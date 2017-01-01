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
--- new(*options) -> YAML::Store

自身を初期化します。

YAML 形式のファイルを読み込ませたい場合は、最初の引数にファイル名を文字列で指定します。
最後の引数がハッシュであった場合は、YAML 出力時のオプションを変更します。

@param options 読み込ませたいファイルや、オプションを与えます。

@see [[m:Object#to_yaml]]
