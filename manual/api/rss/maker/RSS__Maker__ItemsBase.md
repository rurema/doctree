---
library: rss
include:
  - Enumerable
---
# class RSS::Maker::ItemsBase < RSS::Maker::Base

## Instance Methods
### def new_item
#@todo
新しくitemを作成し，返します．作成された
itemはitemリストの最後に追加されています．

### def do_sort
#@todo
現在のdo_sortの値を取得します．デフォルトでは
falseになっています．

### def do_sort=()
#@todo
trueに設定するとitem.dateが新しい順に並び替
えます．Procオブジェクトを指定することにより並び
替え方法をカスタマイズできます．

### def max_size
#@todo
現在のmax_sizeの値を取得します．デフォルトでは
-1になっています．

### def max_size=()
#@todo
出力するitemの数の最大値を設定します．

