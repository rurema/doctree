rdoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToHtml]] のインスタンス
を渡して使用します。

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  m = SM::SimpleMarkup.new
  h = SM::ToHtml.new
  puts m.convert(input_string, h)

変換した結果は文字列で取得できます。

= class SM::ToHtml

rdoc 形式のドキュメントを HTML に整形するクラスです。

== Class Methods

--- new -> SM::ToHtml

自身を初期化します。

実際に文字列を変換する際には、[[m:SM::SimpleMarkup#convert]] の引数に自
身を渡します。

@see [[m:SM::SimpleMarkup#convert]]
