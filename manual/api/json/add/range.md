---
type: library
---
[c:Range] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Range
## Singleton Methods

### def Range.json_create(hash) -> Range

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

p (1..5).to_json # => "{\"json_class\":\"Range\",\"a\":[1,5,false]}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Range#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'a'` に
始端・終端・終端を含むかどうかの 3 要素からなる配列(`[first, last, exclude_end?]`)が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/range'

hash = (1..5).as_json
hash['json_class'] # => "Range"
hash['a']           # => [1, 5, false]
```

- **SEE** [m:Range#to_json], [m:Range.json_create]

#%end

