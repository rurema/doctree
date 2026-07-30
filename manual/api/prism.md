---
type: library
since: "3.3"
category: Text
---
Ruby プログラムを解析するための、エラー耐性のあるパーサライブラリです。

prism は Ruby 3.3 で default gem として導入され、Ruby 3.4 以降は
CRuby 本体が Ruby プログラムをコンパイルする際に使われるデフォルトの
パーサの実装になっています(3.3 の時点では `ruby --parser=prism`
オプションで試験的に切り替えられる位置づけでした)。

設計上の目標として、構文エラーがあっても可能な限り解析を継続する
「エラー耐性(error tolerant)」を重視しており、エディタや IDE、linter
といった、エラーを含む可能性があるコードも解析する必要があるツールから
利用しやすくなっています。また C99 で実装された移植性の高いライブラリ
(libprism)でもあり、CRuby 以外の Ruby 処理系やツール、他言語の
バインディングからも利用できます。

構文解析の結果得られる構文木の各ノードは `Prism::Node` のサブクラス
(150 種類以上)として表現されますが、個々のノードクラスの詳細はこの
リファレンスでは扱いません。ノードクラスも含めた完全な API については
公式ドキュメントを参照してください。

- プロジェクトページ: <https://github.com/ruby/prism>
- リファレンス(YARD): <https://www.rubydoc.info/gems/prism>
- ドキュメントサイト: <https://ruby.github.io/prism/>

```ruby title="例"
require "prism"

result = Prism.parse("1 + 2")
p result.class          # => Prism::ParseResult
p result.value.class    # => Prism::ProgramNode
p result.success?       # => true
```

# module Prism

Ruby プログラムの構文解析・字句解析を行うためのモジュール関数を
提供するモジュールです。文字列を直接解析する [m:Prism?.parse] や
[m:Prism?.lex] の他、ファイルを指定して解析する [m:Prism?.parse_file]
などが用意されています。

解析結果は多くの場合 [c:Prism::ParseResult] のインスタンスとして
返されます。詳細は [c:Prism::ParseResult] を参照してください。

## Module Functions

### module_function def parse(source, **options) -> Prism::ParseResult

Ruby プログラムのソースコード文字列 `source` を構文解析し、結果を
[c:Prism::ParseResult] として返します。

prism はエラー耐性のあるパーサなので、構文エラーがあっても可能な限り
解析を継続し、部分的な構文木を [m:Prism::ParseResult#value] に格納
します。エラーの有無は [m:Prism::ParseResult#success?] や
[m:Prism::ParseResult#errors] で確認できます。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- 解析オプションをキーワード引数で指定します。
       主なものは以下の通りです。

- **`:filepath`**:
  ソースコードのファイルパスを指定します(エラーメッセージなどに使われます)。
- **`:line`**:
  解析を開始する行番号(1 始まり)を指定します。
- **`:encoding`**:
  ソースコードのエンコーディングを指定します。
- **`:scopes`**:
  ソースコードの周囲で定義済みのローカル変数を、シンボルの配列の配列で
  指定します。`eval` のように周囲のローカル変数を引き継いで解析したい
  場合に使います。
- **`:version`**:
  解析に使う Ruby の構文バージョンを文字列(例 `"3.3.0"`)で指定します。
  省略時は最新の構文として解析します。

上記以外にも `:command_line`, `:frozen_string_literal`, `:main_script`,
`:partial_script` などのオプションがあります。利用可能なオプションの
完全な一覧は prism のバージョンによって多少異なるため、公式ドキュメント
を参照してください。

```ruby title="例"
require "prism"

result = Prism.parse("1 + 2")
p result.class          # => Prism::ParseResult
p result.value.class    # => Prism::ProgramNode
p result.success?       # => true
```

```ruby title="例: 構文エラーがあっても解析を継続する"
require "prism"

result = Prism.parse('"unterminated')
p result.success?              # => false
p result.errors.size           # => 1
p result.errors.first.message  # => "unterminated string meets end of file"
p result.value.class           # => Prism::ProgramNode (エラーがあっても構文木は返る)
```

- **SEE** [c:Prism::ParseResult]

### module_function def parse_file(filepath, **options) -> Prism::ParseResult

`filepath` で指定したファイルを読み込んで構文解析します。
オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "def foo(a, b) = a + b\n")

result = Prism.parse_file("sample.rb")
p result.class         # => Prism::ParseResult
p result.value.class   # => Prism::ProgramNode
p result.success?      # => true
```

- **SEE** [m:Prism?.parse]

#%since 3.4
### module_function def lex(source, **options) -> Prism::LexResult
#%else
### module_function def lex(source, **options) -> Prism::ParseResult
#%end

#%since 3.4
`source` を字句解析し、[c:Prism::LexResult] のインスタンスを返します。
#%else
`source` を字句解析します。Ruby 3.3 の prism には字句解析専用の
結果クラスがないため、戻り値は [c:Prism::ParseResult] のインスタンスです。
#%end
`value` は `[トークン, 直前からの字句解析器の状態(Integer)]` という
2 要素配列の配列です。これは [c:Ripper] の [m:Ripper.lex] の戻り値の
形式に近いものになっています。オプションは [m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

result = Prism.lex("1 + 2")
#%since 3.4
p result.class   # => Prism::LexResult
#%end
result.value.each { |token, state| p [token.type, token.value, state] }
# => [:INTEGER, "1", 2]
# => [:PLUS, "+", 1]
# => [:INTEGER, "2", 2]
# => [:EOF, "", 2]
```

- **SEE** [m:Prism?.parse], [c:Ripper]

#%since 3.4
### module_function def lex_file(filepath, **options) -> Prism::LexResult
#%else
### module_function def lex_file(filepath, **options) -> Prism::ParseResult
#%end

`filepath` で指定したファイルを字句解析します。戻り値の形式は
[m:Prism?.lex] と同じです。
オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "def foo(a, b) = a + b\n")

result = Prism.lex_file("sample.rb")
#%since 3.4
p result.class
# => Prism::LexResult
#%end
p result.value.map { |token, _state| token.type }
# => [:KEYWORD_DEF, :IDENTIFIER, :PARENTHESIS_LEFT, :IDENTIFIER, :COMMA,
#     :IDENTIFIER, :PARENTHESIS_RIGHT, :EQUAL, :IDENTIFIER, :PLUS,
#     :IDENTIFIER, :NEWLINE, :EOF]
```

- **SEE** [m:Prism?.lex]

#%since 3.4
### module_function def parse_lex(source, **options) -> Prism::ParseLexResult
#%else
### module_function def parse_lex(source, **options) -> Prism::ParseResult
#%end

#%since 3.4
`source` に対して構文解析と字句解析の両方を行い、
[c:Prism::ParseLexResult] のインスタンスを返します。`value` は
`[構文木, トークンの配列]` という 2 要素配列です。
#%else
`source` に対して構文解析と字句解析の両方を行います。Ruby 3.3 の
prism には専用の結果クラスがないため、戻り値は
[c:Prism::ParseResult] のインスタンスで、`value` が
`[構文木, トークンの配列]` という 2 要素配列になります。
#%end

構文木とトークン列の両方が必要な場合、[m:Prism?.parse] と [m:Prism?.lex]
を個別に呼び出すよりも効率的です。片方だけが必要な場合はそれぞれ
[m:Prism?.parse] または [m:Prism?.lex] を使ってください。オプションは
[m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

result = Prism.parse_lex("1 + 2")
#%since 3.4
p result.class # => Prism::ParseLexResult
#%end

ast, tokens = result.value
p ast.class    # => Prism::ProgramNode
p tokens.size  # => 4
```

- **SEE** [m:Prism?.parse], [m:Prism?.lex]

#%since 3.4
### module_function def parse_lex_file(filepath, **options) -> Prism::ParseLexResult
#%else
### module_function def parse_lex_file(filepath, **options) -> Prism::ParseResult
#%end

`filepath` で指定したファイルに対して構文解析と字句解析の両方を
行います。戻り値の形式は [m:Prism?.parse_lex] と同じです。
オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "1 + 2\n")

