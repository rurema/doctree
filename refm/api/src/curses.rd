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
そのような操作を行った場合、例外 NotImplementedError が発生します。

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
例外 NotImplementedError が発生します。

セーフレベル ($SAFE) が 4 の場合、ほとんどの操作で例外 SecurityError を発生します。

== Constants

--- REPORT_MOUSE_POSITION -> Integer
#@todo
マウスの位置を取得するために使用するマスク用の定数です。

@see [[m:Curses.getmouse]]

--- ALL_MOUSE_EVENTS -> Integer
#@todo
全てのボタンの状態の変化を取得するために使用するマスク用の定数です。

@see [[m:Curses.getmouse]]

--- A_ALTCHARSET -> Integer
#@todo
代替文字セットを表す属性のマスク用定数です。

@see [[m:Curses.attrset]]

--- A_ATTRIBUTES -> Integer
#@todo
属性を展開するために使用する文字列の属性マスク用定数です。

@see [[m:Curses.inch]], [[m:Curses::Window.inch]]

--- A_BLINK -> Integer

文字列の点滅を表す属性のマスク用の定数です。

@see [[m:Curses.attrset]]

--- A_BOLD -> Integer

文字列を明るくするか太字にするための属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_CHARTEXT -> Integer

文字を抽出するための属性マスク用定数です。

@see [[m:Curses.attrset]]

--- A_COLOR -> Integer

色ペアのフィールド情報を抽出するための文字列の属性マスク用の定数です。

@see [[m:Curses.inch]], [[m:Curses::Window.inch]]

--- A_DIM -> Integer

文字列を半分明るくするための属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_HORIZONTAL -> Integer

水平方向のハイライトを表す属性マスク用の定数です。

@see [[man:curs_attr(3x)]]

--- A_INVIS -> Integer

インビジブルかブランクを表す属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_LEFT -> Integer


???を表す属性マスク用の定数です。

@see [[man:curs_attr(3x)]]

--- A_LOW -> Integer
#@todo ???

???を表す属性マスク用の定数です。

@see [[man:curs_attr(3x)]]

--- A_NORMAL -> Integer
#@todo

???を表す属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_PROTECT -> Integer
#@todo
プロテクトモードを表す属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_REVERSE -> Integer

文字列を反転を表す属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_RIGHT -> Integer
#@todo
???を表す属性マスク用の定数です。

@see [[man:curs_attr(3x)]]

--- A_STANDOUT -> Integer
#@todo
ターミナルで使用できる最も強調するモードを表す属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_TOP -> Integer
#@todo
top highlight
@see [[man:curs_attr(3x)]]

--- A_UNDERLINE -> Integer

文字列に下線を引くことを表す属性マスク用の定数です。

@see [[m:Curses.attrset]]

--- A_VERTICAL -> Integer
#@todo
vertical highlight
@see [[man:curs_attr(3x)]]

--- BUTTON1_CLICKED -> Integer

マウスボタン 1 をクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON1_DOUBLE_CLICKED -> Integer

マウスボタン 1 をダブルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON1_PRESSED -> Integer

マウスボタン 1 を押したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON1_RELEASED -> Integer

マウスボタン 1 を離したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON1_TRIPLE_CLICKED -> Integer

マウスボタン 1 をトリプルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON2_CLICKED -> Integer

マウスボタン 2 をクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON2_DOUBLE_CLICKED -> Integer

マウスボタン 2 をダブルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON2_PRESSED -> Integer

マウスボタン 2 を押したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON2_RELEASED -> Integer

マウスボタン 2 を離したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON2_TRIPLE_CLICKED -> Integer

マウスボタン 2 をトリプルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON3_CLICKED -> Integer

マウスボタン 3 をクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON3_DOUBLE_CLICKED -> Integer

マウスボタン 3 をダブルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON3_PRESSED -> Integer

マウスボタン 3 を押したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON3_RELEASED -> Integer

マウスボタン 3 を離したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON3_TRIPLE_CLICKED -> Integer

マウスボタン 3 をトリプルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON4_CLICKED -> Integer

マウスボタン 4 をクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON4_DOUBLE_CLICKED -> Integer

マウスボタン 4 をダブルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON4_PRESSED -> Integer

