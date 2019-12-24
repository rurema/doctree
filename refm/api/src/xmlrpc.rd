category Network

XML-RPC を扱うためのライブラリです。

#@since 2.4.0
このライブラリはbundled gem(gemファイルのみを同梱)です。詳しい内容は下
記のページを参照してください。

 * rubygems.org: [[url:https://rubygems.org/gems/xmlrpc]]
 * プロジェクトページ: [[url:https://github.com/ruby/xmlrpc]]
 * リファレンス: [[url:http://www.rubydoc.info/gems/xmlrpc]]
#@else
このページは xmlrpc ライブラリのまとめのページであり、require 'xmlrpc' を実行しても
エラーになることに注意して下さい。

=== Author and Copyright

Copyright (C) 2001-2004 by Michael Neumann

Released under the same term of license as Ruby.

=== Overview

XMLRPC is a lightweight protocol that enables remote procedure calls over
HTTP.  It is defined at http://www.xmlrpc.com.

XMLRPC allows you to create simple distributed computing solutions that span
computer languages.  Its distinctive feature is its simplicity compared to
other approaches like SOAP and CORBA.

The Ruby standard library package 'xmlrpc' enables you to create a server that
implements remote procedures and a client that calls them.  Very little code
is required to achieve either of these.

=== Example

Try the following code.  It calls a standard demonstration remote procedure.

  require 'xmlrpc/client'
  require 'pp'

  server = XMLRPC::Client.new2("http://xmlrpc-c.sourceforge.net/api/sample.php")
  result = server.call("sample.sumAndDifference", 5, 3)
  pp result

=== Documentation

See http://www.ntecs.de/projects/xmlrpc4r.  There is plenty of detail there to
use the client and implement a server.

=== Features of XMLRPC for Ruby

  * Extensions
    * Introspection
    * multiCall
    * optionally nil values and integers larger than 32 Bit

  * Server
    * Standalone XML-RPC server
    * CGI-based (works with FastCGI)
    * Apache mod_ruby server
    * WEBrick servlet

  * Client
    * synchronous/asynchronous calls
    * Basic HTTP-401 Authentification
    * HTTPS protocol (SSL)

  * Parsers
    * NQXML (NQXMLStreamParser, NQXMLTreeParser)
    * Expat (XMLStreamParser, XMLTreeParser)
    * REXML (REXMLStreamParser)
    * xml-scan (XMLScanStreamParser)
    * Fastest parser is Expat's XMLStreamParser!
 
  * General
    * possible to choose between XMLParser module (Expat wrapper) and REXML/NQXML (pure Ruby) parsers
    * Marshalling Ruby objects to Hashs and reconstruct them later from a Hash
    * SandStorm component architecture Client interface

=== Choosing a different XML Parser or XML Writer

The examples above all use the default parser (which is now since 1.8
REXMLStreamParser) and a default XML writer.  If you want to use a different
XML parser, then you have to call the <i>set_parser</i> method of
XMLRPC::Client instances or instances of subclasses of
XMLRPC::BasicServer or by editing xmlrpc/config.rb.

Client Example:
 
  require 'xmlrpc/client'
  # ...
  server = XMLRPC::Client.new( "xmlrpc-c.sourceforge.net", "/api/sample.php")
  server.set_parser(XMLRPC::XMLParser::XMLParser.new)
  # ...

Server Example:

  require 'xmlrpc/server'
  # ...
  s = XMLRPC::CGIServer.new
  s.set_parser(XMLRPC::XMLParser::XMLStreamParser.new)
  # ...
  
or:

  require 'xmlrpc/server'
  # ...
  server = XMLRPC::Server.new(8080)
  server.set_parser(XMLRPC::XMLParser::NQXMLParser.new)
  # ...


Note that XMLStreamParser is incredible faster (and uses less memory) than any
other parser and scales well for large documents. For example for a 0.5 MB XML
document with many tags, XMLStreamParser is ~350 (!) times faster than
NQXMLTreeParser and still ~18 times as fast as XMLTreeParser.

You can change the XML-writer by calling method <i>set_writer</i>.

=== 参考

  * [[url:http://www.linux.or.jp/JF/JFdocs/XML-RPC-HOWTO/index.html]]
  * [[url:http://www.linux.or.jp/JF/JFdocs/XML-RPC-HOWTO/xmlrpc-howto-ruby.html]]
  * [XML-RPC] [[url:http://www.xmlrpc.com/spec]]
  * [[url:https://magazine.rubyist.net/articles/0007/0007-BundledLibraries.html]]

=== 注意

このライブラリは 2.4.0 で bundled gem(gemファイルのみを同梱)になりました。
#@end
