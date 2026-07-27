---
library: _builtin
since: "3.0"
---
# class Ractor::ClosedError < StopIteration

閉じられた Ractor のポートに対して送受信を行おうとした場合に発生します。

[c:StopIteration] のサブクラスであるため、[m:Kernel?.loop] の中で発生した
場合はループを終了させます。他の Ractor に関する例外と異なり、
[c:Ractor::Error] のサブクラスではないことに注意してください。

```ruby
r = Ractor.new do
#%since 4.0
  Ractor.current.close
#%else
  Ractor.current.close_incoming
#%end
  Ractor.receive # ここで Ractor::ClosedError が発生する
end

begin
#%since 4.0
  r.value
#%else
  r.take
#%end
rescue Ractor::RemoteError => e
  # 他の Ractor で発生した例外は Ractor::RemoteError に包まれて伝わる
  p e.cause.class # => Ractor::ClosedError
end
```

- **SEE** [c:Ractor], [c:StopIteration]