マウスボタン 4 を押したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON4_RELEASED -> Integer

マウスボタン 4 を離したことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON4_TRIPLE_CLICKED -> Integer

マウスボタン 3 をトリプルクリックしたことを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON_ALT -> Integer

マウス操作中に ALT キーを押下していることを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON_CTRL -> Integer

マウス操作中に CTRL キーを押下していることを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- BUTTON_SHIFT -> Integer

マウス操作中に SHIFT キーを押下していることを表すマウスイベント用の定数です。

@see [[m:Curses.getmouse]]

--- COLOR_BLACK -> Integer

黒を表す定数です。

--- COLOR_BLUE -> Integer

青を表す定数です。

--- COLOR_CYAN -> Integer

シアンを表す定数です。

--- COLOR_GREEN -> Integer

緑を表す定数です。

--- COLOR_MAGENTA -> Integer

マゼンタを表す定数です。

--- COLOR_RED -> Integer

赤を表す定数です。

--- COLOR_WHITE -> Integer

白を表す定数です。

--- COLOR_YELLOW -> Integer

黄色を表す定数です。

--- KEY_A1 -> Integer

キーパッドの左上を表す定数です。

--- KEY_A3 -> Integer

キーパッドの右上を表す定数です。

--- KEY_B2 -> Integer

キーパッドの中心を表す定数です。

--- KEY_BACKSPACE -> Integer

バックスペースキーを表す定数です。

--- KEY_BEG -> Integer
#@todo ???
BEG キーを表す定数です。

--- KEY_BREAK -> Integer

BREAK キーを表す定数です。

--- KEY_BTAB -> Integer

Back TAB キーを表す定数です。

--- KEY_C1 -> Integer

キーパッドの左下を表す定数です。

--- KEY_C3 -> Integer

キーパッドの右下を表す定数です。

--- KEY_CANCEL -> Integer

Cancel キーを表す定数です。

--- KEY_CATAB -> Integer
#@todo
Clear all tabs

--- KEY_CLEAR -> Integer

スクリーンのクリアを表す定数です。

--- KEY_CLOSE -> Integer

Close キーを表す定数です。

--- KEY_COMMAND -> Integer

Command キーを表す定数です。

--- KEY_COPY -> Integer

Copy キーを表す定数です。

--- KEY_CREATE -> Integer

Create キーを表す定数です。

--- KEY_CTAB -> Integer
#@todo
Clear tab

--- KEY_CTRL_A -> Integer

Ctrl + A を表す定数です。

--- KEY_CTRL_B -> Integer

Ctrl + B を表す定数です。

--- KEY_CTRL_C -> Integer

Ctrl + C を表す定数です。

--- KEY_CTRL_D -> Integer

Ctrl + D を表す定数です。

--- KEY_CTRL_E -> Integer

Ctrl + E を表す定数です。

--- KEY_CTRL_F -> Integer

Ctrl + F を表す定数です。

--- KEY_CTRL_G -> Integer

Ctrl + G を表す定数です。

--- KEY_CTRL_H -> Integer

Ctrl + H を表す定数です。

--- KEY_CTRL_I -> Integer

Ctrl + I を表す定数です。

--- KEY_CTRL_J -> Integer

Ctrl + J を表す定数です。

--- KEY_CTRL_K -> Integer

Ctrl + K を表す定数です。

--- KEY_CTRL_L -> Integer

Ctrl + L を表す定数です。

--- KEY_CTRL_M -> Integer

Ctrl + M を表す定数です。

--- KEY_CTRL_N -> Integer

Ctrl + N を表す定数です。

--- KEY_CTRL_O -> Integer

Ctrl + O を表す定数です。

--- KEY_CTRL_P -> Integer

Ctrl + P を表す定数です。

--- KEY_CTRL_Q -> Integer

Ctrl + Q を表す定数です。

--- KEY_CTRL_R -> Integer

Ctrl + R を表す定数です。

--- KEY_CTRL_S -> Integer

Ctrl + S を表す定数です。

--- KEY_CTRL_T -> Integer

Ctrl + T を表す定数です。

--- KEY_CTRL_U -> Integer

Ctrl + U を表す定数です。

--- KEY_CTRL_V -> Integer

Ctrl + V を表す定数です。

--- KEY_CTRL_W -> Integer

