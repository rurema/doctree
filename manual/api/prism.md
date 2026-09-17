---
type: library
since: "3.3"
category: Text
---
Ruby プログラムを解析するための、エラー耐性のあるパーサライブラリです。

prism は Ruby 3.3 で default gem として導入され、Ruby 3.4 以降は
CRuby 本体が Ruby プログラムをコンパイルする際に使われるデフォルトのパーサの実装になっています(3.3 の時点では `ruby --parser=prism`
オプションで試験的に切り替えられる位置づけでした)。

設計上の目標として、構文エラーがあっても可能な限り解析を継続する「エラー耐性(error tolerant)」を重視しており、エディタや IDE、linter
といった、エラーを含む可能性があるコードも解析する必要があるツールから利用しやすくなっています。また C99 で実装された移植性の高いライブラリ
(libprism)でもあり、CRuby 以外の Ruby 処理系やツール、他言語のバインディングからも利用できます。

構文解析の結果得られる構文木の各ノードは [c:Prism::Node] のサブクラス
(150 種類以上)として表現されます。すべてのノードに共通する API は
[c:Prism::Node] で扱いますが、個々のノードクラスの詳細はこのリファレンスでは扱いません([c:Prism::Node] にクラス名とフィールド名の一覧表だけを置いています)。
また、ノードの種類ごとに `visit_xxx_node` のようなメソッドを持つ `Prism::Visitor`・`Prism::BasicVisitor`・`Prism::Compiler`・`Prism::Dispatcher`・`Prism::DSL`・`Prism::Translation::Ripper` などのクラスも扱いません。
ノードクラスも含めた完全な API については公式ドキュメントを参照してください。

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

Ruby プログラムの構文解析・字句解析を行うためのモジュール関数を提供するモジュールです。文字列を直接解析する [m:Prism?.parse] や
[m:Prism?.lex] の他、ファイルを指定して解析する [m:Prism?.parse_file]
などが用意されています。

解析結果は多くの場合 [c:Prism::ParseResult] のインスタンスとして返されます。詳細は [c:Prism::ParseResult] を参照してください。

## Module Functions

### module_function def parse(source, **options) -> Prism::ParseResult

Ruby プログラムのソースコード文字列 `source` を構文解析し、結果を
[c:Prism::ParseResult] として返します。

