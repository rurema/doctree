((<執筆者募集>))

* ((<URL:http://www.druby.org/ilikeruby/rinda.html>))
* ((<URL:http://www2a.biglobe.ne.jp/~seki/ruby/d208.html>))



= class Rinda::Tuple

Tuple のためのクラスです。

== Class Methods

--- new(ah)

Tuple オブジェクトを生成します。
ah には [[c:Array]] オブジェクトか [[c:Hash]] オブジェクトを与えます。
[[c:Hash]] オブジェクトを与える場合、
キーはすべて文字列でなければいけません。

== Methods

--- [](key)

ハッシュキー key に対応する要素を返します。
self が [[c:Array]] オブジェクトから生成された場合は、
整数 key を与えるとそのインデックスに対応する要素を返します。

--- each{|key, value| ... }

各ハッシュキー key と値 value のペアを引数としてブロックを評価します。
self が [[c:Array]] オブジェクトから生成された場合は、
インデックスと値のペアを引数としてブロックを評価します。

--- fetch(key)

ハッシュキー key に対応する要素を返します。

--- size

サイズを整数で返します。

--- value

自身が保持しているハッシュか配列を返します。



= class Rinda::Template < Rinda::Tuple

タプルのマッチングのためのクラスです。
ユーザがこのクラスを直接使うことはありません。

=== 例

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

== Methods

--- ===(tuple)
--- match(tuple)

self と tuple のサイズが同じで、
self の各要素が tuple にマッチする場合は真を返します。
マッチングの検査には == と === を用います。
nil はワイルドカードです。



= class Rinda::TupleSpaceProxy

((<執筆者募集>))
