---
type: library
---
RDoc 形式のドキュメントを ANSI エスケープシーケンスで色付けするサブライ
ブラリです。

```ruby
require 'rdoc/markup/to_ansi'

h = RDoc::Markup::ToAnsi.new
puts h.convert(input_string)
```

変換した結果は文字列で取得できます。

# class RDoc::Markup::ToAnsi < RDoc::Markup::ToRdoc

RDoc 形式のドキュメントを ANSI エスケープシーケンスで色付けするクラスで
す。

## Class Methods

### def new(markup = nil) -> RDoc::Markup::ToAnsi

自身を初期化します。

- **param** `markup` -- [c:RDoc::Markup] オブジェクトを指定します。省略した場合
              は新しく作成します。
