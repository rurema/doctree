
ストリーム式の XML パーサ。

rexml の XML パーサの中では高速ですが、機能は限定的です。
もう少し高機能なストリーム式パーサが必要な場合は 
[[c:REXML::Parsers::SAX2Parser]] を用いてください。

パーサからはコールバックによってパースした情報を受け取ります。
[[c:REXML::StreamListener]] を include し、
必要なメソッドをオーバーライドしたクラスのオブジェクトを
コールバックオブジェクトとして [[m:REXML::Parsers::StreamParser.new]]
に渡します。

[[m:REXML::Parsers::StreamParser#parse]] を呼び出すと
パースが開始しその結果によってコールバックが呼び出されます。

コールバックされるメソッドは [[c:REXML::StreamListener]] になにもしない
メソッドとして定義されています。どのようなコールバックがあるかは
そちらを参照してください。

パーサはXML文書の各構成要素を前から順に処理し、
その順にコールバックメソッドを呼び出します。順が前後することはありません。

====[a:example] StreamParserの例

この例では tag_start と text をオーバーライドして
開始タグとテキストの情報を受け取れるようにしています。
空白や改行もテキストであることに注意してください。
  require 'rexml/parsers/baseparser'
  require 'rexml/parsers/streamparser'
  require 'rexml/streamlistener'
  class Listener
    include REXML::StreamListener
    def initialize
      @events = []
    end
    
    def text(text)
      @events << "text[#{text}]"
    end
    
    def tag_start(name, attrs)
      @events << "tag_start[#{name}]"
    end
    
    attr_reader :events
  end
  
  xml = <<EOS
  <members>
    <member name="apple" color="red">
      <comment>comment here</comment>
    </member>
    <member name="banana" color="yellow"/>
  </members>
  EOS
  listener = Listener.new
  REXML::Parsers::StreamParser.new(xml, listener).parse
  listener.events
  # => ["tag_start[members]",
  #     "text[\n  ]",
  #     "tag_start[member]",
  #     "text[\n    ]",
  #     "tag_start[comment]",
  #     "text[comment here]",
  #     "text[\n  ]",
  #     "text[\n  ]",
  #     "tag_start[member]",
  #     "text[\n]",
  #     "text[\n]"]

==== コールバック仕様確認サンプル
以下の例では様々なXMLの構成要素を含むXML文書を
StreamParser で処理したときに、どのコールバックメソッドがどのような
引数で呼び出されるかを示すためのサンプルです。
実体参照は定義済みのものを除いては変換処理されていないことなどが
わかります。
  require 'rexml/parsers/baseparser'
  require 'rexml/parsers/streamparser'
  require 'rexml/streamlistener'
  
  xml = <<EOS
  <?xml version="1.0" encoding="UTF-8" ?>
  <?xml-stylesheet type="text/css" href="style.css"?>
  <!DOCTYPE root SYSTEM "foo" [
    <!ELEMENT root (a+)>
    <!ELEMENT a>
    <!ENTITY bar "barbarbarbar"> 
    <!ATTLIST a att CDATA #REQUIRED xyz CDATA "foobar">
    <!NOTATION foobar SYSTEM "http://example.org/foobar.dtd">
    <!ENTITY % HTMLsymbol PUBLIC
       "-//W3C//ENTITIES Symbols for XHTML//EN"
       "xhtml-symbol.ent">
    %HTMLsymbol;
  ]>
  <root xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar"><![CDATA[cdata is here]]>
    <a foo:att='1' bar:att='2' att='&lt;'/>
    &amp;&amp; <!-- comment here--> &bar;
  </root>
  EOS
  
  class Listener
    def method_missing(name, *args)
      p [name, *args]
    end
    def respond_to_missing?(sym, include_private)
      true
    end
  end
  
  REXML::Parsers::StreamParser.new(xml, Listener.new).parse
  # >> [:xmldecl, "1.0", "UTF-8", nil]
  # >> [:text, "\n"]
  # >> [:instruction, "xml-stylesheet", " type=\"text/css\" href=\"style.css\""]
  # >> [:text, "\n"]
  # >> [:doctype, "root", "SYSTEM", "foo", nil]
  # >> [:elementdecl, "<!ELEMENT root (a+)"]
  # >> [:elementdecl, "<!ELEMENT a"]
  # >> [:entitydecl, ["bar", "barbarbarbar"]]
  # >> [:attlistdecl, "a", {"att"=>nil, "xyz"=>"foobar"}, " \n  <!ATTLIST a att CDATA #REQUIRED xyz CDATA \"foobar\">"]
  # >> [:notationdecl, ["foobar", "SYSTEM", nil, "http://example.org/foobar.dtd"]]
  # >> [:entitydecl, ["HTMLsymbol", "PUBLIC", "-//W3C//ENTITIES Symbols for XHTML//EN", "xhtml-symbol.ent", "%"]]
  # >> [:doctype_end]
  # >> [:text, "\n"]
  # >> [:tag_start, "root", {"xmlns:foo"=>"http://example.org/foo", "xmlns:bar"=>"http://example.org/bar"}]
  # >> [:cdata, "cdata is here"]
  # >> [:text, "\n  "]
  # >> [:tag_start, "a", {"foo:att"=>"1", "bar:att"=>"2", "att"=>"<"}]
  # >> [:tag_end, "a"]
  # >> [:text, "\n  && "]
  # >> [:comment, " comment here"]
  # >> [:text, " &bar;\n"]
  # >> [:tag_end, "root"]
  # >> [:text, "\n"]

= class REXML::Parsers::StreamParser < Object

ストリーム式の XML パーサクラス。

== Class Methods

--- new(source, listener) -> REXML::Parsers::StreamParser
ストリームパーサオブジェクトを生成します。

@param source 入力(文字列、IO、IO互換オブジェクト(StringIOなど))
@param listner コールバックオブジェクト

== Instance Methods

#@# #@since 1.8.2
#@# --- add_listener(listener) -> ()
#@# 
#@# #@end

--- parse -> ()
入力をパースします。

このメソッドの中からコールバックが呼び出されます。

@raise REXML::ParseException XML文書のパースに失敗した場合に発生します
@raise REXML::UndefinedNamespaceException XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します
