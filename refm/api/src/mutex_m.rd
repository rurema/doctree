スレッド同期機構である Mutex のモジュール版を提供するライブラリです。

= module Mutex_m

スレッド同期機構である [[c:Mutex]] のモジュール版です。クラスに
[[m:Module#include]] することでそのクラスに Mutex 機能を持たせることができます。
また、普通のオブジェクトを [[m:Object#extend]] により Mutex にする事ができます。

このモジュールによるロックは再入不可能です。再入可能な同等品が必要な場合は
[[c:Sync_m]] の利用を考えてください。

[[ruby-list:1991]]

=== 例
クラスに [[m:Module#include]] する例
  class Foo
    include Mutex_m
    ...
  end
  obj = Foo.new
  obj.synchronize do 
    # 危険領域(critical section)
    ...
  end

オブジェクトに [[m:Object#extend]] する例
  require "mutex_m"
  obj = Object.new
  obj.extend(Mutex_m)
  obj.lock
  # 危険領域(critical section)  
  ... 
  obj.unlock

== Instance Methods

--- mu_synchronize{ ... } -> object
--- synchronize{ ... } -> object

self のロックを取得し、ブロックを実行します。実行後に必ずロックを解放します。

ブロックで最後に評価した値を返します。

#@until 1.9.1
--- mu_lock -> self
--- lock -> self
#@else
--- mu_lock -> ()
--- lock -> ()
#@end
self をロックします。一度にひとつのスレッドしかロックできません。
既にロックされている mutex に対してロックを行おうとしたスレッドは
ロックが解放されるまで、実行が停止されます。

#@until 1.9.1
self を返します。
#@end

--- mu_locked? -> bool
--- locked? -> bool
self がロックされている時、真を返します。

--- mu_try_lock -> bool
--- try_lock -> bool
self をロックしようとして、成功した場合、真を返し、ロックを得ます。

ロックできなかった場合にはブロックせず偽を返します。

#@until 1.9.1
--- mu_unlock -> self | nil
--- unlock -> self | nil
#@else
--- mu_unlock -> ()
--- unlock -> ()
#@end
ロックを解放します。ロック待ちになっていたスレッドの実行は再開されます。

#@until 1.9.1
self がロックされていなければ nil を返します。そうでなければself を返します。
#@else
@raise ThreadError ロックされていない場合に unlock を呼ぶと発生します
#@end

