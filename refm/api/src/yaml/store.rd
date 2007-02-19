#@since 1.8.0
= class YAML::Store < PStore

[[c:PStore]] の [[c:YAML]] 版です。
[[m:Marshal.dump]] したバイナリ形式の
代わりに YAML 形式でファイルに保存します。

使い方は [[c:PStore]] とほとんど同じです。

== class methods
--- new(*options)
#@todo
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

=== 例

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
