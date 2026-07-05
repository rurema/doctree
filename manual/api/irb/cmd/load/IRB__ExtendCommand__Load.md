---
library: irb/cmd/load
include:
  - IRB::IrbLoader
---
# class IRB::ExtendCommand::Load < IRB::ExtendCommand::Nop

irb 中の irb_load コマンドのための拡張を定義したクラスです。

## Instance Methods

### def execute(file_name, priv = nil) -> nil

ファイル path を Ruby スクリプトとみなし、現在の irb インタプリタ上で実
行します。

[m:Kernel?.load] と異なり、path の内容を irb で一行ずつタイプしたかの
ように、irb 上で一行ずつ評価されます。

- **param** `file_name` -- ファイル名を文字列で指定します。

- **param** `priv` -- 真を指定した場合は実行は内部的に生成される無名モジュール上
            で行われ、グローバルな名前空間を汚染しません。

- **raise** `LoadError` -- 読み込みに失敗した場合に発生します。

