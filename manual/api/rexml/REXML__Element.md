---
library: rexml/document
include:
  - REXML::Namespace
---
# class REXML::Element < REXML::Parent

XML の要素(エレメント、element)を表すクラス。

要素は
  - 子要素(children)
  - 属性(attributes)
  - 名前(name)
を持つものとして特徴付けられます。

また、要素はある別の要素の子となることもできます。

## Class Methods

### def new(arg = UNDEFINED, parent = nil, context = nil) -> REXML::Element
要素オブジェクトを生成します。

arg が文字列の場合、新たな要素の名前は arg に設定されます。
arg が [c:REXML::Element] オブジェクトの場合は、
新たな要素の名前、属性、context が arg のもので初期化されます。

parent で親ノードを指定します。

context には hash table で要素のコンテキストを指定します。
基本的には text node ([c:REXML::Text]) での特別な文字、特に空白について
の取り扱いを指定できます。
#@include(context)

- **param** `arg` -- 要素の名前(String)もしくは初期化に使う [c:REXML::Element]
       オブジェクト
- **param** `parent` -- 親ノード
- **param** `context` -- コンテキスト([c:Hash])
- **SEE** [m:REXML::Parent.new], [m:REXML::Child.new]

## Instance Methods

### def attributes -> REXML::Attributes
要素が保持している属性の集合を返します。

### def elements -> REXML::Elements
要素が保持している子要素の集合を返します。

### def context -> {Symbol => object} | nil

要素の「コンテキスト」を [c:Hash] で返します。

コンテキストとは text node ([c:REXML::Text]) での特別な文字、特に空白について
の取り扱いについての設定です。
#@include(context)

