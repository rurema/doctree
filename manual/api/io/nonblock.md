---
type: library
category: I/O
---
IO のノンブロックモードを扱うライブラリです。

# reopen IO

## Instance Methods

### def nonblock? -> bool

self がノンブロックモードならば true を、
ブロックモードなら false を返します。

### def nonblock=(bool)

bool が真なら self をノンブロックモードに、偽ならブロックモー
ドにします。

- **param** `bool` -- 真を指定すると自身をノンブロックモードにします。偽を指定するとブロックモードにします。

### def nonblock(bool = true) { ... } -> object

ブロック実行中、一時的に self のブロックモードを変更します。
bool が真ならノンブロックモード、偽ならブロックモードになります。

- **param** `bool` -- 真を指定するとノンブロックモード、偽を指定するとブロックモードになります。

