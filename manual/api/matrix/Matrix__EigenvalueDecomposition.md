---
library: matrix
---
# class Matrix::EigenvalueDecomposition

行列の固有分解の情報を保持するクラスです。

[m:Matrix#eigensystem] の返り値のクラスです。

## Instance Methods
### def eigenvector_matrix -> Matrix
### def v  -> Matrix

右固有ベクトルを横に並べた行列を返します。

### def eigenvector_matrix_inv  -> Matrix
### def v_inv  -> Matrix

左固有ベクトルを縦に並べた行列を返します。

これは [m:Matrix::EigenvalueDecomposition#v] の逆行列です

### def eigenvalues -> [Float]

固有値を配列で返します。

### def eigenvectors -> [Vector]

右固有ベクトルを配列で返します。

### def eigenvalue_matrix -> Matrix
### def d -> Matrix

固有値を対角成分に並べた行列を返します。

### def to_ary -> [Matrix, Matrix, Matrix]
### def to_a -> [Matrix, Matrix, Matrix]

[m:Matrix::EigenvalueDecomposition#v],
[m:Matrix::EigenvalueDecomposition#d],
[m:Matrix::EigenvalueDecomposition#v_inv]
をこの順に並べた配列を返します。

