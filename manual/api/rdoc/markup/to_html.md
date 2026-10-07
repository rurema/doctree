---
type: library
require:
  - rdoc/markup/formatter
---
RDoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

```ruby
require 'rdoc'
require 'rdoc/markup/to_html'

#%until 4.1
h = RDoc::Markup::ToHtml.new(RDoc::Options.new)
#%else
h = RDoc::Markup::ToHtml.new
#%end
p h.convert("*bold*")
# => "\n<p><strong>bold</strong></p>\n"
```

変換した結果は文字列で取得できます。

# class RDoc::Markup::ToHtml < RDoc::Markup::Formatter

RDoc 形式のドキュメントを HTML に整形するクラスです。

## Class Methods

#%until 4.1
### def RDoc::Markup::ToHtml.new(options, markup = nil) -> RDoc::Markup::ToHtml

自身を初期化します。

- **param** `options` -- [c:RDoc::Options] オブジェクトを指定します。

- **param** `markup` -- [c:RDoc::Markup] オブジェクトを指定します。省略した場合は新しく作成します。
#%else
### def RDoc::Markup::ToHtml.new(pipe: false, output_decoration: true) -> RDoc::Markup::ToHtml

自身を初期化します。

- **param** `pipe` -- true を指定すると、コードブロックに構文の強調を付けず、見出しにリンクを付けない出力にします。`rdoc --pipe` が使います。

- **param** `output_decoration` -- false を指定すると、見出しに id 属性を付けません。
#%end
