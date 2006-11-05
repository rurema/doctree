= module Precision

精度をもつ具象数値クラスのための Mix-in。 ここでいう精度とは実数の近似
の良さを意味します。抽象数値クラスや複素数、行列などそれら自身が実数に
含まれないような クラスにインクルードすべきではありません。

== Singleton Methods

#@since 1.7.0
--- included(module_or_class)

Precision がインクルードされた時に呼ばれます。詳細は
[[m:Module#included]] を参照してください。

このメソッドは、Precision をインクルードするクラスやモジュー
ルに対してメソッド induced_from を自動的に定義するためにあり
ます。
#@#    ((-ruby 1.6 以前は、これを
#@#    [[m:Module#append_feature]] を再定義すること
#@#    で実現していました-))
#@end

--- induced_from(number)

number を自分のクラスに変換した結果を返します。 デフォルトの
定義は、例外 [[c:TypeError]] を発生させるので、Mix-in したクラスで
このメソッドを再定義する必要があります。再定義に、
[[m:Precision#prec]] を使うと、 無限ループになる可
能性があります。

== Instance Methods

--- prec(klass)

self を精度 klass に変換した結果を返します。デフォルト
の定義では klass.induced_from(self) を呼び出し、その結
果を返します。

新しく精度クラスを作るときは組み込みクラスの
[[m:Precision#Precision.induced_from]] を変更するのではなく、この
prec の再定義で対応するべきです。

--- prec_i

self を [[c:Integer]] に変換します。prec(Integer) と等
価です。

--- prec_f

self を [[c:Float]] に変換します。prec(Float) と等価で
す。
