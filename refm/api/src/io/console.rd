
端末上の入出力を制御するための機能を [[c:IO]] に追加するためのライブラ
リです。

例えば、[[m:IO#noecho]] を使ってパスワード入力を端末上に表示しないといっ
た事ができます。同様の事が [[lib:curses]] ライブラリや[[lib:readline]]
ライブラリでも実現できますが、そこまでは必要はないけど、[[m:IO#gets]]
や [[m:IO#getc]] では機能不足といった場合に便利です。

#@# ruby-dev:40897

= reopen IO

== Instance Methods

--- noecho {|io| ... } -> object

文字入力時のエコーバックを無効に設定してブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

以下の例では、標準入力からエコーバックなしで文字列を一行読み込みます。

  require "io/console"
  STDIN.noecho(&:gets)

@raise LocalJumpError ブロックを指定しなかった場合に発生します。

--- echo=(flag)

文字入力時のエコーバックが有効かどうかを設定します。

@param flag true を指定した場合、文字入力時のエコーバックが有効に設定さ
            れます。

--- echo? -> bool

文字入力時のエコーバックが有効かどうかを返します。

--- raw {|io| ... } -> object

raw モード、行編集を無効にして指定されたブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

@raise LocalJumpError ブロックを指定しなかった場合に発生します。

以下の例では、標準入力からエコーバックなしで文字列を一行読み込みます。

  require "io/console"
  STDIN.raw(&:gets)

--- raw! -> IO

raw モードを有効にします。端末のモードを後で元に戻す必要がある場合は
[[m:IO#raw]] を使用してください。

@return 自身を返します。

@see [[m:IO#raw]]

--- getch -> String

raw モードで一文字読み込んだ結果を返します。

--- winsize -> [Integer, Integer]

端末のサイズを [rows, columns] で返します。

--- winsize=(size)

端末のサイズを設定します。

@param size [rows, columns] を数値の配列で指定します。

効果はプラットフォームや環境に依存します。

--- iflush -> IO

カーネルの入力バッファをフラッシュします。

@return 自身を返します。

--- oflush -> IO

カーネルの出力バッファをフラッシュします。

@return 自身を返します。

--- ioflush -> IO

カーネルの入出力バッファをフラッシュします。

@return 自身を返します。

== Singleton Methods

--- console -> File | nil

端末を [[c:File]] オブジェクトで返します。

  require "io/console"
  IO.console # => #<File:/dev/tty>

プロセスが端末から切り離された状態で実行すると nil を返します。

戻り値はプラットフォームや環境に依存します。
