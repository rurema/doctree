#@if (version >= "1.8.0")
IOのノンブロックモードを扱うライブラリです。

= reopen IO

== Instance Methods

--- nonblock?
#@todo

self がノンブロックモードならば真を、ブロックモードなら偽を返す。

--- nonblock=(bool)
#@todo

bool が真なら self をノンブロックモードに、偽ならブロックモー
ドにする。

--- nonblock(bool = true) { ... }
#@todo

ブロック実行中、一時的に self のブロックモードを変更する。
bool が真ならノンブロックモード、偽ならブロックモードになる。
#@end
