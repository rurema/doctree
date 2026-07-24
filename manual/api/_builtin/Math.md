---
library: _builtin
---
# module Math

浮動小数点演算をサポートするモジュールです。

Math モジュールにはさまざま数学関数がモジュール関数として定義されています。
モジュール関数は以下のように，モジュールの特異メソッドとして呼び出す使い方と、
モジュールをインクルードしてレシーバーを省略した形で呼び出す使い方の両方ができます。

### 例

```ruby
pi = Math.atan2(1, 1)*4;
include Math
pi2 = atan2(1, 1)*4
```

## Module Functions

### module_function def acos(x) -> Float

x の逆余弦関数（arccosine）の値をラジアンで返します。

- **param** `x` -- -1.0 <= x <= 1 の範囲内の実数

- **return** -- 返される値の範囲は [0, +π] です。

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.acos(0) == Math::PI/2  # => true
```

- **SEE** [m:Math?.cos]

### module_function def asin(x) -> Float

x の逆正弦関数（arcsine）の値をラジアンで返します。

- **param** `x` -- -1.0 <= x <= 1 の範囲内の実数

- **return** -- 返される値の範囲は[-π/2, +π/2] です。

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.asin(1) == Math::PI/2  # => true
```

- **SEE** [m:Math?.sin]

### module_function def atan(x) -> Float

x の逆正接関数（arctangent）の値をラジアンで返します。

- **param** `x` -- 実数

- **return** -- 返される値の範囲は [-π/2, +π/2] です。

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.atan(0) # => 0.0
```

- **SEE** [m:Math?.atan2], [m:Math?.tan]

### module_function def atan2(y, x) -> Float

y / x の逆正接関数（arctangent）の値をラジアンで返します。

- **param** `y` -- 実数
- **param** `x` -- 実数

- **return** -- 返される値の範囲は [-π, π] です。

```ruby title="例"
p Math.atan2(1,0) #=>  1.5707963267949
p Math.atan2(-1,0)  #=> -1.5707963267949
```

y に符号付きゼロを渡した場合、+0.0 と -0.0 は区別され、結果の符号が変わります。

```ruby title="例: 符号付きゼロ"
p Math.atan2(0.0, -1)   # =>  3.141592653589793
p Math.atan2(-0.0, -1)  # => -3.141592653589793
```

x に符号付きゼロを渡した場合も +0.0 と -0.0 は区別されます。そのため、`atan2(y, x)` は
`atan(y / x)` とは異なる結果になることがあります。

```ruby title="例: x が符号付きゼロの場合の atan との違い"
p Math.atan2(1.0, -0.0)  # =>  1.5707963267948966
p Math.atan(1.0 / -0.0)  # => -1.5707963267948966
```

- **raise** `TypeError` -- y, x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- y, x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.atan], [m:Math?.tan]

### module_function def acosh(x) -> Float

x の逆双曲線余弦関数（area hyperbolic cosine）の値を返します。

### 定義

```text
acosh(x) = log(x + sqrt(x * x - 1)) [x >= 1]
```

- **param** `x` -- x >= 1 の範囲の実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.cosh]

### module_function def asinh(x) -> Float

x の逆双曲線正弦関数（area hyperbolic sine）の値を返します。

### 定義

```text
asinh(x) = log(x + sqrt(x * x + 1))
```

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.sinh]

### module_function def atanh(x) -> Float

x の逆双曲線正接関数（area hyperbolic tangent）の値を返します。

### 定義

```text
atanh(x) = log((1+x)/(1-x)) / 2     [-1 < x < 1]
```

- **param** `x` -- -1 < x < 1 の実数

- **return** -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.tanh]

### module_function def cos(x) -> Float

x の余弦関数（cosine）の値を返します。

- **param** `x` -- 実数（ラジアンで与えます）

- **return** -- [-1, 1] の実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.cos(Math::PI) # => -1.0
```

- **SEE** [m:Math?.acos]

### module_function def sin(x) -> Float

x の正弦関数（sine）の値を返します。

- **param** `x` -- 実数（ラジアンで与えます）

- **return** -- [-1, 1] の実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.sin(Math::PI/2) # => 1.0
```

- **SEE** [m:Math?.asin]

### module_function def tan(x) -> Float

x の正接関数（tangent）の値を返します。

- **param** `x` -- 実数（ラジアンで与えます）

- **return** -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.tan(0) # => 0.0
```

