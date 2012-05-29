require rake
require rake/tasklib

ユニットテストを実行するためのタスクを定義するライブラリです。

= class Rake::TestTask < Rake::TaskLib

ユニットテストを実行するためのタスクを作成するクラスです。

例:
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
  end

以下に test ターゲットの使用例を示します。

例:
   rake test                           # run tests normally
   rake test TEST=just_one_file.rb     # run just one test file.
   rake test TESTOPTS="-v"             # run in verbose mode
   rake test TESTOPTS="--runner=fox"   # use the fox test runner

== Public Instance Methods

--- define -> self

タスクを定義します。

--- libs -> Array

テスト実行前に [[m:$LOAD_PATH]] に追加するパスを返します。

--- libs=(libs)

テスト実行前に [[m:$LOAD_PATH]] に追加するパスをセットします。

@param libs [[m:$LOAD_PATH]] に追加するパスを配列で指定します。

--- loader -> Symbol

テストをロードする方法を返します。

--- loader=(style)

テストをロードする方法を指定します。

指定できる方法は以下の通りです。

: rake
  Rake が提供する方法でテストをロードします。デフォルトはこれです。
: testrb
  Ruby が提供する testrb コマンドを用いてテストをロードします。
: direct
  コマンドラインで指定したファイルをロードします。

@param style シンボルでテストをロードする方法を指定します。

--- name -> String

テストタスクの名前を返します。デフォルトは "test" です。

--- name=(str)

テストタスクの名前をセットします。

@param str テストタスクの名前を指定します。

--- options -> String

テストスイートに渡すパラメータを返します。

コマンドラインで "TESTOPTS=options" が指定されると、この値を上書きします。
デフォルトは何も指定されていません。

--- options=(option_str)

テストスイートに渡すパラメータをセットします。

@param option_str テストスイートに渡すパラメータを指定します。

--- pattern -> String

テストファイルにマッチする glob パターンを返します。

デフォルトは 'test/test*.rb' です。

--- pattern=(pattern)

テストファイルにマッチする glob パターンを指定します。

#@# --- rake_loader
#@# nodoc

--- ruby_opts -> Array

テスト実行時に Ruby コマンドに渡されるオプションを返します。

--- ruby_opts=(options)

テスト実行時に Ruby コマンドに渡されるオプションをセットします。

@param options 配列でオプションを指定します。

--- test_files=(list)

明示的にテスト対象のファイルを指定します。

[[m:Rake::TestTask#pattern=]], [[m:Rake::TestTask#test_files=]] の
両方でテスト対象を指定した場合、両者は一つにまとめて使用されます。

@param list 配列か [[c:Rake::FileList]] のインスタンスを指定します。

--- verbose -> bool

この値が真である場合、テストの実行結果を詳細に表示します。

--- verbose=(flag)

テストの実行結果を詳細に表示するかどうかをセットします。

@param flag 真または偽を指定します。

--- warning -> bool

この値が真である場合、テスト実行時に ruby -w を実行したのと同じ効果が生じます。

--- warning=(flag)

テスト実行時に警告を表示させるかどうかをセットします。

@param flag 真または偽を指定します。

== Singleton Methods

--- new(name = :test){|t| ... } -> Rake::TestTask

自身を初期化します。

ブロックが与えられた場合は、自身をブロックパラメータとして与えられた
ブロックを評価します。

@param name ターゲット名を指定します。
