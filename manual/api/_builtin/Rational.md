---
library: _builtin
---
# class Rational < Numeric

有理数を表すクラスです。

分子・分母を [c:Integer] オブジェクトとして保持します。

`Rational` オブジェクトはリテラルや [m:Kernel?.Rational] メソッドによって生成できます。

```ruby title="リテラルによる生成"
# 10 進整数に `r` を付けた形式
p -3r # => (-3/1)

# 10 進小数に `r` を付けた形式
p 0.1r # => (1/10)
# Float のリテラル `0.1` と違い、
# 誤差無しで 0.1 を表す Rational オブジェクトが得られる

p 3/4r # => (3/4)
# `3/4r` という形式の Rational のリテラルがあるわけではなく、
# Integer のリテラル `3` と Rational のリテラル `4r` と
# 除算演算子 `/` からなる演算子式
# `3r/4` と書くこともできる
```

```ruby title="Rational メソッドによる生成"
# 分子・分母を引数として与える
p Rational(3, 4)     # => (3/4)

# 整数の場合、分母 `1` は略せる
p Rational(3) # => (3/1)

# 分数形式の文字列を与える
p Rational("3/4")    # => (3/4)

# 10 進整数、10 進小数の形式の文字列を与える
p Rational("3") # => (3/1)
p Rational("-0.1") # => (-1/10)
```

`Rational.new` で生成することはできません（[c:Integer] や [c:Float]
と同様）。

```ruby
Rational.new(1, 3) # ~> NoMethodError
```

[c:Rational] オブジェクトは常に既約（それ以上約分できないこと）かつ分母が正であるような分子・分母を保持しています。

```ruby
p Rational(2, -6) # => (-1/3)

# 計算結果として生じる Rational オブジェクトもそうなっている
p Rational(2, 3) / (-4) # => (-1/6)
```

## Public Instance Methods

### def *(other) -> Rational | Float

`self` に `other` を掛けた値（＝積）を返します。

`Rational` オブジェクトを左項とする算術演算子 `*` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に対する乗数

`other` に [c:Float] を指定した場合は、計算結果を [c:Float] で返します。

```ruby title="例"
r = Rational(3, 4)
p r * 2              # => (3/2)
p r * 4              # => (3/1)
p r * 0.5            # => 0.375
p r * Rational(1, 2) # => (3/8)
```

### def **(other) -> Rational | Float

`self` の `other` 乗を返します。

`Rational` オブジェクトを左項とする算術演算子 `**` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に対する冪指数（べきしすう）
#%since 3.4
- **raise** `ArgumentError` -- 計算結果の分母・分子が巨大すぎる場合に発生します。
#%end

`other` に [c:Float] を指定した場合は、計算結果を [c:Float] で返します。
`other` が有理数であっても、計算結果が無理数だった場合は [c:Float] を返します。

```ruby title="例"
r = Rational(3, 4)
p r ** Rational(2, 1)  # => (9/16)
p r ** 2             # => (9/16)
p r ** 2.0           # => 0.5625
p r ** Rational(1, 2)  # => 0.8660254037844386
```

#%until 3.4
計算結果の分母・分子が巨大になりすぎるとき、警告を出したうえで [m:Float::INFINITY]（基数によっては [m:Float::NAN]）を返します。

```ruby title="計算を放棄して Float::INFINITY を返す例"
p Rational(2) ** 100000000
# => warning: in a**b, b may be too big
#    Infinity
```

判定の閾値は変わりえます。
#%end

#%since 3.4
計算結果の分母・分子が巨大すぎるときは [c:ArgumentError] が発生します。

```ruby title="計算結果が巨大すぎる例"
p Rational(2) ** 10000000000000000000
# ~> ArgumentError: exponent is too large
```

判定の閾値は変わりえます。
#%end

### def +(other) -> Rational | Float

`self` に `other` を足した値（＝和）を返します。

`Rational` オブジェクトを左項とする算術演算子 `+` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に加算する数値

`other` に [c:Float] を指定した場合は、計算結果を [c:Float] で返します。

```ruby title="例"
r = Rational(3, 4)
p r + Rational(1, 2)   # => (5/4)
p r + 1                # => (7/4)
p r + 0.5              # => 1.25
```

