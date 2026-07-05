---
library: openssl
include:
  - Comparable
---
# class OpenSSL::BN < Object

OpenSSL内で利用される多倍長整数クラスです。

通常多倍長整数を利用するには [c:Integer] を用いてください。

## Class Methods

### def new(str, base=10) -> OpenSSL::BN

文字列を多倍長整数オブジェクト([c:OpenSSL::BN])を生成します。

base で、変換方法(基数)を指定します。
デフォルトは 10 で、他に 16, 2, 0 を指定できます。

`````
10  引数の文字列を 10進数とみなして、変換します。
16  引数の文字列を 16進数とみなして、変換します。
 2  引数の文字列を big-endian の符号無し整数のバイナリ列とみなして、変換します。
 0  引数の文字列を MPI形式の文字列(バイト列)とみなして、変換します。
    (最初の4byteはbig-endianでデータ長を表わし、その後にそのデータ長のバイト
     列(big-endian)で数値を表す。最上位ビットが立っていると負数)。
`````

```ruby
require 'openssl'

OpenSSL::BN.new("-241") # => -241
OpenSSL::BN.new("ff00",16) # => 65280
OpenSSL::BN.new("\x81",2) # => 129
OpenSSL::BN.new("\xff\x81",2) # => 65409
OpenSSL::BN.new("\x00\x00\x00\x02\x00\x81", 0) # => 129
OpenSSL::BN.new("\x00\x00\x00\x02\x80\x81", 0) # => -129
OpenSSL::BN.new(1209) # => 1209
```

- **param** `str` -- 整数を表す文字列
- **param** `base` -- 文字列から整数に変換するときの基数
- **raise** `OpenSSL::BNError` -- 変換に失敗した場合に発生します

