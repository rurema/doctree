#@#require rexml/text

= class REXML::CData < REXML::Text
XML の cdata テキストを表すクラス

cdata とは <![CDATA[ と ]]> で囲まれたテキストデータのことです。

== Class Methods

--- new(text, respect_whitespace = true, parent = nil) -> REXML::CData
text をテキストとして持つ CData オブジェクトを生成します。

respect_whitespace に真を指定すると、text に含まれる空白文字は保存されます。
偽の場合は空白はまとめられます。

@param text テキスト文字列
@param respect_whitespace 空白を保存するかどうかを決める真偽値
@param parent 親ノード

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <root />
  EOS
  doc.root.add(REXML::CData.new("foo bar  baz "))
  doc.to_s # => "<root><![CDATA[foo bar  baz ]]></root>\n"
  
  doc = REXML::Document.new(<<EOS)
  <root />
  EOS
  doc.root.add(REXML::CData.new("foo  bar  baz  ", true))
  doc.root.add(REXML::CData.new("foo  bar  baz  ", false))
  doc.to_s # => "<root><![CDATA[foo  bar  baz  ]]><![CDATA[foo bar baz ]]></root>\n"


== Instance Methods

--- clone -> REXML::CData
self を複製して返します。

親ノードの情報は複製されません。

--- to_s -> String
--- value -> String

テキスト文字列を返します。

==== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <root><![CDATA[foobar  baz]]></root>
  EOS
  doc.root[0].class # => REXML::CData
  doc.root[0].value # => "foobar  baz"

#@# --- write(output = $stdout, indent = -1, transitive = false, ie_hack = false)
#@# #@todo

#@# == Constants
#@# 
#@# --- START
#@# #@todo
#@# 
#@# --- STOP
#@# #@todo
#@# 
#@# --- ILLEGAL
#@# #@todo
