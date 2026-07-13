---
library: rinda/rinda
---
# class Rinda::Template < Rinda::Tuple

タプルのマッチングのためのクラスです。
ユーザがこのクラスを直接使うことはありません。

### 例

```ruby
require 'rinda/rinda'
 
template = Rinda::Template.new(['abc', nil, nil])
p template.match(['abc', 2, 5]) # => true
p template.match(['hoge', 2, 5])  # => false

template = Rinda::Template.new([String, Integer, nil])
p template.match(['abc', 2, 5]) # => true
p template.match(['abcd', 2, 5])  # => true
 
template = Rinda::Template.new([/^abc/, Integer, nil])
p template.match([/^abc/, Integer, nil])  # => true
p template.match(['abc', 2, 5])         # => true
p template.match(['def', 2, 5])         # => false
 
template = Rinda::Template.new({'name' => String, 'age' => Integer})
p template.match({'name' => 'seki', 'age' => 0x20}) # => true
p template.match({'name' => :seki,  'age' => 0x20}) # => false
```

#@# == Instance Methods
#@# 
#@# --- ===(tuple)
#@# --- match(tuple)
#@# #@todo
#@# 
#@# self と tuple のサイズが同じで、
#@# self の各要素が tuple にマッチする場合は真を返します。
#@# マッチングの検査には [[m:Rinda::Tuple#==]] と [[m:Rinda::Tuple#===]] を用います。
#@# nil はワイルドカードです。

