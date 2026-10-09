---
type: library
require:
#%until 3.2
  - set
#%end
since: "2.7"
until: "4.1"
---
[c:Set] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Set
## Singleton Methods

### def Set.json_create(object) -> Set
{: since="2.7.0"}

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `object` -- キー `'a'` に要素の配列を持つハッシュを指定します。

```ruby title="例"
require 'json/add/set'

set = Set.json_create({"json_class" => "Set", "a" => [1, 2, 3]})
#%since 4.0
p set # => Set[1, 2, 3]
#%else
p set # => #<Set: {1, 2, 3}>
#%end
```

## Public Instance Methods

### def to_json(*args) -> String
{: since="2.7.0"}

自身を JSON 形式の文字列に変換して返します。

内部的には [m:Set#as_json] で得たハッシュに対して [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require 'json/add/set'

p Set[1, 2, 3].to_json # => "{\"json_class\":\"Set\",\"a\":[1,2,3]}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

### def as_json(*args) -> Hash
{: since="2.7.0"}

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Set#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'a'` に要素の配列が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/set'

hash = Set[1, 2, 3].as_json
p hash['json_class'] # => "Set"
p hash['a']          # => [1, 2, 3]
```

- **SEE** [m:Set#to_json], [m:Set.json_create]
