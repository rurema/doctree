---
type: library
require:
  - reline
  - io/console
  - irb/completion
#%since 3.3
  - irb/history
#%end
#%version 3.1
  - rdoc
#%end
#%until 3.3
  - irb/src_encoding
  - irb/magic-file
#%end
---
irb が入力を扱うためのサブライブラリです。

ユーザが直接使用するものではありません。

