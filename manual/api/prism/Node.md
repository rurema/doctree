---
library: prism
---
# class Prism::Node < Object

構文解析の結果得られる構文木の各ノードを表す抽象基底クラスです。
[m:Prism?.parse] などが返す構文木は、このクラスのサブクラス
(150 種類以上)のインスタンスで構成されます。`Prism::Node` 自身のインスタンスが生成されることはありません。

個々のノードクラス(`Prism::ProgramNode`・`Prism::CallNode` など)に固有のフィールド(子ノードや値を取得するアクセサ)はこのリファレンスでは扱いません。このページで扱うのは、すべてのノードクラスに共通する
API です。個々のノードクラスの詳細は公式ドキュメントを参照してください。

- プロジェクトページ: <https://github.com/ruby/prism>
- リファレンス(YARD): <https://www.rubydoc.info/gems/prism>
- ドキュメントサイト: <https://ruby.github.io/prism/>

```ruby title="例"
require "prism"

node = Prism.parse("1 + 2").value
p node.type           # => :program_node
p node.class          # => Prism::ProgramNode
p node.location.slice # => "1 + 2"

call = node.statements.body[0]
p call.type                    # => :call_node
p call.child_nodes.size        # => 3
p call.compact_child_nodes.size # => 2
```

- **SEE** [c:Prism::ParseResult], [c:Prism::Location]

## Class Methods

### def type -> Symbol

