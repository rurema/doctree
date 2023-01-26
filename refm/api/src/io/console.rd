category CUI

端末上の入出力を制御するための機能を [[c:IO]] に追加するためのライブラ
リです。

例えば、[[m:IO#noecho]] を使ってパスワード入力を端末上に表示しないといっ
た事ができます。同様の事が [[lib:readline]] ライブラリでも実現できますが、
そこまでは必要はないけど、 [[m:IO#gets]] や [[m:IO#getc]] では機能不足
といった場合に便利です。

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

--- raw(min: 1, time: 0, intr: false) {|io| ... } -> object

raw モード、行編集を無効にして指定されたブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

@param min 入力操作 (read) 時に受信したい最小のバイト数を指定します。min 値以上のバイト数を受信するまで、操作がブロッキングされます。

@param time タイムアウトするまでの秒数を指定します。time よりも min が優先されるため、入力バイト数が min 値以上になるまでは、time 値に関わらず操作がブロッキングされます。

@param intr trueを指定した場合は、割り込み (interrupt) 、中止 (quit) 、停止 (suspend) の各シグナルを生成する制御文字が有効になります。端末の制御については、 termios のマニュアル：[[url:https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/termios.h.html]] を参照してください。

@raise LocalJumpError ブロックを指定しなかった場合に発生します。

@raise ArgumentError intr に true または false 以外の値を指定した場合に発生します。

以下の例では、標準入力からエコーバックなしで文字列を一行読み込みます。

  require "io/console"
  STDIN.raw(&:gets)

--- raw!(min: 1, time: 0, intr: false) -> self

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

--- iflush -> self

カーネルの入力バッファをフラッシュします。

@return 自身を返します。

--- oflush -> self

カーネルの出力バッファをフラッシュします。

@return 自身を返します。

--- ioflush -> self

カーネルの入出力バッファをフラッシュします。

@return 自身を返します。

#@# NEWS では 2.0 からに見えますが、1.9.3-p194 には既にバックポート済み
#@# のため、分岐を追加しませんでした。
--- cooked {|io| ... } -> object

cooked モードを有効にして指定されたブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

@raise LocalJumpError ブロックを指定しなかった場合に発生します。

以下の例では、標準入力からエコーバック付きで文字列を一行読み込みます。

  require "io/console"
  STDIN.cooked(&:gets)

--- cooked! -> self

cooked モードを有効にします。端末のモードを後で元に戻す必要がある場合は
[[m:IO#cooked]] を使用してください。

@return 自身を返します。

@see [[m:IO#cooked]]

== Singleton Methods

--- console -> File | nil

端末を [[c:File]] オブジェクトで返します。

  require "io/console"
  IO.console # => #<File:/dev/tty>

プロセスが端末から切り離された状態で実行すると nil を返します。

戻り値はプラットフォームや環境に依存します。
