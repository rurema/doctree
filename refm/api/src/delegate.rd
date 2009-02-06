#@since 1.8.0
メソッドの委譲 (delegation) を行うためのライブラリです。

[[c:Delegator]] クラスは指定したオブジェクトにメソッドの実行を委譲します。
[[c:Delegator]] クラスを利用する場合はこれを継承して
[[m:Delegator#__getobj__]] メソッドを再定義して委譲先のオブジェクトを指定します。


[[c:SimpleDelegator]] は [[c:Delegator]] の利用例の一つであり、
コンストラクタに渡されたオブジェクトにメソッドの実行を委譲します。


[[m:Kernel#DelegateClass]] は 引数で渡されたクラスのインスタンスをひとつとり、
そのオブジェクトにインスタンスメソッドを委譲するクラスを定義して返します。

=== 参考

  * Rubyist Magazine - 標準添付ライブラリ紹介【第 6 回】委譲 [[url:http://jp.rubyist.net/magazine/?0012-BundledLibraries]]


= reopen Kernel

== Private Instance Methods

--- DelegateClass(superclass) -> object

クラス superclass のインスタンスへメソッドを委譲するクラスを定義し、
そのクラスを返します。

@param superclass 委譲先となるクラス

例:

//emlist{
require 'delegate'

class ExtArray < DelegateClass(Array)
  def initialize
    super([])
  end
end
a = ExtArray.new
p a.class   # => ExtArray
a.push 25
p a         # => [25]
//}


= class Delegator < Object

#@since 1.9.1

include Delegator::MethodDelegation

#@end

サブクラスにメソッド委譲の仕組みを提供する抽象クラス。

メソッド委譲を行う場合は、本クラスを継承し[[m:Delegator#__getobj__]]を再定義する必要があります。

具体的な使用例については、[[c:SimpleDelegator]]を参照してください。

== Class Methods

#@if (version <= '1.8.6')

--- new(obj) -> object

委譲を行うメソッドを定義します。

obj のもつインスタンスメソッドのうち、
自オブジェクトに定義されていないメソッドについて、
[[m:Delegator#__getobj__]] が返すオブジェクトへ
メソッド委譲を行うクラスメソッドを定義します。

@param obj 委譲を行うメソッドを決定するために使用するオブジェクト

#@end

== Instance Methods

#@since 1.8.0
#@until 1.9.1

--- __getobj__ -> object

委譲先のオブジェクトを返します。

本メソッドは、サブクラスで再定義する必要があり、
デフォルトでは [[c:NotImplementError]] が発生します。

@raise NotImplementError サブクラスにて本メソッドが再定義されていない場合に発生します。

#@end
#@end

#@since 1.8.1
#@until 1.9.1
--- marshal_dump -> object

シリアライゼーションをサポートするために[[m:Delegator#__getobj__]] が返すオブジェクトを返します。

--- marshal_load(obj) -> object

シリアライズされたオブジェクトから、[[m:Delegator#__getobj__]] が返すオブジェクトを再現します。

@param obj [[m:Delegator#marshal_dump]]の戻り値のコピー

#@end
#@end

#@since 1.8.3
#@until 1.9.1
--- method_missing(m, *args) -> object

渡されたメソッド名と引数を使って、[[m:Delegator#__getobj__]] が返すオブジェクトへメソッド委譲を行います。

@param m メソッドの名前（シンボル）

@param args メソッドに渡された引数

@return 委譲先のメソッドからの返り値

@see [[m:Object#method_missing]]

--- respond_to?(m) -> bool

[[m:Delegator#__getobj__]] が返すオブジェクトが メソッド m を持つとき真を返します。

@param m メソッド名

@see [[m:Object#respond_to?]]

#@end
#@end

#@include(delegate/SimpleDelegator)

#@since 1.9.1
#@include(delegate/Delegator__MethodDelegation)
#@end

#@end
