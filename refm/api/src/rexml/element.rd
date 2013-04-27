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

--- elements -> REXML::Elements
要素が保持している子要素の集合を返します。

--- context 
--- context=(value)
#@todo

#@# #@since 1.8.2
#@# --- inspect
#@# #@todo
#@# #@end

--- clone -> REXML::Element
self を複製して返します。

複製されるのは名前、属性、名前空間のみです。
子ノードは複製されません。

#@since 1.8.3
--- root_node -> REXML::Document | REXML::Node
self が属する文書のルートノードを返します。

通常はその要素が属する文書([[c:REXML::Document]]) オブジェクトが
返されます。

その要素が属する [[c:REXML::Document]] オブジェクトが存在しない
場合は木構造上のルートノードが返されます。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <root>
  <children>
    <grandchildren />
  </children>
  </root>
  EOS
  
  children = doc.get_elements("/root/children").first
  children.name # => "children"
  children.root_node == doc # => true
  grandchildren = doc.get_elements("/root/children/grandchildren").first
  grandchildren.name # => "grandchildren"
  grandchildren.root_node == doc # => true

#@end

--- root -> REXML::Element
self が属する文書のルート要素を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <root>
  <children>
    <grandchildren />
  </children>
  </root>
  EOS
  
  children = doc.get_elements("/root/children").first
  children.name # => "children"
  children.root.name # => "root"
  grandchildren = doc.get_elements("/root/children/grandchildren").first
  grandchildren.name # => "grandchildren"
  grandchildren.root.name # => "root"

--- document -> REXML::Document | nil
self が属する文書([[c:REXML::Document]])オブジェクトを返します。

属する文書がない場合には nil を返します。

--- whitespace -> bool
要素(self)内で空白が考慮されるならば真を返します。

