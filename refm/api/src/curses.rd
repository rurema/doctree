#@since 1.8.0

端末操作ライブラリ curses の Ruby インターフェイスです。

= module Curses

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

--- init_screen
#@todo

スクリーンを curses のために初期化します。
Curses モジュールのすべてのメソッドはこのメソッドを
呼び出してからでないと使えません。

---  close_screen
#@todo

curses スクリーンを閉じます。これ以後 Curses モジュール
のメソッドを呼び出すとすべて例外になります。

--- stdscr
#@todo

画面全体を表す Curses::Window オブジェクトを返します。

--- refresh
#@todo

stdscr の表示を更新します。

--- doupdate
#@todo

？

--- clear
#@todo

stdscr の文字を消去します。
この消去は refresh を待たずにすぐ実行されます。

--- echo
#@todo

入力のエコーを有効にします。

--- noecho
#@todo

入力のエコーをやめます。

--- cbreak
--- crmode
#@todo

キーボード入力のバッファリングをやめます。

--- nocbreak
--- nocrmode
#@todo

キーボード入力のバッファリングを有効にします。

--- nl
#@todo

cooked モードのとき、return キーの入力に対して
LF (Ctrl-j) を返すようにします。

--- nonl
#@todo

cooked モードのとき、return キーの入力に対して
CR (Ctrl-m) を返すようにします。

--- raw
#@todo

キーボード入力のバッファリングと Ctrl-C などの
特殊キーの処理をやめます (raw モード)。

--- noraw
#@todo

キーボード入力のバッファリングと Ctrl-C など
特殊キーの処理を行うようにします (cooked モード)。

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

--- closed?
#@todo

--- color_content(color)
#@todo

--- color_pair(attr)
#@todo

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




#@include(curses/Curses__Key)
#@include(curses/Curses__MouseEvent)
#@include(curses/Curses__Window)

#@end
