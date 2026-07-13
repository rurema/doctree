---
library: psych
---
# class Psych::Nodes::Sequence < Psych::Nodes::Node
YAML sequence [url:http://yaml.org/spec/1.1/#sequence/syntax] を表すクラスです。

YAML sequence とは基本的にはリスト、配列です。以下のような例が考えられます。
```yaml
%YAML 1.1
---
- I am
- a Sequence
```

YAML sequence には anchor を付加できます。
この例では [m:Psych::Nodes::Sequence#anchor] は "A" を返します。
```yaml
%YAML 1.1
---
&A [
  "This sequence",
  "has an anchor"
]
```


tag を付けることもできます。この例では
[m:Psych::Nodes::Sequence#tag] は "tag:yaml.org,2002:seq" 
(!seq はこの tag の別名)を返します。
```yaml
%YAML 1.1
---
!!seq [
  "This sequence",
  "has a tag"
]
```

Psych::Nodes::Sequence は 0 個以上の子ノードを持つことができます。
子ノードは以下のいずれかクラスのインスタンスでなければなりません。
  - [c:Psych::Nodes::Sequence]
  - [c:Psych::Nodes::Mapping]
  - [c:Psych::Nodes::Scalar]
  - [c:Psych::Nodes::Alias]

## Class Methods
### def new(anchor=nil, tag=nil, implicit=true, style=BLOCK) -> Psych::Nodes::Sequence

新たな sequence オブジェクトを生成します。

anchor には sequence に付加されている anchor を文字列で指定します。
anchor を付けない場合には nil を指定します。

tag には sequence に付加されている tag を文字列で指定します。
tag を付けない場合には nil を指定します。

implicit には sequence が implicit に開始されたかどうかを
真偽値で指定します。

style には YAML ドキュメント上の style を整数で指定します。以下のいずれ
かを指定できます。
  - [m:Psych::Nodes::Sequence::ANY]
  - [m:Psych::Nodes::Sequence::BLOCK]
  - [m:Psych::Nodes::Sequence::FLOW]

- **param** `anchor` -- sequence に付加された anchor
- **param** `tag` -- sequence に付加された tag
- **param** `implicit` -- sequence が implicit に開始されたかどうか
- **param** `style` -- YAML ドキュメント上の style

## Instance Methods
### def anchor -> String|nil
sequence に付加された anchor を返します。

- **SEE** [m:Psych::Nodes::Sequence#anchor=],
     [m:Psych::Nodes::Sequence.new]

### def anchor=(a)
sequence に付加する anchor を設定します。

- **param** `a` -- 設定する anchor
- **SEE** [m:Psych::Nodes::Sequence#anchor],
     [m:Psych::Nodes::Sequence.new]


### def tag -> String|nil
sequence に付加された tag を返します。

- **SEE** [m:Psych::Nodes::Sequence#tag=],
     [m:Psych::Nodes::Sequence.new]

### def tag=(t)
sequence に付加する tag を設定します。

- **param** `t` -- 設定する tag
- **SEE** [m:Psych::Nodes::Sequence#anchor=],
     [m:Psych::Nodes::Sequence.new]

### def implicit -> bool
sequence が implicit に開始されたかどうかを真偽値で返します。

- **SEE** [m:Psych::Nodes::Sequence#implicit=],
     [m:Psych::Nodes::Sequence.new]

### def implicit=(bool)
sequence が implicit に開始されたかどうかを真偽値で設定します。

- **param** `bool` -- 設定値

- **SEE** [m:Psych::Nodes::Sequence#implicit],
     [m:Psych::Nodes::Sequence.new]

### def style -> Integer
sequence の style を返します。

- **SEE** [m:Psych::Nodes::Sequence#style=],
     [m:Psych::Nodes::Sequence.new]

### def style=(sty)
sequence の style を設定します。

- **param** `sty` -- 設定する style 

- **SEE** [m:Psych::Nodes::Sequence#style],
     [m:Psych::Nodes::Sequence.new]

## Constants
### const ANY -> Integer
「任意」のスタイルを意味します。

emitter が適当に style を決めます。

- **SEE** [m:Psych::Nodes::Sequence.new],
     [m:Psych::Nodes::Sequence#style],
     [m:Psych::Handler#start_sequence]

### const BLOCK -> Integer
block style を表します。

- **SEE** [m:Psych::Nodes::Sequence.new],
     [m:Psych::Nodes::Sequence#style],
     [m:Psych::Handler#start_sequence]

### const FLOW -> Integer
flow style を表します。

- **SEE** [m:Psych::Nodes::Sequence.new],
     [m:Psych::Nodes::Sequence#style]

