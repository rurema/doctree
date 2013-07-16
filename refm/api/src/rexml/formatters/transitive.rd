= class REXML::Formatters::Transitive < REXML::Formatters::Default

XMLドキュメントをテキストの内容を変えずに
多少の整形を加えて出力するクラスです。

これが有用な場合はあまりないでしょう。
整形されていない XML を整形したいが、
テキストの空白は改行は変えたくない場合には役にたつかもしれません。
ただ、ほとんどの場合は奇妙な出力結果になるでしょう。

  require 'rexml/document'
  require 'rexml/formatters/transitive'
  doc = REXML::Document.new <<EOS
  <root><children>
  <grandchildren foo='bar' />
  </children></root>
  EOS
  
  transitive_formatter = REXML::Formatters::Transitive.new
  output = StringIO.new
  transitive_formatter.write(doc, output)
  output.string 
  # => "<root\n><children\n  >\n<grandchildren foo='bar'\n    />\n</children\n  ></root\n>\n"
  print output.string
  # >> <root
  # >> ><children
  # >>   >
  # >> <grandchildren foo='bar'
  # >>     />
  # >> </children
  # >>   ></root
  # >> >
  
  output = StringIO.new
  transitive_formatter.write(REXML::XPath.first(doc, "/root/children"), output)
  output.string 
  # => "<children\n>\n<grandchildren foo='bar'\n  />\n</children\n>"

  
== Class Method
--- new(indentation=2, ie_hack=false) -> REXML::Formatter::Transitive
フォーマッタオブジェクトを生成して返します。

このフォーマッタによる出力は基本的にテキストの空白や改行を変化させないと
いう制約のもと、出力を整形します。

indentation でインデント幅を指定できます。

ie_hack に真を渡すと、空のタグを閉じる前で空白を挿入します。
これは特定のバージョンのIEのXMLパーサのバグを避けるための機能です。

@param indentation インデント幅
@param ie_hack 空のタグを閉じる所にスペースを入れるかどうかを指定します

