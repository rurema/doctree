= class Array < Object
include Enumerable

配列クラス。配列の要素は任意の Ruby オブジェクトです。
一般的には配列は配列式を使って

  [1, 2, 3]

のように生成します。

== Class Methods

--- [](item,...)

引数を要素として持つ配列を生成します。

--- new([size[, val]])
#@if (version >= "1.7.0")
--- new(ary)
#@end
--- new(size) {|index| ... }

配列を生成します。size を指定したときにはその大きさの配列を
生成し nil で初期化します。第二引数 val も指定したとき
には nil の代わりにそのオブジェクトを全要素にセットします。
(要素毎に val が複製されるわけではないことに注意してください。
全要素が同じオブジェクト val を参照します[[trap:Array]])。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): 二番目の形式では引数に指定した配列を複製し
て返します。

    p Array.new([1,2,3]) # => [1,2,3]
#@end

三番目の形式では、ブロックの評価結果で値を設定します。ブロックは要
素毎に実行されるので、全要素をあるオブジェクトの複製にすることがで
きます。

    p Array.new(5) {|i| i }         # => [0, 1, 2, 3, 4]

    ary = Array.new(3, "foo")
    ary.each {|obj| p obj.object_id }
    # => 537774036
         537774036
         537774036

    ary = Array.new(3) { "foo" }
    ary.each {|obj| p obj.object_id }
    # => 537770448
         537770436
         537770424

== Instance Methods

--- [](nth)

nth 番目の要素を返します。先頭の要素が 0 番目になります。
nth の値が負の時には末尾からのインデックスと見倣します(末尾
の要素が -1 番目)。nth 番目の要素が存在しない時には
nil を返します。

--- [](start..end)

start 番目の要素から end 番目の要素までの部分配列を返
します。start の値が負の時には末尾からのインデックスと見倣し
ます(末尾の要素が -1 番目)。start の値が配列の範囲に収まらな
い場合 nil を返します。end の値が配列の長さを越える時
には、越えた分の長さは無視されます。また、範囲の始点が終点よりも大
きい時には nil を返します。

--- [](start, length)

start 番目から length 個の要素を含む部分配列を返します。
start の値が負の時には末尾からのインデックスと見倣します(末
尾の要素が -1 番目)。length が start 番目からの配列の
長さより長い時には、越えた分の長さは無視されます。length が
負の時には nil を返します。

--- []=(nth, val)

nth 番目の要素を val に設定します。nth が配列の
範囲を越える時には配列の長さを自動的に拡張し、拡張した領域を
nil で初期化します。

val を返します。

--- []=(start..end, val)

start 番目の要素から end 番目の要素までを配列
val の内容に置換します。val の値が配列でないときには
val で置換します。val の要素の数の方が多い時には、後ろ
の要素がずれます。

val が nil か 空の配列 [] なら start から
end までの要素が削除されます。

例:

    ary = [0, 1, 2, 3, 4, 5]
    ary[0..2] = ["a", "b"]
    p ary

    # => ["a", "b", 3, 4, 5]

    ary[2..4] = nil
    p ary

    # => ["a", "b"]

val を返します。

--- []=(start, length, val)

インデックス start から length 個の要素を配列
val の内容で置き換えます。val が配列でないときには
val.to_ary もしくは [val] の内容で置換します。
val を返します。

例:
    ary = [0, 1, 2, 3]
    ary[1, 2] = ['a', 'b', 'c']
    p ary                        # => [0, "a", "b", "c", 3]
    ary[2, 1] = 99
    p ary                        # => [0, "a", 99, "c", 3]
    ary[1, 0] = ['inserted']
    p ary                        # => [0, "inserted", "a", 99, "c", 3]

--- +(other)

self と other の内容を繋げた新しい配列を返します。
other が配列でなければ other.to_ary の戻り値を用います。
その戻り値がまた配列でなかった場合は例外 [[c:TypeError]] が発生し
ます。

例:
    a = [1, 2]
    b = [8, 9]
    p a + b     #=> [1, 2, 8, 9]
    p a         #=> [1, 2]        (変化なし)
    p b         #=> [8, 9]        (こちらも変化なし)

--- *(times)

配列の内容を繰り返した新しい配列を作成し返します。
値はコピーされないことに注意してください[[trap:Array]]。

例:

    p [1, 2, 3] * 3  #=> [1, 2, 3, 1, 2, 3, 1, 2, 3]

