---
library: _builtin
alias:
  - SizedQueue
---
# class Thread::SizedQueue < Thread::Queue

サイズの最大値を指定できる [c:Thread::Queue] です。

### 例

[ruby-list:283] より。q をサイズ 1 の SizedQueue オブジェクトに
することによって、入力される行と出力される行が同じ順序になります。
q = [] にすると入力と違った順序で行が出力されます。

`````
require 'thread'

q = SizedQueue.new(1)

th = Thread.start {
  while line = q.pop
    print line
  end
}

while l = gets
  q.push(l)
end
q.push(l)

th.join
`````

## Class Methods

#@since 2.1.0
### def new(max) -> Thread::SizedQueue
Thread::SizedQueue オブジェクトを生成します。
#@else
### def new(max) -> SizedQueue
SizedQueue オブジェクトを生成します。
#@end

- **param** `max` -- キューのサイズの最大値です。

#@#noexample 要約の例を参照

## Instance Methods

### def max -> Integer
キューの最大サイズを返します。

```ruby title="例"
q = SizedQueue.new(4)
q.max # => 4
```

### def max=(n)
キューの最大サイズを設定します。

- **param** `n` -- キューの最大サイズを指定します。

```ruby title="例"
#@until 2.3.0
require 'thread'
#@end
q = SizedQueue.new(4)
q.max # => 4
q.max = 5
q.max # => 5
```

#@since 2.2.0
### def push(obj, non_block = false) -> ()
### def enq(obj, non_block = false)  -> ()
### def <<(obj)                      -> ()
#@else
### def push(obj) -> ()
### def <<(obj)   -> ()
### def enq(obj)  -> ()
#@end

キューに与えられたオブジェクトを追加します。

#@since 2.1.0
キューのサイズが [m:Thread::SizedQueue#max] に達している場合は、
#@since 2.2.0
non_block が真でなければ、キューのサイズが [m:Thread::SizedQueue#max]
より小さくなるまで他のスレッドに実行を譲ります。
#@else
キューのサイズが [m:Thread::SizedQueue#max] より小さくなるまで他のスレッドに実行を譲ります。
#@end
その後、キューに与えられたオブジェクトを追加します。

- **param** `obj` -- キューに追加したいオブジェクトを指定します。
#@since 2.2.0
- **param** `non_block` -- true を与えると、キューが一杯の時に例外 [c:ThreadError] が発生します。
#@end

#@#noexample 要約の例を参照
- **SEE** [m:Thread::Queue#push]
#@else
キューのサイズが [m:SizedQueue#max] に達している場合は、
キューのサイズが [m:SizedQueue#max] より小さくなるまで他のスレッドに実行を譲ります。
その後、キューに与えられたオブジェクトを追加します。

- **param** `obj` -- キューに追加したいオブジェクトを指定します。

#@#noexample 要約の例を参照
- **SEE** [m:Queue#push]
#@end

### def pop(non_block = false)   -> object
### def shift(non_block = false) -> object
### def deq(non_block = false)   -> object

キューからひとつ値を取り出します。
キューに push しようと待っているスレッドがあれば、実行を再開させます。

- **param** `non_block` -- true を与えると、キューが空の時に例外 [c:ThreadError] が発生します。

```ruby title="例"
require 'thread'

q = SizedQueue.new(4)

th1 = Thread.start do
  while resource = q.pop
    puts resource
  end
end

[:resource1, :resource2, :resource3, nil].each{|r|
  q.push(r)
}

th1.join
# => resource1
# resource2
# resource3
```

```ruby title="例: nonblock = true"
require 'thread'

q = SizedQueue.new(4)

th1 = Thread.start do
  while resource = q.pop
    puts resource
  end
end

[:resource1, :resource2, :resource3, nil].each{|r|
  q.push(r)
}

begin
  th1.join
  q.pop(true)
rescue => e
  p e
  p e.message
end

# => resource1
# resource2
# resource3
# => #<ThreadError: queue empty>
# => "queue empty"
```

#@since 2.1.0
- **SEE** [m:Thread::Queue#pop]
#@else
- **SEE** [m:Queue#pop]
#@end

#@since 2.3.0
### def close -> self

キューを close します。詳しくは [m:Thread::Queue#close] を参照してください。

[c:Thread::Queue] とはキューにオブジェクトを追加するスレッドの動作が
異なります。キューにオブジェクトを追加するスレッドを待機している場合は
[c:ClosedQueueError] が発生して中断されます。

```ruby title="例"
q = SizedQueue.new(4)

[:resource1, :resource2, :resource3, nil].each { |r| q.push(r) }

q.closed? # => false
q.close
q.closed? # => true
```

- **SEE** [m:Thread::Queue#close]
#@end
#@since 2.5.0
### def empty? -> bool

キューが空の時、真を返します。

### def length -> Integer
### def size -> Integer

キューの長さを返します。
#@end
