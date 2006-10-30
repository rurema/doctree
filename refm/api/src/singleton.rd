= module Singleton
=== 目的・概要
Mix-in により singleton パターンを提供します。

Singleton モジュールを include することにより、クラスは
高々ひとつのインスタンスしか持たないことが保証されます。

Singleton を mix-in したクラスの
クラスメソッド instance はその唯一のインスタンスを返します。

new は private メソッドに移され、外部から呼び出そうとするとエラーになります。

=== サンプルコード

  require 'singleton'
  class SomeSingletonClass
    include Singleton
   #....
  end
  a = SomeSingletonClass.instance
  b = SomeSingletonClass.instance  # a and b are same object
  p [a,b]
  a = SomeSingletonClass.new               # error (`new' is private)

== Singleton Methods

--- instance

そのクラスの唯一のインスタンスを返します。
最初に呼ばれたときはそのインスタンスを生成します。

Singleton を include したクラスで定義されますので、
正確には Singleton モジュールのメソッドではありません。
