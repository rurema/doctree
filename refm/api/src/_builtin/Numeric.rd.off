= class Numeric < Object
include Comparable

Numeric は数値の抽象クラスです。Ruby では [[m:Numeric#coerce]]
メソッドを使うことによって異なる数値クラス間で演算を行うことができます。

演算や比較を行うメソッド(+, -, *, /, <=>)などはサブクラスで定義されま
す。また、効率のため Numeric のメソッドと同じメソッドがサブクラ
スで再定義されている場合があります。

数値関連クラスの定義メソッド

ほとんどの数値関連のメソッドはサブクラスで再定義されています。これは、
効率のためであったり上位抽象クラスで実装を定義することができなかったり
するためです。実際にどのメソッドがどのクラスに定義されているかは以下の
表を参照してください。

  cary = [Numeric, Integer, Fixnum, Bignum, Float]
  mary = cary.collect {|c| c.instance_methods(false)}
  methods = mary.flatten.uniq.sort
  
  methods.each_with_index {|op, i|
  if i % 10 == 0
    heading = sprintf("%12s   %10s %10s %10s %10s %10s",
                "", *cary.collect {|klass| klass.name.center(10)})
    puts heading
    puts "-" * heading.size
  end

  printf("%12s | %10s %10s %10s %10s %10s\n",
        op, *mary.collect {|ms| (ms.member?(op) ? "o" : "-").center(10)})
  }
  => ruby 1.6.8 (2002-12-24) [i586-linux]
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
                  % |     -          -          o          o          o
                  & |     -          -          o          o          -
                  * |     -          -          o          o          o
                 ** |     -          -          o          o          o
                  + |     -          -          o          o          o
                 +@ |     o          -          -          -          -
                  - |     -          -          o          o          o
                 -@ |     o          -          o          o          o
                  / |     -          -          o          o          o
                  < |     -          -          o          -          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
                 << |     -          -          o          o          -
                 <= |     -          -          o          -          o
                <=> |     o          -          o          o          o
                 == |     -          -          o          o          o
                === |     o          -          -          o          -
                  > |     -          -          o          -          o
                 >= |     -          -          o          -          o
                 >> |     -          -          o          o          -
                 [] |     -          -          o          o          -
                  ^ |     -          -          o          o          -
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
                abs |     o          -          o          o          o
               ceil |     o          o          -          -          o
                chr |     -          o          -          -          -
              clone |     o          -          -          -          -
             coerce |     o          -          -          o          o
                div |     -          -          -          o          -
             divmod |     o          -          o          o          o
             downto |     -          o          o          -          -
               eql? |     o          -          -          o          o
            finite? |     -          -          -          -          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
              floor |     o          o          -          -          o
               hash |     -          -          -          o          o
            id2name |     -          -          o          -          -
          infinite? |     -          -          -          -          o
           integer? |     o          o          -          -          -
             modulo |     o          -          o          o          o
               nan? |     -          -          -          -          o
               next |     -          o          o          -          -
           nonzero? |     o          -          -          -          -
          remainder |     o          -          -          o          -
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
              round |     o          o          -          -          o
               size |     -          -          o          o          -
               step |     -          o          o          -          -
               succ |     -          o          o          -          -
              times |     -          o          o          -          -
               to_f |     -          -          o          o          o
               to_i |     -          o          -          -          o
             to_int |     -          o          -          -          -
               to_s |     -          -          o          o          o
           truncate |     o          o          -          -          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
               type |     -          -          o          -          -
               upto |     -          o          o          -          -
              zero? |     o          -          o          o          o
                  | |     -          -          o          o          -
                  ~ |     -          -          o          o          -
  => ruby 1.8.0 (2003-08-04) [i586-linux]
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
                  % |     -          -          o          o          o
                  & |     -          -          o          o          -
                  * |     -          -          o          o          o
                 ** |     -          -          o          o          o
                  + |     -          -          o          o          o
                 +@ |     o          -          -          -          -
                  - |     -          -          o          o          o
                 -@ |     o          -          o          o          o
                  / |     -          -          o          o          o
                  < |     -          -          o          -          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
                 << |     -          -          o          o          -
                 <= |     -          -          o          -          o
                <=> |     o          -          o          o          o
                 == |     -          -          o          o          o
                  > |     -          -          o          -          o
                 >= |     -          -          o          -          o
                 >> |     -          -          o          o          -
                 [] |     -          -          o          o          -
                  ^ |     -          -          o          o          -
                abs |     o          -          o          o          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
               ceil |     o          o          -          -          o
                chr |     -          o          -          -          -
             coerce |     o          -          -          o          o
                div |     o          -          o          o          -
             divmod |     o          -          o          o          o
             downto |     -          o          -          -          -
               eql? |     o          -          -          o          o
            finite? |     -          -          -          -          o
              floor |     o          o          -          -          o
               hash |     -          -          -          o          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
            id2name |     -          -          o          -          -
          infinite? |     -          -          -          -          o
           integer? |     o          o          -          -          -
             modulo |     o          -          o          o          o
               nan? |     -          -          -          -          o
               next |     -          o          -          -          -
           nonzero? |     o          -          -          -          -
                quo |     o          -          o          o          -
          remainder |     o          -          -          o          -
              round |     o          o          -          -          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
               size |     -          -          o          o          -
               step |     o          -          -          -          -
               succ |     -          o          -          -          -
              times |     -          o          -          -          -
               to_f |     -          -          o          o          o
               to_i |     -          o          -          -          o
             to_int |     o          o          -          -          o
               to_s |     -          -          o          o          o
             to_sym |     -          -          o          -          -
           truncate |     o          o          -          -          o
                       Numeric    Integer     Fixnum     Bignum     Float
       ---------------------------------------------------------------------
               upto |     -          o          -          -          -
              zero? |     o          -          o          -          o
                  | |     -          -          o          o          -
                  ~ |     -          -          o          o          -

== Instance Methods

--- +@

self 自身を返します。

--- -@

self の符号を反転させたものを返します。

このメソッドは、二項演算子 - で 0 - self によって定義
されています。

--- ==(other)

self と other の値が等しいときに true、等しくないときに false を返します。
other が Numeric で比較できないオブジェクトの場合、
結合法則が成り立つことを仮定して other == self の結果を返します。

--- abs

self の絶対値を返します。

--- ceil
--- floor
--- round
--- truncate

self を整数に丸めた結果を返します。

整数に丸めるメソッドの例:

#@#         numbers=[1.9, 1.1, -1.1, -1.9]
#@#         methods=%w(ceil floor round truncate)
#@#
#@#         fmt = "%5s |" + " %10s" * methods.size + "\n"
#@#
#@#         heading = sprintf(fmt, "", *methods)
#@#         puts heading
#@#         puts "-" * heading.size
#@#
#@#         numbers.each {|n|
#@#           printf(fmt, n,
#@#                  *methods.collect {|m| sprintf("%s", n.send(m))})
#@#         }

        _
              |       ceil      floor      round   truncate
        ----------------------------------------------------
          1.9 |          2          1          2          1
          1.1 |          2          1          1          1
         -1.1 |         -1         -2         -1         -1
         -1.9 |         -1         -2         -2         -1

    * ceil は大きい方の整数へ丸めます(天井)。
    * floor は小さい方の整数に丸めます(床)。
    * round は 近い方の整数に丸めます。中央値 0.5, -0.5 は切上げ(1,
      -1)されます。いわゆる四捨五入ですが、偶数丸めではありません。
    * truncate(そして、[[m:Float#to_i]]) は 0 に近い方の整数に丸めます(切捨て)。
    * 0 から遠い方に丸める(切上げ)メソッドはありません。

切上げはceil, floor を使用して以下のように定義できます。

  if n > 0 then
    n.ceil
  else
    n.floor
  end

また、任意桁の切上げ、切捨て、四捨五入を行うメソッドは以下のように
定義できます。

  class Numeric
    def roundup(d=0)
      x = 10**d
      if self > 0
        (self * x).ceil.quo(x)
      else
        (self * x).floor.quo(x)
      end
    end

    def rounddown(d=0)
      x = 10**d
      if self < 0
        (self * x).ceil.quo(x)
      else
        (self * x).floor.quo(x)
      end
    end

    def roundoff(d=0)
      x = 10**d
      if self < 0
        (self * x - 0.5).ceil.quo(x)
      else
        (self * x + 0.5).floor.quo(x)
      end
    end
  end

#@#        numbers=[0.19, 0.15, 0.11, -0.11, -0.15, -0.19]
#@#        methods=%w(roundup rounddown roundoff)
#@#        arg=1
#@#
#@#        fmt = "%5s |" + " %10s" * methods.size + "\n"
#@#
#@#        heading = sprintf(fmt, "", *methods)
#@#        puts heading
#@#        puts "-" * heading.size
#@#
#@#        numbers.each {|n|
#@#          printf(fmt, n,
#@#                 *methods.collect {|m| sprintf("%s", n.send(m, arg))})
#@#        }
#@#              |    roundup  rounddown   roundoff
#@#        -----------------------------------------
#@#         0.19 |        0.2        0.1        0.2
#@#         0.15 |        0.2        0.1        0.2
#@#         0.11 |        0.2        0.1        0.1
#@#        -0.11 |       -0.2       -0.1       -0.1
#@#        -0.15 |       -0.2       -0.1       -0.2
#@#        -0.19 |       -0.2       -0.1       -0.2

--- clone
--- dup

self を返します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): version 1.7 では数値などの immutable なオ
ブジェクトは clone や dup が禁止されています。

  1.dup   # => in `clone': can't clone Fixnum (TypeError)
#@end

--- coerce(number)

number の型を自分と直接演算できる型に変換して
[number, self] という配列に格納して返します。数値クラ
スの算術演算子は通常自分と演算できないクラスをオペランドとして受け
取ると coerce を使って自分とオペランドを変換した上で演算を行
います。

--- div(other)
--- quo(other)

self を other で割った商を返します。
#@#((-2005-11-24 [[unknown:ruby-dev:27674]]: 1.8 にはバグがあり、self/other
#@#の結果が負のFloatになる場合に結果が異なります。p -3.0.div(2) # => -1
#@#(正しくは-2)-))

  * div は self のクラスにかかわらず整数([[c:Integer]])の商を返します。
  * quo は self のクラスにかかわらず実数([[c:Float]]や[[c:Rational]])
    の商を返します。

div の商に対応する余りは [[m:Numeric#modulo]] で求められます。

  div の例:
  p 3.div(2) # => 1
  p -3.div(2) # => -2
  p -3.0.div(2) # => -2

  quo の例:
  p 1.quo(3)      # => 0.3333333333333333
  
  require 'rational'
  p 1.quo(3)      # => Rational(1, 3)

各メソッドの比較:

#@#        numbers=[[13,4], [13,-4], [-13,4],[-13,-4],[-13,-13],
#@#                 [11.5,4], [11.5,-4], [-11.5,4], [-11.5,-4]]
#@#        methods=%w(divmod / div quo)
#@#
#@#        fmt = "%12s |" + " %12s" * methods.size + "\n"
#@#
#@#        heading = sprintf(fmt, "[a,b]", *methods)
#@#        puts heading
#@#        puts "-" * heading.size
#@#
#@#        numbers.each {|a,b|
#@#          printf(fmt, [a,b].inspect,
#@#                 *methods.collect {|m| a.send(m, b).inspect})
#@#        }
        _
               [a,b] |       divmod            /          div          quo
        -------------------------------------------------------------------
             [13, 4] |       [3, 1]            3            3         3.25
            [13, -4] |     [-4, -3]           -4           -4        -3.25
            [-13, 4] |      [-4, 3]           -4           -4        -3.25
           [-13, -4] |      [3, -1]            3            3         3.25
          [-13, -13] |       [1, 0]            1            1          1.0
           [11.5, 4] |   [2.0, 3.5]        2.875            2        2.875
          [11.5, -4] | [-3.0, -0.5]       -2.875           -3       -2.875
          [-11.5, 4] |  [-3.0, 0.5]       -2.875           -3       -2.875
         [-11.5, -4] |  [2.0, -3.5]        2.875            2        2.875

--- divmod(other)

self を other で割った商 (q) と余り (r) を、
[q, r] という 2 要素の配列にして返します。

ここで、a を b で割った商 q と余り r とい
うのは、それぞれ

   a = b * q + r  かつ  |r| < |b|

    other > 0 のとき:  0     <= r < other
    other < 0 のとき:  other <  r <= 0

をみたす ((*整数*)) q と 数 r のことです。

divmod が返す商は [[m:Numeric#div]] と同じです。
また余りは、[[m:Numeric#modulo]] (つまり、%)と同じです。

このメソッドは、メソッド / と % によって定義されています。

    numbers=[[13,4], [13,-4], [-13,4],[-13,-4],[-13,-13],
             [11.5,4], [11.5,-4], [-11.5,4], [-11.5,-4]]
    methods=%w(divmod / div quo % modulo remainder)

    fmt = "%12s |" + " %12s" * methods.size + "\n"

    heading = sprintf(fmt, "[a,b]", *methods)
    puts heading
    puts "-" * heading.size

    numbers.each {|a,b|
      printf(fmt, [a,b].inspect,
             *methods.collect {|m| a.send(m, b).inspect})
    }

               [a,b] |       divmod            /          div          quo            %       modulo    remainder
        ----------------------------------------------------------------------------------------------------------
             [13, 4] |       [3, 1]            3            3         3.25            1            1            1
            [13, -4] |     [-4, -3]           -4           -4        -3.25           -3           -3            1
            [-13, 4] |      [-4, 3]           -4           -4        -3.25            3            3           -1
           [-13, -4] |      [3, -1]            3            3         3.25           -1           -1           -1
          [-13, -13] |       [1, 0]            1            1          1.0            0            0            0
           [11.5, 4] |     [2, 3.5]        2.875            2        2.875          3.5          3.5          3.5
          [11.5, -4] |   [-3, -0.5]       -2.875           -3       -2.875         -0.5         -0.5          3.5
          [-11.5, 4] |    [-3, 0.5]       -2.875           -3       -2.875          0.5          0.5         -3.5
         [-11.5, -4] |    [2, -3.5]        2.875            2        2.875         -3.5         -3.5         -3.5

--- integer?

self が整数の時、真を返します。

--- modulo(other)
--- remainder(other)

self を other で割った余り r を返します([[m:Numeric#divmod]] も参照)。

modulo では、r の符号は other と同じ(またはゼロ)になります。
一方、remainder は、r の符号は self と同じ(またはゼロ)になります。

つまり、modulo では、
    * other > 0 のとき  0 <= r < other
    * other < 0 のとき other < r <= 0
    となり、
    remainder では、
    * self > 0 のとき  0 <= r < |other|
    * self < 0 のとき -|other| < r <= 0
となります。

modulo は、メソッド % の呼び出しとして定義されています。
(つまり、% と同じです)

  p (13.modulo(4))      #=>  1
  p (13.modulo(-4))     #=> -3
  p ((-13).modulo(4))   #=>  3
  p ((-13).modulo(-4))  #=> -1

  p (13.remainder(4))      #=>  1
  p (13.remainder(-4))     #=>  1
  p ((-13).remainder(4))   #=> -1
  p ((-13).remainder(-4))  #=> -1

余りの求めかたにはこの通り二つのメソッドがありますが、
違いは、self または other が負のときの結果です。

こだわりがなければ modulo (あるいは %)を使えばよいでしょう。
この余りに対応する商は、[[m:Numeric#div]] (あるいは Integer#/)
で求められます。

一方、remainder に対応する商を直接返すメソッドはありません
(self.quo(other).truncate が対応します)。

各メソッドの比較:

#@#        numbers=[[13,4], [13,-4], [-13,4],[-13,-4],[-13,-13],
#@#                 [11.5,4], [11.5,-4], [-11.5,4], [-11.5,-4]]
#@#        methods=%w(divmod % modulo remainder)
#@#
#@#        fmt = "%12s |" + " %12s" * methods.size + "\n"
#@#
#@#        heading = sprintf(fmt, "[a,b]", *methods)
#@#        puts heading
#@#        puts "-" * heading.size
#@#
#@#        numbers.each {|a,b|
#@#          printf(fmt, [a,b].inspect,
#@#                 *methods.collect {|m| a.send(m, b).inspect})
#@#        }
        _
               [a,b] |       divmod            %       modulo    remainder
        -------------------------------------------------------------------
             [13, 4] |       [3, 1]            1            1            1
            [13, -4] |     [-4, -3]           -3           -3            1
            [-13, 4] |      [-4, 3]            3            3           -1
           [-13, -4] |      [3, -1]           -1           -1           -1
          [-13, -13] |       [1, 0]            0            0            0
           [11.5, 4] |   [2.0, 3.5]          3.5          3.5          3.5
          [11.5, -4] | [-3.0, -0.5]         -0.5         -0.5          3.5
          [-11.5, 4] |  [-3.0, 0.5]          0.5          0.5         -3.5
         [-11.5, -4] |  [2.0, -3.5]         -3.5         -3.5         -3.5

--- nonzero?

ゼロの時nilを返し、非ゼロの時 self を返します。

--- to_int

self.to_i と同じです。

--- zero?

ゼロの時、真を返します。

--- step(limit) {|n| ... }
--- step(limit, step) {|n| ... }

self からはじめ step を足しながら limit を越える
前までブロックを繰り返します。step は負の数も指定できます(省
略時は 1)。また、limit や step には [[c:Float]] なども
指定できます。

step に 0 を指定した場合は例外 [[c:ArgumentError]] が発生します。

self を返します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): このメソッドは、[[c:Fixnum]], [[c:Integer]] から移動しまし
た。これにより [[c:Float]] も step できるようになりました。

    1.1.step(1.5, 0.1) {|n| p n}
    => 1.1
       1.2
       1.3
       1.4
       1.5

注：浮動小数点数の 0.1 は 2進数では正確な表現ができない(2進数で
0.1は 0.00011001100....となる)ので、以下のようなループでは誤差が
生じて意図した回数ループしないことがある。step はこの誤差を考慮し
て実装されている。

    i = 1.1
    while i <= 1.5
      p i
      i += 0.1
    end
    => 1.1
       1.2
       1.3
       1.4   <- 1.5 が表示されない
#@end

