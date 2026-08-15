---
library: _builtin
---
# class Complex < Numeric

複素数を表すクラスです。

実部・虚部を、実数を表す数値オブジェクトとして保持します。

[c:Complex] オブジェクトは以下の方法で生成できます。

- 虚数リテラルで記述する
- [m:Kernel?.Complex]、[m:Complex.rect]、[m:Complex.polar] を使う
- 他の数値クラスのオブジェクトから [m:Numeric#to_c] で変換する
- 文字列表現から [m:String#to_c] で変換する

```ruby title="リテラルによる生成"
p 1i # => (0+1i)
# 虚部は Integer オブジェクトで保持される

p 1.0i # => (0+1.0i)
# 虚部は Float オブジェクトで保持される

p 1ri   # => (0+(1/1)*i)
p 0.5ri # => (0+(1/2)*i)
# 虚部は Rational オブジェクトで保持される

p 1+2i # => (1+2i)
# `1+2i` という形式のリテラルがあるわけではなく、
# Integer のリテラル `1` と虚数リテラル `2i` と
# 減算演算子 `-` からなる演算子式
```

```ruby title="Complex メソッドによる生成"
# 実部のみ与える
p Complex(1)          # => (1+0i)
p Complex(0.3)        # => (0.3+0i)

# 実部と虚部を与える
p Complex(2, 3)       # => (2+3i)

# 文字列表現を与える（実部・虚部に浮動小数点リテラル形式を使う）
p Complex("0.3-0.5i") # => (0.3-0.5i)

# 文字列表現を与える（実部・虚部に有理数リテラル形式を使う）
p Complex("2/3+3/4i") # => ((2/3)+(3/4)*i)

# 文字列表現を与える（絶対値と偏角による極形式）
p Complex("2@3.141592653589793") # => (-2+0.0i)
```

```ruby title="Complex.rect メソッドによる生成"
# 実部と虚部を与える
p Complex.rect(2, 3) # => (2+3i)
# `Complex(2, 3)` と変わらない
```

```ruby title="Complex.polar メソッドによる生成"
# 絶対値と偏角を与える
p Complex.polar(0.5, Math::PI / 2) # => (0.0+0.5i)
```

```ruby title="他の数値クラスオブジェクトからの変換による生成"
p 3.to_c    # => (3+0i)
p 0.3.to_c  # => (0.3+0i)
p 0.5r.to_c # => ((1/2)+0i)
```

```ruby title="文字列表現からの変換による生成"
p "0.3-0.5i".to_c    # => (0.3-0.5i)
p "2/3+3/4i".to_c    # => ((2/3)+(3/4)*i)
p "2@3.141592653589793".to_c # => (-2+0.0i)
```

複素数演算において、オペランドの実部・虚部のクラスは演算結果の実部・虚部のクラスに影響します。

```ruby title="例"
a = 3.0 + 3i
# 実部が Float、虚部が Integer

p a / 2 # => (1.5+(3/2)*i)
# 実部は Float、虚部は Rational になる
```

実部・虚部ともに `Integer` もしくは `Rational` であるような `Complex` オブジェクト、および `Integer` オブジェクト、`Rational` オブジェクトの間の加減乗除算は丸め誤差なく行われます。

```ruby title="虚部が Rational と Float の場合の誤差の比較"
p ([1ri / 10] * 10).sum
# => (0+(1/1)*i)
# 演算誤差無し

# 参考：
p ([1.0i / 10] * 10).sum
# => (0+0.9999999999999999i)
# `1.0i / 10` の時点で誤差が生じている
# それを 10 個足し合わせることで、`to_s` でも分かる誤差になっている
```

## Instance Methods

### def *(other) -> Complex

`self` に `other` を掛けた値（＝積）を返します。

`Complex` オブジェクトを左項とする算術演算子 `*` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に対する乗数

```ruby title="例"
p Complex(1, 2) * 2            # => (2+4i)
p Complex(1, 2) * Complex(2, 3)  # => (-4+7i)
p Complex(1, 2) * Rational(1, 2) # => ((1/2)+(1/1)*i)
```

### def **(other) -> Complex

`self` の `other` 乗を返します。

`Complex` オブジェクトを左項とする算術演算子 `**` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に対する冪指数（べきしすう）

```ruby title="例"
p 1i ** 2 # => (-1+0i)
```

### def +(other) -> Complex

`self` に `other` を足した値（＝和）を返します。

`Complex` オブジェクトを左項とする算術演算子 `+` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に加算する数値

```ruby title="例"
p Complex(1, 2) + Complex(2, 3) # => (3+5i)
```

### def -(other) -> Complex

`self` から `other` を引いた値（＝差）を返します。

`Complex` オブジェクトを左項とする算術演算子 `-` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` から減算する数値

```ruby title="例"
p Complex(1, 2) - Complex(2, 3) # => (-1-1i)
```

### def -@ -> Complex

`0` から `self` を引いた値を返します。

`Complex` オブジェクトに対する単項演算子 `-` はこのメソッドの呼び出しになります。

```ruby title="例"
p -Complex(1)     # => (-1+0i)
p -Complex(-1, 1) # => (1-1i)
```

### def /(other)   -> Complex
### def quo(other) -> Complex

`self` を `other` で割った値（＝商）を返します。

`Complex` オブジェクトを左項とする算術演算子 `/` はこのメソッドの呼び出しになります。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p Complex(1.0) / 2 # => (0.5+0i)
# 実部が Float、虚部が Integer

p Complex(1) / 2.0 # => (0.5+0.0i)
# 実部・虚部ともに Float

p Complex(3, 4) / 2 # => ((3/2)+2i)
# 実部が Rational、虚部が Integer
```

- **SEE** [m:Numeric#quo]

### def ==(other) -> bool

`self` が数値として `other` と等しければ `true` を、そうでなければ `false` を返します。

`other` が数値でないときは `false` を返します。

`Complex` オブジェクトを左項とする比較演算子 `==` はこのメソッドの呼び出しになります。

- **param** `other` -- 比較対象

```ruby title="例"
p Complex(2, 1) == Complex(1) # => false
p Complex(1, 0) == Complex(1) # => true
p Complex(1, 0) == 1          # => true
p Complex(1, 0) == 1.0        # => true
```

### def <=>(other) -> -1 | 0 | 1 | nil

`self` と `other` が共に実数（＝虚部がゼロの数）のとき `self.real <=> other.real` の結果を返します。

そうでないときは `nil` を返します。

`Complex` オブジェクトを左項とする二項演算子 `<=>` はこのメソッドの呼び出しになります。

- **param** `other` -- 比較対象

```ruby title="例"
p Complex(2, 3)  <=> Complex(2, 3) # => nil
p Complex(2, 3)  <=> 1           # => nil
p Complex(2)     <=> 1           # => 1
p Complex(2)     <=> 2           # => 0
p Complex(2)     <=> 3           # => -1
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

`self` の絶対値（absolute value）を返します。

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

`self` の絶対値の 2 乗を返します。

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

`self` の偏角を [-π,π] の範囲で返します。

```ruby title="例"
p Complex.polar(3, Math::PI/2).arg # => 1.5707963267948966
```

非正の実軸付近での挙動に注意してください。以下の例のように虚部が 0.0 と
-0.0 では値が変わります。

```ruby title="例"
p Complex(-1, 0).arg            # =>  3.141592653589793
p Complex(-1, -0).arg           # =>  3.141592653589793
p Complex(-1, -0.0).arg         # => -3.141592653589793

p Complex(0, 0.0).arg           # =>  0.0
p Complex(0, -0.0).arg          # => -0.0
p Complex(-0.0, 0).arg          # =>  3.141592653589793
p Complex(-0.0, -0.0).arg       # => -3.141592653589793
```

メソッド名の `arg` は argument（偏角）に由来しますが、「引数」の argument と紛らわしいためか、`argument` というエイリアスは用意されていません。

- **SEE** [m:Numeric#arg]

### def finite? -> bool

実部と虚部の両方が有限値の場合に `true` を、そうでない場合に `false` を返します。

```ruby title="例"
p (1 + 1i).finite?               # => true
p (Float::INFINITY + 1i).finite? # => false
```

- **SEE** [m:Complex#infinite?]

### def infinite? -> nil | 1

実部と虚部のどちらも正または負の無限大ではない場合に `nil` を、そうでない場合に `1` を返します。

```ruby title="例"
p (1+1i).infinite?                 # => nil
p (Float::INFINITY + 1i).infinite? # => 1
```

- **SEE** [m:Complex#finite?]

### def coerce(other) -> [Complex, Complex]

`other` を [c:Complex] に変換して `[変換後の other, self]` の配列を返します。

- **raise** `TypeError` -- 変換できないオブジェクトを指定した場合に発生します。

```ruby title="例"
p Complex(1).coerce(2) # => [(2+0i), (1+0i)]
```

### def conjugate -> Complex
### def conj      -> Complex

`self` の共役複素数を返します。

```ruby title="例"
p Complex(1, 2).conj # => (1-2i)
```

### def denominator -> Integer

`self` の分母（denominator）を返します。

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

`self` を `other` で割った商を返します。
実部と虚部が共に [c:Float] の値になります。

- **param** `other` -- `self` に対する除数

```ruby title="例"
p Complex(11, 22).fdiv(3) # => (3.6666666666666665+7.333333333333333i)
p Complex(11, 22).quo(3)  # => ((11/3)+(22/3)*i)
```

- **SEE** [m:Complex#quo]

#%# --- hash -> Integer

#%# 自身のハッシュ値を返します。
#%# Complex#hashはnodocのため

### def imag      -> Numeric
### def imaginary -> Numeric

`self` の虚部を返します。

```ruby title="例"
p Complex(3, 2).imag # => 2
```

- **SEE** [m:Numeric#imag]

### def inspect -> String

`self` を人間が読みやすい形の文字列表現にして返します。

```ruby title="例"
p Complex(2).inspect                     # => "(2+0i)"
p Complex('-8/6').inspect                # => "((-4/3)+0i)"
p Complex('1/2i').inspect                # => "(0+(1/2)*i)"
p Complex(0, Float::INFINITY).inspect    # => "(0+Infinity*i)"
p Complex(Float::NAN, Float::NAN).inspect  # => "(NaN+NaN*i)"
```

### def numerator -> Complex

`self` の分子（numerator）を返します。

```ruby title="例"
p Complex('1/2+2/3i').numerator # => (3+4i)
p Complex(3).numerator        # => (3+0i)
```

- **SEE** [m:Complex#denominator]

### def polar -> [Numeric, Numeric]

`self` の絶対値と偏角を配列にして返します。

```ruby title="例"
p Complex.polar(1, 2).polar # => [1.0, 2.0]
```

- **SEE** [m:Numeric#polar]

### def real -> Numeric

`self` の実部を返します。

```ruby title="例"
p Complex(3, 2).real # => 3
```

### def real? -> false

常に `false` を返します。

```ruby title="例"
p (2+3i).real? # => false
p (2+0i).real? # => false
```

- **SEE** [m:Numeric#real?]

### def rect        -> [Numeric, Numeric]
### def rectangular -> [Numeric, Numeric]

`self` の実部と虚部を配列にして返します。

メソッド名は、これが複素数の直交形式（rectangular form）の成分を得るものであることから。

```ruby title="例"
p Complex(3).rect  # => [3, 0]
p Complex(3.5).rect  # => [3.5, 0]
p Complex(3, 2).rect # => [3, 2]
```

- **SEE** [m:Numeric#rect]

### def to_f -> Float

`self` の虚部が [c:Integer] か [c:Rational] のゼロであれば実部を [c:Float] に変換して返します。

- **raise** `RangeError` -- 虚部がゼロでなかったり [c:Float] のゼロである場合に発生します。

```ruby title="例"
p (1 + 0i).to_f  # => 1.0
p (1 + 0ri).to_f # => 1.0
```

```ruby title="変換できない例"
# 虚部がゼロでない
(1 + 2i).to_f # ~> RangeError

# 虚部がゼロだが Float の 0.0 である
(1 + 0.0i).to_f # ~> RangeError
```

### def to_i -> Integer

`self` の虚部が [c:Integer] か [c:Rational] のゼロであれば実部を [c:Integer] に変換して返します。

- **raise** `RangeError` -- 虚部がゼロでなかったり [c:Float] のゼロである場合に発生します。

```ruby title="例"
p (1.9 + 0i).to_i  # => 1
p (1.9 + 0ri).to_i # => 1
```

```ruby title="変換できない例"
# 虚部がゼロでない
(1 + 2i).to_i # ~> RangeError

# 虚部がゼロだが Float の 0.0 である
(1 + 0.0i).to_i # ~> RangeError
```

### def to_r             -> Rational

#%since 3.4
`self` の虚部がゼロであれば実部を [c:Rational] に変換して返します。

- **raise** `RangeError` -- 虚部がゼロでない場合に発生します。
#%else
`self` の虚部が [c:Integer] か [c:Rational] のゼロであれば実部を [c:Rational] に変換して返します。

- **raise** `RangeError` -- 虚部がゼロでなかったり [c:Float] のゼロである場合に発生します。
#%end

```ruby title="例"
p (0.75 + 0i).to_r   # => (3/4)
p (0.75 + 0ri).to_r  # => (3/4)
#%since 3.4
p (0.75 + 0.0i).to_r # => (3/4)
#%end
```

```ruby title="変換できない例"
# 虚部がゼロでない
(1 + 2i).to_r # ~> RangeError
#%until 3.4

# 虚部がゼロだが Float の 0.0 である
(1 + 0.0i).to_r # ~> RangeError
#%end
```

### def rationalize -> Rational
### def rationalize(eps) -> Rational

`self` の虚部が [c:Integer] か [c:Rational] のゼロであれば実部を [c:Rational] に変換して返します。許容誤差 `eps` を与えることもできます。

- **param** `eps` -- 許容する誤差。

- **raise** `RangeError` -- 虚部がゼロでなかったり [c:Float] のゼロである場合に発生します。

```ruby title="例"
p Complex(0.1).rationalize            # => (1/10)
p Complex(Math::PI).rationalize(0.01) # => (22/7)
```

```ruby title="変換できない例"
# 虚部がゼロでない
(1 + 2i).rationalize # ~> RangeError

# 虚部がゼロだが Float の 0.0 である
(1 + 0.0i).rationalize # ~> RangeError
```

- **SEE** [m:Float#rationalize], [m:Integer#rationalize], [m:Rational#rationalize]

### def to_s -> String

`self` を "実部 + 虚部i" 形式の文字列にして返します。

```ruby title="例"
p Complex(2).to_s                     # => "2+0i"
p Complex('-8/6').to_s                # => "-4/3+0i"
p Complex('1/2i').to_s                # => "0+1/2i"
p Complex(0, Float::INFINITY).to_s    # => "0+Infinity*i"
p Complex(Float::NAN, Float::NAN).to_s  # => "NaN+NaN*i"
```

### def to_c -> self
{: since="1.9.1"}

`self` を返します。

```ruby title="例"
p Complex(2).to_c    # => (2+0i)
p Complex(-8, 6).to_c  # => (-8+6i)
```

## Class Methods

### def Complex.rect(real, imag = 0)        -> Complex
### def Complex.rectangular(real, imag = 0) -> Complex

実部が `real`、虚部が `imag` である [c:Complex] クラスのオブジェクトを生成します。

複素数の直交形式（rectangular form）に基づくためこの名があります。

- **param** `real` -- 生成する複素数の実部。

- **param** `imag` -- 生成する複素数の虚部。省略した場合は `0` です。

```ruby title="例"
p Complex.rect(1)         # => (1+0i)
p Complex.rect(1, 2)      # => (1+2i)
p Complex.rectangular(1, 2) # => (1+2i)
```

- **SEE** [m:Kernel?.Complex]

### def Complex.polar(r, theta = 0) -> Complex

絶対値が `r`、偏角が `theta` である [c:Complex] クラスのオブジェクトを生成します。

複素数の極形式（polar form）に基づくためこの名があります。

- **param** `r` -- 生成する複素数の絶対値。

- **param** `theta` -- 生成する複素数の偏角。単位はラジアンです。省略した場合は 0 です。

```ruby title="例"
p Complex.polar(2.0)          # => (2.0+0.0i)
p Complex.polar(2.0, 0)       # => (2.0+0.0i)
p Complex.polar(2.0, Math::PI)  # => (-2.0+0.0i)
```

## Private Instance Methods

### def marshal_dump -> Array

[m:Marshal?.load] のためのメソッドです。
`Complex::compatible#marshal_load` で復元可能な配列を返します。

2.0 以降では [m:Marshal?.load] で 1.8 系の [c:Complex] オブジェクトを保存した文字列も復元できます。

[注意] `Complex::compatible` は通常の方法では参照できません。

#%# https://bugs.ruby-lang.org/issues/6625 を参照。

## Constants

### const I -> Complex

虚数単位です。`(0+1i)` を返します。
