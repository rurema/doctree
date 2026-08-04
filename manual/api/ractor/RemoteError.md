---
library: _builtin
since: "3.0"
---
# class Ractor::RemoteError < Ractor::Error

他の Ractor で発生した例外を、その結果を待っている Ractor に伝えるために発生します。

もとの例外は [m:Exception#cause] で取得できます。

```ruby
r = Ractor.new { raise "boom" }
begin
#%since 4.0
  r.value
#%else
  r.take
#%end
rescue Ractor::RemoteError => e
  p e.message       # => "thrown by remote Ractor."
  p e.cause.message # => "boom"
end
```

## Instance Methods

### def ractor -> Ractor

例外が発生した Ractor を返します。

- **SEE** [c:Ractor]
