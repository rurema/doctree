---
library: psych
---
# class Psych::Nodes::Document < Psych::Nodes::Node

YAML ドキュメントを表すクラスです。

このノードは [c:Psych::Nodes::Stream] の子ノードでなければ
なりません。このノードは1個の子ノードを持たなければなりません。
またこの子ノードは以下のいずれかである必要があります。
  - [c:Psych::Nodes::Sequence]
  - [c:Psych::Nodes::Mapping]
  - [c:Psych::Nodes::Scalar]
この唯一の子ノードは「ルート」とも呼ばれ、[c:Psych::Nodes::Document#root] で
アクセスできます。

## Class Methods
### def new(version=[], tag_directives=[], implicit=false) -> Psych::Nodes::Document

Document オブジェクトを生成します。

version にはドキュメントのバージョンを指定します。
[major, minor] という配列で指定します。

tag_directives には tag directive の配列を指定します。
それぞれの tag は [prefix, suffix] という文字列の配列で
表現します。

implicit にはドキュメントが implicit に始まっているかどうかを
真偽値で指定します。

- **param** `version` -- YAML ドキュメントのバージョン
- **param** `tag_directives` -- tag directive の配列
- **param** `implicit` -- ドキュメントが implicit に始まっているかどうか

### 例

以下の例では、YAML 1.1  のドキュメントで、
tag directive を1つ持ち、 implicit にドキュメントが開始
している Document オブジェクトを生成しています。

```ruby
Psych::Nodes::Document.new(
  [1,1],
  [["!", "tag:tenderlovemaking.com,2009:"]],
  true)
```

- **SEE** [m:Psych::Handler#start_document]

## Instance Methods
### def version -> [Integer]

YAML ドキュメントのバージョンを返します。

- **SEE** [m:Psych::Nodes::Document#version=],
     [m:Psych::Nodes::Document.new]

### def version=(ver) 

YAML ドキュメントのバージョンを設定します。

- **param** `ver` -- 設定するバージョン
- **SEE** [m:Psych::Nodes::Document#version],
     [m:Psych::Nodes::Document.new]

### def tag_directives -> [[String, String]]

tag directive の配列を返します。

- **SEE** [m:Psych::Nodes::Document#tag_directives=],
     [m:Psych::Nodes::Document.new]

### def tag_directives=(tags)

tag directive の配列を設定します。

- **param** `tags` -- 設定する tag directive の配列
- **SEE** [m:Psych::Nodes::Document#tag_directives],
     [m:Psych::Nodes::Document.new]

### def implicit -> bool

ドキュメントが implicit に始まっているかどうかを返します。

- **SEE** [m:Psych::Nodes::Document#implicit=],
     [m:Psych::Nodes::Document.new]

### def implicit=(bool)

ドキュメントが implicit に始まっているかどうかを設定します。

- **param** `bool` -- ドキュメントが implicit に始まっているかどうかの設定値
- **SEE** [m:Psych::Nodes::Document#implicit],
     [m:Psych::Nodes::Document.new]

### def implicit_end -> bool

ドキュメントが implicit に終わっているかどうかを返します。

オブジェクト生成時のデフォルト値は true です。

- **SEE** [m:Psych::Nodes::Document#implicit_end=]

### def implicit_end=(bool)

ドキュメントが implicit に終わっているかどうかを設定します。

- **param** `bool` -- ドキュメントが implicit に終わっているかどうかの設定値
- **SEE** [m:Psych::Nodes::Document#implicit_end]

### def root -> Psych::Nodes::Node

ルートノードを返します。

