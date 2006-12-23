#@since 1.8.0

端末操作ライブラリ curses の Ruby インターフェイスです。

= module Curses

== Constants

--- REPORT_MOUSE_POSITION

--- ALL_MOUSE_EVENTS

--- A_ALTCHARSET

--- A_ATTRIBUTES

--- A_BLINK

--- A_BOLD

--- A_CHARTEXT

--- A_COLOR

--- A_DIM

--- A_HORIZONTAL

--- A_INVIS

--- A_LEFT

--- A_LOW

--- A_NORMAL

--- A_PROTECT

--- A_REVERSE

--- A_RIGHT

--- A_STANDOUT

--- A_TOP

--- A_UNDERLINE

--- A_VERTICAL

--- BUTTON1_CLICKED

--- BUTTON1_DOUBLE_CLICKED

--- BUTTON1_PRESSED

--- BUTTON1_RELEASED

--- BUTTON1_TRIPLE_CLICKED

--- BUTTON2_CLICKED

--- BUTTON2_DOUBLE_CLICKED

--- BUTTON2_PRESSED

--- BUTTON2_RELEASED

--- BUTTON2_TRIPLE_CLICKED

--- BUTTON3_CLICKED

--- BUTTON3_DOUBLE_CLICKED

--- BUTTON3_PRESSED

--- BUTTON3_RELEASED

--- BUTTON3_TRIPLE_CLICKED

--- BUTTON4_CLICKED

--- BUTTON4_DOUBLE_CLICKED

--- BUTTON4_PRESSED

--- BUTTON4_RELEASED

--- BUTTON4_TRIPLE_CLICKED

--- BUTTON_ALT

--- BUTTON_CTRL

--- BUTTON_SHIFT

--- COLOR_BLACK

--- COLOR_BLUE

--- COLOR_CYAN

--- COLOR_GREEN

--- COLOR_MAGENTA

--- COLOR_RED

--- COLOR_WHITE

--- COLOR_YELLOW

--- KEY_A1

--- KEY_A3

--- KEY_B2

--- KEY_BACKSPACE

--- KEY_BEG

--- KEY_BREAK

--- KEY_BTAB

--- KEY_C1

--- KEY_C3

--- KEY_CANCEL

--- KEY_CATAB

--- KEY_CLEAR

--- KEY_CLOSE

--- KEY_COMMAND

--- KEY_COPY

--- KEY_CREATE

--- KEY_CTAB

--- KEY_CTRL_A

--- KEY_CTRL_B

--- KEY_CTRL_C

--- KEY_CTRL_D

--- KEY_CTRL_E

--- KEY_CTRL_F

--- KEY_CTRL_G

--- KEY_CTRL_H

--- KEY_CTRL_I

--- KEY_CTRL_J

--- KEY_CTRL_K

--- KEY_CTRL_L

--- KEY_CTRL_M

--- KEY_CTRL_N

--- KEY_CTRL_O

--- KEY_CTRL_P

--- KEY_CTRL_Q

--- KEY_CTRL_R

--- KEY_CTRL_S

--- KEY_CTRL_T

--- KEY_CTRL_U

--- KEY_CTRL_V

--- KEY_CTRL_W

--- KEY_CTRL_X

--- KEY_CTRL_Y

--- KEY_CTRL_Z

--- KEY_DC

--- KEY_DL

--- KEY_DOWN

--- KEY_EIC

--- KEY_END

--- KEY_ENTER

--- KEY_EOL

--- KEY_EOS

--- KEY_EXIT

--- KEY_F0

--- KEY_F1

--- KEY_F10

--- KEY_F11

--- KEY_F12

--- KEY_F13

--- KEY_F14

--- KEY_F15

--- KEY_F16

--- KEY_F17

--- KEY_F18

--- KEY_F19

--- KEY_F2

--- KEY_F20

--- KEY_F21

--- KEY_F22

--- KEY_F23

--- KEY_F24

--- KEY_F25

--- KEY_F26

--- KEY_F27

--- KEY_F28

--- KEY_F29

--- KEY_F3

--- KEY_F30

--- KEY_F31

--- KEY_F32

--- KEY_F33

--- KEY_F34

--- KEY_F35

--- KEY_F36

--- KEY_F37

--- KEY_F38

--- KEY_F39

--- KEY_F4

--- KEY_F40

--- KEY_F41

--- KEY_F42

--- KEY_F43

--- KEY_F44

--- KEY_F45

--- KEY_F46

--- KEY_F47

--- KEY_F48

--- KEY_F49

--- KEY_F5

--- KEY_F50

--- KEY_F51

--- KEY_F52

--- KEY_F53

--- KEY_F54

--- KEY_F55

--- KEY_F56

--- KEY_F57

--- KEY_F58

--- KEY_F59

--- KEY_F6

--- KEY_F60

--- KEY_F61

--- KEY_F62

--- KEY_F63

--- KEY_F7

--- KEY_F8

--- KEY_F9

--- KEY_FIND

--- KEY_HELP

--- KEY_HOME

--- KEY_IC

--- KEY_IL

--- KEY_LEFT

--- KEY_LL

--- KEY_MARK

--- KEY_MAX

--- KEY_MESSAGE

--- KEY_MIN

--- KEY_MOUSE

--- KEY_MOVE

--- KEY_NEXT

--- KEY_NPAGE

--- KEY_OPEN

--- KEY_OPTIONS

