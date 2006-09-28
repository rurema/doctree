= class OpenStruct

手軽な構造体クラス。
method_missingの使い方の例でもある。

  require 'ostruct'
  s = OpenStruct.new
  s.foo = 25
  p s.foo          # => 25
  s.bar = 2
  p s.bar          # => 2
  p s              # => <OpenStruct bar=2 foo=25>
  s.delete_field("foo")
  p s.foo          # => nil
  p s              # => <OpenStruct bar=2>

  t = OpenStruct.new("foo"=>"bar")
  p t.foo         # => "bar"
  t.baz = "fobar"
  p t.baz         # => "fobar"
  
== Class Methods
--- new(hash = nil)
OpenStructオブジェクトを生成。
hashが与えられたとき、

== Instance Methods
--- delete_field(name)
nameで指定された要素を削除。
その後その要素を参照したらnilが返る。
