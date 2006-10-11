メソッドの委譲 (delegation) を行う。

Delegator クラスは指定したオブジェクトにメソッドの実行を委譲する。
Delegator クラスを利用する場合はこれを継承して
__getobj__ メソッドを再定義して委譲先のオブジェクトを指定する。

SimpleDelegator は Delegator の利用例の一つであり、コンストラクタに
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

  * [[unknown:Rubyist Magazine|URL:http://jp.rubyist.net/magazine/]]
  * [[unknown:標準添付ライブラリ紹介【第 6 回】委譲|URL:http://jp.rubyist.net/magazine/?0012-BundledLibraries]]



= reopen Kernel

== Private Instance Methods

--- DelegateClass(superclass)

クラス superclass のインスタンスへメソッドを委譲するクラスを
定義し、そのクラスを返す。



= class Delegator < Object

与えられたオブジェクトの持つメソッドに関して
委譲用のメソッド定義を提供するクラス。

コンストラクタで指定されたオブジェクトのもつインスタンスメソッドのうち、
自分の持たないメソッドについて、
__getobj__ が返すオブジェクトに実行を委譲するようメソッドを定義する。

== Instance Methods

--- initialize(obj)

obj のもつインスタンスメソッドのうち、
自分の持たないメソッドについて、
__getobj__ が返すオブジェクトに実行を委譲する
ようインスタンスメソッドを定義する。

--- __getobj__

委譲先のオブジェクトを返す。
デフォルトでは NotImplementError を発生するので、
サブクラスで再定義する必要がある。



= class SimpleDelegator < Delegator

Delegator クラスをそのまま利用した、
指定したオブジェクトにメソッドを委譲するクラス。

== Class Methods

--- new(obj)

obj がもつメソッドについて、実行を obj に委譲する
オブジェクトを生成する。

== Instance Methods

--- __getobj__

委譲先のオブジェクトを返す。

--- __setobj__(obj)

委譲先のオブジェクトを obj に変更する。

委譲するメソッドの定義は生成時にのみ行われるため、
以前の委譲先オブジェクトと obj の間で
インスタンスメソッドに違いがあっても、
委譲するインスタンスメソッドの再設定は行われないことに注意。
