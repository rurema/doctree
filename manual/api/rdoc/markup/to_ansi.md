---
type: library
---
RDoc 形式のドキュメントを ANSI エスケープシーケンスで色付けするサブライブラリです。

```ruby
require 'rdoc/markup/to_ansi'

h = RDoc::Markup::ToAnsi.new
puts h.convert(input_string)
```

変換した結果は文字列で取得できます。

# class RDoc::Markup::ToAnsi < RDoc::Markup::ToRdoc

RDoc 形式のドキュメントを ANSI エスケープシーケンスで色付けするクラスです。

## Class Methods

#%since 4.1
### def RDoc::Markup::ToAnsi.new -> RDoc::Markup::ToAnsi
#%else
### def RDoc::Markup::ToAnsi.new(markup = nil) -> RDoc::Markup::ToAnsi
#%end

自身を初期化します。

#%until 4.1
- **param** `markup` -- [c:RDoc::Markup] オブジェクトを指定します。省略した場合は新しく作成します。
#%end
