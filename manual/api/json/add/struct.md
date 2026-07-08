---
type: library
---
[c:Struct] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Struct
## Singleton Methods

### def json_create(hash) -> Struct

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

Person = Struct.new(:name, :age)
Person.new("tanaka", 29).to_json # => "{\"json_class\":\"Person\",\"v\":[\"tanaka\",29]}"
```

- **SEE** [m:JSON::Generator::GeneratorMethods::Hash#to_json]
