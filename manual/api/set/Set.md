---
library: set
include:
  - Enumerable
until: "3.2"
---
# class Set < Object

集合を表すクラスです。要素の間に順序関係はありません。

## Class Methods
### def new(enum = nil) -> Set
### def new(enum = nil) {|o| ... } -> Set

引数 enum で与えられた要素を元に、新しい集合を作ります。

引数を指定しない場合、または引数が nil である場合には、空の集合を
作ります。

引数を与えてブロックを与えない場合、enum の各要素からなる集合を
作ります。

引数とブロックの両方を与えた場合、enum の各要素についてブロックを
評価し、その結果を新しい集合の要素とします。

- **param** `enum` -- 集合要素を格納するオブジェクトを指定します。
       enum には each メソッドが定義されている必要があります。
- **raise** `ArgumentError` -- 引数 enum が与えられて、かつ enum に each メソッドが
       定義されていない場合に発生します。

```ruby
require 'set'
p Set.new                      # => #<Set: {}>
p Set.new([1, 2])              # => #<Set: {1, 2}>
p Set.new([1, 2]) {|o| o * 2}  # => #<Set: {2, 4}>
```

### def [](*ary) -> Set

与えられたオブジェクトを要素とする新しい集合を作ります。

- **param** `ary` -- 新しい集合の要素を指定します。

```ruby
require 'set'
p Set[1, 2] # => #<Set: {1, 2}>
```

## Instance Methods
### def clone -> Set
### def dup -> Set

集合を複製して返します。

dup は、集合の内容と taint 情報のみコピーします。
clone は、それに加えて、freeze 情報と特異メソッドをコピーします。
いずれも共通して、内部記憶として保持するハッシュもコピーしますが、
集合の要素そのものはコピーしません。

Set クラスでは、dup と clone に共通して、内部記憶として
用いるハッシュも含めて taint 情報をコピーします。
ただし、clone では内部記憶の freeze 情報はコピーされません。
このため、freeze された集合を clone した場合、生成された集合の要素は
変更可能である点に注意してください。

```ruby
require 'set'
s1 = Set[10, 20]
s2 = s1.dup
s2 << 30
p s1 # => #<Set: {10, 20}>
p s2 # => #<Set: {10, 20, 30}>
```

