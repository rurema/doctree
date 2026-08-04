---
library: _builtin
since: "3.1"
---
# class IO::Buffer::InvalidatedError < RuntimeError

無効になった [c:IO::Buffer] を使用しようとした場合に発生します。

バッファが指しているメモリ領域が既に解放されているなど、そのバッファがもう使用できない状態になっていることを表します。

- **SEE** [c:IO::Buffer]
