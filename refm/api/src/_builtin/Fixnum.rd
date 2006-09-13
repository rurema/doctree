= class Fixnum < Integer

マシンのポインタのサイズに収まる長さの固定長整数。ほとんどのマシンでは
31 ビット幅です。演算の結果が Fixnum の範囲を越えた時には自動的
に [[c:Bignum]] に拡張されます。

== Instance Methods

--- id2name

[[c:Symbol]] オブジェクトの整数値 ([[m:Symbol#to_i]]
で得られます)に対応する文字列を返します。整数に対応するシンボルが
存在しない時には nil を返します。

--- to_sym

#@if (version >= "1.7.0")
オブジェクトの整数値 self に対応する [[c:Symbol]] オブジェク
トを返します。整数に対応するシンボルが存在しない時には nil
を返します。
#@end
