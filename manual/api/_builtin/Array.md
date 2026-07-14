---
library: _builtin
include:
  - Enumerable
---
# class Array < Object

配列クラスです。
配列は任意の Ruby オブジェクトを要素として持つことができます。

一般的には配列は配列式を使って

```ruby title="例"
[1, 2, 3]
```

のように生成します。

## Class Methods

#@since 1.9.1
### def try_convert(obj) -> Array | nil
to_ary メソッドを用いて obj を配列に変換しようとします。

何らかの理由で変換できないときには nil を返します。
このメソッドは引数が配列であるかどうかを調べるために使えます。

```ruby title="例"
p Array.try_convert([1]) # => [1]
p Array.try_convert("1") # => nil

if tmp = Array.try_convert(arg)
  # the argument is an array
elsif tmp = String.try_convert(arg)
  # the argument is a string
end
```
#@end

### def [](*item)    -> Array

引数 item を要素として持つ配列を生成して返します。

[c:Array] のサブクラスを作成したときに、そのサブクラスのインスタンスを作成
しやすくするために用意されている。

- **param** `item` -- 配列の要素を指定します。

```ruby title="例"
p Array[1, 2, 3] #=> [1, 2, 3]

class SubArray < Array
  # ...
end
p SubArray[1, 2, 3] # => [1, 2, 3]
```

### def new(size = 0, val = nil)    -> Array

長さ size の配列を生成し、各要素を val で初期化して返します。

要素毎に val が複製されるわけではないことに注意してください。
全要素が同じオブジェクト val を参照します。
後述の例では、配列の各要素は全て同一の文字列を指します。

- **param** `size` -- 配列の長さを数値で指定します。

- **param** `val` -- 配列の要素の値を指定します。

```ruby title="例"
ary = Array.new(3, "foo")
p ary                     #=> ["foo", "foo", "foo"]
ary[0].capitalize!
p ary                     #=> ["Foo", "Foo", "Foo"]  (各要素は同一のオブジェクトである)
```

### def new(ary)    -> Array

