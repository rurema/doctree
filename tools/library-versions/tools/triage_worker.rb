# always-ng 二次調査: 1 ライブラリ分をこのプロセス内で調べ、行ごとの生データを
# JSON Lines で標準出力へ書く(判定ロジックは host 側 triage_script.rb が行う)。
#
# 使い方: ruby triage_worker.rb <lib> <extra1> <extra2> ... < rows.tsv(class\ttype\tname)
#
# 出力: 1 行 1 JSON。{"class":..,"type":..,"name":..,
#   "base_status":..,"full_status":..,"extras_loaded":[..],
#   "orig_forms":{...}|null,"orig_near_names":[...],
#   "candidates":[{"name":..,"forms":{...},"near_names":[...]}...]}
#
# ARGV は test/unit の autorunner 対策で早めに clear する(rake 等が require 時に
# 中身を見ることがあるため、libname を取り出した直後に clear する)。
require "json"
require "stringio"

libname = ARGV[0]
extras = ARGV[1..] || []
ARGV.clear

def safe_require(name)
  require name
  true
rescue Exception # LoadError/StandardError に限らず ScriptError 系も広く捕まえる
  false
end

def capture_stdout
  old = $stdout
  $stdout = StringIO.new
  yield
ensure
  $stdout = old
end

def resolve(path)
  path.split("::").inject(Object) { |mod, name| mod.const_get(name, false) }
rescue NameError, TypeError
  nil
end

# どんな Module/Class でも Object である以上、singleton_class は Kernel の
# clone/dup/freeze/instance_variable_get 等を「自明に」持ってしまう
# (モジュール自身を clone できるという話であって、ドキュメントが言う
# 「このクラスの特異メソッド」とは無関係)。この自明分は singleton の
# 判定材料として使わない(既知の実例: Rake::Cloneable#clone/#dup)。
TRIVIAL_SINGLETON_SYMS = (Module.new.singleton_class.instance_methods(true) +
                          Module.new.singleton_class.private_instance_methods(true) +
                          Class.new.singleton_class.instance_methods(true) +
                          Class.new.singleton_class.private_instance_methods(true)).map(&:to_sym).uniq.freeze

# klass に対する name の「存在形」を調べる。戻り値は
# {instance:, singleton:, const:} の bool ハッシュ。sym 化できなければ nil。
def forms_for(klass, name)
  sym = name.to_sym
  res = {}
  if klass.is_a?(Module)
    res["instance"] = klass.method_defined?(sym) || klass.private_method_defined?(sym)
    sc = klass.singleton_class
    real_singleton = sc.method_defined?(sym) || sc.private_method_defined?(sym)
    res["singleton"] = real_singleton && !TRIVIAL_SINGLETON_SYMS.include?(sym)
    res["const"] = begin
      klass.const_defined?(sym, true)
    rescue NameError
      false
    end
  else
    # クラスページの実体が定数オブジェクト(モジュールでない)なケース
    sc = klass.singleton_class rescue nil
    res["instance"] = false
    res["singleton"] = sc ? (sc.method_defined?(sym) || sc.private_method_defined?(sym)) : false
    res["const"] = false
  end
  res
rescue TypeError, NoMethodError
  nil
end

def status_from_forms(forms, type)
  return "bad-name" if forms.nil?
  matched =
    case type
    when "#" then forms["instance"]
    when ".", ".#" then forms["singleton"] || (type == ".#" && forms["instance"])
    when "::" then forms["const"]
    else false
    end
  matched ? "ok" : "no-method"
end

# 簡易 Levenshtein 距離(短いメソッド名前提なので O(n*m) で十分)
def levenshtein(a, b)
  return b.length if a.empty?
  return a.length if b.empty?
  prev = (0..b.length).to_a
  a.each_char.with_index do |ca, i|
    cur = [i + 1]
    b.each_char.with_index do |cb, j|
      cost = ca == cb ? 0 : 1
      cur << [prev[j + 1] + 1, cur[j] + 1, prev[j] + cost].min
    end
    prev = cur
  end
  prev.last
