weak reference を実現します。

= class WeakRef < Delegator

[[c:WeakRef]] オブジェクトは与えられたオブジェクトをポイントしますが、
ポイント先のオブジェクトは GC される可能性があります。
アクセスしようとしたときにオブジェクトが GC されていれば
WeakRef::RefError が発生します。

see also: [[lib:delegate]]

=== サンプルコード

  require 'weakref'

  foo = Object.new
  ref = WeakRef.new(foo)
  ref.some_method_of_foo


== Class Methods

--- new(obj)
#@todo

obj への weak reference を生成します。

== Instance Methods

--- weakref_alive?
#@todo

参照先のオブジェクトがまだ生きていれば true を返します。
GCされていれば false を返します。

--- __getobj__
#@todo
Return the object this WeakRef references. Raises WeakRef::RefError if the object has been
garbage collected. The object returned is the object to which method calls are 
delegated (see [[c:Delegator]]).

= class WeakRef::RefError < StandardError

GC されたオブジェクトを参照しようとしたときに発生する例外です。
