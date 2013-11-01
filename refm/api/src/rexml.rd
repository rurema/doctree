category FileFormat

Pure Ruby の XML パーサです。
DOM スタイルと SAX スタイルの両方をカバーしています。

DOM スタイルの API を使うためには [[lib:rexml/document]] を使います。

SAX スタイルの API には、
  * [[lib:rexml/parsers/sax2parser]] 
  * [[lib:rexml/parsers/streamparser]] 
のいずれかを用います。

また、それ以外のパーサとして
  * [[lib:rexml/parsers/pullparser]]
  * [[lib:rexml/parsers/ultralightparser]]
などもあります。

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

#@include(rexml/parseexception.rd)
#@include(rexml/rexml.rd)
#@include(rexml/undefinednamespaceexception.rd)
