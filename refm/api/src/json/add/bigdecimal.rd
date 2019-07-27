require bigdecimal

[[c:BigDecimal]] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

= reopen BigDecimal
== Singleton Methods

--- json_create(hash) -> BigDecimal

JSON のオブジェクトから [[c:BigDecimal]] のオブジェクトを生成して返します。

@param hash [[m:Marshal.#load]] 可能な値をキー 'b' に持つハッシュを指定します。

== Public Instance Methods

#@# --- as_json(*args) -> Hash
#@#
#@# Marshal the object to JSON.
#@#
#@# method used for JSON marshalling support.

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
require 'json/add/bigdecimal'
BigDecimal('0.123456789123456789').to_json # => "{\"json_class\":\"BigDecimal\",\"b\":\"36:0.123456789123456789e0\"}"
#@end

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]
