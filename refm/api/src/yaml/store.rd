require yaml
require pstore

RubyのオブジェクトをYAML形式の外部ファイルに格納するためのクラスです。

  require "yaml/store"

  db = YAML::Store.new("sample.yml")
  db.transaction do
    db["hoge"] = {1 => 100, "bar" => 101}
  end

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

#@since 1.9.2
@see [[m:Object#to_yaml]]
#@else
@see [[m:Object#to_yaml]], [[m:YAML::DEFAULTS]]
#@end

== Instance Methods
#@since 1.8.2
--- dump(table) -> String

YAML 形式の文字列を返します。

@param table 使用されません。

--- load(content) -> object

YAML 形式の文字列からデータを読み込みます。

@param content YAML 形式の文字列を指定します。

#@until 1.8.7
--- load_file(file) -> object

[[c:File]] オブジェクトから YAML 形式のデータを読み込みます。

@param file [[c:File]] オブジェクトを指定します。

#@end
#@end
#@since 1.8.7
--- empty_marshal_checksum -> String

空のデータのチェックサムを返します。

--- empty_marshal_data -> String

空のデータを返します。

--- marshal_dump_supports_canonical_option? -> false

[[c:YAML::Store]] では [[m:Marshal.#dump]] を使用しないので常に偽を返します。

#@end
#@until 1.8.2
--- transaction(read_only = false) -> ()
トランザクションに入ります。このブロックの中でのみデータベースの読み書きができます。
読み込み専用のトランザクションが使用可能です。

@param read_only 真を指定すると、読み込み専用のトランザクションになります。

@raise PStore::Error read_only を真にしたときに、データベースを変更しよ
                     うした場合に発生します。

  require 'yaml/store'

  db = YAML::Store.new("/tmp/store.yaml")
  db.transaction {
    db["hoge"] = [ 1, 2, 3, 4]
  }

  begin
    db.transaction(true) {
      db["hoge"] = [ 1, 2, 3, 4]
    }
  rescue PStore::Error
    puts "読み込み専用のトランザクションに書き込もうとしました。 "
  end


使い方は [[c:PStore]] とほとんど同じです。

例

  require "yaml/store"

  db = YAML::Store.new("sample.yml")
  db.transaction do
    db["hoge"] = {1 => 100, "bar" => 101}
  end

  # sample.yml
  hoge:
    1: 100
    bar: 101

[[c:PStore]] 同様、ユーザが定義したクラスのオブジェクトを保存することもできます。

  require "yaml/store"
  
  class Foo
    attr_accessor :foo
  end
  
  db = YAML::Store.new("sample.yml")
  db.transaction do
    f = Foo.new
    f.foo = 777
    db["bar"] = f
  end
  
  # sample.yml
  bar: !ruby/object:Foo
    foo: 777
#@end

== Constants
#@since 1.8.7
--- EMPTY_MARSHAL_CHECKSUM -> String

内部で使用します。

--- EMPTY_MARSHAL_DATA -> String

内部で使用します。

#@end
