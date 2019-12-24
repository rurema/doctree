[[c:Regexp]] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

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
