---
type: library
---
[c:Symbol] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Symbol
## Singleton Methods

### def Symbol.json_create(hash) -> Symbol

JSON のオブジェクトから [c:Symbol] のオブジェクトを生成して返します。

- **param** `hash` -- 文字列をキー 's' に持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Symbol#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'s'` に `self` を文字列化した
値([m:Symbol#to_s] の返り値)が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/symbol'

hash = :foo.as_json
hash['json_class'] # => "Symbol"
hash['s']           # => "foo"
```

- **SEE** [m:Symbol#to_json], [m:Symbol.json_create]

#%end

