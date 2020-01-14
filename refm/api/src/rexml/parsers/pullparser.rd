
プル方式の XML パーサ。

[[c:REXML::Parsers::StreamParser]] はパースした結果をコールバックによって
受動的に受け取りますが、このパーサは [[m:REXML::Parsers::PullParser#pull]] 
によってパーサから結果をイベントという形で順に能動的に取り出します。
外部的にはこのクラスのオブジェクトはイベントのキューと見なせます。
pull はそのキューの先頭を取り出し、キューから取り除きます。

pull は [[c:REXML::Parsers::PullEvent]] オブジェクトを返します。
このオブジェクトの
[[m:REXML::Parsers::PullEvent#event_type]] で「開始タグ」「終了タグ」
といったイベントの種類を取得します。
[[m:REXML::Parsers::PullEvent#[] ]] でそのイベントのパラメータ
(例えば開始タグなら要素名と属性)を得ることができます。


===[a:event_type] イベントの種類とパラメータ
[[m:REXML::Parsers::PullEvent#event_type]] で得られるイベントの種類の
シンボルを列挙しています。

これらのうちのいくつかは、
[[m:REXML::Parsers::PullEvent#start_element?]] などのメソッドで
判定することが可能です。

: start_element (要素名, 属性)
  XML要素の開始タグ。属性は { 属性名文字列 => 属性値文字列 } という [[c:Hash]]
: end_element (要素名)
  XML要素の終了タグ
: text (正規化文字列, 非正規化文字列)
  テキストノード
: processing_instruction (ターゲット文字列, 内容文字列 | nil)
  XML処理命令(Processing Instruction, PI)
: comment (コメント文字列)
  コメント
: start_doctype (ルート要素名, "SYSTEM" | "PUBLIC" | nil, システム識別子 | nil, 公開識別子 | nil)
  DTD 開始。判定は [[m:REXML::Parsers::PullEvent#doctype?]] メソッドで、
  start_doctype? ではない
: end_doctype ()
  DTD 終了
: attlistdecl (要素名, 属性名とデフォルト値, 宣言文字列)
  DTDの属性リスト宣言。属性名とデフォルト値 は { 属性名文字列 => デフォルト値文字列(なければnil) } という [[c:Hash]]
: elementdecl (宣言文字列)
  DTDの要素宣言
: entitydecl 
  DTDの実体宣言
: notationdecl (記法名文字列, "PUBLIC" | "SYSTEM" | nil, 公開識別子文字列 | nil, URI文字列 | nil)
  DTDの記法宣言
#@# : entity 使われない
: cdata (テキスト文字列)
  cdata セクション
: xmldecl (バージョン文字列, エンコーディング文字列 | nil, standalone ("yes" | "no" | nil))
  XML宣言 
: externalentity (エンティティ文字列)
  doctype内のパラメータ実体参照。
  
=== 例
  require 'rexml/parsers/pullparser'
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
  
  parser = REXML::Parsers::PullParser.new(xml)
  while parser.has_next?
    p parser.pull
  end
  # >> xmldecl: ["1.0", "UTF-8", nil]
  # >> text: ["\n", "\n"]
  # >> processing_instruction: ["xml-stylesheet", " type=\"text/css\" href=\"style.css\""]
  # >> text: ["\n", "\n"]
  # >> start_doctype: ["root", "SYSTEM", "foo", nil]
  # >> elementdecl: ["<!ELEMENT root (a+)"]
  # >> elementdecl: ["<!ELEMENT a"]
  # >> entitydecl: ["bar", "barbarbarbar"]
  # >> attlistdecl: ["a", {"att"=>nil, "xyz"=>"foobar"}, " \n  <!ATTLIST a att CDATA #REQUIRED xyz CDATA \"foobar\">"]
  # >> notationdecl: ["foobar", "SYSTEM", nil, "http://example.org/foobar.dtd"]
  # >> entitydecl: ["HTMLsymbol", "PUBLIC", "-//W3C//ENTITIES Symbols for XHTML//EN", "xhtml-symbol.ent", "%"]
  # >> externalentity: ["%HTMLsymbol;"]
  # >> end_doctype: []
  # >> text: ["\n", "\n"]
  # >> start_element: ["root", {"xmlns:foo"=>"http://example.org/foo", "xmlns:bar"=>"http://example.org/bar"}]
  # >> cdata: ["cdata is here"]
  # >> text: ["\n  ", "\n  "]
  # >> start_element: ["a", {"foo:att"=>"1", "bar:att"=>"2", "att"=>"&lt;"}]
  # >> end_element: ["a"]
  # >> text: ["\n  &amp;&amp; ", "\n  && "]
  # >> comment: [" comment here"]
  # >> text: [" &bar;\n", " barbarbarbar\n"]
  # >> end_element: ["root"]
  # >> text: ["\n", "\n"]

= class REXML::Parsers::PullParser < Object
extend Forwardable
include REXML::XMLTokens

プル方式の XML パーサクラス。
    
== Class Methods

--- new(stream) -> REXML::Parsers::PullParser
新たな PullParser オブジェクトを生成して返します。

@param source 入力(文字列、IO、IO互換オブジェクト(StringIOなど))

== Instance Methods

--- has_next? -> bool
未処理のイベントが残っている場合に真を返します。

@see [[m:REXML::Parsers::PullParser#empty?]]

#@# --- entity
#@# #@todo

--- empty? -> bool
未処理のイベントが残っていない場合に真を返します。

@see [[m:REXML::Parsers::PullParser#has_next?]]

#@# --- source
#@# #@todo

#@# 使い道がない
#@# --- add_listener(listener)
#@# #@todo


--- each {|event| ... } -> ()

XMLをパースし、得られたイベント列を引数として順にブロックを呼び出します。

@raise REXML::ParseException XML文書のパースに失敗した場合に発生します
@raise REXML::UndefinedNamespaceException XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

--- peek(depth = 0) -> REXML::Parsers::PullEvent | nil
イベントキューの先頭から depth 番目のイベントを取り出します。

一番先頭のイベントは 0 で表します。

このメソッドでは列そのものの状態は変化しません。

先頭から depth 番目のイベントが存在しない(XML文書の末尾の
さらに先を見ようとした場合)は nil を返します。

@param depth 先頭から depth 番目のイベントを取り出します

@raise REXML::ParseException XML文書のパースに失敗した場合に発生します
@raise REXML::UndefinedNamespaceException XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

--- pull -> REXML::Parsers::PullEvent
イベントキューの先頭のイベントを取り出し、キューからそれを取り除きます。

@raise REXML::ParseException XML文書のパースに失敗した場合に発生します
@raise REXML::UndefinedNamespaceException XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

--- unshift(token) -> ()
イベントキューの先頭に token を追加します。

@param token 先頭に追加するイベント([[c:REXML::Parsers::PullEvent]] オブジェクト)


= class REXML::Parsers::PullEvent < Object
[[c:REXML::Parsers::PullParser]] で使われるパース結果を表すイベントクラス。

[[m:REXML::Parsers::PullParser#pull]] および
[[m:REXML::Parsers::PullParser#peek]] がこのクラスのオブジェクトを返します。

== Class Methods

#@# Called by PullParser, Users should not use this method
#@# --- new(arg)
#@# #@todo

== Instance Methods

--- [](nth) -> object
#@# --- [](range) -> [object]
--- [](start, len) -> [object]
イベントのパラメータを取り出します。

[[m:Array#[] ]] と同様の引数を取ります。

@param nth nth番目のイベントパラメータを取り出します
#@# @param range
@param start start番目から len 個のイベントを取り出します
@param len start番目から len 個のイベントを取り出します

--- event_type -> Symbol
イベントの種類をシンボルで返します。

詳しくは [[ref:c:REXML::Parsers::PullParser#event_type]] を参照してください。

--- start_element? -> bool
XML要素の開始タグなら真を返します。


--- end_element? -> bool
XML要素の終了タグなら真を返します。

--- text? -> bool
テキストノードなら真を返します。

--- instruction? -> bool
XML処理命令なら真を返します。


--- comment? -> bool
コメントノードなら真を返します。


--- doctype? -> bool
DTD 開始なら真を返します。

--- attlistdecl? -> bool
DTDの属性リスト宣言なら真を返します。

--- elementdecl? -> bool
DTDの要素宣言なら真を返します。

--- entitydecl? -> bool
DTDの実体宣言なら真を返します。

--- notationdecl? -> bool
DTDの記法宣言なら真を返します。

#@# --- entity? -> bool
#@# deprecated, always returns false
#@# #@todo

--- cdata? -> bool
cdata セクションなら真を返します。

--- xmldecl? -> bool
XML宣言なら真を返します。

#@# --- error? -> false
#@# deprecated, always returns false

#@# --- inspect

