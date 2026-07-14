---
library: psych
---
# class Psych::Nodes::Mapping < Psych::Nodes::Node

YAML の mapping [url:https://yaml.org/spec/1.1/#mapping] を表すクラスです。

Psych::Nodes::Mapping は 0 個以上の子ノードを持つことができます。
子ノードの個数は偶数でなければなりません。
子ノードは以下のいずれかクラスのインスタンスでなければなりません。
  - [c:Psych::Nodes::Sequence]
  - [c:Psych::Nodes::Mapping]
  - [c:Psych::Nodes::Scalar]
  - [c:Psych::Nodes::Alias]

子ノードは mapping のキーと値が交互に並んでいます。
```ruby
ast = Psych.parse(<<EOS)
%YAML 1.1
---
x: y
u: v
EOS

p ast.root.children.map{|v| v.value } # => ["x", "y", "u", "v"]
```

## Class Methods
### def new(anchor=nil, tag=nil, implicit=true, style=BLOCK) -> Psych::Nodes::Mapping

新たな mapping オブジェクトを生成します。

anchor には mapping に付加されている anchor を文字列で指定します。
anchor を付けない場合には nil を指定します。

tag には mapping に付加されている tag を文字列で指定します。
tag を付けない場合には nil を指定します。

implicit には mapping が implicit に開始されたかどうかを
真偽値で指定します。

style には YAML ドキュメント上の style を整数で指定します。以下のいずれ
かを指定できます。
  - [m:Psych::Nodes::Mapping::ANY]
  - [m:Psych::Nodes::Mapping::BLOCK]
  - [m:Psych::Nodes::Mapping::FLOW]

- **param** `anchor` -- mapping に付加された anchor
- **param** `tag` -- mapping に付加された tag
- **param** `implicit` -- mapping が implicit に開始されたかどうか
- **param** `style` -- YAML ドキュメント上の style

## Instance Methods
### def anchor -> String|nil
mapping に付加された anchor を返します。

- **SEE** [m:Psych::Nodes::Mapping#anchor=],
     [m:Psych::Nodes::Mapping.new]

### def anchor=(a)
mapping に付加する anchor を設定します。

- **param** `a` -- 設定する anchor
- **SEE** [m:Psych::Nodes::Mapping#anchor],
     [m:Psych::Nodes::Mapping.new]


### def tag -> String|nil
mapping に付加された tag を返します。

- **SEE** [m:Psych::Nodes::Mapping#tag=],
     [m:Psych::Nodes::Mapping.new]

### def tag=(t)
mapping に付加する tag を設定します。

- **param** `t` -- 設定する tag
- **SEE** [m:Psych::Nodes::Mapping#anchor=],
     [m:Psych::Nodes::Mapping.new]

### def implicit -> bool
mapping が implicit に開始されたかどうかを真偽値で返します。

- **SEE** [m:Psych::Nodes::Mapping#implicit=],
     [m:Psych::Nodes::Mapping.new]

### def implicit=(bool)
mapping が implicit に開始されたかどうかを真偽値で設定します。

- **param** `bool` -- 設定値

- **SEE** [m:Psych::Nodes::Mapping#implicit],
     [m:Psych::Nodes::Mapping.new]

### def style -> Integer
mapping の style を返します。

- **SEE** [m:Psych::Nodes::Mapping#style=],
     [m:Psych::Nodes::Mapping.new]

### def style=(sty)
mapping の style を設定します。

- **param** `sty` -- 設定する style

- **SEE** [m:Psych::Nodes::Mapping#style],
     [m:Psych::Nodes::Mapping.new]

## Constants
### const ANY -> Integer
「任意」のスタイルを意味します。

emitter が適当に style を決めます。

- **SEE** [m:Psych::Nodes::Mapping.new],
     [m:Psych::Nodes::Mapping#style],
     [m:Psych::Handler#start_mapping]

### const BLOCK -> Integer
block style を表します。

- **SEE** [m:Psych::Nodes::Mapping.new],
     [m:Psych::Nodes::Mapping#style],
     [m:Psych::Handler#start_mapping]

### const FLOW -> Integer
flow style を表します。

- **SEE** [m:Psych::Nodes::Mapping.new],
     [m:Psych::Nodes::Mapping#style],
     [m:Psych::Handler#start_mapping]

