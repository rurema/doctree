有理数のためのクラス。
rational を require すると [[c:Integer]] のメソッドが以下のように再定義される。

= reopen Kernel

== Module Functions

--- Rational(a, b)
#@todo
[[c:Rational]] オブジェクトを生成する。

Creates a Rational number (i.e. a fraction).  +a+ and +b+ should be Integers:
 
  Rational(1,3)           # -> 1/3

Note: trying to construct a Rational with floating point or real values
produces errors:

  Rational(1.1, 2.3)      # -> NoMethodError


= redefine Integer

== Instance Methods

--- /(other)
#@todo

除算。

  * otherが有理数(Rational)ならば、有理数(Rational)を返す。
  * otherがそれ以外なら、[[m:Integer#/]]と同じ。つまり、
    other が整数(Integer)ならば、整数(Integer)を(整除)、浮動小数(Float)ならば、
    浮動小数(Float)を返す。
    ただし、いずれも、other == 0 の時は、[[c:ZeroDivisionError]]となる。

--- **(other)
#@todo

べき乗。

  * otherが正または0の整数(Integer)ならば、整数(Integer)を返す。
  * otherが負の整数(Integer)ならば、有理数(Rational)を返す。
  * otherが有理数(Rational)や浮動小数(Float)ならば、浮動小数(Float)を返す。

  2 **  3          #=> 8
  2 ** -3          #=> Rational(1, 8)
  2 ** Rational(3) #=> 8.0

= reopen Integer

== Instance Methods

--- power!(other)
#@todo

[[lib:rational]]で再定義される前の[[m:Integer#**]]の別名。
other が正または 0 の整数 (Integer) ならば、
整数 (Integer) を、それ以外なら、浮動小数 (Float) を返す。

--- to_r
#@todo
対応する有理数 (Rational) を返す。
Rational(self, 1) と同じ。

--- gcd(n)
#@todo

self と n の最大公約数を Fixnum として返す。
self や n が負の場合は、正に変換してから計算する。

   72.gcd 168           # -> 24
   19.gcd 36            # -> 1

--- lcm(n)
#@todo

self と n の最小公倍数を返す。
self や n が負の場合は、正に変換してから計算する。

   6.lcm 7        # -> 42
   6.lcm 9        # -> 18

--- gcdlcm(int)
#@todo

最大公約数と最小公倍数の配列 [self.gcd, self.lcm] を返します。

   6.gcdlcm 9     # -> [3, 18]

--- numerator
#@todo
In an integer, the value is the numerator of its rational equivalent.
Therefore, this method returns self.

--- denominator
#@todo
In an integer, the denominator is 1.  Therefore, this method returns 1.


= redefine Fixnum
== Instance Methods

--- quo(other)
#@todo
If Rational is defined, returns a Rational number instead of a Fixnum.

--- **(other)
--- rpower (other)
#@todo
Returns a Rational number if the result is in fact rational (i.e. other < 0).

= reopen Fixnum
== Instance Methods
--- power!(other)
#@todo

= redefine Bignum
== Instance Methods
--- quo(other)
#@todo
If Rational is defined, returns a Rational number instead of a Bignum.

--- **(other)
--- rpower(other)
#@todo
Returns a Rational number if the result is in fact rational (i.e. +other+ < 0).

= reopen  Bignum
== Instance Methods
--- power!(other)
#@todo

= class Rational < Numeric

#@#ソースを見ても include してないようだ
#@#include Comparable

Integer < Rational < Float の順に強いです。つまり other が Float なら、
self を Float に変換してから演算子を適用します。other が Integer なら other を
Rational に変換してから演算子を適用します。冪乗は例外です。

== Class Methods
--- new!(num, den = 1)
#@todo

Implements the constructor. This method does not reduce to lowest
terms or check for division by zero. Therefore #Rational() should
be preferred in normal use.

  puts Rational.new!(6,10) #=> 6/10

--- reduce(num, den = 1)
#@todo

Reduces the given numerator and denominator to their lowest terms.
Use Rational() instead.

== Instance Methods

--- numerator
#@todo

分子を Fixnum として返します。

--- denominator
#@todo

分母を Fixnum として返します。

--- +(other)
#@todo

和を計算します。

  Rational(3, 4) + 2               # => Rational(11, 4)
  Rational(3, 4) + Rational(2, 1)  # => Rational(11, 4)
  Rational(3, 4) + 2.0             # => 2.75

--- -(other)
#@todo

差を計算します。

--- *(other)
#@todo

積を計算します。

  r = Rational(3,4)    # -> Rational(3,4)
  r * 2                # -> Rational(3,2)
  r * 4                # -> Rational(3,1)
  r * 0.5              # -> 0.375
  r * Rational(1,2)    # -> Rational(3,8)

--- /(other)
#@todo

商を計算します。
other が 0 の時は、例外 [[c:ZeroDivisionError]] を投げます。

  Rational(3, 4) / 2              # => Rational(3, 8)
  Rational(3, 4) / Rational(2, 1) # => Rational(3, 8)
  Rational(3, 4) / 2.0            # => 0.375

--- %(other)
#@todo

剰余を計算します。絶対値が self の絶対値を越えない、符合が self と同じ
Numeric を返します。

  Rational(3, 4) % 2               # => Rational(3, 4)
  Rational(3, 4) % Rational(2, 1)  # => Rational(3, 4)
  Rational(3, 4) % 2.0             # => 0.75

--- **(other)
#@todo

冪を計算します。

  Rational(3, 4) ** 2              # => Rational(9, 16)
  Rational(3, 4) ** Rational(2, 1) # => 0.5625
  Rational(3, 4) ** 2.0            # => 0.5625

--- divmod(other)
#@todo

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
#@todo

self が正なら self、負なら -1 * self を返します。

--- <=>(other)
#@todo

other と比べて self が大きいなら 1、同じなら 0、小さいなら -1 を返します。

--- to_i
#@todo

[[c:Fixnum]] に変換します。

--- to_f
#@todo

[[c:Float]] に変換します。

--- to_s
#@todo

文字列に変換します。

  Rational(-3,4).to_s # => "-3/4"
