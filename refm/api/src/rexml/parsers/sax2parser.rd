#@#require rexml/parsers/baseparaser
#@#require rexml/parseexception
#@#require rexml/namespace
#@#require rexml/text

= class REXML::Parsers::SAX2Parser < Object

SAX2 と同等の API を持つストリーム式の XML パーサです。

[[c:REXML::Parsers::StreamParser]] のパーサよりは
高機能です。

==== 例

  require 'rexml/parsers/sax2parser'
  require 'rexml/sax2listener'
  
  parser = REXML::Parsers::SAX2Parser.new(<<XML)
  <root n="0">
    <a n="1">111</a>
    <b n="2">222</b>
    <a n="3">333</a>
  </root>
  XML
  
  elements = []
  parser.listen(:start_element){|uri, localname, qname, attrs|
    elements << [qname, attrs]
  }
  as = []
  parser.listen(:start_element, ["a"]){|uri, localname, qname, attrs|
    as << [qname, attrs]
  }
  texts = []
  parser.listen(:characters, ["a"]){|c| texts << c }
  parser.parse
  elements # => [["root", {"n"=>"0"}], ["a", {"n"=>"1"}], ["b", {"n"=>"2"}], ["a", {"n"=>"3"}]]
  as # => [["a", {"n"=>"1"}], ["a", {"n"=>"3"}]]
  texts # => ["111", "333"]

==== 仕様確認サンプル
  require 'rexml/parsers/sax2parser'
  require 'rexml/sax2listener'
  
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
  <root xmlns="http://example.org/default"
        xmlns:foo="http://example.org/foo"
        xmlns:bar="http://example.org/bar"><![CDATA[cdata is here]]>
    <a foo:att='1' bar:att='2' att='&lt;'>
    <bar:b />
    </a>
    &amp;&amp; <!-- comment here--> &bar;
  </root>
  EOS
  
  class Listener
    #include REXML::SAX2Listener
    def method_missing(name, *args)
      p [name, *args]
    end
    def respond_to_missing?(name, include_private)
      name != :call
    end
  end
  
  parser = REXML::Parsers::SAX2Parser.new(xml)
  parser.listen(Listener.new)
  parser.parse
  # >> [:start_document]
  # >> [:xmldecl, "1.0", "UTF-8", nil]
  # >> [:progress, 39]
  # >> [:characters, "\n"]
  # >> [:progress, 91]
  # >> [:processing_instruction, "xml-stylesheet", " type=\"text/css\" href=\"style.css\""]
  # >> [:progress, 91]
  # >> [:characters, "\n"]
  # >> [:progress, 144]
  # >> [:doctype, "root", "SYSTEM", "foo", nil]
  # >> [:progress, 144]
  # >> [:elementdecl, "<!ELEMENT root (a+)"]
  # >> [:progress, 144]
  # >> [:elementdecl, "<!ELEMENT a"]
  # >> [:progress, 159]
  # >> [:entitydecl, "bar", "barbarbarbar"]
  # >> [:progress, 190]
  # >> [:attlistdecl, "a", {"att"=>nil, "xyz"=>"foobar"}, " \n  <!ATTLIST a att CDATA #REQUIRED xyz CDATA \"foobar\">"]
  # >> [:progress, 245]
  # >> [:notationdecl, "foobar", "SYSTEM", nil, "http://example.org/foobar.dtd"]
  # >> [:progress, 683]
  # >> [:entitydecl, "HTMLsymbol", "PUBLIC", "-//W3C//ENTITIES Symbols for XHTML//EN", "xhtml-symbol.ent", "%"]
  # >> [:progress, 683]
  # >> [:progress, 683]
  # >> [:progress, 683]
  # >> [:characters, "\n"]
  # >> [:progress, 683]
  # >> [:start_prefix_mapping, nil, "http://example.org/default"]
  # >> [:start_prefix_mapping, "foo", "http://example.org/foo"]
  # >> [:start_prefix_mapping, "bar", "http://example.org/bar"]
  # >> [:start_element, "http://example.org/default", "root", "root", {"xmlns"=>"http://example.org/default", "xmlns:foo"=>"http://example.org/foo", "xmlns:bar"=>"http://example.org/bar"}]
  # >> [:progress, 683]
  # >> [:cdata, "cdata is here"]
  # >> [:progress, 683]
  # >> [:characters, "\n  "]
  # >> [:progress, 683]
  # >> [:start_element, "http://example.org/default", "a", "a", {"foo:att"=>"1", "bar:att"=>"2", "att"=>"&lt;"}]
  # >> [:progress, 683]
  # >> [:characters, "\n  "]
  # >> [:progress, 683]
  # >> [:start_element, "http://example.org/bar", "b", "bar:b", {}]
  # >> [:progress, 683]
  # >> [:end_element, "http://example.org/bar", "b", "bar:b"]
  # >> [:progress, 683]
  # >> [:characters, "\n  "]
  # >> [:progress, 683]
  # >> [:end_element, "http://example.org/default", "a", "a"]
  # >> [:progress, 683]
  # >> [:characters, "\n  &amp;&amp; "]
  # >> [:progress, 683]
  # >> [:comment, " comment here"]
  # >> [:progress, 683]
  # >> [:characters, " barbarbarbar\n"]
  # >> [:progress, 683]
  # >> [:end_element, "http://example.org/default", "root", "root"]
  # >> [:end_prefix_mapping, nil]
  # >> [:end_prefix_mapping, "foo"]
  # >> [:end_prefix_mapping, "bar"]
  # >> [:progress, 683]
  # >> [:characters, "\n"]
  # >> [:progress, 683]
  # >> [:end_document]


