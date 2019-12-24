#@#require rexml/namespace
#@#require rexml/text

= class REXML::Attribute
include REXML::Node
include REXML::Namespace

要素([[c:REXML::Element]])の属性を表すクラスです。

つまり、 <element attribute="value"/> という
要素における attribute=value というペアのことです。

属性にはなんらかの名前空間(namespace, [[c:REXML::Namespace]])
に属することができます。

== Class Methods

--- new(attribute_to_clone, parent = nil) -> REXML::Attribute
--- new(attribute, value, parent = nil) -> REXML::Attribute
新たな属性オブジェクトを生成します。

2種類の初期化が可能です。
REXML::Attribute オブジェクトを渡した場合は、
属性名とその値がそれから複製されます。
parent で新たに作られる属性オブジェクトが属する
要素が指定できます。
parent を省略した場合は複製元と同じ要素の属するように
設定されます。

また、属性名とその値を文字列で指定することもできます。
parent で新たに作られる属性オブジェクトが属する
要素が指定できます。
parent を省略した場合は nil が設定されます。

通常はこのメソッドは直接は使わず、[[m:REXML::Element#add_attribute]] などを
使うでしょう。

@param attribute_to_clone 複製元の [[c:REXML::Attribute]] オブジェクト
@param attribute 属性名
@param value 属性の値
@param parent 生成される属性が所属する要素([[c:REXML::Element]])


== Instance Methods

--- element -> REXML::Element
その属性が属する要素を返します。


--- normalized=(value)
正規化された属性値を設定します。

通常はライブラリが自動的にこの値を設定するので
ユーザはこれを使う必要はないでしょう。

@param value 正規化された属性値

--- prefix -> String
属性の名前空間を返します。

=== 例
  require 'rexml/document'
  e = REXML::Element.new( "elns:myelement" )
  e.add_attribute( "nsa:a", "aval" )
  e.add_attribute( "b", "bval" )
  p e.attributes.get_attribute( "a" ).prefix   # -> "nsa"
  p e.attributes.get_attribute( "b" ).prefix   # -> "elns"
  a = REXML::Attribute.new( "x", "y" )
  p a.prefix                                   # -> ""

--- namespace(arg = nil) -> String | nil
属性の名前空間の URI を返します。

URI が定義されていない場合は nil を返します。

@param arg この値を指定すると、その属性の名前空間でなく、arg という名前空間
       の URI が返されます。
       通常は省略します。

=== 例
  require 'rexml/document'
  e = REXML::Element.new("el")
  e.add_attribute("xmlns:ns", "http://www.example.com/ns")
  e.add_attribute("ns:r", "rval")
  p e.attributes.get_attribute("r").prefix  # => "ns"
  p e.attributes.get_attribute("r").namespace # => "http://www.example.com/ns"


--- ==(other) -> bool
属性の名前と値が other と一致する場合に真を返します。

#@# hash が定義されているのに eql? が定義されていない
#@# --- hash 
#@# #@todo

--- to_string -> String
"name='value'" という形式の文字列を返します。

=== 例
  require 'rexml/document'
  e = REXML::Element.new("el")
  e.add_attribute("ns:r", "rval")
  p e.attributes.get_attribute("r").to_string # => "ns:r='rval'"

--- to_s -> String
正規化された属性値を返します。

属性値の正規化については XML の仕様を参考にしてください。


--- value -> String
正規化されていない属性値を返します。

属性値の正規化については XML の仕様を参考にしてください。

--- clone -> REXML::Element
self を複製し返します。

--- element=(element)
self が属する要素を変更します。

@param element 変更先の要素([[c:REXML::Element]])

--- remove -> ()
self を所属する要素から取り除きます。

--- write(output, indent = -1)  -> object
output に self の情報を name='value' という形式で書き込みます。

output が返ります。

@param output 書き込み先の IO オブジェクト
@param indent インデントレベル、ここでは無視される

--- node_type -> Symbol
「:attribute」というシンボルを返します。


--- xpath -> String
その属性を指定する xpath 文字列を返します。

例えば "/foo/bar/@ns:r" という文字列を返します。
#@# 完全な例題をここに書く

== Constants

#@# 内部的に使う正規表現
#@# --- PATTERN
#@# --- NEEDS_A_SECOND_CHECK 
