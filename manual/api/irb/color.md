---
type: library
require:
  - reline
#%until 4.1
  - ripper
#%else
  - prism
#%end
  - irb/ruby-lex
---
irb の出力の色付け(シンタックスハイライト)を行うためのサブライブラリです。

ユーザが直接使用するものではありません。