Ctrl + W を表す定数です。

--- KEY_CTRL_X -> Integer

Ctrl + X を表す定数です。

--- KEY_CTRL_Y -> Integer

Ctrl + Y を表す定数です。

--- KEY_CTRL_Z -> Integer

Ctrl + Z を表す定数です。

--- KEY_DC -> Integer
#@todo ???
Delete キーを表す定数です。

--- KEY_DL -> Integer

行を削除するキーを表す定数です。

--- KEY_DOWN -> Integer

下矢印キーを表す定数です。

--- KEY_EIC -> Integer

挿入モードに入るキーを表す定数です。

--- KEY_END -> Integer

End キーを表す定数です。

--- KEY_ENTER -> Integer

Enter キーを表す定数です。

--- KEY_EOL -> Integer

行末までクリアするキーを表す定数です。

--- KEY_EOS -> Integer

スクリーンの末尾までクリアするキーを表す定数です。

--- KEY_EXIT -> Integer

Exit キーを表す定数です。

--- KEY_F0 -> Integer

F0 キーを表す定数です。

--- KEY_F1 -> Integer

F1 キーを表す定数です。

--- KEY_F10 -> Integer

F10 キーを表す定数です。

--- KEY_F11 -> Integer

F11 キーを表す定数です。

--- KEY_F12 -> Integer

F12 キーを表す定数です。

--- KEY_F13 -> Integer

F13 キーを表す定数です。

--- KEY_F14 -> Integer

F14 キーを表す定数です。

--- KEY_F15 -> Integer

F15 キーを表す定数です。

--- KEY_F16 -> Integer

F16 キーを表す定数です。

--- KEY_F17 -> Integer

F17 キーを表す定数です。

--- KEY_F18 -> Integer

F18 キーを表す定数です。

--- KEY_F19 -> Integer

F19 キーを表す定数です。

--- KEY_F2 -> Integer

F2 キーを表す定数です。

--- KEY_F20 -> Integer

F20 キーを表す定数です。

--- KEY_F21 -> Integer

F21 キーを表す定数です。

--- KEY_F22 -> Integer

F22 キーを表す定数です。

--- KEY_F23 -> Integer

F23 キーを表す定数です。

--- KEY_F24 -> Integer

F24 キーを表す定数です。

--- KEY_F25 -> Integer

F25 キーを表す定数です。

--- KEY_F26 -> Integer

F26 キーを表す定数です。

--- KEY_F27 -> Integer

F27 キーを表す定数です。

--- KEY_F28 -> Integer

F28 キーを表す定数です。

--- KEY_F29 -> Integer

F29 キーを表す定数です。

--- KEY_F3 -> Integer

F3 キーを表す定数です。

--- KEY_F30 -> Integer

F30 キーを表す定数です。

--- KEY_F31 -> Integer

F31 キーを表す定数です。

--- KEY_F32 -> Integer

F32 キーを表す定数です。

--- KEY_F33 -> Integer

F33 キーを表す定数です。

--- KEY_F34 -> Integer

F34 キーを表す定数です。

--- KEY_F35 -> Integer

F35 キーを表す定数です。

--- KEY_F36 -> Integer

F36 キーを表す定数です。

--- KEY_F37 -> Integer

F37 キーを表す定数です。

--- KEY_F38 -> Integer

F38 キーを表す定数です。

--- KEY_F39 -> Integer

F39 キーを表す定数です。

--- KEY_F4 -> Integer

F4 キーを表す定数です。

--- KEY_F40 -> Integer

F40 キーを表す定数です。

--- KEY_F41 -> Integer

F41 キーを表す定数です。

--- KEY_F42 -> Integer

F42 キーを表す定数です。

--- KEY_F43 -> Integer

F43 キーを表す定数です。

--- KEY_F44 -> Integer

F44 キーを表す定数です。

--- KEY_F45 -> Integer

F45 キーを表す定数です。

--- KEY_F46 -> Integer

F46 キーを表す定数です。

--- KEY_F47 -> Integer

F47 キーを表す定数です。

--- KEY_F48 -> Integer

F48 キーを表す定数です。

--- KEY_F49 -> Integer

F49 キーを表す定数です。

--- KEY_F5 -> Integer

F5 キーを表す定数です。

--- KEY_F50 -> Integer

