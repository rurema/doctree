---
type: library
category: Math
---
行列と数ベクトルを扱うためのライブラリです。

行列、ベクトルの各要素には Ruby の任意の数オブジェクト([c:Numeric] の
サブクラス、[c:Float], [c:Integer], [c:Complex], [c:Rational] など)
が使えます。

#@# [2002-04-02]  by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]

# class ExceptionForMatrix::ErrDimensionMismatch < StandardError

行列/ベクトル計算時に次元が合わない場合に発生する例外です。

# class ExceptionForMatrix::ErrNotRegular < StandardError

逆行列計算時に行列が正則でない場合に発生する例外です。

# class ExceptionForMatrix::ErrOperationNotDefined < StandardError

演算時にクラスが適切でない場合に発生する例外です。

