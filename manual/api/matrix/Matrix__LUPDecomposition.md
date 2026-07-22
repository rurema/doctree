---
library: matrix
---
# class Matrix::LUPDecomposition

行列のLUP分解の情報を保持するクラスです。

[m:Matrix#lup_decomposition] の返り値のクラスです。

## Instance Methods
### def det         -> Numeric
### def determinant -> Numeric
#@# サイズが (1, 1) なら型の変換は起こらないので何でも返す可能性が有る。
元の行列の行列式の値を返します。
LUP 分解の結果を利用して計算します。

- **SEE** [m:Matrix#determinant]

### def l -> Matrix

LUP分解の下半行列部分を返します。

### def u -> Matrix

LUP分解の上半行列部分を返します。

### def p -> Matrix

LUP分解の置換行列部分を返します。

### def to_ary -> [Matrix, Matrix, Matrix]
### def to_a -> [Matrix, Matrix, Matrix]

分解した行列を [下半行列, 上半行列, 置換行列] という3要素の配列で
返します。

### def pivots -> [Integer]

ピボッティングを表す配列を返します。

### def singular? -> bool

元の行列が正方で特異なら true を、正則なら false を返します。
LUP 分解の結果を利用して判定します。

- **SEE** [m:Matrix#singular?]

### def solve(b) -> Vector | Matrix

self が正方行列 A の LUP 分解の時、一次方程式 Ax = b の解を返します。
b には [c:Vector], [c:Matrix], 数値の配列を指定出来ます。

それぞれベクトルのサイズ、行列の行数、配列のサイズが A の列数と一致していなければなりません。
返り値は b が行列なら行列、それ以外はベクトルになります。

- **param** `b` -- 一次方程式の定数項を指定します。

```ruby
require 'matrix'

lup = Matrix[[2, 1], [1, 2]].lup

p lup.solve([1, -1])                #=> Vector[(1/1), (-1/1)]
p lup.solve(Vector[3, 0])           #=> Vector[(2/1), (-1/1)]
p lup.solve(Matrix[[1, 3], [-1, 0]])  #=> Matrix[[(1/1), (2/1)], [(-1/1), (-1/1)]]
```

#@#== ChangeLog
#@#
#@#*[2004-04-23] by [[unknown:坂野|URL:mailto:mas@star.le.ac.uk]]
#@#    * Matrix.diagonalに注意書を加える。
#@#*[2002-04-03] by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]
#@#    * 使い方の節を追加
#@#    * Working with Complex classの節を追加
#@#    * []=メソッドを追加
#@#    * イテレータ関係を同じ節にまとめた
#@#    * 誤りを訂正し、説明を直した。
#@#    * 他クラスへのリンクを追加 Numeric, Vector
#@#*[2002-04-02] 初版 by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]
