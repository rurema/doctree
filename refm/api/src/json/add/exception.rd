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
