---
library: prism
---
# class Prism::Comment < Object

[m:Prism::ParseResult#comments] や [m:Prism?.parse_comments] で得られる、ソースコード中のコメントを表す抽象基底クラスです。

実際に生成されるのはサブクラスの [c:Prism::InlineComment](`#` から始まる通常のコメント)または [c:Prism::EmbDocComment](`=begin` 〜
`=end` の埋め込みドキュメント)のどちらかで、このクラス自体のインスタンスが返されることはありません。

- **SEE** [m:Prism::ParseResult#comments], [m:Prism?.parse_comments]

## Instance Methods

### def location -> Prism::Location

コメントのソースコード上の位置を表す [c:Prism::Location] を返します。
コメントの文字列そのものは `location.slice` で取得できます。

```ruby title="例"
require "prism"

comment = Prism.parse("# hello\n1 + 1").comments.first
p comment.location.start_line # => 1
p comment.location.slice      # => "# hello"
```

#%since 3.4
### def slice -> String

コメントの文字列そのものを返します。`location.slice` の短縮形です。

```ruby title="例"
require "prism"

comment = Prism.parse("# hello\n1 + 1").comments.first
p comment.slice # => "# hello"
```

#%end
# class Prism::InlineComment < Prism::Comment

`#` から始まる通常のコメントを表すクラスです。

## Instance Methods

### def trailing? -> bool

コードの後ろに続く行末コメントであれば true を、行頭(または空白だけ)
から始まる独立した行のコメントであれば false を返します。

```ruby title="例"
require "prism"

comments = Prism.parse(<<~RUBY).comments
  # 独立した行のコメント
  1 + 1 # 行末コメント
RUBY
p comments[0].trailing? # => false
p comments[1].trailing? # => true
```

# class Prism::EmbDocComment < Prism::Comment

`=begin` 〜 `=end` で囲まれた埋め込みドキュメントを表すクラスです。

## Instance Methods

### def trailing? -> bool

常に false を返します。行末コメントになり得るのは
[c:Prism::InlineComment] だけです。
