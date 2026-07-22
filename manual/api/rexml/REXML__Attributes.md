---
library: rexml/document
---
# class REXML::Attributes < Hash

属性の集合を表すクラスです。

[m:REXML::Element#attributes] はこのクラスのオブジェクトを返します。
各属性には [m:REXML::Attributes#\[\]] でアクセスします。

## Class Methods

### def new(element) -> REXML::Attributes

空の Attributes オブジェクトを生成します。

どの要素の属性であるかを element で指定します。

通常は [m:REXML::Element.new] によって Attributes オブジェクト
が生成されるため、このメソッドを使う必要はありません。

- **param** `element` -- 属性が属する要素([c:REXML::Element] オブジェクト)

## Instance Methods

### def [](name) -> String | nil

属性名nameの属性値を返します。

属性値ではなく [c:REXML::Attribute] オブジェクトが必要な場合は
[m:REXML::Attributes#get_attribute] を使ってください。

nameという属性名の属性がない場合は nil を返します。

- **param** `name` -- 属性名(文字列)

```ruby
require 'rexml/document'

doc = REXML::Document.new(<<EOS)
<root xmlns:foo="http://example.org/foo"
      xmlns:bar="http://example.org/bar">
  <a foo:att='1' bar:att='2' att='&lt;'/>
</root>
EOS

a = doc.get_elements("/root/a").first

p a.attributes["att"] # => "<"
p a.attributes["bar:att"] # => "2"
```

### def to_a -> [Attribute]

属性の配列を返します。

```ruby
require 'rexml/document'
doc = REXML::Document.new("<a x='1' y='2' z='3' />")
p doc.root.attributes.to_a # => [x='1', y='2', z='3']
```

### def length -> Integer
### def size -> Integer

属性の個数を返します。

```ruby
require 'rexml/document'

doc = REXML::Document.new(<<EOS)
<root xmlns:foo="http://example.org/foo"
      xmlns:bar="http://example.org/bar">
  <a foo:att='1' bar:att='2' att='&lt;'/>
</root>
EOS
a = doc.get_elements("/root/a").first

p a.attributes.length # => 3
```

### def each_attribute {|attribute| ... } -> ()

各属性に対しブロックを呼び出します。

個々の属性は [c:REXML::Attribute] オブジェクトで渡されます。

```ruby
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
```

### def each {|name, value| ... } -> ()

各属性の名前と値に対しブロックを呼び出します。

名前には expanded_name([m:REXML::Namespace#exapnded_name])が
渡されます。

```ruby
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
```

### def get_attribute(name) -> Attribute | nil

name という名前の属性を取得します。

name という名前を持つ属性がない場合は nil を返します。

- **param** `name` -- 属性名(文字列)
- **SEE** [m:REXML::Attributes#\[\]]

```ruby
require 'rexml/document'

doc = REXML::Document.new(<<-EOS)
<root xmlns:foo="http://example.org/foo"
      xmlns:bar="http://example.org/bar">
  <a foo:att='1' bar:att='2' att='&lt;'/>
</root>
EOS
a = doc.get_elements("/root/a").first

p a.attributes.get_attribute("att") # => att='&lt;'
p a.attributes.get_attribute("foo:att") # => foo:att='1'
```

### def []=(name, value)

指定した属性を更新します。

name で属性の名前を、value で値を更新します。
既に同じ名前の属性がある場合は上書きされ、
そうでない場合は属性が追加されます。

```ruby
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
p a # => <a foo:att='1' bar:att='2' att='9' foo:attt='8'/>
```

- **SEE** [m:REXML::Attributes#add]

### def prefixes -> [String]

self の中で宣言されている prefix の集合を
文字列の配列で返します。

self が属する要素より上位の要素で定義されているものは含みません。

```ruby
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
```

### def namespaces -> { String => String }

self の中で宣言されている名前空間の集合を返します。

返り値は名前空間の prefix をキーとし、URI を値とする
[c:Hash] を返します。

```ruby
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
```

### def delete(attribute) -> REXML::Element

指定した属性を取り除きます。

attribute で取り除く属性を指定します。
文字列もしくは [c:REXML::Attribute] オブジェクトを指定します

self が属する要素([c:REXML::Element])を返します。

- **param** `attribute` -- 取り除く属性(文字列もしくは REXML::Attribute オブジェクト)

```ruby
require 'rexml/document'

doc = REXML::Document.new(<<-EOS)
<root xmlns:foo="http://example.org/foo"
      xmlns:bar="http://example.org/bar">
  <a foo:att='1' bar:att='2' att='&lt;'/>
</root>
EOS
a = doc.get_elements("/root/a").first

p a.attributes.delete("att")   # => <a foo:att='1' bar:att='2'/>
p a.attributes.delete("foo:att") # => <a bar:att='2'/>
attr = a.attributes.get_attribute("bar:att")
p a.attributes.delete(attr)    # => <a/>
```

### def add(attribute) -> ()
### def <<(attribute) -> ()

属性を追加/更新します。

attribute で更新する属性([c:REXML::Attribute] オブジェクト)を
指定します。既に同じ名前([c:REXML::Attribute#name])のオブジェクトが
存在する場合は属性が上書きされ、ない場合は追加されます。

- **param** `attribute` -- 追加(更新)する属性([c:REXML::Attribute] オブジェクト)
- **SEE** [m:REXML::Attributes#\[\]=]

### def delete_all(name) -> [REXML::Attribute]

name という名前を持つ属性をすべて削除します。

削除された属性を配列で返します。

- **param** `name` -- 削除する属性の名前

```ruby
require 'rexml/document'

doc = REXML::Document.new(<<-EOS)
<root xmlns:foo="http://example.org/foo"
      xmlns:bar="http://example.org/bar">
  <a foo:att='1' bar:att='2' att='&lt;'/>
</root>
EOS
a = doc.get_elements("/root/a").first

p a.attributes.delete_all("att") # => [att='&lt;']
p a # => <a foo:att='1' bar:att='2'/>
```

### def get_attribute_ns(namespace, name) -> REXML::Attribute | nil

namespace と name で特定される属性を返します。

namespace で名前空間を、 name で prefix を含まない属性名を
指定します。

指定された属性が存在しない場合は nil を返します。

XML プロセッサが prefix を置き換えてしまった場合でも、このメソッドを
使うことで属性を正しく指定できます。

- **param** `namespace` -- 名前空間(URI, 文字列)
- **param** `name` -- 属性名(文字列)

```ruby
require 'rexml/document'

doc = REXML::Document.new(<<-EOS)
<root xmlns:foo="http://example.org/foo"
      xmlns:bar="http://example.org/bar">
  <a foo:att='1' bar:att='2' att='&lt;'/>
</root>
EOS
a = doc.get_elements("/root/a").first

p a.attributes.get_attribute_ns("", "att") # => att='&lt;'
p a.attributes.get_attribute_ns("http://example.org/foo", "att") # => foo:att='1'
p a.attributes.get_attribute_ns("http://example.org/baz", "att") # => nil
p a.attributes.get_attribute_ns("http://example.org/foo", "attt") # => nil
```
