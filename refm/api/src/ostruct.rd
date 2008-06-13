要素を動的に追加・削除できる手軽な構造体を提供するライブラリです

= class OpenStruct < Object

OpenStructのインスタンスに対して未定義なセッターメソッド x= を呼ぶと、
OpenStructクラスの[[m:Object#method_missing]]で捕捉され、インスタンスに属性 x が定義されます。
この挙動によって要素を動的に変更できる構造体として働きます。

  require 'ostruct'
  ab = OpenStruct.new
  ab.foo = 25
  p ab.foo          # => 25
  ab.bar = 2
  p ab.bar          # => 2
  p ab              # => <OpenStruct foo=25, bar=2>
  ab.delete_field("foo")
  p ab.foo          # => nil
  p ab              # => <OpenStruct bar=2>

  son = OpenStruct.new({:name=>"Thomas", :age => 3})
  p son.name        # => "Thomas"
  p son.age         # => 3
  son.age += 1
  p son.age         # => 4
  son.items = ["candy","toy"]
  p son.items       # => ["candy","toy"]
  p son             # => #<OpenStruct name="Thomas", age=4, items=["candy", "toy"]>
  
== Class Methods
--- new(hash = nil) -> OpenStruct

OpenStructオブジェクトを生成。
hashが与えられたとき、それぞれのキーを
生成したオブジェクトの要素にし、値をセットします。

@param hash 設定する要素とその値を指定します。
    hashには[[c:Hash]]クラスのインスタンス、または配列の配列を用いることができます。
@raise NoMethodError hashのキーが to_sym メソッドを持たないときに発生します。

  require 'ostruct'
  some1 = OpenStruct.new({:a =>"a",:b =>"b"}) # => #<OpenStruct b="b", a="a">
  some2 = OpenStruct.new([[:a,"a"],[:b,"b"]]) # => #<OpenStruct b="b", a="a">

== Instance Methods
--- delete_field(name) -> object

nameで指定された要素を削除。
その後その要素を参照したらnilが返ります。

@return 削除前の要素の値を返します。
@param name 削除する要素を指定。文字列やシンボルを用います。
