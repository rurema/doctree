category Math

行列と数ベクトルを扱うためのライブラリです。

行列、ベクトルの各要素には Ruby の任意の数オブジェクト([[c:Numeric]] の
サブクラス、[[c:Float]], [[c:Integer]], [[c:Complex]], [[c:Rational]] など)
が使えます。ただし割り算を必要とするいくつかのメソッド
([[m:Matrix#det]], [[m:Matrix#inv]] など)は整数を要素に持つ場合は正しく
動作しません。

#@# [2002-04-02]  by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]

#@include(matrix/Vector)
#@include(matrix/Matrix)
