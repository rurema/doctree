---
library: json
alias:
  - JSON::Ext::Generator::GeneratorMethods::String::Extend
---
# module JSON::Generator::GeneratorMethods::String::Extend

[c:String] に JSON で使用する特異メソッドを追加するためのモジュールです。

## Class Methods
### def json_create(hash) -> String

JSON のオブジェクトから Ruby の文字列を生成して返します。

- **param** `hash` -- キーとして "raw" という文字列を持ち、その値として数値の配列を持つハッシュを指定します。

```ruby
require 'json'
p String.json_create({"raw" => [0x41, 0x42, 0x43]}) # => "ABC"
```

