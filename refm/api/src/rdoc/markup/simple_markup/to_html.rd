rdoc 形式のドキュメントを HTML に整形するためのサブライブラリです。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToHtml]] のインスタンス
を渡して使用します。

  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_html'

  p = SM::SimpleMarkup.new
  h = SM::ToHtml.new
  puts p.convert(input_string, h)

= class SM::ToHtml

rdoc 形式のドキュメントを HTML に整形するクラスです。

[[c:SM::SimpleMarkup]] に処理を移譲します。

#@todo 委譲の件はもう少し確認する。

== Class Methods

--- new -> SM::ToHtml

自身を初期化します。

@see [[m:SM::SimpleMarkup#convert]]

#@todo: SM::ToHtml を継承した整形も考えられるため、継承に必要なメソッドの追加、説明を加える。SimpleMarkup に。
