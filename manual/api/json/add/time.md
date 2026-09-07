---
type: library
---
[c:Time] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Time
## Singleton Methods

### def Time.json_create(hash) -> Time

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

p Time.now.to_json # => "{\"json_class\":\"Time\",\"s\":1544968675,\"n\":676167000}"
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Time#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'s'` に 1970-01-01 からの
経過秒数([m:Time#tv_sec] の返り値)が、`'n'` にナノ秒未満の端数([m:Time#tv_nsec] の
返り値)が入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/time'

t = Time.at(1700000000, 123456, :usec)
hash = t.as_json
hash['json_class'] # => "Time"
hash['s']           # => 1700000000
hash['n']           # => 123456000
```

- **SEE** [m:Time#to_json], [m:Time.json_create]

#%end

