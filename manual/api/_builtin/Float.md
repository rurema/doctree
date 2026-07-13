---
library: _builtin
---
# class Float < Numeric

浮動小数点数のクラス。Float の実装は C 言語の double で、その精度は環
境に依存します。

一般にはせいぜい15桁です。詳しくは多くのシステムで採用されている
浮動小数点標準規格、IEEE (Institute of Electrical and
Electronics Engineers: 米国電気電子技術者協会) 754 を参照してください。

```ruby title="あるシステムでの 1/3(=0.333...) の結果"
printf("%.50f\n", 1.0/3)
  # => 0.33333333333333331482961625624739099293947219848633
```

[m:Math::PI] などの数学定数については [c:Math] を
参照してください。

## Instance Methods

### def +(other) -> Float
算術演算子。和を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)

```ruby title="例"
# 和
p 3.0 + 4.5 # => 7.5
```

### def -(other) -> Float
算術演算子。差を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)

```ruby title="例"
# 差
p 4.5 - 1.3 # => 3.2
```

### def -@    -> Float

単項演算子の - です。
self の符号を反転させたものを返します。

```ruby title="例"
p(- 1.2) # => -1.2
p(- -1.2)  # => 1.2
```

### def *(other) -> Float
算術演算子。積を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)

```ruby title="例"
# 積
p 2.4 * 3 # => 7.2
```


### def /(other) -> Float
算術演算子。商を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)

```ruby title="例"
# 商
p 1.3 / 2.4 # => 0.541666666666667
p 1.0 / 0 # => Infinity
```

### def %(other) -> Float
### def modulo(other) -> Float
算術演算子。剰余を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)

```ruby title="例"
# 剰余
p 3.0 % 1.2 # => 0.6000000000000001
3.0 % 0.0   # ZeroDivisionError
```

### def **(other) -> Float
算術演算子。冪を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)

```ruby title="例"
# 冪
p 1.2 ** 3.0  # => 1.7279999999999998
p 3.0 + 4.5 - 1.3 / 2.4 * 3 % 1.2 ** 3.0 # => 5.875
p 0.0 ** 0 # => 1.0
```

### def <=>(other) -> -1 | 0 | 1 | nil
self と other を比較して、self が大きい時に正、
等しい時に 0、小さい時に負の整数を返します。
比較できない場合はnilを返します

```ruby title="例"
p 3.05 <=> 3.14   # => -1
p 1.732 <=> 1.414 # => 1
p 3.3 - 3.3 <=> 0.0 # => 0
p 3.14 <=> "hoge" # => nil
p 3.14 <=> 0.0/0.0  # => nil
```

### def ==(other) -> bool

比較演算子。数値として等しいか判定します。

- **param** `other` -- 比較対象の数値

- **return** --      self と other が等しい場合 true を返します。
             そうでなければ false を返します。

```ruby title="例"
p 3.14 == 3.14000 # => true
p 3.14 == 3.1415  # => false
```

NaNどうしの比較は、未定義です。
```ruby title="例"
p Float::NAN == Float::NAN    # => false
p [Float::NAN] == [Float::NAN]  # => true
p [Float::NAN] == [0.0 / 0.0] # => false
```

### def <(other)  -> bool
比較演算子。数値として小さいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other が大きい場合 true を返します。
             そうでなければ false を返します。

```ruby title="例"
p 3.14 <  3.1415  # => true
p 3.14 <= 3.1415  # => true
```

### def <=(other) -> bool
比較演算子。数値として等しいまたは小さいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other の方が大きい場合か、
             両者が等しい場合 true を返します。
             そうでなければ false を返します。

```ruby title="例"
p 3.14 <  3.1415  # => true
p 3.14 <= 3.1415  # => true
```

### def >(other)  -> bool
比較演算子。数値として大きいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other の方が小さい場合 true を返します。
             そうでなければ false を返します。

```ruby title="例"
p 3.14 >  3.1415  # => false
p 3.14 >= 3.1415  # => false
```

### def >=(other) -> bool
比較演算子。数値として等しいまたは大きいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other の方が小さい場合か、
             両者が等しい場合 true を返します。
             そうでなければ false を返します。

```ruby title="例"
p 3.14 >  3.1415  # => false
p 3.14 >= 3.1415  # => false
```

### def finite? -> bool

数値が ∞, -∞, あるいは NaN でない場合に true を返します。
そうでない場合に false を返します。

```ruby title="例"
p 3.14.finite? # => true
inf = 1.0/0
p inf.finite? # => false
```

