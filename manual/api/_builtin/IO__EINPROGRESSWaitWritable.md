---
library: _builtin
include:
  - IO::WaitWritable
---
# class IO::EINPROGRESSWaitWritable < Errno::EINPROGRESS

[m:Socket#connect_nonblock] などのノンブロッキングな接続処理が完了を
待っている状態で `EINPROGRESS` を検出したときに発生する例外です。

[c:Errno::EINPROGRESS] のサブクラスであり [c:IO::WaitWritable] を include
しているため、`rescue IO::WaitWritable` と `rescue Errno::EINPROGRESS` の
どちらでも捕捉できます。同様の例外を発生させるたびに [m:Object#extend]
するのではなく、あらかじめ [c:IO::WaitWritable] を include したこの専用
クラスのインスタンスを生成することで実現されています。

- **SEE** [c:IO::WaitWritable], [m:Socket#connect_nonblock]
