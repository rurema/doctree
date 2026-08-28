# always-ng の二次調査(host 側オーケストレーション)。
#
# mismatch-matrix.tsv の bucket=always-ng 行(yaml/dbm を除く)について、
# ライブラリ単位で triage_worker.rb を子プロセスとして起動し(ObjectSpace は
# プロセス内状態なのでライブラリごとに新しいプロセスが要る)、その生データ
# (JSON Lines)を読んで判定(renamed-class / needs-require / wrong-type /
# not-found / env)を行う。3.4 で not-found だったものだけ 4.0 で再試行する。
#
# usage: ruby triage_script.rb <method-check dir> <doctree root>
#   出力: <dir>/always-ng-triage.tsv

require "json"
require "open3"
require_relative "frontmatter_requires"

DIR = ARGV[0] || "/tmp/claude-1000/-home-debian-rurema/58ba4581-c6ee-4450-bb72-29d0c6d1cc48/scratchpad/method-check"
DOCTREE = ARGV[1] || "/home/debian/rurema/doctree"
RUBY34 = "/home/debian/.local/share/mise/installs/ruby/3.4.8/bin/ruby"
RUBY40 = "/home/debian/.local/share/mise/installs/ruby/4.0.6/bin/ruby"
WORKER = File.join(File.dirname(__FILE__), "triage_worker.rb")

EXCLUDE_LIBS = %w[yaml/dbm]

RSS_EXTRA_SUBS = %w[rss/taxonomy rss/image rss/content rss/trackback rss/syndication rss/dublincore]

# front matter に require:/sublibrary: が無いが、実際にはサブファイルを
# 追加 require しないと定義されないメソッドがあると判明したもの
# (ソース調査で確認: lib/psych/y.rb が Kernel#y を定義する)。
MANUAL_EXTRA_SUBS = {
  "psych" => %w[psych/y],
}

# ---- 1. 入力読み込み ----
rows = []
File.readlines(File.join(DIR, "mismatch-matrix.tsv")).each do |l|
  cols = l.chomp.split("\t")
  next if cols[0] == "bucket" # header
  next unless cols[0] == "always-ng"
  lib = cols[1]
  next if EXCLUDE_LIBS.include?(lib)
  rows << { "lib" => lib, "class" => cols[2], "type" => cols[3], "name" => cols[4] }
end
if ENV["LIBS_FILTER"]
  wanted = ENV["LIBS_FILTER"].split(",")
  rows.select! { |r| wanted.include?(r["lib"]) }
end
STDERR.puts "target rows: #{rows.size}"

by_lib = rows.group_by { |r| r["lib"] }

def extras_for(lib)
  extras = frontmatter_requires(DOCTREE, lib)
  extras += RSS_EXTRA_SUBS if lib == "rss"
  extras += MANUAL_EXTRA_SUBS[lib] if MANUAL_EXTRA_SUBS[lib]
  extras.uniq - [lib]
end

# 子プロセス(ruby バージョンごと)を起動し、JSON Lines を返す。
# 戻り値: [meta_hash, {[class,type,name] => row_hash}]
def run_worker(ruby_bin, lib, extras, targets)
  input = targets.map { |t| [t["class"], t["type"], t["name"]].join("\t") }.join("\n") + "\n"
  out, err, status = Open3.capture3(ruby_bin, WORKER, lib, *extras, stdin_data: input)
  unless status.success?
    STDERR.puts "WARN: worker failed for lib=#{lib} ruby=#{ruby_bin} status=#{status.exitstatus}"
    STDERR.puts err.lines.first(5).join
  end
  meta = nil
  by_key = {}
  out.each_line do |l|
    l = l.strip
    next if l.empty?
    h = JSON.parse(l) rescue next
    if h["_meta"]
      meta = h
    else
      by_key[[h["class"], h["type"], h["name"]]] = h
    end
  end
  [meta, by_key, err]
end

TYPE_TO_FORM = { "#" => "instance", "." => "singleton", ".#" => "singleton", "::" => "const" }

# 1 行分の生データ(worker の JSON)から [resolution, detail] を決める。
# lib 名から想定される Ruby 側の名前空間の頭(例: "rake" -> "Rake",
# "net/http" -> "Net")。kernel_dsl_hits が複数見つかったとき、この頭に
# 一致するものを優先して「特定不能」を避けるためのヒントに使う。
def lib_namespace_guess(lib)
  lib.split("/").first.split(/[_-]/).map { |s| s[0] ? s[0].upcase + s[1..] : s }.join
end