- **SEE** [m:Math?.atan], [m:Math?.atan2]

### module_function def cosh(x) -> Float

x の双曲線余弦関数（hyperbolic cosine）の値を返します。

### 定義

```text
cosh(x) = (exp(x) + exp(-x)) / 2
```

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.acosh]

### module_function def sinh(x) -> Float

x の双曲線正弦関数（hyperbolic sine）の値を返します。

### 定義

```text
sinh(x) = (exp(x) - exp(-x)) / 2
```

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.asinh]

### module_function def tanh(x) -> Float

x の双曲線正接関数（hyperbolic tangent）の値を返します。

### 定義

```text
tanh(x) = sinh(x) / cosh(x)
```

- **param** `x` -- 実数

- **return** -- [-1, 1] の範囲の実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **SEE** [m:Math?.atanh]

### module_function def erf(x) -> Float

x の誤差関数（error function）の値を返します。

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.erf(0) # => 0.0
```

- **SEE** [m:Math?.erfc]

### module_function def erfc(x) -> Float

x の相補誤差関数（complementary error function）の値を返します。

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.erfc(0) # => 1.0
```

- **SEE** [m:Math?.erf]

### module_function def exp(x) -> Float

x の指数関数（exponential）の値を返します。

すなわち e の x 乗の値を返します（e は自然対数の底）。

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.exp(0)     # => 1.0
p Math.exp(1)     # => 2.718281828459045
p Math.exp(1.5)   # => 4.4816890703380645
```

x に負の無限大を渡した場合は 0.0 を返します。これは [m:Math?.log] が 0 に対して
`-Infinity` を返すことと対応しています。

```ruby title="例: 無限大を渡す"
p Math.exp(-Float::INFINITY)  # => 0.0
```

- **SEE** [man:exp(3)], [m:Math?.log]

#@since 4.0
### module_function def expm1(x) -> Float

e の x 乗から 1 を引いた値、すなわち `exp(x) - 1` を返します（e は自然対数の底）。

x が 0 に近いとき、[m:Math?.exp] の結果から 1 を引くと桁落ちによって精度が
失われますが、このメソッドはそれを避けて計算します。

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.expm1(0)    # => 0.0
p Math.expm1(-1.0) # => -0.6321205588285577
p Math.expm1(0.5)  # => 0.6487212707001282
```

```ruby title="例: 0 に近い値での精度"
p Math.exp(1e-16) - 1 # => 0.0     （桁落ちして 0 になる）
p Math.expm1(1e-16)   # => 1.0e-16
```

x に負の無限大を渡した場合は -1.0 を返します。

```ruby title="例: 無限大を渡す"
p Math.expm1(-Float::INFINITY) # => -1.0
p Math.expm1(Float::INFINITY)  # => Infinity
```

- **SEE** [man:expm1(3)], [m:Math?.exp], [m:Math?.log1p]
#@end

### module_function def frexp(x) -> [Float, Integer]

実数 x の仮数部と指数部の配列を返します。

- **param** `x` -- 実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

```ruby title="例"
fraction, exponent = Math.frexp(1234)   # => [0.6025390625, 11]
p fraction * 2**exponent                # => 1234.0
```

### module_function def hypot(x, y) -> Float

sqrt(x*x + y*y) を返します。

この値は x, y を直交する 2 辺とする直角三角形の斜辺（hypotenuse）の長さです。

- **param** `x` -- 実数
- **param** `y` -- 実数

- **raise** `TypeError` -- 引数のどちらかに数値以外を指定した場合に発生します。

