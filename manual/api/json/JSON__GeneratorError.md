---
library: json
alias:
  - JSON::UnparserError
---
# class JSON::GeneratorError < JSON::JSONError

JSON 形式の文字列を生成するときに発生したエラーを通知する例外です。

## Public Instance Methods

#%since 3.4
### def invalid_object -> object

JSON 形式の文字列に変換できなかったオブジェクトを返します。
どのオブジェクトが原因でエラーになったのかを調べる助けになります。

```ruby title="例"
require "json"

begin
  JSON.generate([Object.new], strict: true)
rescue JSON::GeneratorError => e
  e.invalid_object.class # => Object
  e.message               # => "Object not allowed in JSON"
end
```

#%end

