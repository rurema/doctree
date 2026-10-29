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

#%since 4.0
### def to_ruby(symbolize_names: false, freeze: false, strict_integer: false, parse_symbols: true) -> object
### def transform(symbolize_names: false, freeze: false, strict_integer: false, parse_symbols: true) -> object
#%end
#%version 3.2...4.0
### def to_ruby(symbolize_names: false, freeze: false, strict_integer: false) -> object
### def transform(symbolize_names: false, freeze: false, strict_integer: false) -> object
#%end
#%until 3.2
### def to_ruby(symbolize_names: false, freeze: false) -> object
### def transform(symbolize_names: false, freeze: false) -> object
#%end

AST を ruby のオブジェクトに変換します。

- **param** `symbolize_names` -- ハッシュ(YAMLの仕様では正確にはマッピング)のキーを [c:Symbol] に変換するかどうかを指定します。
                       true を指定した場合は変換します。デフォルトでは文字列に変換されます。
- **param** `freeze` -- true を指定すると再帰的に [m:Object#freeze] されたオブジェクトを返します。
              デフォルトは false です。
#%since 3.2
- **param** `strict_integer` -- true を指定すると、"1,000" のようなカンマを含む数値を [c:Integer] に変換せず、文字列として返します。デフォルトは false です。
#%end
#%since 4.0
- **param** `parse_symbols` -- false を指定すると、":foo" のような文字列を [c:Symbol] に変換せず、文字列として返します。デフォルトは true です。
#%end

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
{: since="2.6.0"}

`self` が [c:Psych::Nodes::Alias] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Alias` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Alias]

### def document? -> bool
{: since="2.6.0"}

`self` が [c:Psych::Nodes::Document] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Document` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Document]

### def mapping? -> bool
{: since="2.6.0"}

`self` が [c:Psych::Nodes::Mapping] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Mapping` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Mapping]

### def scalar? -> bool
{: since="2.6.0"}

`self` が [c:Psych::Nodes::Scalar] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Scalar` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Scalar]

### def sequence? -> bool
{: since="2.6.0"}

`self` が [c:Psych::Nodes::Sequence] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Sequence` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Sequence]

### def stream? -> bool
{: since="2.6.0"}

`self` が [c:Psych::Nodes::Stream] を表すノードかどうかを返します。

`Psych::Nodes::Node` では常に false を返します。`Psych::Nodes::Stream` ではこのメソッドを override しており、常に true を返します。

- **SEE** [c:Psych::Nodes::Stream]

### def start_line -> Integer | nil
{: since="2.5.0"}
### def start_line=(line)
{: since="2.5.0"}

`self` が表す YAML ドキュメント上の要素が開始する行番号を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `line` -- 設定する開始行番号
- **SEE** [m:Psych::Nodes::Node#start_column], [m:Psych::Nodes::Node#end_line]

### def start_column -> Integer | nil
{: since="2.5.0"}
### def start_column=(column)
{: since="2.5.0"}

`self` が表す YAML ドキュメント上の要素が開始する行内の位置(列番号)を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `column` -- 設定する開始位置の列番号
- **SEE** [m:Psych::Nodes::Node#start_line], [m:Psych::Nodes::Node#end_column]

### def end_line -> Integer | nil
{: since="2.5.0"}
### def end_line=(line)
{: since="2.5.0"}

`self` が表す YAML ドキュメント上の要素が終了する行番号を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `line` -- 設定する終了行番号
- **SEE** [m:Psych::Nodes::Node#end_column], [m:Psych::Nodes::Node#start_line]

### def end_column -> Integer | nil
{: since="2.5.0"}
### def end_column=(column)
{: since="2.5.0"}

`self` が表す YAML ドキュメント上の要素が終了する行内の位置(列番号)を返します。

[m:Psych.parse] などでパースして得られたノードには、パース時にこの位置情報が設定されます。手動で生成したノードでは nil のままです。

- **param** `column` -- 設定する終了位置の列番号
- **SEE** [m:Psych::Nodes::Node#end_line], [m:Psych::Nodes::Node#start_column]

