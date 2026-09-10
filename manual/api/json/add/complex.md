---
type: library
---
[c:Complex] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Complex
## Singleton Methods

### def Complex.json_create(hash) -> Complex

JSON のオブジェクトから [c:Complex] のオブジェクトを生成して返します。

- **param** `hash` -- 実部をキー 'r'、虚部をキー 'i' に持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]
            に渡されます。

```ruby title="例"
require 'json/add/complex'
p (2+3i).to_json # => "{\"json_class\":\"Complex\",\"r\":2,\"i\":3}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Complex#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'r'` に実部が、
`'i'` に虚部が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/complex'

hash = Complex(2, 3).as_json
hash['json_class'] # => "Complex"
hash['r']           # => 2
hash['i']           # => 3
```

- **SEE** [m:Complex#to_json], [m:Complex.json_create]

#%end

