= class REXML::Document < REXML::Element

XMLの完全な文書(ドキュメント)を表すクラス。

XML処理命令(Processing Instruction, PI)、
DTD(文書型定義、Document Type Definition)、
などを含んでいます。
ドキュメントは直下の子ノードをただ一つ持っています(rootと呼び、
[[m:REXML::Document#root]] でアクセスできます)。
2つ目の要素を([[m:REXML::Element#add_element]]などで)追加しようとすると
例外([[c:RuntimeError]])が発生します。

== Class Methods

--- new(source = nil, context = {}) -> REXML::Document
Document オブジェクトを生成します。

source には [[c:String]]、[[c:IO]]、[[c:REXML::Document]] のいずかが
指定できます。 REXML::Document を指定すると
コンテキストと要素、属性が複製されます。
文字列の場合はそれを XML と見なしてパースします。
IOの場合は、XML文書を読み出してパースします。

context で「コンテキスト」を指定します。テキストノードの空白や
特殊文字の取り扱いを [[c:Hash]] で指定します。
#@include(context)

@param source XML文書(文字列, IO)もしくは REXML::Document オブジェクト
@param context コンテキスト

--- parse_stream(source, listener)
#@todo

== Instance Methods

--- node_type -> Symbol
シンボル :document を返します。

--- clone -> REXML::Document
self を複製します。

[[m:REXML::Document.new]](self) と同じです。

--- expanded_name -> String
--- name -> String

""(空文字列)を返します。

XMLの仕様上、このオブジェクトはexpanded name名前を持ちえません。

--- add(child) -> ()
--- <<(child) -> ()
子ノードを追加します。

追加できるものは
  * XML宣言([[c:REXML::XMLDecl]])
  * DTD([[c:REXML::DocType]])
  * ルート要素
のいずれかです。

#@# REXML::Element#add_element と同じ、ただしルート要素が2つになると例外を発生させる
#@# 
#@# --- add_element(arg = nil, arg2 = nil)
#@# #@todo
#@# 

--- root -> REXML::Element | nil
文書のルート要素を返します。

文書がルート要素を持たない場合は nil を返します。

--- doctype -> REXML::DocType | nil
文書の DTD を返します。

文書が DTD を持たない場合は nil を返します。

--- xml_decl -> REXML::XMLDecl | nil
文書の XML 宣言を返します。

文書が XML 宣言を持たない場合は nil を返します。

--- version -> String
XML 宣言に含まれている XML 文書のバージョンを返します。

文書が XML 宣言を持たない場合はデフォルトの値
([[m:REXML::XMLDecl.default]]で宣言されているもの)を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <e />
  EOS
  doc.version # => "1.0"

--- encoding -> String
XML 宣言に含まれている XML 文書のエンコーディングを返します。

文書が XML 宣言を持たない場合はデフォルトの値
([[m:REXML::XMLDecl.default]]で宣言されているもの)を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <e />
  EOS
  doc.encoding # => "UTF-8"

--- stand_alone? -> String
XML 宣言の standalone の値を文字列で返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <e />
  EOS
  doc.stand_alone? # => "yes"

#@until 2.0.0
--- write(output = $stdout, indent = -1, transitive = false, ie_hack = false) -> ()
#@else
--- write(output = $stdout, indent = -1, transitive = false, ie_hack = false, encoding=nil) -> ()
--- write(output: $stdout, indent: -1, transitive: false, ie_hack: false, encoding: nil) -> ()
#@end

output に XML 文書を出力します。

XML宣言、DTD、処理命令を(もしあるならば)含む文書を出力します。

注意すべき点として、
元の XML 文書が XML宣言を含んでいなくとも
出力される XML はデフォルトの XML 宣言を含んでいるべきであるが、
REXML は明示しない限り(つまりXML宣言を [[m:REXML::Document#add]] で
追加しない限り)
それをしない、ということである。XML-RPCのような利用法では
ネットワークバンドを少しでも節約する必要があるためである。

#@since 2.0.0
2.0.0以降ではキーワード引数による引数指定が可能です。
#@end

@param output 出力先([[c:IO]] のように << で書き込めるオブジェクト)
@param indent インデントのスペースの数(-1 だとインデントしない)
@param transitive XMLではインデントのスペースでDOMが変化してしまう場合がある。
       これに真を渡すと、XMLのDOMに余計な要素が加わらないように
       空白の出力を適当に抑制するようになる
@param ie_hack IEはバージョンによってはXMLをちゃんと解釈できないので、
       それに対応したXMLを出力するかどうかを真偽値で指定する

== Constants

--- DECLARATION -> REXML::XMLDecl
この定数は deprecated です。[[m:REXML::XMLDecl.default]] を
代わりに使ってください。

デフォルトとして使えるXML宣言オブジェクト。