これは、
  * [[m:REXML::Element#context]] に :respect_whitespace も :compress_whitespace も
    含まれない
  * context の :respect_whitespace に self の要素名が含まれていて、
    :compress_whitespace に self の要素名が含まれていない。
    「含まれている」というのには :all が指定されている場合と、
    配列に含まれている場合の両方があります。
のいずれかの場合に真を返します。

要素名として [[m:REXML::Namespace#expanded_name]] が使われるので、
名前空間の prefix は判定に影響します。

--- ignore_whitespace_nodes -> bool
buggy?

#@todo

--- raw -> bool
その要素が raw モードであるならば真を返します。

以下のいずれかであれば、raw モードであると判定されます。
  * [[m:REXML::Element#context]] の :raw が :all である
  * context の :raw の配列に self の要素名が含まれる

--- prefixes -> [String]
self の文脈で定義されている prefix を文字列の配列を返します。

対象の要素とその外側の要素で定義されている prefix を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new("<a xmlns:x='1' xmlns:y='2'><b/><c xmlns:z='3'/></a>")
  doc.elements['//b'].prefixes # => ["x", "y"]

--- namespaces -> {String => String}
self の文脈で定義されている名前空間の情報を返します。

対象の要素とその外側の要素で定義されている名前空間を、{ prefix => 識別子 }
というハッシュテーブルで返します。

  require 'rexml/document'
  doc = REXML::Document.new("<a xmlns:x='1' xmlns:y='2'><b/><c xmlns:z='3'/></a>")
  doc.elements['//b'].namespaces # => {"x"=>"1", "y"=>"2"}

--- namespace(prefix=nil) -> String
self の文脈で prefix が指している名前空間の URI を返します。

prefix を省略すると、デフォルトの名前空間の URI を返します。

prefix で指示される名前空間の宣言が存在しない場合は nil を返します。

  require 'rexml/document'
  doc = REXML::Document.new("<a xmlns='1' xmlns:y='2'><b/><c xmlns:z='3'/><y:d /></a>")
  b = doc.elements['//b']
  b.namespace      # => "1"
  b.namespace("y") # => "2"
  b.namespace("z") # => nil
  d = doc.elements['//y:d']
  d.namespace      # => "2"

--- add_namespace(prefix, uri = nil)
#@todo

--- delete_namespace(namespace = "xmlns")
#@todo

--- add_element(element, attrs = nil)
#@todo

--- delete_element(element)
#@todo

--- has_elements? -> bool
self が一つでも子要素を持つならば true を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new("<a><b/><c>Text</c></a>")
  doc.root.has_elements?               # => true
  doc.elements["/a/b"].has_elements?   # => false
  doc.elements["/a/c"].has_elements?   # => false

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

要素の集合を表すクラスです。

XPath による探索をサポートします。

[[m:REXML::Element#elements]] はこのオブジェクトを返します。
XPath で相対パスを指定した場合は、この REXML::Element#elements の
レシーバが基準要素となります。

== Class Methods

--- new(parent) -> REXML::Elements
空の要素の集合を表すオブジェクトを生成します。

通常は [[m:REXML::Element.new]] によって Elements オブジェクトが
生成されるため、このメソッドを使う必要はありません。

@param parant 親要素オブジェクト

== Instance Methods

--- [](index, name = nil) -> REXML::Element | nil
index が指し示している要素を返します。

index には整数もしくは文字列を指定できます。

index に整数を指定した場合は index 番目の子要素を返します。
index は 1-origin です。つまり
最初の要素の index は 1 であり、 0 ではありません。
n 番目の要素の index は n であり、 n-1 ではありません。
これは XPath の仕様に合わせています。

index に文字列を指定した場合はその文字列を XPath と見なし、
それで指定された要素を返します。
XPath が複数の要素を指している場合は、そのうち一つを返します。
XPath の性質上、子要素でない要素を返す場合もあります。

name は index に整数を指定した場合にのみ意味があります。
name を指定した場合 name という名前を持つ子要素の中で index 番目の
ものを返します。この場合も index は 1-origin です。

整数で指定した場合でも、XPathで指定した場合でも、
指定した要素が存在しない場合は nil を返します。

@param index 取り出したい要素の index (整数)もしくは xpath (文字列)
@param name 子要素の名前(文字列)

==== 例
  require 'rexml/document'
  doc = REXML::Document.new '<a><b/><c id="1"/><c id="2"/><d/></a>'
  doc.root.elements[1]       # => <b/>
  doc.root.elements['c']     # => <c id='1'/>
  doc.root.elements[2,'c']   # => <c id='2'/>
  
  doc = REXML::Document.new '<a><b><c /><a id="1"/></b></a>'
  doc.root.elements["a"]     # => nil
  doc.root.elements["b/a"]   # => <a id='1'/>
  doc.root.elements["/a"]    # => <a> ... </>

--- []=(index, element)
集合に要素 element を追加/更新します。

index で要素の更新する位置を指定します。
index には整数、文字列が指定できます。
整数を指定した場合は index 番目の要素を変更します(1-originです)。
文字列の場合は XPath としてマッチした要素を更新します。

整数/文字列どちらの場合でも対応する要素が存在しない場合は、
末尾に追加されます。

@param index 要素を更新する位置
@param element 要素([[c:REXML::Element]]オブジェクト)

  require 'rexml/document'
  doc = REXML::Document.new '<a/>'
  doc.root.elements[10] = REXML::Element.new('b')
  doc.root.to_s # => "<a><b/></a>"
  doc.root.elements[1] # => <b/>
  doc.root.elements[1] = REXML::Element.new('c')
  doc.root.to_s # => "<a><c/></a>"
  doc.root.elements['c'] = REXML::Element.new('d')
  doc.root.to_s # => "<a><d/></a>"

--- empty? -> bool
子要素を持たない場合に true を返します。


--- index(element) -> Integer
element で指定した要素が何番目の子要素であるかを返します。

element が子要素でない場合は -1 を返します。

返り値は 1-origin です。

@param element インデックスを知りたい要素([[c:REXML::Element]] オブジェクト)
@see [[m:REXML::Element#[] ]]

--- delete(element) -> Element
element で指定した子要素を取り除きます。

element には、[[c:REXML::Element]]、整数、文字列が指定できます。
Element オブジェクトを指定した場合は、その子要素を取り除きます。
整数を指定した場合には element 番目の子要素を削除します(1-originです)。
文字列を指定した場合は、削除する要素を XPath で指定します。
XPathが複数の要素を指している場合は、そのうち一つを削除します。

取り除かれた要素を返します。

XPath で指定した場合、子要素ではない要素も取り除けることに注意してください。

@param element 削除する要素([[c:REXML::Element]], 整数, 文字列)

==== 例
  require 'rexml/document'
  doc = REXML::Document.new '<a><b/><c/><c id="1"/></a>'
  b = doc.root.elements[1]
  doc.root.elements.delete b           # => <b/>
  doc.root.to_s                        # => "<a><c/><c id='1'/></a>"
  doc.elements.delete("a/c[@id='1']")  # => <c id='1'/>
  doc.root.to_s                        # => "<a><c/></a>"
  doc.root.elements.delete 1           # => <c/>
  doc.root.to_s                        # => "<a/>"
  doc.root.elements.delete '/a'
  doc.root.to_s                        # => ""

--- delete_all(xpath) -> [REXML::Element]
xpath で指定した XPath 文字列にマッチする要素をすべて取り除きます。

@param xpath 取り除く要素を指し示す XPath 文字列
==== 例
  require 'rexml/document'
  doc = REXML::Document.new('<a><c/><c/><c/><c/></a>')
  doc.elements.delete_all("a/c") # => [<c/>, <c/>, <c/>, <c/>]
  doc.to_s                       # => "<a/>"
  
--- add(element = nil) -> REXML::Element
--- <<(element = nil) -> REXML::Element

要素 element を追加します。

element には文字列もしくは [[c:REXML::Element]] オブジェクトを
指定します。文字列を指定した場合には [[m:REXML::Element.new]](element)
で生成される要素を追加します。

element を省略した場合は、空の要素が追加されます。

追加された要素が返されます。

@param element 追加する要素

==== 例
  require 'rexml/document'
  a = REXML::Element.new('a')
  a.elements.add(REXML::Element.new('b'))  # => <b/>
  a.to_s # => "<a><b/></a>"
  a.elements.add('c') # => <c/>
  a.to_s # => "<a><b/><c/></a>"

--- each(xpath = nil) {|element| ... } -> [REXML::Elements]
全ての子要素に対しブロックを呼び出します。

xpath を指定した場合には、その XPath 文字列に
マッチする要素に対しブロックを呼び出します。

[[m:REXML::XPath.each]] などとは異なり、要素以外の
テキストノードなどはすべて無視されることに注意してください。

@param xpath XPath文字列

==== 例
  require 'rexml/document'
  require 'rexml/xpath'
  doc = REXML::Document.new '<a><b/><c/><d/>sean<b/><c/><d/></a>'
  # <b/>,<c/>,<d/>,<b/>,<c/>, <d/> がブロックに渡される
  doc.root.elements.each {|e|p e} 
  # <b/>, <b/> がブロックに渡される
  doc.root.elements.each('b') {|e|p e}  #-> Yields b, b elements
  # <b/>,<c/>,<d/>,<b/>,<c/>,<d/> がブロックに渡される
  doc.root.elements.each('child::node()')  {|e|p e}
  # <b/>,<c/>,<d/>,"sean",<b/>,<c/>,<d/> がブロックに渡される
  REXML::XPath.each(doc.root, 'child::node()'){|node| p node }

--- size -> Integer
保持している要素の個数を返します。
  require 'rexml/document'
  doc = REXML::Document.new '<a>sean<b/>elliott<b/>russell<b/></a>'
  # doc.root は3つの要素と3つのテキストノードを持つため、6を返す
  doc.root.size            # => 6
  # そのうち要素は3つであるため、以下は3を返す
  doc.root.elements.size   # => 3

--- to_a(xpath = nil) -> [REXML::Element]
すべての子要素の配列を返します。

xpath を指定した場合は、その XPath 文字列に
マッチする要素の配列を返します。

[[m:REXML::Elements#each]] と同様、[[c:REXML::XPath.match]] などと
異なり、要素以外の子ノードは無視されます。

@param xpath XPath文字列

==== 例
  require 'rexml/document'
  require 'rexml/xpath'
  doc = REXML::Document.new '<a>sean<b/>elliott<c/></a>'
  doc.root.elements.to_a   # => [<b/>, <c/>]
  doc.root.elements.to_a("child::node()") # => [<b/>, <c/>]
  REXML::XPath.match(doc.root, "child::node()") # => ["sean", <b/>, "elliott", <c/>]

#@since 1.8.6
--- collect(xpath = nil) {|element| .. } -> [object]
[[m:Enumerable#collect]] と同様、
各子要素に対しブロックを呼び出し、その返り値の配列を返します。

xpath を指定した場合は、その XPath 文字列に
マッチする要素に対し同様の操作をします。

@param xpath XPath文字列
@see [[m:REXML::Elements#each]]

--- inject(xpath = nil, initial = nil) {|element| ... } -> object
[[m:Enumerable#inject]] と同様、
各子要素に対し畳み込みをします。

xpath を指定した場合は、その XPath 文字列に
マッチする要素に対し同様の操作をします。

@param xpath XPath文字列
@see [[m:REXML::Elements#each]]

#@end

= class REXML::Attributes < Hash
属性の集合を表すクラスです。

[[m:REXML::Element#attributes]] はこのクラスのオブジェクトを返します。
各属性には [[m:REXML::Attributes#[] ]] でアクセスします。

== Class Methods

--- new(element) -> REXML::Attributes
空の Attributes オブジェクトを生成します。

どの要素の属性であるかを element で指定します。

通常は [[m:REXML::Element.new]] によって Attributes オブジェクト
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

名前には expanded_name([[m:REXML::Namespace#exapnded_name]])が
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
