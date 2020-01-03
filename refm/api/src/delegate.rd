category DesignPattern

メソッドの委譲 (delegation) を行うためのライブラリです。

[[c:Delegator]] クラスは指定したオブジェクトにメソッドの実行を委譲します。
[[c:Delegator]] クラスを利用する場合はこれを継承して
[[m:Delegator#__getobj__]] メソッドを再定義して委譲先のオブジェクトを指定します。


[[c:SimpleDelegator]] は [[c:Delegator]] の利用例の一つであり、
コンストラクタに渡されたオブジェクトにメソッドの実行を委譲します。


[[m:Kernel#DelegateClass]] は 引数で渡されたクラスのインスタンスをひとつとり、
そのオブジェクトにインスタンスメソッドを委譲するクラスを定義して返します。

=== 参考

  * Rubyist Magazine - 標準添付ライブラリ紹介【第 6 回】委譲 [[url:https://magazine.rubyist.net/articles/0012/0012-BundledLibraries.html]]


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

#@since 1.9.1

#@#--- delegation_block
#@# 見つからない

#@#--- public_api
#@# nodoc

#@end
#@since 1.9.2

#@# --- const_missing
#@# 見つからない

#@end

== Instance Methods

#@since 1.9.1
--- ==(obj) -> bool

自身が与えられたオブジェクトと等しい場合は、真を返します。
そうでない場合は、偽を返します。

@param obj 比較対象のオブジェクトを指定します。

#@end

#@since 1.9.2

--- !=(obj) -> bool

自身が与えられたオブジェクトと等しくない場合は、真を返します。
そうでない場合は、偽を返します。

@param obj 比較対象のオブジェクトを指定します。

--- ! -> bool

自身を否定します。

#@end

#@if (version == "1.9.1")
--- clone -> object
--- dup -> object

自身の複製を返します。

@see [[m:Object#clone]], [[m:Object#dup]]

#@end

--- __getobj__ -> object

委譲先のオブジェクトを返します。

本メソッドは、サブクラスで再定義する必要があり、
デフォルトでは [[c:NotImplementedError]] が発生します。

@raise NotImplementedError サブクラスにて本メソッドが再定義されていない場合に発生します。


#@since 1.9.1
--- __setobj__(obj) -> object

委譲先のオブジェクトをセットします。

@param obj 委譲先のオブジェクトを指定します。

@raise NotImplementedError サブクラスにて本メソッドが再定義されていない場合に発生します。

#@end

--- marshal_dump -> object

シリアライゼーションをサポートするために[[m:Delegator#__getobj__]] が返すオブジェクトを返します。

--- marshal_load(obj) -> object

シリアライズされたオブジェクトから、[[m:Delegator#__getobj__]] が返すオブジェクトを再現します。

@param obj [[m:Delegator#marshal_dump]]の戻り値のコピー


--- method_missing(m, *args) -> object

渡されたメソッド名と引数を使って、[[m:Delegator#__getobj__]] が返すオブジェクトへメソッド委譲を行います。

@param m メソッドの名前（シンボル）

@param args メソッドに渡された引数

@return 委譲先のメソッドからの返り値

#@since 1.9.1
@see [[m:BasicObject#method_missing]]
#@else
@see [[m:Object#method_missing]]
#@end

--- respond_to?(m) -> bool

[[m:Delegator#__getobj__]] が返すオブジェクトが メソッド m を持つとき真を返します。

@param m メソッド名

@see [[m:Object#respond_to?]]


#@since 1.9.2
--- freeze -> self

自身を凍結します。

@see [[m:Object#freeze]]

--- methods -> [Symbol]

そのオブジェクトに対して呼び出せるメソッド名の一覧を返します。
このメソッドは public メソッドおよび protected メソッドの名前を返します。

@see [[m:Object#methods]]

--- protected_methods(all = true) -> [Symbol]

そのオブジェクトが理解できる protected メソッド名の一覧を返します。

@param all 偽を指定すると __getobj__ のスーパークラスで定義されたメソッドを除きます。

@see [[m:Object#protected_methods]]

--- public_methods(all = true) -> [Symbol]

そのオブジェクトが理解できる public メソッド名の一覧を返します。

@param all 偽を指定すると __getobj__ のスーパークラスで定義されたメソッドを除きます。

@see [[m:Object#public_methods]]

--- respond_to_missing?(m, include_private) -> bool

@param m メソッド名を指定します。

@param include_private 真を指定すると private メソッドも調べます。

#@end

== Constants

#@until 1.9.1
--- IgnoreBacktracePat -> Regexp

バックトレースで無視するパターンを返します。
#@end

#@include(delegate/SimpleDelegator)

