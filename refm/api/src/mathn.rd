category Math

require matrix
require cmath
require prime
[[c:Rational]] と [[c:Complex]] をよりシームレスに利用できるようにするライブラリです。数値ライブラリの挙動をグローバルに変更します。

#@since 2.2.0
なお、このライブラリは非推奨(deprecated)です。
#@end

 * 整数の除算が割り切れない場合、 [[c:Rational]] オブジェクトを返すようになります。
 * 複素数や有理数の演算結果が実数や整数に収まる場合、 [[c:Float]] オブジェクトや [[c:Integer]] オブジェクトを返します。
 * [[c:Math]] モジュールの数学関数の定義域と終域を、実数のみから複素数へと拡大します。

=== 利用局面

Integer や Float に比べ Rational は誤差無しで表現できる範囲が大きいため、
数値の演算において Rational をシームレスに利用したいことがあります。
そこで mathn ライブラリは、各数値クラスの間の関係を
#@until 2.4.0
ちょうど Bignum と Fixnum とのような
#@end
自動的に変換される関係にします。

==== 整数と有理数の相互変換

具体的には、Rational のインスタンスが整数ならば、それは自動的に Integer
#@until 2.4.0
(Fixnum または Bignum)
#@end
となり、また、整数/整数の結果、
割り切れない時は Rational が返るようになります。後者は、整数のメソッド「/」が整商(.div)でなく、商(.quo)を返すようになる、ということを意味します。

例:
  1/2                #=> 0
  2 * Rational(1,2)  #=> Rational(1,1)

  require 'mathn'
  1/2                #=> Rational(1,2)
  2 * Rational(1,2)  #=> 1

==== 実数と複素数の相互変換

同様にして Complex のインスタンスの虚部が 0 ならば、実部として含まれていた Rational, Float, または Integer オブジェクトに変換されます。

一方、数学演算の定義域・終域を複素数に拡大するので、 mathn を利用しない場合には範囲エラー例外を発生していたような演算が Complex オブジェクトを返す場合もあります。

例:
 Complex(0,-1)**2  #=> Complex(-1,0)
 Math.sqrt(-1)     #=> NaN
 
 require 'mathn'
 Complex(0,-1)**2  #=> -1
 Math.sqrt(-1)     #=> Complex(0,1)

=== 使用上の注意
なお、この挙動は、グローバルに影響を与えます。
つまり、(Ruby で書かれた)汎用ライブラリを require していた場合、
ライブラリ中の動作も、上のように変更されることになります。
他人の書いたライブラリを使う時は、ご注意下さい

逆に、汎用ライブラリの作者の方々は、この [[lib:mathn]] が require
される可能性を留意して書いて下されば親切だと思います。
整数同士で整除を意図するならば / メソッド ではなく div メソッド を用いると良いでしょう。

  * [[ruby-list:1174]]

=== Prime

クラス [[c:Prime]] はRuby 1.8までは [[lib:mathn]] で定義されていました。
現在はライブラリ [[lib:prime]] に移動しています。互換性のため mathn を読み込むと自動的に prime も [[m:Kernel.#require]] されます。

#@since 2.4.0
= redefine Integer

== Instance Methods

--- /(other) -> Numeric

[[m:Fixnum#quo]] と同じ働きをします(有理数または整数を返します)。

例:

  10 / 3 # => 3

  require 'mathn'
  10 / 3 # => (10/3)

#@else
= redefine Fixnum

== Instance Methods

--- /(other)
#@todo

Fixnum#quo と同じ働きをします(有理数または整数を返します)。

= redefine Bignum

== Instance Methods

--- /(other)
#@todo

Bignum#quo と同じ働きをします(有理数または整数を返します)。
#@end

= redefine Rational

== Instance Methods

--- **(rhs) -> Numeric
#@todo

self のべき乗を返します。 Rational になるようであれば Rational で返します。

= redefine Math

== Module Functions

--- sqrt(a) -> Numeric
#@todo

a の正の平方根を返します。
a が Complex の時は、Complex を返します。
a が負の時は、a を正にして、その平方根を Complex の虚数部に入れて返します。
それ以外は、Math.rsqrt の結果を返します。

--- rsqrt(a) -> Numeric
#@todo

複素数を考慮しないので、負の数や Complex をあたえないでください。

a が Float の時は、Float を返します。
それ以外の時、平方根が有理数であれば、Rational または Integer を返します。
無理数であれば、Float を返します。
