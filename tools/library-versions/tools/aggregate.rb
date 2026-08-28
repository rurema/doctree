# probe2-<v>.tsv(6 版)を突き合わせ、問題エントリの版マトリクスと分類を出力する
# usage: ruby aggregate.rb <method-check dir>
DIR = ARGV[0]
VERSIONS = %w[3.0 3.1 3.2 3.3 3.4 4.0]

# per version: key -> verdict(ok/no-method/no-class/lib-require-failed/bad-name)
data = {}
VERSIONS.each do |v|
  h = {}
  File.readlines(File.join(DIR, "probe2-#{v}.tsv")).each do |l|
    cols = l.chomp.split("\t")
    next unless cols.size == 5  # autorunner 等の混入行は捨てる
    lib, c, t, n, verdict = cols
    h[[lib, c, t, n]] = verdict
  end
  data[v] = h
end

all_keys = data.values.flat_map(&:keys).uniq

PLATFORM_CLASSES = ["Socket", "Socket::Constants", "Etc"]

rows = []
all_keys.each do |key|
  lib, c, t, n = key
  vs = VERSIONS.map { |v| data[v][key] }  # nil = その版の DB に項目なし(版ゲート済み)
  problems = vs.compact.reject { |x| x == "ok" || x == "lib-require-failed" }
  next if problems.empty?
  measured = vs.compact.reject { |x| x == "lib-require-failed" }
  oks = measured.count("ok")
  bucket =
    if PLATFORM_CLASSES.include?(c) && t == "::"
      "platform-const"
    elsif oks == 0
      "always-ng"
    else
      # 測定できた版の並びで ok / ng の位置関係を見る
      seq = VERSIONS.zip(vs).select { |_, x| x && x != "lib-require-failed" }
      first_ok = seq.index { |_, x| x == "ok" }
      last_ok = seq.rindex { |_, x| x == "ok" }
      ng_before = seq[0...first_ok].any? { |_, x| x != "ok" }
      ng_after = seq[(last_ok + 1)..].to_a.any? { |_, x| x != "ok" }
      ng_middle = seq[first_ok..last_ok].any? { |_, x| x != "ok" }
      if ng_middle then "mixed"
      elsif ng_before && ng_after then "mixed"
      elsif ng_before then "old-only-ng"   # 旧版に無い → since バッジ漏れ候補
      elsif ng_after then "new-only-ng"    # 新版に無い → until バッジ漏れ(API 削除)候補
      else "mixed"
      end
    end
  cells = vs.map { |x| x.nil? ? "-" : { "ok" => "o", "no-method" => "X", "no-class" => "C", "lib-require-failed" => "r", "bad-name" => "B" }.fetch(x, "?") }
  rows << [bucket, lib, c, t, n, cells.join]
end

order = %w[new-only-ng old-only-ng always-ng mixed platform-const]
rows.sort_by! { |r| [order.index(r[0]) || 9, r[1], r[2], r[4]] }
File.open(File.join(DIR, "mismatch-matrix.tsv"), "w") do |f|
  f.puts %w[bucket lib class type name].join("\t") + "\t" + VERSIONS.join("")
  rows.each { |r| f.puts r.join("\t") }
end

# 集計
puts "total problem entries: #{rows.size}"
rows.group_by(&:first).each { |b, rs| puts format("  %-14s %5d", b, rs.size) }
puts "\n== bucket 別 lib 上位:"
order.each do |b|
  top = rows.select { |r| r[0] == b }.group_by { |r| r[1] }.map { |l, rs| [rs.size, l] }.sort.reverse.first(8)
  next if top.empty?
  puts "#{b}: " + top.map { |n2, l| "#{l}(#{n2})" }.join(", ")
end
