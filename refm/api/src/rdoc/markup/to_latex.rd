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

[注意] 1.9.1 では [[m:RDoc::Markup::ToLaTeX#initialize]] に不具合がある
ため、正しく変換が行えません。

#@# 要望がある場合、以下を追記する。
#@#
#@# どうしても使用したい場合、以下のように
#@# [[m:RDoc::Markup::ToLaTeX#initialize]] を自己責任で上書きしてくださ
#@# い。
#@#
#@#   require 'rdoc/markup/to_latex'
#@#
#@#   class RDoc::Markup::ToLaTeX < RDoc::Markup::Formatter
#@#     def initialize
#@#       super
#@#       init_tags
#@#       @list_depth = 0
#@#       @prev_list_types = []
#@#     end
#@#   end
#@#
#@#   h = RDoc::Markup::ToLaTeX.new
#@#   puts h.convert(input_string)
#@#
#@# 変換した結果は文字列で取得できます。
