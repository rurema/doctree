category DesignPattern

Singleton パターンを扱うためのライブラリです。

= module Singleton

Singleton パターンを提供するモジュールです。

Mix-in により singleton パターンを提供します。

Singleton モジュールを include することにより、クラスは
高々ひとつのインスタンスしか持たないことが保証されます。

Singleton を Mix-in したクラスの
クラスメソッド instance はその唯一のインスタンスを返します。

new は private メソッドに移され、外部から呼び出そうとするとエラーになります。

=== サンプルコード

  require 'singleton'

  class SomeSingletonClass
    include Singleton
   #....
  end

  a = SomeSingletonClass.instance
  b = SomeSingletonClass.instance # a and b are same object
  p [a,b] # => [#<SomeSingletonClass:0x0000562e6e18ddd0>, #<SomeSingletonClass:0x0000562e6e18ddd0>]
  a = SomeSingletonClass.new  # => NoMethodError (private method `new' called for SomeSingletonClass:Class)

== Singleton Methods

--- instance -> object

そのクラスの唯一のインスタンスを返します。
最初に呼ばれたときはそのインスタンスを生成します。

Singleton を include したクラスで定義されますので、
正確には Singleton モジュールのメソッドではありません。

== Instance Methods

--- clone

@raise TypeError このメソッドを呼び出した場合に発生します。

--- dup

@raise TypeError このメソッドを呼び出した場合に発生します。
