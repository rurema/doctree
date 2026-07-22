---
library: psych
---
# module Psych::Nodes

Psych が中間データとして利用している AST (Abstract Syntax Tree) に
関するモジュール。

[m:Psych.load] によって YAML ドキュメントを Ruby オブジェクトに変換
するときには、一度中間的な AST に変換され、その AST が Ruby の
オブジェクトに変換されます。

逆向き、つまり [m:Psych.dump] で Ruby のオブジェクトを
YAML ドキュメントに変換するときには、中間的な AST に変換してから
それを YAML ドキュメントに変換します。

YAML AST の各ノードのクラスはすべて Psych::Nodes の下にあります。
AST を手作業で構築して、visitor を使って AST を YAML ドキュメントや
Ruby のオブジェクトに変換できます。

以下の例ではスカラを1つ持つリストの AST を構築しています。

```ruby
# Create our nodes
stream = Psych::Nodes::Stream.new
doc    = Psych::Nodes::Document.new
seq    = Psych::Nodes::Sequence.new
scalar = Psych::Nodes::Scalar.new('foo')

# Build up our tree
stream.children << doc
doc.children    << seq
seq.children    << scalar
```

stream は AST のルートです。以下のようにして AST を YAML ドキュメントに
変換できます。

```text
stream.to_yaml => "---\n- foo\n"
```

Ruby のオブジェクトに変換するためには以下のようにします。

```text
stream.to_ruby => [["foo"]]
```

### YAML AST 仕様
正しい YAML AST は [c:Psych::Nodes::Stream] ノードが
木のルートでなければなりません。Psych::Nodes::Stream ノードは
1つ以上の [c:Psych::Nodes::Document] ノードを子として
持っていなければなりません。

Psych::Nodes::Document は子ノードをちょうど1個持っていなければなりません。
子ノードは以下のいずれかでなければなりません。
- [c:Psych::Nodes::Sequence]
- [c:Psych::Nodes::Mapping]
- [c:Psych::Nodes::Scalar]

[c:Psych::Nodes::Sequence] と [c:Psych::Nodes::Mapping] は複数の
子ノードを持つことができます。Psych::Nodes::Mapping の子ノード数は
偶数でなければなりません。

Psych::Nodes::Sequence と Psych::Nodes::Mapping の子ノードとして有効な
ものは以下のいずれかです。
- [c:Psych::Nodes::Sequence]
- [c:Psych::Nodes::Mapping]
- [c:Psych::Nodes::Scalar]
- [c:Psych::Nodes::Alias]

[c:Psych::Nodes::Scalar] と [c:Psych::Nodes::Alias] は子ノードを持つ
ことができません。

