---
library: _builtin
include:
  - IO::WaitReadable
---
# class IO::EAGAINWaitReadable < Errno::EAGAIN

[m:IO#read_nonblock] などのノンブロッキング I/O が読み込み待ちの状態で
`EAGAIN` を検出したときに発生する例外です。

[c:Errno::EAGAIN] のサブクラスであり [c:IO::WaitReadable] を include して
いるため、`rescue IO::WaitReadable` と `rescue Errno::EAGAIN` のどちらでも
捕捉できます。同様の例外を発生させるたびに [m:Object#extend] するのでは
なく、あらかじめ [c:IO::WaitReadable] を include したこの専用クラスの
インスタンスを生成することで実現されています。

- **SEE** [c:IO::WaitReadable], [m:IO#read_nonblock]
