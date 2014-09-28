#@since 1.9.1

category Math

素数や素因数分解を扱うライブラリです。

ライブラリの中心にあるのは [[c:Prime]] クラスで、これは素数全体を表すシングルトンです。また、素数性と素因数分解に関するメソッドを [[c:Integer]] に追加します。
さらに、 Prime クラスの機能を実現するための低水準のクラスも幾つか提供されています。

=== 例

  Prime.each(100) do |prime|
    p prime #=> 2, 3, 5, 7, 11, ..., 97
  end

  2.prime? #=> true
  4.prime? #=> false

=== 生成器

[[c:Prime]] のメソッドは内部で低水準の疑似素数生成器を使用します。
生成器は擬似素数の列挙方法の実装を提供します。また列挙状態や列挙の上界を記憶する機能もあります。
更に、 [[c:Enumerator]] と互換性のある外部イテレータでもあります。

状況に応じて適切な疑似素数生成アルゴリズムは異なるので、いくつかの生成器の実装が用意されています。 
[[c:Prime::PseudoPrimeGenerator]] は生成器の基底となるクラスです。

: [[c:Prime::EratosthenesGenerator]]
  エラトステネスの篩いを使用します。
: [[c:Prime::TrialDivisionGenerator]]
  試行除算法を使用します。
: [[c:Prime::Generator23]]
  2 と 3 で割り切れない全ての正の整数を生成します。
  この数列は素数の数列としては使い物になりません。しかし、他の生成器より速く、
  メモリの使用量も少ないという特徴があります。そのため、それほど大きくなくて、
  素数の要素を多く持つ整数の因数分解に向いています。

Prime クラスの各メソッドは、一般的な用途を想定して適切な生成器を使用します。
ユーザーは必要に応じて特定の生成器実装を使用するようにオプション引数を設定することもできます。また、ユーザーは独自の生成器を実装することもできます。

= class Prime < Object
include Enumerable

素数全体を表します。

=== インスタンスを取得する方法

Prime クラスはシングルトンであると考えてください。Prime クラスはデフォルトのインスタンスを持っており、ユーザーはそのインスタンスを利用すべきです。 [[m:Prime.instance]] によってそのインスタンスを取得できます。

過去との互換性のために [[m:Prime.new]] も残っています。このメソッドは非推奨ですので、新しいプログラムでは利用しないでください。

なお、利便性のためにデフォルトインスタンスのメソッドをクラスメソッドとしても利用できます。

例:
  Prime.instance.prime?(2)  #=> true
  Prime.prime?(2)           #=> true


== Class Methods
--- new -> Prime
過去との互換性のためのメソッドです。新しいプログラムでは [[m:Prime.instance]] やクラスメソッドを利用してください。

このメソッドが返すインスタンスは、デフォルトのインスタンスとは違って[[c:Prime::OldCompatibility]] で拡張されています。

--- instance -> Prime

[[c:Prime]] のデフォルトのインスタンスを返します。


== Instance Methods

--- each(upper_bound = nil, generator = EratosthenesGenerator.new){|prime| ... } -> object
--- each(upper_bound = nil, generator = EratosthenesGenerator.new)               -> Enumerator

全ての素数を順番に与えられたブロックに渡して評価します。

@param upper_bound 任意の正の整数を指定します。列挙の上界です。
                   nil が与えられた場合は無限に列挙し続けます。

@param generator 素数生成器のインスタンスを指定します。

@return ブロックの最後に評価された値を返します。
        ブロックが与えられなかった場合は、[[c:Enumerator]] と互換性のある外部イテレータを返します。

=== 例:
  Prime.each(6).each{|prime| prime }  # => 5
  Prime.each(7).each{|prime| prime }  # => 7
  Prime.each(10).each{|prime| prime } # => 7
  Prime.each(11).each{|prime| prime } # => 11

=== 例: 30以下の双子素数
  Prime.each(30).each_cons(2).select{|p,r| r-p == 2} 
    #=> [[3, 5], [5, 7], [11, 13], [17, 19]]

=== 注
このメソッドに、真の素数列でない疑似素数を与えるべきではありません。

このメソッドは、素数列の外部イテレータを内部イテレータに変換してRubyらしいプログラミングを提供することが責務です。独自に素数性の保障するのはメソッドの責務ではありません。従って、次のように精度の低い素数生成器を与えると、真に素数とは限らない数列が発生します。
 Prime.each(50, Prime::Generator23.new) do |n|
   p n #=> [2, 3, 5, 7, 11, 13, 17, 19, 23, 25, 29, 31, 35, 37, 41, 43, 47, 49]
 end

@see [[c:Prime::EratosthenesGenerator]], [[c:Prime::TrialDivisionGenerator]], [[c:Prime::Generator23]]

--- int_from_prime_division(pd) -> Integer

