---
library:
  - _builtin
---
# class Thread::Mutex < Object
alias Mutex

Mutex(Mutal Exclusion = 相互排他ロック)は共有データを並行アクセスから保護する
ためにあります。Mutex の典型的な使い方は(m を Mutex オブジェクトとします):

```ruby
m.lock
begin
  # m によって保護されたクリティカルセクション
ensure
  m.unlock
end
```

または、より簡単に

```ruby
m.synchronize {
  # m によって保護されたクリティカルセクション
}
```

## Class Methods

### def new -> Thread::Mutex
新しい mutex を生成して返します。

- **SEE** [m:Thread::Mutex#unlock]

## Instance Methods


### def lock -> self
mutex オブジェクトをロックします。一度に一つのス
レッドだけが mutex をロックできます。既にロックされている mutex
に対してロックを行おうとしたスレッドは mutex のロックが解放さ
れるまで、実行が停止されます。

- **raise** `ThreadError` -- self 既にカレントスレッドにロックされている場合に発
                   生します。
                   また、[m:Signal?.trap] に指定したハンドラ内で実行
                   した場合に発生します。

- **SEE** [m:Thread::Mutex#unlock]

### def locked? -> bool
mutex がロックされている時、真を返します。

```ruby title="例"
m = Thread::Mutex.new
p m.locked? # => false
m.lock
p m.locked? # => true
```

### def synchronize { ... } -> object

mutex をロックし、ブロックを実行します。実行後に必ず mutex のロックを解放します。

ブロックが最後に評価した値を返します。

- **raise** `ThreadError` -- self 既にカレントスレッドにロックされている場合に発
                   生します。
                   また、[m:Signal?.trap] に指定したハンドラ内で実行
                   した場合に発生します。

```ruby title="例"
m = Thread::Mutex.new
result = m.synchronize do
  p m.locked? # => true
  # critical part
  "result"
end
p m.locked? # => false
p result # => "result"
```

### def try_lock -> bool
mutex をロックしようとして、ロックが成功した場合、真を返します。
ロックできなかった場合にはブロックせず偽を返します。

```ruby title="例"
m = Thread::Mutex.new
p m.try_lock # => true
p m.try_lock # => false
```

### def unlock     -> self
mutex のロックを解放します。mutex のロック待ちになっていたスレッドの実行は再開されます。

- **return** -- self を返します。

```ruby title="例"
m = Thread::Mutex.new
begin 
  m.lock
  # critical part
ensure
  m.unlock
end
```

Mutex はロックしたスレッド以外からロックを開放することは出来ません。
ロックしたスレッド以外から unlock が呼ばれると ThreadError が発生します。

```ruby
m = Thread::Mutex.new
m.lock
Thread.new do
  m.unlock # => ThreadError
end.join
```

- **raise** `ThreadError` -- self がロックされていない場合や self をロックしたス
                   レッド以外から呼ばれた場合に発生します。
                   また、[m:Signal?.trap] に指定したハンドラ内で実行
                   した場合に発生します。

### def sleep(timeout = nil)    -> Integer

与えられた秒数の間ロックを解除してスリープして、実行後にまたロックします。

- **param** `timeout` -- スリープする秒数を指定します。省略するとスリープし続けます。

#@since 3.1
- **return** -- タイムアウトした時は nil を、それ以外はスリープしていた秒数を返します。
#@else
- **return** -- スリープしていた秒数を返します。
#@end

- **raise** `ThreadError` -- 自身がカレントスレッドによってロックされていない場合に発生します。

[注意] 2.0 以降ではスリープ中でも、シグナルを受信した場合などに実行が再
開(spurious wakeup)される場合がある点に注意してください。

```ruby title="例"
m = Thread::Mutex.new
th = Thread.new do
  m.lock
  m.sleep(2)
end
p th.status # => "run"
sleep 1
p th.status # => "sleep"
sleep 1
p th.status # => false
```


### def owned? -> bool

self がカレントスレッドによってロックされている場合に true を返します。
そうでない場合に false を返します。


```ruby title="例"
m = Thread::Mutex.new
p m.owned? # => false
m.lock
Thread.new do
  p m.owned? # => false
end.join
p m.owned? # => true
```

