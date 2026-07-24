---
library: _builtin
since: "3.0"
---
# class Ractor::IsolationError < Ractor::Error

shareable にできないオブジェクトを shareable にしようとした場合に発生します。

#@since 3.1

```ruby
Ractor.make_shareable(proc { }) # ~> Ractor::IsolationError
```

#@else
#@#noexample 3.0 では Ractor.make_shareable に Proc を渡しても例外にならないため
#@end

- **SEE** [c:Ractor], [m:Ractor.make_shareable]
