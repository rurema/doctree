# filter_lib.rb: measure_lib.sh の未加工のライブラリ別ダンプを、doctree にエントリのあるメソッドだけに絞り込む。
# usage: ruby tools/method-params/tools/filter_lib.rb <method-params dir> <lib-raw dir> <ver>
#   <lib-raw dir>: measure_lib.sh の <scratch>/lib-raw/<ver>
#   入力: <lib-raw dir>/<符号化した名前>.tsv(ライブラリ名の `/` を `__` にしたもの)・
#         real/<ver>/lib-status.tsv(対象ライブラリの一覧)・db-extract/sigs-*.tsv(全版)
#   出力: real/<ver>/lib.tsv(全行の先頭に lib 列。ライブラリは lib-status.tsv の順)
# ライブラリ L の行として残すのは、L か `L/` で始まるライブラリのいずれかの版のエントリが持つ
# [クラス, 名前](`.new` のエントリは `initialize` も)に当たる P 行。加えて、それらのライブラリの
# エントリのクラスのうち未加工のダンプに P 行が 1 つでもあるものを K 行で出す(no-class の判定用)。
# A 行(定数のパスと Module#name が違うもの)はパスがそれらのエントリのクラスのものだけ残し、
# P 行と K 行は Module#name の側をそのパスでも引く(P 行・K 行のクラス名は Module#name のまま)。
#   <lib>  V  RUBY_VERSION  RUBY_DESCRIPTION
#   <lib>  X  <lib>  require-failed  <error>
#   <lib>  A  <定数のパス>  <Module#name>
#   <lib>  K  <class>
#   <lib>  P  (dump_params.rb の P 行と同じ列)

dir, raw, ver = ARGV
abort "usage: filter_lib.rb <method-params dir> <lib-raw dir> <ver>" unless ver

keys = Hash.new { |h, k| h[k] = {} }    # lib => {[class, name] => true}
classes = Hash.new { |h, k| h[k] = {} } # lib => {class => true}
Dir[File.join(dir, "db-extract", "sigs-*.tsv")].sort.each do |path|
  File.foreach(path).drop(1).each do |l|
    lib, klass, tm, names, = l.split("\t", -1)
    ns = names.split(",")
    ns << "initialize" if tm == "." && ns.include?("new")
    ns.each { |n| keys[lib][[klass, n]] = true }
    classes[lib][klass] = true
  end
end

out = File.open(File.join(dir, "real", ver, "lib.tsv"), "w")
n_files = n_rows = 0
File.foreach(File.join(dir, "real", ver, "lib-status.tsv"), chomp: true) do |st|
  lib, = st.split("\t")
  enc = lib.gsub("/", "__")
  src = File.join(raw, "#{enc}.tsv")
  next unless File.exist?(src)
  related = keys.keys.select { |l| l == lib || l.start_with?("#{lib}/") }
  ks = {}
  cs = {}
  related.each { |l| ks.update(keys[l]); cs.update(classes[l]) }
  head = []
  al = []
  amap = Hash.new { |h, k| h[k] = [] }
  ps = []
  seen = {}
  File.foreach(src, chomp: true) do |l|
    f = l.split("\t", -1)
    case f[0]
    when "V", "X" then head << l
    when "A"
      next unless cs[f[1]]
      al << l
      amap[f[2]] << f[1]
    when "P"
      cls = [f[1]] + amap.fetch(f[1], [])
      seen[f[1]] = true if cls.any? { |c| cs[c] }
      ps << l if cls.any? { |c| ks[[c, f[4]]] }
    end
  end
  (head + al + seen.keys.sort.map { |c| "K\t#{c}" } + ps).each { |l| out.puts "#{lib}\t#{l}" }
  n_files += 1
  n_rows += ps.size
end
out.close
puts "#{ver}: libs=#{n_files} P rows=#{n_rows}"
