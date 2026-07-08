---
type: library
require:
  - readline
---
[c:IRB::Context] にヒストリの読み込み、保存の機能を提供するサブライブ
ラリです。

conf.save_history か IRB.conf[:SAVE_HISTORY] にヒストリの保存件数を設定
する事で使用できます。

ただし、[lib:readline] が利用できない環境ではヒストリの読み込み、保存
は行えません。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

