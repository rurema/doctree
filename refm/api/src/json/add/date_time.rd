require date

[[c:DateTime]] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

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
