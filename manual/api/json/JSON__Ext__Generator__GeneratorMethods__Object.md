---
library: json
---
# module JSON::Ext::Generator::GeneratorMethods::Object

[c:Object] に JSON で使用するインスタンスメソッドを追加するためのモジュールです。

## Public Instance Methods
### def to_json(state_or_hash = nil) -> String

自身を to_s で文字列にした結果を JSON 形式の文字列に変換して返します。

このメソッドはあるオブジェクトに to_json メソッドが定義されていない場合に使用するフォールバックのためのメソッドです。

- **param** `state_or_hash` -- 生成する JSON 形式の文字列をカスタマイズするために [c:JSON::State] のインスタンスか、
                     [m:JSON::State.new] の引数と同じ [c:Hash] を指定します。

```ruby title="例"
require "json"

class Person
  attr :name, :age

  def initialize(name, age)
    @name, @age = name, age
  end
end

tanaka = Person.new("tanaka", 29)

p tanaka.to_json # => "\"#<Person:0x00007ffdec0167c8>\""
p tanaka.method(:to_json).owner # => JSON::Ext::Generator::GeneratorMethods::Object
```

