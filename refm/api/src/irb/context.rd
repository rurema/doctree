require irb/workspace

= class IRB::Context

== Instance Methods

--- eval_history=(n)
#@todo

実行結果のヒストリ機能の設定.
n は整数か nil で n > 0 であればその数だけヒストリにためる。
n = 0の時は無制限に記憶する.
n = nil だとヒストリ機能はやめる (デフォルト).

--- back_trace_limit
#@todo

バックトレース表示をバックトレースの頭から n,
後ろから n だけ行なう.
デフォルトは 16.

--- debug_level=(n)
#@todo

irb のデバッグレベルの設定

--- ignore_eof
--- ignore_eof=(bool)
#@todo

Ctrl-D が入力された時の動作を設定する.
true の時は Ctrl-D を無視する.
false の時は irb を終了する.

--- ignore_sigint
--- ignore_sigint=(bool)
#@todo

Ctrl-C が入力された時の動作を設定します。
false 時は irb を終了します。
true の時の動作は以下のようになる.

: 入力中
    これまで入力したものをキャンセルしトップレベルに戻る.
: 実行中
    実行を中止する.

--- inf_ruby_mode
--- inf_ruby_mode=(bool)
#@todo

inf-ruby-mode 用のプロンプト表示を行なうかどうかを表します。
デフォルト値は false です。

--- inspect_mode=(val)
#@todo

インスペクトモードを設定する.

: true
    inspect の結果を表示する
: false
    to_s の結果を表示する
: nil
    irb が通常モードであれば inspect mode、
    math モードなら non inspect mode

--- math_mode
#@todo

分数と行列の計算ができる bc モードかどうかを表します。

--- use_loader
--- use_loader=(bool)
#@todo

load または require 時に
irb のファイル読み込み機能を使うかどうかを示します。
デフォルト値は false です。

use_loader の値は irb 全体に反映されます。

--- prompt_c
#@todo

if の直後など, 行が継続している時のプロンプトを
表現するフォーマット文字列を返します。

--- prompt_i
#@todo

通常のプロンプトを表現するフォーマット文字列を返します。

--- prompt_s
#@todo

文字列中のプロンプトを表現するフォーマット文字列を返します。

--- rc
#@todo

~/.irbrc を読み込んでいたら true を返します。
読み込んでいなければ false を返します。

--- use_prompt
--- use_prompt=(bool)
#@todo

プロンプトを表示するかどうかを指定します。
use_prompt の値が true ならプロンプトを表示し、
false ならプロンプトを表示しません。

デフォルト値は true です。

--- use_readline=(val)
#@todo

[[lib:readline]] を使うかどうかを指定します。
val の値によって、このメソッドの効果は以下のように分かれます。

: true
    readline ライブラリを使う
: false
    readline ライブラリを使わない
: nil
    inf-ruby-mode 以外で readline ライブラリを利用しようとする (デフォルト)

#@#--- verbose=(bool)
#@#
#@#irbからいろいろなメッセージを出力するか
#@#
