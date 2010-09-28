require rake
require rake/tasklib

ドキュメントを作成するためのタスクを定義します。

以下のタスクを定義します。

: rdoc
  RDoc を作成します。
: clobber_rdoc
  生成された RDoc のファイルを削除します。
  このタスクは clobber タスクにも追加されます。
: rerdoc
  既に存在する RDoc が古くなくても RDoc を作成します。


例:
   Rake::RDocTask.new do |rd|
     rd.main = "README.rdoc"
     rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
   end

例:
   # RDoc タスクに別の名前を付ける例
   Rake::RDocTask.new(:rdoc_dev) do |rd|
     rd.main = "README.doc"
     rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
     rd.options << "--all"
   end

= class Rake::RDocTask < Rake::TaskLib

== Public Instance Methods

--- define -> self

タスクを定義します。

--- external -> bool

この値が真の場合は外部のシェル経由で rdoc コマンドを実行します。
デフォルトは偽です。

--- external=(flag)

外部のシェル経由で rdoc コマンドを実行するかどうかセットします。

@param flag 真または偽を指定します。

--- main -> String

メインとして使用されるファイル名を返します。

--- main=(filename)

メインとして使用されるファイル名をセットします。

--- name -> String

タスクの名前を返します。デフォルトは rdoc です。

--- name=(name)

タスクの名前をセットします。

@param name タスクの名前を指定します。

--- option_list -> Array

rdoc コマンドに渡すオプションのリストを返します。

--- option_string -> String

rdoc コマンドに渡すオプションを文字列として返します。

--- options -> Array

rdoc コマンドに渡すオプションのリストを返します。

指定できるオプションは -o, --main, --title, -T 以外です。

--- options=(options)

rdoc コマンドに渡すオプションのリストをセットします。

@param options rdoc コマンドに渡されるオプションを指定します。

--- quote(str) -> String

[[m:Rake::RDocTask#external]] が真の場合は与えられた文字列をクオートします。

@param str クオートする文字列を指定します。

--- rdoc_dir -> String

作成した HTML ファイルを保存するディレクトリ名を返します。
デフォルトは html です。

--- rdoc_dir=(dir)

作成した HTML ファイルを保存するディレクトリ名をセットします。

--- rdoc_files -> Rake::FileList

RDoc の生成に使用するファイルリストを返します。
デフォルトは空です。

--- rdoc_files=(filelist)

RDoc の生成に使用するファイルリストをセットします。

@param filelist ファイルリストを指定します。

--- template -> String

使用するテンプレートを返します。
デフォルトは RDoc のデフォルトです。

--- template=(template)

使用するテンプレートをセットします。

@param template 使用するテンプレートを指定します。

--- title -> String

RDoc のタイトルを返します。
デフォルト値はありません。

--- title=(title)

RDoc のタイトルをセットします。

@param title タイトルを指定します。

== Singleton Methods

--- new(name = :rdoc){|pkg| ... } -> Rake::RDocTask

自身を初期化して RDoc タスクを定義します。

ブロックが与えられた場合は、自身をブロックパラメータとして
ブロックを評価します。

@param name タスクの名前を指定します。
