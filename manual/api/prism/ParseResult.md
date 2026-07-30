---
library: prism
---
#%since 3.4
# class Prism::ParseResult < Prism::Result
#%else
# class Prism::ParseResult < Object
#%end

[m:Prism?.parse] や [m:Prism?.parse_file] などの戻り値のクラスです。
構文解析によって得られた構文木そのものに加えて、解析中に見つかった
コメント・マジックコメント・エラー・警告などの付随情報をまとめて
保持します。

- **SEE** [m:Prism?.parse], [m:Prism?.parse_file], [c:Prism]

## Instance Methods

### def value -> Prism::ProgramNode

構文解析によって得られた構文木のルートノードを返します。
[m:Prism?.parse] や [m:Prism?.parse_file] の戻り値として得られる
`Prism::ParseResult` では、これは常に `Prism::ProgramNode`
(`Prism::Node` のサブクラス)のインスタンスです。

構文エラーがあった場合でも nil にはならず、prism が構築できた範囲の
構文木が返ります。エラーの有無は [m:Prism::ParseResult#success?] で
確認してください。

```ruby title="例"
require "prism"

result = Prism.parse("1 + 2")
p result.value.class # => Prism::ProgramNode

result = Prism.parse("1 +")
p result.value.class # => Prism::ProgramNode (エラーがあっても構文木は返る)
```

### def success? -> bool

構文解析にエラーがなかった場合に true を返します。
[m:Prism::ParseResult#errors] が空かどうかで判定されます。

```ruby title="例"
require "prism"

p Prism.parse("1 + 1").success? # => true
p Prism.parse("1 +").success?   # => false
```

- **SEE** [m:Prism::ParseResult#failure?], [m:Prism::ParseResult#errors]

### def failure? -> bool

[m:Prism::ParseResult#success?] の否定です。構文解析にエラーがあった
場合に true を返します。

```ruby title="例"
require "prism"

p Prism.parse("1 + 1").failure? # => false
p Prism.parse("1 +").failure?   # => true
```

- **SEE** [m:Prism::ParseResult#success?]

### def errors -> Array

構文解析中に発生したエラー([c:Prism::ParseError] のインスタンス)の
配列を返します。エラーがなければ空配列です。

```ruby title="例"
require "prism"

errors = Prism.parse('"unterminated').errors
p errors.size            # => 1
p errors.first.class     # => Prism::ParseError
p errors.first.message   # => "unterminated string meets end of file"
p errors.first.level     # => :syntax
```

- **SEE** [m:Prism::ParseResult#success?], [m:Prism::ParseResult#warnings]

#%since 3.4
### def errors_format -> String

ソースコードに [m:Prism::ParseResult#errors] の位置(`^~` の下線)と
エラーメッセージの注釈を付けた、人間が読みやすい形式の文字列を
返します。構文エラーの内容をまとめて表示したいときに使えます。

#%end
### def warnings -> Array

構文解析中に発生した警告([c:Prism::ParseWarning] のインスタンス)の
配列を返します。警告がなければ空配列です。

```ruby title="例"
require "prism"

warnings = Prism.parse("1 + 2").warnings
p warnings.size           # => 1
p warnings.first.class    # => Prism::ParseWarning
p warnings.first.message
# => "possibly useless use of + in void context"
p warnings.first.level    # => :verbose
```

- **SEE** [m:Prism::ParseResult#errors]

### def comments -> Array

構文解析中に見つかったコメント([c:Prism::Comment] のサブクラスの
インスタンス)の配列を返します。[m:Prism?.parse_comments] を
呼び出した場合と同じ内容です。

```ruby title="例"
require "prism"

comments = Prism.parse("# hello\n1 + 1").comments
p comments.size                  # => 1
p comments.first.class           # => Prism::InlineComment
p comments.first.location.slice  # => "# hello"
```

- **SEE** [m:Prism?.parse_comments]

### def magic_comments -> Array

構文解析中に見つかったマジックコメント([c:Prism::MagicComment] の
インスタンス)の配列を返します。`# frozen_string_literal: true` の
ような、Ruby の動作に影響を与える特別な形式のコメントが対象です。
各要素は `key`(項目名)と `value`(値)を持ちます。

```ruby title="例"
require "prism"

result = Prism.parse(<<~RUBY)
  # frozen_string_literal: true
  puts "hi"
RUBY
p result.magic_comments.size        # => 1
p result.magic_comments.first.key   # => "frozen_string_literal"
p result.magic_comments.first.value # => "true"
```

### def attach_comments! -> Array

[m:Prism::ParseResult#comments] の各コメントを、前後の位置関係から
構文木の各ノードの位置情報([c:Prism::Location])に関連付けます。
#%since 3.4
関連付けた結果は [m:Prism::Location#leading_comments]・
[m:Prism::Location#trailing_comments]・[m:Prism::Location#comments] で
参照できます。
#%else
関連付けた結果は [m:Prism::Location#comments] で参照できます。
#%end

戻り値は [m:Prism::ParseResult#comments] と同じ配列です。

```ruby title="例"
require "prism"

result = Prism.parse("# leading\na = 1\n")
result.attach_comments!
loc = result.value.statements.body[0].location
p loc.comments.map { |c| c.location.slice } # => ["# leading"]
```

### def data_loc -> Prism::Location | nil

ソースコード中に `__END__` 行が存在する場合、その行からファイル末尾
までの範囲を表す [c:Prism::Location] を返します。`__END__` 以降の内容は
組み込み定数 `DATA` に読み込まれる部分に対応します。`__END__` が
存在しない場合は nil を返します。

```ruby title="例"
require "prism"

result = Prism.parse(<<~RUBY)
  puts "hi"
  __END__
  some data here
RUBY
p result.data_loc.class
# => Prism::Location
p result.data_loc.slice
# => "__END__\nsome data here\n"

p Prism.parse("puts 1").data_loc # => nil
```

### def source -> Prism::Source

解析したソースコードそのものを表す [c:Prism::Source] のインスタンスを
返します。バイトオフセットから行番号・桁位置を求めるなど、位置情報を
扱うための補助的なメソッドを持ちます。

#%since 3.4
実際にはサブクラス `Prism::ASCIISource` のインスタンスの場合があります。

#%end

```ruby title="例"
require "prism"

result = Prism.parse("1 + 2")
p result.source.is_a?(Prism::Source) # => true
```
