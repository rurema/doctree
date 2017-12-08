= class REXML::Instruction < REXML::Child

XML 処理命令(XML Processing Instruction, XML PI)を表すクラス。

XML 処理命令 とは XML 文書中の <? と ?> で挟まれた部分のことで、
アプリケーションへの指示を保持するために使われます。

XML 宣言(文書先頭の <?xml version=... ?>)はXML処理命令ではありませんが、
似た見た目を持っています。

  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <?xml version="1.0" encoding="utf-8" ?>
  <?xml-stylesheet type="text/css" href="style.css"?>
  <root />
  EOS
  doc[2] # => <?p-i xml-stylesheet ...?>
  doc[2].target # => "xml-stylesheet"
  doc[2].content # => "type=\"text/css\" href=\"style.css\""
== Class Methods

--- new(target, content = nil) -> REXML::Instruction
新たな Instruction オブジェクトを生成します。

@param target ターゲット
@param content 内容

  
== Instance Methods

--- target -> String
XML 処理命令のターゲットを返します。

=== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <?xml version="1.0" encoding="utf-8" ?>
  <?xml-stylesheet type="text/css" href="style.css"?>
  <root />
  EOS
  doc[2] # => <?p-i xml-stylesheet ...?>
  doc[2].target # => "xml-stylesheet"
  doc[2].content # => "type=\"text/css\" href=\"style.css\""

--- target=(value)
XML 処理命令のターゲットを value に変更します。

@param value 新たなターゲット(文字列)

--- content -> String | nil
XML 処理命令の内容を返します。

=== 例
  require 'rexml/document'
  doc = REXML::Document.new(<<EOS)
  <?xml version="1.0" encoding="utf-8" ?>
  <?xml-stylesheet type="text/css" href="style.css"?>
  <?foobar?>
  <root />
  EOS
  doc[2] # => <?p-i xml-stylesheet ...?>
  doc[2].target # => "xml-stylesheet"
  doc[2].content # => "type=\"text/css\" href=\"style.css\""
  doc[4].target # => "foobar"
  doc[4].content # => nil
--- content=(value)
XML 処理命令の内容を変更します。

@param value 新たなデータ(文字列)

--- clone -> REXML::Instruction
self を複製します。

#@# obsolete
#@# --- write(writer, indent = -1, transitive = false, ie_hack = false)
#@# #@todo

--- ==(other) -> bool
other と self が同じ 処理命令である場合に真を返します。

同じとは、 [[m:REXML::Instruction#target]] と [[m:REXML::Instruction#content]]
が一致することを意味します。

@param other 比較対象

--- node_type -> Symbol
Symbol :processing_instruction を返します。

#@# #@since 1.8.3
#@# --- inspect
#@# #@todo
#@# #@end

#@# == Constants
#@# 
#@# --- START
#@# #@todo
#@# 
#@# --- STOP
#@# #@todo
