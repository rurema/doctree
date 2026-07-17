---
library: _builtin
since: "2.0.0"
---
# class TracePoint < Object

[m:Kernel?.set_trace_func] と同様の機能をオブジェクト指向的な API で
提供するクラスです。

```ruby title="例:例外に関する情報を収集する"
trace = TracePoint.new(:raise) do |tp|
  p [tp.lineno, tp.event, tp.raised_exception]
end
# => #<TracePoint:0x007f786a452448>

p trace.enable
# => false

0 / 0
# => [5, :raise, #<ZeroDivisionError: divided by 0>]
```

[m:TracePoint.new] または、[m:TracePoint.trace] で指定したブロック
は、メソッドの引数(上記の例では :raise)に対応するイベントが発生した時に
呼び出されます。

発生するイベントの詳細については、[m:TracePoint.new] を参照してくださ
い。

### 参考

 - Ruby VM アドベントカレンダー #12 TracePoint の紹介 (1): <https://www.atdot.net/~ko1/diary/201212.html#d12>
 - Ruby VM アドベントカレンダー #13 TracePoint の紹介 (2): <https://www.atdot.net/~ko1/diary/201212.html#d13>
 - Ruby VM アドベントカレンダー #14 TracePoint の紹介 (3): <https://www.atdot.net/~ko1/diary/201212.html#d14>

## Singleton Methods

### def new(*events) {|obj| ... } -> TracePoint

