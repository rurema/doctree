#@# author: <jammy@shljapan.co.jp>
require getopts

NOTE: このライブラリは Ruby 1.8.1 以降 obsolete になりました。
代わりに [[lib:optparse]] か [[lib:getoptlong]] を使ってください。

[[lib:getopts]] ライブラリを拡張して
コマンドラインオプションの条件を指定できるようにするライブラリです。
また、指定したオプションが条件にあっていない場合はヘルプメッセージを出力します。

=== オプション解析

parsearg ライブラリのオプション解析規則は
[[lib:getopts]] とまったく同じです．

=== ヘルプメッセージの設定

オプションの解析に失敗したときのヘルプメッセージを設定するには、
まずヘルプメッセージを出力するメソッドを定義し、
そのメソッド名をグローバル変数 $USAGE に代入します。

例：

  def usage
    puts "Usage: #{File.basename($0)} <file>..."
    puts "Options:"
          :
          :
  end

  $USAGE = 'usage'



= reopen Kernel

== Module Functions

--- parseArgs(min_argc，check_opts，single_opts，*opts)
#@todo

コマンドラインオプションを解析し、
対応するグローバル変数 $OPT_xxx に値を設定します。
また、指定したオプションが条件にあっていない場合は
グローバル変数 $USAGE の値を eval します。

第 1、第 2 引数はオプションの必要条件を記述します。
その意味は以下の通りです。

: 第 1 引数
    `-' や `--' を伴って指定するオプション以外のオプションの
    最低必要数を指定します。存在しない場合は 0 を指定します。
: 第 2 引数
    どのオプションが必要条件かを指定します．第 3、第 4 引数で指定する
    オプションのうち必要なものを '('，')'，'|'，'&' を使って並べ、
    全体をダブルクォテーションで括ります。Ruby スクリプト実行時に
    全てのオプションが省略可能ならば nil を指定して下さい。

第 3、第 4 引数は [[m:Kernel#getopts]] の第 1、第 2 引数と同じです。

以下の例は、-x，-y，--geometry のどれか一つと -d オプションが
実行時に最低限必要なオプションであると指定しています。

  parseArgs(0，"d&(x|y|geometry)"，"fd"，"x:"，"y:"，"geometry:"，"version")

