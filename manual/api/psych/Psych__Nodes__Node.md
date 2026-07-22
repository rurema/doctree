---
library: psych
include:
  - Enumerable
---
# class Psych::Nodes::Node

YAML AST のノードを表す抽象クラスです。

このクラスをインスタンス化することは不適切です。
すべてのノードのクラスはこのクラスの派生クラスです。

## Instance Methods
### def children -> [Psych::Nodes::Node]

子ノードの集合を配列で返します。

### def tag -> String | nil

ノードに付加されたタグを返します。

タグが付加されていない場合は nil を返します。

```ruby
ast = Psych.parse(<<EOS)
---
- !!str a
- b
EOS
  
p ast.root.children[0].value  # => "a"
p ast.root.children[0].tag    # => "tag:yaml.org,2002:str"
  
p ast.root.children[1].value  # => "b"
p ast.root.children[1].tag    # => nil
```

### def each -> Enumerator
### def each{|node| ... } -> ()

self のノードをルートとする部分木の各ノードを引数として
ブロックを呼び出します。

ブロックを省略した場合は [c:Enumerator] を返します。

### def to_ruby -> object
### def transform -> object

AST を ruby のオブジェクトに変換します。

### def yaml(io=nil, options={}) -> String | IO
### def to_yaml(io=nil, options={}) -> String | IO

AST を YAML ドキュメントに変換します。

io に [c:IO] オブジェクトを指定した場合は、その
オブジェクトに変換後のドキュメントが書き込まれます。
この場合は io を返り値として返します。

io を省略した(nil を指定した)場合には変換後のドキュメントを
文字列で返します。

[c:Psych::Nodes::Stream] 以外を変換しようとすると、AST として不正で
あるためエラーが発生します。

options には以下が指定できます。

#@include(dump_options)

- **param** `io` -- 書き込み先の IO
- **param** `options` -- オプション

