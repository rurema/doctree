category Math

#@since 1.9.1
require cmath
#@end

複素数を扱うためのライブラリです。

#@since 1.9.1

1.9系では [[c:Complex]] クラスは組み込みクラスになりました。complex ラ
イブラリは互換性のために残されています。

= reopen Numeric

== Instance Methods

--- im -> Complex

実数に対し、純虚数化した [[c:Complex]] クラスのオブジェクトを返します。

例:

  require "complex"
  n = 100
  n.im   #=> (0+100i)

= reopen Complex

== Class Methods

--- generic?(other) -> bool

other が [[c:Integer]] [[c:Float]] [[c:Rational]] クラスのオブジェクト
かどうか判定します。

@param other 判定対象のオブジェクト

@return [[c:Integer]] [[c:Float]] [[c:Rational]] クラスのオブジェクトの
        時 trueそれ以外の場合には false を返します。

== Instance Methods

--- image -> Numeric

自身の虚部を返します。[[m:Complex#imag]] のエイリアスです。

例:

  require 'complex'
  Complex(3, 2).image # => 2

#@else

= reopen Kernel

== Module Functions

--- Complex(r, i = 0) -> Complex

実部が r、虚部が i である [[c:Complex]] クラスのオブジェクトを生成します。

@param r 生成する複素数の実部。

@param i 生成する複素数の虚部。省略した場合は 0 です。

  Complex(1)       # => Complex(1, 0)
  Complex(1, 2)    # => Complex(1, 2)

r にも i にも複素数と解釈されるオブジェクトを指定した場合には、
Complex(a, b) を a+bi として計算した [[c:Complex]] オブジェクトを返しま
す。

  Complex(Complex(1, 1), Complex(2, 3))         # => Complex(-2, 3)
  Complex(1, 1) + Complex(2, 3) * Complex(0, 1) # => Complex(-2, 3)

[注意] 1.9 系とは異なり、Complex('1+1i') のように文字列を引数に渡す事は
できません。

  Complex('1+1i')  # => NoMethodError
  Complex('10@10') # => NoMethodError

#@#=== ChangeLog
#@# *[2002-04-03] 初版 by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]
#@# *[2003-04-29] Complex#polarの記述を正しい配列リテラルの表記に修正 by [[unknown:pastor|URL:mailto:pastor@fmc.rikkyo.ne.jp]]

#@#@# imported by aamine
= class Complex < Numeric

#@# [2002-04-03]  by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]

複素数を扱うためのクラスです。

#@if (version < "1.9.0")

このライブラリを require すると、[[c:Math]] モジュールが複素数対応に拡張されます。
対象となる複素数を以下のように極座標表示した時の
  z = a + b * i = r * exp(i * t)
偏角 t は[-π,π]の範囲であると考えて、関数は定義されます。
[[m:Complex#arg]]を参照して下さい。

以下が複素関数の定義です。

  abs(z)  = r
  sqrt(z) = sqrt(r) * exp(i * t/2)
  exp(z)  = exp(a) * exp(i * b)
  log(z)  = log(r) + i * t
  
  sin(z)  = (exp(i * z) - exp(-i * z)) / 2i
  cos(z)  = (exp(i * z) + exp(-i * z)) / 2
  tan(z)  = sin(z) / cos(z)
  sinh(z) = (exp(z) - exp(-z)) / 2
  cosh(z) = (exp(z) + exp(-z)) / 2
  tanh(z) = sinh(z) / cosh(z)
  
  asin(z) = -i * log(i*z + sqrt(1-z*z))
  acos(z) = -i * log(z + i*sqrt(1-z*z))
  atan(z) = i/2 * log((i+z) / (i-z))
  atan2(y, x) = -i * log( (x + i * y) / sqrt( x*x + y*y ) )
  asinh(z) = log(z + sqrt(z*z+1))
  acosh(z) = log(z + sqrt(z*z-1))
  atanh(z) = 1/2 * log((1+z) / (1-z))

また、添付ライブラリのベクトルクラス [[c:Vector]]、および、
行列クラス [[c:Matrix]] を読み込んでいるとき、
Vector や Matrix の要素として、複素数を使うことができます。
Vector および Matrix のそれぞれの項目を参照してください。

=== 例

  require 'complex'
 
  z1 = Complex.new(4, 3)
  z2 = Complex.new(2, 1)
 
  p z1 + z2 #=> Complex(6, 4)
  p z1 * z2 #=> Complex(5, 10)
 
  i = Complex::I
 
  p z1 == 4 + 3 * i #=> true
 
== Class Methods

--- new(r, i) -> Complex
--- new!(r, i = 0) -> Complex
実部が r、虚部が i である[[c:Complex]]クラスのオブジェクトを生成します。

@param r 生成する複素数の実部
@param i 生成する複素数の虚部

例:

  p Complex.new(1, 1)   #=> Complex(1, 1)
  p Complex.new!(3.5)   #=> Complex(3.5, 0)

--- polar(r, theta) -> Complex
絶対値が r、偏角が theta である [[c:Complex]]クラスのオブジェクトを生成します。

@param r 生成する複素数の絶対値。
@param theta 生成する複素数の偏角。単位はラジアンです。

例:

  p Complex.polar(2.0, 0)         #=> Complex(2.0, 0.0)
  p Complex.polar(2.0, Math::PI)  #=> Complex(-2.0, 2.44929359829471e-16)

--- generic?(other) -> bool
other が [[c:Integer]] [[c:Float]] [[c:Rational]] クラスのオブジェクトかどうか判定します。

@param other 判定対象のオブジェクト
@return [[c:Integer]] [[c:Float]] [[c:Rational]] クラスのオブジェクトの時 true
        それ以外の場合には false を返します。

== Instance Methods

--- +(c) -> Complex
複素数 c を加えた結果を返します。

@param c 加算する数
@return 加算結果を[[c:Complex]]クラスのオブジェクトとして返します。

例:

  c =  Complex(1, 1)    #=> Complex(1, 1)
  p c + Complex(3, 3)   #=> Complex(4, 4)
  p c + 3               #=> Complex(4, 1)

--- -(c) -> Complex
複素数 c を減じた結果を返します。

@param c 減算する数
@return 減算結果を[[c:Complex]]クラスのオブジェクトとして返します。

例:

  c =  Complex(3, 3)    #=> Complex(3, 3)
  p c - Complex(2, 2)   #=> Complex(1, 1)
  p c - 3               #=> Complex(0, 3)

--- *(c) -> Complex
複素数 c を乗じた結果を返します。

@param c 乗算する数
@return 乗算結果を[[c:Complex]]クラスのオブジェクトとして返します。

例:

  c =  Complex(1, 1)    #=> Complex(1, 1)
  p c * Complex(2, 2)   #=> Complex(0, 4)
  p c * 3               #=> Complex(3, 3)

--- /(other) -> Complex
複素数 other で除した結果を返します。

  z1 = a + b * i
  z2 = c + d * i

としたとき、除算の定義は

  z1 / z2 = ((a*c + b*d)/(c*c + d*d)) + ((b*c - a*d)/(c*c + d*d)) * i

です。このため実部と虚部が全て整数だった場合、整数同士の除算として / が
計算されることに注意してください。

  z1 = Complex.new(4, 3)
  z2 = Complex.new(2, 1)
  
  p z1 / z2       #=> Complex(2, 0)
  p 1.0 * z1 / z2 #=> Complex(2.2, 0.4)
  
@param other 除算する数
@return 除算結果を[[c:Complex]]クラスのオブジェクトとして返します。

例:

  z1 = Complex.new(4, 3)
  z2 = Complex.new(2, 1)
  
  p z1 / z2       #=> Complex(2, 0)
  p 1.0 * z1 / z2 #=> Complex(2.2, 0.4)

#@until 1.9.1
--- %(c) -> Complex
除算の剰余を計算します。

引数other が[[c:Complex]]オブジェクトの場合、

  (自分自身の実部 % c の実部) + (自分自身の虚部 % c の虚部) * i

を返します。
このため、c の実部または虚部が0だった場合、ZeroDivisionError例外が発生することに注意してください。
引数 c が[[c:Complex]]のオブジェクトではない場合、実部・虚部それぞれを c で除算したときの剰余を実部・虚部に持つ[[c:Complex]]オブジェクトを返します。

例：
  Complex(5, 4) % 3 #=> Complex(2, 1)

@param c 除算する数
@return 演算結果を[[c:Complex]]クラスのオブジェクトとして返します。

[注意] このメソッドは Ruby 1.9 で廃止されました。

#@else
[注意] このメソッドは廃止されました。
#@end

--- **(c) -> Complex
複素数 c でべき乗した結果
  exp(c * log(self)) 
を返します

@param c 累乗する数
@return 演算結果を[[c:Complex]]クラスのオブジェクトとして返します。

例:

  z1 = Complex.new(1, 1)
  z2 = Complex.new(2, 2)

  p z1 ** 2     #=> Complex(0, 2)
  p z1 ** z2    #=> Complex(-0.265653998849241, 0.319818113856136)

#@if (version < "1.8.0")
--- divmod 
このメソッドは廃止されました。
#@end

--- quo(other) -> Complex

self を other で割った商を返します。

[[lib:rational]] ライブラリを require している場合は、
成分を有理数の範囲で計算できるなら実部・虚部が [[c:Rational]] の複素数で結果を返します。

@param other self を割る数を指定します。

  require 'complex'
  z = Complex.new(1, 0)
  
  z.quo(2)    #=> Complex(0.5, 0.0)
  z.quo(2.0)  #=> Complex(0.5, 0.0)
  
  require 'rational'
  z.quo(2)    #=> Complex(Rational(1, 2), Rational(0, 1))
  z.quo(2.0)  #=> Complex(0.5, 0.0)

--- abs -> Float
自分自身の絶対値を返します。

  z = a + b * i

としたとき、絶対値の定義は

  sqrt(a*a + b*b)

です。
計算結果として[[c:Float]]クラスのオブジェクトが返されることに注意してください。

--- abs2 -> Fixnum
--- abs2 -> Float
自分自身の絶対値の2乗を返します。

  z = a + b * i

としたとき、[[m:Complex#abs2]] の定義は

  a*a + b*b

です。

--- angle -> Float
--- arg -> Float
複素数の偏角を[-π,π]の範囲で返します。

例:

  p Complex.new(0, 1).arg == Math::PI/2 #=> true
  p Complex.new(0, -1).arg              #=> -1.5707963267949

非正の実軸付近での挙動に注意してください。
以下の例のように虚部が 0.0 と -0.0 では値が変わります。

  p Complex.new(-1, 0).arg              #=>  3.14159265358979
  p Complex.new(-1, -0).arg             #=>  3.14159265358979
  p Complex.new(-1, -0.0).arg           #=> -3.14159265358979
   
  p Complex.new(0, 0.0).arg             #=>  0.0
  p Complex.new(0, -0.0).arg            #=> -0.0
  p Complex.new(-0.0, 0).arg            #=>  3.14159265358979
  p Complex.new(-0.0, -0.0).arg         #=> -3.14159265358979

--- polar -> Array
複素数の極座標表示、すなわち、配列 [self.abs, self.arg] を返します。

例:

  z = Complex.new(3.0, 4.0)

  p z        #=> Complex(3.0, 4.0)
  p z.polar  #=> [5.0, 0.927295218001612]

--- conj -> Complex
--- conjugate -> Complex
自分の共役複素数を返します。

例:

  z = Complex.new(1, 1)
  p z.conjugate   #=> Complex(1, -1)

--- real -> Fixnum
--- real -> Float
#@# Complex#real= を削除
#@#--- real=
実部を返します。

--- imag -> Fixnum
--- imag -> Float
--- image -> Fixnum
--- image -> Float
#@# Complex#imag=, Complex#image= を削除
#@#--- imag=
#@#--- image=
虚部を返します。

--- <=>(c) -> Fixnum
cとselfの絶対値absを比較した結果を返します。

self と c の[[m:Complex#abs]]メソッドの結果を比較し、
 * self が大きい場合は正の数
 * c が大きい場合は負の数
 * 同じ場合には 0
を返します。

@param c 比較する[[c:Complex]]クラスのオブジェクト

例:

  z1 = Complex.new(1, 1)
  z2 = Complex.new(2, -2)
  p z1 <=> z2   #=> -1

[注意] このメソッドは Ruby 1.9 で廃止されます。

--- ==(c) -> bool

数値として等しいか判定します。

@param c 自身と比較する数値

例:

  z1 = Complex.new(1, 2)
  z2 = Complex.new(1, 0)
  z3 = Complex.new(0, 1)

  p z1 == Complex.new(1, 2)  #=> true
  p z1 == z2                 #=> false
  p z2 == 1.0                #=> true
  p z3 == Complex::I         #=> true

#@if (version < "1.8.0")
--- to_i -> Integer
整数 [[c:Integer]] に変換します。

[注意] このメソッドは廃止されました。
--- to_f
浮動小数点数 [[c:Float]] に変換します。

[注意] このメソッドは廃止されました。
--- to_r
有理数 [[c:Rational]] に変換します。

[注意] このメソッドは廃止されました。
#@end

--- coerce(other) -> Array
自分自身とotherのペアの配列を生成し、生成した配列を返します。

otherが [[c:Complex]] のオブジェクトではないときは [[c:Complex]] オブジェクト化したものが配列の要素となります。

@param other 配列の要素となるオブジェクト

例:

  z1 = Complex.new(1, 2)
  z2 = Complex.new(3, 4)

  p z1.coerce(5)  #=>  [Complex(5, 0), Complex(1, 2)]
  p z1.coerce(z2) #=>  [Complex(3, 4), Complex(1, 2)]

--- denominator -> Fixnum
自分自身の実部・虚部の分母のLCM(最小公倍数)を返します。

例:

  z1 = Complex.new(1, 2)
  z2 = Complex.new(Rational.new!(1, 3), Rational.new!(3, 5))

  p z1.denominator  #=> 1
  p z2.denominator  #=> 15

--- numerator -> Complex
[[m:Complex#denominator]] の値で実部・虚部を通分したものの分子のみを [[c:Complex]] で返します。

具体的な計算式は

 * 実部 = 実部の分子 * (実部、虚部の分母の最大公約数 / 実部の分母)
 * 虚部 = 虚部の分子 * (実部、虚部の分母の最大公約数 / 虚部の分母)

例:

  z1 = Complex.new(1, 2)
  z2 = Complex.new(Rational.new!(1, 3), Rational.new!(3, 5))

  p z1.numerator
  p z2.numerator

--- hash -> Fixnum
複素数のハッシュ値を返します。

例:

  z1 = Complex.new(3.5, 1.20)
  z2 = Complex.new(3.5, 1.21)

  p z1.hash    #=> 1889428376
  p z2.hash    #=> 425788526

--- inspect -> String
自分自身について "Complex(実部, 虚部)" 形式の文字列を返します。

--- to_s -> String
自分自身について "実部 + 虚部i" 形式の文字列を返します。

== Constants

--- I -> Complex
虚数単位です。

[注意] Complex::I は Complex.new(0, 1) で生成されるオブジェクトと同じものです。

= reopen Numeric
== Instance Methods
--- im -> Complex
実数に対し、純虚数化した [[c:Complex]] クラスのオブジェクトを返します。

例:

  n = 100
  p n.im   #=> Complex(0, 100)

--- real -> self
複素数として見た場合の実部を返します。
つまり、self が実数の場合はそのまま、selfを返します。

--- image -> Fixnum
--- imag -> Fixnum
複素数として見た場合の虚部を返します。
つまり、self が実数の場合は 0 を返します。

--- arg -> Fixnum | Float
複素数として見た場合の偏角を[-π,π]の範囲で返します。
非負なら0、負なら [[m:Math::PI]] を返します。

例:

  n = 1000
  f = -12.345

  p n.arg    #=> 0
  p f.arg    #=> 3.14159265358979

--- conj -> self
--- conjugate -> self

自身の共役複素数(実数の場合は常に自身)を返します。

= redefine Math
== Module Functions

--- sqrt(z) -> Complex
z の平方根を返します。

複素関数としてのsqrt()の定義は以下です。

  sqrt(z) = sqrt(r) * exp(i * t/2)

@param z 平方根を求める複素数

===== 注意

虚部が 0 でも [[c:Complex]] クラスのオブジェクトであれば [[c:Complex]] クラスのオブジェクトを返すことに注意してください。

  n = 2
  z = Complex.new(2, 0)

  p Math.sqrt(n) #=> 1.4142135623731
  p Math.sqrt(z) #=> Complex(1.4142135623731, 0.0)

--- exp(z) -> Complex
指数関数(自然対数 e の z 乗)を返します。

複素数 z = a + b *i に対する exp(z) の定義は以下です。

  exp(z)  = exp(a) * exp(i * b)

@param z 複素数

===== 注意

虚部が 0 でも [[c:Complex]] クラスのオブジェクトであれば [[c:Complex]] クラスのオブジェクトを返すことに注意してください。

  n = 2
  z = Complex.new(2, 0)

  p Math.exp(n) #=> 7.38905609893065
  p Math.exp(z) #=> Complex(7.38905609893065, 0.0)

--- log(z) -> Complex
複素数 z の自然対数を返します。

絶対値 r 偏角 theta の複素数 z に対する log(z) は以下で定義されます。

  log(z)  = log(r) + i * theta

@param z 複素数

===== 注意

虚部が 0 でも [[c:Complex]] クラスのオブジェクトであれば [[c:Complex]] クラスのオブジェクトを返すことに注意してください。

  n = 2
  z = Complex.new(2, 0)

  p Math.log(n) #=> 0.693147180559945
  p Math.log(z) #=> Complex(0.693147180559945, 0.0)

--- log10(z) -> Complex
複素数 z の常用対数を返します。

複素数 z に対する log10(z) は以下で定義されます。

  log10(z)  = log(z) / log(10)

@param z 複素数

===== 注意

虚部が 0 でも [[c:Complex]] クラスのオブジェクトであれば [[c:Complex]] クラスのオブジェクトを返すことに注意してください。

  n = 2
  z = Complex.new(2, 0)

  p Math.log10(n) #=> 0.301029995663981
  p Math.log10(z) #=> Complex(0.301029995663981, 0.0)

--- cos(z) -> Complex
複素関数としてのcos関数の結果を返します。

cos関数は以下で定義されます。

  cos(z)  = (exp(i * z) + exp(-i * z)) / 2

@param z 複素数

--- sin(z) -> Complex
複素関数としてのsin関数の結果を返します。

sin関数は以下で定義されます。

  sin(z)  = (exp(i * z) - exp(-i * z)) / 2

@param z 複素数

--- tan(z) -> Complex
複素関数としてのtan関数の結果を返します。

tan関数は以下で定義されます。

  tan(z)  = sin(z) / cos(z)

@param z 複素数

--- cosh(z) -> Complex
複素関数としてのcosh関数(双曲線cos関数)の結果を返します。

cosh関数は以下で定義されます。

  cosh(z) = (exp(z) + exp(-z)) / 2

@param z 複素数

--- sinh(z) -> Complex
複素関数としてのsinh関数(双曲線sin関数)の結果を返します。

sinh関数は以下で定義されます。

  sinh(z) = (exp(z) - exp(-z)) / 2

@param z 複素数

--- tanh(z) -> Complex
複素関数としてのtanh関数(双曲線tan関数)の結果を返します。

tanh関数は以下で定義されます。

  tanh(z) = sinh(z) / cosh(z)

@param z 複素数

--- acos(z) -> Complex
複素関数としてのacos関数(逆cos関数)の結果を返します。

acos関数は以下で定義されます。

  acos(z) = -i * log(z + i*sqrt(1-z*z))

@param z 複素数

--- asin(z) -> Complex
複素関数としてのasin関数(逆sin関数)の結果を返します。

asin関数は以下で定義されます。

  asin(z) = -i * log(i*z + sqrt(1-z*z))

@param z 複素数

--- atan(z) -> Complex
複素関数としてのatan関数(逆tan関数)の結果を返します。

atan関数は以下で定義されます。

  atan(z) = i/2 * log((i+z) / (i-z))

@param z 複素数

--- atan2(z) -> Complex
複素関数としてのatan2関数の結果を返します。

atan2関数は以下で定義されます。

  atan2(y, x) = -i * log( (x + i * y) / sqrt( x*x + y*y ) )

@param z 複素数

--- acosh(z) -> Complex
複素関数としてのacosh関数(双曲逆cos関数)の結果を返します。

acosh関数は以下で定義されます。

  acosh(z) = log(z + sqrt(z*z-1))

@param z 複素数

--- asinh(z) -> Complex
複素関数としてのasinh関数(双曲逆sin関数)の結果を返します。

asinh関数は以下で定義されます。

  asinh(z) = log(z + sqrt(z*z+1))

@param z 複素数

--- atanh(z) -> Complex
複素関数としてのatanh関数(双曲逆tan関数)の結果を返します。

atanh関数は以下で定義されます。

  atanh(z) = 1/2 * log((1+z) / (1-z))

@param z 複素数

#@end

#@end
