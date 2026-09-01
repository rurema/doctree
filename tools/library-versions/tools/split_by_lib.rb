# entries-<v>.tsv(lib\tclass\ttype\tname)をライブラリ別の入力ファイルに分割する
# usage: ruby split_by_lib.rb entries-3.4.tsv outdir
# 出力: outdir/NNN.in(class\ttype\tname)+ outdir/NNN.name(ライブラリ名)
require "fileutils"
src, outdir = ARGV
FileUtils.mkdir_p(outdir)
groups = Hash.new { |h, k| h[k] = [] }
File.readlines(src).each do |l|
  lib, rest = l.chomp.split("\t", 2)
  groups[lib] << rest
end
# require で対話・別挙動になるものは除外(結果には unmeasured として現れる)
SKIP = %w[debug win32ole win32/registry win32/resolv]
i = 0
manifest = []
groups.sort.each do |lib, lines|
  next if SKIP.include?(lib)
  id = format("%03d", i += 1)
  File.write(File.join(outdir, "#{id}.in"), lines.join("\n") + "\n")
  File.write(File.join(outdir, "#{id}.name"), lib)
  manifest << "#{id}\t#{lib}\t#{lines.size}"
end
File.write(File.join(outdir, "manifest.tsv"), manifest.join("\n") + "\n")
puts "#{groups.size} libs, #{i} probed, skipped: #{(groups.keys & SKIP).join(',')}"