prism はエラー耐性のあるパーサなので、構文エラーがあっても可能な限り解析を継続し、部分的な構文木を [m:Prism::ParseResult#value] に格納します。エラーの有無は [m:Prism::ParseResult#success?] や
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
  ソースコードの周囲で定義済みのローカル変数を、シンボルの配列の配列で指定します。`eval` のように周囲のローカル変数を引き継いで解析したい場合に使います。
- **`:version`**:
  解析に使う Ruby の構文バージョンを文字列(例 `"3.3.0"`)で指定します。
  省略時は最新の構文として解析します。

上記以外にも `:command_line`, `:frozen_string_literal`, `:main_script`,
`:partial_script` などのオプションがあります。利用可能なオプションの完全な一覧は prism のバージョンによって多少異なるため、公式ドキュメントを参照してください。

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
`source` を字句解析します。Ruby 3.3 の prism には字句解析専用の結果クラスがないため、戻り値は [c:Prism::ParseResult] のインスタンスです。
#%end
`value` は `[トークン, 直前からの字句解析器の状態(Integer)]` という
2 要素配列の配列です。これは [c:Ripper] の [m:Ripper.lex] の戻り値の形式に近いものになっています。オプションは [m:Prism?.parse] と同じです。

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

`filepath` で指定したファイルに対して構文解析と字句解析の両方を行います。戻り値の形式は [m:Prism?.parse_lex] と同じです。
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
[m:Prism?.parse] を呼び出して [`.success?`](m:Prism::ParseResult#success?) を確認するのとほぼ同じ結果になりますが、構文木を Ruby オブジェクトとして構築しないぶん高速です。オプションは [m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

p Prism.parse_success?("1 + 1") # => true
p Prism.parse_success?("1 +")   # => false
```

- **SEE** [m:Prism?.parse_failure?], [m:Prism::ParseResult#success?]

### module_function def parse_failure?(source, **options) -> bool

[m:Prism?.parse_success?] の否定です。`source` の構文解析にエラーがあった場合に true を返します。オプションは [m:Prism?.parse]
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

`source` を構文解析した結果を prism 独自のバイナリ形式にシリアライズし、その文字列を返します。この形式は主に、CRuby の拡張ライブラリを経由せずに、他言語(JavaScript、Rust、Java など)の実装から prism の構文木を読み込むために使われます。エンコーディングは常に ASCII-8BIT (BINARY) になります。オプションは [m:Prism?.parse]
と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。

- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

dumped = Prism.dump("1 + 2")
p dumped.class     # => String
#%since 3.4
p dumped.encoding  # => #<Encoding:BINARY (ASCII-8BIT)>
#%else
p dumped.encoding  # => #<Encoding:ASCII-8BIT>
#%end
```

### module_function def dump_file(filepath, **options) -> String

`filepath` で指定したファイルを構文解析し、[m:Prism?.dump] と同様にシリアライズした文字列を返します。オプションは [m:Prism?.parse]
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

`source` を構文解析し、見つかったコメントを表すオブジェクトの配列を返します。配列の要素は `Prism::InlineComment`(`# ...` 形式のコメント)または `Prism::EmbDocComment`(`=begin`/`=end` 形式のコメント)のインスタンスです。オプションは [m:Prism?.parse] と同じです。

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

#%since 4.1
### module_function def find(callable) -> Prism::Node | nil

`callable` に対応する構文木のノードを返します。

CRuby では [m:Prism::Node#node_id] を使って正確に対応するノードを特定します。それ以外の実装では、ソースコード上の行番号によるベストエフォートの照合にフォールバックします。対応するノードが見つからない場合は nil を返します。

- **param** `callable` -- 対応するノードを探したい [c:Method]・[c:UnboundMethod]・[c:Proc]・[c:Thread::Backtrace::Location] のいずれかを指定します。
- **raise** `ArgumentError` -- `callable` が上記のいずれでもない場合に発生します。

#%end

### module_function def lex_compat(source, **options) -> Prism::Result

`source` を字句解析し、[c:Ripper] の `Ripper.lex` に近い形式のトークン列を持つ結果オブジェクトを返します。

戻り値は内部クラス `Prism::LexCompat::Result` のインスタンスです。`value` は各要素が `[[行, 桁], 種類を表すシンボル, 文字列, 状態]` という形式になっている配列で、`Ripper.lex` の戻り値に近い形式です。[m:Prism?.lex] が返す [c:Prism::Token] とは異なり、Ripper 互換の配列形式でトークンを扱いたい場合に使います。オプションは [m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。
- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

result = Prism.lex_compat("1 + 2")
p result.value.first
# => [[1, 0], :on_int, "1", END]
```

- **SEE** [m:Prism?.lex], [c:Ripper]

#%until 4.1
### module_function def lex_ripper(source) -> Array

`source` を [c:Ripper] の `Ripper.lex` を使って字句解析します。

空白のイベントを除いた、`Ripper.lex` とほぼ同じ形式のトークンの配列を返します。[m:Prism?.lex_compat] とは異なり、prism 自身ではなく組み込みの [c:Ripper] を使って字句解析します。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。
- **raise** `SyntaxError` -- `source` の構文が不正な場合に発生します。

```ruby title="例"
require "prism"

p Prism.lex_ripper("1 + 2")
# => [[[1, 0], :on_int, "1", END], [[1, 2], :on_op, "+", BEG], [[1, 4], :on_int, "2", END]]
```

- **SEE** [m:Prism?.lex_compat], [c:Ripper]

#%end

### module_function def load(source, serialized, freeze = false) -> Prism::ParseResult

`source` と、それを prism でシリアライズした文字列 `serialized` から構文木を復元し、[c:Prism::ParseResult] として返します。

[m:Prism?.dump] や [m:Prism?.dump_file] で得たシリアライズ済み文字列を、それを生成したときと同じ `source` と組み合わせてデシリアライズするために使います。`freeze` に true を指定すると、復元した構文木の各ノードを frozen にします。

- **param** `source` -- `serialized` を生成したときに使ったソースコードの文字列を指定します。
- **param** `serialized` -- [m:Prism?.dump] などで得たシリアライズ済みの文字列を指定します。
- **param** `freeze` -- true を指定すると復元した構文木を frozen にします。省略した場合は false です。

```ruby title="例"
require "prism"

source = "1 + 2"
dumped = Prism.dump(source)
result = Prism.load(source, dumped)
p result.class        # => Prism::ParseResult
p result.value.slice   # => "1 + 2"
```

- **SEE** [m:Prism?.dump], [m:Prism?.dump_file]

### module_function def parse_file_success?(filepath, **options) -> bool

`filepath` で指定したファイルを構文解析し、エラーなく解析できた場合に true を返します。

[m:Prism?.parse_file] を呼び出して [`.success?`](m:Prism::ParseResult#success?) を確認するのとほぼ同じ結果になりますが、構文木を Ruby オブジェクトとして構築しないぶん高速です。[m:Prism?.parse_success?] のファイル版です。オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。
- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "def foo(a, b) = a + b\n")
p Prism.parse_file_success?("sample.rb") # => true

File.write("bad.rb", "def foo(\n")
p Prism.parse_file_success?("bad.rb")    # => false
```

- **SEE** [m:Prism?.parse_file_failure?], [m:Prism?.parse_success?]

### module_function def parse_file_failure?(filepath, **options) -> bool

`filepath` で指定したファイルの構文解析にエラーがあった場合に true を返します。

[m:Prism?.parse_file_success?] の否定です。オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。
- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "def foo(a, b) = a + b\n")
p Prism.parse_file_failure?("sample.rb") # => false

File.write("bad.rb", "def foo(\n")
p Prism.parse_file_failure?("bad.rb")    # => true
```

- **SEE** [m:Prism?.parse_file_success?]

#%since 3.4
### module_function def parse_stream(stream, **options) -> Prism::ParseResult

`gets` に応答するオブジェクト `stream` から少しずつ読み込みながら構文解析し、結果を [c:Prism::ParseResult] として返します。

ソースコード全体を事前に文字列としてメモリに読み込むことなく構文解析したい場合に使います。オプションは [m:Prism?.parse] と同じです。

- **param** `stream` -- `gets(limit)` に応答するオブジェクトを指定します。[c:IO] や [c:StringIO] などが使えます。
- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"
require "stringio"

result = Prism.parse_stream(StringIO.new("1 + 2\n"))
p result.class        # => Prism::ParseResult
p result.value.slice   # => "1 + 2"
```

- **SEE** [m:Prism?.parse]

### module_function def profile(source, **options) -> nil

`source` を構文解析しますが、結果を Ruby オブジェクトとして構築せずに nil を返します。

プロファイラが構文木を Ruby オブジェクト化するオーバーヘッドを避けつつ、構文解析そのものの処理時間を計測できるようにするためのメソッドです。オプションは [m:Prism?.parse] と同じです。

- **param** `source` -- 解析する Ruby プログラムの文字列を指定します。
- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

p Prism.profile("1 + 2") # => nil
```

- **SEE** [m:Prism?.parse], [m:Prism?.profile_file]

### module_function def profile_file(filepath, **options) -> nil

`filepath` で指定したファイルを構文解析しますが、結果を Ruby オブジェクトとして構築せずに nil を返します。

[m:Prism?.profile] のファイル版です。オプションは [m:Prism?.parse] と同じです。

- **param** `filepath` -- 解析する Ruby プログラムのファイルパスを指定します。
- **param** `options` -- [m:Prism?.parse] を参照してください。

```ruby title="例"
require "prism"

File.write("sample.rb", "1 + 2\n")
p Prism.profile_file("sample.rb") # => nil
```

- **SEE** [m:Prism?.profile]

#%end

#%since 4.0
### module_function def scope(locals: [], forwarding: []) -> Prism::Scope

解析対象のソースコードの周囲にあるものとして扱うローカル変数と、そこから転送されるパラメータの情報をまとめた `Prism::Scope` のインスタンスを作成します。

作成したオブジェクトは [m:Prism?.parse] などの `scopes:` オプションの要素として渡します。`eval` のように、周囲のスコープで定義済みのローカル変数を引き継いで解析したい場合に使います。

- **param** `locals` -- そのスコープで定義済みとみなすローカル変数名をシンボルの配列で指定します。省略した場合は空配列です。
- **param** `forwarding` -- そのスコープから次のスコープへ転送されるパラメータの種類を、`:*`・`:**`・`:&`・`:"..."` のいずれかのシンボルからなる配列で指定します。省略した場合は空配列です。

```ruby title="例"
require "prism"

scope = Prism.scope(locals: [:x])
result = Prism.parse("x + 1", scopes: [scope])
p result.value.statements.body[0].receiver.class
# => Prism::LocalVariableReadNode
```

- **SEE** [m:Prism?.parse]

#%end

