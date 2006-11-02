複素数を扱うためのライブラリです。

=== ChangeLog

#@# *[2002-04-03] 初版 by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]
#@# *[2003-04-29] Complex#polarの記述を正しい配列リテラルの表記に修正 by [[unknown:pastor|URL:mailto:pastor@fmc.rikkyo.ne.jp]]

#@#@# imported by aamine
= class Complex < Numeric

#@# [2002-04-03]  by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]

複素数を扱うクラス

使い方 Usage

Complex を使うためには require 'complex' する必要があります。
このライブラリを require すると、さらに Math モジュールが複素数対応に拡張されます。

  require 'complex'

また、添付ライブラリのベクトルクラス [[c:Vector]]、および、
行列クラス [[c:Matrix]] を読み込んでいるとき、
Vector や Matrix の要素として、複素数を使うことができます。
Vector および Matrix のそれぞれの項目を参照してください。

  require 'matrix'
  require 'complex'

=== 例

 require 'complex'
 
 z1 = Complex.new(4, 3)
 z2 = Complex.new(2, 1)
 
 p z1 + z2 #=> Complex(6, 4)
 p z1 * z2 #=> Complex(5, 10)
 
 i = Complex::I
 
 p z1 == 4 + 3 * i #=> true
 
== Class Methods

--- new(r,i)
--- new!(r,i=0)

実部が r、虚部 i が複素数を生成します。

--- polar(r, theta)

== Instance Methods

--- +(c)
複素数 c を加えた結果を返します。

--- -(c)
複素数 c を減じた結果を返します。

--- *(c)
複素数 c を乗じた結果を返します。

--- /(c)
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
  

--- %(c)
複素数 c で除した余り(実部同士の演算結果 m1、虚部同士の演算結果 m2 )を複素数に
Complex.new(m1, m2)にして返します。

  z1 = a + b * i
  z2 = c + d * i

としたとき、計算結果は

  z1 % z2 = (a % c) + (b % d) * i

です。

--- **(c)
複素数 c でべき乗した結果
  exp(c * log(self)) 
を返します。

#@if (version < "1.8.0")
--- divmod 
このメソッドは廃止されました。
#@end

--- abs
複素数の絶対値を返します。

--- abs2
複素数の絶対値の 2 乗を返します。

--- angle
--- arg
複素数の偏角を[-π,π]の範囲で返します。
以下の例のように虚部が 0.0 と -0.0 では値が変わります。

  p Complex.new(0, 1).arg == Math::PI/2 #=> true
  p Complex.new(0, -1).arg              #=> -1.5707963267949

非正の実軸付近での挙動に注意してください。

  p Complex.new(-1, 0).arg              #=>  3.14159265358979
  p Complex.new(-1, -0).arg             #=>  3.14159265358979
  p Complex.new(-1, -0.0).arg           #=> -3.14159265358979
   
  p Complex.new(0, 0.0).arg             #=>  0.0
  p Complex.new(0, -0.0).arg            #=> -0.0
  p Complex.new(-0.0, 0).arg            #=>  3.14159265358979
  p Complex.new(-0.0, -0.0).arg         #=> -3.14159265358979

--- polar 
複素数の極座標表示、すなわち、配列 [self.abs, self.arg] を返します。

--- conj
--- conjugate
共役複素数を返します。

--- real
--- real=
実部を返します。

--- imag
--- image
--- imag=
--- image=
虚部を返します。

#@if (version < "1.9.0")
--- <=>(c)
cとselfの絶対値absを比較した結果を返します。
#@end

--- ==(c)
c と等しければ、真を返します。

#@if (version < "1.8.0")
--- to_i
整数 [[c:Integer]] に変換します。

--- to_f
浮動小数点数 [[c:Float]] に変換します。

--- to_r
有理数 [[c:Rational]] に変換します。
#@end

#@since 1.9.0
--- scalar?
#@end

== Constants

--- I
虚数単位です。

= reopen Numeric
== Instance Methods
--- im
Returns a Complex number Complex(0, self).

--- real
The real part of a complex number, i.e. self

--- image
--- imag
The imaginary part of a complex number, i.e. 0.

--- arg
偏角を[-π,π]の範囲で返します。実数の場合、
非負なら0、負なら[[c:Math::PI]]を返します。

--- conj
--- conjugate
共役をかえします。実数の場合はselfを返します。


= reopen Math

複素数対応に拡張されます。

必要であるなら、対象となる複素数を極座標表示した時の
  z = a + b * i = r * exp(i * t)
偏角 t は[-π,π]の範囲であると考えて関数は定義されます。
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