素因数分解された結果を元の数値に戻します。

引数が [[p_1, e_1], [p_2, e_2], ...., [p_n, e_n]] のようであるとき、
結果は  p_1**e_1 * p_2**e_2 * .... * p_n**e_n となります。

@param pd 整数のペアの配列を指定します。含まれているペアの第一要素は素因数を、
          第二要素はその素因数の指数をあらわします。

例:
  Prime.int_from_prime_division([[2,2], [3,1]])  #=> 12
  Prime.int_from_prime_division([[2,2], [3,2]])  #=> 36

--- prime?(value, generator = Prime::Generator23.new) -> bool

与えられた整数が素数である場合は、真を返します。
そうでない場合は偽を返します。

@param value 素数かどうかチェックする任意の整数を指定します。

@param generator 素数生成器のインスタンスを指定します。

@return 素数かどうかを返します。
#@since 2.2.0
        引数 value に負の数を指定した場合は常に false を返します。
#@end

@see [[c:Prime::EratosthenesGenerator]], [[c:Prime::TrialDivisionGenerator]], [[c:Prime::Generator23]]

--- prime_division(value, generator= Prime::Generator23.new) -> [[Integer, Integer]]

与えられた整数を素因数分解します。

@param value 素因数分解する任意の整数を指定します。

@param generator 素数生成器のインスタンスを指定します。

@return 素因数とその指数から成るペアを要素とする配列です。つまり、戻り値の各要素は2要素の配列 [n,e] であり、それぞれの内部配列の第1要素 n は value の素因数、第2要素は n**e が value を割り切る最大の自然数 e です。

@raise ZeroDivisionError 与えられた数値がゼロである場合に発生します。

例:
    Prime.prime_division(12) #=> [[2,2], [3,1]]
    Prime.prime_division(10) #=> [[2,1], [5,1]]

@see [[c:Prime::EratosthenesGenerator]], [[c:Prime::TrialDivisionGenerator]], [[c:Prime::Generator23]]

= class Prime::PseudoPrimeGenerator < Object
include Enumerable

擬似素数列の列挙子のための抽象クラスです。

[[c:Prime]] の各メソッドが使用する低水準の疑似素数列挙子は、 Prime::PseudoPrimeGenerator のインスタンスであることが期待されています。
このクラスを継承する具象クラスは succ, next, rewind をオーバーライドしなければなりません。

独自の素数列挙アルゴリズムを実装しようとする場合を除いて、ユーザーがこのクラスを利用する必要はありません。高水準の [[c:Prime]] クラスを利用してください。

== Class Methods

--- new(upper_bound = nil) -> Prime::PseudoPrimeGenerator

自身を初期化します。

@param upper_bound 列挙する素数の上界を指定します。

== Instance Methods

--- each {|prime| ... } -> object
--- each -> self

素数を与えられたブロックに渡して評価します。

--- next -> ()
--- succ -> ()

次の擬似素数を返します。
また内部的な位置を進めます。

サブクラスで実装してください。

@raise NotImplementedError 必ず発生します。

--- rewind -> ()

列挙状態を巻き戻します。

サブクラスで実装してください。

@raise NotImplementedError 必ず発生します。

