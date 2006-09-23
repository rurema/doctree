集合を表す Set クラスを提供します。集合とは重複のないオブジェクトの
順序づけられていない集まりです。
[[c:Array]] の持つ演算機能と [[c:Hash]] のような高速な検索を合わせ持ちます。

#@# Set は重複のないオブジェクトの順序づけられていない集まりの実装です。
#@# Arrayの持つ演算機能とHashのような高速な検索を合わせ持ちます。

2つのオブジェクトの等価性は Object#eql? と Object#hash によります。
なぜなら、Set は Hash を記憶として使っているからです。


=== 例:

  require 'set'
  
  set1 = Set.new ["foo", "bar", "baz", "foo"]
  
  p set1                        #=> #<Set: {"baz", "foo", "bar"}>
  
  p set1.include?("bar")        #=> true
  
  set1.add("heh")
  set1.delete("foo")
  
  p set1                        #=> #<Set: {"heh", "baz", "bar"}>


= class Set < Object
include Enumerable

== Class Methods
--- new(enum = nil)

引数 enum で与えられた Enumerable の要素からなる新しい集合を作ります。

--- [](*ary)

与えられたオブジェクトからなる新しい集合を作ります。

== Instance Methods
--- dup

集合を複製します。

--- size
--- length

要素の個数を返します。

--- empty?

要素を1つも持たないときに true を返します。

--- clear

要素をすべて削除します。

--- replace(enum)

要素を enum のものと置き換えます。要素をすべて削除し、enum で与え
られた Enumerable の要素を新しい要素とします。

--- flatten

ネストした集合を平滑化して作られる新しい集合を返します。

例:

  p s0 = Set[Set[1,2], 3]  #=> #<Set: {#<Set: {1, 2}>, 3}>
  p s0.flatten             #=> #<Set: {1, 2, 3}>
  p s1 = Set[Set[1,2], 1]  #=> #<Set: {#<Set: {1, 2}>, 1}>
  p s1.flatten             #=> #<Set: {1, 2}>

--- flatten!

flatten と同じですが、
集合それ自身が平滑化して作られた新しい集合の要素で置き換えられます。
ただし、要素の変更が起こらなかったときには nil を返します。

--- to_a

配列に変換します。順序は不定です。

--- include?(o)
--- member?(o)

オブジェクト o がその集合に属す場合に true を返します。

--- superset?(set)

集合が与えられた集合 set を含む場合に true を返します。

--- proper_superset?(set)

集合が与えられた集合 set を真に含む場合に true を返します。つまり、
ふたつの集合が等しい場合には false を返します。

--- subset?(set)

集合が与えられた集合 set に含まれる場合に true を返します。

--- proper_subset?(set)

集合が与えられた集合 set に真に含まれる場合に true を返します。つまり、
ふたつの集合が等しい場合には false を返します。

--- each { |o| ... }

集合のすべての要素に対して1度ずつブロックを実行します。
ブロック変数 o にはその要素が渡されます。

--- add(o)
--- << o

集合にオブジェクト o を加え、その集合自身を返します。

--- delete(o)

集合からオブジェクト o を削除し、その集合自身を返します。

--- delete_if { |o| ... }

ブロックで最後に評価された値が真であるようなすべての要素を削除し、
その集合自身を返します。

--- reject! { |o| ... }

delete_if と同じですが、要素が1つも削除されなかった場合は nil を返します。

--- merge(enum)

enum で与えられた Enumerable の要素を追加し、その集合自身を返します。

--- subtract(enum)

enum で与えられた Enumerable の要素を削除し、その集合自身を返します。

--- +@
--- |(enum)

和集合、すなわち、2つの集合の少なくともどちらか一方に属するすべて
の要素からなる新しい集合を作りそれを返します。

--- -@

差集合、すなわち、前者に属し後者に属さないすべての要素からなる
新しい集合を作りそれを返します。

--- &(enum)

共通部分、すなわち、2つの集合のいずれにも属するすべての要素からなる
新しい集合を作りそれを返します。

--- ^(enum)

対称差、すなわち、2つの集合のいずれか一方にだけ属するすべての要素からなる
新しい集合を作りそれを返します。

--- ==(set)

2つの集合が等しいときに true を返します。
要素の等しさは Object#eql? で検査されます。

--- classify { |o| ... }

集合をブロックの値によって分類します。返される分類結果は、
{値 => 要素の集合} という形をしたハッシュです。
ブロックは集合のすべての要素に対して1度ずつ実行され、
ブロック変数 o にはその要素が渡されます。

例:

  require 'set'
  files = Set.new(Dir.glob("*.rb"))
  hash = files.classify { |f| File.mtime(f).year }
  p hash    #=> {2000=>#<Set: {"a.rb", "b.rb"}>,
            #    2001=>#<Set: {"c.rb", "d.rb", "e.rb"}>,
            #    2002=>#<Set: {"f.rb"}>}

--- divide { |o| ... }
--- divide { |o1, o2| ... }

商集合、すなわちブロックで定義される関係で分割した結果を集合として
返します。

引数が2個のときは block.call(o1, o2) が真ならば o1 と o2 は同じ分
割に属します。引数が1個のときは block.call(o1) == block.call(o2)
が真ならばo1 と o2 は同じ分割に属します。つまりブロックの引数が2個
のときはブロックの値の真偽で決まる同値類に、引数が1個のときはブロッ
クの値の == による等しさで定義される同値類に分割されます。

引数が2個のときは、いわゆる同値関係のうち、
対称律「block.call(o1, o2) ならば block.call(o2, o1)」、
そして推移律「block.call(o1, o2) かつ
block.call(o2, o3) ならば
block.call(o1, o3)」
の2つを満たすことが仮定されています。

例:

  require 'set'
  numbers = Set[1, 3, 4, 6, 9, 10, 11]
  set = numbers.divide { |i,j| (i - j).abs == 1 }
  p set     #=> #<Set: {#<Set: {1}>,
            #           #<Set: {11, 9, 10}>,
            #           #<Set: {3, 4}>,
            #           #<Set: {6}>}>

応用例:

  # 8x2 のチェス盤上でナイトが到達できる位置に関する分類
  require "set"
  board = Set.new
  m, n = 8, 2
  for i in 1..m do for j in 1..n do board << [i,j] end end
  knight_move = Set[1,2]
  p board.divide { |i,j|
    Set[(i[0]-j[0]).abs, (i[1]-j[1]).abs] == knight_move
  }  #=> #<Set: {#<Set: {[6, 2], [4, 1], [2, 2], [8, 1]}>,
     #           #<Set: {[2, 1], [8, 2], [6, 1], [4, 2]}>,
     #           #<Set: {[1, 1], [3, 2], [5, 1], [7, 2]}>,
     #           #<Set: {[1, 2], [5, 2], [3, 1], [7, 1]}>}>

--- inspect

人間の読みやすい形に表現した文字列を返します。
