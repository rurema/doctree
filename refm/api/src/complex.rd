複素数を扱うためのライブラリです。

#@#=== ChangeLog
#@# *[2002-04-03] 初版 by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]
#@# *[2003-04-29] Complex#polarの記述を正しい配列リテラルの表記に修正 by [[unknown:pastor|URL:mailto:pastor@fmc.rikkyo.ne.jp]]

#@#@# imported by aamine
= class Complex < Numeric

#@# [2002-04-03]  by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]

複素数を扱うためのクラスです。

このライブラリを require すると、Math モジュールが複素数対応に拡張されます。
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

--- new(r,i) -> Complex
--- new!(r,i=0) -> Complex
[[c:Complex]]クラスのオブジェクトを生成します。

実部が r、虚部が i である複素数を生成します。

@param r 生成する複素数の実部
@param i 生成する複素数の虚部

=== 例

  p Complex(1, 1)       #=> Complex(1, 1)
  p Complex(3.5)        #=> Complex(3.5, 0)

--- polar(r, theta) -> Complex
[[c:Complex]]クラスのオブジェクトを生成します。

絶対値が r、偏角が theta である複素数を生成します。

@param r 生成する複素数の絶対値。
@param theta 生成する複素数の偏角。単位はラジアン角です。

== Instance Methods

--- +(c) -> Complex
複素数 c を加えた結果を返します。

@param c 加算する数
@return 加算結果を[[c:Complex]]クラスのオブジェクトとして返します。

=== 例

  c =  Complex(1, 1)    #=> Complex(1, 1)
  p c + Complex(3, 3)   #=> Complex(4, 4)
  p c + 3               #=> Complex(4, 1)

--- -(c) -> Complex
複素数 c を減じた結果を返します。

@param c 減算する数
@return 減算結果を[[c:Complex]]クラスのオブジェクトとして返します。

=== 例

  c =  Complex(3, 3)    #=> Complex(3, 3)
  p c - Complex(2, 2)   #=> Complex(1, 1)
  p c - 3               #=> Complex(0, 3)

--- *(c) -> Complex
複素数 c を乗じた結果を返します。

@param c 乗算する数
@return 乗算結果を[[c:Complex]]クラスのオブジェクトとして返します。

=== 例

  c =  Complex(1, 1)    #=> Complex(1, 1)
  p c * Complex(2, 2)   #=> Complex(0, 4)
  p c * 3               #=> Complex(3, 3)

--- /(c) -> Complex
複素数 c で除した結果を返します。

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
  
@param c 除算する数
@return 除算結果を[[c:Complex]]クラスのオブジェクトとして返します。

=== 例

  z1 = Complex.new(4, 3)
  z2 = Complex.new(2, 1)
  
  p z1 / z2       #=> Complex(2, 0)
  p 1.0 * z1 / z2 #=> Complex(2.2, 0.4)

#@if (version < "1.9.0")
--- %(c) -> Complex
実部同士の演算結果 m1 と虚部同士の演算結果 m2 を複素数
Complex.new(m1, m2)にして返します。つまり、

  z1 = a + b * i
  z2 = c + d * i

としたとき、計算結果は

  z1 % z2 = (a % c) + (b % d) * i

です。

@param c 演算する数
@return 演算結果を[[c:Complex]]クラスのオブジェクトとして返します。

[注意] このメソッドは Ruby 1.9.0 で廃止されました。

#@else
このメソッドは廃止されました。
#@end

--- **(c) -> Complex
複素数 c でべき乗した結果
  exp(c * log(self)) 
を返します。

@param c 累乗する数
@return 演算結果を[[c:Complex]]クラスのオブジェクトとして返します。

=== 例

  z1 = Complex.new(1, 1)
  z2 = Complex.new(2, 2)

  p z1 ** 2     #=> Complex(0, 2)
  p z1 ** z2    #=> Complex(-0.265653998849241, 0.319818113856136)

#@if (version < "1.8.0")
--- divmod 
このメソッドは廃止されました。
#@end

--- abs -> Float
自分自身の絶対値を返します。

  z = a + b * i

としたとき、絶対値の定義は

  sqrt(a*a + b*b)

です。
計算結果として[[c:Folat]]クラスのオブジェクトが返されることに注意してください。

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

=== 例

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

=== 例

z = Complex.new(3.0, 4.0)

p z        #=> Complex(3.0, 4.0)
p z.polar  #=> [5.0, 0.927295218001612]

--- conj -> Complex
--- conjugate -> Complex
自分の共役複素数を返します。

=== 例

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

#@if (version < "1.9.0")
--- <=>(c) -> Fixnum
cとselfの絶対値absを比較した結果を返します。

self と c の[[m:Complex#abs]]メソッドの結果を比較し、
 * self が大きい場合は正の数
 * c が大きい場合は負の数
 * 同じ場合には 0
を返します。

@param c 比較する[[c:Complex]]クラスのオブジェクト

=== 例

z1 = Complex.new(1, 1)
z2 = Complex.new(2, -2)
p z1 <=> z2   #=> -1

[注意] このメソッドは Ruby 1.9.0 で廃止されました。

#@else
このメソッドは廃止されました。

#@end

--- ==(c)
#@todo
c と等しければ、真を返します。

#@if (version < "1.8.0")
--- to_i
#@todo
整数 [[c:Integer]] に変換します。

--- to_f
#@todo
浮動小数点数 [[c:Float]] に変換します。

--- to_r
#@todo
有理数 [[c:Rational]] に変換します。
#@end

#@since 1.9.0
--- scalar?
#@todo
#@end

== Constants

--- I
#@todo
虚数単位です。

= reopen Numeric
== Instance Methods
--- im
#@todo
Returns a Complex number Complex(0, self).

--- real
#@todo
The real part of a complex number, i.e. self

--- image
--- imag
#@todo
The imaginary part of a complex number, i.e. 0.

--- arg
#@todo
偏角を[-π,π]の範囲で返します。実数の場合、
非負なら0、負なら[[c:Math::PI]]を返します。

--- conj
--- conjugate
#@todo
共役をかえします。実数の場合はselfを返します。

= redefine Math
== Module Functions

--- sqrt(z)
#@todo

--- exp(z)
#@todo

--- log(z)
#@todo

--- log10(z)
#@todo

--- cos(z)
#@todo

--- sin(z)
#@todo

--- tan(z)
#@todo

--- cosh(z)
#@todo

--- sinh(z)
#@todo

--- tanh(z)
#@todo

--- acos(z)
#@todo

--- asin(z)
#@todo

--- atan(z)
#@todo

--- atan2(z)
#@todo

--- acosh(z)
#@todo

--- asinh(z)
#@todo

--- atanh(z)
#@todo
