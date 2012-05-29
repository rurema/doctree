require irb/cmd/nop
require irb/ext/workspaces

irb 中の irb_workspaces、irb_push_workspace、irb_pop_workspace コマンド
のための拡張を定義したサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= class IRB::ExtendCommand::Workspaces < IRB::ExtendCommand::Nop

irb 中の irb_workspaces コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> [IRB::WorkSpace]

現在のワークスペースの一覧を返します。

@param obj 使用しません。

= class IRB::ExtendCommand::PushWorkspace < IRB::ExtendCommand::Nop

irb 中の irb_push_workspace コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> [IRB::WorkSpace]

UNIX シェルコマンドの pushd と同じです。

@param obj [[c:IRB::WorkSpace]] オブジェクトを指定します。複数指定した
           場合は先頭のオブジェクトのみが設定されます。

= class IRB::ExtendCommand::PopWorkspace < IRB::ExtendCommand::Nop

irb 中の irb_pop_workspace コマンドのための拡張を定義したクラスです。

== Instance Methods

--- execute(*obj) -> [IRB::WorkSpace]

UNIX シェルコマンドの popd と同じです。

@param obj 使用しません。
