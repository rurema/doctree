#@since 1.8.0

Ruby の curses ライブラリ(以下、Ruby curses)は、C のプログラムから端末
の画面を制御するための curses ライブラリ(以下、C curses)を利用して、端
末に依存しない形式でテキストユーザインタフェースを構築するためのライブ
ラリです。

C curses には、次のような実装があります。
#@# 利用可能な curses の実装を見つけたら、随時追加してください。

  * [[url:http://www.gnu.org/software/ncurses/ncurses.html]]
  * [[url:http://pdcurses.sourceforge.net/]]

Ruby curses を使ってテキストユーザインタフェース(以下、TUI)を
構築する流れは次のようになります。

  (1) [[m:Curses.#init_screen]] で初期化を行います。
  (2) [[c:Curses]] のモジュール関数を使い、
  入力のエコーを無効にするなどの Ruby curses の設定を行います。
  (3) [[m:Curses.#stdscr]] やそのサブウインドウを操作し、TUI を構築します。
  (4) [[m:Curses.#getch]] や [[m:Curses.#getstr]] により、
  ユーザからの入力を取得します。入力した情報に従って処理を行い、
  そして、入力を待つということを繰り返します。
  (5) 最後に [[m:Curses.#close_screen]] で終了処理を行います。

例: 画面中央に「Hello World!」と表示し、何か入力があると終了する。

  require "curses"
  
  Curses.init_screen
  begin
    s = "Hello World!"
    Curses.setpos(Curses.lines / 2, Curses.cols / 2 - (s.length / 2))
    Curses.addstr(s)
    Curses.refresh
    Curses.getch
  ensure
    Curses.close_screen
  end

例: 上記の例と同様だが、Curses モジュールを include する場合

  require "curses"

  include Curses
  
  init_screen
  begin
    s = "Hello World!"
    setpos(lines / 2, cols / 2 - (s.length / 2))
    addstr(s)
    refresh
    getch
  ensure
    close_screen
  end

なお、C curses を利用できない環境で Ruby をコンパイルしている場合、
Ruby curses は利用できません。
利用できない場合、require の時点で例外 LoadError が発生します。

  foo:1:in `require': no such file to load -- curses (LoadError)
          from foo:1:in `<main>'

Ruby curses の操作によっては、
利用する C curses が提供していない機能を使うものがあります。
そのような操作を行った場合、例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、いくつかの操作で例外 SecurityError を発生します。

= module Curses

Curses モジュールや [[c:Curses::Window]] クラスは、curses ライブラリを利用して、
端末に依存しない形式でテキストユーザインタフェースを作成できます。
curses ライブラリとは、
C のプログラムから端末のディスプレイ画面を制御するためのライブラリのことで、
次のような実装があります。
#@# 利用可能な curses の実装を見つけたら、随時追加してください。

  * [[url:http://pdcurses.sourceforge.net/]]
  * [[url:http://www.gnu.org/software/ncurses/ncurses.html]]

本モジュールを使ってテキストユーザインタフェースを作成する流れは次のようになります。

  (1) [[m:Curses.#init_screen]] で初期化を行います。
  (2) [[c:Curses]] のモジュール関数を使って、
  入力のエコーを無効にするなどの curses の設定を行います。
  (3) [[m:Curses.#stdscr]] で [[c:Curses::Window]] オブジェクトを取得し、
  それを使ってインタフェースを構築する。
  (4) [[m:Curses.#getch]] や [[m:Curses.#getstr]] により、
  ユーザからの入力を取得します。入力した情報に従って処理を行い、
  そして、入力を待つということを繰り返します。
  (5) 最後に [[m:Curses.#close_screen]] で終了処理を行います。

例: 画面中央に「Hello World!」と表示し、何か入力があると終了する。

  require "curses"
  
  Curses.init_screen
  begin
    s = "Hello World!"
    Curses.setpos(Curses.lines / 2, Curses.cols / 2 - (s.length / 2))
    Curses.addstr(s)
    Curses.refresh
    Curses.getch
  ensure
    Curses.close_screen
  end

なお、curses や ncurses をインストールしていない環境では、
本モジュールは利用できません。
利用できない場合、require の時点で以下のような例外が発生します。

  foo:1:in `require': no such file to load -- bar (LoadError)
          from foo:1:in `<main>'

いくつかの操作において、サポートしていない環境では、
例外 NotImplementError が発生します。

セーフレベル ($SAFE) が 4 の場合、ほとんどの操作で例外 SecurityError を発生します。

== Constants

--- REPORT_MOUSE_POSITION
#@todo

--- ALL_MOUSE_EVENTS
#@todo

--- A_ALTCHARSET
#@todo

--- A_ATTRIBUTES
#@todo

--- A_BLINK
#@todo

--- A_BOLD
#@todo

--- A_CHARTEXT
#@todo

--- A_COLOR
#@todo

--- A_DIM
#@todo

--- A_HORIZONTAL
#@todo

--- A_INVIS
#@todo

--- A_LEFT
#@todo

--- A_LOW
#@todo

--- A_NORMAL
#@todo

--- A_PROTECT
#@todo

--- A_REVERSE
#@todo

--- A_RIGHT
#@todo

--- A_STANDOUT
#@todo

--- A_TOP
#@todo

--- A_UNDERLINE
#@todo

--- A_VERTICAL
#@todo

--- BUTTON1_CLICKED
#@todo

--- BUTTON1_DOUBLE_CLICKED
#@todo

--- BUTTON1_PRESSED
#@todo

--- BUTTON1_RELEASED
#@todo

--- BUTTON1_TRIPLE_CLICKED
#@todo

--- BUTTON2_CLICKED
#@todo

--- BUTTON2_DOUBLE_CLICKED
#@todo

--- BUTTON2_PRESSED
#@todo

--- BUTTON2_RELEASED
#@todo

--- BUTTON2_TRIPLE_CLICKED
#@todo

--- BUTTON3_CLICKED
#@todo

--- BUTTON3_DOUBLE_CLICKED
#@todo

--- BUTTON3_PRESSED
#@todo

--- BUTTON3_RELEASED
#@todo

--- BUTTON3_TRIPLE_CLICKED
#@todo

--- BUTTON4_CLICKED
#@todo

--- BUTTON4_DOUBLE_CLICKED
#@todo

--- BUTTON4_PRESSED
#@todo

--- BUTTON4_RELEASED
#@todo

--- BUTTON4_TRIPLE_CLICKED
#@todo

--- BUTTON_ALT
#@todo

--- BUTTON_CTRL
#@todo

--- BUTTON_SHIFT
#@todo

--- COLOR_BLACK
#@todo

--- COLOR_BLUE
#@todo

--- COLOR_CYAN
#@todo

--- COLOR_GREEN
#@todo

--- COLOR_MAGENTA
#@todo

--- COLOR_RED
#@todo

--- COLOR_WHITE
#@todo

--- COLOR_YELLOW
#@todo

--- KEY_A1
#@todo

--- KEY_A3
#@todo

--- KEY_B2
#@todo

--- KEY_BACKSPACE
#@todo

--- KEY_BEG
#@todo

--- KEY_BREAK
#@todo

--- KEY_BTAB
#@todo

--- KEY_C1
#@todo

--- KEY_C3
#@todo

--- KEY_CANCEL
#@todo

--- KEY_CATAB
#@todo

--- KEY_CLEAR
#@todo

--- KEY_CLOSE
#@todo

--- KEY_COMMAND
#@todo

--- KEY_COPY
#@todo

--- KEY_CREATE
#@todo

--- KEY_CTAB
#@todo

--- KEY_CTRL_A
#@todo

--- KEY_CTRL_B
#@todo

--- KEY_CTRL_C
#@todo

--- KEY_CTRL_D
#@todo

--- KEY_CTRL_E
#@todo

--- KEY_CTRL_F
#@todo

--- KEY_CTRL_G
#@todo

--- KEY_CTRL_H
#@todo

--- KEY_CTRL_I
#@todo

--- KEY_CTRL_J
#@todo

--- KEY_CTRL_K
#@todo

--- KEY_CTRL_L
#@todo

--- KEY_CTRL_M
#@todo

--- KEY_CTRL_N
#@todo

--- KEY_CTRL_O
#@todo

--- KEY_CTRL_P
#@todo

--- KEY_CTRL_Q
#@todo

--- KEY_CTRL_R
#@todo

--- KEY_CTRL_S
#@todo

--- KEY_CTRL_T
#@todo

--- KEY_CTRL_U
#@todo

--- KEY_CTRL_V
#@todo

--- KEY_CTRL_W
#@todo

--- KEY_CTRL_X
#@todo

--- KEY_CTRL_Y
#@todo

--- KEY_CTRL_Z
#@todo

--- KEY_DC
#@todo

--- KEY_DL
#@todo

--- KEY_DOWN
#@todo

--- KEY_EIC
#@todo

--- KEY_END
#@todo

--- KEY_ENTER
#@todo

--- KEY_EOL
#@todo

--- KEY_EOS
#@todo

--- KEY_EXIT
#@todo

--- KEY_F0
#@todo

--- KEY_F1
#@todo

--- KEY_F10
#@todo

--- KEY_F11
#@todo

--- KEY_F12
#@todo

--- KEY_F13
#@todo

--- KEY_F14
#@todo

--- KEY_F15
#@todo

--- KEY_F16
#@todo

--- KEY_F17
#@todo

--- KEY_F18
#@todo

--- KEY_F19
#@todo

--- KEY_F2
#@todo

--- KEY_F20
#@todo

--- KEY_F21
#@todo

--- KEY_F22
#@todo

--- KEY_F23
#@todo

--- KEY_F24
#@todo

--- KEY_F25
#@todo

--- KEY_F26
#@todo

--- KEY_F27
#@todo

--- KEY_F28
#@todo

--- KEY_F29
#@todo

--- KEY_F3
#@todo

--- KEY_F30
#@todo

--- KEY_F31
#@todo

--- KEY_F32
#@todo

--- KEY_F33
#@todo

--- KEY_F34
#@todo

--- KEY_F35
#@todo

--- KEY_F36
#@todo

--- KEY_F37
#@todo

--- KEY_F38
#@todo

--- KEY_F39
#@todo

--- KEY_F4
#@todo

--- KEY_F40
#@todo

--- KEY_F41
#@todo

--- KEY_F42
#@todo

--- KEY_F43
#@todo

--- KEY_F44
#@todo

--- KEY_F45
#@todo

--- KEY_F46
#@todo

--- KEY_F47
#@todo

--- KEY_F48
#@todo

--- KEY_F49
#@todo

--- KEY_F5
#@todo

--- KEY_F50
#@todo

--- KEY_F51
#@todo

--- KEY_F52
#@todo

--- KEY_F53
#@todo

--- KEY_F54
#@todo

--- KEY_F55
#@todo

--- KEY_F56
#@todo

--- KEY_F57
#@todo

--- KEY_F58
#@todo

--- KEY_F59
#@todo

--- KEY_F6
#@todo

--- KEY_F60
#@todo

--- KEY_F61
#@todo

--- KEY_F62
#@todo

--- KEY_F63
#@todo

--- KEY_F7
#@todo

--- KEY_F8
#@todo

--- KEY_F9
#@todo

--- KEY_FIND
#@todo

--- KEY_HELP
#@todo

--- KEY_HOME
#@todo

--- KEY_IC
#@todo

--- KEY_IL
#@todo

--- KEY_LEFT
#@todo

--- KEY_LL
#@todo

--- KEY_MARK
#@todo

--- KEY_MAX
#@todo

--- KEY_MESSAGE
#@todo

--- KEY_MIN
#@todo

--- KEY_MOUSE
#@todo

--- KEY_MOVE
#@todo

--- KEY_NEXT
#@todo

--- KEY_NPAGE
#@todo

--- KEY_OPEN
#@todo

--- KEY_OPTIONS
#@todo

--- KEY_PPAGE
#@todo

--- KEY_PREVIOUS
#@todo

--- KEY_PRINT
#@todo

--- KEY_REDO
#@todo

--- KEY_REFERENCE
#@todo

--- KEY_REFRESH
#@todo

--- KEY_REPLACE
#@todo

--- KEY_RESET
#@todo

--- KEY_RESIZE
#@todo

--- KEY_RESTART
#@todo

--- KEY_RESUME
#@todo

--- KEY_RIGHT
#@todo

--- KEY_SAVE
#@todo

--- KEY_SBEG
#@todo

--- KEY_SCANCEL
#@todo

--- KEY_SCOMMAND
#@todo

--- KEY_SCOPY
#@todo

--- KEY_SCREATE
#@todo

--- KEY_SDC
#@todo

--- KEY_SDL
#@todo

--- KEY_SELECT
#@todo

--- KEY_SEND
#@todo

--- KEY_SEOL
#@todo

--- KEY_SEXIT
#@todo

--- KEY_SF
#@todo

--- KEY_SFIND
#@todo

--- KEY_SHELP
#@todo

--- KEY_SHOME
#@todo

--- KEY_SIC
#@todo

--- KEY_SLEFT
#@todo

--- KEY_SMESSAGE
#@todo

--- KEY_SMOVE
#@todo

--- KEY_SNEXT
#@todo

--- KEY_SOPTIONS
#@todo

--- KEY_SPREVIOUS
#@todo

--- KEY_SPRINT
#@todo

--- KEY_SR
#@todo

--- KEY_SREDO
#@todo

--- KEY_SREPLACE
#@todo

--- KEY_SRESET
#@todo

--- KEY_SRIGHT
#@todo

--- KEY_SRSUME
#@todo

--- KEY_SSAVE
#@todo

--- KEY_SSUSPEND
#@todo

--- KEY_STAB
#@todo

--- KEY_SUNDO
#@todo

--- KEY_SUSPEND
#@todo

--- KEY_UNDO
#@todo

--- KEY_UP
#@todo


== Module Functions

--- init_screen -> Curses::Window
--- stdscr -> Curses::Window

端末の種類や curses に関するデータを初期化し、画面をクリアします。
stdscr と呼ばれる画面全体を表すウィンドウを返します。

ncurses を利用している場合、
このメソッドに失敗すると標準エラー出力にエラーメッセージを出力し、終了します。
そうでない場合、このメソッドに失敗すると例外 RuntimeError を発生します。

詳しくは、 man ページの curs_initscr(3X) の initscr 関数と、
curs_clear(3X) の clear 関数を参照ください。

[[c:Curses]] のいくつかのメソッドは、内部でこのメソッドを呼び出します。
これにより、このメソッドを呼び出していない場合でも、
いくつかの処理をできるようになっています。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Curses.#close_screen]]

--- close_screen -> nil

curses の終了処理を行います。
端末の状態を復帰させ、カーソルを左端に移動させます。

詳しくは、 man ページの curs_initscr(3X) の endwin 関数を参照ください。

@see [[m:Curses.#init_screen]]、[[m:Curses.#stdscr]]

--- closed? -> bool

curses が終了しているかどうかを返します。

詳しくは、 man ページの curs_initscr(3X) の isendwin 関数を参照ください。

サポートしていない環境では、例外 NotImplementError が発生します。

@see [[m:Curses.#close_screen]]

--- clear -> nil

画面全体を表すウィンドウ stdscr の文字を消去し、画面をクリアします。
画面のクリアを反映させるために、
本メソッドのあとに [[m:Curses.#refresh]] を呼び出す必要はありません。

詳しくは、 man ページの curs_clear(3X) の clear 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- refresh -> nil

画面全体を表すウィンドウ stdscr の表示を更新します。

詳しくは、 man ページの curs_refresh(3X) の refresh 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- doupdate -> nil

画面全体を表すウィンドウ stdscr の表示を更新します。
[[m:Curses.#refresh]] 以上に能率良く更新処理を行います。

詳しくは、 man ページの curs_refresh(3X) の doupdate 関数を参照ください。

利用している curses のライブラリが doupdate 関数を提供していない場合、
doupdate 関数の代わりに、refresh 関数を呼び出します。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- echo -> nil

ユーザの入力内容を画面に表示するようにします。
つまり、入力のエコーを有効にします。

詳しくは、 man ページの curs_inopts(3X) の echo 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- noecho

ユーザの入力内容を画面に表示しないようにします。
つまり、入力のエコーを止めます。

詳しくは、 man ページの curs_inopts(3X) の noecho 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

--- cbreak -> nil
--- crmode -> nil

キーボード入力のバッファリングをやめ、ユーザの入力を即座に処理できるようにします。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Curses.#nocbreak]]、[[m:Curses.#nocrmode]]

--- nocbreak -> nil
--- nocrmode -> nil

通常の端末のように、キーボード入力のバッファリングを有効にします。
ユーザの入力はエンターキーなどを押すまで処理できません。
この状態のことを「coocked」モードといいます。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。

@see [[m:Curses.#cbreak]]、[[m:Curses.#crmode]]

--- raw -> nil

[[m:Curses.#cbreak]] と同様に、キーボード入力のバッファリングをやめ、
ユーザの入力を即座に処理できるようにします。なおかつ、
割り込み(Ctrl-C)、サスペンド(Ctrl-Z) などの特殊キーの処理をやめます。
この状態のことを「raw」モードといいます。

@see [[m:Curses.#cbreak]]、[[m:Curses.#noraw]]

--- noraw -> nil

raw モードを抜け、通常の状態にします。
つまり、キーボード入力のバッファリングを行い、
割り込み(Ctrl-C)、サスペンド(Ctrl-Z) などの特殊キーの処理を行うようにします。

@see [[m:Curses.#raw]]

--- nl -> nil
#@todo

cooked モードのとき、return キーの入力に対して
LF (Ctrl-j) を返すようにします。

詳しくは、 man ページの curs_outopts(3X) の nl 関数を参照ください。

--- nonl
#@todo

cooked モードのとき、return キーの入力に対して
CR (Ctrl-m) を返すようにします。

詳しくは、 man ページの curs_outopts(3X) の nonl 関数を参照ください。

--- beep
#@todo

音を出します。
この機能がないところでは単に無視されます。

--- flash
#@todo

画面を一瞬点滅させます。
この機能がないところでは単に無視されます。

--- getch
#@todo

標準入力から 1 バイト読み込みます。
戻り値は ASCII コードを表す整数です。

--- getstr
#@todo

標準入力から一行読み込みます。
戻り値は文字列です。

このメソッドは getnstr() が実装されていない
プラットホームではバッファオーバーフローをおこす恐れが
あります。

--- ungetch(ch)
#@todo

文字 ch (ASCII コードを示す整数) をストリームに戻します。

--- setpos(y, x)
#@todo

stdscr のカーソルを座標 (x,y) に移動します。
座標はともに 0 が始点です。

文字がない場所に setpos した場合の挙動は OS に依存します。

--- standout
#@todo

以降書き込む文字を強調します。
「強調」は反転であることが多いようですが、
そう決められているわけではありません。

--- standend
#@todo

強調する文字の書き込みを終えます。

--- addch(ch)
#@todo

stdscr のカーソルの位置に ch (1 バイト) を上書きします。

--- insch(ch)
#@todo

stdscr のカーソルの位置に ch (1 バイト) を挿入します。

--- addstr(str)
#@todo

stdscr のカーソルの位置に文字列 str を挿入します。

--- delch
#@todo

stdscr のカーソルの位置から 1 バイト削除します。

--- deleteln
#@todo

stdscr のカーソルがある行を削除し、後の行を上に詰めます。

--- lines
#@todo

画面に表示可能な行数を返します。

--- cols
#@todo

画面に表示可能な桁数(バイト)を返します。
ただし実際にはもう 1 バイト少なくしか表示できないライブラリが
あるようです。

--- inch
#@todo

stdscr のカーソル位置から 1 バイト読みとって返します。

#@since 1.8.3

--- clrtoeol
#@todo

--- insertln
#@todo

#@end

#@since 1.8.1

--- def_prog_mode
#@todo

--- reset_prog_mode
#@todo

--- timeout=
#@todo

#@end

--- attroff(attrs)
#@todo

--- attron(attron)
#@todo

--- attrset(attrs)
#@todo

--- bkgd(ch)
#@todo

--- bkgdset(ch)
#@todo

--- can_change_color?
#@todo

#@since 1.9.2
--- colors -> Integer
#@todo

サポートしていない環境では、例外 NotImplementError が発生します。

@raise NotImplementError

#@end
--- color_content(color)
#@todo

--- color_pair(attr)
#@todo

#@since 1.9.2
--- color_pairs -> Integer
#@todo

サポートしていない環境では、例外 NotImplementError が発生します。

@raise NotImplementError

#@end
--- curs_set(visibility)
#@todo

--- delch
#@todo

--- getmouse
#@todo

--- has_colors?
#@todo

--- init_color(color, r, g, b)
#@todo

--- init_pair(pair, f, b)
#@todo

--- keyname(c)
#@todo

--- mouseinterval(interval)
#@todo

--- mousemask(mask)
#@todo

--- pair_content(pair)
#@todo

--- pair_number(attrs)
#@todo

--- resize(lin, col)
--- resizeterm(lin, col)
#@todo

#@# 実体は resizeterm

--- scrl(n)
#@todo

--- setscrreg(top, bottom)
#@todo

--- start_color
#@todo

--- ungetmouse(mevent)
#@todo

--- ESCDELAY -> Integer

ESC の入力を破棄する時間(ミリ秒単位)を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

--- ESCDELAY=(val) -> Integer

ESC の入力を破棄する時間(ミリ秒単位)を val に設定します。
設定した値を返します。

@param val ESC の入力を破棄する時間(ミリ秒単位)を指定します。

サポートしていない環境では、例外 NotImplementError が発生します。

--- TABSIZE -> Integer

タブ幅を取得します。

サポートしていない環境では、例外 NotImplementError が発生します。

--- TABSIZE=(val) -> Integer

タブ幅を val に設定します。設定した値を返します。

@param val タブ幅を指定します。

サポートしていない環境では、例外 NotImplementError が発生します。


--- use_default_colors -> nil

前景色と背景色を端末のデフォルト値 (-1) に設定します。

詳細は man ページの defualt_colors(3X) を参照ください。

サポートしていない環境では、例外 NotImplementError が発生します。

#@include(curses/Curses__Key)
#@include(curses/Curses__MouseEvent)
#@include(curses/Curses__Window)

#@end
