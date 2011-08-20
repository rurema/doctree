require rdoc/markup
require rdoc/markup/formatter

rdoc 形式のドキュメントを TexInfo に整形するためのサブライブラリです。

  require 'rdoc/markup/to_texinfo'

  h = RDoc::Markup::ToTexInfo.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。

= class RDoc::Markup::ToTexInfo < RDoc::Markup::Formatter

rdoc 形式のドキュメントを TexInfo に整形するためのクラスです。

== Class Methods

--- new -> RDoc::Markup::ToTexInfo

自身を初期化します。
