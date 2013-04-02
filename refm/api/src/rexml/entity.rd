= class REXML::Entity < REXML::Child
include REXML::XMLTokens

XML における実体(エンティティ、entity)の宣言(declaration)を表わすクラス。

DTD([[c:REXML::DocType]])内の実体宣言に対応するものです。

==== 例

  require 'rexml/document'
  
  doc = REXML::Document.new(<<EOS)
  <!DOCTYPE document [
  <!ENTITY f "foo bar baz">
  <!ENTITY x SYSTEM "x.txt">
  <!ENTITY y SYSTEM "y.png" NDATA PNG>
  <!ENTITY % z "zzz">
  <!ENTITY zz "%z;%z;&f;">
  ]>
  EOS
  
  entities = doc.doctype.entities
  # f は 内部実体名なので、external や ref は nil である
  p entities["f"].name # => "f"
  p entities["f"].value # => "foo bar baz"
  p entities["f"].external # => nil
  p entities["f"].ref # => nil
  
  # x は 外部実体名なので value が nil で、
  # external や ref が文字列を返してくる。
  # しかし解析対象実体(parsed entity)なので ndata は nil を返す
  p entities["x"].name # => "x"
  p entities["x"].value # => nil
  p entities["x"].external # => "SYSTEM"
  p entities["x"].ref # => "x.txt"
  p entities["x"].ndata # => nil
  
  # y は解析対象外実体(unparsed entity)なので ndata が記法名を返す
  p entities["y"].ndata # => "PNG"
  
  # zz は中にパラメータ実体参照と内部実体参照を含むので、
  # value, unnormalized, normalized がすべて異なる値を返す
  p entities["zz"].value # => "zzzzzz&f;"
  p entities["zz"].unnormalized # => "zzzzzzfoo bar baz"
  p entities["zz"].normalized # => "%z;%z;&f;"

== Class Methods

--- new(name, value, parent=nil, reference=false) -> REXML::Entity
--- new(array) -> REXML::Entity
新たな Entity オブジェクトを生成して返します。

name, value で実体の名前とその値を定義します。
parent はその entity オブジェクトが属するノードを渡します。
reference でその実体宣言がパラメータ実体(parameter entity)かどうかを指定します。

このコンストラクタでは単純な内部実体(internal entity)宣言のみを実現できます。

それ以外の内容を保持する Entity オブジェクトが欲しい場合は、
文書に適切な DTD を含めておいてそれを [[m:REXML::Document.new]] で
パースするようにしてください。

配列を使うほうは rexml のパーサが内部的に利用するため通常は利用しません。

@paran name 実体参照の名前
@param value 参照の値
@param parent 親ノード
@param reference パラメータ実体であるかどうかの真偽値
@param array 初期化のための配列

==== 例
「&gt;」「>」 の対応は以下のように実現されます。
  REXML::Entity.new("gt", ">")

--- matches?(string) -> bool
string が実体宣言の文法に従う文字列であれば真を返します。

@param string 判定対象の文字列

==== 例
  require 'rexml/document'
  
  p REXML::Entity.matches?('<!ENTITY s "seal">') # => true
  p REXML::Entity.matches?('<!ENTITY % s "seal">') # => true
  p REXML::Entity.matches?('<!ELEMENT br EMPTY >') # => false


== Instance Methods

--- name -> String
実体の名前を返します。

--- external -> String | nil
実体が外部実体(external entity)宣言である場合は 
"SYSTEM" もしくは "PUBLIC" という文字列を返します。

内部実体(internal entity)宣言である場合には nil を返します。

--- ref -> String | nil
外部実体(external entity)宣言の URI を返します。

内部実体宣言の場合は nil を返します。

--- ndata -> String | nil
解析対象外実体(unparsed entity)宣言である場合には
その記法名(notation name)を返します。

それ以外の場合は nil を返します。

--- pubid -> String | nil
公開識別子(public identifier)を用いた外部実体宣言の場合は、その公開識別子を
返します。

それ以外の場合は nil を返します。

--- unnormalized -> String | nil
非正規化された(unnormalized)実体の値を返します。

すなわち、self が属する DTD によってすべての実体参照(&ent; と %ent; の両方)
を展開した文字列を返します。

外部実体(external enitity)宣言の場合は nil を返します。

@see [[m:REXML::Entity#value]], [[m:REXML::Entity#normalized]]

--- normalized -> String | nil
正規化された(normalized)実体の値を返します。

すなわち、一切の実体参照を展開していない値を返します。

外部実体(external enitity)宣言の場合は nil を返します。

@see [[m:REXML::Entity#value]], [[m:REXML::Entity#unnormalized]]

--- write(out, indent = -1) -> ()
実体宣言を文字列化したものを out に書き込みます。

@param out 出力先の IO オブジェクト
@param indent 利用されません。deprecated なパラメータです
@see [[m:REXML::Entity#to_s]]


--- to_s -> String
実体宣言を文字列化したものを返します。

@see [[m:REXML::Entity#write]]

==== 例
  e = REXML::ENTITY.new("w", "wee");
  p e.to_s # => "<!ENTITY w \"wee\">"

--- value -> String | nil
実体の値を返します。

パラメータ実体参照(parameter entity)のみが展開され、
そうでない実体参照(general entity)は展開されて
いないような値が返されます。

外部実体(external enitity)宣言の場合は nil を返します。

@see [[m:REXML::Entity#unnormalized]], [[m:REXML::Entity#normalized]]

== Constants

#@# Internally used strings and regexps
#@# --- PUBIDCHAR
#@# #@todo
#@# 
#@# --- SYSTEMLITERAL
#@# #@todo
#@# 
#@# --- PUBIDLITERAL
#@# #@todo
#@# 
#@# --- EXTERNALID
#@# #@todo
#@# 
#@# --- NDATADECL
#@# #@todo
#@# 
#@# --- PEREFERENCE
#@# #@todo
#@# 
#@# --- ENTITYVALUE
#@# #@todo
#@# 
#@# --- PEDEF
#@# #@todo
#@# 
#@# --- ENTITYDEF
#@# #@todo
#@# 
#@# --- PEDECL
#@# #@todo
#@# 
#@# --- GEDECL
#@# #@todo
#@# 
#@# --- ENTITYDECL
#@# #@todo
#@# 
#@# --- PEREFERENCE_RE
#@# #@todo

= module REXML::EntityConst

XML の標準的な実体(エンテティ)を保持しているモジュールです。

== Constants

--- GT -> REXML::Entity
「&gt;」「>」というエンティティを表わすオブジェクト。

--- LT -> REXML::Entity
「&lt;」「<」というエンティティを表わすオブジェクト。

--- AMP -> REXML::Entity
「&amp;」「&」というエンティティを表わすオブジェクト。

--- QUOT -> REXML::Entity
「&quot;」「"」というエンティティを表わすオブジェクト。

--- APOS
「&apos;」「'」というエンティティを表わすオブジェクト。

