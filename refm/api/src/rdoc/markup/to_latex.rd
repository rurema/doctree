require rdoc/markup/formatter
require cgi

RDoc 形式のドキュメントを LaTeX に整形するためのサブライブラリです。

[注意] rdoc 2.5 で廃止されたため、1.9.2 から
[[lib:rdoc/markup/to_latex]] は標準添付ライブラリに含まれなくなりました。

= class RDoc::Markup::ToLaTeX < RDoc::Markup::Formatter

RDoc 形式のドキュメントを LaTeX 形式に整形するクラスです。

== Class Methods

--- new -> RDoc::Markup::ToLaTeX

自身を初期化します。

[注意] 1.9.1 では [[m:RDoc::Markup::ToLaTeX.new]] に不具合があるため、
正しく変換が行えません。
