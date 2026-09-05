# doctree DB から全ライブラリ(_builtin 込み)のメソッドエントリ・クラス・ライブラリ一覧を TSV で出力する
# usage: bundle exec ruby extract_db.rb <dbpath> <outdir> <ver>   (doctree ディレクトリで実行)
require "bitclust"
db, outdir, ver = ARGV
db = BitClust::MethodDatabase.new(db)
File.open(File.join(outdir, "entries-#{ver}.tsv"), "w") do |f|
  db.methods.each do |m|
    lib = m.library.name
    klass = m.klass.name
    m.names.each do |name|
      f.puts [lib, klass, m.typemark, name, m.kind, m.visibility].join("\t")
    end
  end
end
File.open(File.join(outdir, "classes-#{ver}.tsv"), "w") do |f|
  db.classes.each do |c|
    sup = (c.superclass && c.superclass.name) rescue nil
    inc = (c.included.map(&:name) rescue [])
    ext = (c.extended.map(&:name) rescue [])
    ali = (c.aliasof && c.aliasof.name) rescue nil
    f.puts [c.name, c.type, c.library.name, sup || "-", inc.join(","), ext.join(","), ali || "-"].join("\t")
  end
end
File.open(File.join(outdir, "libs-#{ver}.tsv"), "w") do |f|
  db.libraries.each do |l|
    n = l.methods.size + l.classes.sum { |c| c.entries.size }
    f.puts [l.name, l.category.to_s, l.is_sublibrary ? "sub" : "top", l.classes.size, n].join("\t")
  end
end
