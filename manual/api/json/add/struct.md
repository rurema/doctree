---
type: library
---
[c:Struct] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Struct
## Singleton Methods

### def Struct.json_create(hash) -> Struct

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

Person = Struct.new(:name, :age)
p Person.new("tanaka", 29).to_json # => "{\"json_class\":\"Person\",\"v\":[\"tanaka\",29]}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Struct#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとして `self` のクラス名が、`'v'` に各メンバの値の
配列([m:Struct#values] の返り値)が入ります。

- **param** `args` -- 無視されます。

- **raise** `JSON::JSONError` -- `self` のクラスが名前を持たない(無名の)構造体クラスの
           場合に発生します。

```ruby title="例"
require 'json/add/struct'

Person = Struct.new(:name, :age)
hash = Person.new("tanaka", 29).as_json
hash['json_class'] # => "Person"
hash['v']           # => ["tanaka", 29]
```

- **SEE** [m:Struct#to_json], [m:Struct.json_create]

#%end