end

# mod が Module(Class でない = mixin)で、直接 method_defined? では false でも、
# 実際に mod を include している「名前のある」具象クラスでは動的に(主に
# append_features によるメタプログラミングで)メソッドが定義されていることが
# ある(例: RSS::*Model 系)。それを ancestors 経由で確認する。
# 無名クラス(内部実装専用、:nodoc: 等)は「実際に使えない」とみなし対象外とする。
def mixin_hits_for(mod, sym)
  return nil unless mod.is_a?(Module) && !mod.is_a?(Class)
  hits = { "instance" => [], "singleton" => [] }
  ObjectSpace.each_object(Class) do |k|
    included = begin
      k.ancestors.include?(mod)
    rescue StandardError
      false
    end
    next unless included
    kname = (MODULE_NAME.bind(k).call rescue nil)
    next unless kname
    hits["instance"] << kname if k.method_defined?(sym) || k.private_method_defined?(sym)
    sc = k.singleton_class
    hits["singleton"] << kname if sc.method_defined?(sym) || sc.private_method_defined?(sym)
  end
  hits["instance"].uniq!
  hits["singleton"].uniq!
  hits
end

# klass 自身が持つメソッド名の中から name に近い(誤字疑い)ものを探す
def near_names(klass, name, limit: 3)
  return [] unless klass.is_a?(Module)
  base = name.to_s.sub(/[?!=]\z/, "")
  pool = []
  begin
    pool.concat(klass.instance_methods(false).map(&:to_s))
    pool.concat(klass.private_instance_methods(false).map(&:to_s))
    pool.concat(klass.singleton_class.instance_methods(false).map(&:to_s))
    pool.concat(klass.singleton_class.private_instance_methods(false).map(&:to_s))
  rescue StandardError
    return []
  end
  pool.uniq!
  threshold = base.length <= 5 ? 1 : 2
  scored = pool.map { |m| [levenshtein(base, m.sub(/[?!=]\z/, "")), m] }
  near = scored.select { |d, _| d <= threshold && d > 0 }.sort.map(&:last)
  # 編集距離だけでは "lock" -> "mu_lock" のような接頭辞付与(prefix)を
  # 誤字とみなせない(距離が threshold を超える)ので、部分文字列一致も
  # 別途拾う(例: mutex_m の lock/unlock/synchronize/... -> mu_lock 等)。
  if base.length >= 3
    substr = pool.select do |m|
      mb = m.sub(/[?!=]\z/, "")
      mb != base && (mb.include?(base) || base.include?(mb))
    end
    near = (near + substr).uniq
  end
  near.first(limit)
end

rows = []
STDIN.each_line do |l|
  c, t, n = l.chomp.split("\t", 3)
  rows << [c, t, n]
end

base_ok = capture_stdout { safe_require(libname) }
base_status = {}
base_forms = {}
rows.each do |c, t, n|
  k = resolve(c)
  f = k.nil? ? nil : forms_for(k, n)
  base_forms[[c, t, n]] = f
  base_status[[c, t, n]] = k.nil? ? "no-class" : status_from_forms(f, t)
end

extras_loaded = []
capture_stdout do
  extras.each { |ex| extras_loaded << ex if safe_require(ex) }
end

full_status = {}
full_forms = {}
full_klass = {}
rows.each do |c, t, n|
  k = resolve(c)
  full_klass[[c, t, n]] = k
  f = k.nil? ? nil : forms_for(k, n)
  full_forms[[c, t, n]] = f
  full_status[[c, t, n]] = k.nil? ? "no-class" : status_from_forms(f, t)
end

