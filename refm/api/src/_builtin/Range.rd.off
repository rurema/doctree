= class Range < Object

include Enumerable

範囲オブジェクトのクラス。範囲オブジェクトは範囲演算子 .. または
... によって生成されます。.. 演算子によって生成された範囲
オブジェクトは終端を含み、... 演算子によって生成された範囲オブジェ
クトは終端を含みません。

例:

  for i in 1..5
     ...
  end

これは 1 から 5 までの範囲オブジェクトを生成して、それぞれの値に対して
繰り返すと言う意味です。

範囲演算子のオペランドは互いに <=> で比較できる必要があります。
さらに [[m:Range#each]] を実行するためには succ メソッ
ドを実行できるものでなければいけません。

== Class Methods

--- new(first,last[, exclude_end])

first から last までの範囲オブジェクトを生成して返しま
す。exclude_end が真ならば終端を含まない範囲オブジェクトを生
成します。exclude_end 省略時には終端を含みます。

生成時に、引数の正当性チェックとして

  first <=> last

を実行します。これが nil を返す場合、例外
[[c:ArgumentError]] が発生します。

== Instance Methods

--- ===(other)
--- include?(other)

other が範囲内に含まれている時に真を返します。=== は
主に [[unknown:制御構造/case]] 文での比較に用いられます。

#@if (version >= "1.7.0")
include? が、[[m:Enumerable#include?]],
[[m:Enumerable#member?]] と異なり <=> メソッド
による演算により範囲内かどうかを判定することに注意する必要がありま
す。(1.6 までは、include? と member? ともに Enumerable のメソッドでした)

  p (0.1 .. 0.2).include?(0.15) # => true
  p (0.1 .. 0.2).member?(0.15)  # => cannot iterate from Float (TypeError)
  
  # 文字列の場合、include? は辞書順の比較になる
  p ("a" .. "c").include?("ba") # => true
  p ("a" .. "c").member?("ba")  # => false
#@end

--- begin
--- first

最初の要素を返します。

--- each {|item|  ... }

範囲内の要素に対して繰り返します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): Range#each は各要素の succ メソッドを使用
してイテレーションするようになりました。1.6 までは、Numeric オブ
ジェクトは、特別に算術演算で行われていました。この変更により Float
の Range の扱いが変わります(Float は、succ を持たない)。

  (1.0 .. 2.0).each {|v| p v}
  => ruby 1.6.7 (2002-03-01) [i586-linux]
  1
  2
  => -:1:in `each': cannot iterate from Float (TypeError)
     from -:1
     ruby 1.7.3 (2002-09-02) [i586-linux]
#@end

--- end
--- last

終端を返します。範囲オブジェクトが終端を含むかどうかは関係ありませ
ん。

  p (1..5).end   # => 5
  p (1...5).end  # => 5

--- exclude_end?

範囲オブジェクトが終端を含まないとき真を返します。

--- length
--- size

範囲の長さを返します。
始点と終端が Integer のインスタンスなら
        (last - first + (exclude_end? ? 0 : 1))
です。それ以外では、each が実行され範囲の長さを数えます。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): length, size メソッドはなくなりました。
必要なら
  p ("a" .. "z").to_a.size
  => 26
などとする必要があります。
#@end

#@if (version >= "1.7.0")
--- step([s]) {|item| ... }

((<ruby 1.7 feature>))
範囲内の要素を s おきに繰り返します。s には正の整数を
指定します。デフォルトは 1 です。
#@#((-あらい 2002-01-13: もちろん [[c:Numeric]] のサブクラスであれば
#@#item + s が動作しなければならない。それ以外では succ
#@#を s 回実行する。-))

  ("a" .. "f").step(2) {|v| p v}
  # => "a"
       "c"
       "e"
#@end
