有理数のためのクラス。
rational を require すると [[c:Integer]] のメソッドが以下のように再定義される。

= reopen Kernel
== Instance Methods
--- Rational(a, b)
[[c:Rational]] オブジェクトを生成する。

= redefine Integer

== Instance Methods

--- /(other)

除算。

  * otherが有理数(Rational)ならば、有理数(Rational)を返す。
  * otherがそれ以外なら、[[m:Integer#/]]と同じ。つまり、
    other が整数(Integer)ならば、整数(Integer)を(整除)、浮動小数(Float)ならば、
    浮動小数(Float)を返す。
    ただし、いずれも、other == 0 の時は、[[c:ZeroDivisionError]]となる。

--- **(other)

べき乗。

  * otherが正または0の整数(Integer)ならば、整数(Integer)を返す。
  * otherが負の整数(Integer)ならば、有理数(Rational)を返す。
  * otherが有理数(Rational)や浮動小数(Float)ならば、浮動小数(Float)を返す。

--- power!(other)

[[m:Integer#**]]と同じ。
other が正または 0 の整数 (Integer) ならば、
整数 (Integer) を、それ以外なら、浮動小数 (Float) を返す。

--- to_r
対応する有理数 (Rational) を返す。
Rational(self, 1) と同じ。

--- gcd(n)

self と n の最大公約数を Fixnum として返す。
self や n が負の場合は、正に変換してから計算する。

--- lcm(n)

self と n の最小公倍数を返す。
self や n が負の場合は、正に変換してから計算する。

--- gcdlcm(int)

最大公約数と最小公倍数の配列 [self.gcd, self.lcm] を返します。


= class Rational < Numeric

include Comparable

Integer < Rational < Float の順に強いです。つまり other が Float なら、
self を Float に変換してから演算子を適用します。other が Integer なら other を
Rational に変換してから演算子を適用します。冪乗は例外です。

== Instance Methods

--- numerator

分子を Fixnum として返します。

--- denominator

分母を Fixnum として返します。

--- +(other)

和を計算します。

  Rational(3, 4) + 2               # => Rational(11, 4)
  Rational(3, 4) + Rational(2, 1)  # => Rational(11, 4)
  Rational(3, 4) + 2.0             # => 2.75

--- -(other)

差を計算します。

--- *(other)

積を計算します。

--- /(other)

商を計算します。
other が 0 の時は、例外 [[c:ZeroDivisionError]] を投げます。

  Rational(3, 4) / 2              # => Rational(3, 8)
  Rational(3, 4) / Rational(2, 1) # => Rational(3, 8)
  Rational(3, 4) / 2.0            # => 0.375

--- %(other)

剰余を計算します。絶対値が self の絶対値を越えない、符合が self と同じ
Numeric を返します。

  Rational(3, 4) % 2               # => Rational(3, 4)
  Rational(3, 4) % Rational(2, 1)  # => Rational(3, 4)
  Rational(3, 4) % 2.0             # => 0.75

--- **(other)

冪を計算します。

  Rational(3, 4) ** 2              # => Rational(9, 16)
  Rational(3, 4) ** Rational(2, 1) # => 0.5625
  Rational(3, 4) ** 2.0            # => 0.5625

--- divmod(other)

self を other で割った、商と余りの配列を返します。
商は Fixnum、余りは絶対値が other の絶対値を越えず、符合が other と同じ
Numeric です。[[m:Numeric#divmod]] も参照して下さい。

 Rational(3,4).divmod(Rational(2,3))  # => [1, Rational(1, 12)]
 Rational(-3,4).divmod(Rational(2,3)) # => [-2, Rational(7, 12)]
 Rational(3,4).divmod(Rational(-2,3)) # => [-2, Rational(-7, 12)]

 Rational(9,4).divmod(2)              # => [1, Rational(1, 4)]
 Rational(9,4).divmod(Rational(2, 1)) # => [1, Rational(1, 4)]
 Rational(9,4).divmod(2.0)            # => [1, 0.25]

--- abs

self が正なら self、負なら -1 * self を返します。

--- <=>(other)

other と比べて self が大きいなら 1、同じなら 0、小さいなら -1 を返します。

--- to_i

[[c:Fixnum]] に変換します。

--- to_f

[[c:Float]] に変換します。

--- to_s

文字列に変換します。

  Rational(-3,4).to_s # => "-3/4"