- **raise** `RangeError` -- 引数のどちらかに実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.hypot(3, 4) #=> 5.0
```

### module_function def ldexp(x, exp) -> Float

実数 x に 2 の exp 乗をかけた数を返します。

- **param** `x` -- 実数
- **param** `exp` -- 整数。小数点以下切捨て。

- **raise** `TypeError` -- 引数のどちらかに数値以外を指定した場合に発生します。

- **raise** `RangeError` -- 引数のどちらかに実数以外の数値を指定した場合に発生します。

```ruby title="例"
fraction, exponent = Math.frexp(1234)
p Math.ldexp(fraction, exponent) # => 1234.0
```

### module_function def log(x) -> Float
### module_function def log(x, b) -> Float

x の対数（logarithm）を返します。

引数 x, b の両方に 0 を指定した場合は [m:Float::NAN] を返します。

- **param** `x` -- 正の実数を指定します。

- **param** `b` -- 底を指定します。省略した場合は自然対数（natural logarithm）を計算します。

- **raise** `TypeError` -- 引数のどちらかに数値以外を指定した場合に発生します。

- **raise** `RangeError` -- 引数のどちらかに実数以外の数値を指定した場合に発生します。

- **raise** `DomainError` -- 引数のどちらかに負の数を指定した場合に発生します。

```ruby title="例"
p Math.log(0)        # => -Infinity
p Math.log(1)        # => 0.0
p Math.log(Math::E)  # => 1.0
p Math.log(Math::E**3) # => 3.0
p Math.log(12, 3)    # => 2.2618595071429146
```

- **SEE** [m:Math?.log2], [m:Math?.log10], [m:Math?.exp]

### module_function def log2(x) -> Float

2 を底とする x の対数（binary logarithm）を返します。
#@# Returns the base 2 logarithm of numeric.

- **param** `x` -- 正の実数

- **raise** `TypeError` -- xに数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- xに実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.log2(1)    # => 0.0
p Math.log2(2)    # => 1.0
p Math.log2(32768)  # => 15.0
p Math.log2(65536)  # => 16.0
```

- **SEE** [m:Math?.log], [m:Math?.log10]

### module_function def log10(x) -> Float

x の常用対数（common logarithm）を返します。

- **param** `x` -- 正の実数

