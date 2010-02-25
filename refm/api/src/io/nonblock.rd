IOのノンブロックモードを扱うライブラリです。

= reopen IO

== Instance Methods

--- nonblock? -> bool
self がノンブロックモードならばtrueを、
ブロックモードならfalseを返します。

--- nonblock=(bool) -> Integer
bool が真なら self をノンブロックモードに、偽ならブロックモー
ドにします。

--- nonblock(bool = true) { ... } -> object

ブロック実行中、一時的に self のブロックモードを変更します。
bool が真ならノンブロックモード、偽ならブロックモードになります。

