= class REXML::Element < REXML::Parent
include REXML::Namespace

XML の要素(エレメント、element)を表すクラス。

要素は
  * 子要素(children)
  * 属性(attributes)
  * 名前(name)
を持つものとして特徴付けられます。

また、要素はある別の要素の子となることもできます。

== Class Methods

--- new(arg = UNDEFINED, parent = nil, context = nil) -> REXML::Element
要素オブジェクトを生成します。

arg が文字列の場合、新たな要素の名前は arg に設定されます。
arg が [[c:REXML::Element]] オブジェクトの場合は、
新たな要素の名前、属性、context が arg のもので初期化されます。

parent で親ノードを指定します。

context には hash table で要素のコンテキストを指定します。
基本的には text node ([[c:REXML::Text]]) での特別な文字、特に空白について
の取り扱いを指定できます。
以下の [[c:Symbol]] をキーとして使うことができます。

: :respect_whitespace
  空白を考慮して欲しい要素の名前の集合を文字列の配列で指定します。
  また、すべての要素で空白を考慮して欲しい場合には
  :all を指定します。
  デフォルト値は :all です。
  [[m:REXML::Element#whitespace]] も参照してください。
: :compress_whitespace
  空白を無視して欲しい要素の名前の集合を文字列の配列で指定します。
  この指定は :respect_whitespace での指定を上書きします。
  すべての要素で空白を無視して欲しい場合には
  :all を指定します。
  [[m:REXML::Element#whitespace]] も参照してください。
: :ignore_whitespace_nodes
  空白のみからなるノードを無視して欲しい要素の名前の集合を
  文字列の配列で指定します。
  すべての要素で無視して欲しい場合は :all を指定します。
  これが設定された場合、空白のみからなる text node は追加されません。
  [[m:REXML::Element#ignore_whitespace_nodes]] も参照してください。
: :raw
  raw mode で取り扱いをして欲しい要素の名前の集合を
  文字列の配列で指定します。
  すべてのノードを raw mode で取り扱って欲しい場合は :all を指定します。
  raw mode においては、text 中の特殊文字は一切変換されません。
  [[m:REXML::Element#raw]] も参照してください。

@param arg 要素の名前(String)もしくは初期化に使う [[c:REXML::Element]] 
       オブジェクト
@param parent 親ノード
@param context コンテキスト([[c:Hash]])
@see [[m:REXML::Parent.new]], [[m:REXML::Child.new]]

== Instance Methods

--- attributes -> REXML::Attributes
要素が保持している属性の集合を返します。

--- elements
#@todo

--- context
--- context=(value)
#@todo

#@since 1.8.2
--- inspect
#@todo
#@end

--- clone
#@todo

#@since 1.8.3
--- root_node
#@todo
#@end

--- root
#@todo

--- document
#@todo

--- whitespace
#@todo

--- ignore_whitespace_nodes
#@todo

--- raw
#@todo

--- prefixes
#@todo

--- namespaces
#@todo

--- namespace
#@todo

--- add_namespace(prefix, uri = nil)
#@todo

--- delete_namespace(namespace = "xmlns")
#@todo

--- add_element(element, attrs = nil)
#@todo

--- delete_element(element)
#@todo

--- has_elements?
#@todo

--- each_element_with_attribute(key, value = nil, max = 0, name = nil) {|element| ... }
#@todo

--- each_element_with_text(text = nil, max = 0, name = nil) {|element| ... }
#@todo

--- each_element(xpath = nil) {|element| ... }
#@todo

--- get_elements(xpath)
#@todo

--- next_element
#@todo

--- previous_element
#@todo

--- has_text?
#@todo

--- text(path = nil)
#@todo

--- get_text(path = nil)
#@todo

--- text=(text)
#@todo

--- add_text(text)
#@todo

--- node_type
#@todo

#@since 1.8.2
--- xpath
#@todo
#@end

--- attribute(name, namespace = nil)
#@todo

--- has_attributes?
#@todo

--- add_attribute(key, value = nil)
#@todo

--- add_attributes(hash)
#@todo

--- delete_attribute(key)
#@todo

--- cdatas
#@todo

--- comments
#@todo

--- instructions
#@todo

--- texts
#@todo

--- write(writer = $stdout, indent = -1, transitive = false, ie_hack = false)
#@todo

== Constants

--- UNDEFINED
#@todo

= class REXML::Elements
include Enumerable

== Class Methods

--- new(parent)
#@todo

== Instance Methods

--- [](index, name = nil)
#@todo

--- []=(index, element)
#@todo

--- empty?
#@todo

--- index(element)
#@todo

--- delete(element)
#@todo

--- delete_all(xpath)
#@todo

--- add(element = nil)
--- <<(element = nil)
#@todo

--- each(xpath = nil) {|element| ... }
#@todo

--- size
#@todo

--- to_a(xpath = nil)
#@todo

#@since 1.8.6
--- collect(xpath = nil) {|element| .. }
#@todo

--- inject(xpath = nil, initial = nil) {|element| ... }
#@todo
#@end

= class REXML::Attributes < Hash
属性の集合を表すクラスです。

[[m:REXML::Element#attributes]] はこのクラスのオブジェクトを返します。
各属性には [[m:REXML::Attributes#[] ]] でアクセスします。

== Class Methods

--- new(element) -> REXML::Attributes
空の Attributes オブジェクトを生成します。

どの要素の属性であるかを element で指定します。

通常は [[m:REXML::Element#new]] によって Attributes オブジェクト
が生成されるため、このメソッドを使う必要はありません。

@param element 属性が属する要素([[c:REXML::Element]] オブジェクト)

== Instance Methods

--- [](name) -> String | nil
属性名nameの属性値を返します。

属性値ではなく [[c:REXML::Attribute]] オブジェクトが必要な場合は
[[m:REXML::Attributes#get_attribute]] を使ってください。

nameという属性名の属性がない場合は nil を返します。

@param name 属性名(文字列)

==== 例

  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  
  a = doc.get_elements("/root/a").first
  
  p a.attributes["att"] # => "<"
  p a.attributes["bar:att"] " => "2"


#@since 1.8.2
--- to_a 
#@todo

#@end

--- length -> Integer
--- size -> Integer
属性の個数を返します。


==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS  
  a = doc.get_elements("/root/a").first
  
  p a.attributes.length # => 3

--- each_attribute {|attribute| ... } -> ()
各属性に対しブロックを呼び出します。

個々の属性は [[c:REXML::Attribute]] オブジェクトで渡されます。

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS  
  a = doc.get_elements("/root/a").first
  
  a.attributes.each_attribute do |attr|
    p [attr.namespace, attr.name, attr.value]
  end
  # => ["http://example.org/foo", "att", "1"]
  # => ["http://example.org/bar", "att", "2"]
  # => ["", "att", "<"]

--- each {|name, value| ... } -> ()
各属性の名前と値に対しブロックを呼び出します。

名前には expanded_name([[m:REXML::Attribute#exapnded_name]])が
渡されます。

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS  
  a = doc.get_elements("/root/a").first
  
  a.attributes.each do |name, value|
    p [name, value]
  end
  
  # => ["foo:att", "1"]
  # => ["bar:att", "2"]
  # => ["att", "<"]

--- get_attribute(name) -> Attribute | nil
name という名前の属性を取得します。

name という名前を持つ属性がない場合は nil を返します。

@param name 属性名(文字列)
@see [[m:REXML::Attributes#[] ]]

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  
  a.attributes.get_attribute("att") # => att='&lt;'
  a.attributes.get_attribute("foo:att") # => foo:att='1'


--- []=(name, value)

指定した属性を更新します。

name で属性の名前を、value で値を更新します。
既に同じ名前の属性がある場合は上書きされ、
そうでない場合は属性が追加されます。

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  
  a.attributes["att"] = "9"
  a.attributes["foo:attt"] = "8"
  a # => <a foo:att='1' bar:att='2' att='9' foo:attt='8'/>

@see [[m:REXML::Attributes#add]]

--- prefixes -> [String]
self の中で宣言されている prefix の集合を
文字列の配列で返します。

self が属する要素より上位の要素で定義されているものは含みません。

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS  
  a = doc.get_elements("/root/a").first
  
  p doc.root.attributes.prefixes # => ["foo", "bar"]
  p a.attributes.prefixes # => []

--- namespaces -> { String => String }
self の中で宣言されている名前空間の集合を返します。

返り値は名前空間の prefix をキーとし、URI を値とする
[[c:Hash]] を返します。

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS  
  a = doc.get_elements("/root/a").first
  
  p doc.root.attributes.namespaces 
  # => {"foo"=>"http://example.org/foo", "bar"=>"http://example.org/bar"}
  p a.attributes.namespaces 
  # => {}

--- delete(attribute) -> REXML::Element

指定した属性を取り除きます。

attribute で取り除く属性を指定します。
文字列もしくは [[c:REXML::Attribute]] オブジェクトを指定します

self が属する要素([[c:REXML::Element]])を返します。

@param attribute 取り除く属性(文字列もしくは REXML::Attribute オブジェクト)

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  
  a.attributes.delete("att")     # => <a foo:att='1' bar:att='2'/>
  a.attributes.delete("foo:att") # => <a bar:att='2'/>
  attr = a.attributes.get_attribute("bar:att")
  a.attributes.delete(attr)      # => <a/>

--- add(attribute) -> ()
--- <<(attribute) -> ()

属性を追加/更新します。

attribute で更新する属性([[c:REXML::Attribute]] オブジェクト)を
指定します。既に同じ名前([[c:REXML::Attribute#name]])のオブジェクトが
存在する場合は属性が上書きされ、ない場合は追加されます。

@param attribute 追加(更新)する属性([[c:REXML::Attribute]] オブジェクト)
@see [[m:REXML::Attributes#[]=]]

--- delete_all(name) -> [REXML::Attribute]

name という名前を持つ属性をすべて削除します。

削除された属性を配列で返します。

@param name 削除する属性の名前

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  
  a.attributes.delete_all("att") # => [att='&lt;']
  a # => <a foo:att='1' bar:att='2'/>

#@since 1.8.5
--- get_attribute_ns(namespace, name) -> REXML::Attribute | nil
namespace と name で特定される属性を返します。

namespace で名前空間を、 name で prefix を含まない属性名を
指定します。

指定された属性が存在しない場合は nil を返します。

XML プロセッサが prefix を置き換えてしまった場合でも、このメソッドを
使うことで属性を正しく指定することができます。

@param namespace 名前空間(URI, 文字列)
@param name 属性名(文字列)

==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  
  a.attributes.get_attribute_ns("", "att") # => att='&lt;'
  a.attributes.get_attribute_ns("http://example.org/foo", "att") # => foo:att='1'
  a.attributes.get_attribute_ns("http://example.org/baz", "att") # => nil
  a.attributes.get_attribute_ns("http://example.org/foo", "attt") # => nil

#@end
