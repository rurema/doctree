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

@see [[m:Object#to_yaml]]

== Instance Methods

--- dump(table) -> String

YAML 形式の文字列を返します。

@param table 使用されません。

--- load(content) -> object

YAML 形式の文字列からデータを読み込みます。

@param content YAML 形式の文字列を指定します。

--- empty_marshal_checksum -> String

空のデータのチェックサムを返します。

--- empty_marshal_data -> String

空のデータを返します。

--- marshal_dump_supports_canonical_option? -> false

[[c:YAML::Store]] では [[m:Marshal.#dump]] を使用しないので常に偽を返します。

== Constants

--- EMPTY_MARSHAL_CHECKSUM -> String

内部で使用します。

--- EMPTY_MARSHAL_DATA -> String

内部で使用します。