ast, tokens = Prism.parse_lex_file("sample.rb").value
p ast.class # => Prism::ProgramNode
p tokens.map { |token, _state| token.type }
# => [:INTEGER, :PLUS, :INTEGER, :NEWLINE, :EOF]
```

- **SEE** [m:Prism?.parse_lex]

### module_function def parse_success?(source, **options) -> bool

`source` を構文解析し、エラーなく解析できた場合に true を返します。
[m:Prism?.parse] を呼び出して [`.success?`](m:Prism::ParseResult#success?) を確認するのとほぼ同じ
結果になりますが、構文木を Ruby オブジェクトとして構築しないぶん
高速です。オプションは [m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

p Prism.parse_success?("1 + 1") # => true
p Prism.parse_success?("1 +")   # => false
```

- **SEE** [m:Prism?.parse_failure?], [m:Prism::ParseResult#success?]

### module_function def parse_failure?(source, **options) -> bool

[m:Prism?.parse_success?] の否定です。`source` の構文解析に
エラーがあった場合に true を返します。オプションは [m:Prism?.parse]
と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

p Prism.parse_failure?("1 + 1") # => false
p Prism.parse_failure?("1 +")   # => true
```

- **SEE** [m:Prism?.parse_success?], [m:Prism::ParseResult#failure?]

### module_function def dump(source, **options) -> String

`source` を構文解析した結果を prism 独自のバイナリ形式に
シリアライズし、その文字列を返します。この形式は主に、CRuby の
拡張ライブラリを経由せずに、他言語(JavaScript、Rust、Java など)の
実装から prism の構文木を読み込むために使われます。エンコーディングは
常に ASCII-8BIT (BINARY) になります。オプションは [m:Prism?.parse]
と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

dumped = Prism.dump("1 + 2")
p dumped.class     # => String
p dumped.encoding  # => #<Encoding:BINARY (ASCII-8BIT)>
```

### module_function def dump_file(filepath, **options) -> String

`filepath` で指定したファイルを構文解析し、[m:Prism?.dump] と
同様にシリアライズした文字列を返します。オプションは [m:Prism?.parse]
と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "def foo(a, b) = a + b\n")

p Prism.dump_file("sample.rb").class # => String
```

- **SEE** [m:Prism?.dump]

### module_function def parse_comments(source, **options) -> Array

`source` を構文解析し、見つかったコメントを表すオブジェクトの
配列を返します。配列の要素は `Prism::InlineComment`(`# ...` 形式の
コメント)または `Prism::EmbDocComment`(`=begin`/`=end` 形式の
コメント)のインスタンスです。オプションは [m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

comments = Prism.parse_comments("# hello\n1 + 1")
p comments.size                  # => 1
p comments.first.class           # => Prism::InlineComment
p comments.first.location.slice  # => "# hello"
```

- **SEE** [m:Prism::ParseResult#comments]

### module_function def parse_file_comments(filepath, **options) -> Array

`filepath` で指定したファイルを構文解析し、[m:Prism?.parse_comments]
と同様にコメントを表すオブジェクトの配列を返します。
オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample2.rb", "# comment here\nputs 1\n")

comments = Prism.parse_file_comments("sample2.rb")
p comments.size         # => 1
p comments.first.class  # => Prism::InlineComment
```

- **SEE** [m:Prism?.parse_comments]
