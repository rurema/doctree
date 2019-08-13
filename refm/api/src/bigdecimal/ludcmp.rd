
#@since 1.9.2
require bigdecimal
#@end

LU 分解を用いて、連立1次方程式 Ax = b の解 x を求める機能を提供します。

Ruby のソースコード中の以下のサンプルスクリプトも参考にしてください。

 * [[url:https://github.com/ruby/ruby/blob/trunk/ext/bigdecimal/sample/linear.rb]]

= module LUSolve

LU 分解を用いて、連立1次方程式 Ax = b の解 x を求めるモジュールです。

#@since 1.9.2
== Module Functions
#@else
== Instance Methods
#@end

--- ludecomp(a, n, zero = 0, one = 1) -> [Integer]

n 次正方行列を表す配列 a を破壊的に変更し、返り値と併せて元の行列の LU 分解を提供します。

#@since 1.9.2
[[m:LUSolve.#lusolve]] の引数を構築するために使います。
#@else
[[m:LUSolve#lusolve]] の引数を構築するために使います。
#@end

@param a 行列を [[c:BigDecimal]] の配列で指定します。(各要素を
         Row-major order で 1 次元の配列にしたオブジェクトを指定し
         ます)

@param n 引数 a の次元を整数で指定します。

@param zero 0 を表す値を指定します。

@param one 1 を表す値を指定します。

@return ピボットの位置を表す [[c:Integer]] の配列を返します。

@raise RuntimeError 引数 a に特異行列を指定した場合に発生します。

--- lusolve(a, b, ps, zero = 0.0) -> [BigDecimal]

LU 分解を用いて、連立1次方程式 Ax = b の解 x を求めて返します。

@param a 行列を [[c:BigDecimal]] の配列で指定します。
         各要素を Row-major order で並べて 1 次元の配列にし、
#@since 1.9.2
         [[m:LUSolve.#ludecomp]] で変換したものを指定します。
#@else
         [[m:LUSolve#ludecomp]] で変換したものを指定します。
#@end

@param b ベクトルを [[c:BigDecimal]] の配列で指定します。

#@since 1.9.2
@param ps [[m:LUSolve.#ludecomp]] の返り値を指定します。
#@else
@param ps [[m:LUSolve#ludecomp]] の返り値を指定します。
#@end

@param zero 0.0 を表す値を指定します。

  require 'bigdecimal'
  require 'bigdecimal/util'
  require 'bigdecimal/ludcmp'

  include LUSolve

  a = [['1.0', '2.0'], ['3.0', '1.0']].flatten.map(&:to_d)
  # x = ['1.0', -1.0']
  b = ['-1.0', '2.0'].map(&:to_d)

  zero = '0.0'.to_d
  one = '1.0'.to_d
  # 以下の 2 行は
  ps = ludecomp(a, b.size, zero, one)  # a が破壊的に変更される
  x = lusolve(a, b, ps, zero)
  # こう書いてもよい
  # x = lusolve(a, b, ludecomp(a, b.size, zero, one), zero)

  p x.map(&:to_f)  #=> [1.0, -1.0]

