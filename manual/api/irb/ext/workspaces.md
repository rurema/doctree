---
type: library
---
[c:IRB::Context] に irb 中での self を管理する機能を提供するサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。
#%until 3.4
[lib:irb/cmd/pushws] から呼び出されます。
#%end
