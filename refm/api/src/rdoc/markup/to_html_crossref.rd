require rdoc/markup/to_html

rdoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

Subclass of the RDoc::Markup::ToHtml class that supports looking up words in
the AllReferences list. Those that are found (like AllReferences in this
comment) will be hyperlinked

  require 'rdoc/markup/to_html_crossref'

  h = RDoc::Markup::ToHtmlCrossref.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。

= class RDoc::Markup::ToHtmlCrossref < RDoc::Markup::ToHtml

rdoc 形式のドキュメントを HTML に整形するクラスです。

== Class Methods

--- new(from_path, context, show_hash) -> RDoc::Markup::ToHtmlCrossref

自身を初期化します。

We need to record the html path of our caller so we can generate
correct relative paths for any hyperlinks that we find
