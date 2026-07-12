---
type: library
category: FileFormat
---
JSON (JavaScript Object Notation)を扱うライブラリです。

このライブラリでは、[c:JSON] モジュールに JSON を操作するための代表的なメソッドが集められています。
詳細は [c:JSON] モジュールを参照してください。

JSON の仕様は [rfc:7159] を参照してください。

```ruby title="例"
require "json"

# JSON文字列をRubyのオブジェクトに変換する
json_str = '{"name": "Ruby", "age": 30}'
p JSON.parse(json_str) # => {"name"=>"Ruby", "age"=>30}

# RubyのオブジェクトをJSON文字列に変換する
data = {"name" => "Ruby", "age" => 30}
p JSON.dump(data) # => "{\"name\":\"Ruby\",\"age\":30}"
```