== Class Methods

--- new(source) -> REXML::Parsers::SAX2Parser
SAX2 パーサオブジェクトを生成します。

@param source 入力(文字列、IO、IO互換オブジェクト(StringIOなど))

== Instance Methods

#@# #@since 1.8.2
#@# --- add_listener(listener)
#@# #@todo
#@# #@end

--- listen(sym, ary) { ... } -> ()
--- listen(sym) { ... } -> ()
--- listen(ary, listener) -> ()
--- listen(ary) { ... } -> ()
--- listen(listener) -> ()

コールバックをパーサに登録します。

引数の種類やブロックの有無でどのような場合に何がコールバックされかが
変わります。

ブロックを指定した場合はそのブロックがコールバックされます。
ブロックを指定しない場合は [[c:REXML::SAX2Listener]] を include した
クラスのオブジェクトを指定します。

sym は以下のシンボルが指定でき、どの場合にコールバックが呼び出されるかを
指定します。どのような場合にどのような引数でコールバックが呼び出されるか
については、
[[c:REXML::SAX2Listener]] の対応するメソッドで詳しく説明されていますので
そちらを参照してください。

  * :start_document 
    (XML文書開始, [[m:REXML::SAX2Listener#start_document]])
  * :end_document 
    (XML文書終了, [[m:REXML::SAX2Listener#end_document]])
  * :start_element 
    (要素開始, [[m:REXML::SAX2Listener#start_element]])
  * :end_element 
    (要素終了, [[m:REXML::SAX2Listener#end_element]])
  * :start_prefix_mapping 
    (名前空間接頭辞導入, [[m:REXML::SAX2Listener#start_prefix_mapping]])
  * :end_prefix_mapping 
    (名前空間接頭辞適用終了, [[m:REXML::SAX2Listener#end_prefix_mapping]])
  * :characters (文字データ, [[m:REXML::SAX2Listener#characters]])
  * :processing_instruction 
    (XML 処理命令 [[m:REXML::SAX2Listener#processing_instruction]])
  * :doctype 
    (DTD, [[m:REXML::SAX2Listener#doctype]])
  * :attlistdecl 
    (DTDの属性リスト宣言, [[m:REXML::SAX2Listener#attlistdecl]])
  * :entitydecl 
    (DTDの実体宣言, [[m:REXML::SAX2Listener#entitydecl]])
  * :notationdecl 
    (DTDの記法宣言, [[m:REXML::SAX2Listener#notationdecl]])
  * :cdata 
    (CDATA セクション, [[m:REXML::SAX2Listener#cdata]])
  * :xmldecl 
    (XML 宣言, [[m:REXML::SAX2Listener#xmldecl]])
  * :comment 
    (コメント, [[m:REXML::SAX2Listener#comment]])
  * :progress 
    (入力を読み進める, [[m:REXML::SAX2Listener#progress]])


ary には配列を指定し、要素名によるコールバック呼び出し条件を指定します。
配列の要素としては、文字列か正規表現が指定できます。
start_element, end_element に関しては、指定した名前を持つ
要素の開始時と終了時にのみコールバックが呼び出されるようになります。
start_prefix_mapping, end_prefix_mapping では、その名前空間が導入された
要素の要素名、つまり xmlns:foo="bar" という属性を持つ
要素の名前でフィルタリングされるようになります。
それ以外(character, cdataなど)では、指定した名前を要素として持つ要素の直下のみ
コールバックが呼び出されます。
フィルタリングに使われる名前は QName、つまり prefix を含む文字列です。

@param sym イベント名(シンボル)
@param ary 要素名によるコールバック呼び出し条件の指定(文字列もしくは正規表現の配列)
@param listener コールバックオブジェクト

==== 例
  # CDATAセクションに出会った場合にブロックが呼び出される。
  parser.listen(:cdata){|data| ... }

  # h1, h2 という要素名を持つ要素が開始した場合にブロックが呼び出される
  parser.listen(:start_element, ["h1", "h2"]){|uri, localname, qname, attrs|
    ...
  }

  # /\Ah[1234]\z/ という正規表現にマッチする要素(h1, .. h4)の直下の
  # 文字データに出会った場合に呼び出される
  parser.listen(:characters, [/\Ah[1234]\z/]){|data|
    ...
  }

#@#   require 'rexml/parsers/sax2parser'
#@#   parser = REXML::Parsers::SAX2Parser.new(<<XML)
#@#   <root>
#@#     <a xmlns:foo="foo"><b xmlns:bar="bar"> </b></a>
#@#     <a></a>
#@#   </root>
#@#   XML
#@#   # "a" という要素名を持つ要素で新たな名前空間が導入された場合に
#@#   # ブロックが呼び出される
#@#   parser.listen(:start_prefix_mapping, ["a"]){|prefix, uri| p prefix}
#@#   parser.parse
#@#   # >> "foo"

--- deafen(listener) -> ()
#@# --- deafen { ... } -> ()

[[m:REXML::Parsers::SAX2Parser#listen]] で指定した listener を
取り除きます。

@param listener 取り除く listener 


--- parse -> ()
[[m:REXML::Parsers::SAX2Parser.new]] で指定した XML を
パースし、その結果によって [[m:REXML::Parsers::SAX2Parser#listen]] で
指定したコールバックを呼び出します。

#@# #@since 1.8.6
#@# --- source
#@# #@todo
#@# #@end
