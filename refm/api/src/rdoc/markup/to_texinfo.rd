require rdoc/markup
require rdoc/markup/formatter

RDoc 形式のドキュメントを TexInfo に整形するためのサブライブラリです。

  require 'rdoc/markup/to_texinfo'

  h = RDoc::Markup::ToTexInfo.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。

[注意] rdoc 2.5 で廃止されたため、1.9.2 から
[[lib:rdoc/markup/to_texinfo]] は標準添付ライブラリに含まれなくなりまし
た。

= class RDoc::Markup::ToTexInfo < RDoc::Markup::Formatter

RDoc 形式のドキュメントを TexInfo に整形するためのクラスです。

== Class Methods

--- new -> RDoc::Markup::ToTexInfo

自身を初期化します。
