---
library: _builtin
since: "3.2"
---
# class IO::Buffer::MaskError < ArgumentError

[c:IO::Buffer] のビット演算に渡したマスクが不正な場合に発生します。

具体的には、長さ 0 のバッファをマスクに指定した場合や、マスクが演算対象のバッファと重なっている場合です。

```ruby
IO::Buffer.new(4) & IO::Buffer.new(0) # ~> IO::Buffer::MaskError
```

- **SEE** [c:IO::Buffer]
