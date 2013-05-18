require irb/workspace

irb の設定を扱うためのサブライブラリです。

= class IRB::Context

irb の設定を扱うためのクラスです。

irb 中で conf コマンドの戻り値や .irbrc で IRB.conf を操作する事で設定
を変更します。irb の起動後は IRB.conf の内容を更新しても変更の内容は反
映されない事に注意してください。

なお、.irbrc 中に記述できる以下の設定値については、[[c:IRB::Context]]
オブジェクトのメソッドとして操作できません。

: IRB.conf[:AT_EXIT]

  irb の終了時(サブ irb を含みません)に本項目に設定された [[c:Proc]] オ
  ブジェクトを実行します。ブロック引数には何も渡されません。

  デフォルト値は [] です。

: IRB.conf[:CONTEXT_MODE]

  新しいワークスペースを作成した時(サブ irb の起動や pushws した時)に、
  ワークスペースに関連する [[c:Binding]] オブジェクトの作成方法を
  [[c:Integer]] で設定します。

  0 を指定した場合、[[m:Object::TOPLEVEL_BINDING]] の [[c:Proc]] 内の
  [[c:Binding]] を使用します。1 を指定した場合、[[c:Tempfile]] 中の
  [[c:Binding]] を使用します。2 を指定した場合、[[c:Thread]] 内で読み込
  んだファイル中の [[c:Binding]] を使用します。3 を指定した場合、
  [[m:Object::TOPLEVEL_BINDING]] の関数中の [[c:Binding]] を使用します。

  ただし、IRB.conf[:SINGLE_IRB] に true を設定していた場合は、現在のワー
  クスペースをそのまま使用します。

  デフォルト値は 3 です。

: IRB.conf[:IRB_LIB_PATH]

  ライブラリ内部で使用します。

