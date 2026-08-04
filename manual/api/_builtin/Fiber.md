---
library: _builtin
since: "1.9.1"
---
# class FiberError < StandardError

Fiber に関するエラーが起きると発生します。

# class Fiber

ノンプリエンプティブな軽量スレッド(以下ファイバーと呼ぶ)を提供します。
他の言語では coroutine あるいは semicoroutine と呼ばれることもあります。
[c:Thread] と違いユーザレベルスレッドとして実装されています。

[c:Thread] クラスが表すスレッドと違い、明示的に指定しない限りファイバーのコンテキストは切り替わりません。
またファイバーは親子関係を持ちます。Fiber#resume を呼んだファイバーが親になり呼ばれたファイバーが子になります。親子関係を壊すような遷移(例えば自分の親の親のファイバーへ切り替えるような処理)はできません。
例外 FiberError が発生します。
できることは
- Fiber#resume により子へコンテキストを切り替える
- Fiber.yield により親へコンテキストを切り替える
の二通りです。この親子関係は一時的なものであり親ファイバーへコンテキストを切り替えた時点で解消されます。

ファイバーが終了するとその親にコンテキストが切り替わります。

#%since 3.1
Ruby 3.1 から fiber を require しなくても、コンテキストの切り替えに制限のない [m:Fiber#transfer] が使えます。
#%else
なお標準添付ライブラリ [lib:fiber] を require することにより、コンテキストの切り替えに制限のない [m:Fiber#transfer] が使えるようになります。
#%end
任意のファイバーにコンテキストを切り替えることができます。

### 例外

ファイバー実行中に例外が発生した場合、親ファイバーに例外が伝播します。

```ruby title="例:"
f = Fiber.new do
  raise StandardError, "hoge"
end

begin
f.resume     # ここでも StandardError が発生する。
rescue => e
p e.message  #=> "hoge"
end
```

### ショートチュートリアル

ファイバーは処理のあるポイントで他のルーチンにコンテキストを切り替え、またそのポイントから再開するという目的のために使います。
[m:Fiber.new] により与えられたブロックとともにファイバーを生成します。
生成したファイバーに対して [m:Fiber#resume] を呼ぶことによりコンテキストを切り替えます。
子ファイバーのブロック中で [m:Fiber.yield] を呼ぶと親にコンテキストを切り替えます。
Fiber.yield の引数が、親での Fiber#resume の返り値になります。

```ruby title="例:"
f = Fiber.new do
  n = 0
  loop do
    Fiber.yield(n)
    n += 1
  end
end

5.times do
 p f.resume
end

#=> 0
    1
    2
    3
    4
```

以下は内部イテレータを外部イテレータに変換する例です。
実際 [c:Enumerator] は Fiber を用いて実装されています。

```ruby title="例:"
def enum2gen(enum)
  Fiber.new do
    enum.each{|i|
      Fiber.yield(i)
    }
  end
end
 
g = enum2gen(1..100)
 
p g.resume  #=> 1
p g.resume  #=> 2
p g.resume  #=> 3
```

### 注意

Thread クラスが表すスレッド間をまたがるファイバーの切り替えはできません。
例外 FiberError が発生します。

```ruby title="例:"
f = nil
Thread.new do
  f = Fiber.new{}
end.join
f.resume
#%since 3.4
#=> t.rb:5:in 'Fiber#resume': fiber called across threads (FiberError)
#      from t.rb:5:in '<main>'
#%else
#=> t.rb:5:in `resume': fiber called across threads (FiberError)
#      from t.rb:5:in `<main>'
#%end
```

### ノンブロッキングファイバーとスケジューラ {#nonblocking}

Ruby 3.0 から、ファイバーはブロッキングとノンブロッキングのどちらかの実行コンテキストを持ちます。
[m:Fiber.new] は既定でノンブロッキングなファイバーを生成します。
`blocking: true` を指定するとブロッキングなファイバーになります。

ノンブロッキングファイバーの中でブロックしうる操作を行うと、その操作はスケジューラに委譲されます。
ブロックしうる操作とは、IO 待ちやスリープなどです。
スケジューラは [m:Fiber.set_scheduler] でスレッドごとに設定します。

スケジューラを設定していない場合、ノンブロッキングファイバーはブロッキングファイバーと同じ動作になります。
つまりノンブロッキングファイバーであること自体は実行の挙動を変えません。

スケジューラは Ruby 本体では提供されていません。
フックメソッドを実装したオブジェクトを利用者が用意します。
実装すべきメソッドは [Ruby 本体の Fiber::Scheduler のドキュメント](https://docs.ruby-lang.org/en/4.0/Fiber/Scheduler.html)で説明されています。

現在の実行コンテキストがどちらであるかは [m:Fiber.blocking?] で調べられます。
また [m:Fiber.schedule] を使うと、スケジューラ経由でノンブロッキングファイバーを生成できます。

## Class Methods
#%since 3.1
#%include(Fiber.current)
#%end

#%since 3.2
### def Fiber.new(blocking: false, storage: true) {|obj| ... } -> Fiber
#%else
### def Fiber.new(blocking: false) {|obj| ... } -> Fiber
#%else
#%end

与えられたブロックとともにファイバーを生成して返します。
ブロックは [m:Fiber#resume] に与えられた引数をその引数として実行されます。

ブロックが終了した場合は親にコンテキストが切り替わります。
その時ブロックの評価値が返されます。

- **param** `blocking` -- 偽を指定するとノンブロッキングなファイバーを生成します。
  真を指定するとブロッキングなファイバーを生成します。
  詳しくは [ref:c:Fiber#nonblocking] を参照してください。
#%since 3.2
- **param** `storage` -- 生成するファイバーの fiber storage を指定します。
  true を指定すると呼び出し元のファイバーの fiber storage を複製して引き継ぎます。
  複製なので、生成後の変更は互いに影響しません。
  nil を指定すると引き継ぎません。この場合、最初に書き込んだ時点で空の状態から作られます。
  [c:Hash] を指定するとその内容で初期化します。キーは [c:Symbol] で指定します。
  fiber storage については [m:Fiber#storage] を参照してください。
#%end

```ruby title="例:"
a = nil
f = Fiber.new do |obj|
  a = obj
  :hoge
end
  
b = f.resume(:foo)
p a  #=> :foo
p b  #=> :hoge
```

#%since 3.2

```ruby title="例: fiber storage の引き継ぎ"
Fiber[:key] = 1

p Fiber.new { Fiber[:key] }.resume                    # => 1
p Fiber.new(storage: nil) { Fiber[:key] }.resume      # => nil
p Fiber.new(storage: {key: 2}) { Fiber[:key] }.resume # => 2
```

#%end

### def Fiber.yield(*arg = nil)   -> object

現在のファイバーの親にコンテキストを切り替えます。

コンテキストの切り替えの際に [m:Fiber#resume] に与えられた引数を yield メソッドは返します。

- **param** `arg` -- 現在のファイバーの親に渡したいオブジェクトを指定します。

- **raise** `FiberError` -- Fiber でのルートファイバーで呼ばれた場合に発生します。

```ruby title="例:"
a = nil
f = Fiber.new do
  a = Fiber.yield()
end
  
f.resume()
f.resume(:foo)

p a  #=> :foo
```

#%since 3.2
### def Fiber.[](key) -> object | nil

現在のファイバーの fiber storage から key に対応する値を返します。
対応する値がない場合は nil を返します。

fiber storage については [m:Fiber#storage] を参照してください。

- **param** `key` -- キーを [c:Symbol] で指定します。
- **raise** `TypeError` -- key を [c:Symbol] として扱えない場合に発生します。

#%since 3.4
key には [c:String] も指定できます。この場合 [c:Symbol] に変換されて扱われます。
#%end

```ruby
Fiber[:key] = 1

p Fiber[:key]     # => 1
p Fiber[:unknown] # => nil
```

- **SEE** [m:Fiber.\[\]=], [m:Fiber#storage]

### def Fiber.[]=(key, value)

現在のファイバーの fiber storage の key に対応する値を value に設定します。
key に対応する値がまだない場合は追加します。

このファイバーから生成したファイバーには、設定した値が引き継がれます。
逆に、生成後の変更は互いに影響しません。

- **param** `key` -- キーを [c:Symbol] で指定します。
- **param** `value` -- 格納する値を指定します。
- **raise** `TypeError` -- key を [c:Symbol] として扱えない場合に発生します。

#%since 3.4
key には [c:String] も指定できます。この場合 [c:Symbol] に変換されて扱われます。
#%end

```ruby
Fiber[:key] = 1

Fiber.new do
  p Fiber[:key] # => 1
  Fiber[:key] = 2
  p Fiber[:key] # => 2
end.resume

# 生成したファイバー側での変更は生成元に影響しない
p Fiber[:key]   # => 1
```

- **SEE** [m:Fiber.\[\]], [m:Fiber#storage]

### def Fiber.blocking {|fiber| ... } -> object

ブロックを実行している間だけ、現在のファイバーをブロッキングにします。

ブロックには現在のファイバーが渡されます。
現在のファイバーがすでにブロッキングである場合は、単にブロックを実行します。

- **return** -- ブロックの評価結果を返します。

```ruby
f = Fiber.new do
  p Fiber.blocking?   # => false
  Fiber.blocking do
    p Fiber.blocking? # => 1
  end
  p Fiber.blocking?   # => false
end
f.resume
```

- **SEE** [m:Fiber.blocking?], [ref:c:Fiber#nonblocking]
#%end

### def Fiber.blocking? -> false | 1

現在の実行コンテキストがブロッキングである場合に 1 を返します。
ノンブロッキングである場合は false を返します。

将来のバージョンで、1 以外のブロッキングレベルを表す値が返るようになる可能性があります。

```ruby
p Fiber.blocking?                                      # => 1
p Fiber.new { Fiber.blocking? }.resume                 # => false
p Fiber.new(blocking: true) { Fiber.blocking? }.resume # => 1
```

- **SEE** [m:Fiber#blocking?], [ref:c:Fiber#nonblocking]

#%since 3.1
### def Fiber.current_scheduler -> object | nil

現在のスレッドに設定されているスケジューラを返します。
ただし現在のファイバーがブロッキングである場合は nil を返します。

現在のファイバーがブロッキングかどうかに関わらずスケジューラを取得したい場合は
[m:Fiber.scheduler] を使用してください。

- **SEE** [m:Fiber.scheduler], [m:Fiber.set_scheduler]
#%end

### def Fiber.schedule(*args) {|*args| ... } -> Fiber

現在のスレッドに設定されているスケジューラを使って、ブロックをノンブロッキングなファイバーで実行します。

ファイバーの生成はスケジューラのフックメソッドに委譲されます。
そのため、ブロックがただちに実行されるかどうかはスケジューラの実装に依存します。

- **param** `args` -- ブロックの引数として渡されます。
- **return** -- 生成されたファイバーを返します。
- **raise** `RuntimeError` -- スケジューラが設定されていない場合に発生します。

```ruby title="例: スケジューラが設定されていない場合"
Fiber.schedule { }  # ~> RuntimeError: No scheduler is available!
```

- **SEE** [m:Fiber.set_scheduler], [ref:c:Fiber#nonblocking]

### def Fiber.scheduler -> object | nil

現在のスレッドに設定されているスケジューラを返します。
設定されていない場合は nil を返します。

```ruby
p Fiber.scheduler # => nil
```

- **SEE** [m:Fiber.set_scheduler]
#%since 3.1
- **SEE** [m:Fiber.current_scheduler]
#%end

### def Fiber.set_scheduler(scheduler) -> object

現在のスレッドにスケジューラを設定します。

スケジューラを設定すると、ノンブロッキングファイバーの中でブロックしうる操作を行った際に、スケジューラのフックメソッドが呼ばれるようになります。
またスレッドの終了時にスケジューラの close メソッドが呼ばれ、終了していないファイバーの後始末ができるようになっています。

- **param** `scheduler` -- スケジューラとして振る舞うオブジェクトを指定します。
  nil を指定するとスケジューラを解除します。
- **return** -- `scheduler` をそのまま返します。
- **raise** `ArgumentError` -- scheduler が必要なフックメソッドを実装していない場合に発生します。

```ruby
Fiber.set_scheduler(Object.new) # ~> ArgumentError: Scheduler must implement #block
```

- **SEE** [m:Fiber.scheduler], [m:Fiber.schedule], [ref:c:Fiber#nonblocking]

## Instance Methods
#%since 3.1
#%include(Fiber.transfer)
#%include(Fiber.alive_p)
#%end
### def raise                                            -> object
### def raise(message)                                   -> object
### def raise(exception, message = nil, backtrace = nil) -> object

selfが表すファイバーが最後に [m:Fiber.yield] を呼んだ場所で例外を発生させます。

Fiber.yield が呼ばれていないかファイバーがすでに終了している場合、
[c:FiberError] が発生します。

引数を渡さない場合、[c:RuntimeError] が発生します。
message 引数を渡した場合、message 引数をメッセージとした RuntimeError
が発生します。

その他のケースでは、最初の引数は [c:Exception] か Exception
のインスタンスを返す exception メソッドを持ったオブジェクトである必要があります。
この場合、2つ目の引数に例外のメッセージを渡せます。また3つ目の引数に例外発生時のスタックトレースを指定できます。

- **param** `message` -- 例外のメッセージとなる文字列です。
- **param** `exception` -- 発生させる例外です。
#%since 3.4
- **param** `backtrace` -- 例外発生時のスタックトレースです。文字列の配列、または [c:Thread::Backtrace::Location] の配列で指定します。
#%else
- **param** `backtrace` -- 例外発生時のスタックトレースです。文字列の配列で指定します。
#%end

```ruby title="例"
f = Fiber.new { Fiber.yield }
f.resume
f.raise "Error!" # => Error! (RuntimeError)
```

```ruby title="ファイバー内のイテレーションを終了させる例"
f = Fiber.new do
  loop do
    Fiber.yield(:loop)
  end
  :exit
end

p f.resume              # => :loop
p f.raise StopIteration # => :exit
```

### def resume(*arg = nil)   -> object

自身が表すファイバーへコンテキストを切り替えます。
自身は resume を呼んだファイバーの子となります。

#%# https://bugs.ruby-lang.org/issues/5526 参照。
ただし、[m:Fiber#transfer] を呼び出した後に resume を呼び出す事はできません。

- **param** `arg` -- self が表すファイバーに渡したいオブジェクトを指定します。

- **return** -- コンテキストの切り替えの際に [m:Fiber.yield] に与えられた引数
        を返します。ブロックの終了まで実行した場合はブロックの評価結果
        を返します。

- **raise** `FiberError` -- 自身が既に終了している場合、コンテキストの切替が
                  Thread クラスが表すスレッド間をまたがる場合、自身が resume を
                  呼んだファイバーの親かその祖先である場合に発生します。
                  また、[m:Fiber#transfer] を呼び出した後に resume を
                  呼び出した場合に発生します。

```ruby title="例:"

f = Fiber.new do
  Fiber.yield(:hoge)
  :fuga
end
  
p f.resume() #=> :hoge
p f.resume() #=> :fuga
f.resume()   # ~> FiberError: attempt to resume a terminated fiber
```

### def backtrace                -> [String]
### def backtrace(start)         -> [String]
### def backtrace(start, length) -> [String]
### def backtrace(range)         -> [String]

`self` が表すファイバーの現在の実行スタックを返します。

引数を指定すると、返すスタックの範囲を指定できます。
引数の意味は [m:Kernel?.caller] と同じです。

ファイバーの実行が開始される前と、終了した後は空の配列を返します。

- **param** `start` -- 開始フレームの位置を数値で指定します。
- **param** `length` -- 取得するフレームの個数を指定します。
- **param** `range` -- 取得したいフレームの範囲を [c:Range] で指定します。

```ruby
def level3 = Fiber.yield
def level2 = level3
def level1 = level2

f = Fiber.new { level1 }

# 開始前は空
p f.backtrace # => []

f.resume

#%since 3.4
p f.backtrace
# => ["t.rb:1:in 'Fiber.yield'", "t.rb:1:in 'Object#level3'", "t.rb:2:in 'Object#level2'",
#     "t.rb:3:in 'Object#level1'", "t.rb:5:in 'block in <main>'"]
p f.backtrace(1, 2)
# => ["t.rb:1:in 'Object#level3'", "t.rb:2:in 'Object#level2'"]
#%else
p f.backtrace
# => ["t.rb:1:in `yield'", "t.rb:1:in `level3'", "t.rb:2:in `level2'",
#     "t.rb:3:in `level1'", "t.rb:5:in `block in <main>'"]
p f.backtrace(1, 2)
# => ["t.rb:1:in `level3'", "t.rb:2:in `level2'"]
#%end

f.resume

# 終了後も空
p f.backtrace # => []
```

- **SEE** [m:Fiber#backtrace_locations], [m:Kernel?.caller]

### def backtrace_locations                -> [Thread::Backtrace::Location]
### def backtrace_locations(start)         -> [Thread::Backtrace::Location]
### def backtrace_locations(start, length) -> [Thread::Backtrace::Location]
### def backtrace_locations(range)         -> [Thread::Backtrace::Location]

[m:Fiber#backtrace] と同じですが、実行スタックの各行を
[c:Thread::Backtrace::Location] の配列で返します。

引数の意味は [m:Fiber#backtrace] と同じです。

```ruby
f = Fiber.new { Fiber.yield }
f.resume

loc = f.backtrace_locations.first
p loc.class  # => Thread::Backtrace::Location
p loc.lineno # => 1
```

- **SEE** [m:Fiber#backtrace], [m:Kernel?.caller_locations]

### def blocking? -> bool

`self` がブロッキングなファイバーである場合に true を返します。
ノンブロッキングである場合は false を返します。

[m:Fiber.new] に `blocking: true` を指定して生成したファイバーがブロッキングです。

```ruby
p Fiber.new { }.blocking?                 # => false
p Fiber.new(blocking: true) { }.blocking? # => true
```

- **SEE** [m:Fiber.blocking?], [ref:c:Fiber#nonblocking]

#%since 3.3
### def kill -> self | false

`self` が表すファイバーを終了させます。

捕捉できない例外を発生させて終了させるため、ensure 節は実行されます。

まだ開始されていないファイバーに対して呼んだ場合は、ブロックを実行せずに終了状態にします。
すでに終了しているファイバーに対して呼んだ場合は何もしません。

`self` 以外のファイバーを終了させられるのは、そのファイバーが [m:Fiber.yield] で停止している場合だけです。
`self` に対して呼んだ場合は、kill を呼んだ場所で例外が発生します。

- **return** -- `self` を返します。すでに kill 済みの場合は false を返します。
- **raise** `FiberError` -- 他のスレッドに属するファイバーに対して呼んだ場合に発生します。

```ruby
f = Fiber.new do
  begin
    Fiber.yield :a
    Fiber.yield :b
  ensure
    puts "ensure は実行される"
  end
end

p f.resume # => :a
f.kill     # "ensure は実行される" が出力される
p f.alive? # => false
```

- **SEE** [m:Thread#kill]
#%end

#%since 3.2
### def storage -> Hash | nil
### def storage=(hash)

`self` が表すファイバーの fiber storage を取得、設定します。

fiber storage はファイバーごとに持てる記憶領域です。
[m:Fiber.new] で生成したファイバーには複製が引き継がれます。
スレッドローカル変数がすべてのファイバーで共有されるのに対し、
fiber storage はファイバーを起点とする実行単位の中だけで共有されます。
リクエスト ID やロガーの設定のように、暗黙のうちに引き回したい状態に向いています。

個々の値の読み書きには [m:Fiber.\[\]] と [m:Fiber.\[\]=] を使います。
storage が返すのは複製なので、返り値を変更しても fiber storage には反映されません。
まだ fiber storage を持たない場合は nil を返します。

storage= は実験的な機能です。呼び出すと実験的な機能である旨の警告が出ます。
警告は `-W:no-experimental` オプションで抑制できます。

- **param** `hash` -- 設定する [c:Hash] を指定します。キーは [c:Symbol] で指定します。
  nil を指定すると fiber storage を空にします。
- **return** -- storage は fiber storage の複製を返します。
- **raise** `ArgumentError` -- [m:Fiber.current] 以外のファイバーに対して呼んだ場合に発生します。

```ruby title="例: 取得"
Fiber[:key] = 1
#%since 3.4
p Fiber.current.storage # => {key: 1}
#%else
p Fiber.current.storage # => {:key=>1}
#%end

# 返り値は複製なので、変更しても fiber storage には影響しない
Fiber.current.storage[:key] = 2
p Fiber[:key]           # => 1
```

```ruby title="例: 設定"
Fiber[:key] = 1

Fiber.current.storage = {other: 2} # 実験的な機能である旨の警告が出る
p Fiber[:key]   # => nil
p Fiber[:other] # => 2
```

- **SEE** [m:Fiber.new]
#%end
