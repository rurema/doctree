---
library:
  - rdoc/known_classes
#@until 1.9.1
  - rdoc/parser/c
#@end
---
# reopen RDoc

## Constants

### def KNOWN_CLASSES -> {String => String}

Ruby の組み込みクラスの内部的な変数名がキー、クラス名が値のハッシュです。

`````
RDoc::KNOWN_CLASSES["rb_cObject"] # => "Object"
`````

ライブラリの内部で使用します。
