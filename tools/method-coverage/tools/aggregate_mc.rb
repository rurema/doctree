# aggregate_mc.rb: 版ごとの result/<v>/{excess,shortage,real-keys}.tsv と db-extract/entries-<v>.tsv を横断し、
# 過剰・不足の各キーがどの版で問題かのマトリクスと、パターン分類(全版/新版のみ/旧版のみ/混在)を出力する
# usage: ruby aggregate_mc.rb <method-coverage dir> <ver ...>
require "set"
ROOT = ARGV.shift; VERSIONS = ARGV
OUT = File.join(ROOT, "result"); MARKS = %w[# . .#]
def pattern(cells)
  present = cells.reject { |c| c == "-" || c == "?" }
  return "unmeasured" if present.empty?
  xs = present.map { |c| c == "X" }
  return "all" if xs.all?
  return "none" if xs.none?
  first_x = xs.index(true); last_x = xs.rindex(true)
  if xs[first_x..last_x].all? then (first_x == 0 ? "old-only" : (last_x == xs.size - 1 ? "new-only" : "middle"))
  else "mixed" end
end
# ---- 過剰 ----
ex = Hash.new { |h, k| h[k] = {} }   # key => { v => status }
exinfo = {}
VERSIONS.each do |v|
  in_db = Set.new
  File.foreach(File.join(ROOT, "db-extract", "entries-#{v}.tsv")) { |l| lib, c, t, n, = l.chomp.split("\t"); in_db << [lib, c, t, n] if MARKS.include?(t) }
  st = {}
  File.foreach(File.join(OUT, v, "excess.tsv")).drop(1).each do |l|
    lib, scope, c, t, n, dbkind, cat = l.chomp.split("\t")
    next unless MARKS.include?(t)
    key = [lib, c, t, n]
    st[key] = cat.start_with?("EXCESS") ? "X" : (cat.start_with?("unmeasured") ? "?" : "o")
    exinfo[key] = [scope, cat] if cat.start_with?("EXCESS") || !exinfo.key?(key)
  end
  in_db.each { |key| ex[key][v] = st[key] || "o" if st.key?(key) || ex.key?(key) }
  # 問題キーだけ追跡する(全 DB エントリは載せない): 後続の版でも in_db なら o を埋める
  ex.each_key { |key| ex[key][v] ||= (in_db.include?(key) ? "o" : "-") }
end
# 過去の版で o だったものの埋め戻し
VERSIONS.each do |v|
  in_db = Set.new
  File.foreach(File.join(ROOT, "db-extract", "entries-#{v}.tsv")) { |l| lib, c, t, n, = l.chomp.split("\t"); in_db << [lib, c, t, n] if MARKS.include?(t) }
  ex.each_key { |key| ex[key][v] ||= (in_db.include?(key) ? "o" : "-") }
end
File.open(File.join(OUT, "matrix-excess.tsv"), "w") do |f|
  f.puts (%w[lib scope class typemark name category] + VERSIONS + %w[pattern first_present]).join("\t")
  ex.sort.each do |key, st|
    next unless st.values.include?("X")
    cells = VERSIONS.map { |v| st[v] || "-" }
    scope, cat = exinfo[key]
    fp = VERSIONS[cells.index { |c| c != "-" } || 0]
    f.puts ([key[0], scope, key[1], key[2], key[3], cat.to_s.sub(/\AEXCESS\((.*)\)/, '\1')] + cells + [pattern(cells), fp]).join("\t")
  end
end
# ---- 不足 ----
sh = Hash.new { |h, k| h[k] = {} }; shinfo = {}
SH_CATS = %w[UNDOC UNDOC(class-stub) UNDOC(class-undoc) NOMETHOD_CONFLICT]
VERSIONS.each do |v|
  File.foreach(File.join(OUT, v, "shortage.tsv")).drop(1).each do |l|
    lib, scope, c, k, vis, n, orig, feat, cat, note = l.chomp.split("\t")
    next unless SH_CATS.include?(cat)
    next if vis == "priv"
    key = [c, k, n]
    sh[key][v] = "X"
    shinfo[key] = [lib, scope, vis, cat, feat]
  end
end
VERSIONS.each do |v|
  present = Set.new
  File.foreach(File.join(OUT, v, "real-keys.tsv")) { |l| c, k, n, = l.chomp.split("\t"); present << [c, k, n] }
  sh.each_key { |key| sh[key][v] ||= (present.include?(key) ? "o" : "-") }
end
File.open(File.join(OUT, "matrix-shortage.tsv"), "w") do |f|
  f.puts (%w[lib scope class kind name vis category feature] + VERSIONS + %w[pattern first_present]).join("\t")
  sh.sort.each do |key, st|
    cells = VERSIONS.map { |v| st[v] || "-" }
    lib, scope, vis, cat, feat = shinfo[key]
    fp = VERSIONS[cells.index { |c| c != "-" } || 0]
    f.puts ([lib, scope, key[0], key[1], key[2], vis, cat, feat] + cells + [pattern(cells), fp]).join("\t")
  end
end
# ---- サマリ ----
puts "== 過剰(DB にあるが実測に無い・メソッドのみ): キー数 #{ex.count { |_k, st| st.values.include?('X') }}"
rows = ex.select { |_k, st| st.values.include?("X") }.map { |key, st| [exinfo[key][0], pattern(VERSIONS.map { |v| st[v] || "-" })] }
rows.map { |sc, _| sc }.uniq.sort.each { |sc| puts "  #{sc}: " + rows.select { |s, _| s == sc }.map { |_, p| p }.tally.sort.map { |p, c| "#{p}=#{c}" }.join(", ") }
puts "== 不足(実測にあるが DB に無い・public/protected・UNDOC 系): キー数 #{sh.size}"
rows = sh.map { |key, st| [shinfo[key][1], shinfo[key][3], pattern(VERSIONS.map { |v| st[v] || "-" })] }
rows.map { |sc, cat, _| [sc, cat] }.uniq.sort.each { |sc, cat| puts "  #{sc} #{cat}: " + rows.select { |s, c, _| s == sc && c == cat }.map { |_, _, p| p }.tally.sort.map { |p, c| "#{p}=#{c}" }.join(", ") }
puts "== 不足(UNDOC・pattern=all)の初出版別(= その版で増えたのに未収録)"
sh.each_with_object(Hash.new { |h, k| h[k] = Hash.new(0) }) { |(key, st), acc|
  cells = VERSIONS.map { |v| st[v] || "-" }
  next unless pattern(cells) == "all"
  fp = VERSIONS[cells.index { |c| c != "-" }]
  acc[[shinfo[key][1], shinfo[key][3]]][fp] += 1
}.sort.each { |(sc, cat), h| puts "  #{sc} #{cat}: " + VERSIONS.map { |v| "#{v}=#{h[v]}" }.join(", ") }
