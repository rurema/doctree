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

== Class Methods
--- new(hash = nil) -> OpenStruct

OpenStruct オブジェクトを生成します。

ハッシュが与えられたとき、それぞれのキーを生成したオブジェクトの要素にし、値をセットします。

@param hash 設定する要素とその値を指定します。
#@since 2.0.0
       hash には [[c:Hash]] クラスのインスタンス、または each_pair メソッ
       ドを持つオブジェクトを用いる事ができます。
#@else
       hash には [[c:Hash]] クラスのインスタンス、または配列の配列を用いることができます。
#@end
@raise NoMethodError hash のキーが to_sym メソッドを持たないときに発生します。

  require 'ostruct'
  some1 = OpenStruct.new({:a =>"a",:b =>"b"}) # => #<OpenStruct b="b", a="a">
#@until 2.0.0
  some2 = OpenStruct.new([[:a,"a"],[:b,"b"]]) # => #<OpenStruct b="b", a="a">
#@end

== Instance Methods

#@since 1.8.1
--- ==(other) -> bool

自身と比較対象のオブジェクトが等しい場合に真を返します。
そうでない場合は、偽を返します。

@param other 比較対象のオブジェクトを指定します。

#@end

#@since 2.0.0
--- eql?(other) -> bool

self と other が等しい場合に true を返します。そうでない場合は false を
返します。

具体的には other が [[c:OpenStruct]] オブジェクトかそのサブクラスでかつ、
self の各要素を保持した内部の [[c:Hash]] が eql? で比較して等しい場合に
true を返します。

@param other 比較対象のオブジェクトを指定します。

#@end

#@until 2.0.0
#@since 1.8.2
--- new_ostruct_member(name) -> Symbol

与えられた名前のアクセサメソッドを自身に定義します。

@param name 文字列かシンボルで定義するアクセサの名前を指定します。

#@end
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

#@since 2.0.0
--- to_h -> { Symbol => object }

self を各要素の名前をキー([[c:Symbol]])、要素が値のハッシュに変換して返
します。

例:

  require 'ostruct'
  data = OpenStruct.new("country" => "Australia", :population => 20_000_000)
  data.to_h   # => {:country => "Australia", :population => 20000000 }

--- each_pair                  -> Enumerator
--- each_pair { |key, value| } -> self

self の各要素の名前をと要素を引数としてブロックを評価します。

ブロックを指定した場合は self を返します。そうでない場合は
[[c:Enumerator]] を返します。

例:

  require 'ostruct'
  data = OpenStruct.new("country" => "Australia", :population => 20_000_000)
  data.each_pair.to_a  # => [[:country, "Australia"], [:population, 20000000]]

--- [](name) -> object

引数 name で指定した要素に対応する値を返します。

@param name 要素の名前を文字列か [[c:Symbol]] オブジェクトで指定します。

例:

  person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  person[:age] # => 70, person.age と同じ

--- []=(name, value)

引数 name で指定した要素に対応する値に value をセットします。

@param name 要素の名前を文字列か [[c:Symbol]] オブジェクトで指定します。

@param value セットする値を指定します。

例:

  person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  person[:age] = 42 # person.age = 42 と同じ
  person.age # => 42

--- hash -> Integer

self のハッシュ値を返します。

#@# Two hashes with the same content will have the same hash code
#@# (and will be eql?).

#@end

== Protected Instance Methods

#@since 1.8.7
#@if (version != "1.9.1")
--- modifiable -> Hash

このメソッドは内部的に使用されます。

自身が [[m:Object#freeze]] されている場合にこのメソッドを呼び出すと例外が発生します。

@raise TypeError 自身が [[m:Object#freeze]] されている場合に発生します。

#@end
#@end

#@since 2.0.0
--- new_ostruct_member(name) -> Symbol

与えられた名前のアクセサメソッドを自身に定義します。

@param name 文字列かシンボルで定義するアクセサの名前を指定します。
#@end

== Constants

#@since 1.8.3
--- InspectKey -> :__inspect_key__

内部的に使用する定数です。
#@end