: IRB.conf[:IRB_RC]

  irb の起動時(サブ irb を含みます)に本項目に設定された [[c:Proc]] オブ
  ジェクトを実行します。ブロック引数には [[c:IRB::Context]] が渡されます。
  そのため、サブ irb の設定をまとめて実行するのに使用します。

  デフォルト値は nil です。

  [[ref:lib:irb#configure_sub_irb]] も併せて参照してください。

: IRB.conf[:LC_MESSAGES]

  ライブラリ内部で使用します。

: IRB.conf[:MAIN_CONTEXT]

  ライブラリ内部で使用します。

: IRB.conf[:SCRIPT]

  ファイル名を指定して irb を実行した場合のパスを文字列で返します。

  デフォルト値は nil です。

: IRB.conf[:SINGLE_IRB]

  irb 中で self を実行して得られるオブジェクトをサブ irb と共有するかど
  うかを設定します。true を設定した場合に共有されます。

  デフォルト値は false です。

: IRB.conf[:VERSION]

  [[m:IRB.version]] を実行した時に返すバージョンを [[c:String]] で指定
  します。

  デフォルト値は nil です。

#@# 変更しても影響がないため省略しました。ある程度は記述したため、必要
#@# になった際にコメントインします。
#@#: IRB.conf[:RC_NAME_GENERATOR]
#@#  設定ファイルを指定するための [[c:Proc]] オブジェクトを指定します。
#@#
#@##@since 1.9.1
#@#: IRB.conf[:ENCODINGS]
#@#  デフォルトの外部/内部エンコーディングの情報を返します。起動時の -U
#@#  や 、-E(--encoding) オプションの結果を反映しています。変更しても影
#@#  響はありません。
#@##@end

: IRB.conf[:__MAIN__]

  ライブラリ内部で使用します。

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

[[m:IRB::Context#prompt_mode]] の変更に影響を受ける事に注意してください。

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

#@since 2.0.0
デフォルト値は false です。
#@else
デフォルト値は true です。
#@end

@see [[m:IRB::Context#debug_level]], [[m:IRB::Context#debug_level=]]

--- debug_level -> Integer

irb のデバッグレベルを返します。

#@since 2.0.0
デフォルト値は 0 です。
#@else
デフォルト値は 1 です。
#@end

@see [[m:IRB::Context#debug_level=]], [[m:IRB::Context#debug?]]

--- debug_level=(val)

irb のデバッグレベルを val に設定します。

#@since 2.0.0
.irbrc ファイル中で IRB.conf[:DEBUG_LEVEL] を設定する事でも同様の操作
が行えます。
#@end

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

--- inspect? -> bool

[[c:IRB::Context#inspect_mode]] が有効かどうかを返します。

#@since 1.9.2
@return 出力結果に to_s したものを表示する場合は false を返します。それ
        以外の場合は true を返します。
#@else
@return 出力結果に inspect したものを表示する場合は true を返します。
        to_s したものを表示する場合は false を返します。
#@end

@see [[c:IRB::Context#inspect_mode]], [[c:IRB::Context#inspect_mode=]]

#@since 1.9.2
--- inspect_mode -> object | nil
#@else
--- inspect_mode -> bool | nil
#@end

実行結果の出力方式を返します。

@see [[m:IRB::Context#inspect_mode=]]

--- inspect_mode=(opt)

実行結果の出力方式を opt に設定します。

@param opt 以下のいずれかを指定します。
#@since 1.9.2
: false, :to_s, :raw
  出力結果を to_s したものを表示します。
: true, :p, :inspect
  出力結果を inspect したものを表示します。
: :pp, :pretty_inspect
  出力結果を pretty_inspect したものを表示します。
: :yaml, :YAML
  出力結果を YAML 形式にしたものを表示します。
: :marshal, :Marshal, :MARSHAL, [[c:Marshal]]
  出力結果を [[m:Marshal.#dump]] したものを表示します。

@see [[ref:lib:irb#inspect_mode]]
#@else
: true, nil
  出力結果を inspect したものを表示します。
: false
  出力結果を to_s したものを表示します。
#@end

--- io -> IRB::InputMethod

ライブラリ内部で使用します。

--- io=(val)

ライブラリ内部で使用します。

--- irb -> IRB::Irb

ライブラリ内部で使用します。

--- irb=(val)

ライブラリ内部で使用します。

--- irb_name -> String

起動しているコマンド名を文字列で返します。

#@# TODO: サブ irb の時の動作を記述

@see [[m:IRB::Context#irb_name=]]

--- irb_name=(val)

起動しているコマンド名を val に設定します。

@param val コマンド名を [[c:String]] で指定します。

@see [[m:IRB::Context#irb_name]]

--- irb_path -> String

ライブラリ内部で使用します。

--- irb_path=(val)

ライブラリ内部で使用します。

--- last_value -> object

irb 中での最後の実行結果を返します。

--- load_modules -> [String]

irb の起動時に -r オプション指定で読み込まれたライブラリ、~/.irbrc など
の設定ファイル内で IRB.conf[:LOAD_MODULES] 指定で読み込まれたライブラリ
の名前の配列を返します。

#@# 変更しても影響がないため省略しました。
#@#--- load_modules=

--- main -> object

self に設定されたオブジェクトを返します。

@see cwws コマンド

--- prompt_c -> String

式が継続している時のプロンプトを表現するフォーマット文字列を返します。

@see [[m:IRB::Context#prompt_c=]], [[ref:lib:irb#customize_prompt]]

--- prompt_c=(val)

式が継続している時のプロンプトを表現するフォーマット文字列を val に設定
します。

@param val フォーマットを文字列で指定します。指定できる内容については、
           [[ref:lib:irb#customize_prompt]] を参照してください。

[[m:IRB::Context#prompt_mode]] の変更に影響を受ける事に注意してください。

@see [[m:IRB::Context#prompt_mode]], [[m:IRB::Context#prompt_mode=]],
     [[m:IRB::Context#prompt_c]], [[ref:lib:irb#customize_prompt]]

--- prompt_i -> String

通常のプロンプトを表現するフォーマット文字列を返します。

@see [[m:IRB::Context#prompt_i=]],[[ref:lib:irb#customize_prompt]]

--- prompt_i=(val)

通常のプロンプトを表現するフォーマット文字列を val に設定します。

@param val フォーマットを文字列で指定します。指定できる内容については、
           [[ref:lib:irb#customize_prompt]] を参照してください。

[[m:IRB::Context#prompt_mode]] の変更に影響を受ける事に注意してください。

@see [[m:IRB::Context#prompt_mode]], [[m:IRB::Context#prompt_mode=]],
     [[m:IRB::Context#prompt_i]], [[ref:lib:irb#customize_prompt]]

--- prompt_mode -> Symbol

現在のプロンプトモードを [[c:Symbol]] で返します。

オリジナルのプロンプトモードを定義していた場合はそのモードを返します。
そうでない場合は、:DEFAULT、:CLASSIC、:SIMPLE、:INF_RUBY、:XMP、:NULL
のいずれかを返します。

定義済みのプロンプトモードの内容については、IRB.conf[:PROMPT][mode] を
参照してください。

@see [[m:IRB::Context#prompt_mode=]], [[ref:lib:irb#customize_prompt]]

--- prompt_mode=(mode)

プロンプトモードを mode に設定します。

@param mode プロンプトモードを [[c:Symbol]] で指定します。オリジナルの
            プロンプトモードか、:DEFAULT、:CLASSIC、:SIMPLE、:INF_RUBY、
            :XMP、:NULL のいずれを指定してください。

@see [[m:IRB::Context#prompt_mode]], [[ref:lib:irb#customize_prompt]]

--- prompt_n -> String

継続行のプロンプトを表現するフォーマット文字列を返します。

@see [[m:IRB::Context#prompt_n=]], [[ref:lib:irb#customize_prompt]]

--- prompt_n=(val)

継続行のプロンプトを表現するフォーマット文字列を val に設定します。

[[m:IRB::Context#prompt_mode]] の変更に影響を受ける事に注意してください。

@see [[m:IRB::Context#prompt_mode]], [[m:IRB::Context#prompt_mode=]],
     [[m:IRB::Context#prompt_n]], [[ref:lib:irb#customize_prompt]]

--- prompt_s -> String

文字列中のプロンプトを表現するフォーマット文字列を返します。

@see [[m:IRB::Context#prompt_s=]], [[ref:lib:irb#customize_prompt]]

--- prompt_s=(val)

文字列中のプロンプトを表現するフォーマット文字列を val に設定します。

@param val フォーマットを文字列で指定します。指定できる内容については、
           [[ref:lib:irb#customize_prompt]] を参照してください。

[[m:IRB::Context#prompt_mode]] の変更に影響を受ける事に注意してください。

@see [[m:IRB::Context#prompt_mode]], [[m:IRB::Context#prompt_mode=]],
     [[m:IRB::Context#prompt_s]], [[ref:lib:irb#customize_prompt]]

--- prompting? -> bool

ライブラリ内部で使用します。

--- rc  -> bool
--- rc? -> bool

~/.irbrc などの設定ファイルがあれば読み込みを行うかどうかを返します。

@return 設定ファイルの読み込みを行う場合は true を返します。行わない場
        合(irb の起動時に -f オプションを指定した場合)は false を返しま
        す。

#@# 上記は .irbrc が存在しない場合も true を返す事から、「.irbrc を読み
#@# 込んでいたら true を返す」という記述を止めました。
#@#
#@# 変更しても影響がないため省略しました。
#@# --- rc=(val)

--- return_format -> String

irb のプロンプトでの評価結果を表示する際のフォーマットを文字列で返します。

@see [[m:IRB::Context#return_format=]], [[d:print_format]]

--- return_format=(val)

irb のプロンプトでの評価結果を表示する際のフォーマットに val を設定します。

@see [[m:IRB::Context#return_format]], [[d:print_format]]

[[m:IRB::Context#prompt_mode]] の変更に影響を受ける事に注意してください。

--- set_last_value(value) -> object

ライブラリ内部で使用します。

--- thread -> Thread

現在のスレッドを返します。

@see [[m:Thread.current]]

--- use_readline  -> bool | nil
--- use_readline? -> bool | nil

[[lib:readline]] を使うかどうかを返します。

@return 戻り値よって以下のように動作します。

: true
    readline ライブラリを使う
: false
    readline ライブラリを使わない
: nil
    inf-ruby-mode 以外で readline ライブラリを利用しようとする (デフォルト)

動作を変更するためには .irbrc ファイル中で IRB.conf[:USE_READLINE] の設
定や irb 起動時に --readline オプション、--noreadline オプションの指定
を行います。

#@# 変更しても影響がないため省略しました。
#@#--- use_readline=(opt)

--- verbose -> bool | nil

標準出力に詳細なメッセージを出力するように設定されているかどうかを返し
ます。

[[m:IRB::Context#verbose?]] とは別のメソッドである事に注意してください。

@return 詳細なメッセージを出力するように設定されている場合は true を返
        します。そうでない場合は false か nil を返します。

@see [[m:IRB::Context#verbose?]], [[m:IRB::Context#verbose=]]

--- verbose? -> bool | nil

標準出力に詳細なメッセージを出力するかどうかを返します。

@return 詳細なメッセージを出力する場合は true を返します。そうでない場
        合は false か nil を返します。

設定を行っていた場合([[m:IRB::Context#verbose]] が true か false を返す
場合)は設定した通りに動作します。設定を行っていない場合は、ファイルを指
定して irb を実行した場合などに true を返します。

#@until 1.9.2
[注意] 1.9.2 以下では nil 以外を [[m:IRB::Context#verbose=]] に指定する
と常に nil を返す不具合がある事に注意してください。
#@end

@see [[m:IRB::Context#verbose]], [[m:IRB::Context#verbose=]]

--- verbose=(val)

標準出力に詳細なメッセージを出力するかどうかを val に設定します。

.irbrc ファイル中で IRB.conf[:VERBOSE] を設定する事でも同様の操作が行え
ます。

false や nil を指定した場合でも、[[m:IRB::Context#verbose?]] が true を
返す場合は詳細なメッセージを出力する事に注意してください。

@param val true を指定した場合、詳細なメッセージを出力します。false や
           nil を指定した場合、詳細なメッセージを出力しません。

@see [[m:IRB::Context#verbose]], [[m:IRB::Context#verbose?]]

--- workspace -> IRB::WorkSpace

ライブラリ内部で使用します。

--- workspace=(val)

ライブラリ内部で使用します。

#@# 使用されていないため省略しました。
#@# --- workspace_home -> nil

== Constants

--- NOPRINTING_IVARS -> [String]

ライブラリ内部で使用します。

--- NO_INSPECTING_IVARS -> [String]

ライブラリ内部で使用します。

--- IDNAME_IVARS -> [String]

ライブラリ内部で使用します。
