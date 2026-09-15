---
library: _builtin
since: "4.1"
alias:
  - Monitor
---
# class Thread::Monitor < Object

スレッドの同期機構としてのモニター機能を提供するクラスです。
また同じスレッドから何度も lock できる Mutex としての機能も提供します。

Ruby 4.0 までは [lib:monitor] ライブラリの `Monitor` クラスとして提供されていましたが、Ruby 4.1 で組み込みクラスになりました。`Monitor` は `Thread::Monitor` の別名として引き続き使えます。

[c:MonitorMixin] と、`mon_enter` のような `mon_` の付いた別名メソッドは、引き続き [lib:monitor] ライブラリで定義されています(RubyGems が読み込むため、通常は `require` しなくても使えます)。

### 例

```ruby title="消費者、生産者問題の例"
buf = []
mon = Thread::Monitor.new
empty_cond = mon.new_cond

# consumer
Thread.start do
  loop do
    mon.synchronize do
      empty_cond.wait_while { buf.empty? }
      print buf.shift
    end
  end
end

# producer
while line = ARGF.gets
  mon.synchronize do
    buf.push(line)
    empty_cond.signal
  end
end
```

2回ロックしてもデッドロックにならない例です。

```ruby title="デッドロックにならない例"
mon = Thread::Monitor.new
mon.synchronize {
  mon.synchronize {
  }
}
```

[c:Thread::Mutex] ではデッドロックになります。

```ruby title="Mutex でデッドロックになる例"
mx = Mutex.new
mx.synchronize {
  mx.synchronize {
  }
}
# => deadlock; recursive locking (ThreadError)
```

## Class Methods

### def Thread::Monitor.new -> Thread::Monitor
{: since=""}

新しい Thread::Monitor オブジェクトを生成します。

## Instance Methods

### def enter -> ()
{: since=""}
### def mon_enter -> ()
{: since=""}

モニターをロックします。

一度に一つのスレッドだけがモニターをロックできます。
既にモニターがロックされている場合は、ロックが開放されるまでそのスレッドは待ちます。

[m:Thread::Mutex#lock] に相当します。
Thread::Mutex#lock と違うのは現在のモニターの所有者が現在実行されているスレッドである場合、何度でもロックできる点です。ロックした回数だけ [m:Thread::Monitor#exit] を呼ばなければモニターは解放されません。

```ruby title="例"
mon = Thread::Monitor.new
mon.enter
mon.enter
```

Thread::Mutex#lock ではデッドロックが起きます。

```ruby title="Mutex でデッドロックする例"
m = Mutex.new
m.lock
m.lock # => deadlock; recursive locking (ThreadError)
```

### def exit -> ()
{: since=""}
### def mon_exit -> ()
{: since=""}

モニターのロックを解放します。

enter でロックした回数だけ exit を呼ばなければモニターは解放されません。

モニターが解放されればモニターのロック待ちになっていたスレッドが一つ実行を再開します。

- **raise** `ThreadError` -- ロックを持っていないスレッドが呼びだした場合に発生します

```ruby title="例"
mon = Thread::Monitor.new
mon.enter
mon.enter
mon.exit
mon.exit
mon.exit # => current thread not owner (ThreadError)
```

### def try_enter     -> bool
{: since=""}
### def try_mon_enter -> bool
{: since=""}
### def mon_try_enter -> bool
{: since=""}

モニターのロックを取得しようと試みます。
ロックに成功した(ロックが開放状態だった、もしくはロックを取得していたスレッドが自分自身であった)場合には真を返します。

ロックができなかった場合は偽を返し、実行を継続します。この場合にはスレッドはブロックしません。

### def synchronize     { ... } -> object
{: since=""}
### def mon_synchronize { ... } -> object
{: since=""}

モニターをロックし、ブロックを実行します。実行後に必ずモニターのロックを解放します。

ブロックの評価値を返り値として返します。

- **SEE** [m:Thread::Monitor#enter]

### def mon_locked? -> bool
{: since="2.5.0"}

モニターがロックされているときに true を返します。

### def mon_check_owner -> nil
{: since=""}

[c:MonitorMixin] 用の内部メソッドです。

- **raise** `ThreadError` -- ロックを持っていないスレッドが呼びだした場合に発生します

### def mon_owned? -> bool
{: since="2.5.0"}

カレントスレッドがモニターをロックしているときに true を返します。

### def wait_for_cond(cond, timeout) -> bool
{: since="2.7.0"}

[c:Thread::Monitor::ConditionVariable] 用の内部メソッドです。

- **param** `cond` -- [c:Thread::ConditionVariable] を指定します。
- **param** `timeout` -- タイムアウトまでの秒数。指定しなかった場合はタイムアウトしません。
- **return** -- タイムアウトしたときは false を返します。それ以外は true を返します。

```ruby title="例"
m = Thread::Monitor.new
cv = Thread::ConditionVariable.new
m.enter
m.wait_for_cond(cv, 1)
```

### def new_cond -> Thread::Monitor::ConditionVariable
{: since=""}

モニターに関連付けられた、新しい [c:Thread::Monitor::ConditionVariable] を生成して返します。
