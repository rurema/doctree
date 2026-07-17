---
type: library
category: Thread
---
スレッド同期機構である Mutex のモジュール版を提供するライブラリです。

# module Mutex_m

スレッド同期機構である [c:Thread::Mutex] のモジュール版です。クラスに
[m:Module#include] することでそのクラスに Mutex 機能を持たせることができます。
また、普通のオブジェクトを [m:Object#extend] により Mutex にする事ができます。

このモジュールによるロックは再入不可能です。再入可能な同等品が必要な場合は
[c:Sync_m] の利用を考えてください。

「mu_」の付かないメソッド([m:Mutex_m#lock], [m:Mutex_m#synchronize], 
[m:Mutex_m#locked?], [m:Mutex_m#try_lock], [m:Mutex_m#unlock])
はモジュールにincludeした場合には定義されません。

[ruby-list:1991]

### 例
クラスに [m:Module#include] する例
```ruby
require "mutex_m"
class Foo
  include Mutex_m
  # ...
end
obj = Foo.new
obj.synchronize do 
  # 危険領域(critical section)
  # ...
end
```

オブジェクトに [m:Object#extend] する例
```ruby
require "mutex_m"
obj = Object.new
obj.extend(Mutex_m)
obj.lock
# 危険領域(critical section)  
... 
obj.unlock
```

## Singleton Methods

### def append_features(klass) -> Class | nil

ユーザが直接、使うことはありません。

- **SEE** [m:Module#append_features]

### def define_aliases(klass) -> Class

ユーザが直接、使うことはありません。

### def extend_object(module) -> Module

ユーザが直接、使うことはありません。

- **SEE** [m:Module#extend_object]

## Instance Methods

### def mu_extended -> Mutex

[m:Mutex_m.extend_object] から呼び出されます。
ユーザが直接使うことはありません。

### def mu_synchronize{ ... } -> object
### def synchronize{ ... } -> object

self のロックを取得し、ブロックを実行します。実行後に必ずロックを解放します。

ブロックで最後に評価した値を返します。

### def mu_lock -> ()
### def lock -> ()
self をロックします。一度にひとつのスレッドしかロックできません。
既にロックされている mutex に対してロックを行おうとしたスレッドは
ロックが解放されるまで、実行が停止されます。


### def mu_locked? -> bool
### def locked? -> bool
self がロックされている時、真を返します。

### def mu_try_lock -> bool
### def try_lock -> bool
self をロックしようとして、成功した場合、真を返し、ロックを得ます。

ロックできなかった場合にはブロックせず偽を返します。

### def mu_unlock -> ()
### def unlock -> ()
ロックを解放します。ロック待ちになっていたスレッドの実行は再開されます。

- **raise** `ThreadError` -- ロックされていない場合に unlock を呼ぶと発生します

