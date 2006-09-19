mathn

[[lib:rational]] と [[lib:complex]] をシームレスに利用するようにするライブラリです。

Integer や Float に比べ Rational は誤差無しで表現できる範囲が大きいため、
数値の演算において Rational をシームレスに利用したいことがあります。

例:

  1/2 -> Rational(1,2)
  2 * Rational(1,2) -> 1 (Fixnum)

また、Complex も演算結果の表現範囲を広げるのに利用できます。

例:

  Complex(0,-1)**2 -> -1 (Fixnum)
  Complex(1,-1) - Complex(0,-1) -> 1 (Fixnum)

require 'mathn' すると上の様な動作を行なうようになります。
つまり、Rational (や Rationalを含む Complex) と Integer (Fixnum と Bignum) との間の関係を、
ちょうど Bignum と Fixnum との間のような関係にします。
具体的には、Rational のインスタンスが整数ならば、それは自動的に Integer
(Fixnum または Bignum)となり、また、整数/整数の結果、
割り切れない時は Rational が返るようになります。
後者は、整数のメソッド「/」が整商(.div)でなく、
商(.quo)を返すようになる、ということを意味します。

なお、この挙動は、グローバルに影響を与えます。
つまり、(Ruby で書かれた)汎用ライブラリを require していた場合、
ライブラリ中の動作も、上のように変更されることになります。
他人の書いたライブラリを使う時は、ご注意下さい
(逆に、汎用ライブラリの作者の方々は、この [[lib:mathn]] が require
される可能性を留意して書いて下されば、親切だと思います)。

=== 参考

  * [[unknown:ruby-list:1174]]

= reopen Integer

== Class Methods

--- from_prime_division(pd)

素因数分解の配列 pd から数を求めます。
pd は [素因数, 指数] 組の配列です。

例:

  Integer.from_prime_division [[2,3],[3,2]]
  # => 72 # == 2**3 * 3**2

=== Instance Methods

--- gcd2(int)

self と int の最大公約数を求めます。

例:

  12.gcd2 8
  # => 4

--- prime_division

self の素因数分解(の配列)を求めます。

例:

  72.prime_division
  # => [[2, 3], [3, 2]]

= redefine Fixnum

== Instance Methods

--- /(other)

Fixnum#quo と同じ働きをします(有理数または整数を返します)。

#@#* Fixnum#divmodの商が小数点以下まで求まるようになる。
#@#* もともとのFixnum#divmodはFixnum#divmod!となる。

= redefine Bignum

== Instance Methods

--- /(other)

Bignum#quo と同じ働きをします(有理数または整数を返します)。

#@#* もともとのBignum#divmodはBignum#divmod!となる。

= redefine Rational

== Instance Methods

--- **

self のべき乗を返します。 Rational になるようであれば Rational で返します。

--- power2

      作りかけ(^^;;

--- inspect

「3/5」などの形で返します。

= redefine Math

== Module Functions

--- sqrt(a)

a の正の平方根を返します。
a が Complex の時は、Complex を返します。
a が負の時は、a を正にして、その平方根を Complex の虚数部に入れて返します。
それ以外は、Math.rsqrt の結果を返します。

--- rsqrt(a)

複素数を考慮しないので、負の数や Complex をあたえないでください。

a が Float の時は、Float を返します。
それ以外の時、平方根が有理数であれば、Rational または Interger を返します。
無理数であれば、Float を返します。

= class Prime < Object

include Enumerable

== Class Methods

--- new

素数を生成するオブジェクトを作ります。

== Instance Methods

--- succ
--- next

次の素数を返します。

例:

  q = Prime.new
  q.succ # => 2
  q.succ # => 3
  q.succ # => 5

--- each

素数について繰り返すイテレータです。
これは無限ループになるので必ず break を入れてください。

例:

  > q=Prime.new; i = 0; q.each  {|x| break if i > 5; puts x; i+=1;}
  2
  3
  5
  7
  11
  13

#@if (version >= "1.9.0")
--- primes

((<ruby 1.9 feature>))

それまでに求めた素数の配列を返します。
#@end
