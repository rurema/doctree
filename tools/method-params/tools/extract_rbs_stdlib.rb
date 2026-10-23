# extract_rbs_stdlib.rb: 同梱 rbs gem の stdlib/ をライブラリごとに解析して TSV にする。
# usage: bundle exec ruby tools/method-params/tools/extract_rbs_stdlib.rb <rbs-src dir> <outdir> <ver>
#   (doctree ディレクトリで BITCLUST_PATH=../bitclust を付けて実行)
#   <rbs-src dir>: <dir>/stdlib・<dir>/VERSION(measure_lib.sh が作る)
#   <outdir>     : rbs/ ディレクトリ。<outdir>/<ver>-stdlib.tsv と <outdir>/<ver>-stdlib.log を書く
# 出力 TSV(ヘッダあり): lib key idx params(,区切り) arity_min arity_max(無制限は -) block(req|opt|-) type
#   lib は stdlib/ 直下のディレクトリ名(rbs のライブラリ名。例 `net-http`)
# ファイルは 1 つずつ構文解析し、読めないファイルは飛ばして log に残す。名前解決は入れ子の
# class/module の名前をつなぐだけで、依存ライブラリや core は読み込まない。キーとオーバーロードの
# 作り方(def self? の両キー・attr・alias の解決・引数名とアリティ)は BitClust::RbsSigImporter と同じ。
require "bitclust/rbs_sig_importer"
require "pathname"
require "fileutils"

src, outdir, ver = ARGV
abort "usage: extract_rbs_stdlib.rb <rbs-src dir> <outdir> <ver>" unless src && outdir && ver
src = Pathname(src)
outdir = Pathname(outdir)
outdir.mkpath
src_version = (src + "VERSION").read.strip rescue "?"
imp = BitClust::RbsSigImporter.new

failed = []
bad_members = []
per_lib = Hash.new { |h, k| h[k] = {sigs: {}, aliases: []} }
total_files = 0

walk = lambda do |decl, prefix, lib, rel|
  name = decl.name.to_s
  full = name.start_with?("::") ? name.delete_prefix("::") : (prefix ? "#{prefix}::#{name}" : name)
  st = per_lib[lib]
  decl.members.each do |m|
    case m
    when RBS::AST::Declarations::Class, RBS::AST::Declarations::Module
      walk.call(m, full, lib, rel)
    when RBS::AST::Members::MethodDefinition
      begin
        ovs = m.overloads.map { |o| imp.send(:method_type_overload, o.method_type.to_s) }
        imp.send(:method_keys, full, m.name, m.kind).each { |k| st[:sigs][k] ||= ovs }
      rescue Exception => e
        bad_members << "#{rel}: #{full} #{m.name}: #{e.class}"
      end
    when RBS::AST::Members::AttrReader, RBS::AST::Members::AttrWriter, RBS::AST::Members::AttrAccessor
      begin
        ov = [imp.send(:attr_overload, m.type.to_s)]
        names = []
        names << m.name.to_s unless m.is_a?(RBS::AST::Members::AttrWriter)
        names << "#{m.name}=" unless m.is_a?(RBS::AST::Members::AttrReader)
        names.each { |n| st[:sigs][imp.send(:attr_key, full, m, n)] ||= ov }
      rescue Exception => e
        bad_members << "#{rel}: #{full} #{m.name}: #{e.class}"
      end
    when RBS::AST::Members::Alias
      st[:aliases] << [full, m]
    end
  end
end

Dir.glob((src + "stdlib/**/*.rbs").to_s).sort.each do |f|
  total_files += 1
  rel = f.sub(src.to_s + "/", "")
  lib = rel.split("/")[1]
  begin
    res = RBS::Parser.parse_signature(RBS::Buffer.new(name: rel, content: File.read(f)))
    decls = res.is_a?(Array) ? res.last : res
  rescue Exception => e
    failed << "#{rel}: #{e.class}: #{e.message.to_s.lines.first.to_s.strip[0, 160]}"
    next
  end
  decls.each do |d|
    next unless d.is_a?(RBS::AST::Declarations::Class) || d.is_a?(RBS::AST::Declarations::Module)
    walk.call(d, nil, lib, rel)
  end
end

n_keys = n_over = 0
File.open(outdir + "#{ver}-stdlib.tsv", "w") do |f|
  f.puts %w[lib key idx params arity_min arity_max block type].join("\t")
  per_lib.keys.sort.each do |lib|
    st = per_lib[lib]
    imp.send(:resolve_aliases, st[:sigs], st[:aliases])
    st[:sigs].keys.sort.each do |key|
      n_keys += 1
      st[:sigs][key].each_with_index do |o, i|
        n_over += 1
        ar = o["arity"]
        type = o["segments"].map { |_, t| t }.join.gsub(/\s+/, " ")
        f.puts [lib, key, i, (o["params"] || []).join(","),
                ar ? ar[0] : "-", ar ? (ar[1] || "-") : "-",
                o["block"] || "-", type].join("\t")
      end
    end
  end
end

log = []
log << "path: extract_rbs_stdlib.rb (local rbs #{RBS::VERSION})"
log << "source rbs gem: #{src_version}"
log << "files: #{total_files}, parse failures: #{failed.size}, member failures: #{bad_members.size}"
failed.each { |l| log << "  FAILED #{l}" }
bad_members.each { |l| log << "  MEMBER-FAILED #{l}" }
log << "libs: #{per_lib.size}, keys: #{n_keys}, overloads: #{n_over}"
log << "result: ok"
(outdir + "#{ver}-stdlib.log").write(log.join("\n") + "\n")
puts log.join("\n")
