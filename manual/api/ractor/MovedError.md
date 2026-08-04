---
library: _builtin
since: "3.0"
---
# class Ractor::MovedError < Ractor::Error

他の Ractor に移動(move)されたオブジェクトにアクセスした場合に発生します。

[m:Ractor#send] に `move: true` を指定してオブジェクトを送ると、送った側ではそのオブジェクトが [c:Ractor::MovedObject] に置き換わり、以後アクセスできなくなります。

```ruby
s = +"hello"
r = Ractor.new { Ractor.receive }
r.send(s, move: true)
s.upcase # ~> Ractor::MovedError
```

- **SEE** [c:Ractor], [c:Ractor::MovedObject], [m:Ractor#send]
