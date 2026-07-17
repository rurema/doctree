---
library: _builtin
---
# class Complex < Numeric

複素数を扱うクラスです。

[c:Complex] オブジェクトを作成するには、[m:Kernel?.Complex]、
[m:Complex.rect]、[m:Complex.polar]、[m:Numeric#to_c]、
[m:String#to_c] のいずれかを使用します。

```ruby title="Complex オブジェクトの作り方"
p Complex(1)         # => (1+0i)
p Complex(2, 3)      # => (2+3i)
p Complex.polar(2, 3)  # => (-1.9799849932008908+0.2822400161197344i)
p Complex(0.3)       # => (0.3+0i)
p Complex('0.3-0.5i')  # => (0.3-0.5i)
p Complex('2/3+3/4i')  # => ((2/3)+(3/4)*i)
p Complex('1@2')     # => (-0.4161468365471424+0.9092974268256817i)
p 3.to_c             # => (3+0i)
p 0.3.to_c           # => (0.3+0i)
p '0.3-0.5i'.to_c    # => (0.3-0.5i)
p '2/3+3/4i'.to_c    # => ((2/3)+(3/4)*i)
p '1@2'.to_c         # => (-0.4161468365471424+0.9092974268256817i)
```

[c:Complex] オブジェクトは有理数の形式も実数の形式も扱う事ができます。

```ruby title="例"
p Complex(1, 1) / 2  # => ((1/2)+(1/2)*i)
p Complex(1, 1) / 2.0  # => (0.5+0.5i)
```

## Instance Methods

### def *(other) -> Complex

積を計算します。

- **param** `other` -- 自身に掛ける数

```ruby title="例"
p Complex(1, 2) * 2            # => (2+4i)
p Complex(1, 2) * Complex(2, 3)  # => (-4+7i)
p Complex(1, 2) * Rational(1, 2) # => ((1/2)+(1/1)*i)
```

### def **(other) -> Complex

冪(べき)乗を計算します。

- **param** `other` -- 自身を other 乗する数

```ruby title="例"
p Complex('i') ** 2           # => (-1+0i)
```

### def +(other) -> Complex

和を計算します。

- **param** `other` -- 自身に足す数

```ruby title="例"
p Complex(1, 2) + Complex(2, 3) # => (3+5i)
```

### def -(other) -> Complex

差を計算します。

- **param** `other` -- 自身から引く数

```ruby title="例"
p Complex(1, 2) - Complex(2, 3) # => (-1-1i)
```

### def -@ -> Complex

自身の符号を反転させたものを返します。

```ruby title="例"
p -Complex(1)   # => (-1+0i)
p -Complex(-1, 1) # => (1-1i)
```

### def /(other)   -> Complex
### def quo(other) -> Complex

商を計算します。

- **param** `other` -- 自身を割る数

```ruby title="例"
p Complex(10.0) / 3  # => (3.3333333333333335+(0/1)*i)
p Complex(10)   / 3  # => ((10/3)+(0/1)*i)
```

- **SEE** [m:Numeric#quo]

### def ==(other) -> bool

数値として等しいか判定します。

- **param** `other` -- 自身と比較する数値

```ruby title="例"
p Complex(2, 1) == Complex(1) # => false
p Complex(1, 0) == Complex(1) # => true
p Complex(1, 0) == 1        # => true
```

### def <=>(other) -> -1 | 0 | 1 | nil

self の虚部がゼロで other が実数の場合、
self の実部の <=> メソッドで other と比較した結果を返します。
other が Complex で虚部がゼロの場合も同様です。

その他の場合は nil を返します。

- **param** `other` -- 自身と比較する数値

```ruby title="例"
p Complex(2, 3)  <=> Complex(2, 3) #=> nil
p Complex(2, 3)  <=> 1           #=> nil
p Complex(2)     <=> 1           #=> 1
p Complex(2)     <=> 2           #=> 0
p Complex(2)     <=> 3           #=> -1
```


### def <(other)    -> bool
{: undef}

### def >(other)    -> bool
{: undef}

### def <=(other)    -> bool
{: undef}

### def >=(other)    -> bool
{: undef}

### def between?(min, max)    -> bool
{: undef}


### def clamp(range)     -> object
{: undef}

### def abs       -> Numeric
### def magnitude -> Numeric

自身の絶対値を返します。

以下の計算の結果を [c:Float] オブジェクトで返します。

```text
sqrt(self.real ** 2 + self.imag ** 2)
```

```ruby title="例"
p Complex(1, 2).abs       # => 2.23606797749979
p Complex(3, 4).abs       # => 5.0
p Complex('1/2', '1/2').abs # => 0.7071067811865476
```

- **SEE** [m:Complex#abs2]

### def abs2 -> Numeric

自身の絶対値の 2 乗を返します。

以下の計算の結果を返します。

```text
self.real ** 2 + self.imag ** 2
```

```ruby title="例"
p Complex(1, 1).abs2       # => 2
p Complex(1.0, 1.0).abs2   # => 2.0
p Complex('1/2', '1/2').abs2 # => (1/2)
```

- **SEE** [m:Complex#abs]

### def arg   -> Float
### def angle -> Float
### def phase -> Float

自身の偏角を[-π,π]の範囲で返します。

```ruby title="例"
p Complex.polar(3, Math::PI/2).arg # => 1.5707963267948966
```

非正の実軸付近での挙動に注意してください。以下の例のように虚部が 0.0 と
-0.0 では値が変わります。

```ruby title="例"
p Complex(-1, 0).arg            #=>  3.141592653589793
p Complex(-1, -0).arg           #=>  3.141592653589793
p Complex(-1, -0.0).arg         #=> -3.141592653589793

p Complex(0, 0.0).arg           #=>  0.0
p Complex(0, -0.0).arg          #=> -0.0
p Complex(-0.0, 0).arg          #=>  3.141592653589793
p Complex(-0.0, -0.0).arg       #=> -3.141592653589793
```


- **SEE** [m:Numeric#arg]

### def finite? -> bool

実部と虚部の両方が有限値の場合に true を、そうでない場合に false を返します。

```ruby title="例"
p (1 + 1i).finite?               # => true
p (Float::INFINITY + 1i).finite? # => false
```

- **SEE** [m:Complex#infinite?]

### def infinite? -> nil | 1

実部と虚部のどちらも無限大ではない場合に nil を、そうでない場合に 1 を返します。

```ruby title="例"
p (1+1i).infinite?                 # => nil
p (Float::INFINITY + 1i).infinite? # => 1
```

- **SEE** [m:Complex#finite?]

### def coerce(other) -> [Complex, Complex]

other を [c:Complex] に変換して [変換後の other, self] の配列を返します。

- **raise** `TypeError` -- 変換できないオブジェクトを指定した場合に発生します。

```ruby title="例"
p Complex(1).coerce(2) # => [(2+0i), (1+0i)]
```

### def conjugate -> Complex
### def conj      -> Complex

自身の共役複素数を返します。

```ruby title="例"
p Complex(1, 2).conj # => (1-2i)
```

### def denominator -> Integer

分母を返します。

以下のように、実部と虚部の分母の最小公倍数を整数で返します。

```text
1   2       3+4i  <-  numerator(分子)
- + -i  ->  ----
2   3        6    <-  denominator(分母)
```

```ruby title="例"
p Complex('1/2+2/3i').denominator # => 6
p Complex(3).denominator          # => 1
```

- **SEE** [m:Complex#numerator]

### def fdiv(other) -> Complex

self を other で割った商を返します。
実部と虚部が共に [c:Float] の値になります。

- **param** `other` -- 自身を割る数

```ruby title="例"
p Complex(11, 22).fdiv(3) # => (3.6666666666666665+7.333333333333333i)
p Complex(11, 22).quo(3)  # => ((11/3)+(22/3)*i)
```

- **SEE** [m:Complex#quo]

#@# --- hash -> Integer

#@# 自身のハッシュ値を返します。
#@# Complex#hashはnodocのため

### def imag      -> Numeric
### def imaginary -> Numeric

自身の虚部を返します。

```ruby title="例"
p Complex(3, 2).imag # => 2
```

- **SEE** [m:Numeric#imag]

### def inspect -> String

自身を人間が読みやすい形の文字列表現にして返します。

```ruby title="例"
p Complex(2).inspect                     # => "(2+0i)"
p Complex('-8/6').inspect                # => "((-4/3)+0i)"
p Complex('1/2i').inspect                # => "(0+(1/2)*i)"
p Complex(0, Float::INFINITY).inspect    # => "(0+Infinity*i)"
p Complex(Float::NAN, Float::NAN).inspect  # => "(NaN+NaN*i)"
```


### def numerator -> Complex

分子を返します。

```ruby title="例"
p Complex('1/2+2/3i').numerator # => (3+4i)
p Complex(3).numerator        # => (3+0i)
```

- **SEE** [m:Complex#denominator]

### def polar -> [Numeric, Numeric]

自身の絶対値と偏角を配列にして返します。

```ruby title="例"
p Complex.polar(1, 2).polar # => [1, 2]
```

- **SEE** [m:Numeric#polar]

### def real -> Numeric

自身の実部を返します。

```ruby title="例"
p Complex(3, 2).real # => 3
```

### def real? -> false

常に false を返します。

```ruby title="例"
p (2+3i).real? # => false
p (2+0i).real? # => false
```

- **SEE** [m:Numeric#real?]

### def rect        -> [Numeric, Numeric]
### def rectangular -> [Numeric, Numeric]

実部と虚部を配列にして返します。

```ruby title="例"
p Complex(3).rect  # => [3, 0]
p Complex(3.5).rect  # => [3.5, 0]
p Complex(3, 2).rect # => [3, 2]
```

- **SEE** [m:Numeric#rect]

### def to_f -> Float

自身を [c:Float] に変換します。

- **raise** `RangeError` -- 虚部が実数か、0 ではない場合に発生します。

```ruby title="例"
p Complex(3).to_f  # => 3.0
p Complex(3.5).to_f  # => 3.5
Complex(3, 2).to_f # => RangeError
```

### def to_i -> Integer

自身を整数に変換します。

- **raise** `RangeError` -- 虚部が実数か、0 ではない場合に発生します。

```ruby title="例"
p Complex(3).to_i  # => 3
p Complex(3.5).to_i  # => 3
Complex(3, 2).to_i # => RangeError
```

### def to_r             -> Rational
### def rationalize      -> Rational
### def rationalize(eps) -> Rational

自身を [c:Rational] に変換します。

- **param** `eps` -- 許容する誤差。常に無視されます。

- **raise** `RangeError` -- 虚部が実数か、0 ではない場合に発生します。

```ruby title="例"
p Complex(3).to_r  # => (3/1)
Complex(3, 2).to_r # => RangeError
```

#@# rationalize メソッドの引数 eps は常に無視されるため、to_r メソッド
#@# と同じエントリとしました(sho-h)。

### def to_s -> String

自身を "実部 + 虚部i" 形式の文字列にして返します。

```ruby title="例"
p Complex(2).to_s                     # => "2+0i"
p Complex('-8/6').to_s                # => "-4/3+0i"
p Complex('1/2i').to_s                # => "0+1/2i"
p Complex(0, Float::INFINITY).to_s    # => "0+Infinity*i"
p Complex(Float::NAN, Float::NAN).to_s  # => "NaN+NaN*i"
```

### def to_c -> self

self を返します。

```ruby title="例"
p Complex(2).to_c    # => (2+0i)
p Complex(-8, 6).to_c  # => (-8+6i)
```

## Class Methods

### def rect(r, i = 0)        -> Complex
### def rectangular(r, i = 0) -> Complex

実部が r、虚部が i である [c:Complex] クラスのオブジェクトを生成します。

- **param** `r` -- 生成する複素数の実部。

- **param** `i` -- 生成する複素数の虚部。省略した場合は 0 です。

```ruby title="例"
p Complex.rect(1)         # => (1+0i)
p Complex.rect(1, 2)      # => (1+2i)
p Complex.rectangular(1, 2) # => (1+2i)
```

- **SEE** [m:Kernel?.Complex]

### def polar(r, theta = 0) -> Complex

絶対値が r、偏角が theta である [c:Complex] クラスのオブジェクトを生成します。

- **param** `r` -- 生成する複素数の絶対値。

- **param** `theta` -- 生成する複素数の偏角。単位はラジアンです。省略した場合は 0 です。

```ruby title="例"
p Complex.polar(2.0)          # => (2.0+0.0i)
p Complex.polar(2.0, 0)       # => (2.0+0.0i)
p Complex.polar(2.0, Math::PI)  # => (-2.0+2.4492127076447545e-16i)
```

## Private Instance Methods

### def marshal_dump -> Array

[m:Marshal?.load] のためのメソッドです。
Complex::compatible#marshal_load で復元可能な配列を返します。

2.0 以降では [m:Marshal?.load] で 1.8 系の [c:Complex] オブジェクト
を保存した文字列も復元できます。

[注意] Complex::compatible は通常の方法では参照する事ができません。

#@# #6625 を参照。

## Constants

### const I -> Complex

虚数単位です。(0+1i) を返します。
