---
library: rexml/document
include:
  - Enumerable
---
# class REXML::Elements

要素の集合を表すクラスです。

XPath による探索をサポートします。

[m:REXML::Element#elements] はこのオブジェクトを返します。
XPath で相対パスを指定した場合は、この REXML::Element#elements の
レシーバが基準要素となります。

## Class Methods

### def new(parent) -> REXML::Elements
空の要素の集合を表すオブジェクトを生成します。

通常は [m:REXML::Element.new] によって Elements オブジェクトが
生成されるため、このメソッドを使う必要はありません。

- **param** `parant` -- 親要素オブジェクト

## Instance Methods

### def [](index, name = nil) -> REXML::Element | nil
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

- **param** `index` -- 取り出したい要素の index (整数)もしくは xpath (文字列)
- **param** `name` -- 子要素の名前(文字列)

```ruby
require 'rexml/document'
doc = REXML::Document.new '<a><b/><c id="1"/><c id="2"/><d/></a>'
p doc.root.elements[1]     # => <b/>
p doc.root.elements['c']   # => <c id='1'/>
p doc.root.elements[2,'c'] # => <c id='2'/>

doc = REXML::Document.new '<a><b><c /><a id="1"/></b></a>'
p doc.root.elements["a"]   # => nil
p doc.root.elements["b/a"] # => <a id='1'/>
p doc.root.elements["/a"]  # => <a> ... </>
```

### def []=(index, element)
集合に要素 element を追加/更新します。

index で要素の更新する位置を指定します。
index には整数、文字列が指定できます。
整数を指定した場合は index 番目の要素を変更します(1-originです)。
文字列の場合は XPath としてマッチした要素を更新します。

整数/文字列どちらの場合でも対応する要素が存在しない場合は、
末尾に追加されます。

- **param** `index` -- 要素を更新する位置
- **param** `element` -- 要素([c:REXML::Element]オブジェクト)

```ruby
require 'rexml/document'
doc = REXML::Document.new '<a/>'
doc.root.elements[10] = REXML::Element.new('b')
p doc.root.to_s # => "<a><b/></a>"
p doc.root.elements[1] # => <b/>
doc.root.elements[1] = REXML::Element.new('c')
p doc.root.to_s # => "<a><c/></a>"
doc.root.elements['c'] = REXML::Element.new('d')
p doc.root.to_s # => "<a><d/></a>"
```

### def empty? -> bool
子要素を持たない場合に true を返します。


### def index(element) -> Integer
element で指定した要素が何番目の子要素であるかを返します。

element が子要素でない場合は -1 を返します。

返り値は 1-origin です。

- **param** `element` -- インデックスを知りたい要素([c:REXML::Element] オブジェクト)
- **SEE** [m:REXML::Element#\[\]]

### def delete(element) -> Element
element で指定した子要素を取り除きます。

element には、[c:REXML::Element]、整数、文字列が指定できます。
Element オブジェクトを指定した場合は、その子要素を取り除きます。
整数を指定した場合には element 番目の子要素を削除します(1-originです)。
文字列を指定した場合は、削除する要素を XPath で指定します。
XPathが複数の要素を指している場合は、そのうち一つを削除します。

取り除かれた要素を返します。

XPath で指定した場合、子要素ではない要素も取り除けることに注意してください。

- **param** `element` -- 削除する要素([c:REXML::Element], 整数, 文字列)

```ruby
require 'rexml/document'
doc = REXML::Document.new '<a><b/><c/><c id="1"/></a>'
b = doc.root.elements[1]
p doc.root.elements.delete b         # => <b/>
p doc.root.to_s                      # => "<a><c/><c id='1'/></a>"
p doc.elements.delete("a/c[@id='1']")  # => <c id='1'/>
p doc.root.to_s                      # => "<a><c/></a>"
p doc.root.elements.delete 1         # => <c/>
p doc.root.to_s                      # => "<a/>"
doc.root.elements.delete '/a'
p doc.root.to_s                      # => ""
```

### def delete_all(xpath) -> [REXML::Element]
xpath で指定した XPath 文字列にマッチする要素をすべて取り除きます。

- **param** `xpath` -- 取り除く要素を指し示す XPath 文字列

```ruby
require 'rexml/document'
doc = REXML::Document.new('<a><c/><c/><c/><c/></a>')
p doc.elements.delete_all("a/c") # => [<c/>, <c/>, <c/>, <c/>]
p doc.to_s                     # => "<a/>"
```

### def add(element = nil) -> REXML::Element
### def <<(element = nil) -> REXML::Element

要素 element を追加します。

element には文字列もしくは [c:REXML::Element] オブジェクトを
指定します。文字列を指定した場合には [m:REXML::Element.new](element)
で生成される要素を追加します。

element を省略した場合は、空の要素が追加されます。

追加された要素が返されます。

- **param** `element` -- 追加する要素

```ruby
require 'rexml/document'
a = REXML::Element.new('a')
p a.elements.add(REXML::Element.new('b'))  # => <b/>
p a.to_s # => "<a><b/></a>"
p a.elements.add('c') # => <c/>
p a.to_s # => "<a><b/><c/></a>"
```

### def each(xpath = nil) {|element| ... } -> [REXML::Elements]
全ての子要素に対しブロックを呼び出します。

xpath を指定した場合には、その XPath 文字列に
マッチする要素に対しブロックを呼び出します。

[m:REXML::XPath.each] などとは異なり、要素以外の
テキストノードなどはすべて無視されることに注意してください。

- **param** `xpath` -- XPath文字列

```ruby
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
```

### def size -> Integer
保持している要素の個数を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new '<a>sean<b/>elliott<b/>russell<b/></a>'
# doc.root は3つの要素と3つのテキストノードを持つため、6を返す
p doc.root.size          # => 6
# そのうち要素は3つであるため、以下は3を返す
p doc.root.elements.size # => 3
```

### def to_a(xpath = nil) -> [REXML::Element]
すべての子要素の配列を返します。

xpath を指定した場合は、その XPath 文字列に
マッチする要素の配列を返します。

[m:REXML::Elements#each] と同様、[c:REXML::XPath.match] などと
異なり、要素以外の子ノードは無視されます。

- **param** `xpath` -- XPath文字列

```ruby
require 'rexml/document'
require 'rexml/xpath'
doc = REXML::Document.new '<a>sean<b/>elliott<c/></a>'
p doc.root.elements.to_a # => [<b/>, <c/>]
p doc.root.elements.to_a("child::node()") # => [<b/>, <c/>]
p REXML::XPath.match(doc.root, "child::node()") # => ["sean", <b/>, "elliott", <c/>]
```

### def collect(xpath = nil) {|element| .. } -> [object]
[m:Enumerable#collect] と同様、
各子要素に対しブロックを呼び出し、その返り値の配列を返します。

xpath を指定した場合は、その XPath 文字列に
マッチする要素に対し同様の操作をします。

- **param** `xpath` -- XPath文字列
- **SEE** [m:REXML::Elements#each]

### def inject(xpath = nil, initial = nil) {|element| ... } -> object
[m:Enumerable#inject] と同様、
各子要素に対し畳み込みをします。

xpath を指定した場合は、その XPath 文字列に
マッチする要素に対し同様の操作をします。

- **param** `xpath` -- XPath文字列
- **SEE** [m:REXML::Elements#each]