反対に、[c:OpenSSL::BN] クラスのオブジェクトを文字列にするには、
[m:OpenSSL::BN#to_s] を用います。

- **SEE** [m:OpenSSL::BN#to_s]

### def new(bn) -> OpenSSL::BN

[c:OpenSSL::BN] を複製して返します。

- **param** `bn` -- 複製する [c:OpenSSL::BN] オブジェクト

### def new(integer) -> OpenSSL::BN

整数オブジェクト([c:Integer])から多倍長整数オブジェクト
([c:OpenSSL::BN])を生成します。

- **param** `integer` -- 整数オブジェクト
- **SEE** [m:Integer#to_bn]

### def generate_prime(bits, safe=true, add=nil, rem=nil) -> OpenSSL::BN
ランダム(擬似乱数的)な bits ビットの素数を返します。

暗号的に意味のある素数は十分大きくないといけないので、
bits が小さすぎる場合は期待する結果を返しません。

safe が真であれば、「安全な」素数((p-1)/2が素数である素数p)を
返します。

add に整数を渡すと、 p % add == rem であるような
素数pのみを返します。rem が nil の場合は rem=1と見なします。

- **param** `bits` -- 生成するランダム素数のビット数
- **param** `safe` -- true で安全な素数のみを生成する
- **param** `add` -- 生成する素数の剰余の条件
- **param** `rem` -- 生成する素数の剰余の条件
- **raise** `OpenSSL::BNError` -- 素数の生成に失敗した場合に発生します

### def pseudo_rand(bits, fill=0, odd=false) -> OpenSSL::BN
乱数を生成し、返します。

乱数系列に暗号論的な強さはないため、暗号関連でない場合や、
強さが必要でない場合に用いることができます。
鍵生成のような場合には使えません。

bits ビットの長さの正の整数を生成します。

fill が -1 なら、生成させる数の最上位ビットが
0である場合を許容します。fill が 0 なら、
生成させる数の最上位ビットは1にセットされます、
つまり必ず bits ビットの整数となります。
fill が1の場合は、上位2ビットが1にセットされます。

odd が真なら、生成される整数は奇数のみとなります。

- **param** `bits` -- 発生させる数のビット数
- **param** `fill` -- 上位ビットの性質を決める整数
- **param** `odd` -- 真なら発生させる数は奇数のみとなる
- **raise** `OpenSSL::BNError` -- 乱数の生成に失敗した場合に発生します
- **SEE** [m:OpenSSL::BN.rand], [m:OpenSSL::BN.pseudo_rand_range]

### def pseudo_rand_range(range) -> OpenSSL::BN
乱数を 0 から range-1 までの間で生成し、返します。

乱数系列に暗号論的な強さはありません。

- **param** `range` -- 生成する乱数の範囲
- **raise** `OpenSSL::BNError` -- 乱数の生成に失敗した場合に発生します
- **SEE** [m:OpenSSL::BN.pseudo_rand], [m:OpenSSL::BN.rand_range]


### def rand(bits, fill=0, odd=false) -> OpenSSL::BN
暗号論的に強い擬似乱数を生成し、返します。

bits ビットの長さの正の整数を生成します。

fill が -1 なら、生成させる数の最上位ビットが
0である場合を許容します。fill が 0 なら、
生成させる数の最上位ビットは1にセットされます、
つまり必ず bits ビットの整数となります。
fill が1の場合は、上位2ビットが1にセットされます。

odd が真なら、生成される整数は奇数のみとなります。

- **param** `bits` -- 発生させる数のビット数
- **param** `fill` -- 上位ビットの性質を決める整数
- **param** `odd` -- 真なら発生させる数は奇数のみとなる
- **raise** `OpenSSL::BNError` -- 乱数の生成に失敗した場合に発生します
- **SEE** [m:OpenSSL::BN.pseudo_rand], [m:OpenSSL::BN.rand_range]

### def rand_range(range) -> OpenSSL::BN
暗号論的に強い擬似乱数を 0 から range-1 までの間で生成し、返します。

- **param** `range` -- 生成する乱数の範囲
- **raise** `OpenSSL::BNError` -- 乱数の生成に失敗した場合に発生します
- **SEE** [m:OpenSSL::BN.rand], [m:OpenSSL::BN.pseudo_rand_range]

## Instance Methods

### def %(other) -> OpenSSL::BN
自身を other で割り算した余りを返します。

- **param** `other` -- 除数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def *(other) -> OpenSSL::BN
自身と other の積を返します。

- **param** `other` -- かける数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#mod_mul]

### def **(other) -> OpenSSL::BN
自身の other 乗を返します。

- **param** `other` -- 指数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#mod_exp]

### def +(other) -> OpenSSL::BN
自身と other の和を返します。

- **param** `other` -- 足す整数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#mod_add]

### def -(other) -> OpenSSL::BN
自身から other を引いた値を返します。

- **param** `other` -- 引く整数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#mod_sub]

### def /(other) -> [OpenSSL::BN, OpenSSL::BN]
自身を other で割った商と余りを配列で返します。

- **param** `other` -- 除数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#mod_inverse]

### def <<(other) -> OpenSSL::BN
自身を other ビット左シフトした値を返します。

```ruby
bn = 1.to_bn
pp bn << 1    # => #<OpenSSL::BN 2>
pp bn         # => #<OpenSSL::BN 1>
```

- **param** `other` -- シフトするビット数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#lshift!]

### def <=>(other) -> -1 | 0 | 1
### def cmp(other) -> -1 | 0 | 1
自身と other を比較し、自身が小さいときには -1、
等しいときには 0、大きいときには 1 を返します。

```ruby
require 'openssl'

OpenSSL::BN.new(5) <=> 5  # =>  0

OpenSSL::BN.new(5) <=> OpenSSL::BN.new(9)  # => -1
OpenSSL::BN.new(5) <=> OpenSSL::BN.new(5)  # =>  0
OpenSSL::BN.new(5) <=> OpenSSL::BN.new(-5)  # =>  1
```

- **param** `other` -- 比較する整数
- **raise** `TypeError` -- 比較できないときに発生します。
- **SEE** [m:OpenSSL::BN#ucmp]

### def ==(other) -> bool
### def ===(other) -> bool
### def eql?(other) -> bool
自身と other が等しい場合に true を返します。

- **param** `other` -- 比較する数

### def >>(other) -> OpenSSL::BN
自身を other ビット右シフトした値を返します。

```ruby
require 'openssl'

bn = 2.to_bn
bn >> 1    # => #<OpenSSL::BN 1>
bn         # => #<OpenSSL::BN 2>
```

- **param** `other` -- シフトするビット数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#rshift!]

### def lshift!(n) -> self
自身を n ビット左シフトします。
[m:OpenSSL::BN#<<]と異なり、破壊的メソッドです。

```ruby
require 'openssl'

bn = 1.to_bn
bn.lshift!(2)   # => #<OpenSSL::BN 4>
bn              # => #<OpenSSL::BN 4>
```

- **param** `n` -- シフトするビット数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#<<]

### def rshift!(n) -> self
自身を n ビット右シフトします。
[[m:OpenSSL::BN#>>]と異なり、破壊的メソッドです。

```ruby
require 'openssl'

bn = 8.to_bn
bn.rshift!(1)    # => #<OpenSSL::BN 4>
bn               # => #<OpenSSL::BN 4>
```

- **param** `n` -- シフトするビット数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#>>]

### def bit_set?(n) -> bool
自身の n ビット目が立っているなら true を返します。

```ruby
require 'openssl'

OpenSSL::BN.new("129").bit_set?(0) # => true
OpenSSL::BN.new("129").bit_set?(1) # => false
```

- **param** `n` -- 調べるビットの位置
- **SEE** [m:OpenSSL::set_bit!]

### def clear_bit!(n) -> self
自身の n ビット目を0にします。

```ruby
require 'openssl'

a = OpenSSL::BN.new("129")
a.clear_bit!(0)
a # => 128
```

- **param** `n` -- 0にするビットの位置
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::set_bit!]

### def coerce(other) -> Array
自身と other が同じクラスになるよう、自身か other を変換し
[other, self] という配列にして返します。

基本的に other が整数のときに、自身を Integer のオブジェクトに
変換して [other, 変換後オブジェクト] にして返します。
それ以外の場合は例外 TypeError を発生させます。

```ruby
require 'openssl'
p 1.to_bn.coerce(2)  # => [2, 1]
```

- **param** `other` -- 変換の基準となるオブジェクト
- **raise** `TypeError` -- 変換に失敗した場合に発生します

coerce メソッドの詳細な説明は、[m:Numeric#coerce] にあります。
- **SEE** [m:Numeric#coerce]


### def copy(other) -> self
other の内容を自身にコピーします。

- **param** `other` -- コピーする [c:OpenSSL::BN] のオブジェクト
- **raise** `OpenSSL::BNError` -- コピーに失敗

### def gcd(other) -> OpenSSL::BN
GCD(最大公約数)を返します。

- **param** `other` -- 自身との GCD を計算する数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def mask_bits!(n) -> self
自身を下位 n ビットでマスクし、破壊的に変更します。

n が自身のビット数より大きい場合は例外 [c:OpenSSL::BNError]
が発生します。

```ruby
require 'openssl'

bn = 0b1111_1111.to_bn

bn.mask_bits!(8)
p "%b" % bn      # => "11111111"

bn.mask_bits!(3)
p "%b" % bn      # =>     "111"
```

- **param** `n` -- マスクするビット数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def mod_add(other, m) -> OpenSSL::BN
(self + other) % m を返します。

```ruby
require 'openssl'

OpenSSL::BN.new("7").mod_add(OpenSSL::BN.new("3"), OpenSSL::BN.new("6")) # => 4
```

- **param** `other` -- 和を取る数
- **param** `m` -- 剰余を取る数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def mod_exp(other, m) -> OpenSSL::BN
(self ** other) % m を返します。

```ruby
require 'openssl'

OpenSSL::BN.new("7").mod_exp(OpenSSL::BN.new("3"), OpenSSL::BN.new("6")) # => 1
```

- **param** `other` -- 指数
- **param** `m` -- 剰余を取る数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def mod_inverse(m) -> OpenSSL::BN
自身の mod m における逆元を返します。

(self * r) % m == 1 となる r を返します。
存在しない場合は例外 [c:OpenSSL::BNError] が発生します。

```ruby
require 'openssl'

p 3.to_bn.mod_inverse(5) # => 2
p (3 * 2) % 5            # => 1
```

- **param** `m` -- mod を取る数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def mod_mul(other, m) -> OpenSSL::BN
(self * other) % m を返します。

```ruby
require 'openssl'

OpenSSL::BN.new("7").mod_mul(OpenSSL::BN.new("3"), OpenSSL::BN.new("6")) # => 3
```

- **param** `other` -- 積を取る数
- **param** `m` -- 剰余を取る数
- **raise** `OpenSSL::BNError` -- 計算時エラー

### def mod_sqr(m) -> OpenSSL::BN
(self ** 2) % m を返します。

- **param** `m` -- mod を取る数
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#sqr]

### def mod_sub(other, m) -> OpenSSL::BN
(self - other) % m を返します。

```ruby
require 'openssl'

OpenSSL::BN.new("27").mod_sub(OpenSSL::BN.new("3"), OpenSSL::BN.new("5")) # => 4
```

- **param** `other` -- 引く数
- **param** `m` -- 剰余を取る数
- **raise** `OpenSSL::BNError` -- 計算時エラー


### def num_bits -> Integer
自身を表現するのに使っているビット数を返します。

符号は無視されます。

```ruby
require 'openssl'

OpenSSL::BN.new("127").num_bits # => 7
OpenSSL::BN.new("-127").num_bits # => 7
OpenSSL::BN.new("128").num_bits # => 8
```

### def num_bytes -> Integer
自身を表現するのに使っているバイト数を返します。

```ruby
require 'openssl'

p 0.to_bn.num_bytes   # => 0
p 255.to_bn.num_bytes # => 1
p 256.to_bn.num_bytes # => 2

p  0b111_11111.to_bn.num_bytes # => 1
p 0b1000_00000.to_bn.num_bytes # => 2
```

### def odd? -> bool
自身が奇数である場合に true を返します。

### def one? -> bool
自身が1である場合に true を返します。

### def prime? -> bool
### def prime?(checks) -> bool
自身が素数であるなら true を返します。

Miller-Rabin 法により確率的に判定します。
checkで指定した回数だけ繰り返します。
引数を省略した場合は OpenSSL が適切な
回数を判断します。

- **param** `check` -- Miller-Robin 法の繰り返しの回数
- **raise** `OpenSSL::BNError` -- 判定時にエラーが発生
- **SEE** [m:OpenSSL::BN#prime_fasttest?]

### def prime_fasttest?(checks=nil, vtrivdiv=true) -> bool
自身が素数であるなら true を返します。

vtrivdiv が真である場合には、 Miller-Rabin 法での
判定の前に小さな素数で割ることで素数か否かを
調べます。自身が小さな素数である場合にはこの手順
により素数ではないと誤った返り値を返します。
#@# 本当は vtrivdiv が false でない

Miller-Rabin 法により確率的に判定します。
checksで指定した回数だけ繰り返します。
checksがnilである場合は OpenSSL が適切な
回数を判断します。

```ruby
require 'openssl'

# 181 は 「小さな素数」である
OpenSSL::BN.new("181").prime_fasttest?(nil, true) # => false
OpenSSL::BN.new("181").prime_fasttest?(nil, false) # => true
```

- **param** `checks` -- Miller-Robin法の繰り返しの回数
- **param** `vtrivdiv` -- 真なら小さな素数で割ることでの素数判定を試みます
- **raise** `OpenSSL::BNError` -- 判定時にエラーが発生
- **SEE** [m:OpenSSL::BN#prime?]

### def set_bit!(n) -> self
自身の n ビット目を1にします。

```ruby
require 'openssl'

a = OpenSSL::BN.new("128")
a.set_bit!(0)
a # => 129
```

- **param** `n` -- 1にするビットの位置
- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::clear_bit!], [m:OpenSSL::bit_set?]

### def sqr -> OpenSSL::BN
自身の2乗を計算します。

- **raise** `OpenSSL::BNError` -- 計算時エラー
- **SEE** [m:OpenSSL::BN#mod_sqr]

### def to_bn -> self
自分自身を返します。

### def to_i -> Integer
### def to_int -> Integer
自身を Integer のインスタンスに変換します。

- **raise** `OpenSSL::BNError` -- 変換に失敗した場合に発生します

### def to_s(base=10) -> String
自身を表す文字列を返します。

base で、変換方法(基数)を指定します。
デフォルトは 10 で、他に 16, 2, 0 を指定できます。

`````
10  10進数の表記
16  16進数の表記
 2  big-endianの符号無し整数のバイナリ列
 0  MPI形式の文字列(バイト列)
`````

- **param** `base` -- 文字列への変換方法(基数)
- **raise** `OpenSSL::BNError` -- 変換に失敗した場合に発生します

```ruby
require 'openssl'

p 10.to_bn.to_s   # =>  "10"
p (-5).to_bn.to_s # =>  "-5"

p 0.to_bn.to_s(16)  # =>   "0"
p 9.to_bn.to_s(16)  # =>  "09"
p 10.to_bn.to_s(16) # =>  "0A"
p 16.to_bn.to_s(16) # =>  "10"
p 26.to_bn.to_s(16) # =>  "1A"
p 256.to_bn.to_s(16) # => "0100"

p 0.to_bn.to_s(2) # => ""
p 6.to_bn.to_s(2) # => "\x06"
p 7.to_bn.to_s(2) # => "\a"

p 0.to_bn.to_s(0) # => "\x00\x00\x00\x00"
p 6.to_bn.to_s(0) # => "\x00\x00\x00\x01\x06"
p 7.to_bn.to_s(0) # => "\x00\x00\x00\x01\a"
```

反対に、文字列から [c:OpenSSL::BN] クラスのインスタンスを作るには
[m:OpenSSL::BN.new] を用います。

- **SEE** [m:OpenSSL::BN.new]


### def pretty_print(pp)

[m:Kernel?.pp] でオブジェクトの内容を出力するときに、内部で呼ばれるメソッドです。

```ruby
#@until 2.5.0
require 'pp'
#@end
require 'openssl'

pp 5.to_bn     #=> #<OpenSSL::BN 5>
pp (-5).to_bn  #=> #<OpenSSL::BN -5>
```

- **param** `pp` -- [c:PP] クラスのインスタンスオブジェクト

### def ucmp(other) -> -1 | 0 | 1
自身と other の絶対値を比較し、自身の絶対値が小さいときには -1、
等しいときには 0、 大きいときには 1 を返します。

```ruby
require 'openssl'

OpenSSL::BN.new(-5).ucmp(5)  # =>  0

OpenSSL::BN.new(5).ucmp(OpenSSL::BN.new(-9))  # => -1
OpenSSL::BN.new(-5).ucmp(OpenSSL::BN.new(5))  # =>  0
OpenSSL::BN.new(-5).ucmp(OpenSSL::BN.new(2))  # =>  1
```

- **param** `other` -- 比較する整数
- **raise** `TypeError` -- 比較できないときに発生します。
- **SEE** [m:OpenSSL::BN#cmp]

#@since 2.5.0
### def negative? -> bool
自身が負である場合に true を返します。Ruby 2.5, OpenSSL 2.1.0 から利用できます。

```ruby
require 'openssl'
p 15.to_bn.negative?    # => false
p  0.to_bn.negative?    # => false
p (-5).to_bn.negative?  # => true
```
#@end

### def zero? -> bool
自身が 0 である場合に true を返します。

