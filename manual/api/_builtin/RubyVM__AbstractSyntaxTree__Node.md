---
library: _builtin
---
# class RubyVM::AbstractSyntaxTree::Node

[m:RubyVM::AbstractSyntaxTree.parse] によって作られる抽象構文木を表すクラスです。

このクラスは MRI の実装の詳細を表します。

## Instance Methods

### def children -> Array

self の子ノードを配列で返します。

どのような子ノードが返ってくるかは、そのノードの type によって異なります。

戻り値は、ほかの RubyVM::AbstractSyntaxTree::Node のインスタンスや nil を含みます。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 2')
p node.children
# => [[], nil, #<RubyVM::AbstractSyntaxTree::Node:OPCALL@1:0-1:5>]
```

### def first_column -> Integer

ソースコード中で、self を表すテキストが最初に現れる列番号を返します。

列番号は0-originで、バイト単位で表されます。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 2')
p node.first_column # => 0
```

### def first_lineno -> Integer

ソースコード中で、self を表すテキストが最初に現れる行番号を返します。

行番号は1-originです。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 2')
p node.first_lineno # => 1
```

### def inspect -> String

self のデバッグ用の情報を含んだ文字列を返します。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 1')
puts node.inspect
# => #<RubyVM::AbstractSyntaxTree::Node:SCOPE@1:0-1:5>
```

### def last_column -> Integer

ソースコード中で、self を表すテキストが最後に現れる列番号を返します。

列番号は0-originで、バイト単位で表されます。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 1')
p node.last_column # => 5
```

### def last_lineno -> Integer

ソースコード中で、self を表すテキストが最後に現れる行番号を返します。

行番号は1-originです。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 1')
p node.last_lineno # => 1
```

### def type -> Symbol

self の種類を Symbol で返します。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 1')
p node.type # => :SCOPE
```
