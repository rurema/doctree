---
library: thwait
extend:
  - Exception2MessageMapper
alias:
  - ThWait
until: "2.7.0"
---
# class ThreadsWait < Object

複数スレッドの終了を待つ機能を提供します。

## Class Methods

### def all_waits(*threads) -> ()
### def all_waits(*threads){|thread| ...} -> ()

指定されたスレッドすべてが終了するまで待ちます。
ブロックが与えられた場合、スレッド終了時にブロックを評価します。

- **param** `threads` -- 終了するまでまつスレッドを一つもしくは複数指定します。

```ruby
require 'thwait'

threads = []
5.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}
ThreadsWait.all_waits(*threads) {|th| printf("end %s\n", th.inspect) }

# 出力例
#=> #<Thread:0x21584 run>
#=> #<Thread:0x21610 run>
#=> #<Thread:0x2169c run>
#=> #<Thread:0x21728 run>
#=> #<Thread:0x214f8 run>
#=> end #<Thread:0x21584 dead>
#=> end #<Thread:0x21610 dead>
#=> end #<Thread:0x2169c dead>
#=> end #<Thread:0x21728 dead>
#=> end #<Thread:0x214f8 dead>
```

### def new(*threads) -> ThreadsWait

指定されたスレッドの終了をまつための、スレッド同期オブジェクトをつくります。

- **param** `threads` -- 終了を待つスレッドを一つもしくは複数指定します。

```ruby title="使用例"
require 'thwait'

threads = []
5.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}
  
thall = ThreadsWait.new(*threads)
thall.all_waits{|th|
  printf("end %s\n", th.inspect)
}
  
# 出力例
#=> #<Thread:0x214bc run>
#=> #<Thread:0x21548 run>
#=> #<Thread:0x215d4 run>
#=> #<Thread:0x21660 run>
#=> #<Thread:0x21430 run>
#=> end #<Thread:0x214bc dead>
#=> end #<Thread:0x21548 dead>
#=> end #<Thread:0x215d4 dead>
#=> end #<Thread:0x21660 dead>
#=> end #<Thread:0x21430 dead>
```


## Instance Methods

### def threads -> Array

同期されるスレッドの一覧を配列で返します。

使用例
```ruby
require 'thwait'

threads = []
3.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}

thall = ThreadsWait.new(*threads)
p thall.threads
#=> [#<Thread:0x21750 sleep>, #<Thread:0x216c4 sleep>, #<Thread:0x21638 sleep>]
```

### def empty? -> bool

同期されるスレッドが存在するならば true をかえします。

使用例
```ruby
require 'thwait'

threads = []
3.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}

thall = ThreadsWait.new
p thall.threads.empty? #=> true
thall.join(*threads)
p thall.threads.empty? #=> false
```

### def finished? -> bool

すでに終了したスレッドが存在すれば true を返します。

使用例
```ruby
require 'thwait'

threads = []
3.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}

thall = ThreadsWait.new(*threads)
p thall.finished? #=> false
sleep 3
p thall.finished? #=> true
```

### def join(*threads) -> ()

終了を待つスレッドの対象として、threads で指定されたスレッドを指定します。

- **param** `threads` -- 複数スレッドの終了を待つスレッドに指定されたthreadsを加えます。

```ruby
require 'thwait'

threads = []
5.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}

thall = ThreadsWait.new
p thall.threads #=> []
thall.join(*threads)
p thall.threads
#=> [#<Thread:0x216ec dead>, #<Thread:0x21660 dead>, #<Thread:0x215d4 dead>, #<Thread:0x214bc dead>]
```

### def join_nowait(*threads) -> ()

終了を待つスレッドの対象として、threads で指定されたスレッドを指定します。
しかし、実際には終了をまちません。

- **param** `threads` -- 複数スレッドの終了を待つスレッドに指定されたthreadsを加えます。

```ruby
require 'thwait'

threads = []
5.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}

thall = ThreadsWait.new
p thall.threads #=> []
thall.join_nowait(*threads)
p thall.threads #=> [#<Thread:0x21638 sleep>, #<Thread:0x215ac sleep>, #<Thread:0x21520 sleep>, #<Thread:0x21494 sleep>, #<Thread:0x21408 sleep>]
# 実際には終了を待っていない。sleep している。
```

### def next_wait(nonblock = nil) -> Thread

指定したスレッドのどれかが終了するまで待ちます。

- **param** `nonblock` -- true を与えると、キューが空の時、例外 [c:ThreadsWait::ErrNoFinishedThread] が発生します。

- **raise** `ErrNoWaitingThread` -- 終了をまつスレッドが存在しない時、発生します。

- **raise** `ErrNoFinishedThread` -- nonblock がtrue でかつ、キューが空の時、発生します。

```ruby
#使用例
require 'thwait'

threads = []
2.times {|i|
  threads << Thread.new { sleep i }
}

thall = ThreadsWait.new
thall.join_nowait(*threads)
until thall.empty?
  th = thall.next_wait
  p th
end
```

- **SEE** [m:Queue#pop]

### def all_waits -> ()

指定されたスレッドすべてが終了するまで待ちます。
ブロックが与えられた場合、スレッド終了時にブロックを評価します。

```ruby title="使用例"
require 'thwait'

threads = []
5.times {|i|
  threads << Thread.new { sleep 1; p Thread.current }
}
  
thall = ThreadsWait.new(*threads)
thall.all_waits{|th|
  printf("end %s\n", th.inspect)
}
  
# 出力例
#=> #<Thread:0x214bc run>
#=> #<Thread:0x21548 run>
#=> #<Thread:0x215d4 run>
#=> #<Thread:0x21660 run>
#=> #<Thread:0x21430 run>
#=> end #<Thread:0x214bc dead>
#=> end #<Thread:0x21548 dead>
#=> end #<Thread:0x215d4 dead>
#=> end #<Thread:0x21660 dead>
#=> end #<Thread:0x21430 dead>
```

