= module Math

浮動小数点演算をサポートするクラス。Math モジュールは同じ定義の
メソッドと特異メソッドとの両方が定義されているので、特異メソッドを呼び
出して使う使い方と、クラスにインクルードして使う使い方との両方ができま
す。

例:

  pi = Math.atan2(1, 1)*4;
  include Math
  pi2 = atan2(1, 1)*4

== Module Functions

--- acos(x)
--- asin(x)
--- atan(x)

x の逆三角関数の値をラジアンで返します。

返される値の範囲はそれぞれ [0, +π]、[-π/2, +π/2]、
(-π/2, +π/2) です。

acos(x), asin(x) では x は -1.0 <= x <= 1 の範囲内でな
ければなりません。(普通、NaN を返します)

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): acos(), asin() は範囲外の引数に対して、例
外 [[unknown:Errno::EDOM|Errno::EXXX]] が発生します。
#@end

--- atan2(y, x)

y/x のアークタンジェントを [-π, π] の範囲で返します。

#@if (version >= "1.7.0")
--- acosh(x)
--- asinh(x)
--- atanh(x)

x の逆双曲線関数の値を返します。

    asinh(x) = log(x + sqrt(x * x + 1))
    acosh(x) = log(x + sqrt(x * x - 1)) [x >= 1]
    atanh(x) = log((1+x)/(1-x)) / 2     [-1 < x < 1]

acosh(x) では x はx >= 1 の範囲内でなければなりません。
(普通、例外 [[unknown:Errno::EDOM|Errno::EXXX]] が発生します)

atanh(x) では x は -1.0 < x < 1 の範囲内でなければな
りません。(普通、例外 [[unknown:Errno::EDOM|Errno::EXXX]] が発生します)
#@end

--- cos(x)
--- sin(x)
--- tan(x)

ラジアンで表された x の三角関数の値を [-1, 1] の範囲で
返します。

#@if (version >= "1.7.0")
--- cosh(x)
--- sinh(x)
--- tanh(x)

x の双曲線関数の値を返します。

    cosh(x) = (exp(x) + exp(-x)) / 2
    sinh(x) = (exp(x) - exp(-x)) / 2
    tanh(x) = sinh(x) / cosh(x)
#@end
#@if (version >= "1.8.0")
--- erf(x)
--- erfc(x)

x の誤差関数(erf)、相補誤差関数(erfc)の値を返します。
#@end

--- exp(x)

x の指数関数の値を返します。

--- frexp(x)

実数 x の指数部と仮数部を返します。

#@if (version >= "1.7.0")
--- hypot(x, y)

sqrt(x*x + y*y) を返します。
#@end

--- ldexp(x,exp)

実数 x に 2 の exp 乗をかけた数を返します。

--- log(x)

x の自然対数を返します。

x は正の値でなければなりません(普通、負の値に対して NaN を 0
に対して -Infinity を返します)

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): 範囲外の引数に対して、負の場合に例外
[[unknown:Errno::EDOM|Errno::EXXX]] が 0 の場合に
[[unknown:Errno::ERANGE|Errno::EXXX]] が発生します。
#@end

--- log10(x)

x の常用対数を返します。

x は正の値でなければなりません(普通、負の値に対して NaN を 0
に対して -Infinity を返します)

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): 範囲外の引数に対して、負の場合に例外
[[unknown:Errno::EDOM|Errno::EXXX]] が 0 の場合に
[[unknown:Errno::ERANGE|Errno::EXXX]] が発生します。
#@end

--- sqrt(x)

x の平方根を返します。x の値が負である時には例外
[[c:ArgumentError]] が発生します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): 普通、x が負の場合、例外
[[unknown:Errno::EDOM|Errno::EXXX]] が発生します。
#@end

== Constants

--- E

自然対数の底

    p Math::E
    # => 2.718281828

--- PI

円周率

    p Math::PI
    # => 3.141592654