### def infinite? -> 1 | -1 | nil

数値が +∞ のとき 1、-∞のとき -1 を返します。それ以外は nil を返
します。

```ruby title="例"
inf = 1.0/0
p inf            # => Infinity
p inf.infinite?  # => 1

inf = -1.0/0
p inf            # => -Infinity
p inf.infinite?  # => -1
```

### def nan? -> bool

数値が NaN(Not a number)のとき真を返します。

```ruby title="例"
nan = 0.0/0.0
p nan       # => NaN
p nan.nan?  # => true
```

### def to_f -> self
self を返します。

```ruby title="例"
p 3.14.to_f # => 3.14
```

### def to_i -> Integer
#@since 2.4.0
### def truncate(ndigits = 0) -> Integer | Float
#@else
### def truncate -> Integer
#@end

小数点以下を切り捨てて値を整数に変換します。

#@since 2.4.0
- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               正の整数を指定した場合、[c:Float] を返します。
               小数点以下を、最大 n 桁にします。
               負の整数を指定した場合、[c:Integer] を返します。
               小数点位置から左に少なくとも n 個の 0 が並びます。
#@end

```ruby title="例"
p 2.8.truncate         # => 2
p (-2.8).truncate      # => -2
#@since 2.4.0
p 1.234567.truncate(2) # => 1.23
p 34567.89.truncate(-2)  # => 34500
#@end
```

