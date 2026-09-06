# compare_mc.rb: 版 V の doctree DB エントリと実測(dump_all.rb 出力)を突き合わせ、過不足を分類する
# usage: ruby compare_mc.rb <method-coverage dir> <ver> <matrix-libs.tsv>
# 出力: <method-coverage dir>/result/<ver>/{excess.tsv,shortage.tsv,summary-by-lib.tsv,summary.txt}
require "set"
require "fileutils"
ROOT, V, MATRIX = ARGV
OUT = File.join(ROOT, "result", V); FileUtils.mkdir_p(OUT)
EX = File.join(ROOT, "db-extract"); REAL = File.join(ROOT, "real", V); PIN = File.join(ROOT, "probe-in", V)
METHOD_MARKS = %w[# . .#]

# ---- ユニット(ライブラリ単位)種別 ----
mcols = nil; unit_kind = {}
File.foreach(MATRIX) do |l|
  f = l.chomp.split("\t")
  if mcols.nil? then mcols = f; next end
  i = mcols.index(V) or abort "no column #{V}"
  unit_kind[f[0]] = f[i][0]  # D/L/E/B/.
end
UNIT_OVERRIDE = { "net/https" => "net/http", "io/console/size" => "io/console", "kconv" => "nkf", "expect" => "pty" }
def unit_for(lib, keys)
  return "_builtin" if lib == "_builtin"
  return UNIT_OVERRIDE[lib] if UNIT_OVERRIDE[lib]
  n = lib.downcase
  return n if keys.include?(n)
  parts = n.split("/")
  (parts.size - 1).downto(1) { |i| pre = parts[0, i].join("/"); return pre if keys.include?(pre) }
  n
end
def scope_of(lib, unit_kind)
  return "builtin" if lib == "_builtin"
  u = unit_for(lib, unit_kind.keys)
  case unit_kind[u]
  when "B" then "bundled"
  when "D", "L", "E" then "stdlib"
  else "stale-lib"   # その版の Ruby に存在しないユニット(rurema 側のみ)
  end
end

# ---- DB 側 ----
db_libs = File.readlines(File.join(EX, "libs-#{V}.tsv")).map { |l| l.split("\t")[0] }.to_set
doc = Hash.new { |h, k| h[k] = {} }        # [class, kind(s/i)] => { name => [typemark, dbkind, lib] }
doc_entries = []                            # [lib, class, t, name, dbkind, vis]
File.foreach(File.join(EX, "entries-#{V}.tsv")) do |l|
  lib, c, t, n, k, vis = l.chomp.split("\t")
  doc_entries << [lib, c, t, n, k, vis]
  next unless METHOD_MARKS.include?(t)
  doc[[c, "i"]][n] = [t, k, lib] if t == "#" || t == ".#"
  doc[[c, "s"]][n] = [t, k, lib] if t == "." || t == ".#"
end
doc_method_count = Hash.new(0)
doc_entries.each { |_lib, c, t, _n, k, _v| doc_method_count[c] += 1 if METHOD_MARKS.include?(t) && %w[defined added redefined].include?(k) }
doc_classes = {}   # name => lib
File.foreach(File.join(EX, "classes-#{V}.tsv")) { |l| f = l.chomp.split("\t"); doc_classes[f[0]] = f[2] }
lib_entry_count = Hash.new(0)
doc_entries.each { |lib, _c, t, _n, k, _v| lib_entry_count[lib] += 1 if METHOD_MARKS.include?(t) && %w[defined added redefined].include?(k) }

# ---- 実測側 ----
manifest = {}  # id => lib
File.foreach(File.join(PIN, "manifest.tsv")) { |l| id, lib, = l.chomp.split("\t"); manifest[id] = lib }
real = {}          # [class, kind, name] => {vis:, orig:, feat:, src:, libs: Set}
anc = Hash.new { |h, k| h[k] = [] }   # class => ancestors(union, order kept)
sup = {}           # class => superclass
ctype = {}         # class => class/module/object
probe = []         # [lib, class, t, name, verdict]
req_failed = {}    # lib => error
dump_size = Hash.new(0)
load_dump = lambda do |path, src, lib|
  File.foreach(path) do |l|
    f = l.chomp.split("\t")
    case f[0]
    when "A"
      _, name, type, s, a = f
      ctype[name] ||= type
      sup[name] ||= s unless s == "-"
      (a || "").split(",").each { |x| anc[name] << x unless anc[name].include?(x) }
    when "M"
      _, c, k, vis, n, orig, feat = f
      key = [c, k, n]
      feat = "-" if feat.start_with?("/") || feat.include?("(eval)")
      r = (real[key] ||= { vis: vis, orig: orig, feat: feat, src: src, libs: Set.new })
      r[:libs] << lib if lib
      feat = "-" if feat.start_with?("/") || feat.include?("(eval)")
      r[:feat] = feat if r[:feat] == "-" && feat != "-"
      dump_size[lib] += 1 if lib
    when "R"
      probe << [lib, f[1], f[2], f[3], f[4]]
    when "X"
      req_failed[f[1]] = f[3]
    end
  end
end
load_dump.call(File.join(REAL, "builtin.tsv"), "builtin", "_builtin")
load_dump.call(File.join(REAL, "base.tsv"), "base", nil)
Dir.glob(File.join(REAL, "libs", "*.tsv")).sort.each do |p|
  id = File.basename(p, ".tsv"); load_dump.call(p, "lib", manifest[id])
end
measured_libs = manifest.values.to_set
desc = Hash.new { |h, k| h[k] = [] }   # module => classes whose ancestors include it
anc.each { |c, as| as.each { |a| desc[a] << c unless a == c } }

# ---- 実測メソッドのライブラリ帰属 ----
class_feat_majority = Hash.new { |h, c| h[c] = begin
  fs = real.select { |(cc, _k, _n), r| cc == c && r[:feat] != "-" }.map { |_key, r| r[:feat] }
  fs.empty? ? nil : fs.tally.max_by { |_f, cnt| cnt }[0]
end }
feat_to_lib = lambda do |feat|
  return [:vendored, feat] if feat =~ %r{\A(rubygems|bundler)/vendor/}
  return [:internal, feat] if feat.start_with?("ruby_vm/", "rubygems/vendored_")
  parts = feat.split("/")
  parts.size.downto(1) { |i| pre = parts[0, i].join("/"); return [:lib, pre] if db_libs.include?(pre) }
  return [:lib, "rubygems"] if feat.start_with?("rubygems/")
  return [:lib, "bundler"] if feat.start_with?("bundler/")
  u = unit_for(feat, unit_kind.keys)
  return [:unit, u] if unit_kind[u] && unit_kind[u] != "."
  [:undoc_lib, feat]
end
attribute = lambda do |key, r|
  c = key[0]
  # 1. クラスが _builtin 以外のライブラリで文書化されていればそのライブラリ(forwardable 等で生成されたメソッドの誤帰属を防ぐ)
  return [doc_classes[c], :lib] if doc_classes[c] && doc_classes[c] != "_builtin"
  return ["_builtin", :lib] if r[:src] == "builtin"
  # 2. 組み込みクラスへの追加メソッドは自身の feature、未文書クラスはクラス内の多数派 feature → 自身の feature
  feat = (doc_classes[c] == "_builtin") ? r[:feat] : class_feat_majority[c]
  feat = r[:feat] if feat.nil? || feat == "-"
  if feat && feat != "-"
    kind, x = feat_to_lib.call(feat)
    return [x, kind]
  end
  cand = r[:libs].reject { |l| l == "_builtin" }
  return [cand.min_by { |l| dump_size[l] }, :lib] unless cand.empty?
  return ["rubygems", :lib] if r[:src] == "base" && c.start_with?("Gem")
  [doc_classes[c] || "?", :lib]
end

# ---- 過剰(DB にあるが実測に無い) ----
skipped_libs = %w[debug win32ole win32/registry win32/resolv]
excess = []   # lib, scope, class, t, name, dbkind, verdict
probed = {}
probe.each { |lib, c, t, n, v| probed[[lib, c, t, n]] = v }
KNOWN_OK = { ["Kernel", ".#", "chomp"] => "-n/-p 時のみ", ["Kernel", ".#", "chop"] => "-n/-p 時のみ", ["Kernel", ".#", "gsub"] => "-n/-p 時のみ", ["Kernel", ".#", "sub"] => "-n/-p 時のみ" }
PLATFORM_CONST_CLASSES = %w[Socket Socket::Constants Etc Process File::Constants Fcntl Syslog Syslog::Constants IO::WaitReadable Errno]
doc_entries.each do |lib, c, t, n, k, _vis|
  next unless METHOD_MARKS.include?(t) || t == "::"
  next if c == "Errno::EXXX"
  next if KNOWN_OK[[c, t, n]]
  next if t == "::" && PLATFORM_CONST_CLASSES.include?(c)
  v = probed[[lib, c, t, n]]
  v = "unmeasured(skipped-lib)" if v.nil? && skipped_libs.include?(lib)
  v ||= "unmeasured(no-probe)"
  cat =
    if k == "nomethod" || k == "undefined"
      v == "ok" ? "NOMETHOD_BUT_EXISTS" : (v.start_with?("no-") ? "ok" : v)
    else
      case v
      when "ok", "ok-inherited" then "ok"
      when "no-method" then "EXCESS(no-method)"
      when "no-class" then "EXCESS(no-class)"
      when "bad-name" then "EXCESS(bad-name)"
      when "lib-require-failed" then "unmeasured(require-failed)"
      else v
      end
    end
  next if cat == "ok"
  excess << [lib, scope_of(lib, unit_kind), c, t, n, k, cat]
end

# ---- 不足(実測にあるが DB に無い) ----
documented = lambda do |c, k, n|
  e = doc[[c, k]][n]
  return e if e
  if c == "Kernel" then (e = doc[["Object", k]][n]) and return e end
  if c == "Object" then (e = doc[["Kernel", k]][n]) and return e end
  nil
end
shortage = []  # lib, scope, class, kind, vis, name, orig, feat, category, note
real.each do |key, r|
  c, k, n = key
  lib, akind = attribute.call(key, r)
  scope = case akind
          when :vendored then "vendored"
          when :internal then "internal"
          when :undoc_lib then "undoc-lib"
          when :unit then (unit_kind[lib] == "B" ? "bundled" : "stdlib") + "(no-page)"
          else scope_of(lib, unit_kind)
          end
  scope += "(no-method-docs)" if %w[stdlib bundled].include?(scope) && lib_entry_count[lib] == 0
  cat = nil; note = "-"
  if (e = documented.call(c, k, n))
    cat = (e[1] == "nomethod" || e[1] == "undefined") ? "NOMETHOD_CONFLICT" : nil
    next if cat.nil?
  elsif k == "i" && n == "initialize" && (e = documented.call(c, "s", "new"))
    next
  elsif k == "i" && n == "initialize" && (a = ([c] + anc[c]).find { |x| documented.call(x, "s", "new") })
    cat = "DOC_ON_ANCESTOR"; note = "#{a}.new"
  elsif r[:orig] != "-" && documented.call(c, k, r[:orig])
    cat = "ALIAS_OF_DOC"; note = r[:orig]
  elsif k == "i" && (a = anc[c].drop(1).find { |x| documented.call(x, "i", n) })
    cat = "DOC_ON_ANCESTOR"; note = a
  elsif k == "s" && (a = (s = c; chain = []; while (s = sup[s]); chain << s; end; chain).find { |x| documented.call(x, "s", n) })
    cat = "DOC_ON_ANCESTOR"; note = a
  elsif k == "s" && ctype[c] == "module" && (a = anc[c].drop(1).find { |x| documented.call(x, "s", n) })
    cat = "DOC_ON_ANCESTOR"; note = "#{a}(module_function 複製)"
  elsif k == "i" && (d = desc[c].find { |x| documented.call(x, "i", n) })
    cat = "DOC_ON_DESCENDANT"; note = d
  elsif k == "i" && r[:vis] == "priv" && n == "initialize"
    cat = "UNDOC_PRIV"; note = "initialize(new 未記載)"
  elsif r[:vis] == "priv"
    cat = "UNDOC_PRIV"
  elsif n.start_with?("_")
    cat = "UNDOC_UNDERSCORE"
  else
    cat = doc_classes.key?(c) ? (doc_method_count[c] > 0 ? "UNDOC" : "UNDOC(class-stub)") : "UNDOC(class-undoc)"
  end
  shortage << [lib, scope, c, k, r[:vis], n, r[:orig], r[:feat], cat, note]
end

# ---- 出力 ----
File.open(File.join(OUT, "real-keys.tsv"), "w") { |f| real.each { |(c, k, n), r| f.puts [c, k, n, r[:vis]].join("\t") } }
File.open(File.join(OUT, "excess.tsv"), "w") { |f| f.puts %w[lib scope class typemark name dbkind category].join("\t"); excess.sort.each { |r| f.puts r.join("\t") } }
File.open(File.join(OUT, "shortage.tsv"), "w") { |f| f.puts %w[lib scope class kind vis name orig feature category note].join("\t"); shortage.sort.each { |r| f.puts r.join("\t") } }
# ライブラリ別サマリ
libs_all = (db_libs.to_a | shortage.map { |r| r[0] }).sort
File.open(File.join(OUT, "summary-by-lib.tsv"), "w") do |f|
  f.puts %w[lib scope unit_kind doc_methods measured excess_method excess_const undoc undoc_class_stub undoc_class_undoc undoc_priv alias_of_doc doc_on_ancestor doc_on_descendant nomethod_conflict].join("\t")
  libs_all.each do |lib|
    ex = excess.select { |r| r[0] == lib }
    sh = shortage.select { |r| r[0] == lib }
    scope = sh.first ? sh.first[1] : scope_of(lib, unit_kind)
    measured = if lib == "_builtin" then "yes" elsif req_failed[lib] then "require-failed" elsif skipped_libs.include?(lib) then "skipped" elsif measured_libs.include?(lib) then "yes" else "-" end
    f.puts [lib, scope, unit_kind[unit_for(lib, unit_kind.keys)] || (lib == "_builtin" ? "core" : "."), lib_entry_count[lib], measured,
            ex.count { |r| METHOD_MARKS.include?(r[3]) && r[6].start_with?("EXCESS") },
            ex.count { |r| r[3] == "::" && r[6].start_with?("EXCESS") },
            sh.count { |r| r[8] == "UNDOC" }, sh.count { |r| r[8] == "UNDOC(class-stub)" }, sh.count { |r| r[8] == "UNDOC(class-undoc)" }, sh.count { |r| r[8] == "UNDOC_PRIV" } + sh.count { |r| r[8] == "UNDOC_UNDERSCORE" },
            sh.count { |r| r[8] == "ALIAS_OF_DOC" }, sh.count { |r| r[8] == "DOC_ON_ANCESTOR" }, sh.count { |r| r[8] == "DOC_ON_DESCENDANT" },
            sh.count { |r| r[8] == "NOMETHOD_CONFLICT" } + ex.count { |r| r[6] == "NOMETHOD_BUT_EXISTS" }].join("\t")
  end
end
File.open(File.join(OUT, "summary.txt"), "w") do |f|
  f.puts "== #{V}  ruby: #{File.read(File.join(REAL, 'ruby-v.txt')).strip rescue '?'}"
  f.puts "DB method entries: #{doc_entries.count { |r| METHOD_MARKS.include?(r[2]) }}  (libs #{db_libs.size})  real methods: #{real.size}"
  f.puts "require-failed libs (#{req_failed.size}): #{req_failed.keys.sort.join(' ')}"
  %w[builtin stdlib bundled stale-lib].each do |sc|
    f.puts "-- scope #{sc}"
    exm = excess.select { |r| r[1] == sc && METHOD_MARKS.include?(r[3]) }
    f.puts "  excess methods: #{exm.count { |r| r[6].start_with?('EXCESS') }}  (#{exm.map { |r| r[6] }.tally.sort.map { |k, v| "#{k}=#{v}" }.join(', ')})"
    exc = excess.select { |r| r[1] == sc && r[3] == "::" }
    f.puts "  excess consts: #{exc.count { |r| r[6].start_with?('EXCESS') }}"
    sh = shortage.select { |r| r[1] == sc }
    f.puts "  shortage: " + sh.map { |r| r[8] }.tally.sort.map { |k, v| "#{k}=#{v}" }.join(", ")
  end
  %w[vendored internal undoc-lib].each do |sc|
    sh = shortage.select { |r| r[1] == sc }
    f.puts "-- #{sc}: #{sh.size} real methods (#{sh.map { |r| r[0] }.tally.sort_by { |_k, v| -v }.first(8).map { |k, v| "#{k}=#{v}" }.join(', ')})"
  end
end
puts File.read(File.join(OUT, "summary.txt"))
