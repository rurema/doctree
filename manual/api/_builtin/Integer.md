---
library: _builtin
alias:
#@until 3.2
  - Fixnum
  - Bignum
#@end
---
# class Integer < Numeric

整数クラスです。

整数オブジェクトに特異メソッドを追加する事はできません。追加した場合、
[c:TypeError] が発生します。

#@since 3.2
かつて Integer クラスのエイリアスであった Fixnum と Bignum は 3.2 で削除されました。
#@else
2.4.0 から [c:Fixnum], [c:Bignum] は Integerに統合されました。
2.4.0 からはどちらも Integer クラスのエイリアスとなっています。
#@end

## Class Methods

#@since 3.1
### def try_convert(obj) -> Integer | nil

obj を Integer に変換しようと試みます。変換には [m:Object#to_int]
メソッドが使われます。

Integer ならそのままobjを返します。
そうでなければ obj.to_int の結果を返すか、nil が返されます。

- **param** `obj` --   変換する任意のオブジェクト
- **return** --      Integer または nil
- **raise** `TypeError` -- to_int が Integer を返さなかった場合に発生します。

```ruby title="例"
p Integer.try_convert(1)  # => 1
p Integer.try_convert(1.25) # => 1
p Integer.try_convert([]) # => nil
```
#@end

### def sqrt(n) -> Integer

非負整数 n の整数の平方根を返します。すなわち n の平方根以下の
最大の非負整数を返します。

- **param** `n` -- 非負整数。Integer ではない場合は、最初に Integer に変換されます。
- **raise** `Math::DomainError` -- n が負の整数の時に発生します。

```ruby
p Integer.sqrt(0)      # => 0
p Integer.sqrt(1)      # => 1
p Integer.sqrt(24)     # => 4
p Integer.sqrt(25)     # => 5
p Integer.sqrt(10**400) == 10**200 # => true
```

Math.sqrt(n).floor と同等ですが、後者は浮動小数点数の精度の限界によって
真の値とは違う結果になることがあります。

```ruby
p Integer.sqrt(10**46)   #=> 100000000000000000000000
p Math.sqrt(10**46).floor  #=>  99999999999999991611392 (!)
```


- **SEE** [m:Math?.sqrt]
## Instance Methods

### def chr -> String
### def chr(encoding) -> String

self を文字コードとして見た時に、引数で与えたエンコーディング encoding に対応する文字を返します。

```ruby
p 65.chr
# => "A"
p 12354.chr
#@since 3.4
# => 'chr': 12354 out of char range (RangeError)
#@else
# => `chr': 12354 out of char range (RangeError)
#@end

p 12354.chr(Encoding::UTF_8)
# => "あ"
p 12354.chr(Encoding::EUC_JP)
# => RangeError: invalid codepoint 0x3042 in EUC-JP
```

引数無しで呼ばれた場合は self を US-ASCII、ASCII-8BIT、デフォルト内部エンコーディングの順で優先的に解釈します。

```ruby
p 0x79.chr.encoding # => #<Encoding:US_ASCII>
p 0x80.chr.encoding # => #<Encoding:ASCII_8BIT>
```

- **param** `encoding` -- エンコーディングを表すオブジェクト。Encoding::UTF_8、'shift_jis' など。
- **return** --     一文字からなる文字列
- **raise** `RangeError` -- self を与えられたエンコーディングで正しく解釈できない場合に発生します。
- **SEE** [m:String#ord] [m:Encoding.default_internal]

### def digits -> [Integer]
### def digits(base) -> [Integer]

base を基数として self を位取り記数法で表記した数値を配列で返します。
base を指定しない場合の基数は 10 です。

```ruby
p 16.digits   # => [6, 1]
p 16.digits(16) # => [0, 1]
```

self は非負整数でなければいけません。非負整数でない場合は、Math::DomainErrorが発生します。

```ruby
-10.digits  # Math::DomainError: out of domain が発生
```

- **return** --     位取り記数法で表した時の数値の配列
- **param** `base` -- 基数となる数値。
- **raise** `ArgumentError` -- base に正の整数以外を指定した場合に発生します。
- **raise** `Math::DomainError` -- 非負整数以外に対して呼び出した場合に発生します。

### def downto(min) {|n| ... } -> self
### def downto(min) -> Enumerator

self から min まで 1 ずつ減らしながらブロックを繰り返し実行します。
self < min であれば何もしません。

- **param** `min` --   数値
- **return** --      self を返します。

```ruby
p 5.downto(1) {|i| print i, " " } # => 5 4 3 2 1
```

- **SEE** [m:Integer#upto], [m:Numeric#step], [m:Integer#times]

### def next -> Integer
### def succ -> Integer

self の次の整数を返します。

```ruby
p 1.next    #=> 2
p (-1).next #=> 0
p 1.succ    #=> 2
p (-1).succ #=> 0
```

- **SEE** [m:Integer#pred]

### def times {|n| ... } -> self
### def times -> Enumerator

self 回だけ繰り返します。
self が正の整数でない場合は何もしません。

またブロックパラメータには 0 から self - 1 までの数値が渡されます。

```ruby
3.times { puts "Hello, World!" }  # Hello, World! と3行続いて表示される。
0.times { puts "Hello, World!" }  # 何も表示されない。
5.times {|n| print n }            # 01234 と表示される。
```

- **SEE** [m:Integer#upto], [m:Integer#downto], [m:Numeric#step]

### def to_i   -> self
### def to_int -> self

self を返します。

```ruby
p 10.to_i # => 10
```

### def floor(ndigits = 0) -> Integer

self と等しいかより小さな整数のうち最大のものを返します。

- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               負の整数を指定した場合、小数点位置から左に少なくとも n 個の 0 が並びます。

```ruby
p 1.floor         # => 1
p 1.floor(2)      # => 1
p 18.floor(-1)    # => 10
p (-18).floor(-1) # => -20
```

- **SEE** [m:Numeric#floor]

### def ceil(ndigits = 0) -> Integer

self と等しいかより大きな整数のうち最小のものを返します。

- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               負の整数を指定した場合、小数点位置から左に少なくとも n 個の 0 が並びます。

```ruby
p 1.ceil         # => 1
p 1.ceil(2)      # => 1
p 18.ceil(-1)    # => 20
p (-18).ceil(-1) # => -10
```

- **SEE** [m:Numeric#ceil]

### def round(ndigits = 0, half: :up) -> Integer

self ともっとも近い整数を返します。

- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               負の整数を指定した場合、小数点位置から左に少なくとも n 個の 0 が並びます。
- **param** `half` -- ちょうど半分の値の丸め方を指定します。
       サポートされている値は以下の通りです。

 - :up or nil: 0から遠い方に丸められます。
 - :even: もっとも近い偶数に丸められます。
 - :down: 0に近い方に丸められます。

```ruby
p 1.round       # => 1
p 1.round(2)    # => 1
p 15.round(-1)  # =>  20
p (-15).round(-1) # => -20

p 25.round(-1, half: :up)    # => 30
p 25.round(-1, half: :down)  # => 20
p 25.round(-1, half: :even)  # => 20
p 35.round(-1, half: :up)    # => 40
p 35.round(-1, half: :down)  # => 30
p 35.round(-1, half: :even)  # => 40
p (-25).round(-1, half: :up) # => -30
p (-25).round(-1, half: :down) # => -20
p (-25).round(-1, half: :even) # => -20
```

- **SEE** [m:Numeric#round]

### def truncate(ndigits = 0) -> Integer

0 から self までの整数で、自身にもっとも近い整数を返します。

- **param** `ndigits` -- 10進数での小数点以下の有効桁数を整数で指定します。
               負の整数を指定した場合、小数点位置から左に少なくとも n 個の 0 が並びます。

```ruby
p 1.truncate         # => 1
p 1.truncate(2)      # => 1
p 18.truncate(-1)    # =>  10
p (-18).truncate(-1) # => -10
```

- **SEE** [m:Numeric#truncate]

### def to_s(base=10)    -> String
### def inspect(base=10) -> String

整数を 10 進文字列表現に変換します。

引数を指定すれば、それを基数とした文字列表
現に変換します。

```ruby
p 10.to_s(2)    # => "1010"
p 10.to_s(8)    # => "12"
p 10.to_s(16)   # => "a"
p 35.to_s(36)   # => "z"
```

- **return** --     数値の文字列表現
- **param** `base` -- 基数となる 2 - 36 の数値。
- **raise** `ArgumentError` -- base に 2 - 36 以外の数値を指定した場合に発生します。

### def upto(max) {|n| ... } -> Integer
### def upto(max) -> Enumerator

self から max まで 1 ずつ増やしながら繰り返します。
self > max であれば何もしません。

- **param** `max` --   数値
- **return** --      self を返します。

```ruby
p 5.upto(10) {|i| print i, " " } # => 5 6 7 8 9 10
```

- **SEE** [m:Integer#downto], [m:Numeric#step], [m:Integer#times]

### def integer? -> true

常に真を返します。

```ruby
p 1.integer?   # => true
p 1.0.integer? # => false
```

### def even? -> bool

自身が偶数であれば真を返します。
そうでない場合は偽を返します。

```ruby
p 10.even?  # => true
p 5.even?   # => false
```

### def odd? -> bool

自身が奇数であれば真を返します。
そうでない場合は偽を返します。

```ruby
p 5.odd?   # => true
p 10.odd?  # => false
```

### def ord    -> Integer
自身を返します。

```ruby
p 10.ord  #=> 10
# String#ord
p ?a.ord  #=> 97
```

- **SEE** [m:String#ord]

### def pred    -> Integer

self から -1 した値を返します。

```ruby
p 1.pred    #=> 0
p (-1).pred #=> -2
```

- **SEE** [m:Integer#next]

### def denominator -> Integer

分母(常に1)を返します。

- **return** -- 分母を返します。

```ruby
p 10.denominator  # => 1
p -10.denominator # => 1
```

- **SEE** [m:Integer#numerator]

### def gcd(n) -> Integer

自身と整数 n の最大公約数を返します。

- **raise** `ArgumentError` -- n に整数以外のものを指定すると発生します。

```ruby
p 2.gcd(2)                  # => 2
p 3.gcd(7)                  # => 1
p 3.gcd(-7)                 # => 1
p ((1<<31)-1).gcd((1<<61)-1)  # => 1
```

また、self や n が 0 だった場合は、0 ではない方の整数の絶対値を返します。

```ruby
p 3.gcd(0)                  # => 3
p 0.gcd(-7)                 # => 7
```

- **SEE** [m:Integer#lcm], [m:Integer#gcdlcm]

### def gcdlcm(n) -> [Integer]

自身と整数 n の最大公約数と最小公倍数の配列 [self.gcd(n), self.lcm(n)]
を返します。

- **raise** `ArgumentError` -- n に整数以外のものを指定すると発生します。

```ruby
p 2.gcdlcm(2)                  # => [2, 2]
p 3.gcdlcm(-7)                 # => [1, 21]
p ((1<<31)-1).gcdlcm((1<<61)-1)  # => [1, 4951760154835678088235319297]
```

- **SEE** [m:Integer#gcd], [m:Integer#lcm]

### def lcm(n) -> Integer

自身と整数 n の最小公倍数を返します。

- **raise** `ArgumentError` -- n に整数以外のものを指定すると発生します。

```ruby
p 2.lcm(2)                  # => 2
p 3.lcm(-7)                 # => 21
p ((1<<31)-1).lcm((1<<61)-1)  # => 4951760154835678088235319297
```

また、self や n が 0 だった場合は、0 を返します。

```ruby
p 3.lcm(0)                  # => 0
p 0.lcm(-7)                 # => 0
```

- **SEE** [m:Integer#gcd], [m:Integer#gcdlcm]

### def numerator -> Integer

分子(常に自身)を返します。

- **return** -- 分子を返します。

```ruby
p 10.numerator  # => 10
p -10.numerator # => -10
```

- **SEE** [m:Integer#denominator]

### def to_r -> Rational

自身を [c:Rational] に変換します。

```ruby
p 1.to_r      # => (1/1)
p (1<<64).to_r  # => (18446744073709551616/1)
```


### def rationalize      -> Rational
### def rationalize(eps) -> Rational

自身を [c:Rational] に変換します。

- **param** `eps` -- 許容する誤差

引数 eps は常に無視されます。

```ruby
p 2.rationalize    # => (2/1)
p 2.rationalize(100) # => (2/1)
p 2.rationalize(0.1) # => (2/1)
```

### def to_f -> Float

self を浮動小数点数([c:Float])に変換します。

self が [c:Float] の範囲に収まらない場合、[m:Float::INFINITY] を返します。

```ruby
p 1.to_f                     # => 1.0
p (Float::MAX.to_i * 2).to_f # => Infinity
p (-Float::MAX.to_i * 2).to_f  # => -Infinity
```

### def <=>(other) -> -1 | 0 | 1 | nil

self と other を比較して、self が大きい時に1、等しい時に 0、小さい時
に-1、比較できない時に nil を返します。

- **param** `other` -- 比較対象の数値
- **return** --      -1 か 0 か 1 か nil のいずれか

```ruby
p 1 <=> 2  # => -1
p 1 <=> 1  # => 0
p 2 <=> 1  # => 1
p 2 <=> '' # => nil
```

### def -@ -> Integer

単項演算子の - です。
self の符号を反転させたものを返します。

```ruby
p(- 10) # => -10
p(- -10) # => 10
```

### def +(other) -> Numeric

算術演算子。和を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)
- **return** -- 計算結果

```ruby
p 3 + 4 # => 7
```

### def -(other) -> Numeric

算術演算子。差を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)
- **return** -- 計算結果

```ruby
p 4 - 1 #=> 3
```

### def *(other) -> Numeric

算術演算子。積を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)
- **return** -- 計算結果

```ruby
p 2 * 3 # => 6
```

### def /(other) -> Numeric

除算の算術演算子。

other が Integer の場合、整商（整数の商）を Integer で返します。
普通の商（剰余を考えない商）を越えない最大の整数をもって整商とします。

other が Float、Rational、Complex の場合、普通の商を other と
同じクラスのインスタンスで返します。

- **param** `other` -- 二項演算の右側の引数(対象)
- **return** -- 計算結果

```ruby title="例"
p 7 / 2 # => 3
p 7 / -2 # => -4
p 7 / 2.0 # => 3.5
p 7 / Rational(2, 1) # => (7/2)
p 7 / Complex(2, 0) # => ((7/2)+0i)

begin
  2 / 0
rescue => e
  e # => #<ZeroDivisionError: divided by 0>
end
```

- **SEE** [m:Integer#div], [m:Integer#fdiv], [m:Numeric#quo]

### def div(other) -> Integer

整商（整数の商）を返します。
普通の商（剰余を考えない商）を越えない最大の整数をもって整商とします。

other が Integer オブジェクトの場合、[m:Integer#/] の結果と一致します。

div に対応する剰余メソッドは modulo です。

- **param** `other` -- 二項演算の右側の引数(対象)
- **return** -- 計算結果

```ruby title="例"
p 7.div(2) # => 3
p 7.div(-2) # => -4
p 7.div(2.0) # => 3
p 7.div(Rational(2, 1)) # => 3

begin
  2.div(0)
rescue => e
  e # => #<ZeroDivisionError: divided by 0>
end

begin
  2.div(0.0)
rescue => e
  e # => #<ZeroDivisionError: divided by 0>
  # Integer#/ と違い、引数が Float でもゼロで割ることはできない
end
```

- **SEE** [m:Integer#fdiv], [m:Integer#/], [m:Integer#modulo]

### def %(other) -> Numeric
### def modulo(other) -> Numeric

算術演算子。剰余を計算します。

```ruby
p 13 % 4  # =>  1
p 13 % -4 # => -3
p -13 % 4 # =>  3
p -13 % -4  # => -1
```

- **param** `other` -- 二項演算の右側の引数(対象)
- **return** -- 計算結果

### def remainder(other) -> Numeric

self を other で割った余り r を返します。

r の符号は self と同じになります。

- **param** `other` -- self を割る数。

```ruby
p 5.remainder(3)  # =>  2
p -5.remainder(3) # => -2
p 5.remainder(-3) # =>  2
p -5.remainder(-3)  # => -2

p -1234567890987654321.remainder(13731)    # => -6966
p -1234567890987654321.remainder(13731.24) # => -9906.22531493148
```

- **SEE** [m:Integer#divmod], [m:Integer#modulo], [m:Numeric#modulo]

### def divmod(other) -> [Integer, Numeric]

self を other で割った商 q と余り r を、 [q, r] という 2 要素の配列にし
て返します。 商 q は常に整数ですが、余り r は整数であるとは限りません。

- **param** `other` -- self を割る数。

- **SEE** [m:Numeric#divmod]

### def fdiv(other) -> Numeric

self を other で割った商を [c:Float] で返します。
ただし [c:Complex] が関わる場合は例外です。
その場合も成分は Float になります。

- **param** `other` -- self を割る数を指定します。

```ruby title="例"
654321.fdiv(13731)      # => 47.652829364212366
654321.fdiv(13731.24)   # => 47.65199646936475

-1234567890987654321.fdiv(13731)      # => -89910996357705.52
-1234567890987654321.fdiv(13731.24)   # => -89909424858035.72
```
- **SEE** [m:Numeric#quo], [m:Numeric#div], [m:Integer#div]

#@since 3.2
### def ceildiv(other) -> Integer

self を other で割り、その(剰余を考えない)商を整数に切り上げたものを返します。
すなわち、self を other で割った商を q とすると、q 以上で最小の整数を返します。

- **param** `other` -- self を割る数を指定します。

```ruby
p 3.ceildiv(3)  # => 1
p 4.ceildiv(3)  # => 2
p 5.ceildiv(3)  # => 2
p 3.ceildiv(1.2)  # => 3
p -5.ceildiv(3) # => -1
p -5.ceildiv(-3)  # => 2
```

#@end

### def **(other) -> Numeric
### def pow(other) -> Numeric
### def pow(other, modulo) -> Integer

算術演算子。冪(べき乗)を計算します。

- **param** `other` -- 二項演算の右側の引数(対象)
- **param** `modulo` -- 指定すると、計算途中に巨大な値を生成せずに (self**other) % modulo と同じ結果を返します。
- **return** -- 計算結果
- **raise** `TypeError` -- 2引数 pow で Integer 以外を指定した場合に発生します。
- **raise** `RangeError` -- 2引数 pow で other に負の数を指定した場合に発生します。
#@since 3.4
- **raise** `ArgumentError` -- 計算結果が巨大になりすぎる場合に発生します。
#@end

```ruby
p 2 ** 3 # => 8
p 2 ** 0 # => 1
p 0 ** 0 # => 1
p 3.pow(3,  8)  # =>  3
p 3.pow(3, -8)  # => -5
p 3.pow(2, -2)  # => -1
p -3.pow(3,  8) # =>  5
p -3.pow(3, -8) # => -3
p 5.pow(2, -8)  # => -7
```

#@until 3.4
結果が巨大すぎる整数になりそうなとき、警告を出したうえで Float::INFINITY を返します。

```ruby title="計算を放棄して Float::INFINITY を返す例"
p 100**9999999
# => warning: in a**b, b may be too big
#    Infinity
```

判定の閾値は変わりえます。
#@end

#@since 3.4
計算結果が巨大すぎるときは ArgumentError が発生します。

```ruby title="計算結果が巨大すぎる例"
p 100**9999999999999999999
# => exponent is too large (ArgumentError)
```

判定の閾値は変わりえます。
#@end

- **SEE** [m:BigDecimal#power]

### def abs -> Integer
### def magnitude -> Integer

self の絶対値を返します。

```ruby
p -12345.abs # => 12345
p 12345.abs  # => 12345
p -1234567890987654321.abs # => 1234567890987654321
```

### def ==(other) -> bool
### def ===(other) -> bool

比較演算子。数値として等しいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self と other が等しい場合 true を返します。
             そうでなければ false を返します。

```ruby
p 1 == 2    # => false
p 1 == 1.0  # => true
```

### def <(other)  -> bool

比較演算子。数値として小さいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other が大きい場合 true を返します。
             そうでなければ false を返します。

```ruby
p 1 < 1  # => false
p 1 < 2  # => true
```

### def <=(other) -> bool

比較演算子。数値として等しいまたは小さいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other の方が大きい場合か、
             両者が等しい場合 true を返します。
             そうでなければ false を返します。

```ruby
p 1 <= 0  # => false
p 1 <= 1  # => true
p 1 <= 2  # => true
```

### def >(other)  -> bool

比較演算子。数値として大きいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other の方が小さい場合 true を返します。
             そうでなければ false を返します。

```ruby
p 1 > 0  # => true
p 1 > 1  # => false
```

### def >=(other) -> bool

比較演算子。数値として等しいまたは大きいか判定します。

- **param** `other` -- 比較対象の数値
- **return** --      self よりも other の方が小さい場合か、
             両者が等しい場合 true を返します。
             そうでなければ false を返します。

```ruby
p 1 >= 0  # => true
p 1 >= 1  # => true
p 1 >= 2  # => false
```

### def ~        -> Integer
ビット演算子。否定を計算します。

```ruby
p ~1  # => -2
p ~3  # => -4
p ~-4 # => 3
```

### def |(other) -> Integer
ビット二項演算子。論理和を計算します。

- **param** `other` -- 数値

```ruby
p 1 | 1  # => 1
p 2 | 3  # => 3
```

### def &(other) -> Integer
ビット二項演算子。論理積を計算します。

- **param** `other` -- 数値

```ruby
p 1 & 1  # => 1
p 2 & 3  # => 2
```

### def ^(other) -> Integer
ビット二項演算子。排他的論理和を計算します。

- **param** `other` -- 数値

```ruby
p 1 ^ 1  # => 0
p 2 ^ 3  # => 1
```

### def [](nth) -> Integer
### def [](nth, len) -> Integer
### def [](range) -> Integer

nth 番目のビット(最下位ビット(LSB)が 0 番目)が立っている時 1
を、そうでなければ 0 を返します。

- **param** `nth` --   何ビット目を指すかの数値
- **param** `len` --   何ビット分を返すか
- **param** `range` -- 返すビットの範囲
- **return** --     self[nth] は 1 か 0
- **return** --     self[i, len] は (n >> i) & ((1 << len) - 1) と同じ
- **return** --     self[i..j] は (n >> i) & ((1 << (j - i + 1)) - 1) と同じ
- **return** --     self[i...j] は (n >> i) & ((1 << (j - i)) - 1) と同じ
- **return** --     self[i..] は (n >> i) と同じ
- **return** --     self[..j] は n & ((1 << (j + 1)) - 1) が 0 なら 0
- **return** --     self[...j] は n & ((1 << j) - 1) が 0 なら 0
- **raise** `ArgumentError` -- self[..j] で n & ((1 << (j + 1)) - 1) が 0 以外のとき
- **raise** `ArgumentError` -- self[...j] で n & ((1 << j) - 1) が 0 以外のとき

```ruby
a = 0b11001100101010
30.downto(0) {|n| print a[n] }
# => 0000000000000000011001100101010

a = 9**15
50.downto(0) {|n| print a[n] }
# => 000101110110100000111000011110010100111100010111001
```

n[i] は (n >> i) & 1 と等価なので、負のインデックスは常に 0 を返します。

```ruby
p 255[-1] # => 0
```

```ruby title="複数ビットの例"
p 0b01001101[2, 4]  #=> 0b0011
p 0b01001100[2..5]  #=> 0b0011
p 0b01001100[2...6] #=> 0b0011
#   ^^^^
```

self[nth]=bit (つまりビットの修正) がないのは、Numeric 関連クラスが
immutable であるためです。

### def <<(bits) -> Integer

シフト演算子。bits だけビットを左にシフトします。

- **param** `bits` -- シフトさせるビット数

```ruby
printf("%#b\n", 0b0101 << 1) # => 0b1010
p -1 << 1 # => -2
```

### def >>(bits) -> Integer
シフト演算子。bits だけビットを右にシフトします。

右シフトは、符号ビット(最上位ビット(MSB))が保持されます。
bitsが実数の場合、小数点以下を切り捨てた値でシフトします。

- **param** `bits` -- シフトさせるビット数

```ruby
printf("%#b\n", 0b0101 >> 1) # => 0b10
p -1 >> 1                    # => -1
```

### def size -> Integer

整数の実装上のサイズをバイト数で返します。

```ruby
p 1.size              # => 8
p 0x1_0000_0000.size  # => 8
```

- **SEE** [m:Integer#bit_length]
### def bit_length -> Integer

self を表すのに必要なビット数を返します。

「必要なビット数」とは符号ビットを除く最上位ビットの位置の事を意味しま
す。2**n の場合は n+1 になります。self にそのようなビットがない(0 や
-1 である)場合は 0 を返します。

```ruby title="例: ceil(log2(int < 0 ? -int : int+1)) と同じ結果"
p (-2**12-1).bit_length   # => 13
p (-2**12).bit_length     # => 12
p (-2**12+1).bit_length   # => 12
p -0x101.bit_length       # => 9
p -0x100.bit_length       # => 8
p -0xff.bit_length        # => 8
p -2.bit_length           # => 1
p -1.bit_length           # => 0
p 0.bit_length            # => 0
p 1.bit_length            # => 1
p 0xff.bit_length         # => 8
p 0x100.bit_length        # => 9
p (2**12-1).bit_length    # => 12
p (2**12).bit_length      # => 13
p (2**12+1).bit_length    # => 13
```

- **SEE** [m:Integer#size]
### def allbits?(mask) -> bool
mask で 1 が立っているビットがすべて self でも 1 なら true を返します。

self & mask == mask と等価です。

- **param** `mask` -- ビットマスクを整数で指定します。

```ruby
p 42.allbits?(42)                 # => true
p 0b1010_1010.allbits?(0b1000_0010) # => true
p 0b1010_1010.allbits?(0b1000_0001) # => false
p 0b1000_0010.allbits?(0b1010_1010) # => false
```

- **SEE** [m:Integer#anybits?]
- **SEE** [m:Integer#nobits?]
### def anybits?(mask) -> bool
self & mask のいずれかのビットが 1 なら true を返します。

self & mask != 0 と等価です。

- **param** `mask` -- ビットマスクを整数で指定します。

```ruby
p 42.anybits?(42)                 # => true
p 0b1010_1010.anybits?(0b1000_0010) # => true
p 0b1010_1010.anybits?(0b1000_0001) # => true
p 0b1000_0010.anybits?(0b0010_1100) # => false
```

- **SEE** [m:Integer#allbits?]
- **SEE** [m:Integer#nobits?]
### def nobits?(mask) -> bool
self & mask のすべてのビットが 0 なら true を返します。

self & mask == 0 と等価です。

- **param** `mask` -- ビットマスクを整数で指定します。

```ruby
p 42.nobits?(42)                 # => false
p 0b1010_1010.nobits?(0b1000_0010) # => false
p 0b1010_1010.nobits?(0b1000_0001) # => false
p 0b0100_0101.nobits?(0b1010_1010) # => true
```

- **SEE** [m:Integer#allbits?]
- **SEE** [m:Integer#anybits?]
