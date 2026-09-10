---
type: library
---
[c:Rational] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Rational
## Singleton Methods

### def Rational.json_create(hash) -> Rational

JSON のオブジェクトから [c:Rational] のオブジェクトを生成して返します。

- **param** `hash` -- 分子をキー 'n'、分母をキー 'd' に持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]
            に渡されます。

```ruby title="例"
require 'json/add/rational'
p (1/3r).to_json # => "{\"json_class\":\"Rational\",\"n\":1,\"d\":3}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Rational#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'n'` に分子が、
`'d'` に分母が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/rational'

hash = Rational(2, 3).as_json
hash['json_class'] # => "Rational"
hash['n']           # => 2
hash['d']           # => 3
```

- **SEE** [m:Rational#to_json], [m:Rational.json_create]

#%end

