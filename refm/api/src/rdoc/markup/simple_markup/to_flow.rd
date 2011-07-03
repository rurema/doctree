rdoc 形式のドキュメントを ri コマンドの出力のように整形するためのサブライブラリです。

#@todo: もう少し確認する。

[[m:SM::SimpleMarkup#convert]] の引数に [[c:SM::ToFlow]] のインスタンス
を渡して使用します。

  require 'rdoc/ri/ri_formatter'
  require 'rdoc/ri/ri_options'
  require 'rdoc/markup/simple_markup'
  require 'rdoc/markup/simple_markup/to_flow'

  p = SM::SimpleMarkup.new
  h = SM::ToFlow.new
  flow = p.convert(input_string, h)
  options = RI::Options.instance
  formatter = options.formatter.new(options, "")
  formatter.display_flow(flow)

= class SM::ToFlow

== Class Methods

--- new -> SM::ToFlow

自身を初期化します。

@see [[m:SM::SimpleMarkup#convert]]
