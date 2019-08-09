Makefile をロードするためのライブラリです。

= class Rake::MakefileLoader

Makefile をロードするためのクラスです。

== Public Instance Methods

--- load(filename)

与えられた Makefile をロードします。

@param filename 読み込む Makefile の名前を指定します。

#@samplecode
# Rakefile での記載例とする
require "rake/loaders/makefile"

task default: :test_rake_app

open "sample.mf", "w" do |io|
  io << <<-'SAMPLE_MF'
# Comments
a: a1 a2 a3 a4
b: b1 b2 b3 \
   b4 b5 b6\
# Mid: Comment
b7
 a : a5 a6 a7
c: c1
d: d1 d2 \
e f : e1 f1
g\ 0: g1 g\ 2 g\ 3 g4
  SAMPLE_MF
end

task :test_rake_app do |task|
  loader = Rake::MakefileLoader.new
  loader.load("sample.mf")
  Rake::Task.task_defined?("a") # => true
  Rake::Task.tasks[0] # => <Rake::FileTask a => [a1, a2, a3, a4, a5, a6, a7]>
end
#@end
