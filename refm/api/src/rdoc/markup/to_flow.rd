require rdoc/markup/formatter
require cgi

RDoc 形式のドキュメントを表示する一段階前の構造化された状態にするための
サブライブラリです。

  require 'stringio'
  require 'rdoc/ri/formatter'
  require 'rdoc/markup/to_flow'

  h = RDoc::Markup::ToFlow.new
  flow = h.convert(input_string)

  output = StringIO.new
  formatter = RDoc::RI::Formatter.new(output, 78, '  ')
  formatter.display_flow(flow)
  puts output.string

変換した結果は構造体の配列で取得できます。[[c:RDoc::Markup::ToHtml]] な
どとは異なり convert メソッドが文字列を返さないため、上記のようにフォー
マッタに変換した結果を渡す必要があります。

= class RDoc::Markup::ToFlow < RDoc::Markup::Formatter

RDoc 形式のドキュメントを表示する一段階前の構造化された状態にするための
クラスです。

== Class Methods

--- new -> RDoc::Markup::ToFlow

自身を初期化します。
