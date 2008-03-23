#@since 1.8.0
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

== class methods
--- new(*options)

YAML形式のファイルを読み込ませたい場合は、最初の引数にファイル名を文字列で指定します。
最後の引数がハッシュであった場合は、YAMLのデフォルトの設定を変更します。

@param 読み込ませたいファイルや、オプションを与えます。

@see [[m:YAML::DEFAULTS]]

== instance methods
--- [](name)
--- fetch
--- []=(name, value)
--- delete(name)
--- roots
--- root?(name)
--- path
--- commit
--- abort
--- transaction
#@todo

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
