# dump_all.rb: 実 Ruby のモジュール/メソッド一覧をダンプし、doctree エントリの実在もプローブする。
# usage: ruby [--disable-gems] dump_all.rb [--lib LIB] [--probe FILE]
#   --lib LIB   : LIB を require し、require 前後の差分(新規メソッド・新規/変化した A)だけ出力
#   --probe FILE: FILE(class \t typemark \t name)各行の実在を判定して R レコードで出力
# 出力(TSV):
#   V  RUBY_VERSION  RUBY_DESCRIPTION
#   X  <lib>  require-failed  <error>
#   A  <name>  class|module|object  <superclass|->  <ancestors ,区切り>
#   M  <class>  s|i  pub|priv|prot  <name>  <original_name|->  <feature|->
#   R  <class>  <typemark>  <name>  <verdict>   (ok/no-method/no-class/bad-name/lib-require-failed)
# トップレベル def/定数を使わない(自身の汚染防止)。require は他に一切しない。
$VERBOSE = nil
main_obj = self
opts = {}
args = ARGV.dup
while (a = args.shift)
  case a
  when "--lib" then opts[:lib] = args.shift
  when "--probe" then opts[:probe] = args.shift
  end
end
ARGV.clear
out = $stdout
out.sync = false

safe_name = lambda { |m| (n = m.name; n && !n.empty? ? n : nil) rescue nil }

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
      next if seen[v.object_id]
      seen[v.object_id] = true
      queue << v
    end
  end
  mods
}

feature_of = lambda { |file|
  next "-" if file.nil? || file.start_with?("<")
  f = (File.expand_path(file) rescue file)
  lp = $LOAD_PATH.map { |p| (File.expand_path(p.to_s) rescue nil) }.compact.uniq.sort_by { |p| -p.size }
  dir = lp.find { |p| f.start_with?(p + "/") }
  rel = dir ? f[(dir.size + 1)..-1] : f
  rel.sub(/\.(rb|so|bundle|dll)\z/, "")
}

