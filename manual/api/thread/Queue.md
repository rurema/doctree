---
library:
  - _builtin
---
# class Thread::Queue < Object
alias Queue

Queue はスレッド間の FIFO(first in first out) の通信路です。ス
レッドが空のキューを読み出そうとすると停止します。キューになんら
かの情報が書き込まれると実行は再開されます。

最大サイズが指定できる Queue のサブクラス [c:Thread::SizedQueue] も提供されています。

### 例

`````
require 'thread'

q = Queue.new

th1 = Thread.start do
  while resource = q.pop
    puts resource
  end
end

[:resource1, :resource2, :resource3, nil].each{|r|
  q.push(r)
}

th1.join
`````

実行すると以下のように出力します。

`````
$ ruby que.rb
resource1
resource2
resource3
`````

## Class Methods

### def new -> Thread::Queue
#@since 3.1
### def new(items) -> Thread::Queue
#@end

新しいキューオブジェクトを生成します。

#@since 3.1
- **param** `items` -- 初期値を Enumerable で指定します。

```ruby
q = Queue.new
q = Queue.new([a, b, c])
q = Queue.new(items)
```
#@else
#@#noexample Thread::Queue#close 等を参照
#@end

## Instance methods

### def clear -> ()

キューを空にします。返り値は不定です。

```ruby title="例"
q = Queue.new

[:resource1, :resource2, :resource3, nil].each { |r| q.push(r) }

p q.length # => 4
q.clear
p q.length # => 0
```

### def empty? -> bool

キューが空の時、真を返します。

```ruby title="例"
q = Queue.new
p q.empty? # => true
q.push(:resource)
p q.empty? # => false
```

### def length -> Integer
### def size -> Integer

キューの長さを返します。

```ruby title="例"
q = Queue.new

[:resource1, :resource2, :resource3, nil].each { |r| q.push(r) }

p q.length # => 4
```

### def num_waiting -> Integer

キューを待っているスレッドの数を返します。

```ruby title="例"
require 'thread'

q = SizedQueue.new(1)
q.push(1)
t = Thread.new { q.push(2) }
sleep 0.05 until t.stop?
p q.num_waiting # => 1

q.pop
t.join
```

### def pop(non_block = false) -> object
### def shift(non_block = false) -> object
### def deq(non_block = false) -> object

キューからひとつ値を取り出します。キューが空の時、呼出元のスレッドは停止します。

- **param** `non_block` -- true を与えると、キューが空の時に例外 [c:ThreadError] が発生します。

```ruby title="例"
require 'thread'

q = Queue.new

th1 = Thread.start do
  while resource = q.pop
    puts resource
  end
end

[:resource1, :resource2, :resource3, nil].each { |r|
  q.push(r)
}

th1.join
```

```ruby title="例: nonblock = true"
require 'thread'

q = Queue.new

th1 = Thread.start do
  while resource = q.pop
    puts resource
  end
end

[:resource1, :resource2, :resource3, nil].each { |r|
  q.push(r)
}

begin
  th1.join
  q.pop(true)
rescue => e
  p e
end

# => resource1
# resource2
# resource3
# => #<ThreadError: queue empty>
# => "queue empty"
```

### def push(value) -> ()
### def <<(value)   -> ()
### def enq(value)  -> ()

キューの値を追加します。待っているスレッドがいれば実行を再開
させます。返り値は不定です。

#@#noexample 要約の例を参照

### def close -> self

キューを close します。close 済みのキューを再度 open することはできません。

close 後は以下のように動作します。

 - [m:Thread::Queue#closed?] は true を返します
 - [m:Thread::Queue#close] は無視されます
 - [m:Thread::Queue#enq]/push/<< は [c:ClosedQueueError] を発生します
 - [m:Thread::Queue#empty?] が false を返す場合は [m:Thread::Queue#deq]/pop/shift は通常通りオブジェクトを返します

また、[c:ClosedQueueError] は [c:StopIteration] を継承しているため、
close する事でループから脱出する事もできます。

例:

`````
q = Queue.new
Thread.new{
  while e = q.deq # wait for nil to break loop
    # ...
  end
}
q.close
`````

### def closed? -> bool

キューが close されている時に true を返します。

```ruby title="例"
q = Queue.new

[:resource1, :resource2, :resource3, nil].each { |r| q.push(r) }

p q.closed? # => false
q.close
p q.closed? # => true
```

