category Math

#@# :author: 小林茂雄
bigdecimal は浮動小数点数演算ライブラリです。
任意の精度で 10 進表現された浮動小数点数を扱えます。

例:

  require 'bigdecimal'
  a = BigDecimal::new("0.123456789123456789")
  b = BigDecimal("123456.78912345678", 40)
  print a + b # => 0.123456912580245903456789E6

一般的な 10 進数の計算でも有用です。2 進数の浮動小数点演算には微小な誤
差があるのに対し、[[c:BigDecimal]] では正確な値を得る事ができます。

例1: 0.0001 を 10000 回足す場合。

  sum = 0
  for i in (1..10000)
    sum = sum + 0.0001
  end
  print sum # => 0.9999999999999062

例2: 0.0001 を 10000 回足す場合。(BigDecimal)

  require 'bigdecimal'

  sum = BigDecimal.new("0")
  for i in (1..10000)
    sum = sum + BigDecimal.new("0.0001")
  end
  print sum # => 0.1E1

例3: 1.2 - 1.0 と 0.2 との比較

  (BigDecimal.new("1.2") - BigDecimal("1.0")) == BigDecimal("0.2") # => true

  (1.2 - 1.0) == 0.2 # => false

=== 特別な値

正確な計算結果の提供のために、[[c:BigDecimal]] はいくつかの特別な値を持
ちます。

==== 無限大

[[c:BigDecimal]] による演算の際には無限大を表す値を返す場合があります。

例:

  BigDecimal("1.0") / BigDecimal("0.0")  #=> infinity
  BigDecimal("-1.0") / BigDecimal("0.0")  #=> -infinity