--- KEY_PPAGE

--- KEY_PREVIOUS

--- KEY_PRINT

--- KEY_REDO

--- KEY_REFERENCE

--- KEY_REFRESH

--- KEY_REPLACE

--- KEY_RESET

--- KEY_RESIZE

--- KEY_RESTART

--- KEY_RESUME

--- KEY_RIGHT

--- KEY_SAVE

--- KEY_SBEG

--- KEY_SCANCEL

--- KEY_SCOMMAND

--- KEY_SCOPY

--- KEY_SCREATE

--- KEY_SDC

--- KEY_SDL

--- KEY_SELECT

--- KEY_SEND

--- KEY_SEOL

--- KEY_SEXIT

--- KEY_SF

--- KEY_SFIND

--- KEY_SHELP

--- KEY_SHOME

--- KEY_SIC

--- KEY_SLEFT

--- KEY_SMESSAGE

--- KEY_SMOVE

--- KEY_SNEXT

--- KEY_SOPTIONS

--- KEY_SPREVIOUS

--- KEY_SPRINT

--- KEY_SR

--- KEY_SREDO

--- KEY_SREPLACE

--- KEY_SRESET

--- KEY_SRIGHT

--- KEY_SRSUME

--- KEY_SSAVE

--- KEY_SSUSPEND

--- KEY_STAB

--- KEY_SUNDO

--- KEY_SUSPEND

--- KEY_UNDO

--- KEY_UP


== Module Functions

--- init_screen

スクリーンを curses のために初期化します。
Curses モジュールのすべてのメソッドはこのメソッドを
呼び出してからでないと使えません。

---  close_screen

curses スクリーンを閉じます。これ以後 Curses モジュール
のメソッドを呼び出すとすべて例外になります。

--- stdscr

画面全体を表す Curses::Window オブジェクトを返します。

--- refresh

stdscr の表示を更新します。

--- doupdate

？

--- clear

stdscr の文字を消去します。
この消去は refresh を待たずにすぐ実行されます。

--- echo

入力のエコーを有効にします。

--- noecho

入力のエコーをやめます。

--- cbreak
--- crmode

キーボード入力のバッファリングをやめます。

--- nocbreak
--- nocrmode

キーボード入力のバッファリングを有効にします。

--- nl

cooked モードのとき、return キーの入力に対して
LF (Ctrl-j) を返すようにします。

--- nonl

cooked モードのとき、return キーの入力に対して
CR (Ctrl-m) を返すようにします。

--- raw

キーボード入力のバッファリングと Ctrl-C などの
特殊キーの処理をやめます (raw モード)。

--- noraw

キーボード入力のバッファリングと Ctrl-C など
特殊キーの処理を行うようにします (cooked モード)。

--- beep

音を出します。
この機能がないところでは単に無視されます。

--- flash

画面を一瞬点滅させます。
この機能がないところでは単に無視されます。

--- getch

標準入力から 1 バイト読み込みます。
戻り値は ASCII コードを表す整数です。

--- getstr

標準入力から一行読み込みます。
戻り値は文字列です。

このメソッドは getnstr() が実装されていない
プラットホームではバッファオーバーフローをおこす恐れが
あります。

--- ungetch(ch)

文字 ch (ASCII コードを示す整数) をストリームに戻します。

--- setpos(y, x)

stdscr のカーソルを座標 (x,y) に移動します。
座標はともに 0 が始点です。

文字がない場所に setpos した場合の挙動は OS に依存します。

--- standout

以降書き込む文字を強調します。
「強調」は反転であることが多いようですが、
そう決められているわけではありません。

--- standend

強調する文字の書き込みを終えます。

--- addch(ch)

stdscr のカーソルの位置に ch (1 バイト) を上書きします。

--- insch(ch)

stdscr のカーソルの位置に ch (1 バイト) を挿入します。

--- addstr(str)

stdscr のカーソルの位置に文字列 str を挿入します。

--- delch

stdscr のカーソルの位置から 1 バイト削除します。

--- deleteln

stdscr のカーソルがある行を削除し、後の行を上に詰めます。

--- lines

画面に表示可能な行数を返します。

--- cols

画面に表示可能な桁数(バイト)を返します。
ただし実際にはもう 1 バイト少なくしか表示できないライブラリが
あるようです。

--- inch

stdscr のカーソル位置から 1 バイト読みとって返します。

#@since 1.8.3

--- clrtoeol

--- insertln

#@end

#@since 1.8.1

--- def_prog_mode

--- reset_prog_mode

--- timeout=

#@end

--- attroff(attrs)

--- attron(attron)

--- attrset(attrs)

--- bkgd(ch)

--- bkgdset(ch)

--- can_change_color?

--- closed?

--- color_content(color)

--- color_pair(attr)

--- curs_set(visibility)

--- delch

--- getmouse

--- has_colors?

--- init_color(color, r, g, b)

--- init_pair(pair, f, b)

--- keyname(c)

--- mouseinterval(interval)

--- mousemask(mask)

--- pair_content(pair)

--- pair_number(attrs)

--- resize(lin, col)
--- resizeterm(lin, col)

#@# 実体は resizeterm

--- scrl(n)

--- setscrreg(top, bottom)

--- start_color

--- ungetmouse(mevent)




#@include(curses/Curses__Key)
#@include(curses/Curses__MouseEvent)
#@include(curses/Curses__Window)

#@end
