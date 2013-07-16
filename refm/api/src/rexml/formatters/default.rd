= class REXML::Formatters::Default

XMLドキュメントを(文字列として)出力するクラスです。

[[c:REXML::Formatters::Pretty]] と
異なりテキストの改行や空白を修正せずにそのまま出力します。

  require 'rexml/document'
  require 'rexml/formatters/default'
  doc = REXML::Document.new <<EOS
  <root>
  <children>
    <grandchildren/>
  </children>
  </root>
  EOS
  
  default_formatter = REXML::Formatters::Default.new
  output = StringIO.new
  default_formatter.write(doc, output)
  output.string 
  # => "<root>\n<children>\n  <grandchildren/>\n</children>\n</root>\n"
  
  output = StringIO.new
  default_formatter.write(REXML::XPath.first(doc, "/root/children"), output)
  output.string 
  # => "<children>\n  <grandchildren/>\n</children>"
  
  ie_hack_formatter = REXML::Formatters::Default.new(true)
  output = StringIO.new
  ie_hack_formatter.write(doc, output)
  output.string 
  # => "<root>\n<children>\n  <grandchildren />\n</children>\n</root>\n"
  
== Class Method
--- new(ie_hack=false) -> REXML::Formatter::Default
フォーマッタオブジェクトを生成して返します。

このフォーマッタによる出力は基本的にテキストの空白や改行を変化させません。

ie_hack に真を渡すと、空のタグを閉じる前で空白を挿入します。
これは特定のバージョンのIEのXMLパーサのバグを避けるための機能です。

@param ie_hack 空のタグを閉じる所にスペースを入れるかどうかを指定します

== Instance Method
--- write(node, output) -> ()
XML のノード node を output に出力します。

node には任意のXMLノードを指定できます。

@param node 出力するノード
@param output 出力先(IO など << で出力できるオブジェクト)