@see [[m:Enumerator#rewind]]

--- upper_bound -> Integer | nil

現在の列挙上界を返します。 nil は上界がなく無限に素数を列挙すべきであることを意味します。

--- upper_bound=(upper_bound)

新しい列挙上界をセットします。

@param upper_bound 新しい上界を整数または nil で指定します。 nil は上界がなく無限に素数を列挙すべきであることを意味します。

--- with_index{|prime, index| ... }      -> self
--- each_with_index{|prime, index| ... } -> self
--- with_index      -> Enumerator
--- each_with_index -> Enumerator

与えられたブロックに対して、素数を0起点の連番を渡して評価します。

@return ブロックを与えられた場合は self を返します。 ブロックを与えられなかった場合は Enumerator を返します。

例:
  Prime::EratosthenesGenerator.new(10).each_with_index do |prime, index|
    p [prime, index]
  end
  # [2, 0]
  # [3, 1]
  # [5, 2]
  # [7, 3]

@see [[m:Enumerator#with_index]]

--- with_object(obj){|prime, obj| ... } -> object
--- with_object(obj) -> Enumerator

与えられた任意のオブジェクトと要素をブロックに渡して評価します。

@param obj 任意のオブジェクトを指定します。
@return 最初に与えられたオブジェクトを返します。
@return ブロックを与えられた場合は obj を返します。ブロックを与えられなかった場合は Enumerator を返します。

@see [[m:Enumerator#with_object]]

= class Prime::EratosthenesGenerator < Prime::PseudoPrimeGenerator

[[c:Prime::PseudoPrimeGenerator]] の具象クラスです。
素数の生成にエラトステネスのふるいを使用しています。

== Instance Methods

--- next -> Integer
--- succ -> Integer

次の(疑似)素数を返します。なお、この実装においては疑似素数は真に素数です。

また内部的な列挙位置を進めます。

例:
 generator = Prime::EratosthenesGenerator.new
 p generator.next #=> 2
 p generator.next #=> 3
 p generator.succ #=> 5
 p generator.succ #=> 7
 p generator.next #=> 11

--- rewind -> nil

列挙状態を巻き戻します。

例:
 generator = Prime::EratosthenesGenerator.new
 p generator.next #=> 2
 p generator.next #=> 3
 p generator.next #=> 5

 generator.rewind

 p generator.next #=> 2


= class Prime::TrialDivisionGenerator < Prime::PseudoPrimeGenerator

[[c:Prime::PseudoPrimeGenerator]] の具象クラスです。
素数の生成に試行除算法を使用しています。

== Instance Methods

--- next -> Integer
--- succ -> Integer

次の(疑似)素数を返します。なお、この実装においては疑似素数は真に素数です。

また内部的な列挙位置を進めます。

--- rewind -> nil

列挙状態を巻き戻します。

= class Prime::Generator23 < Prime::PseudoPrimeGenerator

2と3と、3 より大きくて 2 でも 3 でも割り切れない全ての整数を生成します。

ある整数の素数性を疑似素数による試し割りでチェックする場合、このように低精度だが高速でメモリを消費しない疑似素数生成器が適しています。

一方、 [[m:Prime#each]] のように素数列を生成する目的にはまったく役に立ちません。

== Instance Methods

--- next -> Integer
--- succ -> Integer

次の疑似素数を返します。

また内部的な列挙位置を進めます。

--- rewind -> nil

列挙状態を巻き戻します。


#@# = class Prime::EratosthenesSieve < Object
#@# internal use

#@# = class Prime::TrialDivision < Object
#@# internal use


= module Prime::OldCompatibility

Ruby1.8 との互換性のためのモジュールです。 
[[c:Prime]] オブジェクトにRuby 1.8互換の機能を与えます。

[[m:Prime.new]] が返すインスタンスはこのモジュールで [[m:Object#extend]] されています。一方、 [[m:Prime.instance]] が返すインスタンスは extend されていません。

== Instance Methods

--- next -> Integer
--- succ -> Integer

[[m:Prime#next]] を再定義します。

次の素数を返します。

--- each{|prime| ... } -> object
--- each               -> object

[[m:Prime#each]] を再定義します。

全ての素数を列挙し、それぞれの素数をブロックに渡して評価します。
無限ループになるので必ず break を入れてください。

break 後に再度呼び出すと、最初からではなくインスタンス内部に保存されている中断位置から列挙を再開します。

@return ブロック付きで呼び出された場合は break の引数が返り値になります。
        ブロック無しで呼び出された場合は [[c:Prime::EratosthenesGenerator]] のインスタンスを返します。


= reopen Integer

== Class Methods

--- from_prime_division(pd) -> Integer

素因数分解された結果を元の数値に戻します。

@param pd 整数のペアの配列を指定します。含まれているペアの第一要素は素因数を、
          第二要素はその素因数の指数をあらわします。

@see [[m:Prime#int_from_prime_division]]

例:
  Prime.int_from_prime_division([[2,2], [3,1]])  #=> 12
  Prime.int_from_prime_division([[2,2], [3,2]])  #=> 36


--- each_prime(upper_bound){|prime| ... } -> object
--- each_prime(upper_bound) -> Enumerator

全ての素数を列挙し、それぞれの素数をブロックに渡して評価します。

@param upper_bound 任意の正の整数を指定します。列挙の上界です。
                   nil が与えられた場合は無限に列挙し続けます。
@return ブロックの最後に評価された値を返します。
        ブロックが与えられなかった場合は、[[c:Enumerator]] と互換性のある外部イテレータを返します。

@see [[m:Prime#each]]

== Instance Methods

--- prime_division(generator = Prime::Generator23.new) -> [[Integer, Integer]]

自身を素因数分解した結果を返します。

@param generator 素数生成器のインスタンスを指定します。

@return 素因数とその指数から成るペアを要素とする配列です。つまり、戻り値の各要素は2要素の配列 [n,e] であり、それぞれの内部配列の第1要素 n は self の素因数、第2要素は n**e が self を割り切る最大の自然数 e です。

@raise ZeroDivisionError self がゼロである場合に発生します。

@see [[m:Prime#prime_division]]

例:
    12.prime_division #=> [[2,2], [3,1]]
    10.prime_division #=> [[2,1], [5,1]]

--- prime? -> bool

自身が素数である場合、真を返します。
そうでない場合は偽を返します。

例:

  1.prime? # => false
  2.prime? # => true

@see [[m:Prime#prime?]]

#@end