# ObjectSpace 走査(全 require 後の最終状態)。同名クラスの再オープン等で
# 複数回ヒットしても Module オブジェクトとしては 1 つなので重複しない。
MODULE_NAME = Module.instance_method(:name)
all_modules = {}
ObjectSpace.each_object(Module) do |m|
  # m.name を直接呼ぶと REXML::Functions のように特異メソッド name を
  # 独自定義しているモジュールで本来の Module#name を上書きしてしまう
  # (XPath 関数 "name" 実装のため)。unbind した本来のメソッドで取得する。
  n = MODULE_NAME.bind(m).call rescue nil
  all_modules[n] = m if n && !n.empty?
end
module_names = all_modules.keys

puts({ "_meta" => true, "lib" => libname, "base_ok" => base_ok, "extras_attempted" => extras, "extras_loaded" => extras_loaded }.to_json)

# rurema の慣習として、実行コンテキスト依存で「グローバルに見える」DSL 関数
# (mkmf・rake の task/desc 等)は Kernel のメソッドとして文書化されるが、
# 実体は require しただけでは include/extend されない別モジュールにあること
# がある(例: Rake::DSL は rake コマンド実行時に self(main)へ extend される
# もので、plain require では Object にも Kernel にも現れない)。
# 該当メソッド名を「自身で定義している」モジュールを名前限定で全探索する
# (継承分は含めない = 誤検出を避けるため instance_methods(false) のみ)。
def kernel_dsl_search(sym, cap: 40)
  hits = []
  ObjectSpace.each_object(Module) do |m|
    mn = (MODULE_NAME.bind(m).call rescue nil)
    next unless mn
    next if mn == "Kernel" || mn == "Object"
    own = begin
      m.instance_methods(false) + m.private_instance_methods(false)
    rescue StandardError
      []
    end
    hits << mn if own.include?(sym)
    break if hits.size >= cap # 上限だけ設け、多すぎたら host 側で「特定不能」と判断する
  end
  hits
end

rows.each do |c, t, n|
  entry = {
    "class" => c, "type" => t, "name" => n,
    "base_status" => base_status[[c, t, n]],
    "full_status" => full_status[[c, t, n]],
    "extras_loaded" => extras_loaded,
  }
  k = full_klass[[c, t, n]]
  sym = n.to_sym
  if k
    entry["orig_forms"] = full_forms[[c, t, n]]
    if full_status[[c, t, n]] != "ok"
      entry["orig_near_names"] = near_names(k, n)
      # Kernel は事実上すべての Class から include されているので
      # 「これを include している具象クラス」という mixin_hits_for の前提が
      # 成立しない(全クラスがヒットしてしまい、たまたま同名メソッドを持つ
      # 無関係なクラスまで拾ってしまう。実例: OptionParser::Switch#desc)。
      # Kernel は kernel_dsl_search 専用で扱う。
      mh = (c == "Kernel" ? nil : mixin_hits_for(k, sym))
      entry["mixin_hits"] = mh if mh && (mh["instance"].any? || mh["singleton"].any?)
      if c == "Kernel" && t == "#"
        kd = kernel_dsl_search(sym)
        entry["kernel_dsl_hits"] = kd if kd.any?
      end
    end
  else
    entry["orig_forms"] = nil
    last_seg = c.split("::").last
    suffix_matches = module_names.select { |mn| mn != c && mn.split("::").last == last_seg }
    substring_matches = module_names.select { |mn| mn != c && mn != last_seg && !suffix_matches.include?(mn) && last_seg.length >= 4 && mn.include?(last_seg) }
    candidate_names = (suffix_matches + substring_matches).first(10)
    entry["candidates"] = candidate_names.map do |cn|
      cm = all_modules[cn]
      cf = forms_for(cm, n)
      cstatus = status_from_forms(cf, t)
      cand = { "name" => cn, "forms" => cf, "status" => cstatus }
      if cstatus != "ok"
        cmh = mixin_hits_for(cm, sym)
        cand["mixin_hits"] = cmh if cmh && (cmh["instance"].any? || cmh["singleton"].any?)
      end
      cand
    end
  end
  puts entry.to_json
end
$stdout.flush
exit!(0)
