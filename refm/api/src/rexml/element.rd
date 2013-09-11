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
#@include(context)

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

--- context -> {Symbol => objet} | nil

要素の「コンテキスト」を [[c:Hash]] で返します。

コンテキストとは text node ([[c:REXML::Text]]) での特別な文字、特に空白について
の取り扱いについての設定です。
#@include(context)

@see [[m:REXML::Element.new]], [[m:REXML::Element#context=]]

--- context=(value)

要素の「コンテキスト」を [[c:Hash]] で設定します。

コンテキストとは、 text node ([[c:REXML::Text]]) での特別な文字、特に空白について
の取り扱いについての設定です。
#@include(context)

nil を渡すことでデフォルト値を使うよう指示できます。

@param value 設定値
@see [[m:REXML::Element.new]], [[m:REXML::Element#context]]

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

#@# --- ignore_whitespace_nodes -> bool
#@# buggy?
#@# 
#@# #@todo

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

--- add_namespace(prefix, uri) -> self
--- add_namespace(uri)
名前空間を要素に追加します。

引数が2個の場合は prefix と uri を指定します。
引数が1個の場合はデフォルトの namespace の uri を指定します。

既に同じ prefix が存在する場合はそれが上書きされます。

@param prefix 名前空間の prefix
@param uri 名前空間の uri

==== 例
  require 'rexml/document'
  a = REXML::Element.new("a")
  a.add_namespace("xmlns:foo", "bar" )
  a.add_namespace("foo", "bar")  # 上と同じ意味
  a.add_namespace("twiddle")
  a.to_s # => "<a xmlns:foo='bar' xmlns='twiddle'/>"
  a.add_namespace("foo", "baz") 
  a.to_s # => "<a xmlns:foo='baz' xmlns='twiddle'/>"

--- delete_namespace(namespace = "xmlns") -> self
名前空間を要素から削除します。

削除可能な名前空間はそのノードで宣言されているもののみです。
上位の要素で宣言されているものは削除できません。

引数を省略した場合はデフォルトの名前空間を削除します。

@param namespace 削除する名前空間の prefix

==== 例
  require 'rexml/document'
  doc = REXML::Document.new "<a xmlns:foo='bar' xmlns='twiddle'/>"
  doc.root.delete_namespace
  doc.to_s # => "<a xmlns:foo='bar'/>"
  doc.root.delete_namespace 'foo'
  doc.to_s # => "<a/>"

--- add_element(element, attrs = nil) -> Element

子要素を追加します。

element として追加する要素を指定します。
[[c:REXML::Element]] オブジェクトもしくは文字列を指定します。

element として REXML::Element オブジェクトを指定した場合、それが追加されます。
文字列を指定した場合は、それを要素名とする要素を追加します。

attrs に { String => String } という Hash を渡すと、
追加する要素の属性を指定できます。

子要素の最後に追加されます。

返り値は追加された要素です。

@param element 追加する要素
@param attrs 追加する要素に設定する属性

==== 例
  require 'rexml/document'
  doc = REXML::Document.new('<a/>')
  el = doc.root.add_element 'my-tag' # => <my-tag/>
  doc.root.to_s # => "<a><my-tag/></a>"
  el = doc.root.add_element 'my-tag', {'attr1'=>'val1', 'attr2'=>'val2'}
  # => <my-tag attr1='val1' attr2='val2'/>
  doc.root.to_s # => "<a><my-tag/><my-tag attr1='val1' attr2='val2'/></a>"
  el = REXML::Element.new 'my-tag'
  doc.root.add_element el # => <my-tag/>
  doc.root.to_s # => "<a><my-tag/><my-tag attr1='val1' attr2='val2'/><my-tag/></a>"

@see [[m:REXML::Elements#add]], [[m:REXML::Element.new]]

--- delete_element(element) -> REXML::Element

子要素を削除します。

element で削除する要素を指定できます。整数、文字列、[[c:REXML::Element]]
オブジェクトのいずれかが指定できます。

REXML::Element を指定すると、その要素が削除されます。
整数を指定すると、element 番目の要素を削除します(1-originで指定します)。
文字列を指定すると、XPath としてマッチする要素を削除します。
複数の要素がマッチする場合はそのうち1つが削除されます。

@param element 削除する要素
@see [[m:REXML::Elements#delete]]

  require 'rexml/document'
  doc = REXML::Document.new '<a><b/><c/><c id="1"/><d/><c/></a>'
  doc.delete_element("/a/b")
  doc.to_s # => "<a><c/><c id='1'/><d/><c/></a>"
  doc.delete_element("a/c[@id='1']")
  doc.to_s # => "<a><c/><d/><c/></a>"
  doc.root.delete_element("c")
  doc.to_s # => "<a><d/><c/></a>"
  doc.root.delete_element("c")
  doc.to_s # => "<a><d/></a>"
  doc.root.delete_element(1)
  doc.to_s # => "<a/>"

--- has_elements? -> bool
self が一つでも子要素を持つならば true を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new("<a><b/><c>Text</c></a>")
  doc.root.has_elements?               # => true
  doc.elements["/a/b"].has_elements?   # => false
  # /a/c はテキストノードしか持たないので false である
  doc.elements["/a/c"].has_elements?   # => false

--- each_element_with_attribute(key, value = nil, max = 0, name = nil) {|element| ... } -> ()

特定の属性を持つすべての子要素を引数としてブロックを呼び出します。

key で指定した属性名の属性を持つ要素のみを対象とします。
value を指定すると、keyで指定した属性名を持つ属性の値がvalueである
もののみを対象とします。
maxを指定すると、対象となる子要素の先頭 max 個のみが対象となります。
name を指定すると、それは xpath 文字列と見なされ、
それにマッチするもののみが対象となります。

max に 0 を指定すると、max の指定は無視されます(0個ではありません)。

@param key 属性名(文字列)
@param value 属性値(文字列)
@param max ブロック呼出の対象とする子要素の最大個数
@param name xpath文字列

==== 例
  require 'rexml/document'
  doc = REXML::Document.new("<a><b id='1'/><c id='2'/><d id='1'/><e/></a>")
  doc.root.each_element_with_attribute('id'){|e| p e }
  # >> <b id='1'/>
  # >> <c id='2'/>
  # >> <d id='1'/>
  doc.root.each_element_with_attribute('id', '1'){|e| p e }
  # >> <b id='1'/>
  # >> <d id='1'/>
  doc.root.each_element_with_attribute('id', '1', 1){|e| p e }
  # >> <b id='1'/>
  doc.root.each_element_with_attribute('id', '1', 0, 'd'){|e| p e }
  # >> <d id='1'/>
  
--- each_element_with_text(text = nil, max = 0, name = nil) {|element| ... } -> ()
テキストを子ノードとして
持つすべての子要素を引数としてブロックを呼び出します。

text を指定すると、テキストの内容が text であるもののみを対象とします。
maxを指定すると、対象となる子要素の先頭 max 個のみが対象となります。
name を指定すると、それは xpath 文字列と見なされ、
それにマッチするもののみが対象となります。

max に 0 を指定すると、max の指定は無視されます(0個ではありません)。

@param text テキストの中身(文字列)
@param max ブロック呼出の対象とする子要素の最大個数
@param name xpath文字列

=== 例
  require 'rexml/document'
  doc = REXML::Document.new '<a><b>b</b><c>b</c><d>d</d><e/></a>'
  doc.root.each_element_with_text {|e|p e}
  # >> <b> ... </>
  # >> <c> ... </>
  # >> <d> ... </>
  doc.root.each_element_with_text('b'){|e|p e}
  # >> <b> ... </>
  # >> <c> ... </>
  doc.root.each_element_with_text('b', 1){|e|p e}
  # >> <b> ... </>
  doc.root.each_element_with_text(nil, 0, 'd'){|e|p e}
  # >> <d> ... </>


--- each_element(xpath = nil) {|element| ... } -> ()
各子要素を引数としてブロックを呼び出します。

xpath に文字列を指定するとそれにマッチする子要素のみを対象とします。

@param xpath XPath 文字列

--- get_elements(xpath) -> [REXML::Element]
xpath にマッチする要素を配列で返します。

xpath には XPath 文字列を指定します。

@param xpath XPath 文字列
@see [[m:REXML::Elements#to_a]]

--- next_element -> Element | nil
次の兄弟要素を返します。

次の要素が存在しない場合は nil を返します。

  require 'rexml/document'
  doc = REXML::Document.new '<a><b/>text<c/></a>'
  doc.root.elements['b'].next_element # => <c/>
  doc.root.elements['c'].next_element # => nil

--- previous_element -> Element | nil
前の兄弟要素を返します。

前の要素が存在しない場合は nil を返します。

--- has_text? -> bool
要素がテキストノードを子ノードとして持つ場合に true を返します。


--- text(path = nil) -> String | nil
先頭のテキスト子ノードの文字列を返します。

テキストノードを複数保持している場合は最初のノードにしか
アクセスできないことに注意してください。

raw モードの設定は無視され、常に正規化されたテキストを返します。
[[m:REXML::Text#value]] も参照してください。

path を渡した場合は、その XPath 文字列で指定される
テキストノードの文字列を返します。

テキストノードがない場合には nil を返します。

@param path XPath文字列
@see [[m:REXML::Element#get_text]]

==== 例
  require 'rexml/document'
  doc = REXML::Document.new "<p>some text <b>this is bold!</b> more text</p>"
  # doc.root (<p> ... </p>) は2つのテキストノード("some text " と " more text"
  # を持っているが、前者を返す
  doc.root.text # => "some text "

--- get_text(path = nil) -> REXML::Text | nil
先頭のテキスト子ノードを返します。

raw モードの設定は無視され、常に正規化されたテキストを返します。
[[m:REXML::Text#value]] も参照してください。

path を渡した場合は、その XPath 文字列で指定される
テキストノードの文字列を返します。

テキストノードがない場合には nil を返します。

@param path XPath文字列
@see [[m:REXML::Element#text]]

==== 例
  require 'rexml/document'
  doc = REXML::Document.new "<p>some text <b>this is bold!</b> more text</p>"
  # doc.root (<p> ... </p>) は2つのテキストノード("some text " と " more text"
  # を持っているが、前者を返す
  doc.root.get_text.value # => "some text "

--- text=(text)
「先頭の」テキストノードを text で置き換えます。

テキストノードを1つ以上保持している場合はそのうち
最初のノードを置き換えます。

要素がテキストノードを保持していない場合は新たなテキストノードが追加されます。

text には文字列、[[c:REXML::Text]]、nil のいずれかが指定できます。
REXML::Text オブジェクトを指定した場合には、それが設定され、
文字列を指定した場合には
[[m:REXML::Text.new]](text, whitespace(), nil, raw())
で生成される Text オブジェクトが設定されます。
nil を指定すると最初のテキストノードが削除されます。

@param text 置き換え後のテキスト(文字列、[[c:REXML::Text]], nil(削除))

==== 例
  require 'rexml/document'
  doc = REXML::Document.new('<a><b/></a>')
  doc.to_s # => "<a><b/></a>"
  doc.root.text = "Foo"; doc.to_s # => "<a><b/>Foo</a>"
  doc.root.text = "Bar"; doc.to_s # => "<a><b/>Bar</a>"
  doc.root.add_element "c"
  doc.root.text = "Baz"; doc.to_s # => "<a><b/>Baz<c/></a>"
  doc.root.text = nil; doc.to_s # => "<a><b/><c/></a>"

#@# いまいち buggy なのでとりあえず comment out する
#@# REXML::Text#<< の問題
#@# --- add_text(text) -> self
#@# テキストノードを子ノードとして追加します。
#@# 
#@# text には文字列もしくは [[c:REXML::Text]] を指定できます。
#@# 
#@# @param text 
#@# @see [[m:REXML::Element#add]]
#@# 
#@# ==== 例
#@#   require 'rexml/document'
#@#   doc = REXML::Document.new("<e/>")
#@#   doc.to_s # => "<e/>"
#@#   doc.root.add_text("Foo"); doc.to_s # => "<e>Foo</e>"
#@#   doc.root.add_text(REXML::Text.new("Bar")); doc.to_s # => "<e>FooBar</e>"
#@#   doc.to_s # => "<e>FooBar</e>"
#@#   # Foo と Bar の2つのノードがある
#@#   REXML::XPath.match(doc.root, "child::node()") # => ["Foo", "Bar"]

--- node_type -> Symbol
シンボル :element を返します。


#@since 1.8.2
--- xpath -> String
文書上の対象の要素にのみマッチする xpath 文字列を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new('<a><b/><c/></a>')
  c = doc.root.elements[2] # <a> .. </a> の中の <c/> 要素
  c # => <c/>
  c.xpath # => "/a/c"
  doc = REXML::Document.new('<a><b/><b/></a>')
  b = doc.root.elements[2] # <a> .. </a> の中の2番目の <b/> 要素
  b # => <b/>
  b.xpath # => "/a/b[2]"

#@end

--- attribute(name, namespace = nil) -> REXML::Attribute | nil

name で指定される属性を返します。

属性は [[c:REXML::Attribute]] オブジェクトの形で返します。

name は "foo:bar" のように prefix を指定することができます。

namespace で名前空間の URI を指定することで、その名前空間内で
name という属性名を持つ属性を指定できます。

指定した属性名の属性がない場合は nil を返します。

@param name 属性名(文字列)
@param namespace 名前空間のURI(文字列)
==== 例
  require 'rexml/document'
  
  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  a.attribute("att") # => att='&lt;'
  a.attribute("att", "http://example.org/bar") # => bar:att='2'
  a.attribute("bar:att") # => bar:att='2'
  a.attribute("baz") # => nil

--- has_attributes? -> bool
要素が属性を1つ以上持っていれば真を返します。

--- add_attribute(key, value) -> ()
--- add_attribute(attr) -> ()
要素の属性を追加します。
同じ名前の属性がすでにある場合はその属性を新しい
属性で置き換えます。

引数の与えかたは2通りあります。
要素名と値の2つの文字列で渡す方法と [[c:REXML::Attribute]] オブジェクトを
渡す方法です。

文字列2つで指定する場合、属性値は unnormalized な文字列を渡す必要があります。

@param key 属性名(文字列)
@param value 属性値(文字列)
@param attr 属性([[c:REXML::Attribute]] オブジェクト)

==== 例
  require 'rexml/document'
  doc = REXML::Document.new("<e/>")
  doc.root.add_attribute("a", "b"); doc.root # => <e a='b'/>
  doc.root.add_attribute("x:a", "c"); doc.root # => <e a='b' x:a='c'/>
  doc.root.add_attribute(REXML::Attribute.new("b", "d"))
  doc.root # => <e a='b' x:a='c' b='d'/>

--- add_attributes(attrs) -> ()
要素の属性を複数追加します。
同じ名前の属性がすでにある場合はその属性を新しい
属性で置き換えます。

attrs には [[c:Hash]] もしくは [[c:Array]] を指定できます。
Hash の場合は、
  { "name1" => "value1", "name2" => "value2", ... }
という形で、配列の場合は
  [ ["name1", "value1"], ["name2", "value2"], ... }
という形で追加/更新する属性を指定します。

@param attrs 追加する属性の属性名と属性値の対の集合(Array or Hash)

==== 例
  require 'rexml/document'
  e = REXML::Element.new("e")
  e.add_attributes({"a" => "b", "c" => "d"})
  e # => <e a='b' c='d'/>
  e = REXML::Element.new("e")
  e.add_attributes([["a", "b"], ["c", "d"]])
  e # => <e a='b' c='d'/>

--- delete_attribute(key) -> REXML::Attribute | nil
要素から key という属性名の属性を削除します。

削除された属性を返します。

key という属性名の属性が存在しない場合は削除されずに、nil を返します。

@param key 削除する要素(文字列(属性名) or [[c:REXML::Attribute]]オブジェクト)

==== 例
  require 'rexml/document'
  e = REXML::Element.new("E")
  e.add_attribute("x", "foo"); e # => <E x='foo'/>
  e.add_attribute("y:x", "bar"); e # => <E x='foo' y:x='bar'/>
  e.delete_attribute("x"); e # => <E y:x='bar'/>

--- cdatas -> [REXML::CData]
すべての cdata 子ノードの配列を返します。

返される配列は freeze されます。

--- comments -> [REXML::Comments]
すべての comment 子ノードの配列を返します。

返される配列は freeze されます。

--- instructions -> [REXML::Instraction]
すべての instruction 子ノードの配列を返します。

返される配列は freeze されます。

--- texts -> [REXML::Texts]
すべてのテキスト子ノードの配列を返します。

返される配列は freeze されます。

--- write(output = $stdout, indent = -1, transitive = false, ie_hack = false)
このメソッドは deprecated です。 [[c:REXML::Formatter]] を代わりに
使ってください。

output にその要素を文字列化したものを(子要素を含め)出力します。

@param output 出力先([[c:IO]] のように << で書き込めるオブジェクト)
@param indent インデントのスペースの数(-1 だとインデントしない)
@param transitive XMLではインデントのスペースでDOMが変化してしまう場合がある。
       これに真を渡すと、XMLのDOMに余計な要素が加わらないように
       空白の出力を適当に抑制するようになる
@param ie_hack IEはバージョンによってはXMLをちゃんと解釈できないので、
       それに対応したXMLを出力するかどうかを真偽値で指定する

== Constants

--- UNDEFINED -> String
"UNDEFINED" という文字列。

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
--- to_a -> [Attribute]

属性の配列を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new("<a x='1' y='2' z='3' />")
  doc.root.attributes.to_a # => [x='1', y='2', z='3']

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
