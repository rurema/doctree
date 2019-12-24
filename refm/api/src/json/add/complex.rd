[[c:Complex]] に JSON 形式の文字列に変換するメソッドや JSON 形式の文字列から Ruby のオブジェクトに変換するメソッドを定義します。

= reopen Complex
== Singleton Methods

--- json_create(hash) -> Complex

JSON のオブジェクトから [[c:Complex]] のオブジェクトを生成して返します。

@param hash 実部をキー 'r'、虚部をキー 'i' に持つハッシュを指定します。

== Public Instance Methods

#@# --- as_json(*args) -> Hash
#@#
#@# Returns a hash, that will be turned into a JSON object and
#@# represent this object.

--- to_json(*args) -> String

自身を JSON 形式の文字列に変換して返します。

内部的にはハッシュにデータをセットしてから [[m:JSON::Generator::GeneratorMethods::Hash#to_json]] を呼び出しています。

@param args 使用しません。

@see [[m:JSON::Generator::GeneratorMethods::Hash#to_json]]
