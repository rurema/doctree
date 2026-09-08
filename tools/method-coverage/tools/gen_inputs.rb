# entries-<v>.tsv と libs-<v>.tsv から、版ごとのプローブ入力(NNN.in/NNN.name)と require 対象一覧を作る
# usage: ruby gen_inputs.rb <db-extract dir> <probe-in dir> <ver>
require "fileutils"
src, root, v = ARGV
out = File.join(root, v)
FileUtils.rm_rf(out); FileUtils.mkdir_p(out)
SKIP = %w[debug win32ole win32/registry win32/resolv]   # 対話開始・Windows 専用
groups = Hash.new { |h, k| h[k] = [] }
File.foreach(File.join(src, "entries-#{v}.tsv")) do |l|
  lib, klass, t, name, = l.chomp.split("\t")
  next unless %w[# . .# $ ::].include?(t)
  groups[lib] << [klass, t, name].join("\t")
end
libs = File.readlines(File.join(src, "libs-#{v}.tsv")).map { |l| l.split("\t")[0] }
i = 0
manifest = []
(libs | groups.keys).sort.each do |lib|
  next if SKIP.include?(lib)
  id = format("%03d", i += 1)
  File.write(File.join(out, "#{id}.in"), groups[lib].map { |x| x + "\n" }.join)
  File.write(File.join(out, "#{id}.name"), lib)
  manifest << [id, lib, groups[lib].size].join("\t")
end
File.write(File.join(out, "manifest.tsv"), manifest.map { |x| x + "\n" }.join)
puts "#{v}: #{i} libs (#{groups.size} with entries)"
