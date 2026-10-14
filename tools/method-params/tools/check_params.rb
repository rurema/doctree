# シグネチャの引数名と本文の `- **param**` 行の名前の集合を比較する(doctree#3589 の check_params)
# usage: ruby tools/method-params/tools/check_params.rb <method-params dir> <ver>
#   入力: db-extract/params-<ver>.tsv
#   出力: result/<ver>/check-params.tsv と result/<ver>/check-params-summary.txt(上書き)
require "fileutils"

dir, ver = ARGV
abort "usage: check_params.rb <method-params dir> <ver>" unless ver
out_dir = File.join(dir, "result", ver)
FileUtils.mkdir_p(out_dir)

# 名前の正規化: 先頭の * ** & と末尾の : を除き、self と空文字は捨てる
norm = lambda do |s|
  s.to_s.split(",").map { |n| n.strip.sub(/\A(?:\*\*|\*|&)/, "").sub(/:\z/, "") }
   .reject { |n| n.empty? || n == "self" }.uniq
end

total = with_param = mismatched = args_no_param = 0
rows = []
lines = File.readlines(File.join(dir, "db-extract", "params-#{ver}.tsv"), chomp: true)
lines.shift
lines.each do |l|
  lib, klass, tm, names, loc, sig_s, body_s, n = l.split("\t", -1)
  total += 1
  sig = norm.call(sig_s)
  body = norm.call(body_s)
  if n.to_i.zero?
    args_no_param += 1 unless sig.empty?
    next
  end
  with_param += 1
  next if sig.sort == body.sort
  mismatched += 1
  rows << [loc, klass, tm, names, (sig - body).sort.join(","), (body - sig).sort.join(",")]
end

File.open(File.join(out_dir, "check-params.tsv"), "w") do |f|
  f.puts %w[loc class typemark names only_in_sig only_in_body].join("\t")
  rows.each { |r| f.puts r.join("\t") }
end
File.open(File.join(out_dir, "check-params-summary.txt"), "w") do |f|
  f.puts "#{ver}: entries=#{total} with_param_lines=#{with_param} mismatched=#{mismatched} args_but_no_param_lines=#{args_no_param}"
end
