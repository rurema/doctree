# dump_params.rb: 実 Ruby の全モジュールのメソッドについて arity・parameters・定義元をダンプする。
# usage: ruby --disable-gems dump_params.rb [--pre PRE] [--lib LIB]
#   --lib LIB: LIB を require し、require 前後の差分(新規メソッド・内容が変わったメソッド)だけ出力
#   --pre PRE: 前後差分を取る前に PRE を require する(単体では require できないサブライブラリ向け)
# 出力(TSV):
#   V  RUBY_VERSION  RUBY_DESCRIPTION
#   X  <lib>  require-failed  <error>   (--pre の失敗は <lib> が `pre:PRE`)
#   P  <class>  s|i  pub|prot|priv  <name>  <arity>  <parameters>  <owner>  <source>
#     parameters: Method#parameters を `type[:name]` の空白区切りにしたもの(例 `req:fmt key:buffer`・`rest`・`nokey`)。無ければ `-`
#     owner     : UnboundMethod#owner の名前(特異クラスは `#<Class:Foo>` の形)
#     source    : C 実装なら `C`、`<internal:...>` はそのまま、それ以外は $LOAD_PATH からの相対(拡張子なし)
#   A  <定数のパス>  <Module#name>   (--lib のときだけ。require 後に現れた、パスと名前が違う定数)
# トップレベル def/定数を使わない(自身の汚染防止)。require は --pre・--lib 以外に一切しない。
$VERBOSE = nil
opts = {}
args = ARGV.dup
while (a = args.shift)
  case a
  when "--lib" then opts[:lib] = args.shift
  when "--pre" then opts[:pre] = args.shift
  end
end
ARGV.clear
out = $stdout
out.sync = false

safe_name = lambda { |m| (n = m.name; n && !n.empty? ? n : nil) rescue nil }

aliases = {} # 定数のパス => Module#name(パスと名前が違うもの)
walk = lambda {
  seen = {}
  mods = []
  queue = [Object]
  seen[Object.object_id] = true
  until queue.empty?
    m = queue.shift
    mods << m
    consts = (m.constants(false) rescue [])
    consts.each do |c|
      v = begin
        m.const_get(c, false)
      rescue Exception
        next
      end
      next unless v.is_a?(Module)
      path = m.equal?(Object) ? c.to_s : "#{safe_name.call(m)}::#{c}"
      vn = safe_name.call(v)
      aliases[path] = vn if vn && vn != path
      next if seen[v.object_id]
      seen[v.object_id] = true
      queue << v
    end
  end
  mods
}

load_path = lambda {
  $LOAD_PATH.map { |p| (File.expand_path(p.to_s) rescue nil) }.compact.uniq.sort_by { |p| -p.size }
}

source_of = lambda { |file, lp|
  next "C" if file.nil?
  next file if file.start_with?("<")
  f = (File.expand_path(file) rescue file)
  dir = lp.find { |p| f.start_with?(p + "/") }
  rel = dir ? f[(dir.size + 1)..-1] : f
  rel.sub(/\.(rb|so|bundle|dll)\z/, "")
}

params_of = lambda { |um|
  ps = um.parameters
  next "-" if ps.empty?
  ps.map { |t, n| n ? "#{t}:#{n}" : t.to_s }.join(" ")
}

owner_name = lambda { |o| (safe_name.call(o) || o.inspect).to_s.gsub(/\s+/, " ") }

# 1 モジュール分の行: key => row
rows_of = lambda { |mod, label, lp|
  rows = {}
  add = lambda { |holder, kind, vis, names|
    names.each do |n|
      um = (holder.instance_method(n) rescue nil)
      next if um.nil? || um.owner != holder
      ar = (um.arity rescue "?")
      ps = (params_of.call(um) rescue "?")
      src = (source_of.call((um.source_location || [nil]).first, lp) rescue "?")
      rows["#{label}\t#{kind}\t#{n}"] = ["P", label, kind, vis, n.to_s, ar.to_s, ps, owner_name.call(holder), src]
    end
  }
  sc = mod.singleton_class
  add.call(sc, "s", "pub", sc.public_instance_methods(false))
  add.call(sc, "s", "priv", sc.private_instance_methods(false))
  add.call(sc, "s", "prot", sc.protected_instance_methods(false))
  add.call(mod, "i", "pub", mod.public_instance_methods(false))
  add.call(mod, "i", "priv", mod.private_instance_methods(false))
  add.call(mod, "i", "prot", mod.protected_instance_methods(false))
  rows
}

snapshot = lambda {
  lp = load_path.call
  recs = {}
  seen = {}
  walk.call.each do |m|
    name = safe_name.call(m)
    next unless name
    next if seen[name]
    seen[name] = true
    recs.update(rows_of.call(m, name, lp))
  end
  recs
}

out.puts ["V", RUBY_VERSION, RUBY_DESCRIPTION].join("\t")
before = nil
if opts[:pre]
  begin
    require opts[:pre]
  rescue LoadError, StandardError, ScriptError => e
    out.puts ["X", "pre:#{opts[:pre]}", "require-failed", "#{e.class}: #{e.message.to_s.gsub(/\s+/, ' ')[0, 200]}"].join("\t")
    out.flush
    exit!(0)
  end
end
if opts[:lib]
  before = snapshot.call
  begin
    require opts[:lib]
  rescue LoadError, StandardError, ScriptError => e
    out.puts ["X", opts[:lib], "require-failed", "#{e.class}: #{e.message.to_s.gsub(/\s+/, ' ')[0, 200]}"].join("\t")
    out.flush
    exit!(0)
  end
end
before_aliases = aliases.dup
after = snapshot.call
if opts[:lib]
  aliases.sort.each { |path, n| out.puts ["A", path, n].join("\t") unless before_aliases[path] == n }
end
lines = []
after.each do |key, r|
  next if before && before[key] == r
  lines << r.join("\t")
end
lines.sort.each { |l| out.puts l }
out.flush
exit!(0)
