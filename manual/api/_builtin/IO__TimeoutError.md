---
library: _builtin
since: "3.2"
---
# class IO::TimeoutError < IOError

入出力の操作が [m:IO#timeout=] で設定した時間を超えたときに発生します。

```ruby
r, w = IO.pipe
r.timeout = 0.1

r.read # ~> IO::TimeoutError
```

- **SEE** [m:IO#timeout=], [m:IO#timeout]
