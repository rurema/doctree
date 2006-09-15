= module Comparable

比較演算を許すクラスのための Mix-in。このモジュールをインクルー
ドするクラスは、基本的な比較演算子である <=> 演算子を定義してい
る必要があります。他の比較演算子はその定義を利用して派生できます。

== Instance Methods

--- ==(other)

self と other が等しい時真を返します。

((<ruby 1.8 feature>)):
<=> が nil を返したとき nil を返します。

--- >(other)

self が other より大きい時真を返します。

#@if (version >= "1.8.0")
<=> が nil を返したとき例外[[c:ArgumentError]] が発生します。
#@end

--- >=(other)

self が other より大きいか等しい時真を返します。

((<ruby 1.8 feature>)):
<=> が nil を返したとき例外[[c:ArgumentError]] が発生します。

--- <(other)

self が other より小さい時真を返します。

#@if (version >= "1.8.0")
<=> が nil を返したとき例外[[c:ArgumentError]] が発生します。
#@end

--- <=(other)

self が other より小さいか等しい時真を返します。

#@if (version >= "1.8.0")
<=> が nil を返したとき例外[[c:ArgumentError]] が発生します。
#@end

--- between?(min, max)

self が min と max の範囲内(min, max
を含みます)にある時真を返します。

#@if (version >= "1.8.0")
self <=> min か、self <=> max が nil を返
したとき例外 [[c:ArgumentError]] が発生します。
#@end
