= class WeakRef < Delegator
require 'delegate'

=== 目的・概要

WeakRef クラスにより weak reference を実現します。

WeakRef オブジェクトは与えられたオブジェクトをポイントしますが、
ポイント先のオブジェクトは GC される可能性があります。
アクセスしようとしたときにオブジェクトが GC されていれば
WeakRef::RefError が発生します。

=== サンプルコード

  require 'weakref'
  foo = Object.new
  ref = WeakRef.new(foo)
  ref.some_method_of_foo

=== see also
  * [[lib:delegate]]

== Class Methods

--- new(obj)
obj への weak reference を生成します。

== Instance Methods

--- weakref_alive?

参照先のオブジェクトがまだ生きていれば true を返します。

= class WeakRef::RefError < StandardError
GC されたオブジェクトを参照しようとしたときに発生する例外です。
