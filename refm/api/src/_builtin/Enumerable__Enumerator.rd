#@since 1.8.4
= class Enumerable::Enumerator < Object

include Enumerable

each 以外のメソッド、つまり each_byte 等も enumerate できる
ようにするためのラッパークラス。

== Class Methods

--- new(obj, method = :each, *args)

オブジェクト obj について、 each の代わりに method という
名前のメソッドを使って繰り返すオブジェクトを生成して返します。
args を指定すると、 method の呼び出し時に渡されます。

例:

  str = "xyz"

  enum = Enumerable::Enumerator.new(str, :each_byte)
  p enum.map {|b| '%02x' % b }   # => ["78", "79", "7a"]

== Methods

--- each {...}

生成時のパラメータに従って繰り返します。

#@since 1.9.0
#@# bc-rdoc: detected missing name: to_splat
--- to_splat
#@# => array

Convert this enumerator object to an array to splat.

#@# bc-rdoc: detected missing name: with_index
--- with_index {|(*args), idx| ... }

Iterates the given block for each elements with an index, which
start from 0.
#@end

= reopen Object

== Methods

--- to_enum(method = :each, *args)
--- enum_for(method = :each, *args)

Enumerable::Enumerator.new(self, method, *args) を返します。

例:

  str = "xyz"

  enum = str.enum_for(:each_byte)
  a = enum.map {|b| '%02x' % b } #=> ["78", "79", "7a"]

  # protects an array from being modified
  a = [1, 2, 3]
  some_method(a.to_enum)



= reopen Enumerable

== Methods

--- each_slice(n) {...}

n 要素ずつにわけてブロックに渡して繰り返します。

例:

  (1..10).each_slice(3) {|a| p a}
      # => [1, 2, 3]
      #    [4, 5, 6]
      #    [7, 8, 9]
      #    [10]

--- enum_slice(n)

Enumerable::Enumerator.new(self, :each_slice, n) を返します。

--- each_cons(n) {...}

連続した n 要素ずつの配列をブロックに渡して繰り返す。

例:

  (1..10).each_cons(3) {|a| p a}
      # => [1, 2, 3]
      #    [2, 3, 4]
      #    [3, 4, 5]
      #    [4, 5, 6]
      #    [5, 6, 7]
      #    [6, 7, 8]
      #    [7, 8, 9]
      #    [8, 9, 10]

--- enum_cons(n)

Enumerable::Enumerator.new(self, :each_cons, n) を返します。

--- enum_with_index

Enumerable::Enumerator.new(self, :each_with_index) を返します。
#@end
