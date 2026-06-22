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

  require 'ostruct'
  son = OpenStruct.new({ :name => "Thomas", :age => 3 })
  p son.name        # => "Thomas"
  p son.age         # => 3
  son.age += 1
  p son.age         # => 4
  son.items = ["candy","toy"]
  p son.items       # => ["candy","toy"]
  p son             # => #<OpenStruct name="Thomas", age=4, items=["candy", "toy"]>

#@since 3.0
===[a:caveats] 注意事項

OpenStruct は Ruby のメソッド探索を利用して、プロパティに必要なメソッドを見つけて定義します。これは [[m:BasicObject#method_missing]] と [[m:BasicObject#define_singleton_method]] によって実現されます。

作成されるオブジェクトのパフォーマンスに懸念がある場合は、この点を考慮する必要があります。[[c:Hash]] や [[c:Struct]] を使用する場合と比較して、これらのプロパティの設定にははるかに多くのオーバーヘッドがあるためです。小規模な [[c:Hash]] から [[c:OpenStruct]] を作成し、いくつかの要素にアクセスした場合、直接ハッシュテーブルにアクセスするよりも 200 倍遅くなることがあります。

これは潜在的なセキュリティ問題です。信頼されていないユーザーデータ（例：JSON を用いたリクエスト）から [[c:OpenStruct]] を構築した場合、キーがメソッドを作成し、そのメソッド名が永久に GC されることがないため、DoS 攻撃を受ける可能性があります。

これは、Ruby バージョン間の非互換性の原因にもなります：

  o = OpenStruct.new
  o.then            # => Ruby < 2.6 では nil、Ruby >= 2.6 では Enumerator

以下の方法では、組み込みライブラリのメソッドが上書きされる可能性があり、バグやセキュリティ上の問題が発生する可能性があります：

  o = OpenStruct.new
  o.methods         # => [:to_h, :marshal_load, :marshal_dump, :each_pair, ...]
  o.methods = [:foo, :bar]
  o.methods         # => [:foo, :bar]

衝突を避けるために [[c:OpenStruct]] は ! で終わるメソッドは protected と private でのみ使用し、public な組み込みライブラリの ! で終わるメソッドはエイリアスを定義しています：

  o = OpenStruct.new(make: 'Bentley', class: :luxury)
  o.class           # => :luxury
  o.class!          # => OpenStruct

! で終わるフィールドは使用しないことが推奨されます（ただし、強制ではありません）。サブクラスのメソッドを上書きすることはできませんし、! で終わる OpenStruct 自身のメソッドを上書きすることもできません。

以上の理由から OpenStruct を一切使用しないことを検討してください。
#@end

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

--- ==(other) -> bool

自身と比較対象のオブジェクトが等しい場合に真を返します。
そうでない場合は、偽を返します。

@param other 比較対象のオブジェクトを指定します。


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
--- new_ostruct_member(name) -> Symbol

与えられた名前のアクセサメソッドを自身に定義します。

@param name 文字列かシンボルで定義するアクセサの名前を指定します。

#@end

--- inspect -> String
--- to_s -> String

オブジェクトを人間が読める形式に変換した文字列を返します。

@see [[m:Object#inspect]]

--- delete_field(name) -> object

nameで指定された要素を削除します。

その後その要素を参照したら nil が返ります。

@param name 削除する要素を文字列かシンボルで指定します。
@return 削除前の要素の値を返します。

#@since 2.0.0
--- to_h -> { Symbol => object }
#@since 2.6.0
--- to_h {|name, value| block } -> Hash
#@end

self を各要素の名前をキー([[c:Symbol]])、要素が値のハッシュに変換して返
します。

#@since 2.6.0
ブロックを指定すると各ペアでブロックを呼び出し、
その結果をペアとして使います。
#@end

#@samplecode 例
require 'ostruct'
data = OpenStruct.new("country" => "Australia", :capital => "Canberra")
data.to_h   # => {:country => "Australia", :capital => "Canberra" }
#@since 2.6.0
data.to_h {|name, value| [name.to_s, value.upcase] }
            # => {"country" => "AUSTRALIA", "capital" => "CANBERRA" }
#@end
#@end

--- each_pair                  -> Enumerator
--- each_pair { |key, value| } -> self

self の各要素の名前と要素を引数としてブロックを評価します。

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

  require 'ostruct'
  person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  person[:age] # => 70, person.age と同じ

--- []=(name, value)

引数 name で指定した要素に対応する値に value をセットします。

@param name 要素の名前を文字列か [[c:Symbol]] オブジェクトで指定します。

@param value セットする値を指定します。

例:

  require 'ostruct'
  person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  person[:age] = 42 # person.age = 42 と同じ
  person.age # => 42

#@since 2.3.0
--- dig(key, ...) -> object | nil

self 以下のネストしたオブジェクトを dig メソッドで再帰的に参照して返し
ます。途中のオブジェクトが nil であった場合は nil を返します。

@param key キーを任意個指定します。

  require 'ostruct'
  address = OpenStruct.new('city' => "Anytown NC", 'zip' => 12345)
  person = OpenStruct.new('name' => 'John Smith', 'address' => address)
  person.dig(:address, 'zip')          # => 12345
  person.dig(:business_address, 'zip') # => nil

@see [[m:Array#dig]], [[m:Hash#dig]], [[m:Struct#dig]]
#@end

--- hash -> Integer

self のハッシュ値を返します。

#@# Two hashes with the same content will have the same hash code
#@# (and will be eql?).

#@end

== Protected Instance Methods

#@if (version != "1.9.1")
--- modifiable -> Hash

このメソッドは内部的に使用されます。

自身が [[m:Object#freeze]] されている場合にこのメソッドを呼び出すと例外が発生します。

@raise TypeError 自身が [[m:Object#freeze]] されている場合に発生します。

#@end

#@since 2.0.0
--- new_ostruct_member(name) -> Symbol

与えられた名前のアクセサメソッドを自身に定義します。

@param name 文字列かシンボルで定義するアクセサの名前を指定します。
#@end

== Constants

--- InspectKey -> :__inspect_key__

内部的に使用する定数です。
