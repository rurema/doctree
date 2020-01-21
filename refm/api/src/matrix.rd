category Math

行列と数ベクトルを扱うためのライブラリです。

行列、ベクトルの各要素には Ruby の任意の数オブジェクト([[c:Numeric]] の
サブクラス、[[c:Float]], [[c:Integer]], [[c:Complex]], [[c:Rational]] など)
が使えます。
#@until 1.9.1
ただし割り算を必要とするいくつかのメソッド
([[m:Matrix#det]], [[m:Matrix#inv]] など)は整数を要素に持つ場合は正しく
動作しません。
#@end

#@# [2002-04-02]  by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]

= class ExceptionForMatrix::ErrDimensionMismatch < StandardError
行列/ベクトル計算時に次元が合わない場合に発生する例外です。

= class ExceptionForMatrix::ErrNotRegular < StandardError
逆行列計算時に行列が正則でない場合に発生する例外です。

= class ExceptionForMatrix::ErrOperationNotDefined < StandardError
演算時にクラスが適切でない場合に発生する例外です。

#@include(matrix/Vector)
#@include(matrix/Matrix)
