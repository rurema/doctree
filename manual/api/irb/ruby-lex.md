---
type: library
require:
#%until 4.1
  - ripper
#%else
  - prism
#%end
---
Ruby のソースコードを字句解析するためのサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。
