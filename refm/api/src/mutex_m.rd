= module Mutex_m

スレッド同期機構である [[c:Mutex]] のモジュール版です。普通のオブジェクトを
extend により Mutex にする事ができます。

[[unknown:ruby-list:1991]]

#@# == 例

  require "mutex_m"
  obj = Object.new
  obj.extend(Mutex_m)
  obj.lock
  obj.unlock

== Instance Methods

--- mu_synchronize{ ... }
--- synchronize{ ... }
#@todo
Mutex_m をロックし、ブロックを実行します。実行後に必ず Mutex_m 
のロックを解放します。

--- mu_lock
--- lock
#@todo
Mutex_m をロックします。一度にひとつのスレッドしかロックできません。
既にロックされている mutex に対してロックを行おうとしたスレッドは
Mutex_m のロックが解放されるまで、実行が停止されます。

self を返します。

--- mu_locked?
--- locked?
#@todo
Mutex_m がロックされている時、真を返します。

--- mu_try_lock
--- try_lock
#@todo
Mutex_m をロックしようとして、ロックが成功した場合、真を返します。
ロックできなかった場合にはブロックせず偽を返します。

--- mu_unlock
--- unlock
#@todo
Mutex_m のロックを解放します。
Mutex_m のロック待ちになっていたスレッドの実行は再開されます。

self がロックされていなければ nil を返します。そうでなければself を返します。