- **SEE** [m:Numeric#round], [m:Numeric#ceil], [m:Numeric#floor]

### def hash -> Integer
ハッシュ値を返します。

```ruby title="例"
pi1 = 3.14
pi2 = 3.14
pi3 = 3.1415

pi1.hash # => 335364239
pi2.hash # => 335364239
pi3.hash # => 420540030
```

### def abs        -> Float
### def magnitude  -> Float

自身の絶対値を返します。

```ruby title="例"
p 34.56.abs    # => 34.56
p -34.56.abs   # => 34.56
```

#@since 2.4.0
### def ceil(ndigits = 0) -> Integer | Float
#@else
### def ceil   -> Integer
#@end

自身と等しいかより大きな整数のうち最小のものを返します。

#@since 2.4.0
- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               正の整数を指定した場合、[c:Float] を返します。
               小数点以下を、最大 n 桁にします。
               負の整数を指定した場合、[c:Integer] を返します。
               小数点位置から左に少なくとも n 個の 0 が並びます。
#@end

```ruby title="例"
p 1.2.ceil    # => 2
p 2.0.ceil    # => 2
p (-1.2).ceil # => -1
p (-2.0).ceil # => -2
#@since 2.4.0

p 1.234567.ceil(2) # => 1.24
p 1.234567.ceil(3) # => 1.235
p 1.234567.ceil(4) # => 1.2346
p 1.234567.ceil(5) # => 1.23457

p 34567.89.ceil(-5)  # => 100000
p 34567.89.ceil(-4)  # => 40000
p 34567.89.ceil(-3)  # => 35000
p 34567.89.ceil(-2)  # => 34600
p 34567.89.ceil(-1)  # => 34570
p 34567.89.ceil(0) # => 34568
p 34567.89.ceil(1) # => 34567.9
p 34567.89.ceil(2) # => 34567.89
p 34567.89.ceil(3) # => 34567.89
#@end
```

- **SEE** [m:Float#floor], [m:Float#round], [m:Float#truncate]

### def divmod(other) -> [Numeric]

self を other で割った商 q と余り r を、
[q, r] という 2 要素の配列にして返します。
商 q は常に整数ですが、余り r は整数であるとは限りません。

ここで、商 q と余り r は、

  - self == other * q + r
と
  - other > 0 のとき:  0     <= r < other
  - other < 0 のとき:  other <  r <= 0
  - q は整数
をみたす数です。
このメソッドは、メソッド / と % によって定義されています。

- **param** `other` -- 自身を割る数を指定します。

```ruby title="例"
p 11.divmod(3)       # => [3, 2]
p (11.5).divmod(3.5) # => [3, 1.0]
p 11.divmod(-3)      # => [-4, -1]
p 11.divmod(3.5)     # => [3, 0.5]
p (-11).divmod(3.5)  # => [-4, 3.0]
```

- **SEE** [m:Numeric#div], [m:Numeric#modulo]

#@since 2.4.0
### def floor(ndigits = 0) -> Integer | Float
#@else
### def floor  -> Integer
#@end

自身と等しいかより小さな整数のうち最大のものを返します。

#@since 2.4.0
- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               正の整数を指定した場合、[c:Float] を返します。
               小数点以下を、最大 n 桁にします。
               負の整数を指定した場合、[c:Integer] を返します。
               小数点位置から左に少なくとも n 個の 0 が並びます。
#@end

```ruby title="例"
p 1.2.floor    # => 1
p 2.0.floor    # => 2
p (-1.2).floor # => -2
p (-2.0).floor # => -2
#@since 2.4.0

p 1.234567.floor(2) # => 1.23
p 1.234567.floor(3) # => 1.234
p 1.234567.floor(4) # => 1.2345
p 1.234567.floor(5) # => 1.23456

p 34567.89.floor(-5)  # => 0
p 34567.89.floor(-4)  # => 30000
p 34567.89.floor(-3)  # => 34000
p 34567.89.floor(-2)  # => 34500
p 34567.89.floor(-1)  # => 34560
p 34567.89.floor(0) # => 34567
p 34567.89.floor(1) # => 34567.8
p 34567.89.floor(2) # => 34567.89
p 34567.89.floor(3) # => 34567.89
#@end
```

- **SEE** [m:Numeric#ceil], [m:Numeric#round], [m:Float#truncate]

### def eql?(other)   -> bool

自身と other のクラスが等しくかつ == メソッドで比較して等しい場合に true を返します。
そうでない場合に false を返します。

- **param** `other` -- 自身と比較したい数値を指定します。

```ruby title="例"
p 1.0.eql?(1) # => false
p 1.0.eql?(1.0) # => true
```

### def round(ndigits = 0)  -> Integer | Float
#@since 2.4.0
### def round(ndigits = 0, half: :up)  -> Integer | Float
#@end

自身ともっとも近い整数もしくは実数を返します。

中央値 0.5, -0.5 はそれぞれ 1,-1 に切り上げされます。
いわゆる四捨五入ですが、偶数丸めではありません。

- **param** `ndigits` -- 丸める位を指定します。
       ndigitsが0ならば、小数点以下を四捨五入し、整数を返します。
       ndigitsが0より大きいならば、小数点以下の指定された位で四捨五入されます。
       ndigitsが0より小さいならば、小数点以上の指定された位で四捨五入されます。
#@since 2.4.0
- **param** `half` -- ちょうど半分の値の丸め方を指定します。
       サポートされている値は以下の通りです。

 - :up or nil: 0から遠い方に丸められます。
 - :even: もっとも近い偶数に丸められます。
 - :down: 0に近い方に丸められます。
#@end

- **return** -- 指定された引数に応じて、整数もしくは実数を返します。
       ndigitsが0ならば、整数を返します。
       ndigitsが0より大きいならば、実数を返します。
       ndigitsが0より小さいならば、整数を返します。

- **raise** `TypeError` -- ndigits で指定されたオブジェクトが整数に変換できない場
                 合発生します。

```ruby title="例"
p 1.0.round    # => 1
p 1.2.round    # => 1
p (-1.2).round # => -1
p (-1.5).round # => -2

t = Math::PI # => 3.141592653589793
p t.round(3) # => 3.142
p t.round(0) # => 3
p t.round(1) # => 3.1

t = t**10      # => 93648.04747608298
p t.round(-0)  # => 93648
p t.round(-1)  # => 93650
p t.round(-2)  # => 93600
p t.round(-3)  # => 94000
p t.round(-100)  # => 0
#@since 2.4.0

p 2.5.round(half: :up) # => 3
p 2.5.round(half: :even) # => 2
p 2.5.round(half: :down) # => 2
p 3.5.round(half: :up) # => 4
p 3.5.round(half: :even) # => 4
p 3.5.round(half: :down) # => 3
#@end
```

- **SEE** [m:Float#ceil], [m:Float#floor], [m:Float#truncate]

### def zero?  -> bool

自身がゼロの時、trueを返します。そうでない場合は false を返します。

```ruby title="例"
p 10.0.zero?          # => false
p 0.zero?             # => true
p 0.0.zero?           # => true
```

#@since 2.3.0
### def positive? -> bool

self が 0 より大きい場合に true を返します。そうでない場合に false を返します。

```ruby title="例"
p 0.1.positive? # => true
p 0.0.positive? # => false
p -0.1.positive?  # => false
```

- **SEE** [m:Float#negative?]

### def negative? -> bool

self が 0 未満の場合に true を返します。そうでない場合に false を返します。

```ruby title="例"
p -0.1.negative? # => true
p 0.0.negative?  # => false
p 0.1.negative?  # => false
```

- **SEE** [m:Float#positive?]
#@end

### def to_s -> String
#@since 2.0.0
### def inspect -> String
#@end

自身を人間が読みやすい形の文字列表現にして返します。

固定小数点、浮動小数点の形式か、 "Infinity"、"-Infinity"、"NaN" のいず
れかを返します。

- **return** -- 文字列を返します。

```ruby title="例"
p 0.00001.to_s           # => "1.0e-05"
p 3.14.to_s              # => "3.14"
p 10000_00000_00000.0.to_s # => "100000000000000.0"
p 10000_00000_00000_00000.0.to_s # => "1.0e+19"
p (1.0/0.0).to_s         # => "Infinity"
p (0.0/0.0).to_s         # => "NaN"
```

### def arg   -> 0 | Float
### def angle -> 0 | Float
### def phase -> 0 | Float

自身の偏角(正の数なら 0、負の数なら [m:Math::PI])を返します。

```ruby title="例"
p 1.arg  # => 0
p -1.arg # => 3.141592653589793
```

ただし、自身が NaN(Not a number) であった場合は、NaN を返します。

### def denominator -> Integer

自身を [c:Rational] に変換した時の分母を返します。

- **return** -- 分母を返します。

```ruby title="例"
p 2.0.denominator       # => 1
p 0.5.denominator       # => 2
```

- **SEE** [m:Float#numerator]

### def numerator -> Integer

自身を [c:Rational] に変換した時の分子を返します。

- **return** -- 分子を返します。

```ruby title="例"
p 2.0.numerator         # => 2
p 0.5.numerator         # => 1
```

- **SEE** [m:Float#denominator]

### def to_r -> Rational

自身を [c:Rational] に変換します。

```ruby title="例"
p 0.5.to_r    # => (1/2)
```

### def rationalize      -> Rational
### def rationalize(eps) -> Rational

自身から eps で指定した許容誤差の範囲に収まるような [c:Rational] を返
します。

eps を省略した場合は誤差が最も小さくなるような [c:Rational] を返しま
す。

- **param** `eps` -- 許容する誤差

```ruby title="例"
p 0.3.rationalize        # => (3/10)
p 1.333.rationalize      # => (1333/1000)
p 1.333.rationalize(0.01)  # => (4/3)
```

#@since 2.2.0
### def next_float -> Float

浮動小数点数で表現可能な self の次の値を返します。

[m:Float::MAX].next_float、[m:Float::INFINITY].next_float は
[m:Float::INFINITY] を返します。[m:Float::NAN].next_float は
[m:Float::NAN] を返します。

```ruby title="例"
p 0.01.next_float  # => 0.010000000000000002
p 1.0.next_float   # => 1.0000000000000002
p 100.0.next_float # => 100.00000000000001

p 0.01.next_float - 0.01   # => 1.734723475976807e-18
p 1.0.next_float - 1.0     # => 2.220446049250313e-16
p 100.0.next_float - 100.0 # => 1.4210854715202004e-14

f = 0.01; 20.times { printf "%-20a %s\n", f, f.to_s; f = f.next_float }
# => 0x1.47ae147ae147bp-7 0.01
#    0x1.47ae147ae147cp-7 0.010000000000000002
#    0x1.47ae147ae147dp-7 0.010000000000000004
#    0x1.47ae147ae147ep-7 0.010000000000000005
#    0x1.47ae147ae147fp-7 0.010000000000000007
#    0x1.47ae147ae148p-7  0.010000000000000009
#    0x1.47ae147ae1481p-7 0.01000000000000001
#    0x1.47ae147ae1482p-7 0.010000000000000012
#    0x1.47ae147ae1483p-7 0.010000000000000014
#    0x1.47ae147ae1484p-7 0.010000000000000016
#    0x1.47ae147ae1485p-7 0.010000000000000018
#    0x1.47ae147ae1486p-7 0.01000000000000002
#    0x1.47ae147ae1487p-7 0.010000000000000021
#    0x1.47ae147ae1488p-7 0.010000000000000023
#    0x1.47ae147ae1489p-7 0.010000000000000024
#    0x1.47ae147ae148ap-7 0.010000000000000026
#    0x1.47ae147ae148bp-7 0.010000000000000028
#    0x1.47ae147ae148cp-7 0.01000000000000003
#    0x1.47ae147ae148dp-7 0.010000000000000031
#    0x1.47ae147ae148ep-7 0.010000000000000033
```

- **SEE** [m:Float#prev_float]

### def prev_float -> Float

浮動小数点数で表現可能な self の前の値を返します。

(-[m:Float::MAX]).prev_float と (-[m:Float::INFINITY]).prev_float
は -[m:Float::INFINITY] を返します。[m:Float::NAN].prev_float は
[m:Float::NAN] を返します。

```ruby title="例"
p 0.01.prev_float  # => 0.009999999999999998
p 1.0.prev_float   # => 0.9999999999999999
p 100.0.prev_float # => 99.99999999999999

p 0.01 - 0.01.prev_float   # => 1.734723475976807e-18
p 1.0 - 1.0.prev_float     # => 1.1102230246251565e-16
p 100.0 - 100.0.prev_float # => 1.4210854715202004e-14

f = 0.01; 20.times { printf "%-20a %s\n", f, f.to_s; f = f.prev_float }
# => 0x1.47ae147ae147bp-7 0.01
#    0x1.47ae147ae147ap-7 0.009999999999999998
#    0x1.47ae147ae1479p-7 0.009999999999999997
#    0x1.47ae147ae1478p-7 0.009999999999999995
#    0x1.47ae147ae1477p-7 0.009999999999999993
#    0x1.47ae147ae1476p-7 0.009999999999999992
#    0x1.47ae147ae1475p-7 0.00999999999999999
#    0x1.47ae147ae1474p-7 0.009999999999999988
#    0x1.47ae147ae1473p-7 0.009999999999999986
#    0x1.47ae147ae1472p-7 0.009999999999999985
#    0x1.47ae147ae1471p-7 0.009999999999999983
#    0x1.47ae147ae147p-7  0.009999999999999981
#    0x1.47ae147ae146fp-7 0.00999999999999998
#    0x1.47ae147ae146ep-7 0.009999999999999978
#    0x1.47ae147ae146dp-7 0.009999999999999976
#    0x1.47ae147ae146cp-7 0.009999999999999974
#    0x1.47ae147ae146bp-7 0.009999999999999972
#    0x1.47ae147ae146ap-7 0.00999999999999997
#    0x1.47ae147ae1469p-7 0.009999999999999969
#    0x1.47ae147ae1468p-7 0.009999999999999967
```

- **SEE** [m:Float#next_float]
#@end

## Constants

### const DIG -> Integer

Float が表現できる最大の 10 進桁数です。

通常はデフォルトで 15 です。

### const EPSILON -> Float

1.0 + Float::EPSILON != 1.0 となる最小の正の値です。

通常はデフォルトで 2.2204460492503131e-16 です。

### const MANT_DIG -> Integer

仮数部の Float::RADIX 進法での桁数です。

通常はデフォルトで 53 です。

### const MAX -> Float

Float が取り得る最大の有限の値です。

通常はデフォルトで 1.7976931348623157e+308 です。

- **SEE** [m:Float::MIN]

### const MIN -> Float

Float が取り得る最小の正の値です。

通常はデフォルトで 2.2250738585072014e-308 です。

Float が取り得る最小の有限の値は -[m:Float::MAX] です。

- **SEE** [m:Float::MAX]

### const MAX_10_EXP -> Integer

最大の 10 進の指数です。

通常はデフォルトで 308 です。

- **SEE** [m:Float::MIN_10_EXP]

### const MIN_10_EXP -> Integer

最小の 10 進の指数です。

通常はデフォルトで -307 です。

- **SEE** [m:Float::MAX_10_EXP]

### const MAX_EXP -> Integer

最大の Float::RADIX 進の指数です。

通常はデフォルトで 1024 です。

- **SEE** [m:Float::MIN_EXP]

### const MIN_EXP -> Integer

最小の Float::RADIX 進の指数です。

通常はデフォルトで -1021 です。

- **SEE** [m:Float::MAX_EXP]

### const RADIX -> Integer

指数表現の基数です。

#@until 3.0
### const ROUNDS -> Integer

この定数は Ruby 2.7 から deprecated です。使わないでください。

#@# https://bugs.ruby-lang.org/issues/16044

丸めモード (-1: 不定、0: 0.0 の方向に丸め、1: 四捨五入、2:正の無限
大の方向に丸め、3:負の無限大の方向に丸め)です。
#@end
### const INFINITY -> Float

浮動小数点数における正の無限大です。

負の無限大は -Float::INFINITY です。

- **SEE** [m:Float#finite?], [m:Float#infinite?]

### const NAN -> Float

浮動小数点数における NaN(Not a number)です。

- **SEE** [m:Float#nan?]