無限大を表す [[c:BigDecimal]] オブジェクトを作成する場合、
[[m:Kernel.#BigDecimal]] の引数に "Infinity" や "-Infinity" を指定して
ください。(大文字小文字を区別します)

  BigDecimal("Infinity")  # => #<BigDecimal:f74a2ebc,'Infinity',4(4)>
  BigDecimal("+Infinity") # => #<BigDecimal:f74a2e6c,'Infinity',4(4)>
  BigDecimal("-Infinity") # => #<BigDecimal:f74a2e1c,'-Infinity',4(4)>

  BigDecimal("infinity")  # => #<BigDecimal:f74a2dcc,'0.0',4(4)>
  BigDecimal("-infinity") # => #<BigDecimal:f74a2d7c,'-0.0',4(4)>

==== 非数(Not a Number)

0 / 0 のような未定義の計算を行った場合、非数(Not a Number)を表す値を返
します。

例:

  BigDecimal("0.0") / BigDecimal("0.0") # => #<BigDecimal:f74490d8,'NaN',4(24)>

NaN を表す [[c:BigDecimal]] オブジェクトを作成する場合、
[[m:Kernel.#BigDecimal]] の引数に "NaN" を指定してください。(大文字小文
字を区別します)

  BigDecimal("NaN")  # => #<BigDecimal:a0e49e4,'NaN',4(4)>

NaN はどのような値と比較しても一致しません。(NaN 自身を含みます)

  BigDecimal("NaN") == 0.0               # => false
  BigDecimal("NaN") == BigDecimal("NaN") # => false

==== +ゼロと-ゼロ

計算結果が現在の有効桁数に比べて小さい値である場合、0 を返します。

負の非常に小さな [[c:BigDecimal]] の値は -0 を表す値になります。

  BigDecimal.new("1.0") / BigDecimal.new("-Infinity") # => #<BigDecimal:f74a9f64,'-0.0',4(20)>

正の非常に小さな [[c:BigDecimal]] の値は 0 を表す値になります。

  BigDecimal.new("1.0") / BigDecimal.new("Infinity") # => #<BigDecimal:f74a9e88,'0.0',4(20)>

精度については [[m:BigDecimal.mode]] も併せて参照してください。

また、0.0 と -0.0 は比較した場合に同じ値であるとみなされます。

  BigDecimal("0.0") == BigDecimal("-0.0") # => true

これは数学的には特に意味がない事に注意してください。数学的な 0 は符号を持ちません。

=== 他の数値オブジェクトとの変換 (coerce)

BigDecimal オブジェクトが算術演算子の左にあるときは、
BigDecimal オブジェクトが右にあるオブジェクトを
(必要なら) BigDecimal に変換してから計算します。
従って、BigDecimal オブジェクト以外でも数値を意味するものなら
右に置けば演算は可能です。

ただし、文字列は (通常) 数値に自動変換することはできません。
文字列を数値に自動変換したい場合は bigdecimal.c の
「/* #define ENABLE_NUMERIC_STRING */」のコメントを外してから、
再コンパイル、再インストールする必要があります。
文字列で数値を与える場合は注意が必要です。
数値に変換できない文字があると、
単に変換を止めるだけでエラーにはなりません。
"10XX"なら 10、"XXXX"は 0 と扱われます。

  require "bigdecimal"
  require "bigdecimal/math"

  a = BigMath.E(20)
  c = a * "0.123456789123456789123456789"   # 文字を BigDecimal に変換してから計算

無限大や非数を表す文字として、
"Infinity"、"+Infinity"、"-Infinity"、"NaN" も使用できます
(大文字・小文字を区別します)。
ただし、mode メソッドで false を指定した場合は例外が発生します。
また、BigDecimalクラスは coerce(Ruby本参照)をサポートしています。
従って、BigDecimal オブジェクトが右にある場合も大抵は大丈夫です。
ただ、現在の Ruby インタプリタの仕様上、文字列が左にあると計算できません。

  a = BigMath.E(20)
  c = "0.123456789123456789123456789" * a   # エラー

必要性があるとは思いませんが、
どうしてもと言う人は String オブジェクトを継承した新たなクラスを作成してから、
そのクラスで coerce をサポートしてください。

===[a:internal_structure] 内部構造

BigDecimal内部で浮動小数点は構造体(Real)で表現されます。
そのうち仮数部は unsigned long の配列 (以下の構造体要素 frac) で管理されます。
概念的には、以下のようになります。

  <浮動小数点数> = 0.xxxxxxxxx * BASE ** n

ここで、x は仮数部を表す数字、BASE は基数 (10 進表現なら 10)、
n は指数部を表す整数値です。BASEが大きいほど、大きな数値が表現できます。
つまり、配列のサイズを少なくできます。
BASE は大きいほど都合がよいわけですが、デバッグのやりやすさなどを考慮して、
10000になっています (BASE は VpInit() 関数で自動的に計算します)。
これは 32 ビット整数の場合です。64ビット整数の場合はもっと大きな値になります。
残念ながら、64 ビット整数でのテストはまだやっていません。
もし、テストをした方がいれば結果を教えてください。
BASE が 10000 のときは、以下の仮数部の配列 (frac) の各要素には最大で 4 桁の数字が格納されます。

浮動小数点構造体 (Real) は以下のようになっています。

  typedef struct {
     unsigned long MaxPrec; // 最大精度(frac[]の配列サイズ)
     unsigned long Prec;    // 精度(frac[]の使用サイズ)
     short    sign;         // 以下のように符号等の状態を定義します。
                            //  ==0 : NaN
                            //    1 : +0
                            //   -1 : -0
                            //    2 : 正の値
                            //   -2 : 負の値
                            //    3 : +Infinity
                            //   -3 : -Infinity
     unsigned short flag;   // 各種の制御フラッグ
     int      exponent;     // 指数部の値(仮数部*BASE**exponent)
     unsigned long frac[1]; // 仮数部の配列(可変)
  } Real;

例えば BASE=10000 のとき 1234.56784321 という数字は、

    0.1234 5678 4321*(10000)**1

ですから frac[0] = 1234、frac[1] = 5678、frac[2] = 4321、
Prec = 3、sign = 2、exponent = 1 となります。
MaxPrec は Prec より大きければいくつでもかまいません。
flag の使用方法は実装に依存して内部で使用されます。

=== 2 進と 10 進

BigDecimal は <浮動小数点数> = 0.xxxxxxxxx*10**n という 10 進形式で数値を保持します。
しかし、計算機の浮動小数点数の内部表現は、
言うまでもなく <浮動小数点数> = 0.bbbbbbbb*2**n という 2 進形式が普通です
(x は 0 から 9 まで、b は 0 か 1 の数字)。
BigDecimal がなぜ 10 進の内部表現形式を採用したのかを以下に説明します。

=== 10 進のメリット

==== デバッグのしやすさ

まず、プログラム作成が楽です。
frac[0]=1234、frac[1]=5678、frac[2]=4321、 exponent=1、sign=2
なら数値が 1234.56784321 であるのは見ればすぐに分かります。 

==== 10進表記された数値なら確実に内部表現に変換できる

例えば、以下のようなプログラムは全く誤差無しで計算することができます。
以下の例は、一行に一つの数値が書いてあるファイル file の合計数値を求めるものです。

   file = File::open(....,"r")
   s = BigDecimal::new("0")
   while line = file.gets
      s = s + line
   end

この例を 2 進数で計算すると誤差が入る可能性があります。
例えば 0.1 を2進で表現すると
0.1 = b1*2**(-1)+b1*2**(-2)+b3*2**(-3)+b4*2**(-4) ……
と無限に続いてしまいます (b1=0,b2=0,b3=0,b4=1...)。
ここで bn(n=1,2,3,...) は 2進を表現する 0 か 1 の数字列です。
従って、どこかで打ち切る必要があります。ここで変換誤差が入ります。
もちろん、これを再度 10 進表記にして印刷するような場合は
適切な丸め操作(四捨五入)によって再び "0.1" と表示されます。
しかし、内部では正確な 0.1 ではありません。 

==== 有効桁数は有限である (つまり自動決定できる)

0.1 を表現するための領域はたった一つの配列要素 (frac[0] = 1) で済みます。
配列要素の数は10進数値から自動的に決定できます。
これは、可変長浮動小数点演算では大事なことです。
逆に 0.1 を 2 進表現したときに 2 進の有効桁をいくつにするのかは、
0.1 という数値だけからは決定できません。 

=== 10 進のデメリット

実は今までのメリットは、そのままデメリットにもなります。
そもそも、10 進を 2 進に変換するような操作は
変換誤差を伴う場合を回避することはできません。
大概のコンピュータは 10 進の内部表現を持っていないので、
BigDecimal を利用して誤差無しの計算をする場合は、
計算速度を無視しても最後まで BigDecimal を使用し続ける必要があります。

==== 最初は何か？

自分で計算するときにわざわざ 2 進数を使う人は極めてまれです。
計算機にデータを入力するときもほとんどの場合、 10進数で入力します。
その結果、double 等の計算機内部表現は最初から誤差が入っている場合があります。
BigDecimal はユーザ入力を誤差無しで取り込むことができます。
デバッグのしやすさと、データ読みこみ時に誤差が入らないという 2 点が実際のメリットです。

====[a:precision] 計算精度について

「有効桁数」とは BigDecimal が精度を保証する桁数です。ぴったりではありません、
若干の余裕を持って計算されます。また、例えば32ビットのシステムでは10進で4桁毎に計算します。
従って、現状では、内部の「有効桁数」は4の倍数となっています。

c = a op b という計算 (op は + - * /) をしたときの動作は以下のようになります。

  (1) 乗算は (a の有効桁数) + (b の有効桁数)、
      除算は (a の最大有効桁数) + (b の最大有効桁数) 分の最大桁数
      (実際は、余裕を持って、もう少し大きくなります) を持つ変数 c を新たに生成します。
      加減算の場合は、誤差が出ないだけの精度を持つ c を生成します。
      例えば c = 0.1+0.1*10**(-100) のような場合、c の精度は100桁以上の精度を持つようになります。
  (2) 次に c = a op b の計算を実行します。

このように、加減算と乗算での c は必ず「誤差が出ない」だけの精度を持って生成されます
(BigDecimal.limit を指定しない場合)。
除算は (a の最大有効桁数) + (b の最大有効桁数) 分の最大桁数を持つ c が生成されますが、
c = 1.0/3.0 のような計算で明らかなように、
c の最大精度を超えるところで計算が打ち切られる場合があります。

いずれにせよ、c の最大精度は a や b より大きくなりますので
c が必要とするメモリー領域は大きくなることに注意して下さい。

注意：「+, -, *, /」では結果の精度(有効桁数)を自分で指定できません。
精度をコントロールしたい場合は、以下のインスタンスメソッドを使用します。

: add, sub, mult, div

  これらのメソッドは先頭 (最左) の数字からの桁数を指定できます。

    BigDecimal("2").div(3,12) # 2.0/3.0 => 0.6666666666 67E0

: truncate, round, ceil, floor

  これらのメソッドは小数点からの相対位置を指定して桁数を決定します。

    BigDecimal("6.66666666666666").round(12) # => 0.6666666666 667E1

==== 自分で精度をコントロールしたい場合

自分で精度(有効桁数)をコントロールしたい場合は add、sub、mult、div 等のメソッドが使用できます。以下の円周率を計算するプログラム例のように、求める桁数は自分で指定することができます。

  #!/usr/local/bin/ruby
  
  require "bigdecimal"
  #
  # Calculates 3.1415.... (the number of times that a circle's diameter
  # will fit around the circle) using J. Machin's formula.
  #
  def big_pi(sig) # sig: Number of significant figures
    exp    = -sig
    pi     = BigDecimal::new("0")
    two    = BigDecimal::new("2")
    m25    = BigDecimal::new("-0.04")
    m57121 = BigDecimal::new("-57121")
  
    u = BigDecimal::new("1")
    k = BigDecimal::new("1")
    w = BigDecimal::new("1")
    t = BigDecimal::new("-80")
    while (u.nonzero? && u.exponent >= exp) 
      t   = t*m25
      u   = t.div(k,sig)
      pi  = pi + u
      k   = k+two
    end
  
    u = BigDecimal::new("1")
    k = BigDecimal::new("1")
    w = BigDecimal::new("1")
    t = BigDecimal::new("956")
    while (u.nonzero? && u.exponent >= exp )
      t   = t.div(m57121,sig)
      u   = t.div(k,sig)
      pi  = pi + u
      k   = k+two
    end
    pi
  end
  
  if $0 == __FILE__
    if ARGV.size == 1
      print "PI("+ARGV[0]+"):\n"
      p big_pi(ARGV[0].to_i)
    else
      print "TRY: ruby pi.rb 1000 \n"
    end
  end

=== その他

以下のメソッド以外にも、(C ではない) Ruby ソースの形で提供されているものもあります。例えば、

  require "bigdecimal/math.rb"

とすることで、sin や cos といった関数が使用できるようになります。
使用方法など、詳細は [[lib:bigdecimal/math]] を参照して下さい。 その他、Float との相互変換などの
メソッドが [[lib:bigdecimal/util]] でサポートされています。利用するには

  require "bigdecimal/util.rb"

のようにします。詳細は [[lib:bigdecimal/util]] を参照して下さい。

#@include(bigdecimal/BigDecimal)
#@since 1.9.3
#@include(bigdecimal/BigMath)
#@end