def decide(entry, extras_attempted, lib = nil)
  type = entry["type"]
  full_status = entry["full_status"]
  base_status = entry["base_status"]
  extras_loaded = entry["extras_loaded"] || []

  if full_status == "ok"
    if base_status != "ok"
      detail = "base require のみでは #{base_status} だったが、追加 require (#{extras_loaded.join(', ')}) 適用後は #{entry['class']}##{entry['name']} が #{type} として解決した"
      return ["needs-require:#{extras_loaded.join(',')}", detail]
    else
      return ["not-found", "matrix 上は常に NG のはずだが、この再検証では base require だけで ok 判定になった(要再確認)"]
    end
  end

  if entry.key?("candidates")
    cands = entry["candidates"] || []
    ok_cands = cands.select { |c| c["status"] == "ok" }
    if ok_cands.any?
      sorted = ok_cands.sort_by { |c| [c["name"].include?("::Maker::") ? 1 : 0, c["name"].length] }
      best = sorted.first
      detail = "候補(#{type} で一致): #{ok_cands.map { |c| c['name'] }.join(', ')}"
      detail += " / 追加 require: #{extras_loaded.join(', ')}" unless extras_loaded.empty?
      return ["renamed-class:#{best['name']}", detail]
    end

    mixin_cands = cands.select { |c| c["mixin_hits"] && ((c["mixin_hits"]["instance"] || []).any? || (c["mixin_hits"]["singleton"] || []).any?) }
    if mixin_cands.any?
      best = mixin_cands.first
      via = (best["mixin_hits"]["instance"] + best["mixin_hits"]["singleton"]).uniq.join(", ")
      detail = "#{best['name']} 自体への method_defined? では不在だが、これを include する具象クラス(#{via})では実在(append_features 等の動的注入によるものと推定)"
      return ["renamed-class:#{best['name']}", detail]
    end

    if cands.any?
      names = cands.map { |c| c["name"] }.first(8).join(", ")
      return ["not-found", "類似クラス名(#{names})は見つかったが該当メソッド/定数は無い"]
    end

    return ["not-found", "クラス自体が解決できず、名前が類似するクラスも見つからなかった"]
  else
    forms = entry["orig_forms"] || {}
    type_form = TYPE_TO_FORM[type]
    other_forms = forms.select { |k, v| v && k != type_form }
    if other_forms.any?
      names = other_forms.keys.join(",")
      return ["wrong-type:#{names}", "ドキュメントは #{type}(#{type_form})だが、実際は #{names} として存在する(#{entry['class']})"]
    end

    mh = entry["mixin_hits"]
    if mh && ((mh["instance"] || []).any? || (mh["singleton"] || []).any?)
      via = (mh["instance"] + mh["singleton"]).uniq.join(", ")
      return ["not-found", "クラス自体は存在するが直接の method_defined? では不在(mixin/append_features 由来と推定)。#{entry['class']} を include する具象クラス(#{via})では実際に機能している= ドキュメント自体は妥当な可能性が高い(自動チェックの限界)"]
    end

    kd = entry["kernel_dsl_hits"]
    if kd && kd.any?
      ns = lib ? lib_namespace_guess(lib) : nil
      preferred = ns ? kd.select { |name| name.start_with?("#{ns}::") || name == ns } : []
      if preferred.any?
        return ["renamed-class:#{preferred.first}", "Kernel の関数として文書化されているが、plain require だけでは Kernel/Object に現れない。実体は #{preferred.join(', ')}(自身で定義する private メソッド)。実行文脈(コマンド実行時に self へ extend される等)で初めてトップレベルから呼べる種類のメソッドと推定" + (kd.size > preferred.size ? "(他に無関係な同名メソッドを持つモジュールが#{kd.size - preferred.size}件あるが除外)" : "")]
      elsif kd.size == 1
        return ["renamed-class:#{kd.first}", "Kernel の関数として文書化されているが、plain require だけでは Kernel/Object に現れない。実体は #{kd.first} が自身で定義する private メソッド"]
      else
        return ["not-found", "同名の private メソッドを持つモジュールが#{kd.size}件見つかったが(#{kd.first(5).join(', ')} 等)、一般的な名前で特定不能"]
      end
    end

    near = entry["orig_near_names"] || []
    if near.any?
      return ["not-found", "#{entry['class']} 自身に綴り/構造の近いメソッドが存在(ドキュメントの誤字、またはメソッド名自体の変更(接頭辞付与など)の可能性): #{near.join(', ')}"]
    end

    return ["not-found", "#{entry['class']} は存在するが #{entry['name']} はどの形(instance/singleton/const)でも存在しない"]
  end
end

results = {} # key(lib,class,type,name) => [resolution, detail]
rerun_44 = [] # not-found だった行(4.0 で再試行)
meta34_by_lib = {}
meta40_by_lib = {}

by_lib.each do |lib, targets|
  extras = extras_for(lib)
  STDERR.puts "== #{lib} (#{targets.size} rows, extras=#{extras}) [3.4] =="
  meta, by_key, err = run_worker(RUBY34, lib, extras, targets)
  meta34_by_lib[lib] = meta
  targets.each do |t|
    key = [t["class"], t["type"], t["name"]]
    entry = by_key[key]
    if entry.nil?
      results[[lib, *key]] = ["not-found", "3.4 worker から結果が得られなかった(異常終了の可能性): #{err.to_s.lines.first}"]
      rerun_44 << t.merge("lib" => lib)
      next
    end
    resolution, detail = decide(entry, extras, lib)
    if resolution == "not-found"
      rerun_44 << t.merge("lib" => lib)
    end
    results[[lib, *key]] = [resolution, detail]
  end
