#@# 1.9 系の to_html.rb については、../to_html.rd をご覧ください。
#@# 分岐しても共有できるドキュメントが少なかったため、ファイルを分けました。

require cgi

RDoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToHtml]] のインスタンス
を渡して使用します。

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  m = SM::SimpleMarkup.new
  h = SM::ToHtml.new
  puts m.convert(input_string, h)

変換した結果は文字列で取得できます。

= class SM::ToHtml

RDoc 形式のドキュメントを HTML に整形するクラスです。

[注意] 1.9 系では、require 先やクラス名が以下のように変更になりました。

 * require 先: rdoc/markup/to_html
 * クラス名: RDoc::Markup::ToHtml

== Class Methods

--- new -> SM::ToHtml

自身を初期化します。

実際に文字列を変換する際には、[[m:SM::SimpleMarkup#convert]] の引数に自
身を渡します。

@see [[m:SM::SimpleMarkup#convert]]

== Instance Methods

--- add_tag(name, start, stop) -> ()

name で登録された規則で取得された文字列を start と stop で囲むように指
定します。

@param name [[c:SM::ToHtml]] などのフォーマッタに識別させる時の名前を
            [[c:Symbol]] で指定します。

@param start 開始の記号を文字列で指定します。

@param stop 終了の記号を文字列で指定します。

例:

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  h = SM::ToHtml.new
  # :STRIKE のフォーマットを <strike> 〜 </strike> に指定。
  h.add_tag(:STRIKE, "<strike>", "</strike>")
