---
library: json
---
# module JSON::Ext::Generator::GeneratorMethods::TrueClass

[c:TrueClass] に JSON で使用するインスタンスメソッドを追加するためのモジュールです。

## Public Instance Methods
### def to_json(state_or_hash = nil) -> String

自身から生成した JSON 形式の文字列を返します。

"true" という文字列を返します。

- **param** `state_or_hash` -- 生成する JSON 形式の文字列をカスタマイズするために [c:JSON::State] のインスタンスか、
                     [m:JSON::State.new] の引数と同じ [c:Hash] を指定します。

```ruby title="例"
require "json"

p true.to_json # => "true"
```
