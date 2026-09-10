---
type: library
require:
  - date
---
[c:DateTime] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen DateTime
## Singleton Methods

### def DateTime.json_create(hash) -> DateTime

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

p DateTime.now.to_json
# => "{\"json_class\":\"DateTime\",\"y\":2018,\"m\":12,\"d\":10,\"H\":1,\"M\":28,\"S\":57,\"of\":\"3/8\",\"sg\":2299161.0}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:DateTime#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'y'` に年([m:Date#year])、
`'m'` に月([m:Date#month])、`'d'` に日([m:Date#day])、`'H'` に時
([m:DateTime#hour])、`'M'` に分([m:DateTime#min])、`'S'` に秒
([m:DateTime#sec])、`'of'` に UTC からのオフセット([m:DateTime#offset] の
返り値を文字列化したもの)、`'sg'` に改暦日([m:Date#start])が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/date_time'

hash = DateTime.new(2024, 1, 2, 3, 4, 5).as_json
hash['json_class'] # => "DateTime"
hash['y']           # => 2024
hash['H']           # => 3
hash['of']          # => "0/1"
hash['sg']          # => 2299161.0
```

- **SEE** [m:DateTime#to_json], [m:DateTime.json_create]

#%end

