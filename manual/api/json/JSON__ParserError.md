---
library: json
---
# class JSON::ParserError < JSON::JSONError

JSON のパースエラーを通知する例外です。

## Public Instance Methods

#%since 4.0
### def line -> Integer | nil
### def column -> Integer | nil

パースエラーが発生した位置の行番号と桁番号を返します。

#%since 4.1
`JSON::ResumableParser` によって発生した例外の場合は、いずれも nil を返します。

#%end

```ruby title="例"
require "json"

begin
  JSON.parse(%Q({"a": invalid}))
rescue JSON::ParserError => e
  e.line    # => 1
  e.column  # => 7
  e.message # => "unexpected character: 'invalid}' at line 1 column 7"
end
```

#%end

#%since 4.1
### def json_path -> String | nil

パースエラーが発生した位置を、JSON ドキュメント中の位置を表す JSONPath 形式の文字列
(例: `$.foo[0].bar`)で返します。キーが重複しているというエラーの場合は、
重複したキー`self` の位置を指します。

```ruby title="例"
require "json"

begin
  JSON.parse('{"articles": [ { "title": invalid } ]}')
rescue JSON::ParserError => error
  error.json_path # => "$.articles[0].title"
end
```

#%end

