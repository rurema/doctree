#@since 1.8.1
category Obsolete

このライブラリは obsolete です。
代わりに [[lib:optparse]] か [[lib:getoptlong]] を使ってください。
#@else
category CommandLine
#@end

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

== Private Instance Methods

--- parseArgs(min_argc, check_opts, single_opts, *opts) -> Integer | nil

コマンドラインオプションを解析し、対応するグローバル変数 $OPT_xxx に値を設定します。

また、指定したオプションが条件にあっていない場合はグローバル変数 $USAGE の値を eval します。

@param min_argc `-' や `--' を伴って指定するオプション以外のオプションの
                最低必要数を指定します。存在しない場合は 0 を指定します。

@param check_opts どのオプションが必要条件かを指定します．第 3、第 4 引数で指定する
                  オプションのうち必要なものを '('，')'，'|'，'&' を使って並べ、
                  全体をダブルクォテーションで括ります。Ruby スクリプト実行時に
                  全てのオプションが省略可能ならば nil を指定して下さい。

@param single_opts -f や -x の様な一文字のオプションの指定をします。オプショ
                   ンが -f と -x の2つの場合は "fx" の様に指定します。ここでオプシ
                   ョンがないときは必ず nil を指定して下さい。

@param opts  ロングネームのオプションや、引数を伴うオプションを文字列で指定をします。
             --version や --geometry 300x400、-d host:0.0 等がこれ
             に該当します。引数を伴う指定は ":" を必ず付ける様にし
             ます。この例の場合、"version"、"geometry:"、"d:" の様
             になります。 また、オプションを指定しなかった場合のデ
             フォルトの値を持たせたい場合は、":" の直後にそのデフォ
             ルト値を指定します。例えば、"geometry:80x25" の様にな
             ります。

以下の例は、-x，-y，--geometry のどれか一つと -d オプションが
実行時に最低限必要なオプションであると指定しています。

  parseArgs(0，"d&(x|y|geometry)"，"fd"，"x:"，"y:"，"geometry:"，"version")

@see [[lib:getopts]]

--- printUsageAndExit -> ()

グローバル変数 $USAGE がセットされていれば [[m:Kernel.#eval]] して [[m:Kernel.#exit]] します。
セットされていない場合は、単に [[m:Kernel.#exit]] します。

--- setParenthesis(ex, opt, c) -> String

内部で利用します。

@param ex 式を文字列で指定します。

@param opt オプション文字列です。

@param c オプションが出てくる位置です。

--- setOrAnd(ex, opt, c) -> String

内部で利用します。

@param ex 式を文字列で指定します。

@param opt オプション文字列です。

@param c オプションが出てくる位置です。

--- setExpression(ex, opt, c) -> String

内部で利用します。

@param ex 式を文字列で指定します。

@param opt オプション文字列です。

@param c オプションが出てくる位置です。
