
String、Float、Rational オブジェクト を BigDecimal オブジェクトに変換する機能を提供
します。

 * [[m:String#to_d]]
 * [[m:Float#to_d]]
 * [[m:Rational#to_d]]

#@until 1.9.1
また、BigDecimal オブジェクトを Rational オブジェクトに変換する機能も提供します。

 * [[m:BigDecimal#to_r]]
#@end

これらのメソッドを使うには 'bigdecimal' と 'bigdecimal/util'を require
する必要があります。

= reopen Float

== Instance Methods

--- to_d -> BigDecimal

自身を [[c:BigDecimal]] に変換します。

@return [[c:BigDecimal]] に変換したオブジェクト

自身を一度 [[m:Float#to_s]] で文字列に変換してから
[[m:Kernel.#BigDecimal]] で生成するので、精度に注意してください。

  1.0.to_d.to_s # => "0.1E1"
  (1.0/0).to_d.to_s # => "Infinity"

  ((1.0/3).to_d/(2.0/3).to_d).to_s # => "0.499999999999999250000000000000375E0"
  ((1.0/3)/(2.0/3)).to_d.to_s # => "0.5E0"

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

#@until 1.9.1
--- to_r -> Rational

自身を [[c:Rational]] に変換します。

@return [[c:Rational]] に変換したオブジェクト
#@end

= reopen Rational

== Instance Methods

--- to_d(nFig = 0) -> BigDecimal

自身を [[c:BigDecimal]] に変換します。

nFig が指定された場合、nFig 桁まで計算を行います。省略したり 0 以下を指
定した場合は [[m:BigDecimal.double_fig]] * 2 + 1 桁まで計算を行います。

@param nFig 計算を行う桁数

@return [[c:BigDecimal]] に変換したオブジェクト

例:

  require "rational"
  require "bigdecimal"
  require "bigdecimal/util"
  Rational(1, 3).to_d(3).to_s  # => "0.333E0"
  Rational(1, 3).to_d(10).to_s # => "0.3333333333E0"
