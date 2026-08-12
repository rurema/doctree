---
library: _builtin
since: "2.6.0"
---
# class RubyVM::AbstractSyntaxTree::Node

[m:RubyVM::AbstractSyntaxTree.parse] によって作られる抽象構文木を表すクラスです。

このクラスは MRI の実装の詳細を表します。

## Instance Methods

#%since 3.2
### def all_tokens -> Array | nil

self を含むスクリプト全体のトークンの配列を返します。
各トークンの形式は [m:RubyVM::AbstractSyntaxTree::Node#tokens] と同じです。

keep_tokens を有効にしてパースした場合にだけ利用でき、そうでない場合は nil を返します。

```ruby
root = RubyVM::AbstractSyntaxTree.parse("x = 1", keep_tokens: true)
p root.all_tokens.size # => 5
```

- **SEE** [m:RubyVM::AbstractSyntaxTree::Node#tokens]
#%end

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

#%since 3.4
### def locations -> Array

self に関連づけられた位置情報([c:RubyVM::AbstractSyntaxTree::Location])の配列を返します。

最初の要素は self 全体の位置です。ノードの種類によっては、キーワードなど部分ごとの位置情報が続きます(対応する位置が無い要素は nil になります)。

```ruby
node = RubyVM::AbstractSyntaxTree.parse("return 1 unless x").children[2]
p node.type # => :UNLESS
p node.locations
# => [#<RubyVM::AbstractSyntaxTree::Location:@1:0-1:17>,
#     #<RubyVM::AbstractSyntaxTree::Location:@1:9-1:15>, nil, nil]
```

- **SEE** [c:RubyVM::AbstractSyntaxTree::Location]
#%end

#%since 3.1
### def node_id -> Integer

self に割り当てられた ID を返します。

ID は抽象構文木の中でノードを識別するための整数です。具体的な値は Ruby のバージョンやパーサによって異なります。

```ruby
node = RubyVM::AbstractSyntaxTree.parse("x = 1 + 2\ny = 3\n")
p node.node_id # => 9
```

#%since 3.2
- **SEE** [m:RubyVM::AbstractSyntaxTree.node_id_for_backtrace_location]
#%end
#%end

#%since 3.1
### def script_lines -> Array | nil

スクリプト全体の各行を要素とする文字列の配列を返します。

keep_script_lines を有効にしてパースした場合にだけ利用でき、そうでない場合は nil を返します。

```ruby
root = RubyVM::AbstractSyntaxTree.parse("x = 1 + 2\ny = 3\n", keep_script_lines: true)
p root.script_lines # => ["x = 1 + 2\n", "y = 3\n"]
```

- **SEE** [m:RubyVM::AbstractSyntaxTree::Node#source], [m:RubyVM::AbstractSyntaxTree.parse]
#%end

#%since 3.1
### def source -> String | nil

self に対応する部分のソースコードを文字列で返します。

keep_script_lines を有効にしてパースした場合にだけ利用でき、そうでない場合は nil を返します。

```ruby
root = RubyVM::AbstractSyntaxTree.parse("x = 1 + 2\ny = 3\n", keep_script_lines: true)
p root.source                         # => "x = 1 + 2\ny = 3"
p root.children[2].children[0].source # => "x = 1 + 2"
```

- **SEE** [m:RubyVM::AbstractSyntaxTree::Node#script_lines]
#%end

#%since 3.2
### def tokens -> Array | nil

self に対応する部分のトークンの配列を返します。

各トークンは `[id, type, ソース文字列, 位置情報]` の 4 要素の配列です。
位置情報は `[first_lineno, first_column, last_lineno, last_column]` の配列です。

keep_tokens を有効にしてパースした場合にだけ利用でき、そうでない場合は nil を返します。

```ruby
root = RubyVM::AbstractSyntaxTree.parse("x = 1", keep_tokens: true)
pp root.tokens
# => [[0, :tIDENTIFIER, "x", [1, 0, 1, 1]],
#     [1, :tSP, " ", [1, 1, 1, 2]],
#     [2, :"=", "=", [1, 2, 1, 3]],
#     [3, :tSP, " ", [1, 3, 1, 4]],
#     [4, :tINTEGER, "1", [1, 4, 1, 5]]]
```

- **SEE** [m:RubyVM::AbstractSyntaxTree::Node#all_tokens], [m:RubyVM::AbstractSyntaxTree.parse]
#%end

### def type -> Symbol

self の種類を Symbol で返します。

```ruby
node = RubyVM::AbstractSyntaxTree.parse('1 + 1')
p node.type # => :SCOPE
```