- **SEE** [m:REXML::Element.new], [m:REXML::Element#context=]

### def context=(value)

要素の「コンテキスト」を [c:Hash] で設定します。

コンテキストとは、 text node ([c:REXML::Text]) での特別な文字、特に空白について
の取り扱いについての設定です。
#@include(context)

nil を渡すことでデフォルト値を使うよう指示できます。

- **param** `value` -- 設定値
- **SEE** [m:REXML::Element.new], [m:REXML::Element#context]

#@# #@since 1.8.2
#@# --- inspect
#@# #@todo
#@# #@end

### def clone -> REXML::Element
self を複製して返します。

複製されるのは名前、属性、名前空間のみです。
子ノードは複製されません。

### def root_node -> REXML::Document | REXML::Node
self が属する文書のルートノードを返します。

通常はその要素が属する文書([c:REXML::Document]) オブジェクトが
返されます。

その要素が属する [c:REXML::Document] オブジェクトが存在しない
場合は木構造上のルートノードが返されます。

```ruby
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<root>
<children>
  <grandchildren />
</children>
</root>
EOS

children = doc.get_elements("/root/children").first
p children.name # => "children"
p children.root_node == doc # => true
grandchildren = doc.get_elements("/root/children/grandchildren").first
p grandchildren.name # => "grandchildren"
p grandchildren.root_node == doc # => true
```


### def root -> REXML::Element
self が属する文書のルート要素を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<root>
<children>
  <grandchildren />
</children>
</root>
EOS

children = doc.get_elements("/root/children").first
p children.name # => "children"
p children.root.name # => "root"
grandchildren = doc.get_elements("/root/children/grandchildren").first
p grandchildren.name # => "grandchildren"
p grandchildren.root.name # => "root"
```

### def document -> REXML::Document | nil
self が属する文書([c:REXML::Document])オブジェクトを返します。

属する文書がない場合には nil を返します。

### def whitespace -> bool
要素(self)内で空白が考慮されるならば真を返します。

これは、
  - [m:REXML::Element#context] に :respect_whitespace も :compress_whitespace も
    含まれない
  - context の :respect_whitespace に self の要素名が含まれていて、
    :compress_whitespace に self の要素名が含まれていない。
    「含まれている」というのには :all が指定されている場合と、
    配列に含まれている場合の両方があります。
のいずれかの場合に真を返します。

要素名として [m:REXML::Namespace#expanded_name] が使われるので、
名前空間の prefix は判定に影響します。

#@# --- ignore_whitespace_nodes -> bool
#@# buggy?
#@#
#@# #@todo

### def raw -> bool
その要素が raw モードであるならば真を返します。

以下のいずれかであれば、raw モードであると判定されます。
  - [m:REXML::Element#context] の :raw が :all である
  - context の :raw の配列に self の要素名が含まれる

### def prefixes -> [String]
self の文脈で定義されている prefix を文字列の配列を返します。

対象の要素とその外側の要素で定義されている prefix を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new("<a xmlns:x='1' xmlns:y='2'><b/><c xmlns:z='3'/></a>")
p doc.elements['//b'].prefixes # => ["x", "y"]
```

### def namespaces -> {String => String}
self の文脈で定義されている名前空間の情報を返します。

対象の要素とその外側の要素で定義されている名前空間を、{ prefix => 識別子 }
というハッシュテーブルで返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new("<a xmlns:x='1' xmlns:y='2'><b/><c xmlns:z='3'/></a>")
p doc.elements['//b'].namespaces # => {"x"=>"1", "y"=>"2"}
```

### def namespace(prefix=nil) -> String
self の文脈で prefix が指している名前空間の URI を返します。

prefix を省略すると、デフォルトの名前空間の URI を返します。

prefix で指示される名前空間の宣言が存在しない場合は nil を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new("<a xmlns='1' xmlns:y='2'><b/><c xmlns:z='3'/><y:d /></a>")
b = doc.elements['//b']
p b.namespace    # => "1"
p b.namespace("y") # => "2"
p b.namespace("z") # => nil
d = doc.elements['//y:d']
p d.namespace    # => "2"
```

### def add_namespace(prefix, uri) -> self
### def add_namespace(uri)
名前空間を要素に追加します。

引数が2個の場合は prefix と uri を指定します。
引数が1個の場合はデフォルトの namespace の uri を指定します。

既に同じ prefix が存在する場合はそれが上書きされます。

- **param** `prefix` -- 名前空間の prefix
- **param** `uri` -- 名前空間の uri

```ruby
require 'rexml/document'
a = REXML::Element.new("a")
a.add_namespace("xmlns:foo", "bar" )
a.add_namespace("foo", "bar")  # 上と同じ意味
a.add_namespace("twiddle")
p a.to_s # => "<a xmlns:foo='bar' xmlns='twiddle'/>"
a.add_namespace("foo", "baz")
p a.to_s # => "<a xmlns:foo='baz' xmlns='twiddle'/>"
```

### def delete_namespace(namespace = "xmlns") -> self
名前空間を要素から削除します。

削除可能な名前空間はそのノードで宣言されているもののみです。
上位の要素で宣言されているものは削除できません。

引数を省略した場合はデフォルトの名前空間を削除します。

- **param** `namespace` -- 削除する名前空間の prefix

```ruby
require 'rexml/document'
doc = REXML::Document.new "<a xmlns:foo='bar' xmlns='twiddle'/>"
doc.root.delete_namespace
p doc.to_s # => "<a xmlns:foo='bar'/>"
doc.root.delete_namespace 'foo'
p doc.to_s # => "<a/>"
```

### def add_element(element, attrs = nil) -> Element

子要素を追加します。

element として追加する要素を指定します。
[c:REXML::Element] オブジェクトもしくは文字列を指定します。

element として REXML::Element オブジェクトを指定した場合、それが追加されます。
文字列を指定した場合は、それを要素名とする要素を追加します。

attrs に { String => String } という Hash を渡すと、
追加する要素の属性を指定できます。

子要素の最後に追加されます。

返り値は追加された要素です。

- **param** `element` -- 追加する要素
- **param** `attrs` -- 追加する要素に設定する属性

```ruby
require 'rexml/document'
doc = REXML::Document.new('<a/>')
el = doc.root.add_element 'my-tag' # => <my-tag/>
p doc.root.to_s # => "<a><my-tag/></a>"
el = doc.root.add_element 'my-tag', {'attr1'=>'val1', 'attr2'=>'val2'}
# => <my-tag attr1='val1' attr2='val2'/>
p doc.root.to_s # => "<a><my-tag/><my-tag attr1='val1' attr2='val2'/></a>"
el = REXML::Element.new 'my-tag'
p doc.root.add_element el # => <my-tag/>
p doc.root.to_s # => "<a><my-tag/><my-tag attr1='val1' attr2='val2'/><my-tag/></a>"
```

- **SEE** [m:REXML::Elements#add], [m:REXML::Element.new]

### def delete_element(element) -> REXML::Element

子要素を削除します。

element で削除する要素を指定できます。整数、文字列、[c:REXML::Element]
オブジェクトのいずれかが指定できます。

REXML::Element を指定すると、その要素が削除されます。
整数を指定すると、element 番目の要素を削除します(1-originで指定します)。
文字列を指定すると、XPath としてマッチする要素を削除します。
複数の要素がマッチする場合はそのうち1つが削除されます。

- **param** `element` -- 削除する要素
- **SEE** [m:REXML::Elements#delete]

```ruby
require 'rexml/document'
doc = REXML::Document.new '<a><b/><c/><c id="1"/><d/><c/></a>'
doc.delete_element("/a/b")
p doc.to_s # => "<a><c/><c id='1'/><d/><c/></a>"
doc.delete_element("a/c[@id='1']")
p doc.to_s # => "<a><c/><d/><c/></a>"
doc.root.delete_element("c")
p doc.to_s # => "<a><d/><c/></a>"
doc.root.delete_element("c")
p doc.to_s # => "<a><d/></a>"
doc.root.delete_element(1)
p doc.to_s # => "<a/>"
```

### def has_elements? -> bool
self が一つでも子要素を持つならば true を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new("<a><b/><c>Text</c></a>")
p doc.root.has_elements?             # => true
p doc.elements["/a/b"].has_elements? # => false
# /a/c はテキストノードしか持たないので false である
p doc.elements["/a/c"].has_elements? # => false
```

### def each_element_with_attribute(key, value = nil, max = 0, name = nil) {|element| ... } -> ()

特定の属性を持つすべての子要素を引数としてブロックを呼び出します。

key で指定した属性名の属性を持つ要素のみを対象とします。
value を指定すると、keyで指定した属性名を持つ属性の値がvalueである
もののみを対象とします。
maxを指定すると、対象となる子要素の先頭 max 個のみが対象となります。
name を指定すると、それは xpath 文字列と見なされ、
それにマッチするもののみが対象となります。

max に 0 を指定すると、max の指定は無視されます(0個ではありません)。

- **param** `key` -- 属性名(文字列)
- **param** `value` -- 属性値(文字列)
- **param** `max` -- ブロック呼出の対象とする子要素の最大個数
- **param** `name` -- xpath文字列

```ruby
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
```

### def each_element_with_text(text = nil, max = 0, name = nil) {|element| ... } -> ()
テキストを子ノードとして
持つすべての子要素を引数としてブロックを呼び出します。

text を指定すると、テキストの内容が text であるもののみを対象とします。
maxを指定すると、対象となる子要素の先頭 max 個のみが対象となります。
name を指定すると、それは xpath 文字列と見なされ、
それにマッチするもののみが対象となります。

max に 0 を指定すると、max の指定は無視されます(0個ではありません)。

- **param** `text` -- テキストの中身(文字列)
- **param** `max` -- ブロック呼出の対象とする子要素の最大個数
- **param** `name` -- xpath文字列

```ruby
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
```


### def each_element(xpath = nil) {|element| ... } -> ()
各子要素を引数としてブロックを呼び出します。

xpath に文字列を指定するとそれにマッチする子要素のみを対象とします。

- **param** `xpath` -- XPath 文字列

### def get_elements(xpath) -> [REXML::Element]
xpath にマッチする要素を配列で返します。

xpath には XPath 文字列を指定します。

- **param** `xpath` -- XPath 文字列
- **SEE** [m:REXML::Elements#to_a]

### def next_element -> Element | nil
次の兄弟要素を返します。

次の要素が存在しない場合は nil を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new '<a><b/>text<c/></a>'
p doc.root.elements['b'].next_element # => <c/>
p doc.root.elements['c'].next_element # => nil
```

### def previous_element -> Element | nil
前の兄弟要素を返します。

前の要素が存在しない場合は nil を返します。

### def has_text? -> bool
要素がテキストノードを子ノードとして持つ場合に true を返します。


### def text(path = nil) -> String | nil
先頭のテキスト子ノードの文字列を返します。

テキストノードを複数保持している場合は最初のノードにしか
アクセスできないことに注意してください。

raw モードの設定は無視され、常に正規化されたテキストを返します。
[m:REXML::Text#value] も参照してください。

path を渡した場合は、その XPath 文字列で指定される
テキストノードの文字列を返します。

テキストノードがない場合には nil を返します。

- **param** `path` -- XPath文字列
- **SEE** [m:REXML::Element#get_text]

```ruby
require 'rexml/document'
doc = REXML::Document.new "<p>some text <b>this is bold!</b> more text</p>"
# doc.root (<p> ... </p>) は2つのテキストノード("some text " と " more text"
# を持っているが、前者を返す
p doc.root.text # => "some text "
```

### def get_text(path = nil) -> REXML::Text | nil
先頭のテキスト子ノードを返します。

raw モードの設定は無視され、常に正規化されたテキストを返します。
[m:REXML::Text#value] も参照してください。

path を渡した場合は、その XPath 文字列で指定される
テキストノードの文字列を返します。

テキストノードがない場合には nil を返します。

- **param** `path` -- XPath文字列
- **SEE** [m:REXML::Element#text]

```ruby
require 'rexml/document'
doc = REXML::Document.new "<p>some text <b>this is bold!</b> more text</p>"
# doc.root (<p> ... </p>) は2つのテキストノード("some text " と " more text"
# を持っているが、前者を返す
p doc.root.get_text.value # => "some text "
```

### def text=(text)
「先頭の」テキストノードを text で置き換えます。

テキストノードを1つ以上保持している場合はそのうち
最初のノードを置き換えます。

要素がテキストノードを保持していない場合は新たなテキストノードが追加されます。

text には文字列、[c:REXML::Text]、nil のいずれかが指定できます。
REXML::Text オブジェクトを指定した場合には、それが設定され、
文字列を指定した場合には
[m:REXML::Text.new](text, whitespace(), nil, raw())
で生成される Text オブジェクトが設定されます。
nil を指定すると最初のテキストノードが削除されます。

- **param** `text` -- 置き換え後のテキスト(文字列、[c:REXML::Text], nil(削除))

```ruby
require 'rexml/document'
doc = REXML::Document.new('<a><b/></a>')
p doc.to_s # => "<a><b/></a>"
doc.root.text = "Foo"; doc.to_s # => "<a><b/>Foo</a>"
doc.root.text = "Bar"; doc.to_s # => "<a><b/>Bar</a>"
doc.root.add_element "c"
doc.root.text = "Baz"; doc.to_s # => "<a><b/>Baz<c/></a>"
doc.root.text = nil; doc.to_s # => "<a><b/><c/></a>"
```

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

### def node_type -> Symbol
シンボル :element を返します。


### def xpath -> String
文書上の対象の要素にのみマッチする xpath 文字列を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new('<a><b/><c/></a>')
c = doc.root.elements[2] # <a> .. </a> の中の <c/> 要素
p c # => <c/>
p c.xpath # => "/a/c"
doc = REXML::Document.new('<a><b/><b/></a>')
b = doc.root.elements[2] # <a> .. </a> の中の2番目の <b/> 要素
p b # => <b/>
p b.xpath # => "/a/b[2]"
```


### def attribute(name, namespace = nil) -> REXML::Attribute | nil

name で指定される属性を返します。

属性は [c:REXML::Attribute] オブジェクトの形で返します。

name は "foo:bar" のように prefix を指定できます。

namespace で名前空間の URI を指定することで、その名前空間内で
name という属性名を持つ属性を指定できます。

指定した属性名の属性がない場合は nil を返します。

- **param** `name` -- 属性名(文字列)
- **param** `namespace` -- 名前空間のURI(文字列)
  ```ruby
  require 'rexml/document'

  doc = REXML::Document.new(<<-EOS)
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar">
    <a foo:att='1' bar:att='2' att='&lt;'/>
  </root>
  EOS
  a = doc.get_elements("/root/a").first
  p a.attribute("att") # => att='&lt;'
  p a.attribute("att", "http://example.org/bar") # => bar:att='2'
  p a.attribute("bar:att") # => bar:att='2'
  p a.attribute("baz") # => nil
  ```

### def has_attributes? -> bool
要素が属性を1つ以上持っていれば真を返します。

### def add_attribute(key, value) -> ()
### def add_attribute(attr) -> ()
要素の属性を追加します。
同じ名前の属性がすでにある場合はその属性を新しい
属性で置き換えます。

引数の与えかたは2通りあります。
要素名と値の2つの文字列で渡す方法と [c:REXML::Attribute] オブジェクトを
渡す方法です。

文字列2つで指定する場合、属性値は unnormalized な文字列を渡す必要があります。

- **param** `key` -- 属性名(文字列)
- **param** `value` -- 属性値(文字列)
- **param** `attr` -- 属性([c:REXML::Attribute] オブジェクト)

```ruby
require 'rexml/document'
doc = REXML::Document.new("<e/>")
p doc.root.add_attribute("a", "b"); doc.root # => <e a='b'/>
p doc.root.add_attribute("x:a", "c"); doc.root # => <e a='b' x:a='c'/>
doc.root.add_attribute(REXML::Attribute.new("b", "d"))
p doc.root # => <e a='b' x:a='c' b='d'/>
```

### def add_attributes(attrs) -> ()
要素の属性を複数追加します。
同じ名前の属性がすでにある場合はその属性を新しい
属性で置き換えます。

attrs には [c:Hash] もしくは [c:Array] を指定できます。
Hash の場合は、
```text
{ "name1" => "value1", "name2" => "value2", ... }
```
という形で、配列の場合は
```text
[ ["name1", "value1"], ["name2", "value2"], ... }
```
という形で追加/更新する属性を指定します。

- **param** `attrs` -- 追加する属性の属性名と属性値の対の集合(Array or Hash)

```ruby
require 'rexml/document'
e = REXML::Element.new("e")
e.add_attributes({"a" => "b", "c" => "d"})
p e # => <e a='b' c='d'/>
e = REXML::Element.new("e")
e.add_attributes([["a", "b"], ["c", "d"]])
p e # => <e a='b' c='d'/>
```

### def delete_attribute(key) -> REXML::Attribute | nil
要素から key という属性名の属性を削除します。

削除された属性を返します。

key という属性名の属性が存在しない場合は削除されずに、nil を返します。

- **param** `key` -- 削除する要素(文字列(属性名) or [c:REXML::Attribute]オブジェクト)

```ruby
require 'rexml/document'
e = REXML::Element.new("E")
p e.add_attribute("x", "foo"); e # => <E x='foo'/>
p e.add_attribute("y:x", "bar"); e # => <E x='foo' y:x='bar'/>
p e.delete_attribute("x"); e # => <E y:x='bar'/>
```

### def cdatas -> [REXML::CData]
すべての cdata 子ノードの配列を返します。

返される配列は freeze されます。

### def comments -> [REXML::Comments]
すべての comment 子ノードの配列を返します。

返される配列は freeze されます。

### def instructions -> [REXML::Instraction]
すべての instruction 子ノードの配列を返します。

返される配列は freeze されます。

### def texts -> [REXML::Texts]
すべてのテキスト子ノードの配列を返します。

返される配列は freeze されます。

### def write(output = $stdout, indent = -1, transitive = false, ie_hack = false)
このメソッドは deprecated です。 [c:REXML::Formatter] を代わりに
使ってください。

output にその要素を文字列化したものを(子要素を含め)出力します。

- **param** `output` -- 出力先([c:IO] のように << で書き込めるオブジェクト)
- **param** `indent` -- インデントのスペースの数(-1 だとインデントしない)
- **param** `transitive` -- XMLではインデントのスペースでDOMが変化してしまう場合がある。
       これに真を渡すと、XMLのDOMに余計な要素が加わらないように
       空白の出力を適当に抑制するようになる
- **param** `ie_hack` -- IEはバージョンによってはXMLをちゃんと解釈できないので、
       それに対応したXMLを出力するかどうかを真偽値で指定する

## Constants

### const UNDEFINED -> String
"UNDEFINED" という文字列。

