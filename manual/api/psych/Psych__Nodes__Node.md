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
require 'psych'

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

self のノードをルートとする部分木の各ノードを引数としてブロックを呼び出します。

ブロックを省略した場合は [c:Enumerator] を返します。

### def to_ruby -> object
### def transform -> object

AST を ruby のオブジェクトに変換します。

### def yaml(io=nil, options={}) -> String | IO
### def to_yaml(io=nil, options={}) -> String | IO

AST を YAML ドキュメントに変換します。

io に [c:IO] オブジェクトを指定した場合は、そのオブジェクトに変換後のドキュメントが書き込まれます。
この場合は io を返り値として返します。

io を省略した(nil を指定した)場合には変換後のドキュメントを文字列で返します。

[c:Psych::Nodes::Stream] 以外を変換しようとすると、AST として不正であるためエラーが発生します。

options には以下が指定できます。

#%include(dump_options)

- **param** `io` -- 書き込み先の IO
- **param** `options` -- オプション

### def alias? -> bool

`self` が [c:Psych::Nodes::Alias] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Alias` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Alias]

### def document? -> bool

`self` が [c:Psych::Nodes::Document] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Document` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Document]

### def mapping? -> bool

`self` が [c:Psych::Nodes::Mapping] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Mapping` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Mapping]

### def scalar? -> bool

`self` が [c:Psych::Nodes::Scalar] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Scalar` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Scalar]

### def sequence? -> bool

`self` が [c:Psych::Nodes::Sequence] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Sequence` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Sequence]

### def stream? -> bool

`self` が [c:Psych::Nodes::Stream] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Stream` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Stream]

### def start_line -> Integer | nil
### def start_line=(line)

`self` が表す YAML ドキュメント上の要素が開始する行番号を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `line` -- 設定する開始行番号
- **SEE** [m:Psych::Nodes::Node#start_column], [m:Psych::Nodes::Node#end_line]

### def start_column -> Integer | nil
### def start_column=(column)

`self` が表す YAML ドキュメント上の要素が開始する行内の位置(列番号)を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `column` -- 設定する開始位置の列番号
- **SEE** [m:Psych::Nodes::Node#start_line], [m:Psych::Nodes::Node#end_column]

### def end_line -> Integer | nil
### def end_line=(line)

`self` が表す YAML ドキュメント上の要素が終了する行番号を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `line` -- 設定する終了行番号
- **SEE** [m:Psych::Nodes::Node#end_column], [m:Psych::Nodes::Node#start_line]

### def end_column -> Integer | nil
### def end_column=(column)

`self` が表す YAML ドキュメント上の要素が終了する行内の位置(列番号)を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `column` -- 設定する終了位置の列番号
- **SEE** [m:Psych::Nodes::Node#end_line], [m:Psych::Nodes::Node#start_column]

