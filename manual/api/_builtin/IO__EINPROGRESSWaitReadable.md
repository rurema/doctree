---
library: _builtin
include:
  - IO::WaitReadable
---
# class IO::EINPROGRESSWaitReadable < Errno::EINPROGRESS

ノンブロッキングな I/O 処理が読み込み待ちの状態で `EINPROGRESS` を検出
したときに発生する例外です。

[c:Errno::EINPROGRESS] のサブクラスであり [c:IO::WaitReadable] を include
しているため、`rescue IO::WaitReadable` と `rescue Errno::EINPROGRESS` の
どちらでも捕捉できます。同様の例外を発生させるたびに [m:Object#extend]
するのではなく、あらかじめ [c:IO::WaitReadable] を include したこの専用
クラスのインスタンスを生成することで実現されています。

- **SEE** [c:IO::WaitReadable], [c:IO::EINPROGRESSWaitWritable]
