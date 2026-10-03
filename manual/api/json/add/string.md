---
type: library
since: "4.0"
until: "4.1"
---
[c:String] に、生の文字列を JSON 形式の文字列に変換するメソッドや JSON のオブジェクトから文字列を生成するメソッドを定義します。

これらのメソッドは Ruby 3.4 までは [lib:json] を require するだけで定義されていました。

# reopen String
## Singleton Methods

### def String.json_create(hash) -> String
{: since="1.9.1"}

JSON のオブジェクトから Ruby の文字列を生成して返します。

- **param** `hash` -- キーとして "raw" という文字列を持ち、その値として数値の配列を持つハッシュを指定します。

```ruby title="例"
require 'json/add/string'

p String.json_create({"raw" => [0x41, 0x42, 0x43]}) # => "ABC"
```

## Public Instance Methods

### def to_json_raw(*args) -> String
{: since="1.9.1"}

`self` に対して [m:String#to_json_raw_object] を呼び出して [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] した結果を返します。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

- **SEE** [m:String#to_json_raw_object], [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

### def to_json_raw_object -> Hash
{: since="1.9.1"}

生の文字列を格納したハッシュを生成します。

このメソッドは UTF-8 の文字列ではなく生の文字列を JSON に変換する場合に使用してください。

```ruby title="例"
require 'json/add/string'

p "にほんご".encode("euc-jp").to_json_raw_object
# => {"json_class" => "String", "raw" => [164, 203, 164, 219, 164, 243, 164, 180]}
```
