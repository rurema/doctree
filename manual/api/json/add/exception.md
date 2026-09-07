---
type: library
---
[c:Exception] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

# reopen Exception
## Singleton Methods

### def Exception.json_create(hash) -> Exception

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

- **param** `hash` -- 適切なキーを持つハッシュを指定します。

## Public Instance Methods

### def to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] を呼び出しています。

- **param** `args` -- 引数はそのまま [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json] に渡されます。

```ruby title="例"
require "json/add/core"

begin
  0/0
rescue => e
#%since 3.4
  e.to_json # => "{\"json_class\":\"ZeroDivisionError\",\"m\":\"divided by 0\",\"b\":[\"/path/to/test.rb:4:in '/'\",\"/path/to/test.rb:4:in '<main>'\"]}"
#%else
  e.to_json # => "{\"json_class\":\"ZeroDivisionError\",\"m\":\"divided by 0\",\"b\":[\"/path/to/test.rb:4:in `/'\",\"/path/to/test.rb:4:in `<main>'\"]}"
#%end
end
```

- **SEE** [m:JSON::Ext::Generator::GeneratorMethods::Hash#to_json]

#%until 4.1
### def as_json(*args) -> Hash

`self` を JSON 形式の文字列に変換する際に使う、中間表現となるハッシュに変換して返します。
[m:Exception#to_json] が内部で使用しています。

ハッシュには、[m:JSON.create_id] をキーとしてクラス名が、`'m'` にメッセージが、
`'b'` にバックトレースが入ります。

- **param** `args` -- 無視されます。

```ruby title="例"
require 'json/add/exception'

hash = Exception.new('Foo').as_json
hash['json_class'] # => "Exception"
hash['m']           # => "Foo"
hash['b']           # => nil
```

- **SEE** [m:Exception#to_json], [m:Exception.json_create]

#%end

