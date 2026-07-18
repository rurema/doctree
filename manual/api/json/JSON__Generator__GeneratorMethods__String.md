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

state_or_hash で [m:JSON::State#ascii_only?] を真に指定するなどして
ASCII 以外の文字がエスケープされる場合、そのコードポイントを 16 進
数 4 桁で表した "\uXXXX" という形式になります。
基本多言語面(BMP)外の文字は、UTF-16 のサロゲートペア
として "\uXXXX\uXXXX" のように \u エスケープを 2 つ連ねて表されます。
返り値の [c:String] のエンコーディングは常に UTF-8 です。

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
p "にほんご".encode("euc-jp").to_json_raw_object
# => {"json_class"=>"String", "raw"=>[164, 203, 164, 219, 164, 243, 164, 180]}
"にほんご".encode("euc-jp").to_json # source sequence is illegal/malformed (JSON::GeneratorError)
```

