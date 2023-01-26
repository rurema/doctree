
BigDecimalを使った数学的な機能を提供します。

以下の計算が行えます。

 * sqrt(x, prec)
 * sin (x, prec)
 * cos (x, prec)
 * atan(x, prec)
 * PI  (prec)
 * E   (prec)

引数:

: x

  計算対象の BigDecimal オブジェクト。

: prec

  計算結果の精度。

#@samplecode 例
require "bigdecimal"
require "bigdecimal/math"

include BigMath

a = BigDecimal((PI(100)/2).to_s)
puts sin(a,100)
#=> 0.99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999998765917571575217785e0
#@end

= reopen BigMath

== Module Functions

--- sqrt(x, prec) -> BigDecimal

x の平方根を prec で指定した精度で計算します。

@param x 平方根を求める数。

@param prec 計算結果の精度。

@raise FloatDomainError x に 0 以下、もしくは NaN が指定された場合に発生します。

@raise ArgumentError prec に 0 未満が指定された場合に発生します。

#@samplecode
require "bigdecimal/math"

puts BigMath::sqrt(BigDecimal('2'), 10) #=> 0.1414213562373095048666666667e1
#@end


--- sin(x, prec) -> BigDecimal

x の正弦関数を prec で指定した精度で計算します。単位はラジアンです。x
に無限大や NaN を指定した場合には NaN を返します。

@param x 計算対象の BigDecimal オブジェクト。単位はラジアン。

@param prec 計算結果の精度。

@raise ArgumentError prec に 0 以下が指定された場合に発生します。

#@samplecode
require "bigdecimal/math"

puts BigMath::sin(BigDecimal('0.5'), 10) #=> 0.479425538604203000273287935689073955184741e0
#@end


--- cos(x, prec) -> BigDecimal

x の余弦関数を prec で指定した精度で計算します。単位はラジアンです。x
に無限大や NaN を指定した場合には NaN を返します。

@param x 計算対象の BigDecimal オブジェクト。単位はラジアン。

@param prec 計算結果の精度。

@raise ArgumentError prec に 0 以下が指定された場合に発生します。

#@samplecode
require "bigdecimal/math"

puts BigMath::cos(BigDecimal('0.5'), 10) #=> 0.8775825618903727161162815826327690580439923e0
#@end


--- atan(x, prec) -> BigDecimal

x の逆正接関数を prec で指定した精度で計算します。単位はラジアンです。
x に無限大や NaN を指定した場合には NaN を返します。

@param x 計算対象の BigDecimal オブジェクト。単位はラジアン。

@param prec 計算結果の精度。

@raise ArgumentError x の絶対値が1以上の場合に発生します。

@raise ArgumentError prec に 0 以下が指定された場合に発生します。

#@samplecode
require "bigdecimal/math"

puts BigMath::atan(BigDecimal('0.5'), 10) #=> 0.463647609000806116214256237466868871528608e0
#@end

=== 注意

x の絶対値を 0.9999 のような 1 に近すぎる値にすると計算結果が収束しない
可能性があります。

--- PI(prec) -> BigDecimal

円周率を prec で指定した精度で計算します。

@param prec 計算結果の精度。

@raise ArgumentError prec に 0 以下が指定された場合に発生します。

#@samplecode
require "bigdecimal/math"

puts BigMath::PI(2)  #=> 0.31415926535897932384671233672993238432e1
puts BigMath::PI(5)  #=> 0.31415926535897932384627534923029509162e1
puts BigMath::PI(10) #=> 0.3141592653589793238462643388813853786957412e1
#@end


--- E(prec) -> BigDecimal

自然対数の底 e を prec で指定した精度で計算します。

@param prec 計算結果の精度。

@raise ArgumentError prec に 0 以下が指定された場合に発生します。

#@samplecode
require "bigdecimal/math"

puts BigMath::E(2)  #=> 0.27e1
puts BigMath::E(4)  #=> 0.2718e1
puts BigMath::E(10) #=> 0.2718281828e1
#@end
