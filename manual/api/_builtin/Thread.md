---
library: _builtin
---
# class Thread < Object

スレッドを表すクラスです。スレッドとはメモリ空間を共有して同時に実行される制御の流れです。
Thread を使うことで並行プログラミングが可能になります。

#%include(thread.inc)

## Class Methods
### def Thread.abort_on_exception             -> bool
### def Thread.abort_on_exception=(newstate)

真の時は、いずれかのスレッドが例外によって終了した時に、その例外をメインスレッドで再度発生させます。メインスレッドがその例外を捕捉しない限り、結果としてインタプリタ全体が終了します。false の場合、あるスレッドで起こった例外は、[m:Thread#join]
などで検出されない限りそのスレッドだけをなにも警告を出さずに終了させます。

デフォルトは false です。

[ref:c:Thread#exception]を参照してください。

- **param** `newstate` -- スレッド実行中に例外が発生した場合、その例外をメインスレッドで再度発生させるかどうかを true か false で指定します。

```ruby title="例"
p Thread.abort_on_exception # => false
Thread.abort_on_exception = true
p Thread.abort_on_exception # => true
```

### def Thread.report_on_exception             -> bool
### def Thread.report_on_exception=(newstate)

真の時は、いずれかのスレッドが例外によって終了した時に、その内容を $stderr に報告します。

デフォルトは true です。

```ruby
Thread.new { 1.times { raise } }
```

は $stderr に以下のように出力します:

```text
#<Thread:...> terminated with exception (report_on_exception is true):
Traceback (most recent call last):
#%since 3.4
2: from -e:1:in 'block in <main>'
1: from -e:1:in 'times'
#%else
2: from -e:1:in `block in <main>'
1: from -e:1:in `times'
#%end
```

これによってスレッドのエラーを早期に捕捉できるようになります。
いくつかのケースでは、この出力を望まないかもしれません。
出力を抑制するには複数の方法があります:

- 例外が意図したものではない場合、原因を修正して例外が発生しないようにする方法が最善です。
- 例外が意図したものの場合、例外が発生する場所により近い場所で rescue して、
   その例外でスレッドが終了しないようにするのがより良い方法です。
- [m:Thread#join] や [m:Thread#value] でそのスレッドの終了を待つことが保証できるなら、
   スレッド開始時に Thread.current.report_on_exception = false でレポートを無効化しても
   安全です。しかし、この場合、例外をハンドルするのが遅れたり、親スレッドがブロックされていて
   終了を待つことができなかったりするかもしれません。

スレッドごとに設定する方法は [m:Thread#report_on_exception=] を参照してください。

- **param** `newstate` -- スレッド実行中に例外発生した場合、その内容を報告するかどうかを true か false で指定します。

### def Thread.ignore_deadlock -> bool

デッドロック検知を無視する機能のon/offを返します。

デフォルト値はfalseで、デッドロックが検知されます。

#%#noexample Thread.ignore_deadlock=を参照

- **SEE** [m:Thread.ignore_deadlock=]

### def Thread.ignore_deadlock=(bool)

デッドロック検知を無視する機能をon/offします。デフォルト値はfalseです。

trueを渡すとデッドロックを検知しなくなります。

```ruby
Thread.ignore_deadlock = true
queue = Thread::Queue.new

trap(:SIGUSR1){queue.push "Received signal"}

# ignore_deadlockがfalseだとエラーが発生する
puts queue.pop
```

- **SEE** [m:Thread.ignore_deadlock]

### def Thread.current    -> Thread

現在実行中のスレッド(カレントスレッド)を返します。

```ruby
p Thread.current # => #<Thread:0x4022e6fc run>
```

### def Thread.exit    -> ()

カレントスレッドに対して [m:Thread#exit] を呼びます。

#%#noexample Thread#exitを参照

### def Thread.kill(thread)    -> Thread

指定したスレッド thread に対して [m:Thread#exit] を呼びます。終了したスレッドを返します。

- **param** `thread` -- 終了したい Thread オブジェクトを指定します。

```ruby
th = Thread.new do
end
    
p Thread.kill(th)     # => #<Thread:0x40221bc8 dead>
```

### def Thread.list    -> [Thread]

全ての生きているスレッドを含む配列を生成して返します。aborting 状態であるスレッドも要素に含まれます。

```ruby
Thread.new do
  sleep 
end
sleep 0.1
  
p Thread.list   # => [#<Thread:0x40377a54 sleep>, #<Thread:0x4022e6fc run>]
```

### def Thread.main    -> Thread

メインスレッドを返します。

```ruby
p Thread.main # => #<Thread:0x4022e6fc run>
```

### def Thread.start(*arg) {|*arg| ... }       -> Thread
### def Thread.fork(*arg) {|*arg| ... }        -> Thread

スレッドを生成して、ブロックの評価を開始します。
生成したスレッドを返します。

基本的に [m:Thread.new] と同じですが、
new メソッドと違い initialize メソッドを呼びません。

- **param** `arg` -- 引数 arg はそのままブロックに渡されます。スレッドの開始と同時にその
           スレッド固有のローカル変数に値を渡すために使用します。

- **raise** `ThreadError` -- 現在のスレッドが属する [c:ThreadGroup] が freeze されている場合に発生します。またブロックを与えられずに呼ばれた場合にも発生します。

注意:

例えば、以下のコードは間違いです。スレッドの実行が開始される前に変数 i が書き変わる可能性があるからです。

```ruby
for i in 1..5
   Thread.start { p i }
end
```

上の例は以下のように書き直すべきです。

```ruby
for i in 1..5
   Thread.start(i) {|t| p t }
end
```

### def Thread.new(*arg) {|*arg| ... }         -> Thread

スレッドを生成して、ブロックの評価を開始します。
生成したスレッドを返します。

- **param** `arg` -- 引数 arg はそのままブロックに渡されます。スレッドの開始と同時にその
           スレッド固有のローカル変数に値を渡すために使用します。

- **raise** `ThreadError` -- 現在のスレッドが属する [c:ThreadGroup] が freeze されている場合に発生します。またブロックを与えられずに呼ばれた場合にも発生します。

注意:

例えば、以下のコードは間違いです。スレッドの実行が開始される前に変数 i が書き変わる可能性があるからです。

```ruby
for i in 1..5
   Thread.new { p i }
end
```

上の例は以下のように書き直すべきです。

```ruby
for i in 1..5
   Thread.new(i) {|t| p t }
end
```

### def Thread.pass    -> nil

他のスレッドに実行権を譲ります。実行中のスレッドの状態を変えずに、他の実行可能状態のスレッドに切り替わるよう、スレッドスケジューラにヒントを与えます。実際に切り替わるかどうか、また次にどのスレッドが実行されるかは OS
やスケジューラの実装に依存するため、保証されません。

```ruby
Thread.new do
  (1..3).each{|i|
    p i
    Thread.pass
  }
  exit
end
 
loop do
  Thread.pass
  p :main
end

# =>
1
:main
2
:main
3
:main
```

上記の出力は一例です。実行環境によって出力順序は異なり、保証されません。

### def Thread.stop     -> nil

他のスレッドから [m:Thread#run] メソッドで再起動されるまで、カレントスレッドの実行を停止します。

```ruby title="例"
a = Thread.new { print "a"; Thread.stop; print "c" }
sleep 0.1 while a.status!='sleep'
print "b"
a.run
a.join
# => "abc"
```

- **SEE** [m:Thread#run], [m:Thread#wakeup]

#%since 3.2
#%since 3.4
### def Thread.each_caller_location(start = 1, length = nil) {|location| ... } -> nil
### def Thread.each_caller_location(range) {|location| ... } -> nil
#%else
### def Thread.each_caller_location {|location| ... } -> nil
#%end

現在の実行スタックの各フレームを、[c:Thread::Backtrace::Location] オブジェクトとしてブロックに渡します。

[m:Kernel?.caller_locations] と似ていますが、配列を作らずにブロックへ順に渡すため、目的のフレームが見つかった時点で処理を打ち切るような用途で無駄な生成を避けられます。
#%since 3.4
引数の意味は [m:Kernel?.caller_locations] と同じで、ブロックに渡すフレームの範囲を指定できます。引数を渡せるのは Ruby 3.4 以降です。

- **param** `start` -- 開始フレームの位置を数値で指定します。

- **param** `length` -- ブロックに渡すフレームの個数を指定します。

- **param** `range` -- ブロックに渡したいフレームの範囲を示す [c:Range] オブジェクトを指定します。
#%end

nil を返します。

```ruby title="例"
def foo
  Thread.each_caller_location do |location|
    p location.class # => Thread::Backtrace::Location
    break
  end
end

foo
```

- **SEE** [m:Kernel?.caller_locations]
#%end

### def Thread.DEBUG -> Integer

スレッドのデバッグレベルを返します。

スレッドのデバッグレベルが 0 のときはなにもしません。
それ以外の場合は、スレッドのデバッグログを標準出力に出力します。
初期値は 0 です。
使用するためには、THREAD_DEBUG を -1 にして Ruby をコンパイルする必要があります。通常配布されている Ruby では利用できません。

```ruby title="例"
p Thread.DEBUG # => 0
```

- **SEE** [m:Thread.DEBUG=]

### def Thread.DEBUG=(val)

スレッドのデバッグレベルを val に設定します。

val が 真 のときは Integer に変換してから設定します。
偽 のときは 0 を設定します。
使用するためには、THREAD_DEBUG を -1 にして Ruby をコンパイルする必要があります。通常配布されている Ruby では利用できません。

```ruby title="例"
p Thread.DEBUG # => 0
Thread.DEBUG = 1
p Thread.DEBUG # => 1
```

- **SEE** [m:Thread.DEBUG]

#%# 参考: [[ruby-dev:45341]]
### def Thread.pending_interrupt?(error = nil) -> bool

非同期割り込みのキューが空かどうかを返します。

[m:Thread.handle_interrupt] は非同期割り込みの発生を延期させるのに使用しますが、本メソッドは任意の非同期割り込みが存在するかどうかを確認するのに使用します。

本メソッドが true を返した場合、[m:Thread.handle_interrupt] で例外の発生を延期するブロックを終了すると延期させられていた例外を発生させることができます。

- **param** `error` -- 対象の例外クラスを指定します。省略した場合は全ての例外を対
             象に確認を行います。

例: 延期させられていた例外をただちに発生させる。

```ruby
def Thread.kick_interrupt_immediately
  Thread.handle_interrupt(Object => :immediate) {
    Thread.pass
  }
end
```

### 使い方

```ruby
th = Thread.new{
  Thread.handle_interrupt(RuntimeError => :on_blocking){
    while true
      # ...
      # ここまでで割り込みが発生しても安全な状態になった。
      if Thread.pending_interrupt?
        Thread.handle_interrupt(Object => :immediate){}
      end
      # ...
    end
  }
}
# ...
th.raise # スレッド停止。
```

この例は以下のように記述する事もできます。

```ruby
flag = true
th = Thread.new{
  Thread.handle_interrupt(RuntimeError => :on_blocking){
    while true
      # ...
      # ここまでで割り込みが発生しても安全な状態になった。
      break if flag == false
      # ...
    end
  }
}
# ...
flag = false # スレッド停止
```

- **SEE** [m:Thread#pending_interrupt?], [m:Thread.handle_interrupt]

### def Thread.handle_interrupt(hash) { ... } -> object

スレッドの割り込みのタイミングを引数で指定した内容に変更してブロックを実行します。

「割り込み」とは、非同期イベントや [m:Thread#raise] や
[m:Thread#kill]、[m:Signal?.trap](未サポート)、メインスレッドの終了
(メインスレッドが終了すると、他のスレッドも終了されます)を意味します。

- **param** `hash` -- 例外クラスがキー、割り込みのタイミングを指定する
            [c:Symbol] が値の [c:Hash] を指定します。
            値の内容は以下のいずれかです。

- **`:immediate`**:

  すぐに割り込みます。

- **`:on_blocking`**:

  ブロッキング処理(後述)の間は割り込みが発生します。

- **`:never`**:

  まったく割り込みません。

「ブロッキング処理」とは、読み込み処理や書き込み処理のような呼び出し元のスレッドをブロックするような処理を意味します。CRuby の実装では、GVL
を解放して実行する処理は全てブロッキング処理に含まれます。

また、マスクされた非同期割り込みは再度有効にされるまで延期されます。本メソッドは [man:sigprocmask(3)] に似ています。

- **return** -- ブロックの評価結果を返します。

- **raise** `ArgumentError` -- ブロックを指定しなかった場合に発生します。

### 注意

非同期割り込みの利用は難しいため、スレッド間での通信を実現する場合はまずはキューのような他の方法を検討してください。それでも非同期割り込みを利用する場合は本メソッドをよく理解してから利用してください。

### 使い方

例:[m:Thread#raise] 発生のタイミングを制御する例

```ruby
th = Thread.new do
  Thread.handle_interrupt(RuntimeError => :never) {
    begin
      # 安全にリソースの割り当てが可能
      Thread.handle_interrupt(RuntimeError => :immediate) {
        # ...
      }
    ensure
      # 安全にリソースの解放が可能
    end
  }
end
Thread.pass
# ...
th.raise "stop"
```

[c:RuntimeError] を無視(延期)している間はリソースの割り当てや ensure
節でリソースの解放を安全に行う事ができます。

#### Timeout::Error 対策

例:[c:Timeout::Error] 発生のタイミングを制御する例

```ruby
require 'timeout'
Thread.handle_interrupt(Timeout::Error => :never) {
  Timeout.timeout(10){
    # Timeout::Error => :never の指定により、ここでは Timeout::Error が発生しない。
    Thread.handle_interrupt(Timeout::Error => :on_blocking) {
      # :on_blocking な処理は Timeout::Error が発生し得る。
    }
    # Timeout::Error => :never の指定により、ここでは Timeout::Error が発生しない。
  }
}
```

この例を ensure 節での [c:Timeout::Error] 発生に応用する事でリソースリークに備える事ができます。[m:Timeout?.timeout] はスレッドを使って実装されているため、Thread.handle_interrupt による制御が有効です。

#### Stack control settings

It's possible to stack multiple levels of ::handle_interrupt blocks in order
to control more than one ExceptionClass and TimingSymbol at a time.

```ruby
Thread.handle_interrupt(FooError => :never) {
  Thread.handle_interrupt(BarError => :never) {
     # FooError and BarError are prohibited.
  }
}
```

#### 例外クラスの継承関係

本メソッドでは引数 hash のキーに指定した例外クラスの全てのサブクラスが処理の対象になります。

```ruby title="例"
Thread.handle_interrupt(Exception => :never) {
  # Exception を継承する全ての例外クラスの例外の発生を延期。
}
```

- **SEE** [m:Thread.pending_interrupt?], [m:Thread#pending_interrupt?]

## Instance Methods

### def [](name)    -> object | nil

name に対応したスレッドに固有のデータを取り出します。
name に対応するスレッド固有データがなければ nil を返します。

- **param** `name` -- スレッド固有データのキーを文字列か [c:Symbol] で指定します。

```ruby title="例"
[
  Thread.new { Thread.current["name"] = "A" },
  Thread.new { Thread.current[:name]  = "B" },
  Thread.new { Thread.current["name"] = "C" }
].each do |th|
  th.join
  puts "#{th.inspect}: #{th[:name]}"
end

# => #<Thread:0x00000002a54220 dead>: A
# => #<Thread:0x00000002a541a8 dead>: B
# => #<Thread:0x00000002a54130 dead>: C
```

[m:Thread#\[\]] と [m:Thread#\[\]=] を用いたスレッド固有の変数は
Fiber を切り替えると異なる変数を返す事に注意してください。

```ruby
def meth(newvalue)
  begin
    oldvalue = Thread.current[:name]
    Thread.current[:name] = newvalue
    yield
  ensure
    Thread.current[:name] = oldvalue
  end
end
```

この関数に与えるブロックがFiberを切り替える場合は動的スコープとしては正しく動作しません。

```ruby
f = Fiber.new {
  meth(1) {
    Fiber.yield
  }
}
meth(2) {
  f.resume
}
f.resume
p Thread.current[:name]
# => nil if fiber-local
# => 2 if thread-local (The value 2 is leaked to outside of meth method.)
```

Fiber を切り替えても同じ変数を返したい場合は
[m:Thread#thread_variable_get] と [m:Thread#thread_variable_set]
を使用してください。

- **SEE** [m:Thread#fetch], [m:Thread#\[\]=]

### def []=(name,val)

val を name に対応するスレッド固有のデータとして格納します。

- **param** `name` -- スレッド固有データのキーを文字列か [c:Symbol] で指定します。文字列を指定した場合は [m:String#to_sym] によりシンボルに変換されます。

- **param** `val` -- スレッド固有データを指定します。nil を指定するとそのスレッド固有データは削除されます。

#%#noexample Thread#[]を参照

- **SEE** [m:Thread#\[\]]

### def fetch(name, default = nil) {|name| ... } -> object

name に関連づけられたスレッドに固有のデータを返します。
name に対応するスレッド固有データがない時には、引数 default が与えられていればその値を、ブロックが与えられていればそのブロックを評価した値を返します。

- **param** `name` -- スレッド固有データのキーを文字列か [c:Symbol] で指定します。
- **param** `default` -- name に対応するスレッド固有データがない時の返り値を指定します。
- **raise** `KeyError` -- 引数defaultもブロックも与えられてない時、
                name に対応するスレッド固有データがないと発生します。

```ruby title="例"
th = Thread.new { Thread.current[:name] = 'A' }
th.join
p th.fetch(:name) # => "A"
p th.fetch(:fetch, 'B') # => "B"
p th.fetch('name')  {|name| "Thread" + name}  # => "A"
p th.fetch('fetch') {|name| "Thread" + name}  # => "Threadfetch"
```

- **SEE** [m:Thread#\[\]]

### def abort_on_exception               -> bool
### def abort_on_exception=(newstate)

真の場合、そのスレッドが例外によって終了した時に、その例外をメインスレッドで再度発生させます。メインスレッドがその例外を捕捉しない限り、結果としてインタプリタ全体が終了します。false の場合、あるスレッドで起こった例外は、
[m:Thread#join] などで検出されない限りそのスレッドだけをなにも警告を出さずに終了させます。

デフォルトは偽です。[ref:c:Thread#exception]を参照してください。

- **param** `newstate` -- 自身の実行中に例外が発生した場合、その例外をメインスレッドで再度発生させるかどうかを true か false で指定します。

```ruby title="例"
thread = Thread.new { sleep 1 }
p thread.abort_on_exception # => false
thread.abort_on_exception = true
p thread.abort_on_exception # => true
```

### def report_on_exception               -> bool
### def report_on_exception=(newstate)

真の場合、そのスレッドが例外によって終了した時に、その内容を $stderr に報告します。

デフォルトはスレッド作成時の [m:Thread.report_on_exception] です。

- **param** `newstate` -- スレッド実行中に例外発生した場合、その内容を報告するかどうかを true か false で指定します。

```ruby title="例"
a = Thread.new{ Thread.stop; raise }
a.report_on_exception = true
p a.report_on_exception # => true
a.run
# => #<Thread:0x00007fc3f48c7908 (irb):1 run> terminated with exception (report_on_exception is true):
#    Traceback (most recent call last):
#%since 3.4
#    (irb):1:in 'block in irb_binding': unhandled exception
#%else
#    (irb):1:in `block in irb_binding': unhandled exception
#%end
#    #<Thread:0x00007fc3f48c7908 (irb):1 dead>
b = Thread.new{ Thread.stop; raise }
b.report_on_exception = false
p b.run # => #<Thread:0x00007fc3f48aefc0 (irb):4 dead>
```

- **SEE** [m:Thread.report_on_exception]

### def alive?     -> bool

スレッドが「生きている」時、true を返します。

```ruby title="例"
thr = Thread.new { }
p thr.join              # => #<Thread:0x401b3fb0 dead>
p Thread.current.alive? # => true
p thr.alive?            # => false
```

[m:Thread#status] が真を返すなら、このメソッドも真です。

- **SEE** [m:Thread#status], [m:Thread#stop?]

### def exit         -> self
### def kill         -> self
### def terminate    -> self

スレッドの実行を終了させます。終了時に ensure 節が実行されます。

ただし、スレッドは終了処理中(aborting)にはなりますが、直ちに終了するとは限りません。すでに終了している場合は何もしません。このメソッドにより終了したスレッドの [m:Thread#value] の返り値は不定です。
自身がメインスレッドであるか最後のスレッドである場合は、プロセスを [m:Kernel?.exit](0) 
により終了します。

[m:Kernel?.exit] と違い例外  [c:SystemExit] を発生しません。

```ruby
th1 = Thread.new do
  begin
    sleep 10
  ensure
    p "this will be displayed"
  end
end

sleep 0.1
th1.kill

# => "this will be displayed"
```

- **SEE** [m:Kernel?.exit], [m:Kernel?.exit!]

### def group    -> ThreadGroup

スレッドが属している [c:ThreadGroup] オブジェクトを返します。

```ruby
p Thread.current.group == ThreadGroup::Default
# => true
```

### def join           -> self
### def join(limit)    -> self | nil

スレッド self の実行が終了するまで、カレントスレッドを停止します。self が例外により終了していれば、その例外がカレントスレッドに対して発生します。

limit を指定して、limit 秒過ぎても自身が終了しない場合、nil を返します。

- **param** `limit` -- タイムアウトする時間を整数か小数で指定します。単位は秒です。

- **raise** `ThreadError` -- join を実行することによってデッドロックが起きる場合に発生します。またカレントスレッドを join したときにも発生します。

以下は、生成したすべてのスレッドの終了を待つ例です。

```ruby
threads = []
threads.push(Thread.new { n = rand(5); sleep n; n })
threads.push(Thread.new { n = rand(5); sleep n; n })
threads.push(Thread.new { n = rand(5); sleep n; n })

threads.each {|t| t.join}
```

### def key?(name)     -> bool

name に対応したスレッドに固有のデータが定義されていれば
true を返します。

- **param** `name` -- 文字列か [c:Symbol] で指定します。

```ruby title="例"
me = Thread.current
me[:oliver] = "a"
p me.key?(:oliver)  # => true
p me.key?(:stanley) # => false
```

### def keys    -> [Symbol]

スレッド固有データに関連づけられたキーの配列を返します。キーは
[c:Symbol] で返されます。

```ruby
th = Thread.current
th[:foo] = 'FOO'
th['bar'] = 'BAR'
p th.keys

# => [:bar, :foo]
```

### def priority    -> Integer
### def priority=(val)

スレッドの優先度を返します。この値が大きいほど優先度が高くなります。
メインスレッドのデフォルト値は 0 です。新しく生成されたスレッドは親スレッドの
priority を引き継ぎます。

- **param** `val` -- スレッドの優先度を指定します。プラットフォームに依存します。

```ruby title="例"
p Thread.current.priority # => 0

count1 = count2 = 0
a = Thread.new do
      loop { count1 += 1 }
    end
a.priority = -1

b = Thread.new do
      loop { count2 += 1 }
    end
b.priority = -2
count1 = count2 = 0 # reset
p sleep 1 # => 1
p count1  # => 13809431
p count2  # => 11571921
```

### def raise(error_type, message, traceback)     -> ()

自身が表すスレッドで強制的に例外を発生させます。

- **param** `error_type` -- [m:Kernel?.raise] を参照してください。

- **param** `message` -- [m:Kernel?.raise] を参照してください。

- **param** `traceback` -- [m:Kernel?.raise] を参照してください。

```text
Thread.new {
  sleep 1
  Thread.main.raise "foobar"
}

begin
  sleep
rescue
  p $!, $@
end

=> #<RuntimeError: foobar>
   ["-:3"]
```

### def run    -> self

停止状態(stop)のスレッドを再開させます。
[m:Thread#wakeup] と異なりすぐにスレッドの切り替えを行います。

- **raise** `ThreadError` -- 死んでいるスレッドに対して実行すると発生します。

```ruby title="例"
a = Thread.new { puts "a"; Thread.stop; puts "c" }
sleep 0.1 while a.status!='sleep'
puts "Got here"
a.run
a.join
# => a
# => Got here
# => c
```

- **SEE** [m:Thread#wakeup], [m:Thread.stop]

### def status    -> String | false | nil

生きているスレッドの状態を文字列 "run"、"sleep", "aborting" のいずれかで返します。正常終了したスレッドに対して false、例外により終了したスレッドに対して nil を返します。
#%#((-((<ruby 1.6 feature>)): version 1.6.5 までは、終了処理中
#%#(aborting)のスレッドに対しては "run" を返していました-))

[m:Thread#alive?] が真を返すなら、このメソッドも真です。

```ruby title="例"
p Thread.current.status # => "run"

a = Thread.new { raise("die now") }
sleep 0.1
p a.status              # => nil

b = Thread.new { Thread.stop }
sleep 0.1
p b.status              # => "sleep"

c = Thread.new { Thread.exit }
sleep 0.1
p c.status              # => false

d = Thread.new { sleep }
sleep 0.1
p d.status              # => "sleep"
d.kill
sleep 0.1
p d.status              # => false
```

- **SEE** [m:Thread#alive?], [m:Thread#stop?]

### def stop?    -> bool

スレッドが終了(dead)あるいは停止(stop)している時、true を返します。

```ruby title="例"
a = Thread.new { Thread.stop }
b = Thread.current
p a.stop? # => true
p b.stop? # => false
```

- **SEE** [m:Thread#alive?], [m:Thread#status]

### def value    -> object 

スレッド self が終了するまで待ち([m:Thread#join] と同じ)、そのスレッドのブロックが返した値を返します。スレッド実行中に例外が発生した場合には、その例外を再発生させます。

スレッドが [m:Thread#kill] によって終了した場合は、返り値は不定です。

以下は、生成したすべてのスレッドの終了を待ち結果を出力する例です。

```ruby
threads = []
threads.push(Thread.new { n = rand(5); sleep n; n })
threads.push(Thread.new { n = rand(5); sleep n; n })
threads.push(Thread.new { n = rand(5); sleep n; n })

threads.each {|t| p t.value}
```

最後の行で、待ち合わせを行っていることがわかりにくいと思うなら以下のように書くこともできます。

```ruby
threads.each {|t| p t.join.value}
```

### def wakeup    -> self

停止状態(stop)のスレッドを実行可能状態(run)にします。

- **raise** `ThreadError` -- 死んでいるスレッドに対して実行すると発生します。

```ruby title="例"
c = Thread.new { Thread.stop; puts "hey!" }
sleep 0.1 while c.status!='sleep'
c.wakeup
c.join
# => "hey!"
```

- **SEE** [m:Thread#run], [m:Thread.stop]

### def inspect -> String
### def to_s -> String
{: since=""}

自身を人間が読める形式に変換した文字列を返します。

```ruby title="例"
a = Thread.current
p a.inspect # => "#<Thread:0x00007fdbaf07ddb0 run>"
b = Thread.new{}
p b.inspect # => "#<Thread:0x00007fdbaf8f7d10 (irb):3 dead>"
```

### def add_trace_func(pr) -> Proc

スレッドにトレース用ハンドラを追加します。

追加したハンドラを返します。

- **param** `pr` -- トレースハンドラ([c:Proc] オブジェクト)

```ruby title="例"
th = Thread.new do
  class Trace
  end
  43.to_s
end
th.add_trace_func lambda {|*arg| p arg }
th.join

# => ["line", "example.rb", 4, nil, #<Binding:0x00007f98e107d0d8>, nil]
# => ["c-call", "example.rb", 4, :inherited, #<Binding:0x00007f98e1087448>, Class]
# => ["c-return", "example.rb", 4, :inherited, #<Binding:0x00007f98e1085d00>, Class]
# => ["class", "example.rb", 4, nil, #<Binding:0x00007f98e108f210>, nil]
# => ["end", "example.rb", 5, nil, #<Binding:0x00007f98e108e5e0>, nil]
# => ["line", "example.rb", 6, nil, #<Binding:0x00007f98e108d4b0>, nil]
# => ["c-call", "example.rb", 6, :to_s, #<Binding:0x00007f98e1097aa0>, Integer]
# => ["c-return", "example.rb", 6, :to_s, #<Binding:0x00007f98e1095cc8>, Integer]
```

- **SEE** [m:Thread#set_trace_func] [m:Kernel?.set_trace_func]

### def set_trace_func(pr) -> Proc | nil
{: since="1.9.2"}

スレッドにトレース用ハンドラを設定します。

nil を渡すとトレースを解除します。

設定したハンドラを返します。

```ruby title="例"
th = Thread.new do
  class Trace
  end
  2.to_s
  Thread.current.set_trace_func nil
  3.to_s
end
th.set_trace_func lambda {|*arg| p arg }
th.join

# => ["line", "example.rb", 2, nil, #<Binding:0x00007fc8de87cb08>, nil]
# => ["c-call", "example.rb", 2, :inherited, #<Binding:0x00007fc8de886770>, Class]
# => ["c-return", "example.rb", 2, :inherited, #<Binding:0x00007fc8de8844e8>, Class]
# => ["class", "example.rb", 2, nil, #<Binding:0x00007fc8de88e830>, nil]
# => ["end", "example.rb", 3, nil, #<Binding:0x00007fc8de88d6b0>, nil]
# => ["line", "example.rb", 4, nil, #<Binding:0x00007fc8de88c440>, nil]
# => ["c-call", "example.rb", 4, :to_s, #<Binding:0x00007fc8de896f30>, Integer]
# => ["c-return", "example.rb", 4, :to_s, #<Binding:0x00007fc8de894a50>, Integer]
# => ["line", "example.rb", 5, nil, #<Binding:0x00007fc8de967b08>, nil]
# => ["c-call", "example.rb", 5, :current, #<Binding:0x00007fc8de967798>, Thread]
# => ["c-return", "example.rb", 5, :current, #<Binding:0x00007fc8de9673b0>, Thread]
# => ["c-call", "example.rb", 5, :set_trace_func, #<Binding:0x00007fc8de966fc8>, Thread]
```

- **param** `pr` -- トレースハンドラ([c:Proc] オブジェクト) もしくは nil
- **SEE** [m:Thread#add_trace_func] [m:Kernel?.set_trace_func]

### def backtrace    -> [String] | nil

スレッドの現在のバックトレースを返します。

スレッドがすでに終了している場合は nil を返します。

```ruby title="例"
class C1
  def m1
    sleep 5
  end
  def m2
    m1
  end
end

th = Thread.new {C1.new.m2; Thread.stop}
p th.backtrace
# => [
#%since 3.4
#      [0] "(irb):3:in 'sleep'",
#      [1] "(irb):3:in 'm1'",
#      [2] "(irb):6:in 'm2'",
#      [3] "(irb):10:in 'block in irb_binding'"
#%else
#      [0] "(irb):3:in `sleep'",
#      [1] "(irb):3:in `m1'",
#      [2] "(irb):6:in `m2'",
#      [3] "(irb):10:in `block in irb_binding'"
#%end
#    ]

th.kill
p th.backtrace # => nil
```

### def backtrace_locations(start = 0, length = nil) -> [Thread::Backtrace::Location] | nil
### def backtrace_locations(range)                   -> [Thread::Backtrace::Location] | nil

スレッドの現在のバックトレースを [c:Thread::Backtrace::Location] の配列で返します。

引数で指定した値が範囲外の場合、スレッドがすでに終了している場合は nil
を返します。

- **param** `start` -- 開始フレームの位置を数値で指定します。

- **param** `length` -- 取得するフレームの個数を指定します。

- **param** `range` -- 取得したいフレームの範囲を示す Range オブジェクトを指定します。

[m:Kernel?.caller_locations] と似ていますが、本メソッドは self に限定した情報を返します。

```ruby title="例"
thread = Thread.new { sleep 1 }
thread.run
#%since 3.4
p thread.backtrace_locations # => ["/path/to/test.rb:1:in 'sleep'", "/path/to/test.rb:1:in 'block in <main>'"]
#%else
p thread.backtrace_locations # => ["/path/to/test.rb:1:in `sleep'", "/path/to/test.rb:1:in `block in <main>'"]
#%end
```

- **SEE** [c:Thread::Backtrace::Location]

### def thread_variable_get(key) -> object | nil

引数 key で指定した名前のスレッドローカル変数を返します。

[注意]: [m:Thread#\[\]] でセットしたローカル変数(Fiber ローカル変数)と異なり、Fiber を切り替えても同じ変数を返す事に注意してください。

```ruby title="例"
Thread.new {
  Thread.current.thread_variable_set("foo", "bar") # スレッドローカル
  Thread.current["foo"] = "bar"                    # Fiber ローカル

  Fiber.new {
    Fiber.yield [
      Thread.current.thread_variable_get("foo"), # スレッドローカル
      Thread.current["foo"],                     # Fiber ローカル
    ]
  }.resume
}.join.value # => ['bar', nil]
```

この例の "bar" は [m:Thread#thread_variable_get] により得られた値で、nil は[m:Thread#\[\]] により得られた値です。

- **SEE** [m:Thread#thread_variable_set], [m:Thread#\[\]]

- **SEE** <https://magazine.rubyist.net/articles/0041/0041-200Special-note.html>

### def thread_variable_set(key, value)

引数 key で指定した名前のスレッドローカル変数に引数 value をセットします。

[注意]: [m:Thread#\[\]] でセットしたローカル変数(Fiber ローカル変数)と異なり、セットした変数は Fiber を切り替えても共通で使える事に注意してください。

```ruby title="例"
thr = Thread.new do
  Thread.current.thread_variable_set(:cat, 'meow')
  Thread.current.thread_variable_set("dog", 'woof')
end
p thr.join             # => #<Thread:0x401b3f10 dead>
p thr.thread_variables # => [:cat, :dog]
```

- **SEE** [m:Thread#thread_variable_get], [m:Thread#thread_variables], [m:Thread#\[\]]

### def thread_variable?(key) -> bool

引数 key で指定した名前のスレッドローカル変数が存在する場合に true、そうでない場合に false を返します。

- **param** `key` -- 変数名を [c:String] か [c:Symbol] で指定します。

```ruby
me = Thread.current
me.thread_variable_set(:oliver, "a")
p me.thread_variable?(:oliver)  # => true
p me.thread_variable?(:stanley) # => false
```

[注意]: [m:Thread#\[\]] でセットしたローカル変数(Fiber ローカル変数)が対象ではない事に注意してください。

- **SEE** [m:Thread#thread_variable_get], [m:Thread#\[\]]

### def thread_variables -> [Symbol]

スレッドローカル変数の名前を [c:Symbol] の配列で返します。

[注意]: [m:Thread#\[\]] でセットしたローカル変数(Fiber ローカル変数)は対象ではない事に注意してください。

```ruby title="例"
thr = Thread.new do
  Thread.current.thread_variable_set(:cat, 'meow')
  Thread.current.thread_variable_set("dog", 'woof')
end
thr.join
p thr.thread_variables # => [:cat, :dog]
```

- **SEE** [m:Thread#thread_variable_get], [m:Thread#thread_variable?], [m:Thread#\[\]]

#%since 3.1
### def native_thread_id -> Integer | nil

self に対応するネイティブスレッドの ID を返します。

ID は OS に依存します(pthread_self(3) が返す POSIX スレッド ID とは異なります)。

  * Linux では gettid(2) が返す TID です。
  * macOS では pthread_threadid_np(3) が返すシステム全体で一意な整数の ID です。
  * FreeBSD では pthread_getthreadid_np(3) が返すスレッド固有の整数の ID です。
  * Windows では GetThreadId() が返すスレッド識別子です。
  * その他のプラットフォームでは [c:NotImplementedError] が発生します。

スレッドがまだネイティブスレッドと結びついていない場合や、すでに切り離された場合は nil を返します。

```ruby title="例"
p Thread.current.native_thread_id.class # => Integer

thr = Thread.new {}
thr.join
p thr.native_thread_id                  # => nil
```

#%end

### def pending_interrupt?(error = nil) -> bool

self の非同期例外のキューが空かどうかを返します。

- **param** `error` -- 対象の例外クラスを指定します。

#%#noexample Thread.pending_interrupt? を参照

- **SEE** [m:Thread.pending_interrupt?]

### def name -> String

self の名前を返します。

#%#noexample Thread#name=を参照

- **SEE** [m:Thread#name=]

### def name=(name)

self の名前を name に設定します。

プラットフォームによっては pthread やカーネルにも設定を行う場合があります。

- **raise** `ArgumentError` -- 引数に ASCII 互換ではないエンコーディングのものを
                     指定した場合に発生します。

```ruby title="例"
a = Thread.new{}
a.name = 'named'
p a.name    # => "named"
p a.inspect # => "#<Thread:0x00007f85ac8721f0@named (irb):1 dead>"
```

- **SEE** [m:Thread#name]
