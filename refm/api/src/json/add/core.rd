
Ruby のコアクラスに JSON 形式の文字列に変換するメソッドや
JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

= reopen Time
== Singleton Methods

--- json_create(hash) -> Time

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

#@samplecode 例
require "json/add/core"

Time.now.to_json # => "{\"json_class\":\"Time\",\"s\":1544968675,\"n\":676167000}"
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]

= reopen Date
== Singleton Methods

--- json_create(hash) -> Date

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]


= reopen DateTime
== Singleton Methods

--- json_create(hash) -> DateTime

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

#@samplecode 例
require "json/add/core"

DateTime.now.to_json
# => "{\"json_class\":\"DateTime\",\"y\":2018,\"m\":12,\"d\":10,\"H\":1,\"M\":28,\"S\":57,\"of\":\"3/8\",\"sg\":2299161.0}"
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]


= reopen Range
== Singleton Methods

--- json_create(hash) -> Range

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

#@samplecode 例
require "json/add/core"

(1..5).to_json # => "{\"json_class\":\"Range\",\"a\":[1,5,false]}"
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]


= reopen Struct
== Singleton Methods

--- json_create(hash) -> Struct

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

#@samplecode 例
require "json/add/core"

Person = Struct.new(:name, :age)
Person.new("tanaka", 29).to_json # => "{\"json_class\":\"Person\",\"v\":[\"tanaka\",29]}"
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]


= reopen Exception
== Singleton Methods

--- json_create(hash) -> Exception

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

#@samplecode 例
require "json/add/core"

begin
  0/0
rescue => e
  e.to_json # => "{\"json_class\":\"ZeroDivisionError\",\"m\":\"divided by 0\",\"b\":[\"/path/to/test.rb:4:in `/'\",\"/path/to/test.rb:4:in `<main>'\"]}"
end
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]


= reopen Regexp
== Singleton Methods

--- json_create(hash) -> Regexp

JSON のオブジェクトから Ruby のオブジェクトを生成して返します。

@param hash 適切なキーを持つハッシュを指定します。

== Public Instance Methods

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数には何の意味もありません。

#@samplecode 例
require "json/add/core"

/0\d{1,4}-\d{1,4}-\d{4}/.to_json # => "{\"json_class\":\"Regexp\",\"o\":0,\"s\":\"0\\\\d{1,4}-\\\\d{1,4}-\\\\d{4}\"}"
#@end
