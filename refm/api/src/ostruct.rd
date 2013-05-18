要素を動的に追加・削除できる手軽な構造体を提供するライブラリです。

= class OpenStruct < Object

要素を動的に追加・削除できる手軽な構造体を提供するクラスです。

OpenStruct のインスタンスに対して未定義なメソッド x= を呼ぶと、
#@since 1.9.1
OpenStruct クラスの [[m:BasicObject#method_missing]] で捕捉され、そのインスタンスに
#@else
OpenStruct クラスの [[m:Object#method_missing]] で捕捉され、そのインスタンスに
#@end
インスタンスメソッド x, x= が定義されます。
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

初期化にハッシュを使用することもできます。

  son = OpenStruct.new({ :name => "Thomas", :age => 3 })
  p son.name        # => "Thomas"
  p son.age         # => 3
  son.age += 1
  p son.age         # => 4
  son.items = ["candy","toy"]
  p son.items       # => ["candy","toy"]
  p son             # => #<OpenStruct name="Thomas", age=4, items=["candy", "toy"]>

=== フリーズされている OpenStruct について

Ruby のバージョンごとに挙動が異なるので注意してください。
以下のコードを実行した場合は、表のようになります。

  require 'ostruct'
  a = OpenStruct.new
  a.x = :a
  a.freeze
  a.x = :b # この部分の挙動が異なる

  1.8.0 再代入可能
  1.8.1 TypeError
  1.8.2 再代入可能
  1.8.3 再代入可能
  1.8.4 再代入可能
  1.8.5 再代入可能
  1.8.6 再代入可能
  1.8.7 再代入可能
  1.9.1 再代入可能
  1.9.2 TypeError

同様に以下のコードを実行した場合は全てのバージョンで例外が発生します。

  require 'ostruct'
  a = OpenStruct.new
  a.x = :a
  a.freeze
  a.y = :b # TypeError

== Class Methods
--- new(hash = nil) -> OpenStruct

OpenStruct オブジェクトを生成します。

ハッシュが与えられたとき、それぞれのキーを生成したオブジェクトの要素にし、値をセットします。

@param hash 設定する要素とその値を指定します。
       hash には [[c:Hash]] クラスのインスタンス、または配列の配列を用いることができます。
@raise NoMethodError hash のキーが to_sym メソッドを持たないときに発生します。

  require 'ostruct'
  some1 = OpenStruct.new({:a =>"a",:b =>"b"}) # => #<OpenStruct b="b", a="a">
  some2 = OpenStruct.new([[:a,"a"],[:b,"b"]]) # => #<OpenStruct b="b", a="a">

== Instance Methods

#@since 1.8.1
--- ==(other) -> bool

自身と比較対象のオブジェクトが等しい場合に真を返します。
そうでない場合は、偽を返します。

@param other 比較対象のオブジェクトを指定します。

#@end

#@since 1.8.2
--- new_ostruct_member(name) -> Symbol

与えられた名前のアクセサメソッドを自身に定義します。

@param name 文字列かシンボルで定義するアクセサの名前を指定します。

#@end

--- inspect -> String
#@since 1.8.3
--- to_s -> String
#@end

オブジェクトを人間が読める形式に変換した文字列を返します。

@see [[m:Object#inspect]]

--- delete_field(name) -> object

nameで指定された要素を削除します。

その後その要素を参照したら nil が返ります。

@param name 削除する要素を文字列かシンボルで指定します。
@return 削除前の要素の値を返します。

== Protected Instance Methods

#@since 1.8.7
#@if (version != "1.9.1")
--- modifiable -> Hash

このメソッドは内部的に使用されます。

自身が [[m:Object#freeze]] されている場合にこのメソッドを呼び出すと例外が発生します。

@raise TypeError 自身が [[m:Object#freeze]] されている場合に発生します。

#@end
#@end


== Constants

#@since 1.8.3
--- InspectKey -> :__inspect_key__

内部的に使用する定数です。
#@end
