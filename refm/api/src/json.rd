#@since 1.9.1

category FileFormat

JSON (JavaScript Object Notation)を扱うライブラリです。

JSON の仕様は [[rfc:4627]] を参照してください。

#@until 1.9.2
拡張ライブラリによる実装と Ruby による実装があり、拡張ライブラリによる実装が使用できるときは
拡張ライブラリによる実装を使用します。
Ruby による実装は [[lib:iconv]] と [[lib:strscan]] に依存しています。
#@end

#@include(json/JSON)
#@include(json/JSON__Generator__GeneratorMethods)
#@include(json/JSON__Parser)
#@include(json/JSON__State)

= reopen Kernel

== Private Instance Methods

--- j(*objects) -> nil

与えられたオブジェクトを JSON 形式の文字列で標準出力に一行で出力します。

@param objects JSON 形式で出力したいオブジェクトを指定します。

#@samplecode 例
require "json"

j([1,2,{"name" => "tanaka","age" => 19}])
# => [1,2,{"name":"tanaka","age":19}]
#@end

@see [[m:Kernel.#p]]

--- jj(*objects) -> nil

与えられたオブジェクトを JSON 形式の文字列で標準出力に人間に読みやすく整形して出力します。

@param objects JSON 形式で出力したいオブジェクトを指定します。

#@samplecode 例
require "json"

jj([1,2,{"name" => "tanaka","age" => 19}])
# => [
#      1,
#      2,
#      {
#        "name": "tanaka",
#        "age": 19
#      }
#    ]
#@end

@see [[m:Kernel.#pp]]

--- JSON(object, options = {}) -> object

第一引数に与えられたオブジェクトの種類によって Ruby のオブジェクトか JSON 形式の文字列を返します。

第一引数に文字列のようなオブジェクトを指定した場合は、それを [[m:JSON.#parse]] を用いてパースした結果を返します。
そうでないオブジェクトを指定した場合は、それを [[m:JSON.#generate]] を用いて変換した結果を返します。

@param object 任意のオブジェクトを指定します。

@param options [[m:JSON.#parse]], [[m:JSON.#generate]] に渡すオプションを指定します。

@see [[m:JSON.#parse]], [[m:JSON.#generate]]

= reopen Class

== Public Instance Methods

--- json_creatable? -> bool

シリアライズされた JSON 形式の文字列から、インスタンスを作成するのにこのクラスを使用できる場合は
真を返します。そうでない場合は、偽を返します。

このメソッドが真を返すクラスは json_create というメソッドを実装していなければなりません。
また json_create の第一引数は必要なデータを含むハッシュを期待しています。

= reopen Array
include JSON::Generator::GeneratorMethods::Array

= reopen FalseClass
include JSON::Generator::GeneratorMethods::FalseClass

= reopen Float
include JSON::Generator::GeneratorMethods::Float

= reopen Hash
include JSON::Generator::GeneratorMethods::Hash

= reopen Integer
include JSON::Generator::GeneratorMethods::Integer

= reopen NilClass
include JSON::Generator::GeneratorMethods::NilClass

= reopen Object
include JSON::Generator::GeneratorMethods::Object

= reopen String
extend JSON::Generator::GeneratorMethods::String::Extend
include JSON::Generator::GeneratorMethods::String

= reopen TrueClass
include JSON::Generator::GeneratorMethods::TrueClass

#@end
