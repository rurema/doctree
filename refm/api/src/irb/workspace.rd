#@# IRB.conf[:CONTEXT_MODE] に 2 を設定した場合のみ。
require irb/ws-for-case-2

irb 中で self を扱うためのサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。

= class IRB::WorkSpace

irb 中で self を表すためのクラスです。
