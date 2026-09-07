---
type: library
---
[c:Regexp] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Regexp
## Singleton Methods

### def Regexp.json_create(hash) -> Regexp

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]
            に渡されます。

```ruby title="例"
require "json/add/core"

p /0\d{1,4}-\d{1,4}-\d{4}/.to_json # => "{\"json_class\":\"Regexp\",\"o\":0,\"s\":\"0\\\\d{1,4}-\\\\d{1,4}-\\\\d{4}\"}"
```

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Regexp#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'o'` に
オプションを表す整数([m:Regexp#options] の返り値)が、`'s'` にパターン文字列
([m:Regexp#source] の返り値)が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/regexp'

hash = /foo/i.as_json
hash['json_class'] # => "Regexp"
hash['o']           # => 1
hash['s']           # => "foo"
```

- **SEE** [m:Regexp#to_json], [m:Regexp.json_create]

#%end

