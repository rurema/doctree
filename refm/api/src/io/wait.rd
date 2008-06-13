#@if (version >= "1.8.0")
IOが読み込み可能になるまで待つ機能を提供するライブラリです。

= reopen IO

== Instance Methods

--- ready?
#@todo

ブロックせずに読み込み可能なら真を返します。そうでなければ nil を返します。
self が EOF に達していれば false を返します。

--- wait([timeout = nil])
#@todo

self が読み込み可能になるまでブロックし、読み込み可能になったら
self を返します。

timeout を指定した場合は、指定秒数経過するまでブロックし、タ
イムアウトした場合は nil を返します。

self が EOF に達していれば false を返します。
#@end