指定された配列 ary を複製して返します。
[m:Array#dup] 同様 要素を複製しない浅い複製です。

- **param** `ary` -- 複製したい配列を指定します。

```ruby title="例"
p Array.new([1,2,3]) # => [1,2,3]

a = ["a", "b", "c"]
b = Array.new(a)
a.each{|s| s.capitalize! }
p a                        #=> ["A", "B", "C"]
p b                        #=> ["A", "B", "C"]   (b は a と要素を共有する)
```


### def new(size) {|index| ... }    -> Array

長さ size の配列を生成し、各要素のインデックスを引数としてブロックを実行し、
各要素の値をブロックの評価結果に設定します。

ブロックは要素毎に実行されるので、全要素をあるオブジェクトの複製にできます。

- **param** `size` -- 配列の長さを数値で指定します。

```ruby title="例"
ary = Array.new(3){|index| "hoge#{index}"}
p ary                      #=> ["hoge0", "hoge1", "hoge2"]
```

```ruby title="例"
ary = Array.new(3){ "foo" }
p ary                      #=> ["foo", "foo", "foo"]
ary[0].capitalize!
p ary                      #=> ["Foo", "foo", "foo"]  (各要素は違うオブジェクトである)
```

## Instance Methods

### def [](nth)    -> object | nil
### def at(nth)    -> object | nil

nth 番目の要素を返します。nth 番目の要素が存在しない時には nil を返します。

- **param** `nth` -- インデックスを整数で指定します。
           先頭の要素が 0 番目になります。nth の値が負の時には末尾から
           のインデックスと見倣します。末尾の要素が -1 番目になります。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [ "a", "b", "c", "d", "e" ]
p a[0]  #=> "a"
p a[1]  #=> "b"
p a[-1] #=> "e"
p a[-2] #=> "d"
p a[10] #=> nil
```

### def [](range)    -> Array | nil

[c:Range] オブジェクト range の範囲にある要素からなる部分配列を返します。
range の begin が自身の範囲外となる時は nil を返します。ただし、begin が配列の長さに等しいときは空の配列を返します。
range の begin が end より後にある場合には空の配列を返します。

- **param** `range` -- 生成したい部分配列の範囲を [c:Range] オブジェクトで指定します。
             range の begin や end の値が負の時には末尾からのインデックスと見倣します。末尾
             の要素が -1 番目になります。
             end の値が配列の範囲を越える時には、越えた分は無視されます。

```ruby title="例"
a = [ "a", "b", "c", "d", "e" ]
p a[0..1] #=> ["a", "b"]
p a[0...1]  #=> ["a"]
p a[0..-1]  #=> ["a", "b", "c", "d", "e"]
p a[-2..-1] #=> ["d", "e"]
p a[-2..4]  #=> ["d", "e"]  (start は末尾から -2 番目、end は先頭から (4+1) 番目となる。)
p a[0..10]  #=> ["a", "b", "c", "d", "e"]
p a[10..11] #=> nil
p a[2..1] #=> []
p a[-1..-2] #=> []

# 特殊なケース。begin が自身の長さと同じ場合には以下のようになります。
p a[5]    #=> nil
p a[5..10]  #=> []
```

### def [](start, length)    ->  Array | nil

start 番目から length 個の要素を含む部分配列を返します。
start が自身の範囲外となる時は nil を返します。ただし、start が配列の長さに等しいときは空の配列を返します。
length が負の時は nil を返します。

- **param** `start` -- 生成したい部分配列の先頭のインデックスを整数で指定します。
             start の値が負の時には末尾からのインデックスと見倣します。
             末尾の要素が -1 番目になります。
             整数以外のオブジェクトを指定した場合は to_int メソッドによ
             る暗黙の型変換を試みます。

- **param** `length` -- 生成したい部分配列の長さを整数で指定します。
              length が start 番目からの配列の長さより長い時には、越え
              た分の長さは無視されます。
              整数以外のオブジェクトを指定した場合は to_int メソッドに
              よる暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [ "a", "b", "c", "d", "e" ]
p a[0, 1]  #=> ["a"]
p a[-1, 1] #=> ["e"]
p a[0, 10] #=> ["a", "b", "c", "d", "e"]
p a[0, 0]  #=> []
p a[0, -1] #=> nil
p a[10, 1] #=> nil

# 特殊なケース。start が自身の長さと同じ場合には以下のようになります。
p a[5]     #=> nil
p a[5, 1]  #=> []
```

### def []=(nth, val)

nth 番目の要素を val に設定します。nth が配列の範囲を越える時には配列の長さを自動的に拡張し、
拡張した領域を nil で初期化します。

- **param** `nth` -- インデックスを整数で指定します。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **param** `val` -- 設定したい要素の値を指定します。

- **raise** `TypeError` -- 引数 nth に整数以外の(暗黙の型変換が行えない)オブジェ
                 クトを指定した場合に発生します。

- **raise** `IndexError` -- 指定された nth が自身の始点よりも前を指している場合に発生します。

```ruby title="例"
a = [0, 1, 2, 3, 4, 5]
a[0] = "a"
p a  #=> ["a", 1, 2, 3, 4, 5]
a[10] = "x"
p a  #=> ["a", 1, 2, 3, 4, 5, nil, nil, nil, nil, "x"]

a = [0, 1, 2, 3, 4, 5]
a[-100] = 1           #=> IndexError
```

### def []=(range, val)

[c:Range] オブジェクト range の範囲にある要素を配列 val の内容に置換します。
range の first が自身の末尾を越える時には配列の長さを自動的に拡張し、拡張した領域を nil で初期化します。

```ruby title="例"
ary = [0, 1, 2, 3, 4, 5]
ary[0..2] = ["a", "b"]
p ary  # => ["a", "b", 3, 4, 5]

ary = [0, 1, 2]
ary[5..6] = "x"
p ary  # => [0, 1, 2, nil, nil, "x"]

ary = [0, 1, 2, 3, 4, 5]
ary[1..3] = "x"
p ary  # => [0, "x", 4, 5]
```

- **param** `range` -- 設定したい配列の範囲を [c:Range] オブジェクトで指定します。
             range の first や end の値が負の時には末尾からのインデックスと見倣します。
             末尾の要素が -1 番目になります。
             range の first が end より後にある場合には first の直前に val を挿入します。

```ruby title="例"
ary = [0, 1, 2, 3, 4, 5]
ary[2..0] = ["a", "b", "c"]
p ary   # => [0, 1, "a", "b", "c", 2, 3, 4, 5]
```

- **param** `val` -- range の範囲に設定したい要素を配列で指定します。
           配列以外のオブジェクトを指定した場合は to_ary メソッドによる
           暗黙の型変換を試みます。to_ary メソッドに応答できない場合は
           [val] を用います。
           val の要素の数の方が range の長さより大きい時には、後ろの要素がずれます。
#@since 1.9.1
           val が空の配列 [] なら start から end までの要素が削除されます。
#@else
           val が nil か 空の配列 [] なら start から end までの要素が削除されます。
#@end

```ruby title="例"
ary = [0, 1, 2, 3, 4, 5]
ary[2..4] = []
p ary   # => [0, 1, 5]
```

- **raise** `RangeError` -- 指定された範囲の始点が自身の始点よりも前にある場合に発生します。

```ruby title="例"
a = [0, 1, 2, 3, 4, 5]
a[-10..10] = 1        #=> RangeError
```

### def []=(start, length, val)

インデックス start から length 個の要素を配列 val の内容で置き換えます。
start が自身の末尾を越える時には配列の長さを自動的に拡張し、拡張した領域を nil で初期化します。

```ruby title="例"
ary = [0, 1, 2, 3]
ary[1, 2] = ["a", "b", "c", "d"]
p ary                        #=> [0, "a", "b", "c", "d", 3]

ary = [0, 1, 2]
ary[5, 1] = "Z"
p ary                        #=> [0, 1, 2, nil, nil, "Z"]

ary = [0, 1, 2, 3]
ary[0, 10] = ["a"]
p ary                        #=> ["a"]
```

- **param** `start` -- 置き換えたい範囲の先頭のインデックスを指定します。
             start の値が負の時には末尾からのインデックスと見倣します。
             末尾の要素が -1 番目になります。
             整数以外のオブジェクトを指定した場合は to_int メソッドによ
             る暗黙の型変換を試みます。

- **param** `length` -- 置き換えたい要素の個数を指定します。
              length の値が 0 のときは start の直前に val を挿入します。
              整数以外のオブジェクトを指定した場合は to_int メソッドに
              よる暗黙の型変換を試みます。

```ruby title="例"
ary = [0, 1, 2, 3]
ary[1, 0] = ["inserted"]
p ary                        # => [0, "inserted", 1, 2, 3]
```

- **param** `val` -- 設定したい要素を配列で指定します。
           配列以外のオブジェクトを指定した場合は to_ary メソッドによる
           暗黙の型変換を試みます。to_ary メソッドに応答できない場合は
           [val] を用います。
           val の長さが length と等しくない場合には、val の長さに合わせて要素が削除されたりずれたりします。
#@since 1.9.1
           val が空の配列 [] なら start から end までの要素が削除されます。
#@else
           val が nil か 空の配列 [] なら start から end までの要素が削除されます。
#@end

```ruby title="例"
a = [0, 1, 2, 3, 4, 5]
a[2, 3] = []
p a   # => [0, 1, 5]
```

- **raise** `TypeError` -- 引数 start、length に整数以外の(暗黙の型変換が行えな
                 い)オブジェクトを指定した場合に発生します。

- **raise** `TypeError` -- 引数 val に配列以外の(暗黙の型変換が行えない)オブジェ
                 クトを指定した場合に発生します。

- **raise** `IndexError` -- 引数 start が自身の始点よりも前を指している場合に発生します。

- **raise** `IndexError` -- 引数 length に負の数を指定した場合に発生します。

### def +(other)    -> Array

自身と other の内容を繋げた配列を生成して返します。

- **param** `other` -- 自身と繋げたい配列を指定します。
             配列以外のオブジェクトを指定した場合は to_ary メソッドによ
             る暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [1, 2]
b = [8, 9]
p a + b     #=> [1, 2, 8, 9]
p a         #=> [1, 2]        (変化なし)
p b         #=> [8, 9]        (こちらも変化なし)
```

### def *(times)    -> Array

配列の内容を times 回 繰り返した新しい配列を作成して返します。
値はコピーされないことに注意してください。

- **param** `times` -- 繰り返したい回数を整数で指定します。
             整数以外のオブジェクトを指定した場合は to_int メソッドによ
             る暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

- **raise** `ArgumentError` -- 引数に負の数を指定した場合に発生します。

```ruby title="例"
p [1, 2, 3] * 3  #=> [1, 2, 3, 1, 2, 3, 1, 2, 3]
```

### def *(sep)    -> String

指定された sep を間にはさんで連結した文字列を生成して返します。[m:Array#join](sep) と同じ動作をします。

- **param** `sep` -- 文字列を指定します。
           文字列以外のオブジェクトを指定した場合は to_str メソッドによ
           る暗黙の型変換を試みます。

```ruby title="例"
p [1,2,3] * ","
# => "1,2,3"
```

- **SEE** [m:Array#join]

### def -(other)    -> Array

自身から other の要素を取り除いた配列を生成して返します。

要素の同一性は [m:Object#eql?] により評価されます。
self 中で重複していて、other中に存在していなかった要素は、その重複が保持されます。

- **param** `other` -- 自身から取り除きたい要素の配列を指定します。
             配列以外のオブジェクトを指定した場合は to_ary メソッドによ
             る暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
p [1, 2, 1, 3, 1, 4] - [4, 2]  # => [1, 1, 3, 1]

p [1, 2, 1, 3, 1, 4] - [1, 4]  # => [2, 3]
```

#@since 2.6.0

- **SEE** [m:Array#difference]
### def difference(*other_arrays) -> Array

自身から other_arrays の要素を取り除いた配列を生成して返します。

要素の同一性は [m:Object#hash] と [m:Object#eql?] により評価されます。
self 中で重複していて、other_arrays中に存在していなかった要素は、その重複が保持されます。
新しい配列における要素の順は self における要素の順と同じです。

```ruby title="例"
p [ 1, 1, 2, 2, 3, 3, 4, 5 ].difference([ 1, 2, 4 ])     # => [ 3, 3, 5 ]
p [ 1, 'c', :s, 'yep' ].difference([ 1 ], [ 'a', 'c' ])  # => [:s, "yep"]
```

集合のような振る舞いが必要なら [c:Set] も参照してください。

- **SEE** [m:Array#-]
#@end
### def &(other)    -> Array

集合の積演算です。両方の配列に含まれる要素からなる新しい配列を返
します。重複する要素は取り除かれます。

要素の重複判定は、[m:Object#eql?] により行われます。

新しい配列における要素の順は self における要素の順と同じです。

- **param** `other` -- 配列を指定します。
             配列以外のオブジェクトを指定した場合は to_ary メソッドによ
             る暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
p [1, 1, 2, 3] & [3, 1, 4] #=> [1, 3]
```

#@since 2.7.0
- **SEE** [m:Array#|], [m:Array#intersection]
#@else
- **SEE** [m:Array#|]
#@end

### def |(other)    -> Array

集合の和演算です。両方の配列にいずれかに含まれる要素を全て含む新し
い配列を返します。重複する要素は取り除かれます。

要素の重複判定は、[m:Object#eql?] と [m:Object#hash] により行われます。

新しい配列における要素の順は self における要素の順と同じです。

- **param** `other` -- 配列を指定します。
             配列以外のオブジェクトを指定した場合は to_ary メソッドによ
             る暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
p [1, 1, 4, 2, 3] | [5, 4, 5]  #=> [1, 4, 2, 3, 5]
```

- **SEE** [m:Array#&]
#@since 2.6.0
- **SEE** [m:Array#union]

### def union(*other_arrays) -> Array

集合の和演算です。self と other_arrays の配列にどれかに含まれる要素を
全て含む新しい配列を返します。重複する要素は取り除かれます。

要素の重複判定は、[m:Object#eql?] と [m:Object#hash] により行われます。

- **param** `other_arrays` -- 0個以上の配列を指定します。

```ruby title="例"
p ["a", "b", "c"].union([ "c", "d", "a" ])  #=> ["a", "b", "c", "d"]
p ["a"].union(["e", "b"], ["a", "c", "b"])  #=> ["a", "e", "b", "c"]
p ["a"].union # => ["a"]
```

- **SEE** [m:Array#|]
#@end
### def <<(obj)    -> self

指定された obj を自身の末尾に破壊的に追加します。

```ruby title="例"
ary = [1]
ary << 2
p ary      # [1, 2]
```

またこのメソッドは self を返すので、以下のように連続して
書くことができます。

```ruby title="例"
ary = [1]
ary << 2 << 3 << 4
p ary   #=> [1, 2, 3, 4]
```

- **param** `obj` -- 自身に加えたいオブジェクトを指定します。[m:Array#push] と違って引数は一つしか指定できません。

- **SEE** [m:Array#push]

#@since 1.9.2
### def <=>(other)    -> -1 | 0 | 1 | nil
#@else
### def <=>(other)    -> -1 | 0 | 1
#@end

自身と other の各要素をそれぞれ順に <=> で比較していき、結果が 0 でなかった場合に
その値を返します。各要素が等しく、配列の長さも等しい場合には 0 を返します。
各要素が等しいまま一方だけ配列の末尾に達した時、自身の方が短ければ -1 をそうでなければ 1
を返します。
#@since 1.9.2
other に配列以外のオブジェクトを指定した場合は nil を返します。
#@end

- **param** `other` -- 自身と比較したい配列を指定します。
             配列以外のオブジェクトを指定した場合は to_ary メソッドによ
             る暗黙の型変換を試みます。

#@until 1.9.2
- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。
#@end

```ruby title="例"
p [ 1, 2, 3 ] <=> [ 1, 3, 2 ]     #=> -1
p [ 1, 2, 3 ] <=> [ 1, 2, 3 ]     #=> 0
p [ 1, 2, 3 ] <=> [ 1, 2 ]        #=> 1
```

### def ==(other)    -> bool

自身と other の各要素をそれぞれ順に == で比較し
て、全要素が等しければ true を返します。そうでない場合には false を返します。

- **param** `other` -- 自身と比較したい配列を指定します。

- **SEE** [m:Object#==]

```ruby title="例"
p [ "a", "c" ]    == [ "a", "c", 7 ]   #=> false
p [ "a", "c", 7 ] == [ "a", "c", 7 ]   #=> true
p [ "a", "c", 7 ] == [ "a", "d", "f" ] #=> false
```

#@since 2.6.0
### def all?               -> bool
### def all? {|item| ... } -> bool
### def all?(pattern)      -> bool

すべての要素が真である場合に true を返します。
偽である要素があれば、ただちに false を返します。

ブロックを伴う場合は、各要素に対してブロックを評価し、すべての結果
が真である場合に true を返します。ブロックが偽を返した時点で、
ただちに false を返します。

要素の数が 0 である配列に対しては true を返します。

- **param** `pattern` -- ブロックの代わりに各要素に対して pattern === item を評価します。

```ruby title="例"
# すべて正の数か？
p [5,  6, 7].all? {|v| v > 0 }   # => true
p [5, -1, 7].all? {|v| v > 0 }   # => false
p [].all? {|v| v > 0 }           # => true
p %w[ant bear cat].all?(/t/)     # => false
p [1, 2, 3].all?(Integer)        # => true
p [1, 2, 3.0].all?(Integer)      # => false
```

- **SEE** [m:Enumerable#all?]
#@end

#@since 2.2.0
### def any?               -> bool
### def any? {|item| ... } -> bool
#@since 2.5.0
### def any?(pattern)      -> bool
#@end

すべての要素が偽である場合に false を返します。
真である要素があれば、ただちに true を返します。

ブロックを伴う場合は、各要素に対してブロックを評価し、すべての結果
が偽である場合に false を返します。ブロックが真を返した時点
で、ただちに true を返します。

要素の数が 0 である配列に対しては false を返します。

#@since 2.5.0
- **param** `pattern` -- ブロックの代わりに各要素に対して pattern === item を評価します。
#@end

```ruby title="例"
p [1, 2, 3].any? {|v| v > 3 }   # => false
p [1, 2, 3].any? {|v| v > 1 }   # => true
p [].any? {|v| v > 0 }          # => false
#@since 2.5.0
p %w[ant bear cat].any?(/d/)    # => false
p [nil, true, 99].any?(Integer) # => true
p [nil, true, 99].any?          # => true
p [].any?                       # => false
#@end
```

- **SEE** [m:Enumerable#any?]

#@end

### def assoc(key)    -> Array | nil

配列の配列を検索して、その 0 番目の要素が key に == で等しい
最初の要素を返します。該当する要素がなければ nil を返します。

- **param** `key` -- 検索するオブジェクトを指定します。

```ruby title="例"
ary = [[1,15], [2,25], [3,35]]
p ary.assoc(2)           # => [2, 25]
p ary.assoc(100)         # => nil
p ary.assoc(15)          # => nil
```

- **SEE** [m:Array#rassoc]

### def clear    -> self

配列の要素をすべて削除して空にします。

```ruby title="例"
ary = [1, 2]
ary.clear
p ary     #=> []
```

### def clone    -> Array
### def dup      -> Array

レシーバと同じ内容を持つ新しい配列を返します。

clone は frozen singleton-class の情報も含めてコピーしますが、
#@since 2.7.0
dup は内容だけをコピーします。
#@else
dup は内容と tainted だけをコピーします。
#@end
またどちらのメソッドも要素それ自体のコピーはしません。
つまり参照しているオブジェクトが変わらない「浅い(shallow)」コピーを行います。

```ruby title="例"
ary = ['string']
p ary             #=> ["string"]
copy = ary.dup
p copy            #=> ["string"]

ary[0][0...3] = ''
p ary             #=> ["ing"]
p copy            #=> ["ing"]
```

### def collect  -> Enumerator
### def map      -> Enumerator
### def collect {|item| ... } -> [object]
### def map {|item| ... }     -> [object]

各要素に対してブロックを評価した結果を全て含む配列を返します。

ブロックを省略した場合は [c:Enumerator] を返します。

```ruby title="例"
# すべて 3 倍にする
p [1, 2, 3].map {|n| n * 3 }  # => [3, 6, 9]
```

#@since 2.6.0
- **SEE** [m:Hash#to_h], [m:Enumerable#collect], [m:Enumerable#map]
#@else
- **SEE** [m:Enumerable#collect], [m:Enumerable#map]
#@end

### def collect! {|item| ..}    -> self
### def map! {|item| ..}        -> self
#@since 1.9.1
### def collect!                -> Enumerator
### def map!                    -> Enumerator
#@else
### def collect!                -> Enumerable::Enumerator
### def map!                    -> Enumerable::Enumerator
#@end

各要素を順番にブロックに渡して評価し、その結果で要素を
置き換えます。

ブロックが与えられなかった場合は、自身と map! から生成した
#@since 1.9.1
[c:Enumerator] オブジェクトを返します。
#@else
[c:Enumerable::Enumerator] オブジェクトを返します。
#@end

```ruby title="例"
ary = [1, 2, 3]
ary.map! {|i| i * 3 }
p ary   #=> [3, 6, 9]

ary = [1, 2, 3]
e = ary.map!
e.each{ 1 }
p ary           #=> [1, 1, 1]
```

#@since 1.9.1
- **SEE** [m:Array#collect],  [c:Enumerator]
#@else
- **SEE** [m:Array#collect], [c:Enumerable::Enumerator]
#@end

### def compact     -> Array
### def compact!    -> self | nil

compact は自身から nil を取り除いた配列を生成して返します。
compact! は自身から破壊的に nil を取り除き、変更が
行われた場合は self を、そうでなければ nil を返します。

```ruby title="例"
ary = [1, nil, 2, nil, 3, nil]
p ary.compact   #=> [1, 2, 3]
p ary           #=> [1, nil, 2, nil, 3, nil]
ary.compact!
p ary           #=> [1, 2, 3]
p ary.compact!  #=> nil
```

### def concat(other)    -> self

配列 other を自身の末尾に破壊的に連結します。

- **param** `other` -- 自身と連結したい配列を指定します。

```ruby title="例"
array = [1, 2]
a     = [3, 4]
array.concat a
p array          # => [1, 2, 3, 4]
p a              # => [3, 4]       # こちらは変わらない
```

#@since 2.4.0
### def concat(*other_arrays)    -> self

other_arrays の要素を自身の末尾に破壊的に連結します。

- **param** `other_arrays` -- 自身と連結したい配列を指定します。

```ruby title="例"
p [ "a", "b" ].concat( ["c", "d"] ) #=> [ "a", "b", "c", "d" ]
p [ "a" ].concat( ["b"], ["c", "d"] ) #=> [ "a", "b", "c", "d" ]
p [ "a" ].concat #=> [ "a" ]

a = [ 1, 2, 3 ]
a.concat( [ 4, 5 ] )
p a                               #=> [ 1, 2, 3, 4, 5 ]

a = [ 1, 2 ]
p a.concat(a, a)                  #=> [1, 2, 1, 2, 1, 2]
```

- **SEE** [m:Array#+]
#@end

### def count                   -> Integer
### def count(item)             -> Integer
### def count {|obj| ... }  -> Integer

レシーバの要素数を返します。

引数を指定しない場合は、配列の要素数を返します。

引数を一つ指定した場合は、レシーバの要素のうち引数に一致するものの
個数をカウントして返します(一致は == で判定します)。

ブロックを指定した場合は、ブロックを評価して真になった要素の個数を
カウントして返します。

- **param** `item` -- カウント対象となる値。

```ruby title="例"
ary = [1, 2, 4, 2.0]
p ary.count           # => 4
p ary.count(2)        # => 2
p ary.count{|x|x%2==0}  # => 3
```

- **SEE** [m:Enumerable#count]

### def delete(val)           -> object | nil
### def delete(val) { ... }   -> object

指定された val と == で等しい要素を自身からすべて取り除きます。
#@since 1.9.1
等しい要素が見つかった場合は最後に見つかった要素を、
#@else
等しい要素が見つかった場合は val を、
#@end
そうでない場合には nil を返します。

ブロックが与えられた場合、val と等しい要素が見つからなかったときにブロッ
クを評価してその結果を返します。

- **param** `val` -- 自身から削除したい値を指定します。

```ruby title="例"
array = [1, 2, 3, 2, 1]
p array.delete(2)       #=> 2
p array                 #=> [1, 3, 1]

# ブロックなしの引数に nil を渡すとその戻り値から削除が
# 行われたかどうかの判定をすることはできない
ary = [nil,nil,nil]
p ary.delete(nil)       #=> nil
p ary                   #=> []
p ary.delete(nil)       #=> nil
```

### def delete_at(pos)    -> object | nil

指定された位置 pos にある要素を取り除きそれを返します。
pos が範囲外であったら nil を返します。

[m:Array#at] と同様に負のインデックスで末尾から位置を指定できます。

- **param** `pos` -- 削除したい要素のインデックスを整数で指定します。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
array = [0, 1, 2, 3, 4]
array.delete_at 2
p array             #=> [0, 1, 3, 4]
```

### def delete_if {|x| ... }    -> self
### def reject! {|x| ... }      -> self | nil
### def delete_if               -> Enumerator
### def reject!                 -> Enumerator

要素を順番にブロックに渡して評価し、その結果が真になった要素をすべて削除します。
delete_if は常に self を返しますが、reject! は要素が 1 つ以上削除されれば self を、
1 つも削除されなければ nil を返します。

ブロックが与えられなかった場合は、自身と reject! から生成した
[c:Enumerator] オブジェクトを返します。
返された Enumerator オブジェクトの each メソッドには、
もとの配列に対して副作用があることに注意してください。

```ruby title="例"
a = [0, 1, 2, 3, 4, 5]
a.delete_if{|x| x % 2 == 0}
p a #=> [1, 3, 5]

a = [0, 1, 2, 3, 4, 5]
e = a.reject!
e.each{|i| i % 2 == 0}
p a                    #=> [1, 3, 5]  もとの配列から削除されていることに注意。
```

- **SEE** [m:Array#select!], [m:Array#keep_if]

### def drop(n)               -> Array

配列の先頭の n 要素を捨てて、
残りの要素を配列として返します。
このメソッドは自身を破壊的に変更しません。

- **param** `n` -- 捨てる要素数。

```ruby title="例"
a = [1, 2, 3, 4, 5, 0]
p a.drop(3)           # => [4, 5, 0]

# 変数aの値は変化しない
p a                   # => [1, 2, 3, 4, 5, 0]
```

- **SEE** [m:Enumerable#drop], [m:Array#drop_while], [m:Array#shift]

### def drop_while                    -> Enumerator
### def drop_while {|element| ... }   -> Array

ブロックを評価して最初に偽となった要素の手前の要素まで捨て、
残りの要素を配列として返します。
このメソッドは自身を破壊的に変更しません。

ブロックを指定しなかった場合は、[c:Enumerator] を返します。

```ruby title="例"
a = [1, 2, 3, 4, 5, 0]
p a.drop_while {|i| i < 3 } # => [3, 4, 5, 0]

# 変数aの値は変化しない
p a                         # => [1, 2, 3, 4, 5, 0]
```

- **SEE** [m:Enumerable#drop_while], [m:Array#drop]

### def each {|item| .... }    -> self
#@since 1.9.1
### def each                   -> Enumerator
#@else
### def each                   -> Enumerable::Enumerator
#@end

各要素に対してブロックを評価します。

ブロックが与えられなかった場合は、自身と each から生成した
#@since 1.9.1
[c:Enumerator] オブジェクトを返します。
#@else
[c:Enumerable::Enumerator] オブジェクトを返します。
#@end

```ruby title="例"
[1, 2, 3].each do |i|
  puts i
end
#=> 1
#   2
#   3
```

#@#
#@#each により(また、標準のメソッドで)複数の値を取得しながら繰り返す
#@#ことはできません。現在のところ以下のようなメソッドを定義する必要が
#@#あります。
#@#
#@#    class Array
#@#      def every(&block)
#@#        arity = block.arity
#@#        return self.each(&block) if arity <= 0
#@#
#@#        i = 0
#@#        while i < self.size
#@#          yield(*self[i, arity])
#@#          i += arity
#@#        end
#@#        self
#@#      end
#@#    end
#@#
#@#    ary = [1,2,3]
#@#    ary.every {|i| p i}
#@#    # => 1
#@#    #    2
#@#    #    3
#@#    ary.every {|i,j| p [i,j]}
#@#    # => [1, 2]
#@#    #    [3, nil]
#@#    ary.every {|i,j,k| p [i,j,k]}
#@#    # => [1, 2, 3]
#@#    ary.every {|*i| p *i}
#@#    # => 1
#@#    #    2
#@#    #    3

- **SEE** [m:Array#each_index], [m:Array#reverse_each]

### def each_index {|index| .... }    -> self
#@since 1.9.1
### def each_index                    -> Enumerator
#@else
### def each_index                    -> Enumerable::Enumerator
#@end

各要素のインデックスに対してブロックを評価します。

以下と同じです。

```ruby title="例"
(0 ... ary.size).each do |index|
  # ....
end
```

ブロックが与えられなかった場合は、自身と each_index から生成した
#@since 1.9.1
[c:Enumerator] オブジェクトを返します。
#@else
[c:Enumerable::Enumerator] オブジェクトを返します。
#@end

- **SEE** [m:Array#each], [m:Array#reverse_each]

### def empty?    -> bool

自身の要素の数が 0 の時に真を返します。そうでない場合に false を返します。

```ruby title="例"
p [].empty?         #=> true
p [1, 2, 3].empty?  #=> false
```

### def eql?(other)    -> bool

自身と other の各要素をそれぞれ順に
[m:Object#eql?] で比較して、全要素が等しければ真を返
します。そうでない場合に false を返します。

- **param** `other` -- 自身と比較したい配列を指定します。

```ruby title="例"
p ["a", "b", "c"].eql? ["a", "b", "c"]    #=> true
p ["a", "b", "c"].eql? ["a", "c", "b"]    #=> false
p ["a", "b", 1].eql?   ["a", "b", 1.0]    #=> false (1.eql?(1.0) が false なので)
```

- **SEE** [m:Object#eql?]

### def fetch(nth)               -> object
### def fetch(nth, ifnone)       -> object
### def fetch(nth) {|nth| ... }  -> object

nth 番目の要素を返します。

[m:Array#\[\]](nth) とは nth 番目の要素が存在しない場合の振舞いが異
なります。最初の形式では、例外 [c:IndexError] が発生します。
二番目の形式では、引数 ifnone を返します。
三番目の形式では、ブロックを評価した結果を返します。

- **param** `nth` -- 取得したい要素のインデックスを整数で指定します。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **param** `ifnone` -- 要素が存在しなかった場合に返すべき値を指定します。

- **raise** `TypeError` -- 引数 nth に整数以外の(暗黙の型変換が行えない)オブジェ
                 クトを指定した場合に発生します。

- **raise** `IndexError` -- 引数 ifnone もブロックも指定しておらず、 nth 番目の要
                  素も存在しなかった場合に発生します。

```ruby title="例"
a = [1, 2, 3, 4, 5]
begin
  p a.fetch(10)
rescue IndexError => err
  puts err #=> index 10 out of array
end

p a.fetch(10, 999) #=> 999

result = a.fetch(10){|nth|
  print "#{nth} はありません。\n"
  999
}
p result #=> 999
```

#@since 3.4
### def fetch_values(*indexes)                 -> Array
### def fetch_values(*indexes) { |index| ... } -> Array

引数で指定されたインデックスに対する値の配列を返します。

指定したインデックスが self の範囲外である場合、ブロックが与えられたかどうかにより挙動が異なります。

 - ブロックが与えられている場合、インデックスを引数としてブロックを呼び出し、その結果の値を使用します。
 - ブロックが与えられていない場合、[c:IndexError] が発生します。

- **param** `indexes` -- 取得したい要素のインデックスを指定します。

- **raise** `IndexError` -- ブロックが与えられてない時に、範囲外のインデックスを引数で指定すると発生します。

```ruby title="例"
ary = ["a", "b", "c"]

p ary.fetch_values(0, 2)  # => ["a", "c"]
p ary.fetch_values(-1, 1) # => ["c", "b"]
ary.fetch_values(0, 10) # => index 10 outside of array bounds: -3...3 (IndexError)
p ary.fetch_values(0, 10) { |i| i.to_s } # => ["a", "10"]
```

- **SEE** [m:Array#values_at], [m:Array#fetch]
#@end

### def fill(val)            -> self
### def fill {|index| ... }  -> self

すべての要素に val をセットします。

このメソッドが val のコピーでなく val 自身をセットする
ことに注意してください。
val の代わりにブロックを指定するとブロックの評価結果を値とします。

- **param** `val` -- 自身にセットしたいオブジェクトを指定します。

```ruby title="例"
a = [0, 1, 2, 3, 4]
a.fill(10)
p a #=> [10, 10, 10, 10, 10]

a = [0, 1, 2, 3, 4]
a.fill("a")
p a #=> ["a", "a", "a", "a", "a"]
a[0].capitalize!
p a #=> ["A", "A", "A", "A", "A"]
```

### def fill(val, start, length = nil)             -> self
### def fill(val, range)                     -> self
### def fill(start, length = nil) {|index| ... }    -> self
### def fill(range) {|index| ... }            -> self

配列の指定された範囲すべてに val をセットします。

範囲の始点が自身の末尾を越える時には配列の長さを自動的に拡張し、拡張した領域を nil で初期化します。
範囲の終点が自身の末尾を越える時は長さを自動的に拡張し、拡張した部分を val で初期化します。
このメソッドが val のコピーでなく val 自身をセットすることに注意してください。
```ruby title="例"
a = [0, 1, 2]
a.fill("x", 5..10)
p a #=> [0, 1, 2, nil, nil, "x", "x", "x", "x", "x", "x"]
```

val の代わりにブロックを指定するとブロックの評価結果を値とし
ます。ブロックは要素毎に実行されるので、セットする値のそれぞれをあ
るオブジェクトの複製にできます。
ブロックのパラメータには start からのインデックスが渡されます。

```ruby title="例"
ary = []
p ary.fill(1..2) {|i| i}         # => [nil, 1, 2]
p ary.fill(0,3) {|i| i}          # => [0, 1, 2]
p ary.fill { "foo" }             # => ["foo", "foo", "foo"]
p ary.collect {|v| v.object_id } # => [537770124, 537770112, 537770100]
```

- **param** `val` -- 自身に設定したいオブジェクトを指定します。

- **param** `start` -- val を設定する範囲の始点のインデックスを整数で指定します。start の値が負の時には末尾からのインデックスと見倣します。末尾の要素が -1 番目になります。

- **param** `length` -- val を設定する要素の個数を指定します。nil が指定された時は配列の終りまでの長さを意味します。

- **param** `range` -- val を設定する範囲を [c:Range] オブジェクトで指定します。

#@##@since 1.8.0
#@#version 1.8.0 には、ブロックに渡されるパラ
#@#メータが仕様と異なる不具合がありました。
#@#
#@#    ary = []
#@#    p ary.fill(1..2) {|i| i}         # => [2, 4, 6]  <- bug
#@#    p ary.fill(0,3) {|i| i}          # => [1, 3, 5]  <- bug
#@#    p ary.fill { "foo" }             # => ["foo", "foo", "foo"]
#@#    p ary.collect {|v| v.object_id } # => [537770124, 537770112, 537770100]
#@##@end

### def first       -> object | nil

配列の先頭の要素を返します。要素がなければ nil を返します。

```ruby title="例"
p [0, 1, 2].first   #=> 0
p [].first          #=> nil
```

- **SEE** [m:Array#last]

### def first(n)    -> Array

先頭の n 要素を配列で返します。n は 0 以上でなければなりません。

- **param** `n` -- 取得したい要素の個数を整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

- **raise** `ArgumentError` -- n が負値の場合発生します。

```ruby title="例"
ary =  [0, 1, 2]
p ary.first(0)
p ary.first(1)
p ary.first(2)
p ary.first(3)
p ary.first(4)
# => []
#    [0]
#    [0, 1]
#    [0, 1, 2]
#    [0, 1, 2]
```

- **SEE** [m:Array#last]

### def flatten(lv = nil)     -> Array
### def flatten!(lv = nil)    -> self | nil

flatten は自身を再帰的に平坦化した配列を生成して返します。flatten! は
自身を再帰的かつ破壊的に平坦化し、平坦化が行われた場合は self をそうでない
場合は nil を返します。
lv が指定された場合、lv の深さまで再帰的に平坦化します。

- **param** `lv` -- 平坦化の再帰の深さを整数で指定します。nil を指定した場合、再
          帰の深さの制限無しに平坦化します。
          整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
          黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

- **raise** `ArgumentError` -- 配列要素が自身を含むような無限にネストした配列に対して flatten を呼んだ場合に発生します。

```ruby title="例"
# 自身を再帰的に平坦化する例。
a = [1, [2, 3, [4], 5]]
p a.flatten                     #=> [1, 2, 3, 4, 5]
p a                             #=> [1, [2, 3, [4], 5]]

# 自身を破壊的に平坦化する例。
a = [[[1, [2, 3]]]]
p a.flatten!                    #=> [1, 2, 3]
p a                             #=> [1, 2, 3]

# 平坦化が行われない場合は nil を返す。
p [1, 2, 3].flatten!            #=> nil

# 平坦化の再帰の深さを指定する例。
a = [ 1, 2, [3, [4, 5] ] ]
p a.flatten(1)            #=> [1, 2, 3, [4, 5]]
```

### def hash    -> Integer

自身のハッシュ値を整数で返します。ハッシュ値は自身の各要素のハッシュ値から
計算されます。[m:Array#eql?] で比較して等しい配列同士は同じハッシュ値を返します。

```ruby title="例"
a = ["a", "b", 1]
p a.hash              #=>  321
b = a.dup
p b.hash              #=>  321

p ["a", 1, "b"].hash  #=>  491
p ["a", 1.0, "b"].hash  #=>  466227
```

### def include?(val)    -> bool

配列が val と == で等しい要素を持つ時に真を返します。

- **param** `val` -- オブジェクトを指定します。

```ruby title="例"
a = [ "a", "b", "c" ]
p a.include?("b")     #=> true
p a.include?("z")     #=> false
```

### def find_index(val)          -> Integer | nil
### def index(val)               -> Integer | nil
### def find_index {|item| ...}  -> Integer | nil
### def index {|item| ...}       -> Integer | nil
#@since 1.9.1
### def find_index               -> Enumerator
### def index                    -> Enumerator
#@else
### def find_index               -> Enumerable::Enumerator
### def index                    -> Enumerable::Enumerator
#@end

条件に一致する最初の要素の位置を返します。

- **param** `val` -- 位置を知りたいオブジェクトを指定します。

指定された val と == で等しい最初の要素の位置を返します。
等しい要素がひとつもなかった場合は nil を返します。

```ruby title="例"
p [1, 0, 0, 1, 0].index(1)   #=> 0
p [1, 0, 0, 0, 0].index(1)   #=> 0
p [0, 0, 0, 0, 0].index(1)   #=> nil
```

ブロックが与えられた場合には、各要素を引数として順にブロックを実行し、
ブロックが真を返した最初の要素の位置を返します。
一つも真にならなかった場合は nil を返します。

```ruby title="例"
p [0, 1, 0, 1, 0].index {|v| v > 0}   #=> 1
```


引数、ブロックのどちらも与えられなかった場合は、
#@since 1.9.1
[c:Enumerator] のインスタンスを返します。
#@else
[c:Enumerable::Enumerator] のインスタンスを返します。
#@end

- **SEE** [m:Array#rindex]

#@since 2.3.0
### def dig(idx, ...) -> object | nil

self 以下のネストしたオブジェクトを dig メソッドで再帰的に参照して返し
ます。途中のオブジェクトが nil であった場合は nil を返します。

- **param** `idx` -- インデックスを整数で任意個指定します。

```ruby title="例"
a = [[1, [2, 3]]]

p a.dig(0, 1, 1)               # => 3
p a.dig(1, 2, 3)               # => nil
#@since 2.4.0
a.dig(0, 0, 0)                 # => TypeError: Integer does not have #dig method
#@else
a.dig(0, 0, 0)                 # => TypeError: Fixnum does not have #dig method
#@end
p [42, {foo: :bar}].dig(1, :foo) # => :bar
```

- **SEE** [m:Hash#dig], [m:Struct#dig], [m:OpenStruct#dig]
#@end

### def insert(nth, *val)    -> self

インデックス nth の要素の直前(nth が負の場合は直後)に第 2 引数以降の値を挿入します。
引数 val を一つも指定しなければ何もしません。

- **param** `nth` -- val を挿入する位置を整数で指定します。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **param** `val` -- 自身に挿入するオブジェクトを指定します。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
ary = [1, 2, 3]
ary.insert(2, "a", "b")
p ary                  # => [1, 2, "a", "b", 3]
ary.insert(-2, "X")
p ary                  # => [1, 2, "a", "b", "X", 3]
```

#@since 2.7.0
### def intersection(*other_arrays) -> Array

自身と引数に渡された配列の共通要素を新しい配列として返します。
要素が重複する場合は、そのうちの1つのみを返します。
要素の順序は自身の順序を維持します。

- **param** `other_arrays` -- 自身と共通要素を取りたい配列を指定します。
                    配列以外のオブジェクトを指定した場合は to_ary
                    メソッドによる暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

intersectionは[m:Object#hash]と[m:Object#eql?]を使って比較を行います。

```ruby title="例"
p [1, 1, 3, 5].intersection([3, 2, 1])                # => [1, 3]
p ["a", "b", "z"].intersection(["a", "b", "c"], ["b"])  # => ["b"]
p ["a"].intersection                                  # => ["a"]
```

- **SEE** [m:Set#intersection], [m:Array#&]
#@end

### def join(sep = $,)    -> String

配列の要素を文字列 sep を間に挟んで連結した文字列を返します。

#@since 1.9.2
文字列でない要素に対しては、to_str があれば to_str、なければ to_s した結果を連結します。
#@else
文字列でない要素に対しては to_s した結果を連結します。
#@end
要素がまた配列であれば再帰的に (同じ sep を利用して)
join した文字列を連結します。
ただし、配列要素が自身を含むような無限にネストした配列に対しては、以下
のような結果になります。

#@since 1.9.2
```ruby title="例"
ary = [1,2,3]
ary.push ary
p ary           # => [1, 2, 3, [...]]
p ary.join      # => ArgumentError: recursive array join
```
#@else
```ruby title="例"
ary = [1,2,3]
ary.push ary
p ary           # => [1, 2, 3, [...]]
p ary.join      # => "123123[...]"
```
#@end

- **param** `sep` -- 間に挟む文字列を指定します。nil のときは空文字列を使います。
           文字列以外のオブジェクトを指定した場合は to_str メソッドによ
           る暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に文字列以外の(暗黙の型変換が行えない)オブジェクト
                 を指定した場合に発生します。

#@since 1.9.2
- **raise** `ArgumentError` -- 配列要素が自身を含むような無限にネストした配列に対
                     して join を呼んだ場合に発生します。
#@end

```ruby title="例"
p [1, 2, 3].join('-') #=> "1-2-3"
```

- **SEE** [m:Array#*], [m:$,]

### def last    -> object | nil

配列の末尾の要素を返します。配列が空のときは nil を返します。

```ruby title="例"
p [0, 1, 2].last   #=> 2
p [].last          #=> nil
```

- **SEE** [m:Array#first]

### def last(n)    -> Array

末尾の n 要素を配列で返します。n は 0 以上でなければなりません。

- **param** `n` -- 取得したい要素の個数を整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

- **raise** `ArgumentError` -- n が負値の場合発生します。

```ruby title="例"
ary =  [0, 1, 2]
p ary.last(0)
p ary.last(1)
p ary.last(2)
p ary.last(3)
p ary.last(4)
# => []
#    [2]
#    [1, 2]
#    [0, 1, 2]
#    [0, 1, 2]
```

- **SEE** [m:Array#first]

### def length    -> Integer
### def size      -> Integer

配列の長さを返します。配列が空のときは 0 を返します。

```ruby title="例"
p [1, nil, 3, nil].size    #=> 4
```

#@until 1.9.1
### def nitems    -> Integer
### def nitems{|obj| ... } -> Integer

nil でない要素の数を返します。

ブロックが与えられた場合は、各要素を引数として評価し nil でない値を返した
要素の数を返します。

```ruby title="例"
p [1, nil, 3, nil].nitems              #=> 2
p [1, nil, 3, nil].nitems{|e| e == 1}  #=> 2
```
#@end

#@since 2.6.0
### def none?               -> bool
### def none?{|obj| ... }   -> bool
### def none?(pattern)      -> bool

すべての要素が偽である場合に true を返します。真である要素があれば、ただちに false を返します。

ブロックを伴う場合は、各要素に対してブロックを評価し、すべての結果が偽である場合に true を返します。ブロックが真を返した時点で、ただちに false を返します。
要素の数が 0 である配列に対しては true を返します。

- **param** `pattern` -- ブロックの代わりに各要素に対して pattern === item を評価します。

```ruby title="例"
p %w{ant bear cat}.none? {|word| word.length == 5}  # => true
p %w{ant bear cat}.none? {|word| word.length >= 4}  # => false
p %w{ant bear cat}.none?(/d/)                     # => true
p [].none?                                        # => true
p [nil].none?                                     # => true
p [nil,false].none?                               # => true
p [nil, false, true].none?                        # => false
```

- **SEE** [m:Enumerable#none?]

### def one?                -> bool
### def one?{|obj| ... }    -> bool
### def one?(pattern)       -> bool

ブロックを指定しない場合は、 配列の要素のうち
ちょうど一つだけが真であれば、真を返します。
そうでなければ偽を返します。

ブロックを指定した場合は、配列の要素を
ブロックで評価した結果、一つの要素だけが真であれば真を返します。
そうでなければ偽を返します。

- **param** `pattern` -- ブロックの代わりに各要素に対して pattern === item を評価します。

```ruby title="例"
p %w{ant bear cat}.one? {|word| word.length == 4} # => true
p %w{ant bear cat}.one? {|word| word.length > 4}  # => false
p %w{ant bear cat}.one?(/t/)                      # => false
p [ nil, true, 99 ].one?                          # => false
p [ nil, true, false ].one?                       # => true
p [ nil, true, 99 ].one?(Integer)                 # => true
p [].one?                                         # => false
```

- **SEE** [m:Enumerable#one?]
#@end

### def pack(template)                      -> String
#@since 2.4.0
### def pack(template, buffer: String.new)  -> String
#@end

配列の内容を template で指定された文字列にしたがって、
バイナリとしてパックした文字列を返します。

テンプレートは
型指定文字列とその長さ(省略時は1)を並べたものです。長さと
して * が指定された時は「残りのデータ全て」の長さを
表します。型指定文字は以下で述べる pack テンプレート文字列の通りです。

#@since 2.4.0
buffer が指定されていれば、バッファとして使って返値として返します。
もし template の最初にオフセット (@) が指定されていれば、
結果はオフセットの後ろから詰められます。
buffer の元の内容がオフセットより長ければ、
オフセットより後ろの部分は上書きされます。
オフセットより短ければ、足りない部分は "\0" で埋められます。

buffer オプションはメモリ確保が発生しないことを保証するものでは
ないことに注意してください。
buffer のサイズ(capacity)が足りなければ、packはメモリを確保します。

```ruby title="例"
p ['!'].pack('@1a', buffer: 'abc')  # => "a!"
p ['!'].pack('@5a', buffer: 'abc')  # => "abc\u0000\u0000!"
```
#@end

- **param** `template` -- 自身のバイナリとしてパックするためのテンプレートを文字列で指定します。
#@since 2.4.0
- **param** `buffer` --   結果を詰めるバッファとして使う文字列オブジェクトを指定します。
                指定した場合は返値も指定した文字列オブジェクトになります。
#@end

#@include(pack-template)

#@since 2.4.0
- **SEE** [m:String#unpack], [m:String#unpack1]
#@else
- **SEE** [m:String#unpack]
#@end

### def pop    -> object | nil
### def pop(n) -> Array

自身の末尾から要素を取り除いてそれを返します。
引数を指定した場合はその個数だけ取り除き、それを配列で返します。

空配列の場合、n が指定されていない場合は nil を、
指定されている場合は空配列を返します。
また、n が自身の要素数より少ない場合はその要素数の配列を
返します。どちらの場合も自身は空配列となります。

返す値と副作用の両方を利用して、個数を指定して配列を 2 分する簡単な方法として使えます。

- **param** `n` -- 自身から取り除きたい要素の個数を整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
array = [1, [2, 3], 4]
p array.pop      # => 4
p array.pop      # => [2, 3]
p array          # => [1]

p array.pop      # => 1
p array.pop      # => nil
p array          # => []
array = [1, 2, 3]
p array.pop(2)   #=> [2, 3]
p array          #=> [1]
```

- **SEE** [m:Array#push], [m:Array#shift], [m:Array#unshift]

### def push(*obj)        -> self
#@since 2.5.0
### def append(*obj)      -> self
#@end

指定された obj を順番に配列の末尾に追加します。
引数を指定しなければ何もしません。

- **param** `obj` -- 自身に追加したいオブジェクトを指定します。

```ruby title="例"
array = [1, 2, 3]
array.push 4
array.push [5, 6]
array.push 7, 8
p array          # => [1, 2, 3, 4, [5, 6], 7, 8]
```

- **SEE** [m:Array#pop], [m:Array#shift], [m:Array#unshift], [m:Array#<<]

### def rassoc(obj)    -> Array | nil

自身が配列の配列であると仮定して、要素の配列でインデックス
1 の要素が obj に等しいものを検索し見つかった最初の要素を返
します。該当する要素がなければ nil を返します。

比較は == 演算子を使って行われます。

- **param** `obj` -- 検索するオブジェクトを指定します。

```ruby title="例"
a = [[15,1], [25,2], [35,3]]
p a.rassoc(2)    # => [25, 2]
```

- **SEE** [m:Array#assoc]

### def reject               -> Enumerator
### def reject {|item| ... } -> [object]

各要素に対してブロックを評価し、
その値が偽であった要素を集めた新しい配列を返します。
条件を反転させた select です。

ブロックを省略した場合は [c:Enumerator] を返します。

```ruby title="例"
# 偶数を除外する (奇数を集める)
p [1, 2, 3, 4, 5, 6].reject {|i| i % 2 == 0 }  # => [1, 3, 5]
```

- **SEE** [m:Array#select], [m:Enumerable#reject]
#@since 2.3.0
- **SEE** [m:Enumerable#grep_v]
#@end

### def replace(another)    -> self

配列の内容を配列 another の内容で置き換えます。

- **param** `another` -- 配列を指定します。
               配列以外のオブジェクトを指定した場合は to_ary メソッドに
               よる暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [1, 2, 3]
a.replace [4, 5, 6]
p a                 #=> [4, 5, 6]
```

### def reverse     -> Array
### def reverse!    -> self

reverse は自身の要素を逆順に並べた新しい配列を生成して返します。
reverse! は自身を破壊的に並べ替えます。
reverse! は self を返します。

```ruby title="例"
a = ["a", 2, true]
p a.reverse         #=> [true, 2, "a"]
p a                 #=> ["a", 2, true] (変化なし)

a = ["a", 2, true]
p a.reverse!        #=> [true, 2, "a"]
p a                 #=> [true, 2, "a"]
```

### def reverse_each {|item| ... }    -> self
#@since 1.9.1
### def reverse_each                  -> Enumerator
#@else
### def reverse_each                  -> Enumerable::Enumerator
#@end

各要素に対して逆順にブロックを評価します。

ブロックが与えられなかった場合は、自身と reverse_each から生成した
#@since 1.9.1
[c:Enumerator] オブジェクトを返します。
#@else
[c:Enumerable::Enumerator] オブジェクトを返します。
#@end

```ruby title="例"
a = [ "a", "b", "c" ]
a.reverse_each {|x| print x, " " }
# => c b a
```

- **SEE** [m:Array#each]

### def rindex(val)           -> Integer | nil
### def rindex {|item| ... }  -> Integer | nil
#@since 1.9.1
### def rindex                -> Enumerator
#@else
### def rindex                -> Enumerable::Enumerator
#@end

指定された val と == で等しい最後の要素の位置を返します。
等しい要素がひとつもなかった時には nil を返します。

ブロックが与えられた時には、各要素を右(末尾)から順に引数としてブロックを実行し、
ブロックが真を返す最初の要素の位置を返します。
ブロックが真を返す要素がなかった時には nil を返します。

引数、ブロックのどちらも与えられなかった時には、自身と rindex から生成した
#@since 1.9.1
[c:Enumerator] オブジェクトを返します。
#@else
[c:Enumerable::Enumerator] オブジェクトを返します。
#@end

- **param** `val` -- オブジェクトを指定します。

```ruby title="例"
p [1, 0, 0, 1, 0].rindex(1)   #=> 3
p [1, 0, 0, 0, 0].rindex(1)   #=> 0
p [0, 0, 0, 0, 0].rindex(1)   #=> nil
p [0, 1, 0, 1, 0].rindex {|v| v > 0}   #=> 3
```

- **SEE** [m:Array#index]

### def shift -> object | nil
### def shift(n) -> Array

配列の先頭の要素を取り除いてそれを返します。
引数を指定した場合はその個数だけ取り除き、それを配列で返します。

空配列の場合、n が指定されていない場合は nil を、
指定されている場合は空配列を返します。
また、n が自身の要素数より少ない場合はその要素数の配列を
返します。どちらの場合も自身は空配列となります。

返す値と副作用の両方を利用して、個数を指定して配列を 2 分する簡単な方法として使えます。

- **param** `n` -- 自身から取り除きたい要素の個数を非負整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。
- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

- **raise** `ArgumentError` -- 引数に負の数を指定した場合に発生します。



```ruby title="例"
a = [0, 1, 2, 3, 4]
p a.shift            #=> 0
p a                  #=> [1, 2, 3, 4]

p [].shift           #=> nil
p [].shift(1)        #=> []
```

- **SEE** [m:Array#push], [m:Array#pop], [m:Array#unshift]

### def slice(nth)       -> object | nil

指定された自身の要素を返します。[m:Array#\[\]] と同じです。

- **param** `nth` -- 要素のインデックスを整数で指定します。[m:Array#\[\]] と同じです。

```ruby title="例"
p [0, 1, 2].slice(1)    #=> 1
p [0, 1, 2].slice(2)    #=> 2
p [0, 1, 2].slice(10)   #=> nil
```

### def slice(pos, len)  -> Array | nil
### def slice(range)     -> Array | nil

指定された自身の部分配列を返します。[m:Array#\[\]] と同じです。

- **param** `pos` -- [m:Array#\[\]] と同じです。

- **param** `len` -- [m:Array#\[\]] と同じです。

- **param** `range` -- [m:Array#\[\]] と同じです。

```ruby title="例"
p [0, 1, 2].slice(0, 2)    #=> [0, 1]
p [0, 1, 2].slice(2..3)    #=> [2]
p [0, 1, 2].slice(10, 1)   #=> nil
```

### def slice!(nth)       -> object | nil

指定した要素を自身から取り除き、取り除いた要素を返します。取り除く要素がなければ nil
を返します。

- **param** `nth` -- 取り除く要素のインデックスを整数で指定します。

```ruby title="例"
a = [ "a", "b", "c" ]
p a.slice!(1)   #=> "b"
p a             #=> ["a", "c"]
p a.slice!(-1)  #=> "c"
p a             #=> ["a"]
p a.slice!(100) #=> nil
p a             #=> ["a"]
```

### def slice!(start, len)  -> Array | nil
### def slice!(range)     -> Array | nil

指定した部分配列を自身から取り除き、取り除いた部分配列を返します。取り除く要素がなければ nil
を返します。

- **param** `start` -- 削除したい部分配列の先頭のインデックスを整数で指定します。

- **param** `len` -- 削除したい部分配列の長さを整数で指定します。

- **param** `range` -- 削除したい配列の範囲を [c:Range] オブジェクトで指定します。

```ruby title="例"
a = [ "a", "b", "c" ]
p a.slice!(1, 2)   #=> ["b", "c"]
p a                #=> ["a"]

a = [ "a", "b", "c" ]
p a.slice!(1, 0)   #=> []
p a                #=> [ "a", "b", "c" ]
```

### def sort                -> Array
### def sort!               -> self
### def sort {|a, b| ... }  -> Array
### def sort! {|a, b| ... } -> self

全ての要素を昇順にソートします。
要素同士の比較は <=> 演算子を使って行います。

sort は self を変更せず、ソートされた配列を生成して返します。
sort! は self を破壊的にソートし、self を返します。

ブロックとともに呼び出された時には、要素同士の比較をブロックを用いて行います。
ブロックに2つの要素を引数として与えて評価し、その結果で比較します。
ブロックは <=> 演算子と同様に整数を返すことが期待されています。つまり、
ブロックは第1引数が大きいなら正の整数、両者が等しいなら0、そして第1引数の方が小さいなら
負の整数を返さなければいけません。両者を比較できない時は nil を返します。

Array#sort, Array#sort! は安定ではありません (unstable sort)。
安定なソートが必要な場合は [m:Enumerable#sort_by] を使って工夫する必要があります。
詳しくは [m:Enumerable#sort_by] の項目を参照してください。

※ 比較結果が同じ要素は元の順序通りに並ぶソートを
「安定なソート (stable sort)」と言います。

```ruby title="例"
ary1 = [ "d", "a", "e", "c", "b" ]
p ary1.sort                             #=> ["a", "b", "c", "d", "e"]

ary2 = ["9", "7", "10", "11", "8"]
p ary2.sort                             #=> ["10", "11", "7", "8", "9"] (文字列としてソートするとこうなる)
p ary2.sort{|a, b| a.to_i <=> b.to_i }  #=> ["7", "8", "9", "10", "11"] (ブロックを使って数字としてソート)

# sort_by を使っても良い
p ary2.sort_by{|x| x.to_i }             #=> ["7", "8", "9", "10", "11"]
```

- **SEE** [m:Enumerable#sort_by]
#@since 1.9.2
     , [m:Array#sort_by!]
#@end

#@since 1.9.2
### def sort_by!               -> Enumerator
### def sort_by! {|item| ... } -> self
sort_by の破壊的バージョンです。

ブロックを省略した場合は [c:Enumerator] を返します。

Array#sort_by! は安定ではありません (unstable sort)。

```ruby title="例"
fruits = %w{apple pear fig}
fruits.sort_by! { |word| word.length }
p fruits # => ["fig", "pear", "apple"]
```

- **SEE** [m:Enumerable#sort_by]
#@end

### def take(n)               -> Array

配列の先頭から n 要素を配列として返します。
このメソッドは自身を破壊的に変更しません。

- **param** `n` -- 要素数を指定します。

```ruby title="例"
a = [1, 2, 3, 4, 5, 0]
p a.take(3)           # => [1, 2, 3]
```

- **SEE** [m:Enumerable#take]

### def take_while                    -> Enumerator
### def take_while {|element| ... }   -> Array

配列の要素を順に偽になるまでブロックで評価します。
最初に偽になった要素の手前の要素までを配列として返します。
このメソッドは自身を破壊的に変更しません。

```ruby title="例"
a = [1, 2, 3, 4, 5, 0]
p a.take_while {|i| i < 3 } # => [1, 2]
```

ブロックを省略した場合は [c:Enumerator] を返します。

- **SEE** [m:Enumerable#take_while]

### def to_a       -> Array

self を返します。ただし、Array のサブクラスのインスタンスに対して呼ばれた時は、
自身を Array に変換したものを返します。

```ruby title="例"
class SubArray < Array; end
ary1 = Array([1, 2, 3, 4])
ary2 = SubArray([1, 2, 3, 4])

p ary1.to_a      # => [1, 2, 3, 4]
p ary1.to_a.class  # => Array

p ary2.to_a      # => [1, 2, 3, 4]
p ary2.to_a.class  # => Array
```

- **SEE** [m:Array#to_ary]

### def to_ary  -> self

self をそのまま返します。

```ruby title="例"
class SubArray < Array; end
ary1 = Array([1, 2, 3, 4])
ary2 = SubArray([1, 2, 3, 4])

p ary1.to_ary      # => [1, 2, 3, 4]
p ary1.to_ary.class  # => Array

p ary2.to_ary      # => [1, 2, 3, 4]
p ary2.to_ary.class  # => SubArray
```

- **SEE** [m:Array#to_a]

#@since 1.9.1
### def to_s    -> String
### def inspect -> String

自身の情報を人間に読みやすい文字列にして返します。

```ruby title="例"
p [1, 2, 3, 4].to_s  # => "[1, 2, 3, 4]"
p [1, 2, 3, 4].inspect # => "[1, 2, 3, 4]"
```

#@else
### def to_s    -> String

[m:Array#join]([m:$,]) と同じです。

```ruby title="例"
p [1, 2, 3, 4].to_s  # => "1234"
```

### def inspect -> String

自身の情報を人間に読みやすい文字列にして返します。

```ruby title="例"
p [1, 2, 3, 4].inspect # => "[1, 2, 3, 4]"
```
#@end

#@since 2.1.0
### def to_h -> Hash
#@since 2.6.0
### def to_h { block } -> Hash
#@end

self を [key, value] のペアの配列として解析した結果を [c:Hash] にして
返します。

```ruby title="例"
p [[:foo, :bar], [1, 2]].to_h # => {:foo => :bar, 1 => 2}
```

#@since 2.6.0
ブロックを指定すると配列の各要素でブロックを呼び出し、
その結果をペアとして使います。

```ruby title="ブロック付きの例"
p ["foo", "bar"].to_h {|s| [s.ord, s]} # => {102=>"foo", 98=>"bar"}
```
#@end

#@end

### def transpose    -> Array

自身を行列と見立てて、行列の転置(行と列の入れ換え)を行いま
す。転置した配列を生成して返します。空の配列に対しては空の配列を生
成して返します。

それ以外の一次元の配列に対しては、例外
[c:TypeError] が発生します。各要素のサイズが不揃いな配列に対して
は、例外 [c:IndexError] が発生します。

```ruby title="例"
p [[1,2],
   [3,4],
   [5,6]].transpose
# => [[1, 3, 5], [2, 4, 6]]

p [].transpose
# => []

p [1,2,3].transpose

#@since 3.4
# => -:1:in 'transpose': cannot convert Fixnum into Array (TypeError)
#@else
# => -:1:in `transpose': cannot convert Fixnum into Array (TypeError)
#@end
#       from -:1

p [[1,2],
   [3,4,5],
   [6,7]].transpose
#@since 3.4
# => -:3:in 'transpose': element size differ (3 should be 2) (IndexError)
#@else
# => -:3:in `transpose': element size differ (3 should be 2) (IndexError)
#@end
```

### def uniq     -> Array
### def uniq!    -> self | nil
### def uniq {|item| ... } -> Array
### def uniq! {|item| ... } -> self | nil

uniq は配列から重複した要素を取り除いた新しい配列を返します。
uniq! は削除を破壊的に行い、削除が行われた場合は self を、
そうでなければnil を返します。

取り除かれた要素の部分は前に詰められます。
要素の重複判定は、[m:Object#eql?] により行われます。

```ruby title="例"
p [1, 1, 1].uniq         # => [1]
p [1, 4, 1].uniq         # => [1, 4]
p [1, 3, 2, 2, 3].uniq   # => [1, 3, 2]
```

ブロックが与えられた場合、ブロックが返した値が重複した要素を取り除いた
配列を返します。

```ruby title="例"
p [1, 3, 2, "2", "3"].uniq                # => [1, 3, 2, "2", "3"]
p [1, 3, 2, "2", "3"].uniq { |n| n.to_s } # => [1, 3, 2]
```

要素を先頭から辿っていき、最初に出現したものが残ります。

### def unshift(*obj)        -> self
#@since 2.5.0
### def prepend(*obj)        -> self
#@end

指定された obj を引数の最後から順番に配列の先頭に挿入します。
引数を指定しなければ何もしません。

- **param** `obj` -- 自身に追加したいオブジェクトを指定します。

```ruby title="例"
arr = [1,2,3]
arr.unshift 0
p arr             #=> [0, 1, 2, 3]
arr.unshift [0]
p arr             #=> [[0], 0, 1, 2, 3]
arr.unshift 1, 2
p arr             #=> [1, 2, [0], 0, 1, 2, 3]
```

- **SEE** [m:Array#push], [m:Array#pop], [m:Array#shift]

### def values_at(*selectors)    -> Array

引数で指定されたインデックスに対応する要素を配列で返します。インデッ
クスに対応する値がなければ nil が要素になります。

- **param** `selectors` -- インデックスを整数もしくは整数の [c:Range] で指定します。
#@until 2.0.0
       [c:Range] の場合は、[m:Range#begin] が配列のサイズを越える場合は無視され、
       [m:Range#end] が配列のサイズを越えるまで対応する要素が選択されます。
       ちょうど配列のサイズを指す場合は、nil で埋められます。
#@end

```ruby title="例"
ary = %w( a b c d e )
p ary.values_at( 0, 2, 4 )          #=> ["a", "c", "e"]
p ary.values_at( 3, 4, 5, 6, 35 )   #=> ["d", "e", nil, nil, nil]
p ary.values_at( 0, -1, -2 )        #=> ["a", "e", "d"]
p ary.values_at( -4, -5, -6, -35 )  #=> ["b", "a", nil, nil]
p ary.values_at( 1..2 )             #=> ["b", "c"]
#@since 2.0.0
p ary.values_at( 3..10 )            #=> ["d", "e", nil, nil, nil, nil, nil, nil]
p ary.values_at( 6..7 )             #=> [nil, nil]
#@else
p ary.values_at( 3..10 )            #=> ["d", "e", nil]
p ary.values_at( 6..7 )             #=> []
#@end
p ary.values_at( 0, 3..5 )          #=> ["a", "d", "e", nil]
```

#@# ([[m:Array#indexes]], [[m:Array#indices]] と同じです)


### def zip(*lists)  -> [[object]]
### def zip(*lists) {|v1, v2, ...| ...} -> nil

自身と引数に渡した配列の各要素からなる配列の配列を生成して返します。
生成される配列の要素数は self の要素数と同じです。

ブロック付きで呼び出した場合は、
self と引数に渡した配列の各要素を順番にブロックに渡します。

- **param** `lists` -- 配列を指定します。
#@since 1.9.1
             配列以外のオブジェクトを指定した場合は to_ary メソッドによ
             る暗黙の型変換を試みます。to_ary メソッドに応答できない場
             合は each メソッドによる暗黙の型変換を試みます。

#@since 2.0.0
- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。
#@else
- **raise** `NoMethodError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェク
                     トを指定した場合に発生します。
#@end

#@else
```text
配列以外のオブジェクトを指定した場合は
[[m:Enumerable#zip]] とは異なり、to_ary メソッドによる暗黙
の型変換を試みます。
```

- **raise** `TypeError` -- 引数に配列以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。
#@end

```ruby title="例"
p [1,2,3].zip([4,5,6], [7,8,9])
# => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]

p [1,2].zip([:a,:b,:c], [:A,:B,:C,:D])
# => [[1, :a, :A], [2, :b, :B]]

p [1,2,3,4,5].zip([:a,:b,:c], [:A,:B,:C,:D])
# => [[1, :a, :A], [2, :b, :B],
#     [3, :c, :C], [4, nil, :D], [5, nil, nil]]

p [1,2,3].zip([4,5,6], [7,8,9]) { |ary| p ary }
# => [1, 4, 7]
#    [2, 5, 8]
#    [3, 6, 9]
#    nil
```

#@if (version == "1.8.7")
### def choice        -> object | nil

配列の要素を1個ランダムに選んで返します。

配列が空の場合は nil を返します。

srand()が有効です。

このメソッドは Ruby 1.8.7 と Ruby 1.9.0 にしか存在しないメソッドです。
Ruby 1.9.1 以降では Array#sample を使ってください。

```ruby title="例"
a = (1..10).to_a
p a.choice        #=>  9
p a.choice        #=> 10
p a               #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```
#@end

### def sample        -> object | nil
### def sample(n)     -> Array
### def sample(random: Random)    -> object | nil
### def sample(n, random: Random) -> Array

配列の要素を1個(引数を指定した場合は自身の要素数を越えない範囲で n 個)
ランダムに選んで返します。

重複したインデックスは選択されません。そのため、自身がユニークな配列の
場合は返り値もユニークな配列になります。

配列が空の場合、無引数の場合は nil を、個数を指定した場合は空配列を返します。

srand()が有効です。

- **param** `n` -- 取得する要素の数を指定します。自身の要素数(self.length)以上の
         値を指定した場合は要素数と同じ数の配列を返します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **param** `random` -- 乱数生成器(主に [c:Random] オブジェクト)を指定します。
              選択する要素のインデックスを返す rand メソッドに応答する
              オブジェクトであれば指定する事ができます。rand メソッド
              の引数には [m:Random#rand](max) のように選択可能なイン
              デックスの最大値が指定されます。
              [m:Kernel?.rand]、[c:Random] を使用しないオブジェク
              トを指定した場合、[m:Kernel?.srand]の指定に影響されません。

- **raise** `TypeError` -- 引数 n に整数以外の(暗黙の型変換が行えない)オブジェク
                 トを指定した場合に発生します。

- **raise** `ArgumentError` -- 引数 n に負の数を指定した場合に発生します。

```ruby title="例"
a = (1..10).to_a
p a.sample        #=>  9
p a.sample        #=> 10
p a.sample(3)     #=> [1, 9, 3]
p a               #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

random [c:SecureRandom] などの乱数生成器を渡すことができます。

```ruby title="例"
require 'securerandom'
a = (1..10).to_a
p a.sample(random: SecureRandom)  #=>  2
```

### def cycle(n=nil) {|obj| block } -> nil
#@since 1.9.1
### def cycle(n=nil) -> Enumerator
#@else
### def cycle(n=nil) -> Enumerable::Enumerator
#@end

配列の全要素を n 回(nilの場合は無限に)繰り返しブロックを呼びだします。

ブロックを省略した場合は [c:Enumerator] を返します。

- **param** `n` -- 繰り返したい回数を整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = ["a", "b", "c"]
a.cycle {|x| puts x }  # print, a, b, c, a, b, c,.. forever.
```

### def shuffle -> Array
#@since 1.9.3
### def shuffle(random: Random) -> Array
#@end

配列の要素をランダムシャッフルして，その結果を配列として返します。

#@since 1.9.3
引数に [c:Random] オブジェクトを渡すことでそのオブジェクトが
生成する擬似乱数列を用いることができます。
#@end

```ruby title="例"
a = [ 1, 2, 3 ]           #=> [1, 2, 3]
p a.shuffle               #=> [2, 3, 1]
#@since 1.9.3
rng = Random.new
rng2 = rng.dup # RNGを複製
# 以下の2つは同じ結果を返す
[1,2,3].shuffle(random: rng)
[1,2,3].shuffle(random: rng2)
#@end
```

- **SEE** [m:Array#shuffle!]
### def shuffle!        -> self
### def shuffle!(random: Random) -> self

配列を破壊的にランダムシャッフルします。

- **param** `random` -- 乱数生成器(主に [c:Random] オブジェクト)を指定します。
              選択する要素のインデックスを返す rand メソッドに応答する
              オブジェクトであれば指定する事ができます。rand メソッド
              の引数には [m:Random#rand](max) のように選択可能なイン
              デックスの最大値が指定されます。
              [m:Kernel?.rand]、[c:Random] を使用しないオブジェク
              トを指定した場合、[m:Kernel?.srand]の指定に影響されま
              せん。

```ruby title="例"
a = [ 1, 2, 3 ]           #=> [1, 2, 3]
p a.shuffle!              #=> [2, 3, 1]
p a                       #=> [2, 3, 1]
```

- **SEE** [m:Array#shuffle]

### def combination(n) {|c| block }    -> self
#@since 1.9.1
### def combination(n)                 -> Enumerator
#@else
### def combination(n)                 -> Enumerable::Enumerator
#@end

サイズ n の組み合わせをすべて生成し、それを引数としてブロックを実行します。

得られる組み合わせの順序は保証されません。ブロックなしで呼び出されると、組み合わせ
#@since 1.9.1
を生成する [c:Enumerator] オブジェクトを返します。
#@else
を生成する [c:Enumerable::Enumerator] オブジェクトを返します。
#@end

- **param** `n` -- 生成される配列のサイズを整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [1, 2, 3, 4]
p a.combination(1).to_a  #=> [[1],[2],[3],[4]]
p a.combination(2).to_a  #=> [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
p a.combination(3).to_a  #=> [[1,2,3],[1,2,4],[1,3,4],[2,3,4]]
p a.combination(4).to_a  #=> [[1,2,3,4]]
p a.combination(0).to_a  #=> [[]]: one combination of length 0
p a.combination(5).to_a  #=> []  : no combinations of length 5
```

ブロックが与えられた場合、作成した配列の各要素を引数としてブロックを実
行して self を返します。

```ruby title="例"
a = [1, 2, 3, 4]
result = []
p a.combination(2) {|e| result << e} # => [1,2,3,4]
p result #=> [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]
```

#@since 1.9.2
- **SEE** [m:Array#permutation], [m:Array#repeated_combination]
#@else
- **SEE** [m:Array#permutation]
#@end

### def permutation(n = self.length) { |p| block }       -> self
#@since 1.9.1
### def permutation(n = self.length)                     -> Enumerator
#@else
### def permutation(n = self.length)                     -> Enumerable::Enumerator
#@end

サイズ n の順列をすべて生成し，それを引数としてブロックを実行します。

引数を省略した場合は配列の要素数と同じサイズの順列に対してブロックを実
行します。

得られる順列の順序は保証されません。ブロックなしで呼び出されると， 順列
#@since 1.9.1
を生成する [c:Enumerator] オブジェクトを返します。
#@else
を生成する [c:Enumerable::Enumerator] オブジェクトを返します。
#@end

- **param** `n` -- 生成する配列のサイズを整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [1, 2, 3]
p a.permutation.to_a   #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
p a.permutation(1).to_a  #=> [[1],[2],[3]]
p a.permutation(2).to_a  #=> [[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]]
p a.permutation(3).to_a  #=> [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
p a.permutation(0).to_a  #=> [[]]: one permutation of length 0
p a.permutation(4).to_a  #=> []  : no permutations of length 4
```

ブロックが与えられた場合、作成した配列の各要素を引数としてブロックを実
行して self を返します。

```ruby title="例"
a = [1, 2, 3]
result = []
p a.permutation(2) {|e| result << e} # => [1,2,3]
p result # => [[1,2],[1,3],[2,1],[2,3],[3,1],[3,2]]
```

#@since 1.9.2
- **SEE** [m:Array#combination], [m:Array#repeated_permutation]
#@else
- **SEE** [m:Array#combination]
#@end

### def product(*lists)    -> Array
#@since 1.9.2
### def product(*lists) { |e| ... }   -> self
#@end

レシーバの配列と引数で与えられた配列（複数可）のそれぞれから要素を1
個ずつとって配列とし，それらのすべての配列を要素とする配列を返します。

返される配列の長さは，レシーバと引数で与えられた配列の長さのすべての積にな
ります。


- **param** `lists` -- 配列。複数指定可能。

```ruby title="例"
p [1,2,3].product([4,5])   # => [[1,4],[1,5],[2,4],[2,5],[3,4],[3,5]]
p [1,2].product([1,2])     # => [[1,1],[1,2],[2,1],[2,2]]
p [1,2].product([3,4],[5,6]) # => [[1,3,5],[1,3,6],[1,4,5],[1,4,6],
                           #     [2,3,5],[2,3,6],[2,4,5],[2,4,6]]
p [1,2].product()          # => [[1],[2]]
p [1,2].product([])        # => []
```

#@since 1.9.2
ブロックが与えられた場合、作成した配列の各要素を引数としてブロックを実
行して self を返します。

```ruby title="例"
a = []
p [1,2,3].product([4,5]) {|e| a << e} # => [1,2,3]
p a # => [[1,4],[1,5],[2,4],[2,5],[3,4],[3,5]]
```
#@end


#@since 1.9.2
### def repeated_combination(n) { |c| ... } -> self
### def repeated_combination(n)             -> Enumerator

サイズ n の重複組み合わせをすべて生成し、それを引数としてブロックを実行
します。

得られる組み合わせの順序は保証されません。ブロックなしで呼び出されると、
組み合わせを生成する Enumerator オブジェクトを返します。

- **param** `n` -- 生成される配列のサイズを整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [1, 2, 3]
p a.repeated_combination(1).to_a  #=> [[1], [2], [3]]
p a.repeated_combination(2).to_a  #=> [[1,1],[1,2],[1,3],[2,2],[2,3],[3,3]]
p a.repeated_combination(3).to_a  #=> [[1,1,1],[1,1,2],[1,1,3],[1,2,2],[1,2,3],
                                #    [1,3,3],[2,2,2],[2,2,3],[2,3,3],[3,3,3]]
p a.repeated_combination(4).to_a  #=> [[1,1,1,1],[1,1,1,2],[1,1,1,3],[1,1,2,2],[1,1,2,3],
                                #    [1,1,3,3],[1,2,2,2],[1,2,2,3],[1,2,3,3],[1,3,3,3],
                                #    [2,2,2,2],[2,2,2,3],[2,2,3,3],[2,3,3,3],[3,3,3,3]]
p a.repeated_combination(0).to_a  #=> [[]] # one combination of length 0
```

ブロックが与えられた場合、作成した配列の各要素を引数としてブロックを実
行して self を返します。

```ruby title="例"
a = [1, 2, 3]
result = []
p a.repeated_combination(3) {|e| result << e} # => [1,2,3]
p result  #=> [[1,1,1],[1,1,2],[1,1,3],[1,2,2],[1,2,3],
        #    [1,3,3],[2,2,2],[2,2,3],[2,3,3],[3,3,3]]
```

- **SEE** [m:Array#repeated_permutation], [m:Array#combination]
### def repeated_permutation(n) { |p| ... } -> self
### def repeated_permutation(n)             -> Enumerator

サイズ n の重複順列をすべて生成し，それを引数としてブロックを実行します。

得られる順列の順序は保証されません。ブロックなしで呼び出されると， 順列
を生成する Enumerator オブジェクトを返します。

- **param** `n` -- 生成する配列のサイズを整数で指定します。
         整数以外のオブジェクトを指定した場合は to_int メソッドによる暗
         黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [1, 2]
p a.repeated_permutation(1).to_a  #=> [[1], [2]]
p a.repeated_permutation(2).to_a  #=> [[1,1],[1,2],[2,1],[2,2]]
p a.repeated_permutation(3).to_a  #=> [[1,1,1],[1,1,2],[1,2,1],[1,2,2],
                                #    [2,1,1],[2,1,2],[2,2,1],[2,2,2]]
p a.repeated_permutation(0).to_a  #=> [[]] # one permutation of length 0
```

ブロックが与えられた場合、作成した配列の各要素を引数としてブロックを実
行して self を返します。

```ruby title="例"
a = [1, 2]
result = []
p a.repeated_permutation(3) {|e| result << e} # => [1,2]
p result  #=> [[1,1,1],[1,1,2],[1,2,1],[1,2,2],
        #    [2,1,1],[2,1,2],[2,2,1],[2,2,2]]
```

- **SEE** [m:Array#repeated_combination], [m:Array#permutation]
### def keep_if {|item| ... } -> self
### def keep_if -> Enumerator

ブロックが真を返した要素を残し、偽を返した要素を自身から削除します。

```ruby title="例"
a = %w{ a b c d e f }
p a.keep_if {|v| v =~ /[aeiou]/} # => ["a", "e"]
p a # => ["a", "e"]
```

keep_if は常に self を返しますが、[m:Array#select!] は要素が 1 つ以上削除されれば self を、
1 つも削除されなければ nil を返します。

```ruby title="例"
a = %w{ a b c d e f }
p a.keep_if {|v| v =~ /[a-z]/ } # => ["a", "b", "c", "d", "e", "f"]
p a # => ["a", "b", "c", "d", "e", "f"]
```

ブロックが与えられなかった場合は、自身と keep_if から生成した
[c:Enumerator] オブジェクトを返します。

- **SEE** [m:Array#select!], [m:Array#delete_if]

### def select    -> Enumerator
#@since 2.6.0
### def filter    -> Enumerator
#@end
### def select {|item| ... }   -> [object]
#@since 2.6.0
### def filter {|item| ... }   -> [object]
#@end

各要素に対してブロックを評価した値が真であった要素を全て含む配列を
返します。真になる要素がひとつもなかった場合は空の配列を返します。

ブロックを省略した場合は [c:Enumerator] を返します。

```ruby title="例"
p [1,2,3,4,5].select                    # => #<Enumerator: [1, 2, 3, 4, 5]:select>
p [1,2,3,4,5].select { |num| num.even? }  # => [2, 4]
```
- **SEE** [m:Enumerable#select]
- **SEE** [m:Array#select!]

### def select! {|item| block } -> self | nil
### def select! -> Enumerator
#@since 2.6.0
### def filter! {|item| block } -> self | nil
### def filter! -> Enumerator
#@end

ブロックが真を返した要素を残し、偽を返した要素を自身から削除します。
変更があった場合は self を、
変更がなかった場合には nil を返します。

```ruby title="例"
a = %w{ a b c d e f }
p a.select! {|v| v =~ /[a-z]/ } # => nil
p a # => ["a", "b", "c", "d", "e", "f"]
```

ブロックが与えられなかった場合は、自身と select! から生成した
[c:Enumerator] オブジェクトを返します。

- **SEE** [m:Array#keep_if], [m:Array#reject!]

### def rotate(cnt = 1) -> Array

cnt で指定したインデックスの要素が先頭になる配列を新しく作成します。
cnt より前の要素は末尾に移動します。cnt に負の数を指定した場合、逆の操
作を行います。

- **param** `cnt` -- 先頭にする要素のインデックスを指定します。指定しなかった場合
           は 1 になります。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [ "a", "b", "c", "d" ]
p a.rotate       # => ["b", "c", "d", "a"]
p a              # => ["a", "b", "c", "d"]
p a.rotate(2)    # => ["c", "d", "a", "b"]
p a.rotate(-1)   # => ["d", "a", "b", "c"]
p a.rotate(-3)   # => ["b", "c", "d", "a"]
```

- **SEE** [m:Array#rotate!]
### def rotate!(cnt = 1) -> self

cnt で指定したインデックスの要素が先頭になるように自身の順番を変更しま
す。cnt より前の要素は末尾に移動します。cnt に負の数を指定した場合、逆
の操作を行います。

- **param** `cnt` -- 先頭にする要素のインデックスを指定します。指定しなかった場合
           は 1 になります。
           整数以外のオブジェクトを指定した場合は to_int メソッドによる
           暗黙の型変換を試みます。

- **raise** `TypeError` -- 引数に整数以外の(暗黙の型変換が行えない)オブジェクトを
                 指定した場合に発生します。

```ruby title="例"
a = [ "a", "b", "c", "d" ]
p a.rotate!      #=> ["b", "c", "d", "a"]
p a              #=> ["b", "c", "d", "a"]
p a.rotate!(2)   #=> ["d", "a", "b", "c"]
p a.rotate!(-3)  #=> ["a", "b", "c", "d"]
```

- **SEE** [m:Array#rotate]
#@end

#@since 2.0.0
### def bsearch { |x| ... } -> object | nil
### def bsearch             -> Enumerator

ブロックの評価結果で範囲内の各要素の判定を行い、条件を満たす値を二分探
索(計算量は O(log n))で検索します。要素が見つからない場合は nil を返し
ます。self はあらかじめソートしておく必要があります。

本メソッドはブロックを評価した結果により以下のいずれかのモードで動作し
ます。

 - find-minimum モード
 - find-any モード

find-minimum モード(特に理由がない限りはこのモードを使う方がいいでしょ
う)では、条件判定の結果を以下のようにする必要があります。

 - 求める値がブロックパラメータの値か前の要素の場合: true を返す
 - 求める値がブロックパラメータより後の要素の場合: false を返す

ブロックの評価結果が true になる最初の要素を返すか、nil を返します。

```ruby title="例"
ary = [0, 4, 7, 10, 12]
p ary.bsearch {|x| x >=   4 } # => 4
p ary.bsearch {|x| x >=   6 } # => 7
p ary.bsearch {|x| x >=  -1 } # => 0
p ary.bsearch {|x| x >= 100 } # => nil
```

find-any モードは [man:bsearch(3)] のように動作します。ブロックは真偽値
ではなく、以下のような数値を返す必要があります。求める要素が配列の i 番目
から j-1 番目までに入っているとします。またブロックパラメータの値の
インデックスを k とします。

 - ブロックパラメータの値が求める値の範囲よりも小さい（0 <= k < i）場合: 正の数を返す
 - ブロックパラメータの値が求める値の範囲に合致する（i <= k < j）場合: 0 を返す
 - ブロックパラメータの値が求める値の範囲よりも大きい（j <= k < self.size）場合: 負の数を返す

ブロックの評価結果が 0 になるいずれかの要素を返すか、nil を返します。

```ruby title="例"
ary = [0, 4, 7, 10, 12]
# 4 <= v < 8 になる要素を検索
p ary.bsearch {|x| 1 - x / 4 } # => 4 or 7
# 8 <= v < 10 になる要素を検索
p ary.bsearch {|x| 4 - x / 2 } # => nil
```

上記の 2 つのモードを混在して使用しないでください(ブロックの評価結果は
常に true/false、数値のいずれかを一貫して返すようにしてください)。
また、二分探索の各イテレーションで値がどのような順序で選ばれるかは
未規定です。

ブロックが与えられなかった場合は、 [c:Enumerator] のインスタンスを返します。

- **raise** `TypeError` -- ブロックの評価結果が true、false、nil、数値以外であっ
                 た場合に発生します。

#@end
#@if("2.0.0" <= version and version < "2.3.0")
- **SEE** [m:Range#bsearch], <https://magazine.rubyist.net/articles/0041/0041-200Special-note.html>
#@end
#@since 2.3.0
- **SEE** [m:Array#bsearch_index], [m:Range#bsearch], <https://magazine.rubyist.net/articles/0041/0041-200Special-note.html>

### def bsearch_index { |x| ... } -> Integer | nil
### def bsearch_index             -> Enumerator

ブロックの評価結果で範囲内の各要素の判定を行い、条件を満たす値の位置を
二分探索(計算量は O(log n))で検索します。要素が見つからない場合は nil
を返します。self はあらかじめソートしておく必要があります。

本メソッドは[m:Array#bsearch]と同様に、ブロックを評価した結果により2
つのモードで動作します。[m:Array#bsearch] との違いは見つかった要素自
身を返すか位置を返すかのみです。各モードのより詳細な違いについては
[m:Array#bsearch] を参照してください。

```ruby title="例: find-minimum モード"
ary = [0, 4, 7, 10, 12]
p ary.bsearch_index { |x| x >=   4 } # => 1
p ary.bsearch_index { |x| x >=   6 } # => 2
p ary.bsearch_index { |x| x >=  -1 } # => 0
p ary.bsearch_index { |x| x >= 100 } # => nil
```

```ruby title="例: find-any モード"
ary = [0, 4, 7, 10, 12]
# 4 <= v < 8 になる要素の位置を検索
p ary.bsearch_index { |x| 1 - x / 4 } # => 2
# 8 <= v < 10 になる要素の位置を検索
p ary.bsearch_index { |x| 4 - x / 2 } # => nil
```

- **SEE** [m:Array#bsearch]
#@end

#@since 2.4.0
### def max    -> object | nil
### def max(n) -> Array

最大の要素、もしくは最大の n 要素が降順に入った配列を返します。
全要素が互いに <=> メソッドで比較できることを仮定しています。

引数を指定しない形式では要素が存在しなければ nil を返します。
引数を指定する形式では、空の配列を返します。

```ruby title="例"
p [].max         #=> nil
p [].max(1)      #=> []
p [2, 5, 3].max  #=> 5
p [2, 5, 3].max(2) #=> [5, 3]
```

- **param** `n` -- 取得する要素数。

- **SEE** [m:Enumerable#max]

### def max {|a, b| ... }    -> object | nil
### def max(n) {|a, b| ... } -> Array

ブロックの評価結果で各要素の大小判定を行い、最大の要素、もしくは最大の
n 要素が降順に入った配列を返します。
引数を指定しない形式では要素が存在しなければ nil を返します。
引数を指定する形式では、空の配列を返します。

ブロックの値は、a > b のとき正、
a == b のとき 0、a < b のとき負の整数を、期待しています。

```ruby title="例"
p [].max {|a, b| a <=> b }  #=> nil
p [].max(1) {|a, b| a <=> b } #=> []

ary = %w(albatross dog horse)
p ary.max {|a, b| a.length <=> b.length }  #=> "albatross"
p ary.max(2) {|a, b| a.length <=> b.length } #=> ["albatross", "horse"]
```

- **param** `n` -- 取得する要素数。

- **SEE** [m:Enumerable#max]
#@end

#@since 2.4.0
### def min    -> object | nil
### def min(n) -> Array

最小の要素、もしくは最小の n 要素が昇順で入った配列を返します。
全要素が互いに <=> メソッドで比較できることを仮定しています。

引数を指定しない形式では要素が存在しなければ nil を返します。
引数を指定する形式では、空の配列を返します。

```ruby title="例"
p [].min         #=> nil
p [].min(1)      #=> []
p [2, 5, 3].min  #=> 2
p [2, 5, 3].min(2) #=> [2, 3]
```

- **param** `n` -- 取得する要素数。

- **SEE** [m:Enumerable#min]

### def min {|a, b| ... }    -> object | nil
### def min(n) {|a, b| ... } -> Array

ブロックの評価結果で各要素の大小判定を行い、最小の要素、もしくは最小の
n 要素が昇順で入った配列を返します。
引数を指定しない形式では要素が存在しなければ nil を返します。
引数を指定する形式では、空の配列を返します。

ブロックの値は、a > b のとき正、a == b のとき 0、
a < b のとき負の整数を、期待しています。

```ruby title="例"
p [].min {|a, b| a <=> b }  #=> nil
p [].min(1) {|a, b| a <=> b } #=> []

ary = %w(albatross dog horse)
p ary.min {|a, b| a.length <=> b.length }  #=> "dog"
p ary.min(2) {|a, b| a.length <=> b.length } #=> ["dog", "horse"]
```

- **param** `n` -- 取得する要素数。

- **SEE** [m:Enumerable#min]
#@end

#@since 2.7.0
### def minmax                 -> [object, object]
### def minmax{|a, b| ... }    -> [object, object]

自身の各要素のうち最小の要素と最大の要素を
要素とするサイズ 2 の配列を返します。

一つ目の形式は、各要素がすべて <=> メソッドを実装していることを仮定し
ています。二つ目の形式では、要素同士の比較をブロックを用いて行います。

```ruby title="例"
a = %w(albatross dog horse)
p a.minmax                               #=> ["albatross", "horse"]
p a.minmax{|a,b| a.length <=> b.length } #=> ["dog", "albatross"]
p [].minmax # => [nil, nil]
```

- **SEE** [m:Enumerable#minmax]

#@end

#@since 2.4.0
### def sum(init=0)                    -> object
### def sum(init=0) {|e| expr }        -> object

要素の合計を返します。例えば [e1, e2, e3].sum は init + e1 + e2 + e3 を返します。

ブロックが与えられた場合、加算する前に各要素にブロックが適用されます。

配列が空の場合、initを返します。

```ruby title="例"
p [].sum                           #=> 0
p [].sum(0.0)                      #=> 0.0
p [1, 2, 3].sum                    #=> 6
p [3, 5.5].sum                     #=> 8.5
p [2.5, 3.0].sum(0.0) {|e| e * e } #=> 15.25
[Object.new].sum                   #=> TypeError
```

配列の平均値は以下のように求められます。

```ruby title="例"
mean = ary.sum(0.0) / ary.length
```

init 引数を明示的に指名すると数値以外のオブジェクトにも使えます。

```ruby title="例"
p ["a", "b", "c"].sum("")          #=> "abc"
p [[1], [[2]], [3]].sum([])        #=> [1, [2], 3]
```

しかし、文字列の配列や配列の配列の場合 [m:Array#join] や [m:Array#flatten] の方が [m:Array#sum] よりも高速です。

```ruby title="例"
p ["a", "b", "c"].join             #=> "abc"
p [[1], [[2]], [3]].flatten(1)     #=> [1, [2], 3]
```

"+" メソッドが再定義されている場合、[m:Array#sum] は再定義を無視することがあります(例えば [m:Integer#+])。

- **SEE** [m:Enumerable#sum]
#@end
#@since 3.1
### def intersect?(other)   -> bool

other と共通の要素が少なくとも1個あれば true を、なければ false を返します。

```ruby title="例"
a = [ 1, 2, 3 ]
b = [ 3, 4, 5 ]
c = [ 5, 6, 7 ]
p a.intersect?(b) # => true
p a.intersect?(c) # => false
```
#@end
