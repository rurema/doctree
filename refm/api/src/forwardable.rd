クラスに対してメソッドの委譲機能を定義します。

#@#以下のモジュールが定義されます。

#@#  * [[c:Forwardable]]
#@#  * [[c:SingleForwardable]]

#@#詳細は [[unknown:"ruby-src:doc/forwardable.rd.ja"]] を参照してください。

=== 参考

  * Rubyist Magazine 0012 号 標準添付ライブラリ紹介【第 6 回】委譲 ([[url:http://jp.rubyist.net/magazine/?0012-BundledLibraries]])

= module Forwardable

クラスに対しメソッドの委譲機能を定義するモジュールです。

=== 使い方

クラスに対して [[m:Object#extend]] して使います。[[m:Module#include]] でないところに注意して下さい。

例:

  class Foo
    extend Forwardable
    
    def_delegators("@out", "printf", "print")
    def_delegators(:@in, :gets)
    def_delegator(:@contents, :[], "content_at")
  end
  f = Foo.new
  f.printf ...
  f.gets
  f.content_at(1)

== Singleton Methods

--- debug
--- debug=
#@todo

委譲したメソッドをバックトレースに含めるかどうかを設定します。
(デフォルトは表示しません。)

== Instance Methods

--- def_instance_delegators(accessor, *methods)
--- def_delegators(accessor, *methods)
#@todo

methods で渡されたメソッドのリストを accessor に委譲する
ようにします。

--- def_instance_delegator(accessor, method, ali = method)
--- def_delegator(accessor, method, ali = method)
#@todo

method で渡されたメソッドを accessor に委譲するようにし
ます。aliが引数として渡されたときは、メソッドaliが呼ば
れたときには、accessor に対し method を呼び出します。

= module SingleForwardable

オブジェクトに対し、メソッドの委譲機能を定義するモジュールです。

=== 使い方

オブジェクトに対して extend して使います。

例:

  g = Goo.new
  g.extend SingleForwardable
  g.def_delegator("@out", :puts)
  g.puts ...

== Instance Methods

--- def_singleton_delegators(accessor, *methods)
--- def_delegators(accessor, *methods)
#@todo

methods で渡されたメソッドのリストを accessor に委譲する
ようにします。

--- def_singleton_delegator(accessor, method, ali = method)
--- def_delegator(accessor, method, ali = method)
#@todo

method で渡されたメソッドを accessor に委譲するようにしま
す。ali が引数として渡されたときは, メソッド ali が呼ばれ
たときには、accessor に対し method を呼び出します。

