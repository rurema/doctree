= class Integer < Numeric
include Precision

整数の抽象クラス。サブクラスとして [[c:Fixnum]] と [[c:Bignum]] があり
ます。この 2 種類の整数は値の大きさに応じてお互いに自動的に変換されま
す。ビット操作において整数は無限の長さのビットストリングとみなすことが
できます。

== Class Methods

--- induced_from(num)

num を Integer に変換した結果を返します。

== Instance Methods

--- [](nth)

nth 番目のビット(最下位ビット(LSB)が 0 番目)が立っている時 1
を、そうでなければ 0 を返します。

self[nth]=bit が Integer にないのは、Numeric 関連クラスが
immutable であるためです。

--- +(other)
--- -(other)
--- *(other)
--- /(other)
--- %(other)
--- **(other)

算術演算子。それぞれ和、差、積、商、剰余、冪を計算します。

--- <=>(other)

self と other を比較して、self が大きい時に正、
等しい時に 0、小さい時に負の整数を返します。

--- ==(other)
--- <(other)
--- <=(other)
--- >(other)
--- >=(other)

比較演算子。

--- ~
--- |(other)
--- &(other)
--- ^(other)

ビット演算子。それぞれ否定、論理和、論理積、排他的論理和を計算しま
す。

--- <<(bits)
--- >>(bits)

シフト演算子。bits だけビットを右(左)にシフトします。

右シフトは、符号ビット(最上位ビット(MSB))が保持されます。

    printf("%#b\n", 0b0101 << 1)
    printf("%#b\n", 0b0101 >> 1)
    
    => 0b1010
       0b10
    
    p -1 >> 1
    
    => -1

--- chr

文字コードに対応する 1 バイトの文字列を返します。例えば
65.chr は "A" を返します。

逆に文字列から文字コードを得るには "A"[0] とします
([[m:String#[]]] を参照してください)。

整数は 0 から 255 の範囲内でなければなりません。範囲外の整数に対す
る呼び出しは例外 [[c:RangeError]] を発生させます。

--- downto(min) {|n| ... }

self から min まで 1 ずつ減らしながら繰り返します。
self < min であれば何もしません。

[[m:Integer#upto]], [[m:Integer#step]], [[m:Integer#times]] も参照。

--- next
--- succ

次の整数を返します。

--- step(limit, step) {|n| ... }

self からはじめ step を足しながら limit を越える
前までブロックを繰り返します。step は負の数も指定できます。
また、limit や step には [[c:Float]] なども指定できます。

step に 0 を指定した場合は例外 [[c:ArgumentError]] が発生します。

self を返します。

[[m:Integer#upto]], [[m:Integer#downto]], [[m:Integer#times]] も参照。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): Numeric#[[m:Numeric#step]] も参照。
#@end

--- times {|n| ... }

self 回だけ(0 から self-1 まで)繰り返します。
self が負であれば何もしません。

self を返します。

[[m:Integer#upto]], [[m:Integer#downto]], [[m:Integer#step]] も参照。

--- to_i
--- to_int

self を返します。

--- size

整数の実装上のサイズをバイト数で返します。

現在の実装では [[c:Fixnum]] は、sizeof(long) 固定(多くの 32
bit マシンで 4 バイト)、[[c:Bignum]]は、システム依存です。

    p 1.size
    p 0x1_0000_0000.size
    # => 4
         8

--- to_f

値を浮動小数点数([[c:Float]])に変換します。

--- to_s
#@if (version >= "1.7.0")
--- to_s(base)
#@end

整数を 10 進文字列表現に変換します。

#@if (version >= "1.7.0")
((<ruby 1.7 feature>)): 引数を指定すれば、それを基数とした文字列表
現に変換します。基数として 2 〜 36 以外を指定した場合は例外
[[c:ArgumentError]] が発生します。

    p 10.to_s(2)    # => "1010"
    p 10.to_s(8)    # => "12"
    p 10.to_s(16)   # => "a"
    p 35.to_s(36)   # => "z"
#@end

--- upto(max) {|n| ... }

self から max まで 1 ずつ増やしながら繰り返します。
self > max であれば何もしません。

self を返します。

[[m:Integer#downto]], [[m:Integer#step]], [[m:Integer#times]] も参照。
