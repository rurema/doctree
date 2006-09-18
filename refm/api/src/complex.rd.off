complex

=== ChangeLog

*[2002-04-03] 初版 by [[unknown:すす|URL:mailto:sugawah@attglobal.net]]
*[2003-04-29] Complex#polarの記述を正しい配列リテラルの表記に修正 by [[unknown:pastor|URL:mailto:pastor@fmc.rikkyo.ne.jp]]

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

== Class Methods

--- new(r,i)
--- r,i=0)
--- new!(r,i=0)

実部が r、虚部 i が複素数を生成します。

== Instance Methods

--- +(c)
複素数 c を加えた結果を返します。

--- -(c)
複素数 c を減じた結果を返します。

--- *(c)
複素数 c を乗じた結果を返します。

--- /(c)
複素数 c で除した結果を返す。

--- %(c)
複素数 c で除した余り(実部同士、虚部同士の演算結果)を返します。

--- **(c)
複素数 c でべき乗した結果を返します。

--- divmod -- obsolete
このメソッドは廃止されました。

--- abs
複素数の絶対値を返します。

--- abs2
複素数の絶対値の 2 乗を返します。

--- arg
複素数の偏角を返します。
#@# (値域は?）

--- polar
複素数の極座標表示、すなわち、配列 [self.abs,self.arg] を返します。

--- conjugate
共役複素数を返します。

--- real
実部を返します。

--- image
虚部を返します。

--- <=>(c)
c との比較結果を返します。

--- ==(c)
c と等しければ、真を返します。

--- to_i
整数 [[c:Integer]] に変換します。

--- to_f
浮動小数点数 [[c:Float]] に変換します。

--- to_r
有理数 [[c:Rational]] に変換します。

== Constants

--- I
虚数単位。
