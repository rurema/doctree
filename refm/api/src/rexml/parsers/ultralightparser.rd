#@#require rexml/parsers/streamparser
#@#require rexml/parsers/baseparser

= class REXML::Parsers::UltraLightParser < Object
パース結果を配列で作られた木構造により返すパーサです。

=== ノードの表現
[[m:REXML::Parsers::UltraLightParser#parse]] が返す
XML の各ノードは配列で表現されます。
配列の最初の要素はシンボルでノードの種類を表わし、2番目以降の要素で
そのノードの情報を保持しています。
例えばテキストノードは [:text, テキスト文字列 ] という2要素の配列で
表現されます。XML 要素のように子ノードを持つ場合、
それらの子ノードもこの配列の要素として保持されます。

[[m:REXML::Parsers::UltraLightParser#parse]] の返り値となる
木のルートは特別で、ノードの種類を表すシンボルを持ちません。
XML宣言、DTD、ルート要素、テキストノードの配列です。例も確認してください。
木のルートの配列に含まれるテキストノードはあまり意味がないので
たいがいの場合には無視すべきでしょう。

各ノードは以下のような配列で表現されます。

: [:start_element, 親ノード, 要素名, 属性, *子ノード]
  XML要素。属性は { 属性名文字列 => 属性値文字列 } という [[c:Hash]]。
  子ノードの配列は node[4..-1] で得られる。
: [:text, 正規化文字列]
  テキストノード
: [:processing_instruction, ターゲット文字列, 内容文字列 | nil]
  XML処理命令(Processing Instruction, PI)
: [:comment ,コメント文字列]
  コメント
: [:start_doctype, 親ノード, ルート要素名, "SYSTEM" | "PUBLIC" | nil, システム識別子 | nil, 公開識別子 | nil, *子ノード]
  DTD。子ノードの配列は node[6..-1] で得られる。
: [:attlistdecl, 要素名, 属性名とデフォルト値, 宣言文字列]
  DTDの属性リスト宣言。属性名とデフォルト値 は { 属性名文字列 => デフォルト値文字列(なければnil) } という [[c:Hash]]
: [:elementdecl, 宣言文字列]
  DTDの要素宣言
: [:entitydecl, *パラメータ]
  DTDの実体宣言
: [:notationdecl, 記法名文字列, "PUBLIC" | "SYSTEM" | nil, 公開識別子文字列 | nil, URI文字列 | nil]
  DTDの記法宣言
#@# : entity 使われない
: [:cdata, テキスト文字列]
  cdata セクション
: [:xmldecl, バージョン文字列, エンコーディング文字列 | nil, standalone ("yes" | "no" | nil)]
  XML宣言 
: [:externalentity,エンティティ文字列]
  doctype内のパラメータ実体参照。

=== 例
以下の例は簡単な XML をパースし、その結果を返しています。[...]の部分は親
ノードを指しているので、pp の表示では省略されています。
  require 'rexml/parsers/ultralightparser'
  require 'pp'
  parser = REXML::Parsers::UltraLightParser.new(<<XML)
  <?xml version="1.0" encoding="UTF-8" ?>
  <root>
    <a n="1">xyz</a>
    <b m="2" />
  </root>
  XML
  pp parser.parse
  # >> [[:xmldecl, "1.0", "UTF-8", nil],
  # >>  [:text, "\n"],
  # >>  [:start_element,
  # >>   [...],
  # >>   "root",
  # >>   {},
  # >>   [:text, "\n  "],
  # >>   [:start_element, [...], "a", {"n"=>"1"}, [:text, "xyz"]],
  # >>   [:text, "\n  "],
  # >>   [:start_element, [...], "b", {"m"=>"2"}],
  # >>   [:text, "\n"]],
  # >>  [:text, "\n"]]

#@until 2.1.0
==== 注意
Ruby 2.1.0 以前に添付されている rexml の UltraLightParser は
doctype の処理にバグがあります。そのため doctype を持つ XML 文書には
使わないでください。
#@end

== Class Methods

--- new(stream) -> REXML::Parsers::UltraLightParser
パーサオブジェクトを返します。

@param stream 入力(文字列、IO、IO互換オブジェクト(StringIOなど))

== Instance Methods

#@# #@since 1.8.2
#@# --- add_listener(listener)
#@# #@todo
#@# #@end

--- rewind -> ()
[[m:REXML::Parsers::UltraLightParser.new]] で指定した stream を
rewind してもう一度パースできる状態にします。

--- parse -> Array
XML 文書のパース結果を配列による木で返します。

@raise REXML::ParseException XML文書のパースに失敗した場合に発生します
@raise REXML::UndefinedNamespaceException XML文書のパース中に、定義されていない名前空間
       が現れた場合に発生します

