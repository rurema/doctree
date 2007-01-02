#@if (version >= "1.8.0")
#@# = REXML

[[unknown:執筆者募集]]

=== ライブラリ毎の詳細

  * DOMっぽいAPI
    * rexml/document
    * rexml/element
    * rexml/attribute
    * rexml/namespace
    * rexml/text(おまけでrexml/cdataも？)
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
    [[url:http:#/www.cozmixng.org/~kou/ruby/rexml/]]
    [[url:http:#/www.cozmixng.org/~kou/ruby/rexml/reference]]

#@include(rexml/attlistdecl.rd)
#@include(rexml/attribute.rd)
#@include(rexml/cdata.rd)
#@include(rexml/child.rd)
#@include(rexml/comment.rd)
#@include(rexml/doctype.rd)
#@include(rexml/dtd/attlistdecl.rd)
#@include(rexml/dtd/dtd.rd)
#@include(rexml/dtd/elementdecl.rd)
#@include(rexml/dtd/entitydecl.rd)
#@include(rexml/dtd/notationdecl.rd)
#@include(rexml/element.rd)
#@include(rexml/encoding.rd)
#@end
