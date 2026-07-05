---
library: rexml/document
include:
  - Enumerable
---
# class REXML::AttlistDecl < REXML::Child

DTD の属性リスト宣言を表すクラスです。


## Class Methods

### def new(source) -> REXML::AttlistDecl
このメソッドは内部用なので使わないでください。


## Instance Methods

### def [](key) -> String | nil
key という属性名のデフォルト値を返します。

key という名前の属性が存在しない、もしくは
デフォルト値を持たない場合は nil を返します。

### def each {|name, value| ... } -> ()
それぞれの属性名、デフォルト値を引数として
ブロックを順に呼び出します。

デフォルト値を持たない属性に関しては nil が渡されます。

### def element_name -> String
属性を定義しているエレメントの名前を返します。

### def include?(key) -> bool
key が属性名であるならば真を返します。

- **param** `key` -- 属性名であるかどうか判定する文字列

### def node_type -> Symbol
[c:Symbol] :attlistdecl を返します。

### def write(out, indent = -1) -> ()
self を out に出力します。

- **param** `out` -- 出力先の IO オブジェクト
- **param** `indent` -- インデント数(無視されます)
