---
library: psych
---
# class Psych::Nodes::Scalar < Psych::Nodes::Node
YAML の scalar [url:http://yaml.org/spec/1.1/#id858081] を表すクラスです。

これは AST の葉にあたるノードであり、子ノードを持ちません。

## Class Methods
### def new(value, anchor=nil, tag=nil, plain=true, quoted=false, style=ANY) -> Psych::Nodes:Scalar

Scalar オブジェクトを生成します。

value は scalar の値を文字列で指定します。

anchor には scalar に付加されている anchor を文字列で指定します。
anchor を付けない場合には nil を指定します。

tag には scalar に付加されている tag を文字列で指定します。
tag を付けない場合には nil を指定します。

plain は plain style であるかどうか、quoted は quoted style であるかどうか
を指定します。style には node の style を整数値で渡します。
style は次の値のいずれかです。
  - [m:Psych::Nodes::Scalar::ANY]
  - [m:Psych::Nodes::Scalar::PLAIN]
  - [m:Psych::Nodes::Scalar::SINGLE_QUOTED]
  - [m:Psych::Nodes::Scalar::DOUBLE_QUOTED]
  - [m:Psych::Nodes::Scalar::LITERAL]
  - [m:Psych::Nodes::Scalar::FOLDED]

- **param** `value` -- スカラー値
- **param** `anchor` -- 関連付けられた anchor の名前
- **param** `tag` -- タグ名
- **param** `plain` -- plain style であるかどうか
- **param** `quoted` -- quoted style であるかどうか
- **param** `style` -- スカラーのスタイル

## Instance Methods
### def value -> String
scalar の値を返します。

- **SEE** [m:Psych::Nodes::Scalar#value=],
     [m:Psych::Nodes::Scalar.new]

### def value=(v)
scalar の値を設定します。

- **param** `v` -- 設定する値
- **SEE** [m:Psych::Nodes::Scalar#value],
     [m:Psych::Nodes::Scalar.new]

### def anchor -> String|nil
scalar に付加された anchor を返します。

- **SEE** [m:Psych::Nodes::Scalar#anchor=],
     [m:Psych::Nodes::Scalar.new]

### def anchor=(a) 
scalar に付加された anchor を変更します。

- **param** `a` -- 設定する anchor
- **SEE** [m:Psych::Nodes::Scalar#anchor],
     [m:Psych::Nodes::Scalar.new]

### def tag -> String|nil
scalar に付加された tag を返します。

- **SEE** [m:Psych::Nodes::Scalar#tag=],
     [m:Psych::Nodes::Scalar.new]

### def tag=(t)
scalar に付加された tag を変更します。

- **param** `t` -- 設定する tag
- **SEE** [m:Psych::Nodes::Scalar#tag],
     [m:Psych::Nodes::Scalar.new]

### def plain -> bool
scalar が plain style であるかどうかを返します。


- **SEE** [m:Psych::Nodes::Scalar#plain=],
     [m:Psych::Nodes::Scalar.new]

### def plain=(bool)
scalar が plain style であるかどうかを変更します。

- **param** `bool` -- 設定する真偽値
- **SEE** [m:Psych::Nodes::Scalar#plain],
     [m:Psych::Nodes::Scalar.new]

### def quoted -> bool
scalar が quoted であるかどうかを返します。

- **SEE** [m:Psych::Nodes::Scalar#quoted=],
     [m:Psych::Nodes::Scalar.new]

### def quoted=(bool)
scalar が quoted であるかどうかを変更します。

- **param** `bool` -- 設定する真偽値
- **SEE** [m:Psych::Nodes::Scalar#quoted],
     [m:Psych::Nodes::Scalar.new]

### def style -> Integer
scalar の style を返します。

- **SEE** [m:Psych::Nodes::Scalar#style=],
     [m:Psych::Nodes::Scalar.new]

### def style=(sty)
scalar の style を変更します。

- **param** `sty` -- 設定する style
- **SEE** [m:Psych::Nodes::Scalar#style=],
     [m:Psych::Nodes::Scalar.new]

## Constants
### const ANY -> Integer
「任意」のスタイルを意味します。

emitter が適当に style を決めます。

- **SEE** [m:Psych::Nodes::Scalar.new],
     [m:Psych::Nodes::Scalar#style]

### const PLAIN -> Integer
plain scalar style を表します。

- **SEE** [m:Psych::Nodes::Scalar.new],
     [m:Psych::Nodes::Scalar#style],
     [m:Psych::Handler#scalar]

### const SINGLE_QUOTED -> Integer
single quoted style を表します。

- **SEE** [m:Psych::Nodes::Scalar.new],
     [m:Psych::Nodes::Scalar#style],
     [m:Psych::Handler#scalar]

### const DOUBLE_QUOTED -> Integer
double quoted style を表します。

- **SEE** [m:Psych::Nodes::Scalar.new],
     [m:Psych::Nodes::Scalar#style],
     [m:Psych::Handler#scalar]

### const LITERAL -> Integer
literal style を表します。

- **SEE** [m:Psych::Nodes::Scalar.new],
     [m:Psych::Nodes::Scalar#style],
     [m:Psych::Handler#scalar]

### const FOLDED -> Integer
folded style を表します。

- **SEE** [m:Psych::Nodes::Scalar.new],
     [m:Psych::Nodes::Scalar#style],
     [m:Psych::Handler#scalar]

