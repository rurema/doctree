#@# 1.9 系の to_latex.rb については、../to_latex.rd をご覧ください。
#@# 分岐しても共有できるドキュメントが少なかったため、ファイルを分けました。

require cgi

RDoc 形式のドキュメントを LaTeX に整形するためのサブライブラリです。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToLaTeX]] のインスタンス
を渡して使用します。

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_latex'

  m = SM::SimpleMarkup.new
  h = SM::ToLaTeX.new
  puts m.convert(input_string, h)

変換した結果は文字列で取得できます。

= class SM::ToLaTeX

RDoc 形式のドキュメントを LaTeX 形式に整形するクラスです。

[注意] 1.9 系では、require 先やクラス名が以下のように変更になりました。

 * require 先: rdoc/markup/to_latex
 * クラス名: RDoc::Markup::ToLaTeX

== Class Methods

--- new -> SM::ToLaTeX

自身を初期化します。

実際に文字列を変換する際には、[[m:SM::SimpleMarkup#convert]] の引数に自
身を渡します。

@see [[m:SM::SimpleMarkup#convert]]

== Instance Methods

--- add_tag(name, start, stop) -> ()

name で登録された規則で取得された文字列を start と stop で囲むように指
定します。

@param name [[c:SM::ToLaTeX]] などのフォーマッタに識別させる時の名前を
            [[c:Symbol]] で指定します。

@param start 開始の記号を文字列で指定します。

@param stop 終了の記号を文字列で指定します。
