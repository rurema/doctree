# doctree DB から _builtin 以外の全メソッドエントリを TSV で出力する
# usage: bundle exec ruby extract_entries.rb <dbpath>  (doctree ディレクトリで実行)
require "bitclust"

db = BitClust::MethodDatabase.new(ARGV[0])
db.methods.each do |m|
  lib = m.library.name
  next if lib == "_builtin"
  klass = m.klass.name
  m.names.each do |name|
    puts [lib, klass, m.typemark, name].join("\t")
  end
end
