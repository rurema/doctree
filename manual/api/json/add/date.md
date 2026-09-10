---
type: library
require:
  - date
---
[c:Date] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Date
## Singleton Methods

### def Date.json_create(hash) -> Date

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

p Date.today.to_json
# => "{\"json_class\":\"Date\",\"y\":2018,\"m\":12,\"d\":11,\"sg\":2299161.0}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Date#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'y'` に年([m:Date#year])、
`'m'` に月([m:Date#month])、`'d'` に日([m:Date#day])、`'sg'` に改暦日
([m:Date#start])が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/date'

hash = Date.new(2024, 1, 2).as_json
hash['json_class'] # => "Date"
hash['y']           # => 2024
hash['m']           # => 1
hash['d']           # => 2
hash['sg']          # => 2299161.0
```

- **SEE** [m:Date#to_json], [m:Date.json_create]

#%end

