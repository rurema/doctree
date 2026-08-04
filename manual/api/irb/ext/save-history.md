---
type: library
until: "3.4"
---
[c:IRB::Context] にヒストリの読み込み、保存の機能を提供するサブライブラリです。

conf.save_history か IRB.conf[:SAVE_HISTORY] にヒストリの保存件数を設定する事で使用できます。

ただし、[lib:readline] が利用できない環境ではヒストリの読み込み、保存は行えません。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。

