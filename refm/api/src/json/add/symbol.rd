[[c:Symbol]] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

= reopen Symbol
== Singleton Methods

--- json_create(hash) -> Symbol

JSON のオブジェクトから [[c:Symbol]] のオブジェクトを生成して返します。

@param hash 文字列をキー 's' に持つハッシュを指定します。

== Public Instance Methods

#@# --- as_json(*args) -> Hash
#@#
#@# Returns a hash, that will be turned into a JSON object and
#@# represent this object.

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 引数はそのまま [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] に渡されます。

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]
