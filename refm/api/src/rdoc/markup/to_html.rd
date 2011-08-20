require rdoc/markup/formatter

rdoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

  require 'rdoc/markup/to_html'

  h = RDoc::Markup::ToHtml.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。

= class RDoc::Markup::ToHtml < RDoc::Markup::Formatter

rdoc 形式のドキュメントを HTML に整形するクラスです。

== Class Methods

--- new -> RDoc::Markup::ToHtml

自身を初期化します。
