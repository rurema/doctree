---
library: json
since: "4.0"
---
# class JSON::Fragment < Struct

既に JSON 形式になっている文字列を、変換せずにそのまま出力に埋め込むためのクラスです。

[m:JSON?.generate] や [m:JSON::Coder#dump] で変換するオブジェクトの中にこのクラスのインスタンスがあると、`json` の内容がそのまま挿入されます。
生成済みの JSON 形式の文字列をキャッシュしておき、組み合わせて出力するような用途に使います。

内容の検証やエスケープは行いません。`ascii_only` や `script_safe` などの生成オプションは内容には適用されず、[m:JSON?.pretty_generate] でもインデントされません。`strict` が真のときも使用できます。[m:JSON::State#as_json=] に設定した `Proc` や [m:JSON::Coder.new] のブロックの返り値としても使用できます。

```ruby title="例"
require "json"

cached = JSON::Fragment.new('{"a":1}')
p cached.json                              # => "{\"a\":1}"
p cached.to_json                           # => "{\"a\":1}"
p JSON.generate({"x" => cached, "y" => 2}) # => "{\"x\":{\"a\":1},\"y\":2}"
p JSON.generate([cached], strict: true)    # => "[{\"a\":1}]"
puts JSON.pretty_generate({"x" => cached, "y" => 2})
# => {
#      "x": {"a":1},
#      "y": 2
#    }
```

```ruby title="例 内容は検証もエスケープもされない"
require "json"

p JSON.generate([JSON::Fragment.new('"é"'), "é"], ascii_only: true)      # => "[\"é\",\"\\u00e9\"]"
p JSON.generate([JSON::Fragment.new('"a/b"'), "a/b"], script_safe: true) # => "[\"a/b\",\"a\\/b\"]"
p JSON.generate([JSON::Fragment.new("not json")])                        # => "[not json]"
```

## Singleton Methods

### def JSON::Fragment.new(json) -> JSON::Fragment

自身を初期化します。

- **param** `json` -- 埋め込む JSON 形式の文字列を指定します。内容は検証されません。

- **raise** `TypeError` -- `json` が文字列でない場合に発生します。

## Public Instance Methods

### def json -> String

埋め込む JSON 形式の文字列を返します。

### def json=(string)

埋め込む JSON 形式の文字列を設定します。

- **param** `string` -- 埋め込む JSON 形式の文字列を指定します。

### def to_json(state = nil, *args) -> String

`json` の内容をそのまま返します。

[m:JSON?.generate] などから呼び出されます。

- **param** `state` -- [c:JSON::State] を指定しますが使用しません。

- **param** `args` -- 無視されます。
