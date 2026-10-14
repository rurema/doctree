# extract_rbs.rb: 同梱 rbs gem の core/(+ stdlib/)を BitClust::RbsSigImporter で解析して TSV にする。
# usage: bundle exec ruby tools/method-params/tools/extract_rbs.rb <rbs-src dir> <outdir> <ver>
#   (doctree ディレクトリで BITCLUST_PATH=../bitclust を付けて実行)
#   <rbs-src dir>: <dir>/core・<dir>/stdlib・<dir>/VERSION(measure.sh が作る)
#   <outdir>     : rbs/ ディレクトリ。<outdir>/<ver>.tsv と <outdir>/<ver>.log を書く
# 出力 TSV(ヘッダあり): key idx params(,区切り) arity_min arity_max(無制限は -) block(req|opt|-) type
# 手元の rbs で core が 1 ファイルでも読めなければ exit 2 で終わる(その版は extract_rbs_native.rb を使う)。
require "bitclust/rbs_sig_importer"
require "pathname"
require "tmpdir"
require "fileutils"

src, outdir, ver = ARGV
abort "usage: extract_rbs.rb <rbs-src dir> <outdir> <ver>" unless src && outdir && ver
src = Pathname(src)
outdir = Pathname(outdir)
outdir.mkpath
src_version = (src + "VERSION").read.strip rescue "?"

# 読めないファイルの洗い出し(core・stdlib を 1 ファイルずつ試す)
failed = []
total_files = 0
%w[core stdlib].each do |d|
  Dir.glob((src + d + "**/*.rbs").to_s).sort.each do |f|
    total_files += 1
    begin
      RBS::Parser.parse_signature(RBS::Buffer.new(name: f, content: File.read(f)))
    rescue Exception => e
      failed << "#{f.sub(src.to_s + '/', '')}: #{e.class}: #{e.message.to_s.lines.first.to_s.strip[0, 160]}"
    end
  end
end

log = []
log << "path: bitclust RbsSigImporter (local rbs #{RBS::VERSION})"
log << "source rbs gem: #{src_version}"
# core が読めなければ致命的。stdlib は importer が暗黙に要求する stringio しか読み込まないので参考扱い
core_failed = failed.select { |l| l.start_with?("core/") }
log << "files: #{total_files}, parse failures: core #{core_failed.size}, stdlib #{failed.size - core_failed.size} (stdlib は参考)"
failed.each { |l| log << "  FAILED #{l}" }

sigs = nil
unless core_failed.empty?
  log << "result: not extracted (local parser cannot read this version; use extract_rbs_native.rb)"
  (outdir + "#{ver}.log").write(log.join("\n") + "\n")
  warn log.join("\n")
  exit 2
end

# rbs 3.4.0 以前は stdlib/stringio が無く、core 読み込み時の暗黙の stringio 要求で落ちるので空の代用品を足す
repo = src + "stdlib"
tmp = nil
unless (repo + "stringio").directory?
  tmp = Dir.mktmpdir("rbs-stdlib")
  FileUtils.cp_r((src + "stdlib").children.map(&:to_s), tmp)
  FileUtils.mkdir_p("#{tmp}/stringio/0")
  File.write("#{tmp}/stringio/0/stringio.rbs", "class StringIO\nend\n")
  repo = Pathname(tmp)
  log << "note: stdlib/stringio が無いので空の StringIO を補った"
end
begin
  sigs = BitClust::RbsSigImporter.new(core_root: (src + "core").to_s,
                                      repository_root: repo.to_s).signatures
rescue Exception => e
  log << "result: importer failed: #{e.class}: #{e.message.lines.first.to_s.strip[0, 200]}"
  (outdir + "#{ver}.log").write(log.join("\n") + "\n")
  warn log.join("\n")
  exit 2
end

FileUtils.rm_rf(tmp) if tmp
n_over = 0
File.open(outdir + "#{ver}.tsv", "w") do |f|
  f.puts %w[key idx params arity_min arity_max block type].join("\t")
  sigs.keys.sort.each do |key|
    sigs[key].each_with_index do |o, i|
      n_over += 1
      ar = o["arity"]
      type = o["segments"].map { |_, t| t }.join.gsub(/\s+/, " ")
      f.puts [key, i, (o["params"] || []).join(","),
              ar ? ar[0] : "-", ar ? (ar[1] || "-") : "-",
              o["block"] || "-", type].join("\t")
    end
  end
end
log << "keys: #{sigs.size}, overloads: #{n_over}"
log << "result: ok"
(outdir + "#{ver}.log").write(log.join("\n") + "\n")
puts log.join("\n")