# メソッド列挙: [kind, vis, name, orig, feature]
methods_of = lambda { |mod, label|
  rows = []
  add = lambda { |holder, kind, vis, names|
    names.each do |n|
      um = (holder.instance_method(n) rescue nil)
      next if um && um.owner != holder
      orig = (um && um.original_name.to_s) || "-"
      orig = "-" if orig == n.to_s
      feat = um ? feature_of.call((um.source_location || [nil]).first) : "-"
      rows << [label, kind, vis, n.to_s, orig, feat]
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
object_methods_of = lambda { |obj, label|
  rows = []
  sc = obj.singleton_class
  [["pub", sc.public_instance_methods(false)], ["priv", sc.private_instance_methods(false)], ["prot", sc.protected_instance_methods(false)]].each do |vis, names|
    names.each do |n|
      um = (sc.instance_method(n) rescue nil)
      next if um && um.owner != sc
      orig = (um && um.original_name.to_s) || "-"
      orig = "-" if orig == n.to_s
      feat = um ? feature_of.call((um.source_location || [nil]).first) : "-"
      rows << [label, "s", vis, n.to_s, orig, feat]
    end
  end
  rows
}

snapshot = lambda {
  arecs = {}   # name => [type, super, ancestors]
  mrecs = {}   # "class\tkind\tname" => row
  walk.call.each do |m|
    name = safe_name.call(m)
    next unless name
    next if arecs.key?(name)
    type = m.is_a?(Class) ? "class" : "module"
    sup = m.is_a?(Class) ? (safe_name.call(m.superclass) || "-") : "-"
    anc = m.ancestors.map { |a| safe_name.call(a) }.compact
    arecs[name] = [type, sup, anc.join(",")]
    methods_of.call(m, name).each { |r| mrecs["#{r[0]}\t#{r[1]}\t#{r[3]}"] = r }
  end
  # 特殊オブジェクト
  if defined?(ARGF) && !arecs.key?("ARGF.class")
    k = ARGF.class
    arecs["ARGF.class"] = ["class", safe_name.call(k.superclass) || "-", k.ancestors.map { |a| safe_name.call(a) }.compact.join(",")]
    methods_of.call(k, "ARGF.class").each { |r| mrecs["#{r[0]}\t#{r[1]}\t#{r[3]}"] = r }
  end
  if defined?(ENV)
    arecs["ENV"] = ["object", "-", "-"]
    object_methods_of.call(ENV, "ENV").each { |r| mrecs["#{r[0]}\t#{r[1]}\t#{r[3]}"] = r }
  end
  arecs["main"] = ["object", "-", "-"]
  object_methods_of.call(main_obj, "main").each { |r| mrecs["#{r[0]}\t#{r[1]}\t#{r[3]}"] = r }
  [arecs, mrecs]
}

out.puts ["V", RUBY_VERSION, RUBY_DESCRIPTION].join("\t")
before_a, before_m = nil, nil
if opts[:lib]
  before_a, before_m = snapshot.call
  begin
    require opts[:lib]
  rescue LoadError, StandardError, ScriptError => e
    out.puts ["X", opts[:lib], "require-failed", "#{e.class}: #{e.message.to_s.gsub(/\s+/, ' ')[0, 200]}"].join("\t")
    if opts[:probe]
      File.foreach(opts[:probe]) do |l|
        c, t, n = l.chomp.split("\t", 3)
        out.puts ["R", c, t, n, "lib-require-failed"].join("\t")
      end
    end
    out.flush
    exit!(0)
  end
end
after_a, after_m = snapshot.call
after_a.each do |name, (type, sup, anc)|
  next if before_a && before_a[name] == [type, sup, anc]
  out.puts ["A", name, type, sup, anc].join("\t")
end
after_m.each do |key, r|
  next if before_m && before_m.key?(key)
  out.puts ["M", *r].join("\t")
end

if opts[:probe]
  resolve = lambda do |path|
    begin
      path.split("::").inject(Object) { |mod, name| mod.const_get(name, false) }
    rescue NameError, TypeError
      nil
    end
  end
  cache = {}
  File.foreach(opts[:probe]) do |l|
    c, t, n = l.chomp.split("\t", 3)
    next if n.nil?
    verdict =
      if t == "$"
        gv = n.start_with?("$") ? n : "$#{n}"
        begin
          eval("defined?(#{gv})") ? "ok" : "no-method"
        rescue SyntaxError, StandardError
          "bad-name"
        end
      else
        k = if c == "ARGF.class" then (defined?(ARGF) ? ARGF.class : nil)
            elsif c == "main" then main_obj.singleton_class
            else (cache.key?(c) ? cache[c] : (cache[c] = resolve.call(c)))
            end
        if k.nil?
          "no-class"
        elsif !k.is_a?(Module)
          km = (k.singleton_class rescue nil)
          sym = (n.to_sym rescue nil)
          if km.nil? || sym.nil? then "bad-name"
          elsif km.method_defined?(sym) || km.private_method_defined?(sym) then "ok"
          else "no-method"
          end
        else
          sym = (n.to_sym rescue nil)
          if sym.nil?
            "bad-name"
          else
            case t
            when "#"
              found = k.method_defined?(sym) || k.private_method_defined?(sym)
              found ||= (c == "Kernel" && (Object.method_defined?(sym) || Object.private_method_defined?(sym)))
              found ? "ok" : "no-method"
            when ".", ".#"
              sc = k.singleton_class
              found = sc.method_defined?(sym) || sc.private_method_defined?(sym)
              found ||= (t == ".#" && (k.method_defined?(sym) || k.private_method_defined?(sym)))
              found ||= (c == "Kernel" && (Object.method_defined?(sym) || Object.private_method_defined?(sym)))
              found ? "ok" : "no-method"
            when "::"
              begin
                k.const_defined?(sym, false) ? "ok" : (k.const_defined?(sym) ? "ok-inherited" : "no-method")
              rescue NameError
                "bad-name"
              end
            else
              "bad-name"
            end
          end
        end
      end
    out.puts ["R", c, t, n, verdict].join("\t")
  end
end
out.flush
exit!(0)
