[[c:Rational]] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

= reopen Rational
== Singleton Methods

--- json_create(hash) -> Rational

JSON のオブジェクトから [[c:Rational]] のオブジェクトを生成して返します。

@param hash 分子をキー 'n'、分母をキー 'd' に持つハッシュを指定します。

== Public Instance Methods

#@# --- as_json(*args) -> Hash
#@#
#@# Returns a hash, that will be turned into a JSON object and
#@# represent this object.

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

#@since 2.7.0
@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]
            に渡されます。
#@else
@param args 使用しません。
#@end

#@samplecode 例
require 'json/add/rational'
Rational(1, 3).to_json # => "{\"json_class\":\"Rational\",\"n\":1,\"d\":3}"
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]