新しい [c:TracePoint] オブジェクトを作成して返します。トレースを有効
にするには [m:TracePoint#enable] を実行してください。

```ruby title="例:irb で実行した場合"
trace = TracePoint.new(:call) do |tp|
    p [tp.lineno, tp.defined_class, tp.method_id, tp.event]
end
# => #<TracePoint:0x007f17372cdb20>

p trace.enable
# => false

puts "Hello, TracePoint!"
# ...
# [69, IRB::Notifier::AbstractNotifier, :printf, :call]
# ...
```

トレースを無効にするには [m:TracePoint#disable] を実行してください。

```ruby
trace.disable
```

- **param** `events` -- トレースするイベントを [c:String] か [c:Symbol] で任
              意の数指定します。

- **`:line`**:

  式の評価。

- **`:class`**:

  クラス定義、特異クラス定義、モジュール定義への突入。

- **`:end`**:

   クラス定義、特異クラス定義、モジュール定義の終了。

- **`:call`**:

  Ruby で記述されたメソッドの呼び出し。

- **`:return`**:

  Ruby で記述されたメソッド呼び出しからのリターン。

- **`:c_call`**:

  C で記述されたメソッドの呼び出し。

- **`:c_return`**:

  C で記述されたメソッド呼び出しからのリターン。

- **`:raise`**:

  例外の発生。

- **`:b_call`**:

  ブロックの開始。

- **`:b_return`**:

  ブロックの終了。

- **`:thread_begin`**:

  スレッドの開始。

- **`:thread_end`**:

  スレッドの終了。

- **`:fiber_switch`**:

  ファイバーの切り替え。

- **`:script_compiled`**:

  スクリプトのコンパイル

指定イベントに関連しない情報を取得するメソッドを実行した場合には
[c:RuntimeError] が発生します。

```ruby title="例"
TracePoint.trace(:line) do |tp|
    p tp.raised_exception
end
# => RuntimeError: 'raised_exception' not supported by this event
```

イベントフックの外側で、発生したイベントに関連する情報を取得するメソッ
ドを実行した場合には [c:RuntimeError] が発生します。

```ruby title="例"
TracePoint.trace(:line) do |tp|
  $tp = tp
end
$tp.lineno # => access from outside (RuntimeError)
```

他のスレッドから参照する事も禁じられています。

- **raise** `ArgumentError` -- ブロックを指定しなかった場合に発生します。

### def trace(*events) {|obj| ... } -> TracePoint

新しい [c:TracePoint] オブジェクトを作成して自動的にトレースを開始し
ます。[m:TracePoint.new] のコンビニエンスメソッドです。

- **param** `events` -- トレースするイベントを [c:String] か [c:Symbol] で任
              意の数指定します。指定できる値については
              [m:TracePoint.new] を参照してください。

```ruby title="例"
trace = TracePoint.trace(:call) { |tp| [tp.lineno, tp.event] }
# => #<TracePoint:0x007f786a452448>

p trace.enabled? # => true
```

- **raise** `ThreadError` -- ブロックを指定しなかった場合に発生します。

### def stat -> object
TracePoint の内部情報を返します。

返り値の内容は実装依存です。
将来変更される可能性があります。

このメソッドは TracePoint 自身のデバッグ用です。
## Instance Methods

### def enable         -> bool
### def enable { ... } -> object

self のトレースを有効にします。

実行前の [m:TracePoint#enabled?] を返します。(トレースが既に有効であっ
た場合は true を返します。そうでなければ false を返します)

```ruby title="例"
p trace.enabled?  # => false
p trace.enable  # => false (実行前の状態)

# トレースが有効

p trace.enabled?  # => true
p trace.enable  # => true (実行前の状態)

# 引き続きトレースが有効
```

ブロックが与えられた場合、ブロック内でのみトレースが有効になります。
この場合はブロックの評価結果を返します。

```ruby title="例"
p trace.enabled? # => false

trace.enable do
  p trace.enabled? # => true
end

p trace.enabled? # => false
```

[注意] イベントフックのためのメソッドにブロックの外側で参照した場合は
[c:RuntimeError] が発生する事に注意してください。

```ruby title="例"
trace.enable { p trace.lineno }
# => RuntimeError: access from outside
```

- **SEE** [m:TracePoint#disable], [m:TracePoint#enabled?]

### def disable         -> bool
### def disable { ... } -> object

self のトレースを無効にします。

実行前の [m:TracePoint#enabled?] を返します。(トレースが既に有効であっ
た場合は true を返します。そうでなければ false を返します)

```ruby title="例"
p trace.enabled? # => true
p trace.disable  # => false (実行前の状態)
p trace.enabled? # => false
p trace.disable  # => false
```

ブロックが与えられた場合、ブロック内でのみトレースが無効になります。
この場合はブロックの評価結果を返します。

```ruby title="例"
p trace.enabled? # => true

trace.disable do
  p trace.enabled? # => false
end

p trace.enabled? # => true
```

[注意] イベントフックのためのメソッドに、ブロックの外側で参照した場合は
[c:RuntimeError] が発生する事に注意してください。

```ruby
trace.enable { p trace.lineno }
# => RuntimeError: access from outside
```

- **SEE** [m:TracePoint#enable], [m:TracePoint#enabled?]

### def enabled? -> bool

self のトレースが有効な場合に true を、そうでない場合に false を返しま
す。

#@#noexample TracePoint#enable, TracePoint#disable  の例を参照

- **SEE** [m:TracePoint#enable], [m:TracePoint#disable]

### def inspect -> String

self の状態を人間に読みやすい文字列にして返します。

```ruby title="例"
def foo(ret)
  ret
end
trace = TracePoint.new(:call) do |tp|
#@since 3.4
  p tp.inspect # "#<TracePoint:call 'foo' /path/to/test.rb:1>"
#@else
  p tp.inspect # "#<TracePoint:call `foo'@/path/to/test.rb:1>"
#@end
end
trace.enable
foo 1
```

### def event -> Symbol

発生したイベントの種類を [c:Symbol] で返します。

発生するイベントの詳細については、[m:TracePoint.new] を参照してくださ
い。

- **raise** `RuntimeError` -- イベントフックの外側で実行した場合に発生します。

```ruby title="例"
def foo(ret)
  ret
end
trace = TracePoint.new(:call, :return) do |tp|
  p tp.event
end
trace.enable
p foo 1
# => :call
# :return
```

### def lineno -> Integer

発生したイベントの行番号を返します。

- **raise** `RuntimeError` -- イベントフックの外側で実行した場合に発生します。

```ruby title="例"
def foo(ret)
  ret
end
trace = TracePoint.new(:call, :return) do |tp|
  tp.lineno
end
trace.enable
p foo 1
# => 1
# 3
```

### def path -> String

イベントが発生したファイルのパスを返します。

- **raise** `RuntimeError` -- イベントフックの外側で実行した場合に発生します。

```ruby title="例"
def foo(ret)
  ret
end
trace = TracePoint.new(:call) do |tp|
  p tp.path # => "/path/to/test.rb"
end
trace.enable
foo 1
```

### def method_id -> Symbol | nil

イベントが発生したメソッドの定義時の名前を [c:Symbol] で返します。
トップレベルであった場合は nil を返します。

- **raise** `RuntimeError` -- イベントフックの外側で実行した場合に発生します。

```ruby
class C
  def method_name
  end
  alias alias_name method_name
end

trace = TracePoint.new(:call) do |tp|
  p [tp.method_id, tp.callee_id] # => [:method_name, :alias_name]
end
trace.enable do
  C.new.alias_name
end
```

- **SEE** [m:TracePoint#callee_id]

### def callee_id -> Symbol | nil

イベントが発生したメソッドの呼ばれた名前を [c:Symbol] で返します。
トップレベルであった場合は nil を返します。

- **raise** `RuntimeError` -- イベントフックの外側で実行した場合に発生します。

```ruby
class C
  def method_name
  end
  alias alias_name method_name
end

trace = TracePoint.new(:call) do |tp|
  p [tp.method_id, tp.callee_id] # => [:method_name, :alias_name]
end
trace.enable do
  C.new.alias_name
end
```

- **SEE** [m:TracePoint#method_id]

### def defined_class -> Class | module

メソッドを定義したクラスかモジュールを返します。

```ruby title="例"
class C; def foo; end; end
trace = TracePoint.new(:call) do |tp|
  p tp.defined_class # => C
end.enable do
  C.new.foo
end
```

メソッドがモジュールで定義されていた場合も(include に関係なく)モジュー
ルを返します。

```ruby title="例"
module M; def foo; end; end
class C; include M; end;
trace = TracePoint.new(:call) do |tp|
  p tp.defined_class # => M
end.enable do
  C.new.foo
end
```

[注意] 特異メソッドを実行した場合は TracePoint#defined_class は特異クラ
スを返します。また、[m:Kernel?.set_trace_func] の 6 番目のブロックパ
ラメータは特異クラスではなく元のクラスを返します。

```ruby title="例"
class C; def self.foo; end; end
trace = TracePoint.new(:call) do |tp|
  p tp.defined_class # => #<Class:C>
end.enable do
  C.foo
end
```

[m:Kernel?.set_trace_func] と [c:TracePoint] の上記の差分に注意して
ください。

- **SEE** [ruby-core:50864]

#@since 3.2
### def binding -> Binding | nil
#@else
### def binding -> Binding
#@end

発生したイベントによって生成された [c:Binding] オブジェクトを返します。

#@since 3.2
C で記述されたメソッドは binding を生成しないため、
:c_call および :c_return イベントに対しては nil を返すことに注意してください。
#@end

```ruby title="例"
def foo(ret)
  ret
end
trace = TracePoint.new(:call) do |tp|
  p tp.binding.local_variables # => [:ret]
end
trace.enable
foo 1
```

### def self -> object

イベントを発生させたオブジェクトを返します。

以下のようにする事で同じ値を取得できます。

#@since 3.2
なお、self メソッドは binding が nil になる :c_call および :c_return イベントに対しても正しく動作します。
#@end

```ruby title="例"
trace.binding.eval('self')
```

- **SEE** [m:TracePoint#binding]

### def return_value -> object

メソッドやブロックの戻り値を返します。

- **raise** `RuntimeError` -- :return、:c_return、:b_return イベントのためのイベ
                    ントフックの外側で実行した場合に発生します。

```ruby title="例"
def foo(ret)
  ret
end
trace = TracePoint.new(:return) do |tp|
  p tp.return_value # => 1
end
trace.enable
foo 1
```

### def raised_exception -> Exception

発生した例外を返します。

- **raise** `RuntimeError` -- :raise イベントのためのイベントフックの外側で実行し
                    た場合に発生します。

```ruby title="例"
trace = TracePoint.new(:raise) do |tp|
  tp.raised_exception # => #<ZeroDivisionError: divided by 0>
end
trace.enable
begin
  0/0
rescue
end
```

### def parameters -> [object]

現在のフックが属するメソッドまたはブロックのパラメータ定義を返します。
フォーマットは [m:Method#parameters] と同じです。

- **raise** `RuntimeError` -- :call、:return、:b_call、:b_return、:c_call、:c_return
                    イベントのためのイベントフックの外側で実行した場合に発生します。

```ruby title="例"
def foo(a, b = 2)
end
TracePoint.new(:call) do |tp|
  p tp.parameters # => [[:req, :a], [:opt, :b]]
end.enable do
  foo(1)
end
```

- **SEE** [m:Method#parameters], [m:UnboundMethod#parameters], [m:Proc#parameters]

### def eval_script -> String | nil

script_compiledイベント発生時にコンパイルされたソースコードを返します。
ファイルから読み込んだ場合は、nilを返します。

```ruby title="例"
TracePoint.new(:script_compiled) do |tp|
  p tp.eval_script # => "puts 'hello'"
end.enable do
  eval("puts 'hello'")
end
```

- **raise** `RuntimeError` -- :script_compiled イベントのための
                    イベントフックの外側で実行した場合に発生します。

### def instruction_sequence -> RubyVM::InstructionSequence

script_compiledイベント発生時にコンパイルされた
RubyVM::InstructionSequenceインスタンスを返します。

```ruby title="例"
TracePoint.new(:script_compiled) do |tp|
  p tp.instruction_sequence # => <RubyVM::InstructionSequence:block in <main>@(eval):1>
end.enable do
  eval("puts 'hello'")
end
```

- **raise** `RuntimeError` -- :script_compiled イベントのための
                    イベントフックの外側で実行した場合に発生します。

