---
type: library
until: "3.4"
require:
  - irb/cmd/nop
  - irb/ext/change-ws
---
irb 中の irb_current_working_workspace、irb_change_workspace コマンドのための拡張を定義したサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。

# class IRB::ExtendCommand::CurrentWorkingWorkspace < IRB::ExtendCommand::Nop

irb 中の irb_current_working_workspace コマンドのための拡張を定義したクラスです。

## Instance Methods

### def execute(*obj) -> obj

irb の self を返します。

- **param** `obj` -- 使用しません。

# class IRB::ExtendCommand::ChangeWorkspace < IRB::ExtendCommand::Nop

irb 中の irb_change_workspace コマンドのための拡張を定義したクラスです。

## Instance Methods

### def execute(*obj) -> obj

irb の self を obj で指定したオブジェクトに設定します。self に設定されたオブジェクトを返します。

- **param** `obj` -- 任意のオブジェクトを指定できます。複数指定した場合は先頭のオブジェクトのみが設定されます。
