require irb/cmd/nop
require irb/ext/change-ws

irb 中の irb_current_working_workspace、irb_change_workspace コマンドの
ための拡張を定義したサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= class IRB::ExtendCommand::CurrentWorkingWorkspace < IRB::ExtendCommand::Nop

irb 中の irb_current_working_workspace コマンドのための拡張を定義したク
ラスです。

== Instance Methods

--- execute(*obj) -> obj

irb の self を返します。

@param obj 使用しません。

= class IRB::ExtendCommand::ChangeWorkspace < IRB::ExtendCommand::Nop

irb 中の irb_change_workspace コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> obj

irb の self を obj で指定したオブジェクトに設定します。self に設定され
たオブジェクトを返します。

@param obj 任意のオブジェクトを指定できます。複数指定した場合は先頭のオ
           ブジェクトのみが設定されます。
