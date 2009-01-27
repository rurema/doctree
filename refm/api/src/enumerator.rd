#@until  1.9.1
each 以外のメソッドも enumerate できるようにするライブラリです。

#@since 1.8.7
このライブラリは後方互換性のためにのみ提供されています。

ruby-1.8.7 より [[c:Enumerable::Enumerator]] は組み込みクラスになりました。
require 'enumerator' を実行しても false を返すだけで何もしません。

#@else
#@include(_builtin/Enumerable__Enumerator)

#@since 1.8.4
= reopen Enumerable

== Instance Methods

--- each_slice(n) {|list| ... } -> nil

n 要素ずつブロックに渡して繰り返します。
要素数が n で割り切れないときは、
最後の回だけ要素数が減ります。

nil を返します。

@arg n   区切る要素数を示す整数です。

例:

  (1..10).each_slice(3) {|a| p a}
      # => [1, 2, 3]
      #    [4, 5, 6]
      #    [7, 8, 9]
      #    [10]

@see [[m:Enumerable#each_cons]]

--- each_cons(n) {|list| ... } -> nil

要素を重複ありで n 要素ずつに区切り、
ブロックに渡して繰り返します。

nil を返します。

@arg n   区切る要素数を示す整数です。

例:

  [1, 2, 3, 4, 5].each_cons(3) {|a| p a }
      # => [1, 2, 3]
      #    [2, 3, 4]
      #    [3, 4, 5]

@see [[m:Enumerable#each_slice]]

--- enum_slice(n) -> Enumerable::Enumerator

n 要素ずつ繰り返す Enumerator を返します。
Enumerable::Enumerator.new(self, :each_slice, n) と同じです。

@arg n   区切る要素数を示す整数です。
@see [[m:Enumerable#each_cons]]

--- enum_cons(n) -> Enumerable::Enumerator

要素を重複ありで n 要素ずつに区切って繰り返す Enumerator を返します。

Enumerable::Enumerator.new(self, :each_cons, n) を返します。

@arg n   区切る要素数を示す整数です。
@see [[m:Enumerable#each_slice]]

--- enum_with_index -> Enumerable::Enumerator

要素とそのインデックスに対して繰り返す Enumerator を返します。
Enumerable::Enumerator.new(self, :each_with_index) と同じです。

@see [[m:Enumerable#each_with_index]]

#@end
#@end
#@end
