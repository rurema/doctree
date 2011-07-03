rdoc 形式のドキュメントを LaTeX に整形するためのサブライブラリです。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToLaTeX]] のインスタンス
を渡して使用します。

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_latex'

  p = SM::SimpleMarkup.new
  h = SM::ToLaTeX.new
  puts p.convert(input_string, h)

= class SM::ToLaTeX

== Class Methods

--- new -> SM::ToLaTeX

自身を初期化します。

@see [[m:SM::SimpleMarkup#convert]]
