
Rake というコマンドラインツールを扱うライブラリです。

=== Rake とは

Rake は Make によく似た機能を持つ Ruby で書かれたシンプルなビルドツールです。

Rake は以下のような特徴を持っています。

  * Rakefile (Rake における Makefile) は標準的な Ruby の文法で書くことができます。
    XML ファイルを編集する必要はありませんし、Makefile の風変わりな文法 (タブだっけ？スペースだっけ？) に頭を悩ませる必要もありません。
  * ユーザは必須条件をタスクに指定できます。
  * Rake は暗黙のタスクを合成することをサポートしています。
  * 配列のように振る舞うフレキシブルな FileList メソッドがあります。
    FileList はファイル名やパス名を扱うのに便利です。
  * Rakefile をより簡単に作成するためにこのライブラリにはいくつかのタスクが同梱されています。

@see [[man:make(1)]]

=== Rake コマンドの使い方

  $ rake --help
  rake [-f rakefile] {options} targets...
  Options are ...
      -C, --classic-namespace       トップレベルに Task, FileTask を定義します。
                                    過去との互換性のためのオプションです。
      -D, --describe [PATTERN]      パターンにマッチしたタスクの詳細を表示して終了します。
                                    パターンは省略可能です。
      -n, --dry-run                 アクションを実行せずにタスクを実行します。
      -e, --execute CODE            Ruby のコードを実行して終了します。
      -p, --execute-print CODE      Ruby のコードを実行して結果を表示して終了します。
      -E, --execute-continue CODE   Ruby のコードを実行してから、タスクを実行します。
      -I, --libdir LIBDIR           ロードパスに LIBDIR を含めます。
      -P, --prereqs                 タスクの依存関係を表示して終了します。
      -q, --quiet                   標準出力にログメッセージを表示しません。
      -f, --rakefile [FILE]         FILE を Rakefile として使用します。
      -R, --rakelibdir RAKELIBDIR   RAKELIBDIR にある *.rake ファイルを自動的にインポートします。
          --rakelib                 デフォルトは rakelib です。
      -r, --require MODULE          Rakefile を実行する前に MODULE を require します。
          --rules                   ルールの解決を追跡します。
      -N, --no-search, --nosearch   親ディレクトリの Rakefile を検索しません。
      -s, --silent                  --quiet に似ていますが、ディレクトリも表示しません。
      -g, --system                  システム全体の Rakefile を使用します。('~/.rake/*.rake')
      -G, --no-system, --nosystem   システム全体の Rakefile を使用しません。
      -T, --tasks [PATTERN]         パターンにマッチしたタスクの短い説明を表示して終了します。
                                    パターンは省略可能です。
      -t, --trace                   全てのバックトレースを表示します。
      -v, --verbose                 標準出力にログメッセージを表示します (デフォルト)。
      -V, --version                 このプログラムのバージョンを表示します。
      -h, -H, --help                このメッセージを表示します。

=== Rake ファイルの書き方

一から全て自分で書くことも出来ますが、あらかじめ定義されているタスクを
使用すると比較的複雑なタスクも簡単に定義することができます。
また、ルールやファイルタスクをうまく使うとタスクを簡潔に書くことが
出来る場合があります。Rakefile は普通の Ruby スクリプトと同じ文法で
書くことができるので工夫次第で Ruby にできることなら何でもできます。

簡単な例:
  # coding: utf-8
  task :hello do
    puts 'do task hello!'
  end

動的にタスクを定義する例:
  # coding: utf-8
  require 'rake/testtask'
  require 'rake/clean'    # clean, clobber の二つのタスクを定義
  task :default => [:test]
  
  1.upto(8) do |n|
    Rake::TestTask.new("test_step#{n}") do |t|
      t.libs << "step#{n}"
      t.test_files = FileList["step#{n}/test_*.rb"]
      t.verbose = false
    end
  end
  
  desc 'execute all test'
  task 'test_all' => (1..8).to_a.map{|n| "test_step#{n}"}

=== 用語集

#@include(rake/glossary.rd)


#@include(rake/Rake)
#@include(rake/Rake__Application)
#@include(rake/Rake__Cloneable)
#@include(rake/Rake__DefaultLoader)
#@include(rake/Rake__EarlyTime)
#@include(rake/Rake__FileCreationTask)
#@include(rake/Rake__FileList)
#@include(rake/Rake__FileTask)
#@include(rake/Rake__InvocationChain)
#@include(rake/Rake__MultiTask)
#@include(rake/Rake__NameSpace)
#@include(rake/Rake__Task)
#@include(rake/Rake__TaskArguments)
#@include(rake/Rake__TaskManager)

#@include(rake/RakeFileUtils)

#@include(rake/core_ext)


