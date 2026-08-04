---
library: _builtin
since: "3.1"
---
# class IO::Buffer::LockedError < RuntimeError

ロックされている [c:IO::Buffer] に対して、ロック中は行えない操作をした場合に発生します。

具体的には、ロック中のバッファをリサイズしようとした場合や、所有権を移そうとした場合、既にロックされているバッファを再度ロックしようとした場合などです。

```ruby
buf = IO::Buffer.new(4)
buf.locked do |b|
  b.resize(8)  # ~> IO::Buffer::LockedError
end
```

- **SEE** [c:IO::Buffer], [m:IO::Buffer::LOCKED]
