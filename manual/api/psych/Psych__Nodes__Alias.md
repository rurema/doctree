---
library: psych
---
# class Psych::Nodes::Alias < Psych::Nodes::Node

YAML の alias [url:https://yaml.org/spec/1.1/#alias] を表すクラス。

anchor で別の YAML の要素を指します。

alias は YAML の AST の葉のノードであり、子ノードを持ちません。

## Class Methods

### def new(anchor) -> Psych::Nodes::Alias
新たな Alias オブジェクトを生成します。

anchor で指す先の anchor を指定します。

- **param** `anchor` -- 指す先の anchor

## Instance Methods

### def anchor -> String
alias が指す先の anchor を返します。

- **SEE** [m:Psych::Nodes::Alias#anchor=],
     [m:Psych::Nodes::Alias.new]
### def anchor=(val)
alias が指す先の anchor を変更します。

- **param** `val` -- 設定する anchor
- **SEE** [m:Psych::Nodes::Alias#anchor],
     [m:Psych::Nodes::Alias.new]

