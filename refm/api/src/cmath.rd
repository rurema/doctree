#@since 1.9.1

複素数演算をサポートするライブラリです。

= module CMath

include Math

複素数演算をサポートするモジュールです。[[c:Math]] モジュールの複素数版です。

例:

  require "cmath"
  CMath.sqrt(-9)  # => (0+3.0i)

== Module Functions

--- exp!(x) -> Float

x の指数関数([[m:Math::E]] の x 乗)の値を返します。[[m:Math.#exp]] のエ
イリアスです。

@param x [[m:Math::E]] を x 乗する数を実数で指定します。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

例:

  require "cmath"
  CMath.exp!(0)   # => 1
  CMath.exp!(0.5) # => Math.sqrt(Math::E)
  CMath.exp!(1)   # => Math::E
  CMath.exp!(2)   # => Math::E ** 2

--- exp(z) -> Float | Complex

z の指数関数([[m:Math::E]] の z 乗)の値を返します。

@param z [[m:Math::E]] を z 乗する数を指定します。

例:

  require "cmath"
  CMath.exp(Complex(0, 0))              # => (1.0+0.0i)
  CMath.exp(Complex(0, Math::PI))       # => (-1.0+1.2246063538223773e-16i)
  CMath.exp(Complex(0, Math::PI / 2.0)) # => (6.123031769111886e-17+1.0i)

--- log!(x) -> Float
--- log!(x, b) -> Float

x の対数を返します。[[m:Math.#log]] のエイリアスです。

@param x 真数を正の実数で指定します。

@param b 底を指定します。省略した場合は自然対数を計算します。

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。

@raise RangeError 引数のどちらかに実数以外の数値を指定した場合に発生します。

例:

  require "cmath"
  CMath.log!(Math::E) # => 1.0
  CMath.log!(1)       # => 0.0
  CMath.log!(100, 10) # => 2.0
  CMath.log!(-1.0)     # => Math::DomainError

#@# r4625 現在、Math.#log のドキュメントは引数が 1 つしかないが、1.9 系
#@# では 2 つ指定する事もできる。

--- log(z) -> Float | Complex
--- log(z, b) -> Float | Complex

z の対数を返します。

@param x 真数を指定します。

@param b 底を指定します。省略した場合は自然対数を計算します。

例:

  require "cmath"
  CMath.log(Complex(0, 0)) # => -Infinity+0.0i
  CMath.log(0)             # => -Infinity

#@todo 底を与えたときの例を追加。

#@since 1.9.2
--- log2!(x) -> Float
#@else
--- log2(x) -> Float
#@end

2 を底とする x の対数 (binary logarithm) を返します。[[m:Math.#log2]]
のエイリアスです。

@param x 真数を正の実数で指定します。

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@since 1.9.2
--- log2(z) -> Float | Complex

2 を底とする z の対数 (binary logarithm) を返します。

@param z 真数を指定します。
#@end

--- log10!(x) -> Float

x の常用対数を返します。[[m:Math.#log10]] のエイリアスです。

@param x 真数を正の実数で指定します。

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

--- log10(z) -> Float | Complex

x の常用対数を返します。

#@since 1.9.2
--- cbrt!(x) -> Float
#@else
--- cbrt(x) -> Float
#@end

実数 x の立方根を返します。[[m:Math.#cbrt]] のエイリアスです。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

例:

  require "cmath"
  CMath.cbrt!(8.0)  # => 2.0
  CMath.cbrt!(-8.0) # => -2.0

#@since 1.9.2
--- cbrt(z) -> Float | Complex

z の立方根を返します。

#@end

--- sqrt!

#@todo

--- sqrt

#@todo

--- sin!

#@todo

--- sin

#@todo

--- cos!

#@todo

--- cos

#@todo

--- tan!

#@todo

--- tan

#@todo

--- sinh!

#@todo

--- sinh

#@todo

--- cosh!

#@todo

--- cosh

#@todo

--- tanh!

#@todo

--- tanh

#@todo

--- asin!

#@todo

--- asin

#@todo

--- acos!

#@todo

--- acos

#@todo

--- atan!

#@todo

--- atan

#@todo

--- atan2!

#@todo

--- atan2

#@todo

--- asinh!

#@todo

--- asinh

#@todo

--- acosh!

#@todo

--- acosh

#@todo

--- atanh!

#@todo

--- atanh

#@todo

--- frexp

#@todo

--- ldexp

#@todo

--- hypot

#@todo

--- erf

#@todo

--- erfc

#@todo

--- gamma

#@todo

--- lgamma

#@todo

#@end
