---
type: library
category: CUI
---
端末上の入出力を制御するための機能を [c:IO] に追加するためのライブラリです。

例えば、[m:IO#noecho] を使ってパスワード入力を端末上に表示しないといった事ができます。同様の事が [lib:readline] ライブラリでも実現できますが、そこまでは必要はないけど、 [m:IO#gets] や [m:IO#getc] では機能不足といった場合に便利です。

#%# ruby-dev:40897

# reopen IO

## Instance Methods

### def noecho {|io| ... } -> object

文字入力時のエコーバックを無効に設定してブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

以下の例では、標準入力からエコーバックなしで文字列を一行読み込みます。

```ruby
require "io/console"
STDIN.noecho(&:gets)
```

- **raise** `LocalJumpError` -- ブロックを指定しなかった場合に発生します。

### def echo=(flag)

文字入力時のエコーバックが有効かどうかを設定します。

- **param** `flag` -- true を指定した場合、文字入力時のエコーバックが有効に設定されます。

### def echo? -> bool

文字入力時のエコーバックが有効かどうかを返します。

### def raw(min: 1, time: 0, intr: false) {|io| ... } -> object

raw モード、行編集を無効にして指定されたブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

- **param** `min` -- 入力操作 (read) 時に受信したい最小のバイト数を指定します。min 値以上のバイト数を受信するまで、操作がブロッキングされます。

- **param** `time` -- タイムアウトするまでの秒数を指定します。time よりも min が優先されるため、入力バイト数が min 値以上になるまでは、time 値に関わらず操作がブロッキングされます。

- **param** `intr` -- trueを指定した場合は、割り込み (interrupt) 、中止 (quit) 、停止 (suspend) の各シグナルを生成する制御文字が有効になります。端末の制御については、 termios のマニュアル：<https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/termios.h.html> を参照してください。

- **raise** `LocalJumpError` -- ブロックを指定しなかった場合に発生します。

- **raise** `ArgumentError` -- intr に true または false 以外の値を指定した場合に発生します。

以下の例では、標準入力からエコーバックなしで文字列を一行読み込みます。

```ruby
require "io/console"
STDIN.raw(&:gets)
```

### def raw!(min: 1, time: 0, intr: false) -> self

raw モードを有効にします。端末のモードを後で元に戻す必要がある場合は
[m:IO#raw] を使用してください。

- **return** -- 自身を返します。

- **SEE** [m:IO#raw]

### def getch -> String

raw モードで一文字読み込んだ結果を返します。

### def winsize -> [Integer, Integer]

端末のサイズを [rows, columns] で返します。

### def winsize=(size)

端末のサイズを設定します。

- **param** `size` -- [rows, columns] を数値の配列で指定します。

効果はプラットフォームや環境に依存します。

### def iflush -> self

カーネルの入力バッファをフラッシュします。

- **return** -- 自身を返します。

### def oflush -> self

カーネルの出力バッファをフラッシュします。

- **return** -- 自身を返します。

### def ioflush -> self

カーネルの入出力バッファをフラッシュします。

- **return** -- 自身を返します。

#%# NEWS では 2.0 からに見えますが、1.9.3-p194 には既にバックポート済み
#%# のため、分岐を追加しませんでした。
### def cooked {|io| ... } -> object

cooked モードを有効にして指定されたブロックを評価します。

ブロック引数には self が渡されます。ブロックを評価した結果を返します。

- **raise** `LocalJumpError` -- ブロックを指定しなかった場合に発生します。

以下の例では、標準入力からエコーバック付きで文字列を一行読み込みます。

```ruby
require "io/console"
STDIN.cooked(&:gets)
```

### def cooked! -> self

cooked モードを有効にします。端末のモードを後で元に戻す必要がある場合は
[m:IO#cooked] を使用してください。

- **return** -- 自身を返します。

- **SEE** [m:IO#cooked]

### def console_mode -> IO::ConsoleMode
### def console_mode=(mode)

現在の端末の入出力モードを取得し、または設定します。

`console_mode` は現在のモードを表す `IO::ConsoleMode` のインスタンスを返します。
`console_mode=` は mode に指定したモードを端末に設定します。[m:IO#raw] などでモードを
変更する前に `console_mode` で現在の状態を取得しておき、後で `console_mode=` に渡して
元に戻す、という使い方ができます。

- **param** `mode` -- 設定するモードを表す `IO::ConsoleMode` のインスタンスです。

### def beep -> self

端末を鳴らします。

### def goto(line, column) -> self

カーソル位置を line 行目、column 列目に移動します。

- **param** `line` -- 移動先の行を 0 から始まる整数で指定します。
- **param** `column` -- 移動先の列を 0 から始まる整数で指定します。

- **SEE** [m:IO#cursor]

### def goto_column(column) -> self

カーソルを同じ行のまま column 列目に移動します。

- **param** `column` -- 移動先の列を 0 から始まる整数で指定します。

- **SEE** [m:IO#goto]

### def cursor -> [Integer, Integer] | nil
### def cursor=(pos)

現在のカーソル位置を取得し、または移動します。

`cursor` は現在のカーソル位置を、行と列からなる要素数 2 の配列で返します。行・列とも
0 から始まる整数です。端末が対応していないなど、位置を取得できない場合は nil を返します。

`cursor=` はカーソル位置を pos で移動します。`io.cursor = [line, column]` は
`io.goto(line, column)` と同じです。

- **param** `pos` -- 移動先の位置を表す、行と列からなる要素数 2 の配列です。
- **raise** `ArgumentError` -- pos が要素数 2 の配列に変換できない場合に発生します。

- **SEE** [m:IO#goto]

### def cursor_up(n) -> self

カーソルを n 行上に移動します。

- **param** `n` -- 移動する行数を整数で指定します。

- **SEE** [m:IO#cursor_down]

### def cursor_down(n) -> self

カーソルを n 行下に移動します。

- **param** `n` -- 移動する行数を整数で指定します。

- **SEE** [m:IO#cursor_up]

### def cursor_left(n) -> self

カーソルを n 列左に移動します。

- **param** `n` -- 移動する列数を整数で指定します。

- **SEE** [m:IO#cursor_right]

### def cursor_right(n) -> self

カーソルを n 列右に移動します。

- **param** `n` -- 移動する列数を整数で指定します。

- **SEE** [m:IO#cursor_left]

#%since 4.1
### def hide_cursor -> self

カーソルを非表示にします。

- **SEE** [m:IO#show_cursor]

#%end

#%since 4.1
### def show_cursor -> self

カーソルを表示します。

- **SEE** [m:IO#hide_cursor]

#%end

### def erase_line(mode) -> self

カーソル位置を基準にして、行の一部または全体を消去します。

- **param** `mode` -- 消去する範囲を表す 0 から 2 の整数です。0 はカーソルから行末まで、
           1 は行頭からカーソルまで(カーソル位置を含む)、2 は行全体を消去します。
           nil を指定した場合は 0 として扱われます。
- **raise** `ArgumentError` -- mode が 0 から 2 の範囲外の整数の場合に発生します。

- **SEE** [m:IO#erase_screen]

### def erase_screen(mode) -> self

カーソル位置を基準にして、画面の一部または全体を消去します。

- **param** `mode` -- 消去する範囲を表す 0 から 3 の整数です。0 はカーソルから画面末尾まで、
           1 は画面先頭からカーソルまで(カーソル位置を含む)、2 は画面全体、
           3 は画面の外にスクロールした部分も含めた全体を消去します。
           nil を指定した場合は 0 として扱われます。
- **raise** `ArgumentError` -- mode が 0 から 3 の範囲外の整数の場合に発生します。

- **SEE** [m:IO#erase_line], [m:IO#clear_screen]

### def clear_screen -> self

画面全体を消去し、カーソルを左上に移動します。

[m:IO#erase_screen] に 2 を指定して呼び出した後、 [m:IO#goto] で先頭(0 行目、0 列目)に
移動するのと同じです。

- **SEE** [m:IO#erase_screen], [m:IO#goto]

### def scroll_forward(n) -> self

画面全体を n 行分、上方向にスクロールします。新しく現れた行は空白になります。

- **param** `n` -- スクロールする行数を整数で指定します。

- **SEE** [m:IO#scroll_backward]

### def scroll_backward(n) -> self

画面全体を n 行分、下方向にスクロールします。新しく現れた行は空白になります。

- **param** `n` -- スクロールする行数を整数で指定します。

- **SEE** [m:IO#scroll_forward]

### def pressed?(key) -> bool

key で指定したキーが押されているかどうかを返します。

このメソッドは Windows でのみ使用できます。

- **param** `key` -- 調べたいキーを表す仮想キーコード(整数)か、その名前を
           "VK_" 接頭辞を除いた文字列またはシンボルで指定します。
- **raise** `ArgumentError` -- key が文字列またはシンボルで、対応する仮想キーコードが
           見つからない場合に発生します。
- **raise** `NotImplementedError` -- Windows 以外の環境で発生します。

### def check_winsize_changed { ... } -> self

コンソールの入力イベントキューに溜まっているイベントを読み進め、ウィンドウサイズが
変更されたイベントが見つかるたびにブロックを評価します。ウィンドウサイズの変更以外の
イベントは読み捨てます。ブロックには常に nil が渡されます。

このメソッドは Windows でのみ使用できます。

- **raise** `NotImplementedError` -- Windows 以外の環境で発生します。

#%since 4.1
### def console_input_events(max_events = 1, timeout: nil) -> [{Symbol => object}]

コンソールの入力イベントを、発生順を保ったまま最大 max_events 件読み込んで返します。

少なくとも 1 件のイベントを読み込めるまでブロックします。 timeout を指定した場合、
その秒数が経過してもイベントを読み込めなかったときは空の配列を返します。

戻り値の配列の各要素は、1 件のイベントの情報を持つハッシュです。 `:type` キーの値に
よって、残りのキーの構成が変わります。

- `:key` -- `:key_down`、`:repeat_count`、`:virtual_key_code`、`:virtual_scan_code`、
  `:unicode_char`、`:control_key_state` を持ちます。
- `:mouse` -- `:position` ([行, 列])、`:button_state`、`:control_key_state`、
  `:event_flags` を持ちます。
- `:window_buffer_size` -- `:size` ([行, 列]) を持ちます。
- `:menu` -- `:command_id` を持ちます。
- `:focus` -- `:set_focus` を持ちます。

このメソッドは Windows でのみ使用できます。

- **param** `max_events` -- 読み込むイベントの最大件数です。省略した場合は 1 です。
- **param** `timeout` -- タイムアウトするまでの秒数です。省略した場合はタイムアウトしません。
- **raise** `ArgumentError` -- max_events に 0 を指定した場合に発生します。
- **raise** `NotImplementedError` -- Windows 以外の環境で発生します。

#%end

#%since 4.1
### def input_pending? -> bool

`self` から、ブロックせずに読み込めるデータがあるかどうかを返します。

#%end

### def getpass(prompt = nil) -> String

エコーバックなしで 1 行読み込んで返します。

prompt を指定した場合、読み込む前にそれを出力します。 `self` が標準入力の場合、
prompt は標準エラー出力に出力します。読み込んだ文字列の末尾の改行は
[m:String#chomp!] と同じ規則で取り除かれます。

```ruby invalid
require "io/console"
STDIN.getpass("Enter password: ")
```

- **param** `prompt` -- 入力を促すために出力する文字列です。省略した場合は何も出力しません。
- **return** -- 読み込んだ文字列を返します。

- **SEE** [m:String#chomp!]

#%since 3.4
### def ttyname -> String | nil

`self` が端末に接続されている場合、その端末名を返します。端末に接続されていない
場合は nil を返します。

- **return** -- 端末名の文字列、または nil を返します。

#%end

## Singleton Methods

### def IO.console -> File | nil

端末を [c:File] オブジェクトで返します。

```ruby
require "io/console"
p IO.console # => #<File:/dev/tty>
```

プロセスが端末から切り離された状態で実行すると nil を返します。

戻り値はプラットフォームや環境に依存します。
