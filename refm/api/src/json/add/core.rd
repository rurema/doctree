
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


