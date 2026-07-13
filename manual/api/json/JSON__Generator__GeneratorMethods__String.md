---
library: json
alias:
  - JSON::Ext::Generator::GeneratorMethods::String
---
# module JSON::Generator::GeneratorMethods::String

[c:String] に JSON で使用するインスタンスメソッドを追加するためのモジュールです。

## Public Instance Methods
### def to_json(state_or_hash = nil) -> String

自身から生成した JSON 形式の文字列を返します。

自身のエンコードは UTF-8 であるべきです。
"\u????" のように UTF-16 ビッグエンディアンでエンコードされた文字列を返すことがあります。

- **param** `state_or_hash` -- 生成する JSON 形式の文字列をカスタマイズするため
                     に [c:JSON::State] のインスタンスか、
                     [m:JSON::State.new] の引数と同じ [c:Hash] を
                     指定します。

```ruby title="例"
require "json"

puts "test".to_json                    # => "test"
puts '"'.to_json                       # => "\""
puts "\\".to_json                      # => "\\"
puts "𤘩宮城".to_json(ascii_only: true) # => "\ud851\ude29\u5bae\u57ce"
```

### def to_json_raw -> String

自身に対して [m:JSON::Generator::GeneratorMethods::String#to_json_raw_object] を呼び出して [m:JSON::Generator::GeneratorMethods::Hash#to_json] した結果を返します。

- **SEE** [m:JSON::Generator::GeneratorMethods::String#to_json_raw_object], [m:JSON::Generator::GeneratorMethods::Hash#to_json]

### def to_json_raw_object -> Hash

生の文字列を格納したハッシュを生成します。

このメソッドは UTF-8 の文字列ではなく生の文字列を JSON に変換する場合に使用してください。

```ruby
require 'json'
"にほんご".encode("euc-jp").to_json_raw_object
# => {"json_class"=>"String", "raw"=>[164, 203, 164, 219, 164, 243, 164, 180]}
"にほんご".encode("euc-jp").to_json # source sequence is illegal/malformed (JSON::GeneratorError)
```

