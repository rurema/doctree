---
library: _builtin
since: "3.1"
---
# class IO::Buffer::AccessError < RuntimeError

書き込みできない [c:IO::Buffer] に書き込もうとした場合や、外部(external)のバッファをリサイズしようとした場合に発生します。

```ruby
buf = IO::Buffer.for("abc")
p buf.readonly?      # => true
buf.set_string("z")  # ~> IO::Buffer::AccessError
```

- **SEE** [c:IO::Buffer], [m:IO::Buffer::READONLY]
