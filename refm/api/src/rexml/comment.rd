#@#require rexml/child

= class REXML::Comment < REXML::Child
include Comparable

XML コメントを表すクラス。

コメントとは <!-- と --> で挟まれたテキストです。

  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <!-- xx -->
  <root>
  <!-- yy -->
  text
  <!-- zz -->
  </root>
  EOS
  
  doc[0].string # => " xx "
  doc.root[1].string # => " yy "
  doc.root[3].string # => " zz "
  
== Class Methods

#@# --- new(source) -> REXML::Comment
--- new(string, parent = nil) -> REXML::Comment
--- new(comment, parent = nil) -> REXML::Comment

Comment オブジェクトを生成します。

引数に REXML::Comment オブジェクトを渡すとその内容が複製されます
(親ノードの情報は複製されません)。

@param string コメント文字列
@param comment REXML::Comment オブジェクト
@param parent 親ノード

== Instance Methods

--- string -> String
--- to_s -> String

コメント文字列を返します。

--- string=(value)
コメント文字列を設定します。

@param value 設定する文字列

--- clone -> REXML::Comment

内容が複製された Commnent オブジェクトを返します。
(親ノードの情報は複製されません)。

#@# --- write(output, indent = -1, transitive = false, ie_hack = false)
#@# #@todo

--- <=>(other) -> -1 | 0 | 1
other と内容([[m:REXML::Comment#string]])を比較します。

--- ==(other) -> bool
other と内容([[m:REXML::Comment#string]])が同じならば真を返します。

--- node_type -> Symbol
シンボル :comment を返します。

== Constants

#@# --- START
#@# #@todo
#@# 
#@# --- STOP
#@# #@todo
