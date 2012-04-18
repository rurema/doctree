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

--- __inspect__ -> String

自身を文字列表現にしたオブジェクトを返します。

--- __to_s__ -> String

自身を文字列表現にしたオブジェクトを返します。

--- ap_name -> String

自身のアプリケーション名を返します。

デフォルト値は "irb" です。

@see [[m:IRB::Context#ap_name=]]

--- ap_name=(val)

自身のアプリケーション名を val に設定します。

.irbrc ファイル中で IRB.conf[:AP_NAME] を設定する事でも同様の操作が行え
ます。

@param val アプリケーション名を [[c:String]] で指定します。

@see [[m:IRB::Context#ap_name]]

--- auto_indent_mode -> bool

入力が次の行に継続した時に自動で字下げを行うかどうかを返します。

デフォルト値は false です。

@return 自動で字下げを行う場合は true を返します。行わない場合は false
        を返します。

@see [[m:IRB::Context#auto_indent_mode=]]

--- auto_indent_mode=(val)

入力が次の行に継続した時に自動で字下げを行うかどうかを val に設定します。

@param val true を指定した場合、自動で字下げを行います。false を指定し
           た場合は自動で字下げを行いません。

@see [[m:IRB::Context#auto_indent_mode]]

--- back_trace_limit -> Integer

エラー発生時のバックトレース表示の先頭、末尾の上限の行数を返します。

デフォルト値は 16 です。

@see [[m:IRB::Context#back_trace_limit=]]

--- back_trace_limit=(val)

エラー発生時のバックトレース表示の先頭、末尾の上限の行数をそれぞれ val
行に設定します。

.irbrc ファイル中で IRB.conf[:BACK_TRACE_LIMIT] を設定する事でも同様の
操作が行えます。

@param val バックトレース表示の先頭、末尾の上限を [[c:Integer]] で指定
           します。

@see [[m:IRB::Context#back_trace_limit]]

--- debug? -> bool

irb がデバッグモード([[m:IRB::Context#debug_level]] が 1 以上)で動作し
ているかどうかを返します。

デフォルト値は true です。

@see [[m:IRB::Context#debug_level]], [[m:IRB::Context#debug_level=]]

#@# TODO: 2.0 以降のデフォルト値は false になると思われるため、対応後に
#@# 分岐する。

--- debug_level -> Integer

irb のデバッグレベルを返します。

デフォルト値は 1 です。

@see [[m:IRB::Context#debug_level=]], [[m:IRB::Context#debug?]]

--- debug_level=(val)

irb のデバッグレベルを val に設定します。

#@# TODO: #6301 の対応後、早ければ 2.0 から分岐を行う。
#@# (IRB::Context#debug_level のデフォルト値も同様)
#@# .irbrc ファイル中で IRB.conf[:DEBUG_LEVEL] を設定する事でも同様の操作
#@# が行えます。

@see [[m:IRB::Context#debug_level]], [[m:IRB::Context#debug?]]

--- echo  -> bool
--- echo? -> bool

irb のプロンプトでの評価結果を表示するかどうかを返します。

デフォルト値は false です。

@see [[m:IRB::Context#echo=]]

--- echo=(val)

irb のプロンプトでの評価結果を表示するかどうかを設定します。

.irbrc ファイル中で IRB.conf[:ECHO] を設定する事でも同様の操作が行えま
す。

@param val true を指定した場合、irb のプロンプトでの評価結果を表示しま
           す。false を指定した場合は表示しません。

@see [[m:IRB::Context#echo]]

--- evaluate(line, line_no) -> object

ライブラリ内部で使用します。

--- exit(ret = 0) -> object

irb を終了します。ret で指定したオブジェクトを返します。

@param ret 戻り値を指定します。

@see [[m:IRB.irb_exit]]

--- file_input? -> bool

ライブラリ内部で使用します。

--- ignore_eof  -> bool
--- ignore_eof? -> bool

Ctrl-D(EOF) が入力された時に irb を終了するかどうかを返します。

true の時は Ctrl-D を無視します。false の時は irb を終了します。

デフォルト値は false です。

@see [[m:IRB::Context#ignore_eof=]]

--- ignore_eof=(val)

Ctrl-D(EOF) が入力された時に irb を終了するかどうかを val に設定します。

.irbrc ファイル中で IRB.conf[:IGNORE_EOF] を設定する事でも同様の操作が
行えます。

@param val true を指定した場合、 Ctrl-D を無視します。false を指定した
           場合は Ctrl-D の入力時に irb を終了します。

@see [[m:IRB::Context#ignore_eof]]

--- ignore_sigint  -> bool
--- ignore_sigint? -> bool

Ctrl-C が入力された時に irb を終了するかどうかを返します。

false の時は irb を終了します。true の時は以下のように動作します。

: 入力中
    これまで入力したものをキャンセルしトップレベルに戻る.
: 実行中
    実行を中止する.

デフォルト値は true です。

@see [[m:IRB::Context#ignore_sigint=]]

--- ignore_sigint=(val)

Ctrl-C が入力された時に irb を終了するかどうかを val に設定します。

.irbrc ファイル中で IRB.conf[:IGNORE_SIGINT] を設定する事でも同様の操作
が行えます。

@param val false を指定した場合、Ctrl-C の入力時に irb を終了します。
           true を指定した場合、Ctrl-C の入力時に以下のように動作します。

: 入力中
    これまで入力したものをキャンセルしトップレベルに戻る.
: 実行中
    実行を中止する.

@see [[m:IRB::Context#ignore_sigint]]

--- inspect -> String
--- to_s -> String

自身を人間に読みやすい文字列にして返します。

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
