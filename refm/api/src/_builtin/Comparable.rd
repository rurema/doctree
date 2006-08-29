= Comparable

比較演算を許すクラスのための (({Mix-in}))。このモジュールをインクルー
ドするクラスは、基本的な比較演算子である (({<=>})) 演算子を定義してい
る必要があります。他の比較演算子はその定義を利用して派生できます。

== メソッド:

--- self == other

    (({self})) と ((|other|)) が等しい時真を返します。

    ((<ruby 1.8 feature>)):
    <=> が nil を返したとき nil を返します。

--- self > other

    (({self})) が ((|other|)) より大きい時真を返します。

    ((<ruby 1.8 feature>)):
    <=> が nil を返したとき例外((<ArgumentError>)) が発生します。

--- self >= other

    (({self})) が ((|other|)) より大きいか等しい時真を返します。

    ((<ruby 1.8 feature>)):
    <=> が nil を返したとき例外((<ArgumentError>)) が発生します。

--- self < other

    (({self})) が ((|other|)) より小さい時真を返します。

    ((<ruby 1.8 feature>)):
    <=> が nil を返したとき例外((<ArgumentError>)) が発生します。

--- self <= other

    (({self})) が ((|other|)) より小さいか等しい時真を返します。

    ((<ruby 1.8 feature>)):
    <=> が nil を返したとき例外((<ArgumentError>)) が発生します。

--- between?(min, max)

    (({self})) が ((|min|)) と ((|max|)) の範囲内(((|min|)), ((|max|)) 
    を含みます)にある時真を返します。

    ((<ruby 1.8 feature>)):
    (({self})) <=> ((|min|)) か、(({self})) <=> (({max})) が nil を返
    したとき例外 ((<ArgumentError>)) が発生します。
