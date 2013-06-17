category FileFormat

Pure Ruby の XML パーサです。
DOM スタイルと SAX スタイルの両方をカバーしています。

  * DOMっぽいAPI
    * rexml/document
    * rexml/element
    * rexml/attribute
    * rexml/namespace
    * rexml/text (おまけで rexml/cdata も？)
    * rexml/instruction

  * SAXっぽいAPI
    * rexml/parsers/streamparser
    * rexml/streamlistener

    * rexml/parsers/sax2parser
    * rexml/sax2listener

=== リンク

  * REXML Home
    [[url:http://www.germane-software.com/software/rexml]]
  * API リファレンス
    [[url:http://www.germane-software.com/software/rexml_doc]]
    日本語訳 [[url:http://pub.cozmixng.org/~kou/rexml-doc-ja/]]
  * チュートリアル
    [[url:http://www.germane-software.com/software/rexml/docs/tutorial.html]]
    日本語訳 [[url:http://www.baykit.org/~makotos/cgi-bin/wiliki.cgi?REXML%A5%C1%A5%E5%A1%BC%A5%C8%A5%EA%A5%A2%A5%EB&l=jp]]
  * 日本語
    [[url:http://www.cozmixng.org/~kou/ruby/rexml/]]
    [[url:http://www.cozmixng.org/~kou/ruby/rexml/reference]]

#@include(rexml/attlistdecl.rd)
#@include(rexml/attribute.rd)
#@include(rexml/cdata.rd)
#@include(rexml/child.rd)
#@include(rexml/comment.rd)
#@include(rexml/doctype.rd)
#@include(rexml/document.rd)
#@include(rexml/dtd/attlistdecl.rd)
#@include(rexml/dtd/dtd.rd)
#@include(rexml/dtd/elementdecl.rd)
#@include(rexml/dtd/entitydecl.rd)
#@include(rexml/dtd/notationdecl.rd)
#@include(rexml/element.rd)
#@include(rexml/encoding.rd)
#@include(rexml/entity.rd)
#@include(rexml/functions.rd)
#@include(rexml/instruction.rd)
#@include(rexml/light/node.rd)
#@include(rexml/namespace.rd)
#@include(rexml/node.rd)
#@include(rexml/output.rd)
#@include(rexml/parent.rd)
#@include(rexml/parseexception.rd)
#@include(rexml/parsers/baseparser.rd)
#@include(rexml/parsers/lightparser.rd)
#@include(rexml/parsers/pullparser.rd)
#@include(rexml/parsers/sax2parser.rd)
#@include(rexml/parsers/streamparser.rd)
#@include(rexml/parsers/treeparser.rd)
#@include(rexml/parsers/ultralightparser.rd)
#@include(rexml/parsers/xpathparser.rd)
#@include(rexml/rexml.rd)
#@include(rexml/sax2listener.rd)
#@include(rexml/source.rd)
#@include(rexml/streamlistener.rd)
#@include(rexml/syncenumerator.rd)
#@include(rexml/text.rd)
#@include(rexml/validation/relaxng.rd)
#@include(rexml/validation/validation.rd)
#@include(rexml/validation/validationexception.rd)
#@include(rexml/xmldecl.rd)
#@include(rexml/xmltokens.rd)
#@include(rexml/xpath.rd)
