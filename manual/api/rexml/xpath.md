---
library: rexml/document
include:
  - REXML::Functions
---
# class REXML::XPath < Object

XPath を取り扱うためのクラスです。

インスタンスは使わずにクラスメソッドのみを使います。

## Class Methods

### def first(element, path = nil, namespaces = {}, variables = {}) -> Node | nil

element の path で指定した XPath 文字列にマッチする最初のノードを
返します。

path に相対パスを指定した場合は element からの相対位置で
マッチするノードを探します。
絶対パスを指定した場合は element が属する文書のルート要素からの
位置でマッチするノードを探します。
path を省略すると "*" を指定したことになります。

namespace で名前空間の対応付けを指定します。

variable で XPath 内の変数に対応する値を指定できます。
XPathインジェクション攻撃を避けるため、適切な
エスケープを付加するため、に用います。

マッチするノードがない場合には nil を返します。

- **param** `element` -- 要素([c:REXML::Element])
- **param** `path` -- XPath文字列
- **param** `namespace` -- 名前空間とURLの対応付け
- **param** `variables` -- 変数名とその値の対応付け

```ruby
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<root xmlns:x='1'>
  <a>
    <b>b1</b>
    <x:c />
    <b>b2</b>
    <d />
  </a>
  <b> b3 </b>
</root>
EOS

a = doc.root.elements[1] # => <a> ... </>
b1 = REXML::XPath.first(a, "b")
p b1.text # => "b1"

p REXML::XPath.first(doc, "/root/a/x:c") # => <x:c/>
p REXML::XPath.first(a, "x:c") # => <x:c/>
p REXML::XPath.first(a, "y:c") # => nil
p REXML::XPath.first(a, "y:c", {"y" => "1"}) # => <x:c/>
b2 = REXML::XPath.first(doc, "/root/a/b[text()=$v]", {}, {"v" => "b2"})
p b2 # => <b> ... </>
p b2.text # => "b2"
```

### def each(element, path = nil, namespaces = {}, variables = {}) {|e| ... } -> ()

element の path で指定した XPath 文字列にマッチする各ノード
に対してブロックを呼び出します。

path に相対パスを指定した場合は element からの相対位置で
マッチするノードを探します。
絶対パスを指定した場合は element が属する文書のルート要素からの
位置でマッチするノードを探します。
path を省略すると "*" を指定したことになります。

namespace で名前空間の対応付けを [c:Hash] で指定します。

variable で XPath 内の変数に対応する値を指定できます。
XPathインジェクション攻撃を避けるため、適切な
エスケープを付加するため、に用います。

- **param** `element` -- 要素([c:REXML::Element])
- **param** `path` -- XPath文字列
- **param** `namespace` -- 名前空間とURLの対応付け
- **param** `variables` -- 変数名とその値の対応付け

```ruby
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<root xmlns:x='1'>
  <a>
    <b>b1</b>
    <x:c />
    <b>b2</b>
    <d />
  </a>
  <b> b3 </b>
</root>
EOS

REXML::XPath.each(doc, "/root/a/b"){|e| p e.text }
# >> "b1"
# >> "b2"
```

### def match(element, path = nil, namespaces = {}, variables = {}) -> [Node]

element の path で指定した XPath 文字列にマッチするノードの配列を
返します。

path に相対パスを指定した場合は element からの相対位置で
マッチするノードを探します。
絶対パスを指定した場合は element が属する文書のルート要素からの
位置でマッチするノードを探します。
path を省略すると "*" を指定したことになります。

namespace で名前空間の対応付けを [c:Hash] で指定します。

variable で XPath 内の変数に対応する値を指定できます。
XPathインジェクション攻撃を避けるため、適切な
エスケープを付加するため、に用います。

- **param** `element` -- 要素([c:REXML::Element])
- **param** `path` -- XPath文字列
- **param** `namespace` -- 名前空間とURLの対応付け
- **param** `variables` -- 変数名とその値の対応付け

```ruby
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<root xmlns:x='1'>
  <a>
    <b>b1</b>
    <x:c />
    <b>b2</b>
    <d />
  </a>
  <b> b3 </b>
</root>
EOS

p REXML::XPath.match(doc, "/root/a/b") # => [<b> ... </>, <b> ... </>]
```

#@# == Constants
#@#
#@# --- EMPTY_HASH
#@# #@todo
