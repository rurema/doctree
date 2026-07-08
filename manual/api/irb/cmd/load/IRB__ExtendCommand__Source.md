---
library: irb/cmd/load
include:
  - IRB::IrbLoader
---
# class IRB::ExtendCommand::Source < IRB::ExtendCommand::Nop

irb 中の irb_source コマンドのための拡張を定義したクラスです。

## Instance Methods

### def execute(file_name) -> nil

現在の irb インタプリタ上で、 Ruby スクリプト path を評価します。

path の内容を irb で一行ずつタイプしたかのように、irb 上で一行ずつ評価
されます。[m:$"] は更新されず、何度でも実行し直す事ができます。

- **param** `file_name` -- ファイル名を文字列で指定します。
