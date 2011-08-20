require rdoc/markup/formatter
require cgi

rdoc 形式のドキュメントを LaTeX に整形するためのサブライブラリです。

  require 'rdoc/markup/to_latex'

  h = RDoc::Markup::ToLatex.new
  puts h.convert(input_string)

変換した結果は文字列で取得できます。

= class RDoc::Markup::ToLaTeX < RDoc::Markup::Formatter

rdoc 形式のドキュメントを LaTeX 形式に整形するクラスです。

== Class Methods

--- new -> RDoc::Markup::ToLaTeX

自身を初期化します。
