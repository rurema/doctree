#@since 1.8.0

#@since 1.9.2
require bigdecimal
#@end

LU 分解を用いて、連立1次方程式 Ax = b の解 x を求める機能を提供します。

Ruby のソースコード中の以下のサンプルスクリプトも併せて確認できます。

 * [[url:http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/trunk/ext/bigdecimal/sample/linear.rb?view=markup]]

= module LUSolve

LU 分解を用いて、連立1次方程式 Ax = b の解 x を求めるモジュールです。

#@since 1.9.2
== Module Functions
#@else
== Instance Methods
#@end

--- ludecomp(a, n, zero = 0, one = 1) -> [BigDecimal]

n 次正方行列 a に対して LU 分解を行います。

@param a 行列を [[c:BigDecimal]] の配列で指定します。(各要素を
         Row-major order で 1 次元の配列にしたオブジェクトを指定し
         ます)

@param n 引数 a の次元を整数で指定します。

@param zero 0 を表す値を指定します。

@param one 1 を表す値を指定します。

@raise RuntimeError 引数 a に特異行列を指定した場合に発生します。

--- lusolve(a, b, ps, zero = 0.0) -> [BigDecimal]

LU 分解を用いて、連立1次方程式 Ax = b の解 x を求めます。

@param a 行列を [[c:BigDecimal]] の配列で指定します。(各要素を
         Row-major order で 1 次元の配列にしたオブジェクトを指定し
         ます)

@param b 定数ベクトルを [[c:BigDecimal]] の配列で指定します。

@param ps ピボットを [[c:BigDecimal]] の配列で指定します。解の誤差を最
          小限に抑えるために指定します。適切な値は引数 a に依存します。
          詳しくは他の文献を参照してください。

@param zero 0.0 を表す値を指定します。

#@end
