外部イテレータを扱うためのライブラリです。

#@since 1.8.1
= class Generator < Object

include Enumerable

内部イテレータを外部イテレータに変えるためのクラスです。
実装に callcc を使っているので遅いです。

 * [[c:SyncEnumerator]]

例:

  require 'generator'
  
  # Generator from an Enumerable object
  g = Generator.new(['A', 'B', 'C', 'Z'])
  
  while g.next?
    puts g.next
  end
  
  # Generator from a block
  g = Generator.new { |g|
    for i in 'A'..'C'
      g.yield i
    end
  
    g.yield 'Z'
  }
  
  # The same result as above
  while g.next?
    puts g.next
  end

== Class Methods

--- new(enum = nil) -> Generator
--- new(enum = nil) {|g|  ... } -> Generator

[[c:Enumerable]] オブジェクトかブロックから Generator オブジェクトを生成します。

ブロックは生成した Generator オブジェクトをブロック引数として呼ばれます。

@param enum [[c:Enumerable]] をインクルードしたオブジェクトを与えます。
            enum とブロックを同時に与えた場合は、ブロックは無視されます。



== Instance Methods

--- current -> object

現在の位置にある要素を返します。next と違い位置は移動しません。

例:

  require 'generator'
  g = Generator.new(['A', 'B', 'C', 'Z'])
  p g.current # => 'A'
  p g.current # => 'A'

--- each {|e| ... } -> self

ジェネレータの要素を引数としてブロックを評価します。self を返します。

--- end? -> bool

次の要素がなく、ジェネレータが終わりに達しているなら真を返します。

--- index -> Integer
--- pos   -> Integer

現在の位置を返します。

例:

  require 'generator'
  g = Generator.new(['A', 'B', 'C', 'Z'])
  p g.pos     # => 0
  p g.next    # => 'A'
  p g.pos     # => 1

--- next -> object

現在の位置にある要素を返し、位置を1つ進めます。

@raise EOFError 次の要素が無い場合に発生します。

例:

  require 'generator'
  g = Generator.new() do |g|
        ['A', 'B', 'C', 'Z'].each{|s|
          g.yield s
        }
      end
  p g.next # => 'A'
  p g.next # => 'B'

--- next? -> bool

次の要素が存在するなら真を返します。

--- rewind -> self

ジェネレータを最初に巻き戻します。self を返します。

例:

  require 'generator'
  g = Generator.new() do |g|
        ['A', 'B', 'C', 'Z'].each{|s|
          g.yield s
        }
      end
  p g.next # => 'A'
  p g.next # => 'B'
  g.rewind
  p g.next # => 'A'

--- yield(val) -> self

val をジェネレータに渡します。
Generator.new() {|g|  ... } のブロックの中でしか呼ぶことができません。
ジェネレータに渡された val は next などで取り出すことができます。

例:

  require 'generator'
  g = Generator.new() do |g|
        n = 0
        loop do
          g.yield n
          n += 1
        end
      end
  p g.next # => 0
  p g.next # => 1
  p g.next # => 2
  g.rewind
  p g.next # => 0

= class SyncEnumerator < Object
include Enumerable

複数の [[c:Enumerable]] オブジェクトを並行して yield するためのクラスです。

例:

  require 'generator'
  
  s = SyncEnumerator.new([1,2,3], ['a', 'b', 'c'])
  
  # Yields [1, 'a'], [2, 'b'], and [3,'c']
  s.each { |row| puts row.join(', ') }

== Class Methods

--- new(*enums) -> SyncEnumerator

SyncEnumerator オブジェクトを生成します。

複数の [[c:Enumerable]] オブジェクトを与えます。
Enumerable オブジェクトのサイズは異なっていても構いません。

== Instance Methods

--- each {|elem| ... } -> self

与えられた Enumerable オブジェクトのそれぞれの要素の配列を引数として
ブロックを評価します。self を返します。

要素がある Enumerable オブジェクトがひとつでもあれば、評価を続けます。
要素のなくなった Enumerable オブジェクトの代わりに nil を配列の要素とします。
全ての Enumerable オブジェクトの要素がなくなるとそこで、ブロックの評価を止めます。

例:

  require 'generator'
  s = SyncEnumerator.new([1, 2, 3], ['a', 'b'], ['X'])
  s.each{|arry| p arry}
  
  # => 結果
  # [1, "a", "X"]
  # [2, "b", nil]
  # [3, nil, nil]

--- end?(i = nil) -> bool

SyncEnumerator が終わりに達している場合は真を返します。

i を与えた場合は、i 番目の Enumerable オブジェクトが終わりに
達している場合、真を返します。

--- length -> Integer
--- size   -> Integer

与えられた Enumerable オブジェクトの数を返します。
#@end

#@since 1.8.4
#@since 1.9.1
= reopen Enumerator
#@else
= reopen Enumerable::Enumerator
#@end

== Instance Methods
--- next -> object

現在の位置にある要素を返し、位置を一つ進めます。

@raise EOFError 次の要素が無い場合に発生します。

@see [[m:Generator#next]]


--- rewind -> self

内部で保持しているジェネレータを最初まで巻き戻します。

@see [[m:Generator#rewind]]
#@end