times が文字列なら、self.[[m:Array#join]](times) と同じ
動作をします。

    p [1,2,3] * ","
    # => "1,2,3"

--- -(other)

集合の差演算。self から other の要素を
取り除いた内容の新しい配列を返します。
重複する要素は取り除かれます。

other が配列でなければ to_ary メソッドによる
暗黙の型変換を試みます。

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): 要素の同一性は [[m:Object#===]] ではなく、[[m:Object#eql?]] による評価に変更されました。

((<ruby 1.8 feature>)): self中で重複していて、other中に存在していなかった要素は、その重複が保持されます。

    p([1, 2, 1, 3, 1, 4, 1, 5] - [2, 3, 4, 5])
    # => [1, 1, 1, 1]

    p([1, 2, 1, 3, 1, 4, 1, 5] - [1, 2, 3, 4, 5])
    # => []
#@end

--- &(other)

集合の積演算。両方の配列に含まれる要素からなる新しい配列を返
します。重複する要素は取り除かれます。
other が配列でなければ to_ary メソッドによる
暗黙の型変換を試みます。

要素の重複判定は、[[m:Object#eql?]] により行われます。
(処理の高速化のために内部で [[c:Hash]] を使用しているためです)

--- |(other)

集合の和演算。両方の配列にいずれかに含まれる要素を全て含む新し
い配列を返します。重複する要素は取り除かれます。
other が配列でなければ to_ary メソッドによる
暗黙の型変換を試みます。

要素の重複判定は、[[m:Object#eql?]] により行われます。

--- <<(obj)

obj を配列の末尾に追加します。Array#push と同じ効果です。

  ary = [1]
  ary << 2
  p ary      # [1, 2]

またこのメソッドは self を返すので、以下のように連続して
書くことができます。

  ary = [1]
  ary << 2 << 3 << 4
  p ary   #=> [1, 2, 3, 4]

--- <=>(other)

self と other の各要素をそれぞれ順に <=> で比較
して、self が大きい時に正、等しい時に 0、小さい時に負の整数
を返します。各要素が等しいまま、一方だけ配列の末尾に達した時は、よ
り短い配列の方が小さいとみなします。

--- ==(other)

self と other の各要素をそれぞれ順に == で比較し
て、全要素が等しければ真を返します。

--- assoc(key)

配列の配列を検索して、その 0 番目の要素が key に等しい最初の
要素を返します。比較は == 演算子を使って行われます。
該当する要素がなければ nil を返します。

例:
    ary = [[1,15], [2,25], [3,35]]
    p ary.assoc(2)           # => [2, 25]
    p ary.assoc(100)         # => nil
    p ary.assoc(15)          # => nil

[[m:Array#rassoc]] も参照してください。

--- at(pos)

配列の pos の位置にある要素を返します。
self[pos] と同じです。

--- clear

配列の要素をすべて削除して空にします。
self を返します。

例:
    ary = [1, 2]
    ary.clear
    p ary     #=> []

--- clone
--- dup

レシーバと同じ内容を持つ新しい配列を返します。clone は
frozen tainted singleton-class の情報も含めてコピーしますが、
dup は内容だけをコピーします。

またどちらのメソッドも要素それ自体のコピーはしません。
つまり「浅い(shallow)」コピーを行います。

例:
    ary = ['string']
    p ary             #=> ["string"]
    copy = ary.dup
    p copy            #=> ["string"]

    ary[0][0...3] = ''
    p ary             #=> ["ing"]
    p copy            #=> ["ing"]

--- collect! {|item| ..}
--- map! {|item| ..}

各要素を順番にブロックに渡して評価し、その結果で要素を
置き換えます。[[m:Enumerable#collect]] も参照。

self を返します。

例:
    ary = [1, 2, 3]
    ary.map! {|i| i * 3 }
    p ary   #=> [3, 6, 9]

--- compact
--- compact!

compact は self から nil である要素を取り除いた
新しい配列を返します。compact! は変更を破壊的に行い、変更が
行われた場合は self を、そうでなければ nil を返します。

例:
    ary = [1, nil, 2, nil, 3, nil]
    p ary.compact   #=> [1, 2, 3]
    p ary           #=> [1, nil, 2, nil, 3, nil]
    ary.compact!
    p ary           #=> [1, 2, 3]
    p ary.compact!  #=> nil

--- concat(other)

配列 other を self の末尾に(破壊的に)連結します。
self を返します。

例:
    array = [1, 2]
    a     = [3, 4]
    array.concat a
    p array          # => [1, 2, 3, 4]
    p a              # => [3, 4]       # こちらは変わらない

--- delete(val)
--- delete(val) { ... }

val と == で等しい要素をすべて取り除きます。
val と等しい要素が見つかった場合は、((*val*)) を返します。

valと等しい要素がなければ nil を返しますが、ブロックが
指定されていればブロックを評価してその結果を返します。

例:

    array = [1, 2, 3, 2, 1]
    p array.delete(2)       #=> 2
    p array                 #=> [1, 3, 1]

    # ブロックなしの引数に nil を渡すとその戻り値から削除が
    # 行われたかどうかの判定をすることはできない
    ary = [nil,nil,nil]
    p ary.delete(nil)       #=> nil
    p ary                   #=> []
    p ary.delete(nil)       #=> nil

--- delete_at(pos)

pos で指定された位置にある要素を取り除きそれを返します。
pos が範囲外であったら nil を返します。

[[m:Array#at]] と同様に負のインデックスで末尾から位置を指定するこ
とができます。

例:

    array = [0, 1, 2, 3, 4]
    array.delete_at 2
    p array             #=> [0, 1, 3, 4]

--- delete_if {|x| ... }
--- reject! {|x| ... }

要素を順番にブロックに渡して評価し、その結果が真になった要素を
すべて削除します。

delete_if は常に self を返しますが、reject! は要
素が 1 つ以上削除されれば self を、 1 つも削除されなければ nil を返します。

--- each {|item| .... }

各要素に対してブロックを評価します。self を返します。

例:

    # 1、2、3 が順番に表示される
    [1, 2, 3].each do |i|
      puts i
    end

each により(また、標準のメソッドで)複数の値を取得しながら繰り返す
ことはできません。現在のところ以下のようなメソッドを定義する必要が
あります。

例:

    class Array
      def every(&block)
        arity = block.arity
        return self.each(&block) if arity <= 0

        i = 0
        while i < self.size
          yield(*self[i, arity])
          i += arity
        end
        self
      end
    end

    ary = [1,2,3]
    ary.every {|i| p i}
    # => 1
    #    2
    #    3
    ary.every {|i,j| p [i,j]}
    # => [1, 2]
    #    [3, nil]
    ary.every {|i,j,k| p [i,j,k]}
    # => [1, 2, 3]
    ary.every {|*i| p *i}
    # => 1
    #    2
    #    3

--- each_index {|index| .... }

各要素のインデックスに対してブロックを評価します。
以下と同じです。

    (0 ... ary.size).each {|index| ....  }

self を返します。

--- empty?

配列の要素数が 0 の時真を返します。

--- eql?(other)

self と other の各要素をそれぞれ順に
[[m:Object#eql?]] で比較して、全要素が等しければ真を返
します。

--- fetch(nth)
--- fetch(nth, ifnone)
--- fetch(nth) {|nth| ... }

[[m:Array#[nth]]] と同様 nth 番目の要素を返しますが、
Array#[nth] とは nth 番目の要素が存在しない場合の振舞いが異
なります。

最初の形式では、例外 [[c:IndexError]] が発生します。
二番目の形式では、引数 ifnone を返します。
三番目の形式では、ブロックを評価した結果を返します。

Array#[nth] は、Array#fetch(nth, nil) と同じです。

--- fill(val)
--- fill(val, start[, length])
--- fill(val, start..end)
#@if (version >= "1.7.0")
--- fill {|index| ... }
--- fill(start[, length]) {|index| ... }
--- fill(start..end) {|index| ... }
#@end

配列の、指定された範囲すべてに val をセットします。二番目の
形式で length が省略された時は配列の終りまでの長さを意味しま
す。指定された部分配列が元の配列の範囲を越える時は長さを自動的に拡
張し、拡張した部分を val で初期化します。

このメソッドが val のコピーでなく val 自身をセットする
ことに注意してください([[trap:Array]])。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)):

val の代わりにブロックを指定するとブロックの評価結果を値とし
ます。ブロックは要素毎に実行されるので、セットする値のそれぞれをあ
るオブジェクトの複製にすることができます。
ブロックのパラメータには start からのインデックスが渡されます。

    ary = []
    p ary.fill(1..2) {|i| i}         # => [nil, 1, 2]
    p ary.fill(0,3) {|i| i}          # => [0, 1, 2]
    p ary.fill { "foo" }             # => ["foo", "foo", "foo"]
    p ary.collect {|v| v.object_id } # => [537770124, 537770112, 537770100]
#@end

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): version 1.8.0 には、ブロックに渡されるパラ
メータが仕様と異なる不具合がありました。

    ary = []
    p ary.fill(1..2) {|i| i}         # => [2, 4, 6]  <- bug
    p ary.fill(0,3) {|i| i}          # => [1, 3, 5]  <- bug
    p ary.fill { "foo" }             # => ["foo", "foo", "foo"]
    p ary.collect {|v| v.object_id } # => [537770124, 537770112, 537770100]
#@end

--- first
#@if (version >= "1.8.0")
--- first(n)
#@end
配列の先頭の要素を返します。要素がなければ nil を返します。

例:

    p [0, 1, 2].first   #=> 0
    p [].first          #=> nil

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)):
省略可能な引数 n を指定した場合、先頭の n 要素を配列で
返します。n は 0 以上でなければなりません。

    ary =  [0, 1, 2]
    p ary.first(0)
    p ary.first(1)
    p ary.first(2)
    p ary.first(3)
    p ary.first(4)
    # => []
         [0]
         [0, 1]
         [0, 1, 2]
         [0, 1, 2]
#@end
[[m:Array#last]] も参照してください。

--- flatten
--- flatten!

ネストした配列を平滑化してそれを返します。flatten! は
配列それ自体を破壊的に平滑化し、配列がネストしていないとき
には nil を返します。

例:

    p [1, [2, 3, [4], 5]].flatten   #=> [1, 2, 3, 4, 5]

    array = [[[1, [2, 3]]]]
    array.flatten!
    p array                         #=> [1, 2, 3]

--- include?(val)

配列が val と == において等しい要素を持つ時に真を返し
ます。

--- index(val)
#@if (version >= "1.9.0")
--- index {|item| ...}
#@end
最初の形式では、val と == で等しい最初の要素の位置を返
します。

#@if (version >= "1.9.0")
((<ruby 1.9 feature>)):
二番目の形式では、ブロックが真を返した最初の要素の位置を返します。
ブロック引数には、要素が順に渡されます。
#@end

等しい要素がひとつもなかった時には nil を返します。

例:
    p [1, 0, 0, 1, 0].index(1)   #=> 0
    p [1, 0, 0, 0, 0].index(1)   #=> 0
    p [0, 0, 0, 0, 0].index(1)   #=> nil
#@if (version >= "1.9.0")
    p [0, 1, 0, 1, 0].index {|v| v > 0}   #=> 1
#@end
[[m:Array#rindex]] も参照してください。

--- indexes(index_1, ... , index_n)     
--- indices(index_1, ... , index_n)     

各引数の値をインデックスとする要素の配列を返します。範囲外の
インデックス指定に対しては nil が対応します。

例:
    ary = %w( a b c d e )
    p ary.indexes( 0, 2, 4 )          #=> ["a", "c", "e"]
    p ary.indexes( 3, 4, 5, 6, 35 )   #=> ["d", "e", nil, nil]
    p ary.indexes( 0, -1, -2 )        #=> ["a", "e", "d"]
    p ary.indexes( -4, -5, -6, -35 )  #=> ["b", "a", nil, nil]
#@if (version >= "1.8.0")
((<ruby 1.8 feature>)):
このメソッドは version 1.8 では、((<obsolete>)) です。
使用すると警告メッセージが表示されます。
代わりに [[m:Array#values_at]] を使用します。
#@end

#@if (version >= "1.7.0")
--- insert(nth, val[, val2 ...])
--- insert(nth, [val[, val2 ...]])

((<ruby 1.7 feature>))

インデックス nth の要素の直前に第 2 引数以降の値を挿入します。
self を返します。以下のように定義されます。

    class Array
      def insert( n, *vals )
        self[n, 0] = vals
        self
      end
    end

例:
    ary = %w( foo bar baz )
    ary.insert 2, 'a', 'b'
    p ary                  # => ["foo", "bar", "a", "b", "baz"]
#@end
#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): 引数 val を一つも指定しなければ何もしません。
#@end

--- join([sep])

配列の要素を文字列 sep を間に挟んで連結した文字列を返します。

文字列でない要素に対しては to_s した結果を連結します。
要素がまた配列であれば再帰的に (同じ sep を利用して)
join した文字列を連結します。

sep が nil のときは空文字列を使います。

引数 sep が省略された場合には変数 [[m:$,]]
の値が使われます。$, のデフォルト値は nil です。

注: 配列要素が自身を含むような無限にネストした配列に対しては、以下
のような結果になります。

    ary = [1,2,3]
    ary.push ary
    p ary           # => [1, 2, 3, [...]]
    p ary.join      # => "123123[...]"

--- last
#@if (version >= "1.8.0")
--- last(n)
#@end
配列の末尾の要素を返します。配列が空のときは nil を返します。

    p [0, 1, 2].last   #=> 2
    p [].last          #=> nil

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)):
省略可能な引数 n を指定した場合、末尾の n 要素を配列で
返します。n は 0 以上でなければなりません。

    ary =  [0, 1, 2]
    p ary.last(0)
    p ary.last(1)
    p ary.last(2)
    p ary.last(3)
    p ary.last(4)
    # => []
         [2]
         [1, 2]
         [0, 1, 2]
         [0, 1, 2]
#@end

[[m:Array#first]] も参照してください。

--- length
--- size

配列の長さを返します。配列が空のときは 0 を返します。

--- nitems

nil でない要素の数を返します。

--- pack(template)

配列の内容を template で指定された文字列にしたがって、
バイナリとしてパックした文字列を返します。テンプレートは
型指定文字列とその長さ(省略時は1)を並べたものです。長さと
して * が指定された時は「残りのデータ全て」の長さを
表します。型指定文字は[[unknown:packテンプレート文字列]]の通りです。

--- pop

末尾の要素を取り除いてそれを返します。空配列の時は
nil を返します。

[[m:Array#push]], [[m:Array#shift]], [[m:Array#unshift]] も参照し
てください。

例:
      array = [1, [2, 3], 4]
      p array.pop      # => 4
      p array.pop      # => [2, 3]
      p array          # => [1]

      p array.pop      # => 1
      p array.pop      # => nil
      p array          # => []

--- push(obj1[, obj2 ...])
--- push([obj1[, obj2 ...]])

obj1, obj2 ... を順番に配列の末尾に追加します。

[[m:Array#pop]], [[m:Array#shift]], [[m:Array#unshift]] も参照して
ください。

self を返します。

例:
      array = [1, 2, 3]
      array.push 4
      array.push [5, 6]
      array.push 7, 8
      p array          # => [1, 2, 3, 4, [5, 6], 7, 8]
#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): 引数を指定しなければ何もしません。
#@end

--- rassoc(obj)

self が配列の配列であると仮定して、要素の配列でインデックス
1 の要素が obj に等しいものを検索し見つかった最初の要素を返
します。比較は == 演算子を使って行われます。

該当する要素がなければ nil を返します。

例:
    a = [[15,1], [25,2], [35,3]]
    p a.rassoc(2)    # => [25, 2]

[[m:Array#assoc]] も参照してください。

--- replace(another)

配列の内容を配列 another の内容で置き換えます。
self を返します。

例:
    a = [1, 2, 3]
    a.replace [4, 5, 6]
    p a                 #=> [4, 5, 6]

--- reverse
--- reverse!

reverse は全ての要素を逆順に並べた新しい配列を返します。
reverse! は配列の要素を逆順に(破壊的に)並べ替えます。

reverse は、常に新しい配列を返しますが、reverse!  は、
1 要素の配列に対して nil を返しそれ以外では self を返
します
#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): 常に self を返します。
#@end
--- reverse_each {|item| ... }

各要素に対して逆順にブロックを評価します。self を返します。

--- rindex(val)
#@if (version >= "1.9.0")
--- rindex {|item| ... }
#@end
最初の形式では、val と == で等しい((*最後*))の要素の位
置を返します。

#@if (version >= "1.9.0")
((<ruby 1.9 feature>)):
二番目の形式では、ブロックが真を返した((*最後*))の要素の位置を返し
ます。ブロック引数には、要素が順に渡されます。
#@end

等しい要素がひとつもなかった時には nil を返します。


例:
    p [1, 0, 0, 1, 0].rindex(1)   #=> 3
    p [1, 0, 0, 0, 0].rindex(1)   #=> 0
    p [0, 0, 0, 0, 0].rindex(1)   #=> nil
    p [0, 1, 0, 1, 0].rindex {|v| v > 0}   #=> 3

[[m:Array#index]] も参照してください。

--- shift

配列の先頭の要素を取り除いてそれを返します。残りの要素はひとつずつ
前に詰められます。空配列に対してはnil を返します。

[[m:Array#push]], [[m:Array#pop]], [[m:Array#unshift]] も参照して
ください。

--- slice(pos[, len])
--- slice(start..last)

[[m:Array#self[]]] と同じです。

--- slice!(pos[, len])
--- slice!(start..last)

指定した要素を取り除いて返します。取り除く要素がなければ nil
を返します。

--- sort
--- sort!
--- sort {|a, b| ... }
--- sort! {|a, b| ... }

配列の内容をソートします。ブロックとともに呼び出された時には
ブロックに 2 引数を与えて評価し、その結果で比較します。
ブロックがない時には <=> 演算子を使って比較します。
sort はソートされた新しい配列を返し、sort! は
self を破壊的に変更します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)):
sort! は、バージョン 1.6 以前には要素の数が 2 より小さい場合には
nil を返していました。一方バージョン 1.7 では常に self を
返します。
#@end

--- to_a
--- to_ary

self をそのまま返します。

--- to_s

self.[[m:Array#join]]([[m:$,]]) と同じです。

#@if (version >= "1.7.0")
--- transpose

((<ruby 1.7 feature>)):

self を行列と見立てて、行列の転置(行と列の入れ換え)を行いま
す。転置した配列を生成して返します。空の配列に対しては空の配列を生
成して返します。それ以外の一次元の配列に対しては、例外
[[c:TypeError]] が発生します。各要素のサイズが不揃いな配列に対して
は、例外 [[c:IndexError]] が発生します。

    p [[1,2],
       [3,4],
       [5,6]].transpose
    # => [[1, 3, 5], [2, 4, 6]]

    p [].transpose
    # => []

    p [1,2,3].transpose

    # => -:1:in `transpose': cannot convert Fixnum into Array (TypeError)
            from -:1

    p [[1,2],
       [3,4,5],
       [6,7]].transpose
    # => -:3:in `transpose': element size differ (3 should be 2) (IndexError)
#@end

--- uniq
--- uniq!

uniq は配列から重複した要素を取り除いた新しい配列を返します。
取り除かれた要素の部分は前に詰められます。uniq! は削除を破壊
的に行い、削除が行われた場合は self を、そうでなければ
nil を返します。

要素の重複判定は、[[m:Object#eql?]] により行われます。

例:
    p [1, 1, 1].uniq         #=> [1]
    p [1, 4, 1].uniq         #=> [1, 4]
    p [1, 3, 2, 2, 3].uniq   #=> [1, 3, 2]

--- unshift(obj1[, obj2 ...])
--- unshift([obj1[, obj2 ...]])

obj1, obj2 ... を順番に配列の先頭に挿入します。self を返します。

[[m:Array#push]], [[m:Array#pop]], [[m:Array#shift]] も参照してく
ださい。

例:
    arr = [1,2,3]
    arr.unshift 0
    p arr             #=> [0, 1, 2, 3]
    arr.unshift [0]
    p arr             #=> [[0], 0, 1, 2, 3]
    arr.unshift 1, 2
    p arr             #=> [1, 2, [0], 0, 1, 2, 3]

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): 引数を指定しなければ何もしません。
#@end

#@if (version >= "1.8.0")
--- values_at(index_1, ... , index_n)

((<ruby 1.8 feature>))

引数で指定されたインデックスに対応する要素を配列で返します。インデッ
クスに対応する値がなければ nil が要素になります。
([[m:Array#indexes]], [[m:Array#indices]] と同じです)

例:
    ary = %w( a b c d e )
    p ary.values_at( 0, 2, 4 )          #=> ["a", "c", "e"]
    p ary.values_at( 3, 4, 5, 6, 35 )   #=> ["d", "e", nil, nil, nil]
    p ary.values_at( 0, -1, -2 )        #=> ["a", "e", "d"]
    p ary.values_at( -4, -5, -6, -35 )  #=> ["b", "a", nil, nil]
#@end