[m:Prism::Node#type] のクラスメソッド版です。インスタンスを作らずにノードクラス自体からノードの種類を表すシンボルを得られます。

#%since 3.4
### def fields -> [Prism::Reflection::Field]

このノードクラスが持つフィールド(子ノードや属性)を表す
`Prism::Reflection::Field` の配列を返します。構文木の各ノード・各フィールドを再帰的に処理するツールを書くときのリフレクション用途に使えます。

`Prism::Node` 自身に対して呼び出すと [c:NoMethodError] が発生します。
サブクラスに対して呼び出してください。
#%end

## Instance Methods

### def type -> Symbol

ノードの種類を表すシンボル(例 `:program_node`、`:call_node`)を返します。case 式や配列との比較でノードの種類を判定するときに使えます。

### def location -> Prism::Location

ノードのソースコード上の位置を表す [c:Prism::Location] を返します。

### def slice -> String

ノードの位置に対応するソースコードの文字列を返します。
[`location.slice`](m:Prism::Location#slice) と同じです。

### def accept(visitor) -> object

Visitor パターンの受け入れメソッドです。ノードの種類に応じた
`visitor.visit_xxx` を呼び出し、その戻り値を返します。

- **param** `visitor` -- `Prism::Visitor` (またはそのサブクラス)の
       インスタンスを指定します。

### def child_nodes -> [Prism::Node | nil]

子ノードの配列を返します。存在しないオプショナルな子ノードの位置には nil が入ります。

- **SEE** [m:Prism::Node#compact_child_nodes]

### def compact_child_nodes -> [Prism::Node]

子ノードの配列を返します。[m:Prism::Node#child_nodes] と異なり、存在しないオプショナルな子ノードは含まれません(nil を含みません)。

### def comment_targets -> [Prism::Node | Prism::Location]

コメントの関連付け先になりうる子ノードや位置情報の配列を返します。
[m:Prism::ParseResult#attach_comments!] が内部で使用します。

### def copy(**params) -> Prism::Node

自身と同じクラスの新しいノードを、指定したフィールドだけを差し替えて複製します。渡せるキーワードはノードクラスごとのフィールド名で、指定しなかったフィールドは自身の値を引き継ぎます。

```ruby title="例"
require "prism"

call = Prism.parse("1 + 2").value.statements.body[0]
copied = call.copy
p copied.class        # => Prism::CallNode
p copied.equal?(call) # => false
```

### def deconstruct -> [Prism::Node | nil]

[m:Prism::Node#child_nodes] のエイリアスです。パターンマッチの配列パターン(`case node; in [a, b]`)で使われます。

### def deconstruct_keys(keys) -> Hash

パターンマッチのハッシュパターン(`case node; in {value:}`)で使われます。ノードの各フィールドをキーに持つハッシュを返します。

- **param** `keys` -- 取り出したいキーの配列。すべて取り出す場合は
       nil を指定します。

#%since 3.4
### def inspect -> String
#%else
### def inspect(inspector = NodeInspector.new) -> String
#%end

構文木をツリー形式で表した、人間が読みやすい文字列を返します。

#%until 3.4
`inspector` は内部実装用の引数なので、通常は省略してください。
#%end

```ruby title="例"
require "prism"

puts Prism.parse("1 + 2").value.inspect
```

### def pretty_print(q) -> ()

`pp` ライブラリからの呼び出しに対応します。[m:Prism::Node#inspect]
の出力を、現在のインデントレベルを保ったまま表示します。

### def to_dot -> String

構文木を Graphviz の DOT 言語形式の文字列に変換します。

```ruby title="例"
require "prism"

dot = Prism.parse("1 + 2").value.to_dot
p dot.start_with?("digraph") # => true
```

### def newline? -> bool

このノードが、[c:TracePoint] の `:line` イベントを発生させる行の位置としてマークされているかどうかを返します。

#%since 3.4
### def node_id -> Integer

このノード固有の識別子を返します。同じソースコードを同じバージョンで再度解析した場合、対応するノードには同じ識別子が割り当てられます。
構文木全体をメモリ上に保持せずにノードを再特定するための仕組み
(prism の `Prism::Relocation`)で使われます。

### def start_offset -> Integer

開始位置のバイトオフセットを返します。[`location.start_offset`](m:Prism::Location#start_offset) と同じです。

### def end_offset -> Integer

終了位置のバイトオフセットを返します。[`location.end_offset`](m:Prism::Location#end_offset) と同じです。

### def source_lines -> [String]

ソースコード全体を行ごとに分割した配列を返します。
[`location.source_lines`](m:Prism::Location#source_lines) と同じです。

### def script_lines -> [String]

[m:Prism::Node#source_lines] のエイリアスです。
[c:RubyVM::AbstractSyntaxTree] の API に合わせた名前で、そこからの移行を容易にするためのものです。

### def slice_lines -> String

ノードの位置を含む行全体(開始行の行頭から終端行の行末まで)の文字列を返します。[`location.slice_lines`](m:Prism::Location#slice_lines) と同じです。

### def static_literal? -> bool

このノードに静的リテラル(構文解析の時点で値が確定するリテラル)
のフラグが立っているかどうかを返します。

### def tunnel(line, column) -> [Prism::Node]

指定した行・桁を位置に含むノードを、自分自身から子孫の方向へ順に並べた配列で返します。エディタ上のカーソル位置に対応するノードを特定するといった用途に使えます。

- **param** `line` -- 行番号(1 始まり)を指定します。
- **param** `column` -- 行頭からのバイト単位の桁位置(0 始まり)を
       指定します。

```ruby title="例"
require "prism"

node = Prism.parse("x = 1 + 2").value
path = node.tunnel(1, 4)
p path.map(&:type)
# => [:program_node, :statements_node, :local_variable_write_node, :call_node, :integer_node]
```

### def breadth_first_search {|node| ... } -> Prism::Node | nil

自身を含めて構文木を幅優先で探索し、ブロックが真を返した最初のノードを返します。見つからない場合は nil を返します。

```ruby title="例"
require "prism"

node = Prism.parse("1 + 2").value
call = node.breadth_first_search { |n| n.is_a?(Prism::CallNode) }
p call&.type # => :call_node
```

#%since 4.1
- **SEE** [m:Prism::Node#find]
#%end

### def ===(other) -> bool

`other` が自身と同じクラスで、位置情報を除く各フィールドの内容が
(再帰的に `===` で)一致する場合に true を返します。位置情報は「存在するかどうか」だけが比較され、実際の値(オフセットなど)は比較されません。

- **param** `other` -- 比較対象のオブジェクトを指定します。

```ruby title="例"
require "prism"

a = Prism.parse("1 + 2").value
b = Prism.parse("1 + 2").value
p a === b # => true
```

#%end

#%since 4.0
### def start_line -> Integer

開始位置の行番号を返します。[`location.start_line`](m:Prism::Location#start_line) と同じです。

### def end_line -> Integer

終了位置の行番号を返します。[`location.end_line`](m:Prism::Location#end_line) と同じです。

### def start_character_offset -> Integer

開始位置の、ソースコード先頭からの文字単位のオフセットを返します。
[`location.start_character_offset`](m:Prism::Location#start_character_offset) と同じです。

### def end_character_offset -> Integer

終了位置の、ソースコード先頭からの文字単位のオフセットを返します。
[`location.end_character_offset`](m:Prism::Location#end_character_offset) と同じです。

### def start_column -> Integer

開始位置の、行頭からのバイト単位の桁位置を返します。
[`location.start_column`](m:Prism::Location#start_column) と同じです。

### def end_column -> Integer

終了位置の、行頭からのバイト単位の桁位置を返します。
[`location.end_column`](m:Prism::Location#end_column) と同じです。

### def start_character_column -> Integer

開始位置の、行頭からの文字単位の桁位置を返します。
[`location.start_character_column`](m:Prism::Location#start_character_column) と同じです。

### def end_character_column -> Integer

終了位置の、行頭からの文字単位の桁位置を返します。
[`location.end_character_column`](m:Prism::Location#end_character_column) と同じです。

### def cached_start_code_units_offset(cache) -> Integer

キャッシュを使って、開始位置の、指定エンコーディングのコード単位でのオフセットを返します。

- **param** `cache` -- [m:Prism::Result#code_units_cache] で得た
       キャッシュを指定します。

### def cached_end_code_units_offset(cache) -> Integer

キャッシュを使って、終了位置の、指定エンコーディングのコード単位でのオフセットを返します。

- **param** `cache` -- [m:Prism::Result#code_units_cache] で得た
       キャッシュを指定します。

### def cached_start_code_units_column(cache) -> Integer

キャッシュを使って、開始位置の、行頭からのコード単位での桁位置を返します。

- **param** `cache` -- [m:Prism::Result#code_units_cache] で得た
       キャッシュを指定します。

### def cached_end_code_units_column(cache) -> Integer

キャッシュを使って、終了位置の、行頭からのコード単位での桁位置を返します。

- **param** `cache` -- [m:Prism::Result#code_units_cache] で得た
       キャッシュを指定します。

### def leading_comments -> [Prism::Comment]

このノードの前に付くコメントの配列を返します。
[`location.leading_comments`](m:Prism::Location#leading_comments) と同じです。
[m:Prism::ParseResult#attach_comments!] を呼び出す前は空配列です。

### def trailing_comments -> [Prism::Comment]

このノードの後ろに付くコメントの配列を返します。
[`location.trailing_comments`](m:Prism::Location#trailing_comments) と同じです。

### def comments -> [Prism::Comment]

このノードに関連付けられた前後両方のコメントの配列を返します。
[`location.comments`](m:Prism::Location#comments) と同じです。

### def each_child_node -> Enumerator
### def each_child_node {|node| ... } -> ()
{: since="4.0.1"}

ブロックを指定した場合、[m:Prism::Node#compact_child_nodes] の各要素を順に yield します。ブロックを指定しない場合は [c:Enumerator] を返します。
#%end

#%since 4.1
### def breadth_first_search_all {|node| ... } -> [Prism::Node]

自身を含めて構文木を幅優先で探索し、ブロックが真を返したノードをすべて集めた配列を返します。

- **SEE** [m:Prism::Node#find_all]

### def find {|node| ... } -> Prism::Node | nil

[m:Prism::Node#breadth_first_search] の別名です。

### def find_all {|node| ... } -> [Prism::Node]

[m:Prism::Node#breadth_first_search_all] の別名です。
#%end