end

STDERR.puts "\nnot-found in 3.4, retrying in 4.0: #{rerun_44.size} rows"

rerun_44.group_by { |t| t["lib"] }.each do |lib, targets|
  extras = extras_for(lib)
  STDERR.puts "== #{lib} (#{targets.size} rows) [4.0 retry] =="
  meta, by_key, err = run_worker(RUBY40, lib, extras, targets)
  meta40_by_lib[lib] = meta
  targets.each do |t|
    key = [t["class"], t["type"], t["name"]]
    entry = by_key[key]
    if entry.nil?
      next # 3.4 の not-found のまま
    end
    resolution, detail = decide(entry, extras, lib)
    if resolution != "not-found"
      results[[lib, *key]] = [resolution, "[4.0で確認] #{detail}"]
    else
      old_res, old_detail = results[[lib, *key]]
      results[[lib, *key]] = [old_res, "#{old_detail} / 4.0でも同様に not-found(#{detail})"]
    end
  end
end

# ---- env 判定の上書き ----
# ライブラリ本体が 3.4・4.0 どちらでも一切ロードできない(base require も
# front matter 由来の追加 require も全滅)場合、それはドキュメント上のクラス名/
# メソッド名の問題ではなく「今回使える Ruby (3.4/4.0) では検証不能」という
# 環境要因なので、その lib の全行を env に上書きする。
# (front matter の require: に何か 1 つでも読み込めるものがあれば、それは
#  実質的に機能の一部が生きている可能性が高いので上書きしない= not-found のまま)
by_lib.each_key do |lib|
  m34 = meta34_by_lib[lib]
  next unless m34 && m34["base_ok"] == false && (m34["extras_loaded"] || []).empty?
  m40 = meta40_by_lib[lib]
  next unless m40.nil? || (m40["base_ok"] == false && (m40["extras_loaded"] || []).empty?)
  by_lib[lib].each do |t|
    key = [lib, t["class"], t["type"], t["name"]]
    results[key] = ["env", "ライブラリ #{lib} 自体が 3.4/4.0 のどちらでも require できない(この検証環境で使える Ruby バージョンの範囲では実行時検証が不能。ページ front matter の until/since 指定を要確認)"]
  end
end

# aggregate.rb は Socket/Socket::Constants/Etc の「::」(定数)エントリだけを
# platform-const バケットにしていたが、Etc::Passwd/Etc::Group や
# Socket::Ifaddr のような libc 由来の Struct クラスは「#」(メンバー)側にも
# 同種のプラットフォーム依存(BSD 系にのみ存在するフィールド等)がある。
# 実際にこの Linux 環境で該当クラス自身は解決できるがメンバーだけ無い
# (not-found)ケースを env に格上げする。
PLATFORM_STRUCT_CLASSES = ["Etc::Passwd", "Etc::Group", "Socket::Ifaddr"]
rows.each do |r|
  next unless PLATFORM_STRUCT_CLASSES.include?(r["class"])
  key = [r["lib"], r["class"], r["type"], r["name"]]
  resolution, detail = results[key]
  next unless resolution == "not-found"
  results[key] = ["env", "#{r['class']} は libc 由来の Struct でメンバー構成が OS 依存(例: age/change/comment/expire/quota/uclass は BSD 系のみ、vhid は FreeBSD の CARP 関連フィールド)。このサンドボックス(Linux)には無いだけで、対象 OS では存在しうる。aggregate.rb の PLATFORM_CLASSES(Socket/Etc の `::` 定数)と同種の環境要因。実測: #{r['class']}.members(またはinstance_methods) に #{r['name'].sub(/=\\z/, '')} が含まれない / 元判定: #{detail}"]
end

# ---- 出力 ----
out_path = File.join(DIR, "always-ng-triage.tsv")
File.open(out_path, "w") do |f|
  f.puts %w[lib class type name resolution detail].join("\t")
  rows.each do |r|
    key = [r["lib"], r["class"], r["type"], r["name"]]
    resolution, detail = results[key] || ["not-found", "(内部エラー: 結果未取得)"]
    f.puts [r["lib"], r["class"], r["type"], r["name"], resolution, detail.to_s.gsub(/[\t\n]/, " ")].join("\t")
  end
end
STDERR.puts "wrote #{out_path}"

# ---- 簡易集計(標準エラー) ----
by_resolution = Hash.new(0)
results.each_value { |res, _| by_resolution[res.split(":").first] += 1 }
STDERR.puts "\n== resolution 別件数 =="
by_resolution.sort_by { |_, n| -n }.each { |k, n| STDERR.puts format("  %-14s %4d", k, n) }
