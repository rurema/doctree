[[c:DRb::DRbIdConv]] の拡張 [[c:DRb::TimerIdConv]] を定義
するライブラリ。
[[c:DRb::DRbIdConv]] の GC 問題をタイムアウトを定めることで
部分的に解決します。

= class DRb::TimerIdConv < DRb::DRbIdConv

オブジェクトと識別子を相互に変換するクラスです。
これによって識別子に変換されたオブジェクトは一定時間
GC から保護されます。

[[c:DRb::DRbIdConv]] では to_id で識別子に
変換し、リモートに送られたオブジェクトは GC から保護されません。
ローカルプロセスからの参照がなくなったオブジェクトは、
リモートからの参照が生きていたとしても GC によって廃棄される
可能性があります。
このクラスを DRb::DRbIdConv の代わりに用いることで、
to_id でオブジェクトを識別子に変換してから
一定時間([[m:DRb::TimerIdConv.new]] の timeout で指定した秒数)
の間はそのオブジェクトは GC されないことが保証されます。

このクラスを使う場合はどのタイミングでオブジェクトが
識別子に変換されるかを注意する必要があります。
基本的にはオブジェクトをリモートに送る直前に変換されます。

== Class Methods
--- new(timeout=600) -> DRb::TimerIdConv
TimerIdConv のインスタンスを生成して返します。

@param timeout to_id で識別子に変換してからオブジェクトがGCされないことが保証される秒数

== Instance Methods

--- to_id(obj) -> Integer

オブジェクトを識別子に変換します。

--- to_obj(ref) -> Object

識別子をオブジェクトに変換します。