- **raise** `TypeError` -- xに数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- xに実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.log10(1)     # => 0.0
p Math.log10(10)    # => 1.0
p Math.log10(10**100) # => 100.0
```

- **SEE** [m:Math?.log], [m:Math?.log2]

#@since 4.0
### module_function def log1p(x) -> Float

1 に x を足した値の自然対数、すなわち `log(x + 1)` を返します。

x が 0 に近いとき、1 に x を足してから [m:Math?.log] を取ると桁落ちによって
精度が失われますが、このメソッドはそれを避けて計算します。

- **param** `x` -- -1 以上の実数

- **raise** `TypeError` -- x に数値以外を指定した場合に発生します。

- **raise** `RangeError` -- x に実数以外の数値を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に -1 未満の実数を指定した場合に発生します。

```ruby title="例"
p Math.log1p(0)             # => 0.0
p Math.log1p(Math::E - 1)   # => 1.0
p Math.log1p(-1.0)          # => -Infinity
```

```ruby title="例: 0 に近い値での精度"
p Math.log(1 + 1e-16) # => 0.0     （桁落ちして 0 になる）
p Math.log1p(1e-16)   # => 1.0e-16
```

```ruby title="例: 定義域外"
Math.log1p(-2.0) # ~> Math::DomainError
```

- **SEE** [man:log1p(3)], [m:Math?.log], [m:Math?.expm1]
#@end

### module_function def sqrt(x) -> Float

x の非負の平方根（principal square root）を返します。

- **param** `x` -- 0または正の実数

- **raise** `TypeError` -- xに数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に範囲外の実数を指定した場合に発生します。

- **raise** `RangeError` -- xに実数以外の数値を指定した場合に発生します。

```ruby title="例"
0.upto(10) {|x|
  p [x, Math.sqrt(x), Math.sqrt(x)**2]
}
# => [0, 0.0, 0.0]
#   [1, 1.0, 1.0]
#   [2, 1.4142135623731, 2.0]
#   [3, 1.73205080756888, 3.0]
#   [4, 2.0, 4.0]
#   [5, 2.23606797749979, 5.0]
#   [6, 2.44948974278318, 6.0]
#   [7, 2.64575131106459, 7.0]
#   [8, 2.82842712474619, 8.0]
#   [9, 3.0, 9.0]
#   [10, 3.16227766016838, 10.0]
```

- **SEE** [m:Integer.sqrt], [m:Math?.cbrt]

### module_function def cbrt(x) -> Float

x の立方根（cubic root）を返します。

- **param** `x` -- 実数

- **raise** `TypeError` -- xに数値以外を指定した場合に発生します。

- **raise** `RangeError` -- xに実数以外の数値を指定した場合に発生します。

```ruby title="例"
-9.upto(9) {|x|
  p [x, Math.cbrt(x), Math.cbrt(x)**3]
}
# => [-9, -2.0800838230519, -9.0]
#   [-8, -2.0, -8.0]
#   [-7, -1.91293118277239, -7.0]
#   [-6, -1.81712059283214, -6.0]
#   [-5, -1.7099759466767, -5.0]
#   [-4, -1.5874010519682, -4.0]
#   [-3, -1.44224957030741, -3.0]
#   [-2, -1.25992104989487, -2.0]
#   [-1, -1.0, -1.0]
#   [0, 0.0, 0.0]
#   [1, 1.0, 1.0]
#   [2, 1.25992104989487, 2.0]
#   [3, 1.44224957030741, 3.0]
#   [4, 1.5874010519682, 4.0]
#   [5, 1.7099759466767, 5.0]
#   [6, 1.81712059283214, 6.0]
#   [7, 1.91293118277239, 7.0]
#   [8, 2.0, 8.0]
#   [9, 2.0800838230519, 9.0]
```

- **SEE** [m:Math?.sqrt]

### module_function def gamma(x) -> Float

x のガンマ関数の値を返します。

- **param** `x` -- 実数

- **raise** `TypeError` -- xに数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に負の整数、もしくは -∞ を渡した場合に発生します。

- **raise** `RangeError` -- xに実数以外の数値を指定した場合に発生します。

```ruby title="例"
def fact(n) (1..n).inject(1) {|r,i| r*i } end
1.upto(26) {|i| p [i, Math.gamma(i), fact(i-1)] }
# => [1, 1.0, 1]
#   [2, 1.0, 1]
#   [3, 2.0, 2]
#   [4, 6.0, 6]
#   [5, 24.0, 24]
#   [6, 120.0, 120]
#   [7, 720.0, 720]
#   [8, 5040.0, 5040]
#   [9, 40320.0, 40320]
#   [10, 362880.0, 362880]
#   [11, 3628800.0, 3628800]
#   [12, 39916800.0, 39916800]
#   [13, 479001600.0, 479001600]
#   [14, 6227020800.0, 6227020800]
#   [15, 87178291200.0, 87178291200]
#   [16, 1307674368000.0, 1307674368000]
#   [17, 20922789888000.0, 20922789888000]
#   [18, 355687428096000.0, 355687428096000]
#   [19, 6.402373705728e+15, 6402373705728000]
#   [20, 1.21645100408832e+17, 121645100408832000]
#   [21, 2.43290200817664e+18, 2432902008176640000]
#   [22, 5.109094217170944e+19, 51090942171709440000]
#   [23, 1.1240007277776077e+21, 1124000727777607680000]
#   [24, 2.5852016738885062e+22, 25852016738884976640000]
#   [25, 6.204484017332391e+23, 620448401733239439360000]
#   [26, 1.5511210043330954e+25, 15511210043330985984000000]
```

x に符号付きゼロを渡した場合も +0.0 と -0.0 は区別され、符号付きの無限大を返します。
これは x に負の整数を渡した場合に Math::DomainError が発生するのとは別の挙動です。

```ruby title="例: 符号付きゼロ"
p Math.gamma(0.0)   # =>  Infinity
p Math.gamma(-0.0)  # => -Infinity
```

- **SEE** [m:Math?.lgamma]

### module_function def lgamma(x) -> [Float, Integer]

log(|gamma(x)|) と、gamma(x) の符号を返します。

符号は +1 もしくは -1 で返されます。

- **param** `x` -- 実数

- **raise** `TypeError` -- xに数値以外を指定した場合に発生します。

- **raise** `Math::DomainError` -- x に -∞ を渡した場合に発生します。

- **raise** `RangeError` -- xに実数以外の数値を指定した場合に発生します。

```ruby title="例"
p Math.lgamma(0) # => [Infinity, 1]
```

- **SEE** [m:Math?.gamma]

## Constants

### const E -> Float

自然対数の底

```ruby title="例"
p Math::E
# => 2.718281828
```

### const PI -> Float

円周率

```ruby title="例"
p Math::PI
# => 3.141592654
```

# class Math::DomainError < StandardError

数学関数（module Math のモジュール関数）で与えた引数が定義域
に含まれていない場合に発生します。
