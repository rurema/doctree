---
library: json
alias:
  - JSON::Ext::Generator::GeneratorMethods::Float
---
# module JSON::Generator::GeneratorMethods::Float

[c:Float] に JSON で使用するインスタンスメソッドを追加するためのモジュールです。

## Public Instance Methods
### def to_json(state_or_hash = nil) -> String

自身から生成した JSON 形式の文字列を返します。

- **param** `state_or_hash` -- 生成する JSON 形式の文字列をカスタマイズするため
                     に [c:JSON::State] のインスタンスか、
                     [m:JSON::State.new] の引数と同じ [c:Hash] を
                     指定します。

```ruby title="例"
require "json"

(1.0).to_json # => "1.0"
```

