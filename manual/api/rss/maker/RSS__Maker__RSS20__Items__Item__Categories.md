---
library: rss
include:
  - Enumerable
---
# class RSS::Maker::RSS20::Items::Item::Categories < RSS::Maker::RSS09::Items::Item::Categories

RSS 2.0を生成するときだけ利用されます．

## Instance Methods

### def new_category
#@todo
新しくcategoryを作成し，返します．作成された
categoryはcategoryリストの最後
に追加されています．

item.categories.new_categoryが作成する
categoryは
maker.channel.categories.new_categoryが作成する
categoryと同じAPIを持ちます．
