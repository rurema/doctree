---
library: rexml/document
include:
  - REXML::Encoding
---
# class REXML::XMLDecl < REXML::Child

XML 宣言を表すクラス。

文書から XML 宣言を取り出すには [m:REXML::Document#xml_decl] を使います。

```ruby
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<e />
EOS

xml_decl = doc.xml_decl
p xml_decl.version # => "1.0"
p xml_decl.encoding # => "UTF-8"
p xml_decl.standalone # => "yes"
p xml_decl.writethis # => true
```


```ruby title="XML 宣言を省略した場合の例。"
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<e />
EOS

xml_decl = doc.xml_decl
p xml_decl.version # => "1.0"
p xml_decl.encoding # => "UTF-8"
p xml_decl.standalone # => nil
p xml_decl.writethis # => false
```

```ruby title="XML 宣言が encoding 属性を持たない場合の例"
require 'rexml/document'
doc = REXML::Document.new(<<EOS)
<?xml version="1.0" ?>
<e />
EOS

xml_decl = doc.xml_decl
p xml_decl.version # => "1.0"
p xml_decl.encoding # => "UTF-8"
p xml_decl.standalone # => nil
p xml_decl.writethis # => true
```

## Class Methods

### def new(version = REXML::XMLDecl::DEFAULT_VERSION, encoding = nil, standalone = nil)
新たな XMLDecl オブジェクトを生成して返します。

version 以外は省略可能です。

- **param** `version` -- バージョン(文字列)
- **param** `encoding` -- エンコーディング(文字列 or nil)
- **param** `standalone` -- スタンドアロン文章かどうか("yes", "no", nil)

### def default -> REXML::XMLDecl
XML宣言を含まない文章でデフォルトで使うための
XMLDecl オブジェクトを生成して返します。


## Instance Methods

### def version -> String
XML文書のバージョンを文字列で返します。

### def version=(value)
XML文書のバージョンを設定します。

- **param** `value` -- 設定値(文字列)

### def standalone -> String | nil
### def stand_alone? -> String | nil
スタンドアロン文書であるかどうかを "yes" "no" で
返します。

nil(省略)を返す場合もあります。

### def standalone=(value)
スタンドアロン文書であるかどうかを "yes" "no" で設定します。

この属性を省略したい場合は nil を指定します。

- **param** `value` -- 設定値(文字列)

### def writeencoding -> bool
XML宣言内の encoding の宣言を出力時に省略するならば真を返します。

これが真であっても UTF-8 以外のエンコーディングを指定している
ならば encoding は出力されます。


### def clone -> REXML::XMLDecl
self を複製します。

#@# --- write(writer, indent = -1, transitive = false, ie_hack = false) -> ()
#@# #@todo

### def ==(other) -> bool
self と other が同じであるならば真を返します。

「同じ」とは [m:REXML::XMLDecl#version], [m:REXML::XMLDecl#encoding],
[m:REXML::XMLDecl#standalone] が一致していることを意味します。

- **param** `other` -- 比較対象のオブジェクト

### def xmldecl(version, encoding, standalone) -> ()

内容を更新します。

- **param** `version` -- バージョン(文字列)
- **param** `encoding` -- エンコーディング(文字列 or nil)
- **param** `standalone` -- スタンドアロン文章かどうか("yes", "no", nil)

### def node_type -> Symbol
シンボル :xmldecl を返します。

#@# for internal use
#@# #@since 1.8.1
#@# --- old_enc=(enc)
#@# #@todo

### def encoding -> String | nil
設定されているエンコーディングの名前を文字列で返します。

エンコーディングが指定されていない(デフォルトの UTF-8 とみなされます)
場合は nil を返します。

#@# このメソッドは実際は REXML::Encoding にあります

### def encoding=(enc)
エンコーディングを enc に設定します。

enc に nil を渡すと XML 宣言では encoding が
指定されていない(デフォルトで UTF-8 が使われる)
ことになります。

- **param** `enc` -- エンコーディング(文字列 or nil)
- **SEE** [m:REXML::XMLDecl#encoding=]

### def nowrite -> ()
出力時([m:REXML::Document#write]) に XML 宣言を省略する
よう指示します。

- **SEE** [m:REXML::XMLDecl#dowrite], [m:REXML::XMLDecl#writethis]

### def dowrite -> ()
出力時([m:REXML::Document#write]) に XML 宣言を省略しない
よう指示します。

- **SEE** [m:REXML::XMLDecl#nowrite], [m:REXML::XMLDecl#writethis]

### def writethis -> bool
出力時([m:REXML::Document#write]) に XML 宣言を出力する(省略しない)
ならば真を返します。

- **SEE** [m:REXML::XMLDecl#dowrite], [m:REXML::XMLDecl#nowrite]

#@# --- inspect
#@# #@todo

## Constants


### const DEFAULT_VERSION -> String
[m:REXML::XMLDecl.new] や [m:REXML::XMLDecl.default] で
の使われるデフォルトのXMLバージョン。

#@# #@todo
#@#
#@# 以下の利用法は？
#@# --- DEFAULT_ENCODING
#@# #@todo
#@#
#@# --- DEFAULT_STANDALONE
#@# #@todo

#@# 以下2つは内部用
#@# --- START
#@# #@todo
#@#
#@# --- STOP
#@# #@todo