- **SEE** [m:Object#clone]

### def compare_by_identity -> self

集合の要素の一致判定をオブジェクトの同一性で判定するように変更します。

デフォルトでは、要素の内容が [m:Object#eql?] で等しければ同じ要素とみなされますが、より厳密に
[m:Object#object_id] が一致しているかどうかを条件とするように self を変更します。

self が変化する破壊的メソッドです。

- **return** -- self を返します。

```ruby title="例"
require 'set'
s1 = Set["a", "b"]
a  = "a"

p s1.compare_by_identity? # => false
p s1.include?(a)          # => true

s1.compare_by_identity

p s1.compare_by_identity? # => true
p s1.include?(a)          # => false
p s1.include?("a")        # => false
```

- **SEE** [m:Set#compare_by_identity?], [m:Hash#compare_by_identity]

### def compare_by_identity? -> bool

集合が要素の一致判定をオブジェクトの同一性を用いて行っているならば真を返します。

```ruby title="例"
require 'set'
s1 = Set["a", "b"]
p s1.compare_by_identity? # => false

s1.compare_by_identity

p s1.compare_by_identity? # => true
```

- **SEE** [m:Set#compare_by_identity], [m:Hash#compare_by_identity?]

### def size -> Integer
### def length -> Integer

集合の要素数を返します。

```ruby
require 'set'
p Set[10, 20, 30, 10].size # => 3
```

### def empty? -> bool

集合が要素を 1 つも持たないときに true を返します。

```ruby
require 'set'
p Set[10, 20].empty? # => false
p Set[].empty?       # => true
```

### def clear -> self

集合の要素をすべて削除し、空にした後の self を返します。

```ruby
require 'set'
p s = Set[10, 20, 30] # => #<Set: {10, 20, 30}>
s.clear
p s # => #<Set: {}>
```

### def replace(enum) -> self

集合の要素をすべて削除し、enum で与えられた要素に置き換えます。

引数 enum には each メソッドが定義されている必要があります。

- **param** `enum` -- 置き換え後の集合要素を格納するオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
p s = Set[10, 20, 30] # => #<Set: {10, 20, 30}>
s.replace([15, 25])
p s # => #<Set: {15, 25}>
```

### def flatten -> Set
### def flatten! -> self | nil

集合を再帰的に平坦化します。

flatten は、平坦化した集合を新しく作成し、それを返します。

flatten! は、元の集合を破壊的に平坦化します。集合の要素に変更が
発生した場合には self を、そうでない場合には nil を返します。

- **raise** `ArgumentError` -- 集合の要素として self が再帰的に現れた場合に発生
                     します。

```ruby
require 'set'
s = Set[Set[1,2], 3]
p s.flatten # => #<Set: {1, 2, 3}>
p s         # => #<Set: {#<Set: {1, 2}>, 3}>
s.flatten!
p s         # => #<Set: {1, 2, 3}>
```

- **SEE** [m:Array#flatten]

### def to_a -> Array

self を配列に変換します。要素の順序は不定です。

```ruby
require 'set'
set = Set['hello', 'world']
p set.to_a # => ["hello", "world"]
```

### def include?(o) -> bool
### def member?(o) -> bool
### def ===(o) -> bool

オブジェクト o がその集合に属する場合に true を返します。

- **param** `o` -- オブジェクトを指定します。

```ruby
require 'set'
set = Set['hello', 'world']
p set.include?('world') # => true
p set.include?('bye')   # => false
```

### def superset?(set) -> bool
### def proper_superset?(set) -> bool

self が集合 set の上位集合 (スーパーセット) である場合に true を
返します。

superset? は、2 つの集合が等しい場合にも true となります。

proper_superset? は、2 つの集合が等しい場合には false を返します。

- **param** `set` -- 比較対象の Set オブジェクトを指定します。
- **raise** `ArgumentError` -- 引数が Set オブジェクトでない場合に発生します。

```ruby
require 'set'
s = Set[1, 2, 3]
p s.superset?(Set[1, 2])            # => true
p s.superset?(Set[1, 4])            # => false
p s.superset?(Set[1, 2, 3])         # => true
p s.proper_superset?(Set[1, 2])     # => true
p s.proper_superset?(Set[1, 4])     # => false
p s.proper_superset?(Set[1, 2, 3])  # => false
```

- **SEE** [m:Set#subset?]

### def subset?(set) -> bool
### def proper_subset?(set) -> bool

self が集合 set の部分集合である場合に true を返します。

subset? は、2 つの集合が等しい場合にも true となります。

proper_subset? は、2 つの集合が等しい場合には false を返します。

- **param** `set` -- 比較対象の Set オブジェクトを指定します。
- **raise** `ArgumentError` -- 引数が Set オブジェクトでない場合に発生します。

```ruby
require 'set'
s = Set[1, 2]
p s.subset?(Set[1, 2, 3])         # => true
p s.subset?(Set[1, 4])            # => false
p s.subset?(Set[1, 2])            # => true
p s.proper_subset?(Set[1, 2, 3])  # => true
p s.proper_subset?(Set[1, 4])     # => false
p s.proper_subset?(Set[1, 2])     # => false
```

- **SEE** [m:Set#superset?]

### def each {|o| ... } -> self

集合の各要素についてブロックを実行します。

```ruby
require 'set'
s = Set[10, 20]
ary = []
s.each {|num| ary << num + 1}
p ary # => [11, 21]
```

### def collect! {|o| ...} -> self
### def map! {|o| ...} -> self

集合の各要素についてブロックを評価し、その結果で元の集合を置き換えます。

```ruby
require 'set'
set = Set['hello', 'world']
set.map! {|str| str.capitalize}
p set  # => #<Set: {"Hello", "World"}>
```

- **SEE** [m:Enumerable#collect]

### def add(o) -> self
### def <<(o) -> self
### def add?(o) -> self | nil

集合にオブジェクト o を加えます。

add は常に self を返します。<< は add の別名です。

add? は、集合に要素が追加された場合には self を、変化がなかった場合には
nil を返します。

- **param** `o` -- 追加対象のオブジェクトを指定します。

```ruby
require 'set'
s = Set[1, 2]
s << 10
p s           # => #<Set: {1, 2, 10}>
p s.add?(20)  # => #<Set: {1, 2, 10, 20}>
p s.add?(2)   # => nil
```

### def delete(o) -> self
### def delete?(o) -> self | nil

集合からオブジェクト o を削除します。

delete は常に self を返します。

delete? は、集合の要素が削除された場合には self を、変化がなかった場合
には nil を返します。

- **param** `o` -- 削除対象のオブジェクトを指定します。

```ruby
require 'set'
s = Set[10, 20, 30]
s.delete(10)
p s              # => #<Set: {20, 30}>
p s.delete?(20)  # => #<Set: {30}>
p s.delete?(10)  # => nil
```

### def delete_if {|o| ... } -> self
### def reject! {|o| ... } -> self | nil

集合の各要素に対してブロックを実行し、その結果が真であるようなすべての
要素を削除します。

delete_if は常に self を返します。

reject! は、要素が 1 つ以上削除されれば self を、1 つも削除されなければ
nil を返します。

```ruby
require 'set'
s1 = Set['hello.rb', 'test.rb', 'hello.rb.bak']
s1.delete_if {|str| str =~ /\.bak\z/}
p s1 # => #<Set: {"hello.rb", "test.rb"}>

s2 = Set['hello.rb', 'test.rb', 'hello.rb.bak']
p s2.reject! {|str| str =~ /\.bak\z/} # => #<Set: {"hello.rb", "test.rb"}>
p s2.reject! {|str| str =~ /\.o\z/}   # => nil
```

- **SEE** [m:Enumerable#reject]

### def merge(enum) -> self

元の集合に enum で与えられた要素を追加します。

引数 enum には each メソッドが定義されている必要があります。

- **param** `enum` -- 追加対象の要素を格納したオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
set = Set[10, 20]
set.merge([10, 30])
p set # => #<Set: {10, 20, 30}>
```

### def subtract(enum) -> self

元の集合から、enum で与えられた要素を削除します。

引数 enum には each メソッドが定義されている必要があります。

- **param** `enum` -- 削除対象の要素を格納したオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
set = Set[10, 20, 40]
set.subtract([10, 20, 30])
p set # => #<Set: {40}>
```

### def union(enum) -> Set
### def +(enum) -> Set
### def |(enum) -> Set

和集合、すなわち、2 つの集合の少なくともどちらか一方に属するすべての
要素からなる新しい集合を作ります。

- **param** `enum` -- each メソッドが定義されたオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
p Set[10, 20, 30] + Set[10, 20, 40]
# => #<Set: {10, 20, 30, 40}>
```

### def difference(enum) -> Set
### def -(enum) -> Set

差集合、すなわち、元の集合の要素のうち引数 enum に含まれる要素を取り除いた
新しい集合を作ります。

- **param** `enum` -- each メソッドが定義されたオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
p Set[10, 20, 30] - Set[10, 20, 40]
# => #<Set: {30}>
```

### def intersection(enum) -> Set
### def &(enum) -> Set

共通部分、すなわち、2つの集合のいずれにも属するすべての要素からなる
新しい集合を作ります。

- **param** `enum` -- each メソッドが定義されたオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
s1 = Set[10, 20, 30]
s2 = Set[10, 30, 50]
p s1 & s2 #=> #<Set: {10, 30}>
```

- **SEE** [m:Array#&], [m:Array#intersection]

### def ^(enum) -> Set

対称差、すなわち、2 つの集合のいずれか一方にだけ属するすべての要素からなる
新しい集合を作ります。

- **param** `enum` -- each メソッドが定義されたオブジェクトを指定します。
- **raise** `ArgumentError` -- 引数 enum に each メソッドが定義されていない場合に
       発生します。

```ruby
require 'set'
s1 = Set[10, 20, 30]
s2 = Set[10, 30, 50]
p s1 ^ s2 # => #<Set: {50, 20}>
```

### def ==(set) -> bool

2 つの集合が等しいときに true を返します。

より厳密には、引数 set が Set オブジェクトであり、self と set が同数の
要素を持ち、かつそれらの要素がすべて等しい場合に true となります。
それ以外の場合には、false を返します。
要素の等しさは [m:Object#eql?] により判定されます。

- **param** `set` -- 比較対象のオブジェクトを指定します。

```ruby
require 'set'
s1 = Set[10, 20, 30]
s2 = Set[10, 30, 40]
s3 = Set[30, 10, 30, 20]
p s1 == s2 # => false
p s1 == s3 # => true
```

### def classify {|o| ... } -> Hash

集合をブロックの値によって分類し、結果をハッシュとして返します。

ブロックは集合の各要素について実行され、引数 o にはその要素が
渡されます。

生成されるハッシュのキーはブロックの実行結果、値は分類された集合と
なります。

```ruby
require 'set'
numbers = Set[10, 4.5, 20, 30, 31.2]
p numbers.classify {|o| o.class}
# => {Integer=>#<Set: {10, 20, 30}>, Float=>#<Set: {4.5, 31.2}>}
```

### def divide {|o| ... } -> Set
### def divide {|o1, o2| ... } -> Set

元の集合をブロックで定義される関係で分割し、その結果を集合として返します。

ブロックパラメータが 1 個の場合、block.call(o1) == block.call(o2) が真
ならば、o1 と o2 は同じ分割に属します。

ブロックパラメータが 2 個の場合、block.call(o1, o2) が真ならば、
o1 と o2 は同じ分割に属します。
この場合、block.call(o1, o2) == block.call(o2, o1)
が成立しないブロックを与えると期待通りの結果が得られません。

```ruby title="例1"
require 'set'
numbers = Set.new(1..6)
set = numbers.divide {|i| i % 3}
p set
# => #<Set: {#<Set: {1, 4}>, #<Set: {2, 5}>, #<Set: {3, 6}>}>
```

```ruby title="例2"
require 'set'
numbers = Set[1, 3, 4, 6, 9, 10, 11]
set = numbers.divide {|i, j| (i - j).abs == 1}
p set     # => #<Set: {#<Set: {1}>,
          #            #<Set: {3, 4}>,
          #            #<Set: {6}>,
          #            #<Set: {9, 10, 11}>}>
```

```ruby title="応用例: 8x2 のチェス盤上で、ナイトが到達できる位置に関する分類を作成します。"
require 'set'

board = Set.new
m, n = 8, 2
for i in 1..m
  for j in 1..n
    board << [i,j]
  end
end
knight_move = Set[1,2]
p board.divide { |i,j|
  Set[(i[0] - j[0]).abs, (i[1] - j[1]).abs] == knight_move
}
# => #<Set: {#<Set: {[1, 1], [3, 2], [5, 1], [7, 2]}>,
#            #<Set: {[1, 2], [3, 1], [5, 2], [7, 1]}>,
#            #<Set: {[2, 1], [4, 2], [6, 1], [8, 2]}>,
#            #<Set: {[2, 2], [4, 1], [6, 2], [8, 1]}>}>
```

### def inspect -> String
### def to_s -> String

人間の読みやすい形に表現した文字列を返します。

```ruby
require 'set'
puts Set.new(['element1', 'element2']).inspect
# => #<Set: {"element1", "element2"}>
```

### def intersect?(set) -> bool

self と set の共通要素がある場合に true を返します。

- **param** `self` -- Set オブジェクトを指定します。
- **raise** `ArgumentError` -- 引数が Set オブジェクトでない場合に発生します。

```ruby
require 'set'
p Set[1, 2, 3].intersect?(Set[3, 4])  # => true
p Set[1, 2, 3].intersect?(Set[4, 5])  # => false
```

- **SEE** [m:Set#intersection], [m:Set#disjoint?]

### def disjoint?(set) -> bool

self と set が互いに素な集合である場合に true を返します。

逆に self と set の共通集合かを確認する場合には [m:Set#intersect?] を
使用します。

- **param** `self` -- Set オブジェクトを指定します。
- **raise** `ArgumentError` -- 引数が Set オブジェクトでない場合に発生します。

```ruby
require 'set'
p Set[1, 2, 3].disjoint? Set[3, 4] # => false
p Set[1, 2, 3].disjoint? Set[4, 5] # => true
```

- **SEE** [m:Set#intersect?]

### def keep_if {|element| ... } -> self

各要素に対してブロックを評価し、その結果が偽であった要素を self から削除します。

- **return** -- 常に self を返します。

### def select! {|element| ... } -> self | nil
### def filter! {|element| ... } -> self | nil

各要素に対してブロックを評価し、その結果が偽であった要素を self から削除します。

- **return** -- 変更があった場合は self を、変更がなかった場合は nil を返します。

### def reset -> self

キーのハッシュ値を再計算します。

既存の要素の変更後、内部状態をリセットして self を返します。

要素はインデックスし直され、重複削除されます。

- **SEE** [m:Hash#rehash]

