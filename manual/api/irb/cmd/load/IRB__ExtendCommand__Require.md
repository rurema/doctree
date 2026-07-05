---
library: irb/cmd/load
include:
  - IRB::IrbLoader
---
# class IRB::ExtendCommand::Require < IRB::ExtendCommand::Nop

irb 中の irb_require コマンドのための拡張を定義したクラスです。

## Instance Methods

### def execute(file_name) -> bool

ファイル file_name を現在の irb インタプリタ上で実行します。

file_name に Ruby スクリプトを指定した場合は、[m:Kernel?.require] と異
なり、file_name の内容を irb で一行ずつタイプしたかのように、irb 上で一
行ずつ評価されます。require に成功した場合は true を、そうでない場合は
false を返します。

拡張ライブラリ(*.so,*.o,*.dll など)を指定した場合は単純に require され
ます。

- **param** `file_name` -- ファイル名を文字列で指定します。

