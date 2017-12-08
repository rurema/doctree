= class REXML::DocType < REXML::Parent
include REXML::XMLTokens

XML の DTD(文書型定義、Document Type Definition)を表すクラスです。

rexml では DTD は積極的にはサポートされていません。
デフォルトの実体定義(gt, lt, amp, quot apos)の解決のため DTD は
ある程度はサポートされますが、スキーマの定義や検証をしたい場合は
XML schema や RELAX NG などを使ってください。

子ノード([[m:REXML::Parent#children]])として、
  * [[c:REXML::ElementDecl]]
  * [[c:REXML::ExternalEntity]]
  * [[c:REXML::Entity]]
  * [[c:REXML::NotationDecl]]
  * [[c:REXML::AttlistDecl]]
などを保持しています。
== Class Methods

--- new(source, parent = nil) -> REXML::DocType

DocType オブジェクトを生成します。

[[c:REXML::Source]] オブジェクトの場合は、Source オブジェクトが
保持しているDTDのテキストがパースされ、その内容によって DocType
オブジェクトが初期化されます。
  REXML::DocType.new(Source.new(<<EOS))
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  EOS
このインターフェースは deprecated です。

このメソッドは他のインターフェースもありますが、内部用なので使わないで
ください。

一般的にいって、XML 文書に含まれる DTD は [[m:REXML::Document.new]] などで
適切に解析され、[[m:REXML::Document#doctype]] で取得できます。
このメソッドを直接使う必要はありません。


== Instance Methods

--- name -> String
ルート要素名を返します。

  document = REXML::Document.new(<<EOS)
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  EOS
  doctype = document.doctype
  p doctype.name # => "html"

--- external_id -> String | nil
DTD が外部サブセットを用いている場合は "SYSTEM", "PUBLIC" の
いずれかの文字列を返します。

それ以外の場合は nil を返します。

  require 'rexml/document'
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  EOS
  doctype.name # => "html"
  doctype.external_id  # => "PUBLIC"
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE books [
    <!ELEMENT books (book+)>
    <!ELEMENT book (title,author)>
    <!ELEMENT title (#PCDATA)>
    <!ELEMENT author (#PCDATA)>
  ]>
  EOS
  doctype.name # => "books"
  doctype.external_id # => nil

--- entities -> { String => REXML::Entity }
DTD で宣言されている実体の集合を Hash で返します。

返される Hash は実体参照名をキーとし、対応する [[c:REXML::Entity]] オブジェクト
を値とするハッシュテーブルです。

これには、XML のデフォルトの実体(gt, lt, quot, apos)も含まれています。

=== 例
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE foo [
    <!ENTITY bar "barbarbarbar">
  ]>
  EOS

  p doctype.entities # => { "gt" => #<REXML::Entity: ...>, 
                     #      "lt" => #<REXML::Entity: ...>, ... }
  p doctype.entities["bar"].to_s # => "<!ENTITY bar \"barbarbarbar\">"
  p doctype.entities["gt"].to_s # => "<!ENTITY gt \">\">"


--- namespaces -> nil
nil を返します。
#@# 用途不明

--- node_type -> Symbol
[[c:Symbol]] :doctype を返します。


--- attributes_of(element) -> [REXML::Attribute]
DTD 内の属性リスト宣言で、 element という名前の要素に対し宣言されている
属性の名前とデフォルト値を REXML::Attribute の配列で返します。

名前とデフォルト値のペアは、各 Attribute オブジェクトの
[[m:REXML::Attribute#name]] と
[[m:REXML::Attribute#value]] で表現されます。

=== 例
  require 'rexml/document'
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE books [
  <!ELEMENT book (comment)>
  <!ELEMENT comment (#PCDATA)>
  <!ATTLIST book
            author CDATA #REQUIRED
            title CDATA #REQUIRED
            publisher CDATA "foobar publisher">
  ]>
  EOS
  
  p doctype.attributes_of("book")
  # => [author='', title='', publisher='foobar publisher'] 
  p doctype.attributes_of("book")[0].name # => "author"
  p doctype.attributes_of("book")[0].value # => ""

--- attribute_of(element, attribute) -> String | nil
DTD 内の属性リスト宣言で、 element という名前の要素の attribute という
名前の属性のデフォルト値を返します。

elementという名前の要素の属性値は宣言されていない、
elementという名前の要素にはattributeという名前の属性が宣言されていない、
もしくはデフォルト値が宣言されていない、のいずれかの場合は nil を返します。

@param element 要素名(文字列)
@param attribute 属性名(文字列)

=== 例
  require 'rexml/document'
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE books [
  <!ELEMENT book (comment)>
  <!ELEMENT comment (#PCDATA)>
  <!ATTLIST book
            author CDATA #REQUIRED
            title CDATA #REQUIRED
            publisher CDATA "foobar publisher">
  ]>
  EOS
  
  p doctype.attribute_of("book", "publisher") # => "foobar publisher"
  p doctype.attribute_of("bar", "foo") # => nil
  p doctype.attribute_of("book", "baz") # => nil
  p doctype.attribute_of("book", "title") # => nil

--- clone -> REXML::DocType
self の複製を返します。

external_id ([[m:REXML::DocType#external_id]]) と
名前([[m:REXML::DocType#name]]) のみ複製されるため、
結果として得られるオブジェクトはあまり有用ではないでしょう。


--- write(output, indent = 0, transitive = false, ie_hack = false) -> ()
output に DTD を出力します。

このメソッドは deprecated です。[[c:REXML::Formatter]] で
出力してください。

@param output 出力先の IO オブジェクト
@param indent インデントの深さ。指定しないでください。
@param transitive 無視されます。指定しないでください。
@param ie_hack 無視されます。指定しないでください。

=== 例
  require 'rexml/document'
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE books [
  <!ELEMENT book (comment)>
  <!ELEMENT comment (#PCDATA)>
  <!ATTLIST book
            author CDATA #REQUIRED
            title CDATA #REQUIRED
            publisher CDATA "foobar publisher">
  <!ENTITY p "foobar publisher">
  <!ENTITY % q "quzz">
  ]>
  EOS
  
  doctype.write(STDOUT)
  # =>
  # <!DOCTYPE books [
  # <!ELEMENT book (comment)>
  # ....

#@since 1.8.2
--- context -> { Symbol => object }
DTD が属する文書の「コンテキスト」を返します。

具体的には親ノードである [[c:REXML::Document]] オブジェクトの
[[m:REXML::Element#context]] を返します。

コンテキストの具体的な内容については [[m:REXML::Element#context]] を
参照してください。

#@end

--- entity(name) -> String | nil
name という実体参照名を持つ実体を文字列で返します。

返される文字列は非正規化([[m:REXML::Entity#unnormalized]] 参照)
された文字列が返されます。

name という名前を持つ実体が存在しない場合には nil を返します。

@param name 実体参照名(文字列)

=== 例
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE foo [
    <!ENTITY bar "barbarbarbar">
  ]>
  EOS
  p doctype.entity("bar") # => "barbarbar"
  p doctype.entity("foo") # => nil

--- add(child) -> ()
child を子ノード列の最後に追加します。

[[m:REXML::Parent#add]] を内部で呼び出します。
また、[[m:REXML::DocType#entities]] を更新します。

@param child 追加するノード

#@since 1.8.5
--- public -> String | nil
DTD の公開識別子を返します。

DTD が公開識別子による外部サブセットを含んでいない場合は nil を返します。

  require 'rexml/document'
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  EOS
  doctype.system # => "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  doctype.public  # => "-//W3C//DTD XHTML 1.0 Strict//EN"
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE root SYSTEM "foobar">
  EOS
  doctype.system # => "foobar"
  doctype.public  # => nil

--- system -> String | nil
DTD のシステム識別子を返します。

DTD が外部サブセットを含んでいない場合は nil を返します。

  require 'rexml/document'
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
           "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
  EOS
  doctype.system # => "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  doctype.public  # => "-//W3C//DTD XHTML 1.0 Strict//EN"
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE root SYSTEM "foobar">
  EOS
  doctype.system # => "foobar"
  doctype.public  # => nil

--- notations -> [REXML::NotationDecl]
DTD に含まれている記法宣言 ([[c:REXML::NotationDecl]]) を
配列で返します。

--- notation(name) -> REXML::NotationDecl | nil
DTD に含まれている記法宣言 ([[c:REXML::NotationDecl]]) で
name という名前を持つものを返します。

name という名前を持つ記法宣言が存在しない場合は nil を返します。

@param name 検索する記法名

#@end

== Constants

#@# --- START
#@# #@todo
#@# 
#@# --- STOP
#@# #@todo
#@# 
#@# --- SYSTEM
#@# #@todo
#@# 
#@# --- PUBLIC
#@# #@todo

--- DEFAULT_ENTITIES -> { String => REXML::Entity }
XML の仕様上デフォルトで定義されている実体の Hash table。

"amp" => [[m:REXML::EntityConst::AMP]] は含まれません。

= class REXML::Declaration < REXML::Child
DTD に含まれる各種宣言ノードを表すクラスです。

このクラス自体は直接はインスタンスを作りません。
各サブクラスのインスタンスが使われます。

== Instance Methods

--- to_s -> String
ノードを文字列化します。

--- write(output, indent) -> ()
output にノードを出力します。

このメソッドは deprecated です。[[c:REXML::Formatter]] で
出力してください。

@param output 出力先の IO オブジェクト
@param indent インデントの大きさ。無視されます。

= class REXML::ElementDecl < REXML::Declaration
DTD の要素宣言(Element Decleration)を表すクラスです。

== Class Methods

--- new(src) -> REXML::ElementDecl
新たな要素宣言オブジェクトを作ります。

@param src 要素宣言文字列


= class REXML::ExternalEntity < REXML::Child
DTD 内の宣言でパラメータ実体参照を使って宣言が
されているものを表わすクラスです。

例えば、以下の DTD 宣言における %HTMLsymbol が
それにあたります。
  <!ENTITY % HTMLsymbol PUBLIC
     "-//W3C//ENTITIES Symbols for XHTML//EN"
     "xhtml-symbol.ent">
  %HTMLsymbol;
=== 例
  require 'rexml/document'
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE xhtml [
    <!ENTITY % HTMLsymbol PUBLIC
       "-//W3C//ENTITIES Symbols for XHTML//EN"
       "xhtml-symbol.ent">
    %HTMLsymbol;
  ]>
  EOS
  
  p doctype.children.find_all{|child| REXML::ExternalEntity === child }.map(&:to_s)
  # => ["%HTMLsymbol;"]

== Class Methods

--- new(src) -> REXML::ExternalEntity
新たな ExternalEntity オブジェクトを生成します。

@param src 宣言文字列

== Instance Methods

--- to_s -> String
宣言を文字列化します。

--- write(output, indent) -> ()
output へ self を文字列化して出力します。

このメソッドは deprecated です。[[c:REXML::Formatter]] で
出力してください。

@param output 出力先の IO オブジェクト
@param indent インデントの大きさ。無視されます。


= class REXML::NotationDecl < REXML::Child
DTD の記法宣言を表すクラスです。


=== 例
  require 'rexml/document'
  
  doctype = REXML::Document.new(<<EOS).doctype
  <!DOCTYPE foo [
  <!NOTATION type-image-svg       PUBLIC "-//W3C//DTD SVG 1.1//EN"
       "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
  <!NOTATION type-image-gif       PUBLIC "image/gif">
  <!NOTATION foobar               SYSTEM "http://example.org/foobar.dtd">
  ]>
  EOS
  
  svg = doctype.notation("type-image-svg")
  p svg.name  # => "type-image-svg"
  p svg.to_s  # => "<!NOTATION type-image-svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">"
  p svg.public # => "-//W3C//DTD SVG 1.1//EN"
  p svg.system # => "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
  
  gif = doctype.notation("type-image-gif")
  p gif.name # => "type-image-gif"
  p gif.to_s # => "<!NOTATION type-image-gif PUBLIC \"image/gif\">"
  p gif.public # => "image/gif"
  p gif.system # => nil

  foobar = doctype.notation("foobar")
  p foobar.name # => "foobar"
  p foobar.to_s # => "<!NOTATION foobar SYSTEM \"http://example.org/foobar.dtd\">"
  p foobar.public # => nil
  p foobar.system # => "http://example.org/foobar.dtd"

== Class Methods

--- new(name, middle, pub, sys) -> REXML::NotationDecl
NotationDecl オブジェクトを生成します。

@param name 記法名(文字列)
@param middle 種別("PUBLIC" もしくは "SYSTEM")
@param pub 公開識別子(文字列)
@param sys URI(文字列)

== Instance Methods

--- public -> String | nil
公開識別子を返します。

宣言が公開識別子を含まない場合は nil を返します。

--- public=(value)
公開識別子を value に変更します。

@param value 設定する公開識別子(文字列)

--- system -> String | nil
システム識別子(URI)を返します。

宣言がシステム識別子を含まない場合は nil を返します。

--- system=(value)
システム識別子を変更します。

@param value 設定するシステム識別子

--- to_s -> String
self を文字列化したものを返します。

--- write(output, indent = -1)
output へ self を文字列化して出力します。

このメソッドは deprecated です。[[c:REXML::Formatter]] で
出力してください。

@param output 出力先の IO オブジェクト
@param indent インデントの大きさ。無視されます。

--- name -> String
記法宣言の名前を返します。

