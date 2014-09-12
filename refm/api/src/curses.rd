#@since 1.8.0

category CUI

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
      入力を待つということを繰り返します。
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

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、いくつかの操作で例外 SecurityError を発生します。
#@end

=== 注意

このライブラリは 2.1.0 で gem ライブラリとして切り離されました。2.1.0
以降ではそちらを利用してください。

  * [[url:https://rubygems.org/gems/curses]]

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

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、ほとんどの操作で例外 SecurityError を発生します。
#@end

== Constants

--- REPORT_MOUSE_POSITION -> Integer

マウスの位置を取得するために使用するマスク用の定数です。

@see [[m:Curses.getmouse]]

--- ALL_MOUSE_EVENTS -> Integer

全てのボタンの状態の変化を取得するために使用するマスク用の定数です。

@see [[m:Curses.getmouse]]

--- A_ALTCHARSET -> Integer

代替文字セットを表す属性のマスク用定数です。

@see [[m:Curses.attrset]]

--- A_ATTRIBUTES -> Integer

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

Options キーを表す定数です。

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

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

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

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

--- refresh -> nil

画面全体を表すウィンドウ stdscr の表示を更新します。

詳しくは、 man ページの curs_refresh(3X) の refresh 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

--- doupdate -> nil

画面全体を表すウィンドウ stdscr の表示を更新します。
[[m:Curses.#refresh]] 以上に能率良く更新処理を行います。

詳しくは、 man ページの curs_refresh(3X) の doupdate 関数を参照ください。

利用している curses のライブラリが doupdate 関数を提供していない場合、
doupdate 関数の代わりに、refresh 関数を呼び出します。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

--- echo -> nil

ユーザの入力内容を画面に表示するようにします。
つまり、入力のエコーを有効にします。

詳しくは、 man ページの curs_inopts(3X) の echo 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

--- noecho

ユーザの入力内容を画面に表示しないようにします。
つまり、入力のエコーを止めます。

詳しくは、 man ページの curs_inopts(3X) の noecho 関数を参照ください。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

--- cbreak -> nil
#@since 1.9.2
--- crmode -> nil
#@end

キーボード入力のバッファリングをやめ、ユーザの入力を即座に処理できるようにします。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

#@since 1.9.2
@see [[m:Curses.#nocbreak]]、[[m:Curses.#nocrmode]]
#@else
@see [[m:Curses.#nocbreak]]、[[m:Curses#nocrmode]]
#@end

--- nocbreak -> nil
#@since 1.9.2
--- nocrmode -> nil
#@end

通常の端末のように、キーボード入力のバッファリングを有効にします。
ユーザの入力はエンターキーなどを押すまで処理できません。
この状態のことを「cooked」モードといいます。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

#@since 1.9.2
@see [[m:Curses.#cbreak]]、[[m:Curses.#crmode]]
#@else
@see [[m:Curses.#cbreak]]、[[m:Curses#crmode]]
#@end

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

 Enable the underlying display device to translate
 the return key into newline on input, and whether it
 translates newline into return and line-feed on output
 (in either case, the call Curses.addch('\n') does the
 equivalent of return and line feed on the virtual screen).
 
 Initially, these translations do occur. If you disable
 them using Curses.nonl, curses will be able to make better use
 of the line-feed capability, resulting in faster cursor
 motion. Also, curses will then be able to detect the return key.

--- nonl -> nil
#@todo

cooked モードのとき、return キーの入力に対して
CR (Ctrl-m) を返すようにします。

詳しくは、 man ページの curs_outopts(3X) の nonl 関数を参照ください。

 Disable the underlying display device to translate
 the return key into newline on input

@see [[m:Curses.#nl]]

--- beep -> nil

音を出します。
この機能がないところでは単に無視されます。

--- flash -> nil

画面を一瞬点滅させます。
この機能がないところでは単に無視されます。

#@since 1.9.1
--- getch -> String | Integer | nil

標準入力から 1 文字読み込みます。読み込んだ文字が印字可能な文字の場合は
読み込んだ文字を返します。そうでなければ読み込んだ文字に対応する ASCII
コードを表す整数を返します。読み込みにタイムアウトした場合は nil を返し
ます。

@see [[c:Curses::Key]], [[m:Curses.#timeout=]]
#@else
--- getch -> Integer

標準入力から 1 バイト読み込みます。
戻り値は ASCII コードを表す整数です。

@see [[c:Curses::Key]]
#@end

--- getstr -> String

標準入力から一行読み込みます。
戻り値は文字列です。

このメソッドは getnstr() が実装されていない
プラットホームではバッファオーバーフローをおこす恐れが
あります。

@see [[m:Curses::Window#getstr]]

--- ungetch(ch) -> nil

文字 ch (ASCII コードを示す整数) をストリームに戻します。

全てのウインドウで一つだけキューがあります。

@param ch 文字を一つ ASCII コードで指定します。


--- setpos(y, x) -> nil

stdscr のカーソルを座標 (x,y) に移動します。
座標はともに 0 が始点です。

文字がない場所に setpos した場合の挙動は OS に依存します。

@param y Y 座標の値を指定します。

@param x X 座標の値を指定します。

--- standout ->nil

以降書き込む文字を強調します。

「強調」は反転であることが多いようですが、
そう決められているわけではありません。

以下のコードと同じです。

  Curses:Window.attron(A_STANDOUT)

@see [[m:Curses::Window.attrset]]

--- standend -> nil

強調する文字の書き込みを終えます。

以下のコードと同じです。

  Curses.attron(A_NORMAL)

@see [[m:Curses::Window.attrset]]

--- addch(ch) -> nil

stdscr のカーソルの位置に ch (1 バイト) を上書きします。

@param ch 文字を指定します。

@see [[man:curs_addch(3)]]

--- insch(ch) -> nil

stdscr のカーソルの位置に ch (1 バイト) を挿入します。

@param ch 文字を指定します。

--- addstr(str) -> nil

stdscr のカーソルの位置に文字列 str を挿入します。

@param str 文字列を指定します。

--- delch -> nil

stdscr のカーソルの位置から 1 バイト削除します。

--- deleteln -> nil

stdscr のカーソルがある行を削除し、後の行を上に詰めます。

--- lines -> Integer

画面に表示可能な行数を返します。

--- cols -> Integer

画面に表示可能な桁数(バイト)を返します。

ただし実際にはもう 1 バイト少なくしか表示できないライブラリが
あるようです。

--- inch -> Integer

stdscr のカーソル位置から 1 バイト読みとって返します。

#@since 1.8.3

--- clrtoeol -> nil

現在のカーソル位置からウィンドウの最後までをクリアします。

--- insertln -> nil

現在のカーソル位置に一行挿入します。

#@end

#@since 1.8.1

--- def_prog_mode -> bool
#@todo
Save the current terminal modes as the "program"
state for use by the Curses.reset_prog_mode

This is done automatically by Curses.init_screen

--- reset_prog_mode -> bool
#@todo
Reset the current terminal modes to the saved state
by the Curses.def_prog_mode

This is done automatically by Curses.close_screen

--- timeout=(delay)
#@todo
Sets block and non-blocking reads for the window.
- If delay is negative, blocking read is used (i.e., waits indefinitely for input).
- If delay is zero, then non-blocking read is used (i.e., read returns ERR if no input is waiting).
- If delay is positive, then read blocks for delay milliseconds, and returns ERR if there is still no input.

#@end

--- attroff(attrs) -> Integer
#@todo
Turns on the named attributes +attrs+ without affecting any others.

@see [[m:Curses::Window.attrset]]

--- attron(attron) -> Integer
#@todo
Turns off the named attributes +attrs+
without turning any other attributes on or off.

@see [[m:Curses::Window.attrset]]

--- attrset(attrs) -> Integer
#@todo
Sets the current attributes of the given window to +attrs+.

@see [[m:Curses::Window.attrset]]

--- bkgd(ch) -> bool
#@todo

Window background manipulation routines.

Set the background property of the current
and then apply the character Integer +ch+ setting
to every character position in that window.

@see [[man:curs_bkgd(3)]]

--- bkgdset(ch) -> nil

Manipulate the background of the named window
with character Integer +ch+

The background becomes a property of the character
and moves with the character through any scrolling
and insert/delete line/character operations.

@see [[man:curs_bkgd(3)]]

--- can_change_color? -> bool

端末が色を変更できる場合は真を返します。
そうでない場合は偽を返します。

#@since 1.9.2
--- colors -> Integer
#@todo ???

色の数を返します。

@raise NotImplementedError サポートしていない環境で発生します。

#@end
--- color_content(color) -> Array

与えられた色の RGB 値を三要素の配列として返します。

@param color 色を Curses::COLOR_RED などで指定します。

--- color_pair(attrs) -> Integer
#@todo

Sets the color pair attributes to +attrs+.

以下のコードと同じです。

  Curses.attrset(COLOR_PAIR(+attrs+))

@param attr 

#@since 1.9.2
--- color_pairs -> Integer
#@todo

Returns the COLOR_PAIRS available, if the curses library supports it.

@raise NotImplementedError サポートしていない環境で発生します。

#@end
--- curs_set(visibility) -> Integer | nil
#@todo

Sets Cursor Visibility.

 * 0: invisible
 * 1: visible
 * 2: very visible

@param visibility カーソルの可視性を指定します。

--- delch -> nil

カーソルの下の文字を削除します。

--- getmouse -> Integer | nil
#@todo

Returns coordinates of the mouse.

This will read and pop the mouse event data off the queue

@see [[m:Curses::ALL_MOUSE_EVENTS]], [[m:Curses::REPORT_MOUSE_POSITION]]

--- has_colors? -> bool

端末がカラー表示に対応している場合は真を返します。
そうでない場合は偽を返します。

--- init_color(color, r, g, b) -> bool
#@todo

Changes the definition of a color. It takes four arguments:
 * the number of the color to be changed, +color+
 * the amount of red, +r+
 * the amount of green, +g+
 * the amount of blue, +b+

The value of the first argument must be between 0 and  COLORS.
(See the section Colors for the default color index.)  Each
of the last three arguments must be a value between 0 and 1000.
When Curses.init_color is used, all occurrences of that color
on the screen immediately change to the new definition.

@param color ???

@param r レッドの量を指定します。
@param g グリーンの量を指定します。
@param b ブルーの量を指定します。

--- init_pair(pair, f, b) -> bool
#@todo

Changes the definition of a color-pair.

It takes three arguments: the number of the color-pair to be changed +pair+,
the foreground color number +f+, and the background color number +b+.

If the color-pair was previously initialized, the screen is
refreshed and all occurrences of that color-pair are changed
to the new definition.


--- keyname(c) -> String | nil
#@todo

キー c に対応する文字列を返します。

@param c キーの名前を指定します。

--- mouseinterval(interval) -> bool
#@todo
The Curses.mouseinterval function sets the maximum time
(in thousands of a second) that can elapse between press
and release events for them to be recognized as a click.

Use Curses.mouseinterval(0) to disable click resolution.
This function returns the previous interval value.

Use Curses.mouseinterval(-1) to obtain the interval without
altering it.

The default is one sixth of a second.

@param interval

--- mousemask(mask) -> Integer

与えられた mask から報告可能なイベントを取り出して返します。

@param mask マスク値を指定します。

--- pair_content(pair) -> Array
#@todo
与えられた pair に含まれる文字色と背景色を要素とする二要素の配列を返します。

@param pair 

--- pair_number(attrs) -> Integer
#@todo
Returns the Fixnum color pair number of attributes +attrs+.
@param attrs 

--- resizeterm(lines, cols) -> bool | nil
--- resize(lines, cols) -> bool | nil

現在の端末サイズを変更します。

@param lines 変更後の行数を指定します。

@param cols 変更後のカラム数を指定します。

@return サイズの変更に成功した場合は、真を返します。失敗した場合は偽を返します。
        機能をサポートしていない場合は nil を返します。

--- scrl(num) -> bool
#@todo
Scrolls the current window Fixnum +num+ lines.
The current cursor position is not changed.

For positive +num+, it scrolls up.

For negative +num+, it scrolls down.

@param num スクロールする行数を指定します。

--- setscrreg(top, bottom) -> bool
#@todo
Set a software scrolling region in a window.
+top+ and +bottom+ are lines numbers of the margin.

If this option and Curses.scrollok are enabled, an attempt to move off
the bottom margin line causes all lines in the scrolling region
to scroll one line in the direction of the first line.
Only the text of the window is scrolled.

@param top 上方向のマージン行数を指定します。

@param bottom 下方向のマージン行数を指定します。

--- start_color -> bool
#@todo
Initializes the color attributes, for terminals that support it.

This must be called, in order to use color attributes.
It is good practice to call it just after Curses.init_screen

--- ungetmouse(mevent) -> bool
#@todo
It pushes a KEY_MOUSE event onto the input queue, and associates with that
event the given state data and screen-relative character-cell coordinates.

The Curses.ungetmouse function behaves analogously to Curses.ungetch.

@param mevent 入力キューに戻すマウスイベントを指定します。

#@since 1.9.2
--- ESCDELAY -> Integer

ESC の入力を破棄する時間(ミリ秒単位)を取得します。

@raise  NotImplementedError サポートしていない環境で発生します。

--- ESCDELAY=(val)

ESC の入力を破棄する時間(ミリ秒単位)を val に設定します。
設定した値を返します。

@param val ESC の入力を破棄する時間(ミリ秒単位)を指定します。

@raise  NotImplementedError サポートしていない環境で発生します。

--- TABSIZE -> Integer

タブ幅を取得します。

@raise  NotImplementedError サポートしていない環境で発生します。

--- TABSIZE=(val)

タブ幅を val に設定します。設定した値を返します。

@param val タブ幅を指定します。

@raise  NotImplementedError サポートしていない環境で発生します。

--- use_default_colors -> nil

前景色と背景色を端末のデフォルト値 (-1) に設定します。

@raise  NotImplementedError サポートしていない環境で発生します。

@see [[man:default_colors(3X)]]

#@else
== Private Instance Methods

--- crmode -> nil

キーボード入力のバッファリングをやめ、ユーザの入力を即座に処理できるようにします。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

@see [[m:Curses.#nocbreak]]、[[m:Curses#nocrmode]]

--- nocrmode -> nil

通常の端末のように、キーボード入力のバッファリングを有効にします。
ユーザの入力はエンターキーなどを押すまで処理できません。
この状態のことを「cooked」モードといいます。

このメソッドの中で [[m:Curses.#init_screen]] を呼び出します。

#@until 2.1.0
セーフレベル ($SAFE) が 4 の場合、例外 SecurityError を発生します。
#@end

@see [[m:Curses.#cbreak]]、[[m:Curses#crmode]]

#@end

#@include(curses/Curses__Key)
#@include(curses/Curses__MouseEvent)
#@include(curses/Curses__Window)

#@end
