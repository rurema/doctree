
String、Integer、Float、Rational オブジェクトを
BigDecimal オブジェクトに変換する機能を提供します。

 * [[m:String#to_d]]
 * [[m:Integer#to_d]]
 * [[m:Float#to_d]]
 * [[m:Rational#to_d]]


これらのメソッドを使うには 'bigdecimal' と 'bigdecimal/util'を require
する必要があります。

= reopen Float

== Instance Methods

--- to_d -> BigDecimal
--- to_d(prec) -> BigDecimal

自身を [[c:BigDecimal]] に変換します。

@param prec 計算結果の精度。省略した場合は [[m:Float::DIG]] + 1 です。

@return [[c:BigDecimal]] に変換したオブジェクト

自身を一度 [[m:Float#to_s]] で文字列に変換してから
[[m:Kernel.#BigDecimal]] で生成するので、精度に注意してください。

#@samplecode
require 'bigdecimal'
require 'bigdecimal/util'
1.0.to_d.to_s # => "0.1E1"
(1.0/0).to_d.to_s # => "Infinity"

((1.0/3).to_d/(2.0/3).to_d).to_s # => "0.499999999999999250000000000000375E0"
((1.0/3)/(2.0/3)).to_d.to_s # => "0.5E0"
#@end

@raise ArgumentError prec に負の数を指定した場合に発生します。

= reopen String

== Instance Methods

--- to_d -> BigDecimal

自身を [[c:BigDecimal]] に変換します。BigDecimal(self) と同じです。

@return [[c:BigDecimal]] に変換したオブジェクト

= reopen BigDecimal

== Instance Methods

--- to_digits -> String

自身を "1234.567" のような十進数の形式にフォーマットした文字列に変換し
ます。

@return 十進数の形式にフォーマットした文字列

注意:

このメソッドは非推奨です。[[m:BigDecimal#to_s]]("F") を使用してください。


--- to_d -> BigDecimal

自身を返します。

@return [[c:BigDecimal]] オブジェクト

= reopen Rational

== Instance Methods

--- to_d(nFig)     -> BigDecimal

自身を [[c:BigDecimal]] に変換します。

nFig 桁まで計算を行います。

@param nFig 計算を行う桁数

@return [[c:BigDecimal]] に変換したオブジェクト

@raise ArgumentError nFig に 0 以下を指定した場合に発生します。

#@samplecode
require "bigdecimal"
require "bigdecimal/util"
Rational(1, 3).to_d(3).to_s  # => "0.333E0"
Rational(1, 3).to_d(10).to_s # => "0.3333333333E0"
#@end

= reopen Integer

== Instance Methods

--- to_d -> BigDecimal

自身を [[c:BigDecimal]] に変換します。BigDecimal(self) と同じです。

@return [[c:BigDecimal]] に変換したオブジェクト