F50 キーを表す定数です。

--- KEY_F51 -> Integer

F51 キーを表す定数です。

--- KEY_F52 -> Integer

F52 キーを表す定数です。

--- KEY_F53 -> Integer

F53 キーを表す定数です。

--- KEY_F54 -> Integer

F54 キーを表す定数です。

--- KEY_F55 -> Integer

F55 キーを表す定数です。

--- KEY_F56 -> Integer

F56 キーを表す定数です。

--- KEY_F57 -> Integer

F57 キーを表す定数です。

--- KEY_F58 -> Integer

F58 キーを表す定数です。

--- KEY_F59 -> Integer

F59 キーを表す定数です。

--- KEY_F6 -> Integer

F6 キーを表す定数です。

--- KEY_F60 -> Integer

F60 キーを表す定数です。

--- KEY_F61 -> Integer

F61 キーを表す定数です。

--- KEY_F62 -> Integer

F62 キーを表す定数です。

--- KEY_F63 -> Integer

F63 キーを表す定数です。

--- KEY_F7 -> Integer

F7 キーを表す定数です。

--- KEY_F8 -> Integer

F8 キーを表す定数です。

--- KEY_F9 -> Integer

F9 キーを表す定数です。

--- KEY_FIND -> Integer

Find キーを表す定数です。

--- KEY_HELP -> Integer

Help キーを表す定数です。

--- KEY_HOME -> Integer

Home キーを表す定数です。

--- KEY_IC -> Integer

文字を挿入するか挿入モードに入るキーを表す定数です。

--- KEY_IL -> Integer

行を挿入するキーを表す定数です。

--- KEY_LEFT -> Integer

左矢印キーを表す定数です。

--- KEY_LL -> Integer
#@todo
Home down or bottom (lower left)

--- KEY_MARK -> Integer

Mark キーを表す定数です。

--- KEY_MAX -> Integer

curses で利用可能なキーを表す定数の最大値です。

--- KEY_MESSAGE -> Integer

Message キーを表す定数です。

--- KEY_MIN -> Integer

curses で利用可能なキーを表す定数の最小値です。

--- KEY_MOUSE -> Integer
#@todo
Mouse event read

--- KEY_MOVE -> Integer
#@todo
Move キーを表す定数です。

--- KEY_NEXT -> Integer

Next object キーを表す定数です。

--- KEY_NPAGE -> Integer

Next Page キーを表す定数です。

--- KEY_OPEN -> Integer

Open キーを表す定数です。

--- KEY_OPTIONS -> Integer

Opetions キーを表す定数です。

--- KEY_PPAGE -> Integer

Previous Page キーを表す定数です。

--- KEY_PREVIOUS -> Integer

Previous object キーを表す定数です。

--- KEY_PRINT -> Integer

Print キーを表す定数です。

--- KEY_REDO -> Integer

Redo キーを表す定数です。

--- KEY_REFERENCE -> Integer

Reference キーを表す定数です。

--- KEY_REFRESH -> Integer

Refresh キーを表す定数です。

--- KEY_REPLACE -> Integer

Replace キーを表す定数です。

--- KEY_RESET -> Integer

Reset キーを表す定数です。

--- KEY_RESIZE -> Integer

スクリーンがリサイズされたことを表す定数です。

--- KEY_RESTART -> Integer

Restart キーを表す定数です。

--- KEY_RESUME -> Integer

Resume キーを表す定数です。

--- KEY_RIGHT -> Integer

右矢印キーを表す定数です。

--- KEY_SAVE -> Integer

Save キーを表す定数です。

--- KEY_SBEG -> Integer
#@todo
Shifted beginning key

--- KEY_SCANCEL -> Integer

Shift + Cancel キーを表す定数です。

--- KEY_SCOMMAND -> Integer

Shift + Command キーを表す定数です。

--- KEY_SCOPY -> Integer

Shift + Copy キーを表す定数です。

--- KEY_SCREATE -> Integer

Shift + Create キーを表す定数です。

--- KEY_SDC -> Integer
#@todo ???
Shift + Delete キーを表す定数です。

--- KEY_SDL -> Integer

Shift + 行を削除するキーを表す定数です。

--- KEY_SELECT -> Integer

Select キーを表す定数です。

