category GC

weak reference を実現します。

= class WeakRef < Delegator

weak reference を実現するクラスです。

[[c:WeakRef]] オブジェクトは与えられたオブジェクトをポイントしますが、
ポイント先のオブジェクトは GC される可能性があります。
アクセスしようとしたときにオブジェクトが GC されていれば
[[c:WeakRef::RefError]] が発生します。

[[lib:delegate]] も参照してください。

=== サンプルコード

  require 'weakref'

  foo = Object.new
  ref = WeakRef.new(foo)
  ref.some_method_of_foo


== Class Methods

--- new(orig) -> WeakRef

与えられたオブジェクトを使って自身を初期化します。

@param orig 任意のオブジェクトを指定します。

== Instance Methods

--- weakref_alive? -> bool

参照先のオブジェクトがまだ生きていれば真を返します。
GC されていれば偽を返します。

--- __getobj__ -> object

自身の参照先のオブジェクトを返します。

@raise WeakRef::RefError GC 済みのオブジェクトを参照した場合に発生します。

@see [[lib:delegate]]

#@since 1.8.6
--- __setobj__(obj) -> ()

与えられたオブジェクトを自身の参照先としてセットします。
内部用のメソッドなので使わないでください。

@param obj 任意のオブジェクトを指定します。
#@end

= class WeakRef::RefError < StandardError

GC されたオブジェクトを参照しようとしたときに発生する例外です。
