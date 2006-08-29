((<執筆者募集>))

* ((<URL:http://www.druby.org/ilikeruby/rinda.html>))
* ((<URL:http://www2a.biglobe.ne.jp/~seki/ruby/d208.html>))



= class Rinda::Tuple

Tuple のためのクラスです。

== クラスメソッド

--- Tuple.new(ah)
    Tuple オブジェクトを生成します。((|ah|)) には ((<Array>)) オブジェクトか
    ((<Hash>)) オブジェクトを与えます。((<Hash>)) オブジェクトを与える場合、キーは
    すべて文字列でなければいけません。

== メソッド

--- self[k]
    ハッシュキー ((|k|)) に対応する要素を返します。self が ((<Array>)) オブジェクト
    から生成された場合は、整数 ((|k|)) を与えるとそのインデックスに対応する要素を
    返します。

--- each{|k, v| ... }
    各ハッシュキーと値のペアを引数としてブロックを評価します。self が ((<Array>))
    オブジェクトから生成された場合は、インデックスと値のペアを引数としてブロックを
    評価します。

--- fetch(k)
    ((|k|)) に対応する要素を返します。

--- size
    サイズを整数で返します。

--- value
    自身が保持しているハッシュか配列を返します。



= class Rinda::Template

タプルのマッチングのためのクラスです。
ユーザがこのクラスを直接使うことはありません。

== 例

 require 'rinda/rinda'
 
 template = Rinda::Template.new(['abc', nil, nil])
 template.match(['abc', 2, 5])   # => true
 template.match(['hoge', 2, 5])  # => false

 template = Rinda::Template.new([String, Integer, nil])
 template.match(['abc', 2, 5])   # => true
 template.match(['abcd', 2, 5])  # => true
 
 template = Rinda::Template.new([/^abc/, Integer, nil])
 template.match([/^abc/, Integer, nil])  # => true
 template.match(['abc', 2, 5])           # => true
 template.match(['def', 2, 5])           # => false
 
 template = Rinda::Template.new({'name' => String, 'age' => Integer})
 template.match({'name' => 'seki', 'age' => 0x20})   # => true
 template.match({'name' => :seki,  'age' => 0x20})   # => false

== スーパークラス

((<Rinda::Tuple>))

== メソッド

--- ===(tuple)
--- match(tuple)
    (({self})) と ((|tuple|)) のサイズが同じで、(({self})) の各要素が ((|tuple|)) に
    マッチする
    場合は真を返します。マッチングの検査には (({==})) と (({===})) を用います。
    (({nil})) はワイルドカードです。



= class Rinda::TupleSpaceProxy

((<執筆者募集>))
