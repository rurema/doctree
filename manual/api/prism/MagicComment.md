---
library: prism
---
# class Prism::MagicComment < Object

[m:Prism::ParseResult#magic_comments] で得られる、マジックコメント
(`# frozen_string_literal: true` のような、Ruby の動作に影響を与える
特別な形式のコメント)を表すクラスです。

キーも値も**文字列**として取得されます。`"true"` を真偽値に変換する
ような意味の解釈は行われないことに注意してください。

```ruby title="例"
require "prism"

result = Prism.parse(<<~RUBY)
  # frozen_string_literal: true
  puts "hi"
RUBY
magic = result.magic_comments.first
p magic.key   # => "frozen_string_literal"
p magic.value # => "true"
```

- **SEE** [m:Prism::ParseResult#magic_comments]

## Instance Methods

### def key -> String

マジックコメントのキー(`:` の左側)を文字列で返します。
`key_loc.slice` と同じ内容です。

### def value -> String

マジックコメントの値(`:` の右側)を文字列で返します。
`value_loc.slice` と同じ内容です。

### def key_loc -> Prism::Location

キーのソースコード上の位置を表す [c:Prism::Location] を返します。

### def value_loc -> Prism::Location

値のソースコード上の位置を表す [c:Prism::Location] を返します。

```ruby title="例"
require "prism"

magic = Prism.parse("# coding: utf-8\np 1\n").magic_comments.first
p magic.key_loc.slice   # => "coding"
p magic.value_loc.slice # => "utf-8"
```
