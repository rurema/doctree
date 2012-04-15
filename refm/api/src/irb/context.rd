require irb/workspace

irb の設定を扱うためのサブライブラリです。

= class IRB::Context

irb の設定を扱うためのクラスです。

irb 中で conf コマンドの戻り値や .irbrc で IRB.conf を操作する事で設定
を変更します。irb の起動後は IRB.conf の内容を更新しても変更の内容は反
映されない事に注意してください。

== Class Methods

--- new(irb, workspace = nil, input_method = nil, output_method = nil) -> IRB::Context

自身を初期化します。

@param irb [[c:IRB::Irb]] オブジェクトを指定します。

@param workspace [[c:IRB::WorkSpace]] オブジェクトを指定します。省略し
                 た場合は新しく作成されます。

@param input_method [[c:String]]、[[c:IRB::InputMethod]] のサブクラスの
                    オブジェクト、nil のいずれかを指定します。

@param output_method [[c:IRB::OutputMethod]] のサブクラスのオブジェクト
                     を指定します。省略した場合は
                     [[c:IRB::StdioOutputMethod]] オブジェクトが新しく
                     作成されます。

== Instance Methods

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
== Constants

--- NOPRINTING_IVARS -> [String]

ライブラリ内部で使用します。

--- NO_INSPECTING_IVARS -> [String]

ライブラリ内部で使用します。

--- IDNAME_IVARS -> [String]

ライブラリ内部で使用します。
