require yaml
require pstore

RubyのオブジェクトをYAML形式の外部ファイルに格納するためのクラスです。

例:

  require 'yaml/store'

  Person = Struct.new :first_name, :last_name

  people = [Person.new("Bob", "Smith"), Person.new("Mary", "Johnson")]

  store = YAML::Store.new "test.store"

  store.transaction do
    store["people"] = people
    store["greeting"] = { "hello" => "world" }
  end

上記のコードを実行すると "test.store" は以下のようになります。

  ---
  people:
  - !ruby/struct:Person
    first_name: Bob
    last_name: Smith
  - !ruby/struct:Person
    first_name: Mary
    last_name: Johnson
  greeting:
    hello: world

= class YAML::Store < PStore

[[c:PStore]] の [[c:YAML]] 版です。
[[m:Marshal.#dump]] したバイナリ形式の
代わりに YAML 形式でファイルに保存します。

使い方は [[c:PStore]] とほとんど同じです。
インターフェースは [[c:Hash]] に似ています。

== Class Methods

#@# 最終的にPStore.newに渡されるためメソッドシグネチャは2.4.0以前と同様
#@# にしてある。
--- new(file_name, yaml_opts = {})                      -> YAML::Store
#@since 2.4.0
--- new(file_name, thread_safe = false, yaml_opts = {}) -> YAML::Store
#@end

自身を初期化します。

@param file_name 格納先のファイル名。ファイルがない場合は作成します。既
                 にファイルが存在する場合はその内容を読み込みます。

#@since 2.4.0
@param thread_safe 自身をスレッドセーフにして初期化するかどうか。
#@end

@param yaml_opts YAML 出力時のオプションを [[c:Hash]] で指定します。
                 詳しくは [[m:Psych.dump]] を参照してください。
