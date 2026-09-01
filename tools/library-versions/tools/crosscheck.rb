# crosscheck: rurema-libs.tsv × ruby-stdlib/<ver>.tsv → matrix + findings
require "set"

SP = File.expand_path(__dir__)
BASE = File.expand_path("..", SP)  # データ一式の置き場(tools/ の親= library-versions/)
DOC_VERSIONS = %w[3.0 3.1 3.2 3.3 3.4 4.0 4.1]
RUBY_SRC = { "3.0" => "3.0", "3.1" => "3.1", "3.2" => "3.2", "3.3" => "3.3",
             "3.4" => "3.4", "4.0" => "4.0", "4.1" => "master" }
EN_VERSIONS = %w[3.2 3.3 3.4 4.0 4.1]

# ruby-side 表示名 → ユニットキー(rurema の require パス表記)
ALIAS = {
  "Bundler" => "bundler", "DEBUGGER__" => "debug", "DateTime" => "date",
  "Delegator" => "delegate", "DidYouMean" => "did_you_mean",
  "ErrorHighlight" => "error_highlight", "Gem" => "rubygems",
  "IO#nonblock" => "io/nonblock", "IO#wait" => "io/wait", "IO.console" => "io/console",
  "MakeMakefile" => "mkmf", "MiniTest" => "minitest", "minitest" => "minitest",
  "Net::POP3" => "net/pop", "Observable" => "observer", "OpenStruct" => "ostruct",
  "OpenURI" => "open-uri", "OptionParser" => "optparse",
  "PowerAssert" => "power_assert", "PrettyPrinter" => "prettyprint",
  "RBS" => "rbs", "rbs" => "rbs", "Racc" => "racc", "racc" => "racc",
  "Rinda" => "rinda", "rinda" => "rinda", "StringScanner" => "strscan",
  "TypeProf" => "typeprof", "typeprof" => "typeprof",
  "win32-registry" => "win32/registry",
}
# "IO"(3.0〜3.3 の rdoc 表記)は io/console・io/nonblock・io/wait の総称
MULTI_ALIAS = { "IO" => %w[io/console io/nonblock io/wait] }

# rurema 名 → ユニットの手動対応(自動プレフィックス解決でうまくいかないもの)
RUREMA_UNIT_OVERRIDE = {
  "net/https" => "net/http",       # net-http gem の一部
  "io/console/size" => "io/console",
  "kconv" => "nkf",                # lib/kconv.rb は nkf gem 同梱(ext/nkf/lib)
  "expect" => "pty",               # lib/expect.rb は pty 同梱(ext/pty/lib)
}

# standard_library ドキュメント未記載だがツリー実在を確認済みのもの(raw 一覧・ext/.document で裏取り)
SUPPLEMENT = {
  "continuation" => { kind: "ext", vers: %w[3.0 3.1 3.2 3.3 3.4 4.0 4.1] },
  "fiber"        => { kind: "ext", vers: %w[3.0] },                       # ext/fiber は 3.1 で撤去
  "net/protocol" => { kind: "default-gem", vers: %w[3.0 3.1 3.2 3.3 3.4 4.0 4.1] }, # net-protocol gem(ローカル実測で確認)
  "win32/registry" => { kind: "ext", vers: %w[3.0 3.1 3.2 3.3 3.4 4.0] }, # 4.1 は bundled(win32-registry)側で載る
  "win32/resolv"   => { kind: "ext", vers: %w[3.0 3.1 3.2 3.3 3.4 4.0 4.1] },
  "reline"       => { kind: "default-gem", vers: %w[3.0 3.1] },  # 3.0/3.1 の rdoc に記載漏れ(ツリー実在)
  "error_highlight" => { kind: "default-gem", vers: %w[3.1] },   # 3.1 の rdoc に記載漏れ(v3_1_7 ツリーに lib/error_highlight 実在。記載は 3.2 から)
  "io/nonblock"  => { kind: "default-gem", vers: %w[3.4] },      # 3.4 md に記載漏れ(ローカル実測で default gem)
  "io/wait"      => { kind: "default-gem", vers: %w[3.4] },      # 同上
  "cgi"          => { kind: "lib", vers: %w[4.0 4.1] },          # 4.0 で gem 廃止・escape 系のみ lib/cgi.rb+ext/cgi として残存
}

# --- rurema 名一覧(名寄せの正: gem 名のダッシュを require パスのスラッシュへ寄せる判定に使う) ---
RUREMA_NAMES = File.readlines("#{BASE}/rurema-libs.tsv").drop(1)
                   .map { |l| l.split("\t")[0].downcase }.to_set

def norm(name)
  a = name.downcase.gsub("::", "/").sub(/\.rb\z/, "")
  return a if RUREMA_NAMES.include?(a)
  b = a.gsub("-", "/")
  RUREMA_NAMES.include?(b) ? b : a
end

