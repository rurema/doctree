クラスやオブジェクトに、メソッドの委譲機能を追加するためのライブラリです。

#@#以下のモジュールが定義されます。

#@#  * [[c:Forwardable]]
#@#  * [[c:SingleForwardable]]

#@#詳細は [[unknown:"ruby-src:doc/forwardable.rd.ja"]] を参照してください。

=== 参考

  * Rubyist Magazine 0012 号 標準添付ライブラリ紹介【第 6 回】委譲 ([[url:http://jp.rubyist.net/magazine/?0012-BundledLibraries]])

= module Forwardable

クラスに対し、メソッドの委譲機能を定義するモジュールです。

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

--- debug -> bool

委譲部分をバックトレースに含めるかどうかの状態を返します。

バックトレースを含める設定となっている時、真を返します。
デフォルトは含めない設定となっています。


--- debug= -> bool

委譲部分をバックトレースに含めるかどうかの状態を設定します。


== Instance Methods

--- def_instance_delegators(accessor, *methods) -> nil
--- def_delegators(accessor, *methods) -> nil

メソッドの委譲先をまとめて設定します。

@param accessor 委譲先のオブジェクト

@param methods 委譲するメソッドのリスト

委譲元のオブジェクトで methods のそれぞれのメソッドが呼び出された場合に、
委譲先のオブジェクトの同名のメソッドへ処理が委譲されるようになります。

def_delegators は def_instance_delegators の別名になります。


--- def_instance_delegator(accessor, method, ali = method) -> nil
--- def_delegator(accessor, method, ali = method) -> nil

メソッドの委譲先を設定します。

@param accessor 委譲先のオブジェクト

@param method 委譲先のメソッド

@param ali 委譲元のメソッド

委譲元のオブジェクトで ali が呼び出された場合に、
委譲先のオブジェクトの method へ処理が委譲されるようになります。

委譲元と委譲先のメソッド名が同じ場合は, ali を省略することが可能です。

def_delegator は def_instance_delegator の別名になります。


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


--- def_singleton_delegators(accessor, *methods) -> nil
--- def_delegators(accessor, *methods) -> nil

メソッドの委譲先をまとめて設定します。

@param accessor 委譲先のオブジェクト

@param methods 委譲するメソッドのリスト

委譲元のオブジェクトで methods のそれぞれのメソッドが呼び出された場合に、
委譲先のオブジェクトの同名のメソッドへ処理が委譲されるようになります。

def_delegators は def_singleton_delegators の別名になります。


--- def_singleton_delegator(accessor, method, ali = method) -> nil
--- def_delegator(accessor, method, ali = method) -> nil

メソッドの委譲先を設定します。

@param accessor 委譲先のオブジェクト

@param method 委譲先のメソッド

@param ali 委譲元のメソッド

委譲元のオブジェクトで ali が呼び出された場合に、
委譲先のオブジェクトの method へ処理が委譲されるようになります。

委譲元と委譲先のメソッド名が同じ場合は, ali を省略することが可能です。

def_delegator は def_singleton_delegator の別名になります。

