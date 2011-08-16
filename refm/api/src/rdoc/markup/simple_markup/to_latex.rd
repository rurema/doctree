require cgi

rdoc 形式のドキュメントを LaTeX に整形するためのサブライブラリです。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToLaTeX]] のインスタンス
を渡して使用します。

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_latex'

  m = SM::SimpleMarkup.new
  h = SM::ToLaTeX.new
  puts m.convert(input_string, h)

変換した結果は文字列で取得できます。

= class SM::ToLaTeX

rdoc 形式のドキュメントを LaTeX 形式に整形するクラスです。

== Class Methods

--- new -> SM::ToLaTeX

自身を初期化します。

実際に文字列を変換する際には、[[m:SM::SimpleMarkup#convert]] の引数に自
身を渡します。

@see [[m:SM::SimpleMarkup#convert]]
