要素を動的に追加・削除できる手軽な構造体

= class OpenStruct < Object

インスタンスに対して未定義なセッターメソッドを呼ぶと、
method_missing が呼ばれて
代入した値を返すメソッドがインスタンスに新たに定義されます。
この動作によって要素を動的に変更できる構造体として働きます。

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

  son = OpenStruct.new(:name=>"Thomas", :age => 3)
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

@param hash 設定する要素とその値を指定します
キーには to_sym でシンボル化できるもの、
つまり文字列やシンボルを使用することができます。

== Instance Methods
--- delete_field(name) -> object

nameで指定された要素を削除。
その後その要素を参照したらnilが返る。

@return 要素の削除前の値を返します。

@param name 削除する要素を指定
文字列やシンボルを用います。
