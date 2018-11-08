#@since 1.9.1

category Math

複素数演算をサポートするライブラリです。

= module CMath

include Math

複素数演算をサポートするモジュールです。

[[c:Math]] モジュールの複素数版です。同名のメソッドを複素数対応します。
従来の計算結果が必要な場合は、「メソッド名!」の形式で呼び出します。

#@samplecode 例
require "cmath"
CMath.sqrt(-9)# => (0+3.0i)
CMath.sqrt!(4)# => 2.0
#@end

== Module Functions

--- exp!(x) -> Float

実数 x の指数関数([[m:Math::E]] の x 乗)の値を返します。
[[m:Math.#exp]] のエイリアスです。

@param x [[m:Math::E]] を x 乗する数を実数で指定します。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.exp!(0) # => 1
CMath.exp!(0.5) # => Math.sqrt(Math::E)
CMath.exp!(1) # => Math::E
CMath.exp!(2) # => Math::E ** 2
#@end

@see [[m:Math.#exp]]

--- exp(z) -> Float | Complex

z の指数関数([[m:Math::E]] の z 乗)の値を返します。

@param z [[m:Math::E]] を z 乗する数を指定します。

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

#@samplecode 例
require "cmath"
CMath.exp(Complex(0, 0))# => (1.0+0.0i)
CMath.exp(Complex(0, Math::PI)) # => (-1.0+1.2246063538223773e-16i)
CMath.exp(Complex(0, Math::PI / 2.0)) # => (6.123031769111886e-17+1.0i)
#@end

--- log!(x) -> Float
--- log!(x, b) -> Float

実数 x の対数を返します。[[m:Math.#log]] のエイリアスです。

@param x 真数を正の実数で指定します。

@param b 底を指定します。省略した場合は自然対数を計算します。

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。

@raise RangeError 引数のどちらかに実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.log!(Math::E) # => 1.0
CMath.log!(1) # => 0.0
CMath.log!(100, 10) # => 2.0
CMath.log!(-1.0)# => Math::DomainError
#@end

@see [[m:Math.#log]]

--- log(z) -> Float | Complex
--- log(z, b) -> Float | Complex

z の対数を返します。

@param z 真数を指定します。

@param b 底を指定します。省略した場合は自然対数を計算します。

#@since 1.9.3
@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。
#@end

#@samplecode 例
require "cmath"
CMath.log(Complex(0, 0)) # => -Infinity+0.0i
CMath.log(0) # => -Infinity
#@end

#@until 1.9.3
[注意] 1.9.2 以下では z に 0+0i を与えると [[c:Math::DomainError]] が発
生するバグがあります。
#@end

#@since 1.9.2
--- log2!(x) -> Float
#@else
--- log2(x) -> Float
#@end

2 を底とする実数 x の対数 (binary logarithm) を返します。
[[m:Math.#log2]]のエイリアスです。

@param x 真数を正の実数で指定します。

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#log2]]

#@since 1.9.2
--- log2(z) -> Float | Complex

2 を底とする z の対数 (binary logarithm) を返します。

@param z 真数を指定します。

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end
#@end

--- log10!(x) -> Float

実数 x の常用対数を返します。[[m:Math.#log10]] のエイリアスです。

@param x 真数を正の実数で指定します。

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#log10]]

--- log10(z) -> Float | Complex

x の常用対数を返します。

@param x 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

#@since 1.9.2
--- cbrt!(x) -> Float
#@else
--- cbrt(x) -> Float
#@end

実数 x の立方根を返します。[[m:Math.#cbrt]] のエイリアスです。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.cbrt!(8.0)# => 2.0
CMath.cbrt!(-8.0) # => -2.0
#@end

@see [[m:Math.#cbrt]]

#@since 1.9.2
--- cbrt(z) -> Float | Complex

z の立方根の内、主値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

#@samplecode 例
require "cmath"
CMath.cbrt(-8)# => (1.0000000000000002+1.7320508075688772i)
#@end

#@until 1.9.3
[注意] 1.9.2 以下では負の実数を引数に与えると、主値以外の立方根(実数解)を
返すバグがあります。
#@end

@see [[m:Complex#**]]

#@end

--- sqrt!(x) -> Float

実数 x の平方根を返します。[[m:Math.#sqrt]] のエイリアスです。

@param x 正の実数

@raise Math::DomainError x が負の数である場合に発生します。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.sqrt!(4.0) # => 2.0
CMath.sqrt!(9.0) # => 3.0
#@end

@see [[m:Math.#sqrt]]

--- sqrt(z) -> Float | Complex

z の平方根を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

#@samplecode 例
require "cmath"
CMath.sqrt(-1) # => (0+1.0i)
CMath.sqrt(1)# => 1.0
CMath.sqrt(Complex(0, 8))# => (2.0+2.0i)
#@end

--- sin!(x) -> Float

実数 x の正弦関数の値をラジアンで返します。[[m:Math.#sin]] のエイリアス
です。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.sin!(0 * Math::PI / 4) # => 0.0
CMath.sin!(1 * Math::PI / 4) # => 0.7071067811865475
CMath.sin!(2 * Math::PI / 4) # => 1.0
#@end

@see [[m:Math.#sin]]

--- sin(z) -> Float | Complex

z の正弦関数の値をラジアンで返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- cos!(x) -> Float

実数 x の余弦関数の値をラジアンで返します。[[m:Math.#cos]] のエイリアス
です。

@param x 実数

@return [-1, 1] の実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.cos!(0 * Math::PI / 4) # => 1.0
CMath.cos!(1 * Math::PI / 4) # => 0.7071067811865476
CMath.cos!(4 * Math::PI / 4) # => -1.0
#@end

@see [[m:Math.#cos]]

--- cos(z) -> Float | Complex

z の余弦関数の値をラジアンで返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- tan!(x) -> Float

実数 x の正接関数の値をラジアンで返します。[[m:Math.#tan]] のエイリアス
です。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

#@samplecode 例
require "cmath"
CMath.tan!(0 * Math::PI / 4) # => 0.0
CMath.tan!(1 * Math::PI / 4) # => 1.0
CMath.tan!(4 * Math::PI / 4) # => 0.0
#@end

@see [[m:Math.#tan]]

--- tan(z) -> Float | Complex

z の正接関数の値をラジアンで返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- sinh!(x) -> Float

実数 x の双曲線正弦関数の値を返します。[[m:Math.#sinh]] のエイリアスで
す。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#sinh]]

--- sinh(z) -> Float | Complex

z の双曲線正弦関数の値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- cosh!(x) -> Float

実数 x の双曲線余弦関数の値を返します。[[m:Math.#cosh]] のエイリアスで
す。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#cosh]]

--- cosh(z) -> Float | Complex

z の双曲線余弦関数の値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- tanh!(x) -> Float

実数 x の双曲線正接関数の値を返します。[[m:Math.#tanh]] のエイリアスで
す。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#tanh]]

--- tanh(z) -> Float | Complex

z の双曲線正接関数の値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- asin!(x) -> Float

実数 x の逆正弦関数の値をラジアンで返します。[[m:Math.#asin]] のエイリ
アスです。

@param x -1.0 <= x <= 1 の範囲内の実数。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise Math::DomainError x に範囲外の実数を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#asin]]

--- asin(z) -> Float | Complex

z の逆正弦関数の値をラジアンで返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- acos!(x) -> Float

実数 x の逆余弦関数の値をラジアンで返します。[[m:Math.#acos]] のエイリ
アスです。

@param x -1.0 <= x <= 1 の範囲内の実数

@return 返される値の範囲は [0, +π] です。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise Math::DomainError x に範囲外の実数を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#acos]]

--- acos(z) -> Float | Complex

z の逆余弦関数の値をラジアンで返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- atan!(x) -> Float

実数 x の逆正接関数の値をラジアンで返します。[[m:Math.#atan]] のエイリ
アスです。

@param x 実数。

@return 返される値の範囲は [-π/2, +π/2] です。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#atan]]

--- atan(z) -> Float | Complex

z の逆正接関数の値をラジアンで返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- atan2!(y, x) -> Float

実数 y / x の逆正接関数の値を返します。[[m:Math.#atan2]] のエイリアスで
す。

@param y 実数。

@param x 実数。

@return 返される値の範囲は [-π, π] です。

@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。

@raise RangeError 引数のどちらかに数値以外を指定した場合に発生します。

@see [[m:Math.#atan2]]

--- atan2(y, x) -> Float | Complex

y / x の逆正接関数の値を返します。

@param y 数値

@param x 数値

#@since 1.9.3
@raise TypeError 引数のどちらかに数値以外を指定した場合に発生します。
#@end

--- asinh!(x) -> Float

実数 x の逆双曲線正弦関数の値を返します。[[m:Math.#asinh]] のエイリアスです。

@param x 実数

@raise TypeError x に数値以外を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#asinh]]

--- asinh(z) -> Float | Complex

z の逆双曲線正弦関数の値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- acosh!(x) -> Float

実数 x の逆双曲線余弦関数の値を返します。[[m:Math.#acosh]] のエイリアスです。

@param x x >= 1 の範囲の実数。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise Math::DomainError x に範囲外の実数を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#acosh]]

--- acosh(z) -> Float | Complex

z の逆双曲線余弦関数の値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

--- atanh!(x) -> Float

実数 x の逆双曲線正接関数の値を返します。[[m:Math.#atanh]] のエイリアスです。

@param x -1 < x < 1 の実数。

@return 実数。

@raise TypeError x に数値以外を指定した場合に発生します。

@raise Math::DomainError x に範囲外の実数を指定した場合に発生します。

@raise RangeError x に実数以外の数値を指定した場合に発生します。

@see [[m:Math.#atanh]]

--- atanh(z) -> Float | Complex

z の逆双曲線正接関数の値を返します。

@param z 数値

#@since 1.9.3
@raise TypeError z に数値以外を指定した場合に発生します。
#@end

#@end
