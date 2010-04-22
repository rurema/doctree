
String、Fload、Rational オブジェクト を BigDecimal に変換する機能を提供
します。

ここにあるメソッドを使うには 'bigdecimal/util'を require する必要があり
ます。

 * [[m:String#to_d]]
 * [[m:Float#to_d]]
 * [[m:Rational#to_d]]

#@until 1.9.1
また、BigDecimal オブジェクトからは Rational オブジェクトに変換する事も
できるようになります。

 * [[m:BigDecimal#to_r]]
#@end

= reopen Float

== Instance Methods

--- to_d -> BigDeciamal

自身を [[c:BigDecimal]] に変換します。

@return [[c:BigDecimal]] に変換したオブジェクト

= reopen String

== Instance Methods

--- to_d -> BigDeciamal

自身を [[c:BigDecimal]] に変換します。

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
