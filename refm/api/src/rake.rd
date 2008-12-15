
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
  
  オプション ...
  
    --classic-namespace  (-C)
        Put Task and FileTask in the top level namespace
    --describe=PATTERN   (-D)
        PATTERN にマッチしたタスクの詳細を表示します。PATTERN を省略すると全タスクを表示します。
    --dry-run            (-n)
        Do a dry run without executing actions.
        何をするか表示しますが、実際には何もしません。
    --help               (-h)
        このメッセージを表示します。
    --libdir=LIBDIR      (-I)
        $LOAD_PATH を指定します。
    --nosearch           (-N)
        親ディレクトリの Rakefile を探索しません。
    --prereqs            (-P)
        タスクと依存関係を表示します。
    --quiet              (-q)
        ログメッセージを標準出力に出力しません。
    --rakefile=FILE      (-f)
        FILE を Rakefile として使用します。
    --rakelibdir=RAKELIBDIR (-R)
        RAKELIBDIR にある *.rake というファイルを自動的に読み込みます。(デフォルトは 'rakelib' です)
    --require=MODULE     (-r)
        Rakefile を実行する前に MODULE を読み込みます。
    --silent             (-s)
        --quiet のように動作しますが、現在のディレクトリを表示します。
    --tasks=PATTERN      (-T)
        PATTERN にマッチしたタスクと説明を表示します。PATTERN を省略すると全タスクを表示します。
    --trace              (-t)
        Turn on invoke/execute tracing, enable full backtrace.
        起動/実行したタスクのトレースを出力します。バックトレースを全て表示します。
    --verbose            (-v)
        標準出力にログメッセージを出力します。 (デフォルト).
    --version            (-V)
        このプログラムのバージョンを表示します。


=== Rake ファイルの書き方

簡単な例:
  


=== 用語集

#@include(rake/glossary.rd)


#@include(rake/core_ext)

#@include(rake/Rake)
#@include(rake/Rake__Application)
#@include(rake/Rake__Cloneable)
#@include(rake/Rake__DefaultLoader)
#@include(rake/Rake__EarlyTime)
#@include(rake/Rake__FileList)



