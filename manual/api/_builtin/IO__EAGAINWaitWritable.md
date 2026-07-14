---
library: _builtin
include:
  - IO::WaitWritable
---
# class IO::EAGAINWaitWritable < Errno::EAGAIN

[m:IO#write_nonblock] などのノンブロッキング I/O が書き込み待ちの状態で
`EAGAIN` を検出したときに発生する例外です。

[c:Errno::EAGAIN] のサブクラスであり [c:IO::WaitWritable] を include して
いるため、`rescue IO::WaitWritable` と `rescue Errno::EAGAIN` のどちらでも
捕捉できます。同様の例外を発生させるたびに [m:Object#extend] するのでは
なく、あらかじめ [c:IO::WaitWritable] を include したこの専用クラスの
インスタンスを生成することで実現されています。

- **SEE** [c:IO::WaitWritable], [m:IO#write_nonblock]
