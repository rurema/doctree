#@since 1.8.0
メソッドの委譲 (delegation) を行う。

[[c:Delegator]] クラスは指定したオブジェクトにメソッドの実行を委譲する。
[[c:Delegator]] クラスを利用する場合はこれを継承して
[[m:Delegator#__getobj__]] メソッドを再定義して委譲先のオブジェクトを指定する。

[[c:SimpleDelegator]] は [[c:Delegator]] の利用例の一つであり、コンストラクタに
渡されたオブジェクトにメソッドの実行を委譲する。

関数 DelegateClass(supperclass) は superclass クラスの
オブジェクトをひとつとり、そのオブジェクトにインスタンスメソッドを委譲す
るクラスを定義して返す。

see also: [[m:Object#method_missing]]

//emlist{
require 'delegate'

foo = Object.new
def foo.test
  p 25
end
foo2 = SimpleDelegator.new(foo)
foo2.test   # => 25

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

=== 参考

  * Rubyist Magazine[[url:http://jp.rubyist.net/magazine/]]
  * 標準添付ライブラリ紹介【第 6 回】委譲[[url:http://jp.rubyist.net/magazine/?0012-BundledLibraries]]



= reopen Kernel

== Private Instance Methods

--- DelegateClass(superclass)

クラス superclass のインスタンスへメソッドを委譲するクラスを
定義し、そのクラスを返す。



= class Delegator < Object

#@since 1.9.0

include Delegator::MethodDelegation

#@end

与えられたオブジェクトの持つメソッドに関して
委譲用のメソッド定義を提供するクラス。

コンストラクタで指定されたオブジェクトのもつインスタンスメソッドのうち、
自分の持たないメソッドについて、
[[m:Delegator#__getobj__]] が返すオブジェクトに実行を委譲するようメソッドを定義する。

== Class Methods

#@if (version <= '1.8.6')

--- new(obj)

obj のもつインスタンスメソッドのうち、
自分の持たないメソッドについて、
[[m:Delegator#__getobj__]] が返すオブジェクトに実行を委譲する
ようインスタンスメソッドを定義する。

#@end

== Instance Methods

#@since 1.8.0

--- __getobj__

委譲先のオブジェクトを返す。
デフォルトでは [[c:NotImplementError]] を発生するので、
サブクラスで再定義する必要がある。

#@end

#@since 1.8.1
#@if (version < "1.9.0")
--- marshal_dump

--- marshal_load(obj)

#@end
#@end

#@since 1.8.3
#@if (version < "1.9.0")
--- method_missing(m, *args)

--- respond_to?(m)

#@end
#@end

#@include(delegate/SimpleDelegator)

#@since 1.9.0
#@include(delegate/Delegator__MethodDelegation)
#@end

#@end