--- KEY_SEND -> Integer

Shift + End キーを表す定数です。

--- KEY_SEOL -> Integer

Shift + 行末までクリアするキーを表す定数です。

--- KEY_SEXIT -> Integer

Shift + Exit キーを表す定数です。

--- KEY_SF -> Integer

前に一行スクロールすることを表す定数です。

--- KEY_SFIND -> Integer

Shift + Find キーを表す定数です。

--- KEY_SHELP -> Integer

Shift + Help キーを表す定数です。

--- KEY_SHOME -> Integer

Shift + Home キーを表す定数です。

--- KEY_SIC -> Integer
#@todo ???
Shift + ... キーを表す定数です。

--- KEY_SLEFT -> Integer

Shift + 左矢印キーを表す定数です。

--- KEY_SMESSAGE -> Integer

Shift + Message キーを表す定数です。

--- KEY_SMOVE -> Integer

Shift + Move キーを表す定数です。

--- KEY_SNEXT -> Integer

Shift + Next キーを表す定数です。

--- KEY_SOPTIONS -> Integer

Shift + Options キーを表す定数です。

--- KEY_SPREVIOUS -> Integer

Shift + Previous キーを表す定数です。

--- KEY_SPRINT -> Integer

Shift + Print キーを表す定数です。

--- KEY_SR -> Integer

後に一行スクロールすることを表す定数です。

--- KEY_SREDO -> Integer

Shift + Redo キーを表す定数です。

--- KEY_SREPLACE -> Integer

Shift + Replace キーを表す定数です。

--- KEY_SRESET -> Integer

Shift + Reset キーを表す定数です。

--- KEY_SRIGHT -> Integer

Shift + 右矢印キーを表す定数です。

--- KEY_SRSUME -> Integer

Shift + Resume キーを表す定数です。

--- KEY_SSAVE -> Integer

Shift + Save キーを表す定数です。

--- KEY_SSUSPEND -> Integer

Shift + Suspend キーを表す定数です。

--- KEY_STAB -> Integer

Shift + TAB キーを表す定数です。

--- KEY_SUNDO -> Integer

Shift + Undo キーを表す定数です。

--- KEY_SUSPEND -> Integer

Suspend キーを表す定数です。

--- KEY_UNDO -> Integer

Undo キーを表す定数です。

--- KEY_UP -> Integer

上矢印キーを表す定数です。

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

@see [[m:Curses.#init_screen]]、[[m:Curses.#stdscr]], [[man:curs_initscr(3X)]]

--- closed? -> bool

curses が終了しているかどうかを返します。

詳しくは、 man ページの curs_initscr(3X) の isendwin 関数を参照ください。

サポートしていない環境では、例外 NotImplementedError が発生します。

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
この状態のことを「cooked」モードといいます。

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

サポートしていない環境では、例外 NotImplementedError が発生します。

@raise NotImplementedError

#@end
--- color_content(color)
#@todo

--- color_pair(attr)
#@todo

#@since 1.9.2
--- color_pairs -> Integer
#@todo

サポートしていない環境では、例外 NotImplementedError が発生します。

@raise NotImplementedError

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

#@since 1.9.2
--- ESCDELAY -> Integer

ESC の入力を破棄する時間(ミリ秒単位)を取得します。

サポートしていない環境では、例外 NotImplementedError が発生します。

--- ESCDELAY=(val)

ESC の入力を破棄する時間(ミリ秒単位)を val に設定します。
設定した値を返します。

@param val ESC の入力を破棄する時間(ミリ秒単位)を指定します。

サポートしていない環境では、例外 NotImplementedError が発生します。

--- TABSIZE -> Integer

タブ幅を取得します。

サポートしていない環境では、例外 NotImplementedError が発生します。

--- TABSIZE=(val)

タブ幅を val に設定します。設定した値を返します。

@param val タブ幅を指定します。

サポートしていない環境では、例外 NotImplementedError が発生します。


--- use_default_colors -> nil

前景色と背景色を端末のデフォルト値 (-1) に設定します。

詳細は man ページの default_colors(3X) を参照ください。

サポートしていない環境では、例外 NotImplementedError が発生します。
#@end

#@include(curses/Curses__Key)
#@include(curses/Curses__MouseEvent)
#@include(curses/Curses__Window)

#@end
