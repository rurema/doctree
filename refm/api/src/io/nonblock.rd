#@if (version >= "1.8.0")
= reopen IO

== Instance Methods

--- nonblock?

self がノンブロックモードならば真を、ブロックモードなら偽を返す。

--- nonblock=(bool)

bool が真なら self をノンブロックモードに、偽ならブロックモー
ドにする。

--- nonblock(bool = true) { ... }

ブロック実行中、一時的に self のブロックモードを変更する。
bool が真ならノンブロックモード、偽ならブロックモードになる。
#@end
