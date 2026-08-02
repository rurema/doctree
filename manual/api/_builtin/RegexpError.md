---
library: _builtin
---
# class RegexpError < StandardError

正規表現のコンパイルに失敗したときに発生します。

```ruby
Regexp.compile("*")
# ~> RegexpError: target of repeat operator is not specified: /*/
```