# --- ruby 側読み込み ---
ruby = {} # doc_ver => { unit => kind }
RUBY_SRC.each do |dv, src|
  units = {}
  File.readlines("#{BASE}/ruby-stdlib/#{src}.tsv").drop(1).each do |l|
    name, kind, source = l.chomp.split("\t")
    keys = MULTI_ALIAS[name] || [ALIAS[name] || norm(name)]
    keys.each do |k|
      if units[k] && units[k] != kind
        # 3.1 の debug: stdlib-doc(default 扱いのまま)と bundled_gems ファイルが矛盾 → 実態(bundled)を優先
        units[k] = kind if source == "bundled_gems-file"
      else
        units[k] ||= kind
      end
    end
  end
  SUPPLEMENT.each { |k, s| units[k] ||= s[:kind] if s[:vers].include?(dv) }
  ruby[dv] = units
end
ruby_unit_keys = ruby.values.flat_map(&:keys).to_set

# --- rurema 側読み込み ---
rurema = File.readlines("#{BASE}/rurema-libs.tsv").drop(1).map do |l|
  name, since, until_, = l.chomp.split("\t", 4)
  { name: name, since: (since.to_s.empty? ? nil : since), until: (until_.to_s.empty? ? nil : until_) }
end

def active?(entry, ver)
  v = Gem::Version.new(ver)
  return false if entry[:since] && Gem::Version.new(entry[:since]) > v
  return false if entry[:until] && Gem::Version.new(entry[:until]) <= v
  true
end

# ユニット割当: override → 完全一致 → プレフィックス縮め → 自分自身
def unit_for(name, keys)
  return RUREMA_UNIT_OVERRIDE[name] if RUREMA_UNIT_OVERRIDE[name]
  n = name.downcase
  return n if keys.include?(n)
  parts = n.split("/")
  (parts.size - 1).downto(1) do |i|
    pre = parts[0, i].join("/")
    return pre if keys.include?(pre)
  end
  n
end

rurema_units = Hash.new { |h, k| h[k] = [] } # unit => [entries]
rurema.each do |e|
  next if e[:name] == "_builtin"
  rurema_units[unit_for(e[:name], ruby_unit_keys)] << e
end

def rurema_active?(entries, ver)
  entries.any? { |e| active?(e, ver) }
end

# --- マトリクス ---
all_units = (ruby_unit_keys + rurema_units.keys).sort
KIND_CODE = { "lib" => "L", "ext" => "E", "default-gem" => "D", "bundled-gem" => "B" }
File.open("#{BASE}/matrix-libs.tsv", "w") do |f|
  f.puts(["unit", *DOC_VERSIONS].join("\t"))
  all_units.each do |u|
    cells = DOC_VERSIONS.map do |v|
      rk = ruby[v][u] ? KIND_CODE[ruby[v][u]] : "."
      ja = rurema_units.key?(u) && rurema_active?(rurema_units[u], v) ? "o" : "."
      rk + ja
    end
    f.puts([u, *cells].join("\t"))
  end
end

# --- findings ---
File.open("#{BASE}/findings.md", "w") do |f|
  f.puts "# ライブラリ単位突き合わせ(自動生成: crosscheck.rb)"
  f.puts
  f.puts "## A. Ruby に存在するが rurema にページがない(版別)"
  DOC_VERSIONS.each do |v|
    miss = ruby[v].keys.reject { |u| rurema_units.key?(u) && rurema_active?(rurema_units[u], v) }.sort
    f.puts "- **#{v}**: " + (miss.empty? ? "(なし)" : miss.map { |u| "#{u}(#{ruby[v][u]})" }.join(", "))
  end
  f.puts
  f.puts "## B. rurema でその版に有効だが Ruby 側に存在しない(until 欠落・撤去漏れ候補)"
  DOC_VERSIONS.each do |v|
    stale = rurema_units.keys.select { |u| rurema_active?(rurema_units[u], v) && !ruby[v].key?(u) }.sort
    f.puts "- **#{v}**: " + (stale.empty? ? "(なし)" : stale.join(", "))
  end
  f.puts
  f.puts "## C. en rdoc との差(en 対象版のみ。en 掲載 = ソースツリー内 = lib/ext/default-gem)"
  EN_VERSIONS.each do |v|
    ja_only = rurema_units.keys.select { |u|
      rurema_active?(rurema_units[u], v) && (!ruby[v].key?(u) || ruby[v][u] == "bundled-gem")
    }.sort
    en_only = ruby[v].select { |u, k| k != "bundled-gem" }.keys
                    .reject { |u| rurema_units.key?(u) && rurema_active?(rurema_units[u], v) }.sort
    f.puts "### #{v}"
    f.puts "- ja のみ(en に版別ページなし): " + (ja_only.empty? ? "(なし)" : ja_only.join(", "))
    f.puts "- en のみ(rurema 未収載): " + (en_only.empty? ? "(なし)" : en_only.join(", "))
  end
end

# --- 検算用: rurema 側でどのユニットにも吸収されず自分自身がユニットになった名前のうち、
#     ruby 側に一度も現れないもの(=要注意リスト) ---
puts "== rurema-only units (ruby 側に全版で不在):"
rurema_units.keys.reject { |u| ruby_unit_keys.include?(u) }.sort.each do |u|
  ents = rurema_units[u]
  vers = DOC_VERSIONS.select { |v| rurema_active?(ents, v) }
  puts "#{u}\tactive:#{vers.empty? ? '(none)' : vers.join(',')}\tfiles:#{ents.size}"
end
puts "== done. matrix-libs.tsv / findings.md written."
