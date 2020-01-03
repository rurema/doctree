category DesignPattern

クラスやオブジェクトに、メソッドの委譲機能を追加するためのライブラリです。

#@#以下のモジュールが定義されます。

#@#  * [[c:Forwardable]]
#@#  * [[c:SingleForwardable]]

#@#詳細は [[unknown:"ruby-src:doc/forwardable.rd.ja"]] を参照してください。

=== 参考

  * Rubyist Magazine 0012 号 標準添付ライブラリ紹介【第 6 回】委譲 ([[url:https://magazine.rubyist.net/articles/0012/0012-BundledLibraries.html]])

= module Forwardable

クラスに対し、メソッドの委譲機能を定義するモジュールです。

=== 使い方

クラスに対して [[m:Object#extend]] して使います。[[m:Module#include]] でないところに注意して下さい。

例:

  require 'forwardable'
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

--- def_instance_delegators(accessor, *methods) -> ()
--- def_delegators(accessor, *methods)          -> ()

メソッドの委譲先をまとめて設定します。

@param accessor 委譲先のオブジェクト

@param methods 委譲するメソッドのリスト

委譲元のオブジェクトで methods のそれぞれのメソッドが呼び出された場合に、
委譲先のオブジェクトの同名のメソッドへ処理が委譲されるようになります。

def_delegators は def_instance_delegators の別名になります。

また、以下の 2 つの例は同じ意味です。

  def_delegators :@records, :size, :<<, :map

  def_delegator :@records, :size
  def_delegator :@records, :<<
  def_delegator :@records, :map

@see [[m:Forwardable#def_delegator]]

--- def_instance_delegator(accessor, method, ali = method) -> ()
--- def_delegator(accessor, method, ali = method)          -> ()

メソッドの委譲先を設定します。

@param accessor 委譲先のオブジェクト

@param method 委譲先のメソッド

@param ali 委譲元のメソッド

委譲元のオブジェクトで ali が呼び出された場合に、
委譲先のオブジェクトの method へ処理が委譲されるようになります。

委譲元と委譲先のメソッド名が同じ場合は, ali を省略することが可能です。

def_delegator は def_instance_delegator の別名になります。

例:

  require 'forwardable'
  class MyQueue
    extend Forwardable
    attr_reader :queue
    def initialize
      @queue = []
    end

    def_delegator :@queue, :push, :mypush
  end

  q = MyQueue.new
  q.mypush 42
  q.queue    # => [42]
  q.push 23  # => NoMethodError

@see [[m:Forwardable#def_delegators]]

#@since 1.9.1
--- instance_delegate(hash) -> ()
--- delegate(hash)          -> ()

メソッドの委譲先を設定します。

@param hash 委譲先のメソッドがキー、委譲先のオブジェクトが値の
            [[c:Hash]] を指定します。キーは [[c:Symbol]]、
            [[c:String]] かその配列で指定します。

#@# ruby-core:05899 のパッチに付いてたテストコードより。

例:

  require 'forwardable'
  class Zap
     extend Forwardable
     delegate :length => :@str
     delegate [:first, :last] => :@arr
     def initialize
        @arr = %w/foo bar baz/
        @str = "world"
     end
  end

  zap = Zap.new
  zap.length # => 5
  zap.first  # => "foo"
  zap.last   # => "baz"

== Constants

--- FORWARDABLE_VERSION -> "1.1.0"

[[lib:forwardable]] ライブラリのバージョンを返します。
#@end

= module SingleForwardable

オブジェクトに対し、メソッドの委譲機能を定義するモジュールです。

=== 使い方

オブジェクトに対して extend して使います。

例:

  require 'forwardable'
  g = Goo.new
  g.extend SingleForwardable
  g.def_delegator("@out", :puts)
  g.puts ...

また、[[c:SingleForwardable]] はクラスやモジュールに対して以下のようにする事もできます。

  require 'forwardable'
  class Implementation
    def self.service
      puts "serviced!"
    end
  end
  
  module Facade
    extend SingleForwardable
    def_delegator :Implementation, :service
  end

  Facade.service # => serviced!

もし [[c:Forwardable]] と [[c:SingleForwardable]] の両方を使いたい場合、
#@since 1.9.1
def_instance_delegator と def_single_delegator メソッドの方を呼び出して
ください。
#@else
def_instance_delegator と def_singleton_delegator メソッドの方を呼び出
してください。
#@end

== Instance Methods

#@since 1.9.1
--- def_single_delegators(accessor, *methods)    -> ()
#@else
--- def_singleton_delegators(accessor, *methods) -> ()
#@end
--- def_delegators(accessor, *methods)           -> ()

メソッドの委譲先をまとめて設定します。

@param accessor 委譲先のオブジェクト

@param methods 委譲するメソッドのリスト

委譲元のオブジェクトで methods のそれぞれのメソッドが呼び出された場合に、
委譲先のオブジェクトの同名のメソッドへ処理が委譲されるようになります。

def_delegators は def_singleton_delegators の別名になります。

また、以下の 2 つの例は同じ意味です。

  def_delegators :@records, :size, :<<, :map

  def_delegator :@records, :size
  def_delegator :@records, :<<
  def_delegator :@records, :map

@see [[m:SingleForwardable#def_delegator]]

#@since 1.9.1
--- def_single_delegator(accessor, method, ali = method)    -> ()
#@else
--- def_singleton_delegator(accessor, method, ali = method) -> ()
#@end
--- def_delegator(accessor, method, ali = method)           -> ()

メソッドの委譲先を設定します。

@param accessor 委譲先のオブジェクト

@param method 委譲先のメソッド

@param ali 委譲元のメソッド

委譲元のオブジェクトで ali が呼び出された場合に、
委譲先のオブジェクトの method へ処理が委譲されるようになります。

委譲元と委譲先のメソッド名が同じ場合は, ali を省略することが可能です。

def_delegator は def_singleton_delegator の別名になります。

@see [[m:SingleForwardable#def_delegators]]

#@since 1.9.1
--- single_delegate(hash) -> ()
--- delegate(hash)        -> ()

メソッドの委譲先を設定します。

@param hash 委譲先のメソッドがキー、委譲先のオブジェクトが値の
            [[c:Hash]] を指定します。キーは [[c:Symbol]]、
            [[c:String]] かその配列で指定します。

@see [[m:Forwardable#delegate]]
#@end