### def -(other) -> Rational | Float

`self` から `other` を引いた値（＝差）を返します。

`Rational` オブジェクトを左項とする算術演算子 `-` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` から減算する数値

`other` に [c:Float] を指定した場合は、計算結果を [c:Float] で返します。

```ruby title="例"
r = Rational(3, 4)
p r - 1              # => (-1/4)
p r - 0.5            # => 0.25
```

### def /(other)   -> Rational | Float
### def quo(other) -> Rational | Float

`self` を `other` で割った値（＝商）を返します。

`Rational` オブジェクトを左項とする算術演算子 `/` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` を割る数

`other` に [c:Float] を指定した場合は、計算結果を [c:Float] で返します。

```ruby title="例"
r = Rational(3, 4)
p r / 2              # => (3/8)
p r / 2.0            # => 0.375
p r / 0.5            # => 1.5
p r / Rational(1, 2) # => (3/2)
r / 0                # ~> ZeroDivisionError
```

- **raise** `ZeroDivisionError` -- `other` が `0` のときに発生します。

- **SEE** [m:Numeric#quo]

### def -@ -> Rational
{: since="1.9.1"}

`self` の符号を反転させたものを返します。

`Rational` オブジェクトに対する単項演算子 `-` はこのメソッドの呼び出しになります。

```ruby title="例"
r = Rational(3, 4)
p(- r)        # => (-3/4)
```

### def <=>(other) -> -1 | 0 | 1 | nil

`self` を `other` と比較し、`self` が `other` より大きければ `1` を、等しければ `0` を、小さければ `-1` を返します。
比較できないときは `nil` を返します。

`Rational` オブジェクトを左項とする二項演算子 `<=>` はこのメソッドの呼び出しになります。

- **param** `other` -- 比較対象

```ruby title="例"
p Rational(2, 3)  <=> Rational(2, 3)  # => 0
p Rational(5)     <=> 5             # => 0
p Rational(2, 3)  <=> Rational(1,3) # => 1
p Rational(1, 3)  <=> 1             # => -1
p Rational(1, 3)  <=> 0.3           # => 1
p Rational(1, 3)  <=> nil           # => nil
```

### def ==(other) -> bool

`self` が数値として `other` と等しければ `true` を、そうでなければ `false` を返します。

`other` が数値でないときは `false` を返します。

`Rational` オブジェクトを左項とする比較演算子 `==` はこのメソッドの呼び出しになります。

- **param** `other` -- 比較対象

```ruby title="例"
p Rational(2, 3)  == Rational(2, 3) # => true
p Rational(5)     == 5              # => true
p Rational(0)     == 0.0            # => true
p Rational('1/3') == 0.33           # => false
p Rational('1/2') == '1/2'          # => false
```

### def positive? -> bool
{: since="2.3.0"}

`self` が正の数なら `true` を、そうでないなら `false` を返します。

```ruby title="例"
p Rational(1, 2).positive?  # => true
p Rational(-1, 2).positive? # => false
```

- **SEE** [m:Rational#negative?]

### def negative? -> bool
{: since="2.3.0"}

`self` が負の数なら `true` を、そうでないなら `false` を返します。

```ruby title="例"
p Rational(1, 2).negative?  # => false
p Rational(-1, 2).negative? # => true
```

- **SEE** [m:Rational#positive?]

### def abs       -> Rational
{: since="1.9.1"}
### def magnitude -> Rational
{: since="1.9.1"}

`self` の絶対値（absolute value）を返します。

```ruby title="例"
p Rational(1, 2).abs   # => (1/2)
p Rational(-1, 2).abs  # => (1/2)
```

### def ceil(precision = 0) -> Integer | Rational

`self` と等しいかより大きな整数のうち最小のものを返します。

- **param** `precision` -- 計算結果の精度

- **raise** `TypeError` -- `precision` に整数以外のものを指定すると発生します。

```ruby title="例"
p Rational(3).ceil    # => 3
p Rational(2, 3).ceil # => 1
p Rational(-3, 2).ceil  # => -1
```

`precision` を指定した場合は指定した桁数の数値と、上述の性質に最も近い整数か [c:Rational] を返します。

```ruby title="例"
p Rational('-123.456').ceil(+1)     # => (-617/5)
p Rational('-123.456').ceil(+1).to_f  # => -123.4
p Rational('-123.456').ceil(0)      # => -123
p Rational('-123.456').ceil(-1)     # => -120
```

- **SEE** [m:Rational#floor], [m:Rational#round], [m:Rational#truncate]

### def coerce(other) -> Array

`self` と `other` が同じクラスになるよう、`self` か `other` を変換し `[other, self]` という配列にして返します。

- **param** `other` -- 比較または変換するオブジェクト

```ruby title="例"
p Rational(1).coerce(2) # => [(2/1), (1/1)]
p Rational(1).coerce(2.2) # => [2.2, 1.0]
```

### def denominator -> Integer

`self` の分母（denominator）を返します。分母は常に正の整数です。

```ruby title="例"
p Rational(7).denominator     # => 1
p Rational(7, 1).denominator  # => 1
p Rational(9, -4).denominator # => 4
p Rational(-2, -10).denominator # => 5
```

- **SEE** [m:Rational#numerator]

### def fdiv(other) -> Float

`self` を `other` で割った商を [c:Float] で返します。
`other` に虚数を指定することはできません。

- **param** `other` -- `self` を割る数

```ruby title="例"
p Rational(2, 3).fdiv(1) # => 0.6666666666666666
p Rational(2, 3).fdiv(0.5) # => 1.3333333333333333
p Rational(2).fdiv(3)    # => 0.6666666666666666

p Rational(1).fdiv(Complex(1, 0))  # => 1.0
Rational(1).fdiv(Complex(0, 1))  # ~> RangeError
```

### def floor(precision = 0) -> Integer | Rational

`self` と等しいかより小さな整数のうち最大のものを返します。

- **param** `precision` -- 計算結果の精度

- **raise** `TypeError` -- `precision` に整数以外のものを指定すると発生します。

```ruby title="例"
p Rational(3).floor   # => 3
p Rational(2, 3).floor  # => 0
p Rational(-3, 2).floor # => -2
```

[m:Rational#to_i] とは違う結果を返す事に注意してください。

```ruby title="例"
p Rational(+7, 4).to_i  # => 1
p Rational(+7, 4).floor # => 1
p Rational(-7, 4).to_i  # => -1
p Rational(-7, 4).floor # => -2
```

`precision` を指定した場合は指定した桁数の数値と、上述の性質に最も近い整数か [c:Rational] を返します。

```ruby title="例"
p Rational('-123.456').floor(+1)     # => (-247/2)
p Rational('-123.456').floor(+1).to_f  # => -123.5
p Rational('-123.456').floor(0)      # => -124
p Rational('-123.456').floor(-1)     # => -130
```

- **SEE** [m:Rational#ceil], [m:Rational#round], [m:Rational#truncate]

### def hash -> Integer

`self` のハッシュ値を返します。

#%#noexample

- **SEE** [m:Object#hash]

### def inspect -> String

`self` を人間が読みやすい形の文字列表現にして返します。

`"(3/5)"`, `"(-17/7)"` のように10進数の表記を返します。

- **return** -- 有理数の表記にした文字列を返します。

```ruby title="例"
p Rational(5, 8).inspect  # => "(5/8)"
p Rational(2).inspect   # => "(2/1)"
p Rational(-8, 6).inspect # => "(-4/3)"
p Rational(0.5).inspect # => "(1/2)"
```

- **SEE** [m:Rational#to_s]

### def numerator -> Integer

`self` の分子（numerator）を返します。

```ruby title="例"
p Rational(7).numerator     # => 7
p Rational(7, 1).numerator  # => 7
p Rational(9, -4).numerator # => -9
p Rational(-2, -10).numerator # => 1
```

- **SEE** [m:Rational#denominator]

### def rationalize(eps = 0) -> Rational

`self` から `eps` で指定した許容誤差の範囲に収まるような [c:Rational] を返します。

`eps` を省略した場合は `self` を返します。

- **param** `eps` -- 許容する誤差

```ruby title="例"
r = Rational(5033165, 16777216)
p r.rationalize                 # => (5033165/16777216)
p r.rationalize(Rational(0.01)) # => (3/10)
p r.rationalize(Rational(0.1))  # => (1/3)
```

### def round(precision = 0) -> Integer | Rational

`self` ともっとも近い整数を返します。

中央値 `0.5`, `-0.5` はそれぞれ `1`, `-1` に切り上げされます。

- **param** `precision` -- 計算結果の精度

- **raise** `TypeError` -- `precision` に整数以外のものを指定すると発生します。

```ruby title="例"
p Rational(3).round   # => 3
p Rational(2, 3).round  # => 1
p Rational(-3, 2).round # => -2
```

`precision` を指定した場合は指定した桁数の数値と、上述の性質に最も近い整数か [c:Rational] を返します。

```ruby title="例"
p Rational('-123.456').round(+1)    # => (-247/2)
p Rational('-123.456').round(+1).to_f # => -123.5
p Rational('-123.456').round(0)     # => -123
p Rational('-123.456').round(-1)    # => -120
p Rational('-123.456').round(-2)    # => -100
```

- **SEE** [m:Rational#ceil], [m:Rational#floor], [m:Rational#truncate]

### def to_f -> Float

`self` の値を最も良く表現する [c:Float] に変換します。

絶対値が極端に小さい、または大きい場合にはゼロや正負の無限大が返ることがあります。

- **return** -- [c:Float] を返します。

```ruby title="例"
p Rational(2).to_f           # => 2.0
p Rational(9, 4).to_f        # => 2.25
p Rational(-3, 4).to_f       # => -0.75
p Rational(20, 3).to_f       # => 6.666666666666667
p Rational(1, 10**1000).to_f # => 0.0
p Rational(-1, 10**1000).to_f  # => -0.0
p Rational(10**1000).to_f    # => Infinity
p Rational(-10**1000).to_f   # => -Infinity
```

### def to_i -> Integer
### def truncate(precision = 0) -> Rational | Integer

小数点以下を切り捨てて値を整数に変換して返します。

- **param** `precision` -- 計算結果の精度

- **raise** `TypeError` -- `precision` に整数以外のものを指定すると発生します。

```ruby title="例"
p Rational(2, 3).to_i # => 0
p Rational(3).to_i    # => 3
p Rational(300.6).to_i  # => 300
p Rational(98, 71).to_i # => 1
p Rational(-31, 2).to_i # => -15
```

`precision` を指定した場合は指定した桁数で切り捨てた整数か
[c:Rational] を返します。

```ruby title="例"
p Rational('-123.456').truncate(+1)     # => (-617/5)
p Rational('-123.456').truncate(+1).to_f  # => -123.4
p Rational('-123.456').truncate(0)      # => -123
p Rational('-123.456').truncate(-1)     # => -120
```

- **SEE** [m:Rational#ceil], [m:Rational#floor]

### def to_r -> Rational

`self` を返します。

```ruby title="例"
p Rational(3, 4).to_r  # => (3/4)
p Rational(8).to_r   # => (8/1)
```

### def to_s -> String

`self` を人間が読みやすい形の文字列表現にして返します。

`"3/5"`, `"-17/7"` のように10進数の表記を返します。

- **return** -- 有理数の表記にした文字列を返します。

```ruby title="例"
p Rational(3, 4).to_s  # => "3/4"
p Rational(8).to_s   # => "8/1"
p Rational(-8, 6).to_s # => "-4/3"
p Rational(0.5).to_s # => "1/2"
```

- **SEE** [m:Rational#inspect]

## Private Instance Methods

### def marshal_dump -> Array

[m:Marshal?.load] のためのメソッドです。
`Rational::compatible#marshal_load` で復元可能な配列を返します。

[注意] `Rational::compatible` は通常の方法では参照できません。

#%# https://bugs.ruby-lang.org/issues/6625 を参照。

## Private Singleton Methods

### def Rational.convert(*arg) -> Rational

引数を有理数([c:Rational])に変換した結果を返します。

- **param** `arg` -- 変換対象のオブジェクトです。

[m:Kernel?.Rational] の本体です。

- **SEE** [m:Kernel?.Rational]
