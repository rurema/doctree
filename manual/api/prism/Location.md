---
library: prism
---
# class Prism::Location < Object

ソースコード上の範囲(開始バイトオフセットと長さ)を表すクラスです。
構文木の各ノードのほか、[c:Prism::Comment]・[c:Prism::MagicComment]・
[c:Prism::ParseError]・[c:Prism::ParseWarning]・[c:Prism::Token] などの
`location` メソッドから得られます。

行番号・桁位置への変換や、該当範囲の文字列の取り出しなどのメソッドを持ちます。桁位置を表すメソッドには「バイト単位」(`start_column` など)と「文字単位」(`start_character_column` など)の系列があります。

```ruby title="例"
require "prism"

node = Prism.parse("x = 1 + 2").value.statements.body[0]
loc = node.location
p loc.slice        # => "x = 1 + 2"
p loc.start_line   # => 1
p loc.start_offset # => 0
p loc.length       # => 9

loc = node.value.location # 右辺の 1 + 2
p loc.slice        # => "1 + 2"
p loc.start_column # => 4
```

## Instance Methods

### def start_offset -> Integer

範囲の開始位置のバイトオフセットを返します。

### def end_offset -> Integer

範囲の終端位置(最後のバイトの次)のバイトオフセットを返します。

### def length -> Integer

範囲のバイト数を返します。`end_offset - start_offset` と同じです。

### def start_line -> Integer

範囲の開始位置がある行の行番号を返します。行番号は 1 から始まります。

### def end_line -> Integer

範囲の終端位置がある行の行番号を返します。

### def start_column -> Integer

範囲の開始位置の、行頭からのバイト単位の桁位置(0 origin)を返します。

### def end_column -> Integer

範囲の終端位置の、行頭からのバイト単位の桁位置(0 origin)を返します。

### def start_character_column -> Integer

範囲の開始位置の、行頭からの文字単位の桁位置(0 origin)を返します。
マルチバイト文字を含む行では [m:Prism::Location#start_column] と異なる値になります。

### def end_character_column -> Integer

範囲の終端位置の、行頭からの文字単位の桁位置(0 origin)を返します。

```ruby title="例"
require "prism"

loc = Prism.parse('s = "あい" + x').value.statements.body[0].location
p loc.end_column           # => 16 (バイト単位)
p loc.end_character_column # => 12 (文字単位)
```

### def start_character_offset -> Integer

範囲の開始位置の、ソースコード先頭からの文字単位のオフセットを返します。

### def end_character_offset -> Integer

範囲の終端位置の、ソースコード先頭からの文字単位のオフセットを返します。

### def slice -> String

範囲に対応するソースコードの文字列を返します。

### def start_line_slice -> String

開始位置がある行の、行頭から開始位置の直前までの文字列を返します。

```ruby title="例"
require "prism"

loc = Prism.parse("x = 1").value.statements.body[0].value.location
p loc.slice            # => "1"
p loc.start_line_slice # => "x = "
```

### def join(other) -> Prism::Location

自身の開始位置から other の終端位置までを表す新しい
`Prism::Location` を返します。間にある文字列も範囲に含まれます。

- **param** `other` -- 結合する `Prism::Location`。自身より後ろにある必要があります。

```ruby title="例"
require "prism"

body = Prism.parse("foo = 1\nbar = 2\n").value.statements.body
p body[0].location.join(body[1].location).slice
# => "foo = 1\nbar = 2"
```

### def copy(source: self.source, start_offset: self.start_offset, length: self.length) -> Prism::Location

指定した属性だけを差し替えた新しい `Prism::Location` を返します。

### def comments -> Array

この位置に関連付けられたコメント([c:Prism::Comment] のサブクラスのインスタンス)の配列を返します。前に付くコメント、後ろに付くコメントの順に並びます。

コメントの関連付けは [m:Prism::ParseResult#attach_comments!] を呼び出したときに行われます。呼び出す前は空配列です。

### def ==(other) -> bool

other が同じ範囲を表す `Prism::Location` であれば true を返します。

- **param** `other` -- 比較対象のオブジェクト

#%since 3.4
### def leading_comments -> Array

この位置の前に付くコメント([c:Prism::Comment] のサブクラスのインスタンス)の配列を返します。
[m:Prism::ParseResult#attach_comments!] を呼び出す前は空配列です。

```ruby title="例"
require "prism"

result = Prism.parse("# leading\na = 1 # trailing\n")
result.attach_comments!
loc = result.value.statements.body[0].location
p loc.leading_comments.map { |c| c.slice }  # => ["# leading"]
p loc.trailing_comments.map { |c| c.slice } # => ["# trailing"]
```

### def trailing_comments -> Array

この位置の後ろに付くコメントの配列を返します。
[m:Prism::ParseResult#attach_comments!] を呼び出す前は空配列です。

### def chop -> Prism::Location

末尾の 1 バイトを除いた新しい `Prism::Location` を返します。

### def adjoin(string) -> Prism::Location

範囲の直後に続くソースコードが string と一致する場合に、その分だけ範囲を伸ばした新しい `Prism::Location` を返します。

- **param** `string` -- 取り込む文字列
- **raise** `RuntimeError` -- 範囲の直後が string と一致しない場合に発生します。

### def slice_lines -> String

範囲を含む行全体(開始行の行頭から終端行の行末まで)の文字列を返します。

### def source_lines -> Array

ソースコード全体を行ごとに分割した配列を返します。

### def start_code_units_offset(encoding = Encoding::UTF_16LE) -> Integer

範囲の開始位置の、指定エンコーディングのコード単位でのオフセットを返します。UTF-16 のコード単位で位置をやりとりする
LSP(Language Server Protocol)などとの連携向けです。

- **param** `encoding` -- コード単位の基準となるエンコーディング

### def end_code_units_offset(encoding = Encoding::UTF_16LE) -> Integer

範囲の終端位置の、指定エンコーディングのコード単位でのオフセットを返します。

### def start_code_units_column(encoding = Encoding::UTF_16LE) -> Integer

範囲の開始位置の、行頭からの指定エンコーディングのコード単位での桁位置を返します。

### def end_code_units_column(encoding = Encoding::UTF_16LE) -> Integer

範囲の終端位置の、行頭からの指定エンコーディングのコード単位での桁位置を返します。

#%end
