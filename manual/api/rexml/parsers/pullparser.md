---
type: library
---
プル方式の XML パーサ。

[c:REXML::Parsers::StreamParser] はパースした結果をコールバックによって
受動的に受け取りますが、このパーサは [m:REXML::Parsers::PullParser#pull]
によってパーサから結果をイベントという形で順に能動的に取り出します。
外部的にはこのクラスのオブジェクトはイベントのキューと見なせます。
pull はそのキューの先頭を取り出し、キューから取り除きます。

pull は [c:REXML::Parsers::PullEvent] オブジェクトを返します。
このオブジェクトの
[m:REXML::Parsers::PullEvent#event_type] で「開始タグ」「終了タグ」
といったイベントの種類を取得します。
[m:REXML::Parsers::PullEvent#\[\]] でそのイベントのパラメータ
(例えば開始タグなら要素名と属性)を得ることができます。

### イベントの種類とパラメータ {#event_type}

[m:REXML::Parsers::PullEvent#event_type] で得られるイベントの種類の
シンボルを列挙しています。

これらのうちのいくつかは、
[m:REXML::Parsers::PullEvent#start_element?] などのメソッドで
判定することが可能です。

- **start_element (要素名, 属性)**:
  XML要素の開始タグ。属性は { 属性名文字列 => 属性値文字列 } という [c:Hash]
- **end_element (要素名)**:
  XML要素の終了タグ
- **text (正規化文字列, 非正規化文字列)**:
  テキストノード
- **processing_instruction (ターゲット文字列, 内容文字列 | nil)**:
  XML処理命令(Processing Instruction, PI)
- **comment (コメント文字列)**:
  コメント
- **start_doctype (ルート要素名, "SYSTEM" | "PUBLIC" | nil, システム識別子 | nil, 公開識別子 | nil)**:
  DTD 開始。判定は [m:REXML::Parsers::PullEvent#doctype?] メソッドで、
  start_doctype? ではない
- **`end_doctype ()`**:
  DTD 終了
- **attlistdecl (要素名, 属性名とデフォルト値, 宣言文字列)**:
  DTDの属性リスト宣言。属性名とデフォルト値 は { 属性名文字列 => デフォルト値文字列(なければnil) } という [c:Hash]
- **elementdecl (宣言文字列)**:
  DTDの要素宣言
- **`entitydecl`**:
  DTDの実体宣言
- **notationdecl (記法名文字列, "PUBLIC" | "SYSTEM" | nil, 公開識別子文字列 | nil, URI文字列 | nil)**:
  DTDの記法宣言
#@# : entity 使われない
- **cdata (テキスト文字列)**:
  cdata セクション
- **xmldecl (バージョン文字列, エンコーディング文字列 | nil, standalone ("yes" | "no" | nil))**:
  XML宣言
- **externalentity (エンティティ文字列)**:
  doctype内のパラメータ実体参照。

  ```ruby
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
  ```

