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
