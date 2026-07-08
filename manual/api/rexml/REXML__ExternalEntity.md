---
library: rexml/document
---
# class REXML::ExternalEntity < REXML::Child
DTD 内の宣言でパラメータ実体参照を使って宣言が
されているものを表わすクラスです。

例えば、以下の DTD 宣言における %HTMLsymbol が
それにあたります。

`````
<!ENTITY % HTMLsymbol PUBLIC
   "-//W3C//ENTITIES Symbols for XHTML//EN"
   "xhtml-symbol.ent">
%HTMLsymbol;
`````

```ruby
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
```

## Class Methods

### def new(src) -> REXML::ExternalEntity
新たな ExternalEntity オブジェクトを生成します。

- **param** `src` -- 宣言文字列

## Instance Methods

### def to_s -> String
宣言を文字列化します。

### def write(output, indent) -> ()
output へ self を文字列化して出力します。

このメソッドは deprecated です。[c:REXML::Formatter] で
出力してください。

- **param** `output` -- 出力先の IO オブジェクト
- **param** `indent` -- インデントの大きさ。無視されます。


