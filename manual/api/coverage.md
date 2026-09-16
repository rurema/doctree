---
type: library
category: Development
---
カバレッジを測定するためのライブラリです。

### 基本的な使い方

以下のようにして測定を行います。

  1. require "coverage" で、ライブラリを読み込む。
  2. Coverage.start を実行し、測定を開始する。
  3. require や load で測定対象のファイルを実行する。
  4. Coverage.result や Coverage.peek_result で結果を確認する。

Coverage.result は、ファイル名をキーとし、カバレッジ測定結果を値とするハッシュを返します。

#### 簡単な例

まず測定対象のソースを用意します。

```ruby title="foo.rb"
s = 0
10.times do |x|
  s += x
end

if s == 45
  p :ok
else
  p :ng
end
```

以下のようにして測定を行います。

```ruby
require "coverage"
Coverage.start
load "foo.rb"
p Coverage.result  # => {"foo.rb"=>[1, 1, 10, nil, nil, 1, 1, nil, 0, nil]}
```

この Coverage.result["foo.rb"] から得られる配列は各行の実行回数になっています。

### カバレッジモードの指定

Ruby 2.5 以降では、Coverage.start の引数で、計測対象の種類を変更するモード機能があります。

#### linesカバレッジモード

linesカバレッジモードでは、各行の実行された回数を計測します。得られる結果の情報は、引数でモードを明示的にしない場合と同じです。

```ruby
require "coverage"
Coverage.start(lines: true)
load "foo.rb"
p Coverage.result  # => {"foo.rb"=>{:lines=>[1, 1, 10, nil, nil, 1, 1, nil, 0, nil]}}
```

キーの :lines が指す値は、各行が実行された回数を示す配列です。この配列の順序は重要です。たとえば、この配列の最初の要素は、カバレッジ計測中にファイルの 1 行目が実行された回数を示しています(この例では 1 回)。

なお、空行、コメント、end のような行はカバレッジの計測対象外で、nil となっています。

#### oneshot_linesカバレッジモード

oneshot_linesカバレッジモードでは、カバレッジの計測中に実行された行を記録します。実行回数は計測せず、実行されたこと行番号を記録します。

```ruby
require "coverage"
Coverage.start(oneshot_lines: true)
load "foo.rb"
p Coverage.result  # => {"foo.rb"=>{:oneshot_lines=>[1, 2, 3, 6, 7]}}
```

oneshot_linesキーの指す値は、実行された行番号を列挙した配列です。

#### branchesカバレッジモード

branchesカバレッジモードでは、各条件分岐のそれぞれの分岐(branch)の実行された回数を計測します。

```ruby
require "coverage"
Coverage.start(branches: true)
load "foo.rb"
pp Coverage.result
# {"foo.rb"=>
#   {:branches=>
#     {[:if, 0, 6, 0, 10, 3]=>
#       {[:then, 1, 7, 2, 7, 7]=>1, [:else, 2, 9, 2, 9, 7]=>0}}}}
```

キーの :branches が指すハッシュの各キーは条件分岐(の識別情報)であり、その条件分岐のキーが指すハッシュはその条件分岐の分岐(の識別情報)とその分岐の実行回数です。

分岐の識別情報であるキーを構成する要素は、左から右に向かって以下の通りです。

1. 枝や条件分岐の種類を示すラベル
2. ID(固有の識別子)
3. ファイル内での開始行
4. ファイル内での開始列
5. ファイル内での終了行
6. ファイル内での終了列

#### methodsカバレッジモード

methodsカバレッジモードでは、各メソッドの実行回数を計測します。

```ruby title="foo_method.rb"
class Greeter
  def greet
    "welcome!"
  end
end

def hello
  "Hi"
end

hello()
Greeter.new.greet()
```

```ruby
require "coverage"
Coverage.start(methods: true)
load "foo_method.rb"
pp Coverage.result
# {"foo_method.rb"=>
#   {:methods=>
#     {[Object, :hello, 7, 0, 9, 3]=>1, [Greeter, :greet, 2, 2, 4, 5]=>1}}}
```

キーの :methods が指すハッシュの各キーはメソッド(の識別情報)を表し、値はメソッドの実行回数です。

メソッドの識別情報であるキーを構成する要素は、左から右に向かって以下の通りです。

1. クラス名
2. メソッド名
3. ファイル内でのメソッドの開始行
4. ファイル内でのメソッドの開始列
5. ファイル内でのメソッドの終了行
6. ファイル内でのメソッドの終了列

#### 全指定の all

このモードでは、全てのカレッジモードを同時に実行できます。

ただし、oneshot_linesカバレッジモードは実行されません。これは、linesカバレッジモードにより各行の実行回数が計測され、行が実行されたかどうかわかるためです。

```ruby
require "coverage"
Coverage.start(:all)
load "foo.rb"
pp Coverage.result
# {"foo.rb"=>
#   {:lines=>[1, 1, 10, nil, nil, 1, 1, nil, 0, nil],
#    :branches=>
#     {[:if, 0, 6, 0, 10, 3]=>
#       {[:then, 1, 7, 2, 7, 7]=>1, [:else, 2, 9, 2, 9, 7]=>0}},
#    :methods=>{}}}
```

# class Coverage

カバレッジを測定する機能を提供するクラスです。

実験的な機能のため、APIは将来変更になる可能性があります。

## Class Methods

### def Coverage.start(option = {})  -> nil

カバレッジの測定を開始します。既に実行されていた場合には何も起こりません。
ただし、カバレッジ計測中に測定対象を変更しようとした場合は、RuntimeError となります。

- **param** `option` -- カバレッジの計測モードを指定します。
              :all か "all" を指定すると、全ての種類を計測します。
              個別に指定する場合は、ハッシュを渡します。
              詳細は、[lib:coverage] ライブラリ を参照してください。

```ruby title="bool.rb"
def bool(obj)
  if obj
    true
  else
    false
  end
end
```

```ruby
require "coverage"

Coverage.start(:all)
load "bool.rb"
bool(0)
pp Coverage.result
# {"bool.rb"=>
#   {:lines=>[1, 1, 1, nil, 0, nil, nil],
#    :branches=>
#     {[:if, 0, 2, 2, 6, 5]=>
#       {[:then, 1, 3, 4, 3, 8]=>1, [:else, 2, 5, 4, 5, 9]=>0}},
#    :methods=>{[Object, :bool, 1, 0, 7, 3]=>1}}}

Coverage.start(methods: true)
load "bool.rb"
bool(0)
pp Coverage.result  # => {"bool.rb"=>{:methods=>{[Object, :bool, 1, 0, 7, 3]=>1}}}
```

### def Coverage.result(stop: true, clear: true)  -> Hash

対象ファイル名をキー、測定結果を値したハッシュを返します。
測定結果の詳細は、[lib:coverage] ライブラリ を参照してください。

- **param** `stop` -- true であれば、カバレッジの測定を終了します。
- **param** `clear` -- true であれば、測定記録をクリアします。

- **return** -- 測定結果を表すハッシュ

- **raise** `RuntimeError` -- [m:Coverage.start] を実行する前に実行された場合に発生します。

```ruby title="bool.rb"
def bool(obj)
  if obj
    true
  else
    false
  end
end
```

```ruby
require "coverage"
Coverage.start
load "bool.rb"
p Coverage.result  # => {"bool.rb"=>[1, 0, 0, nil, 0, nil, nil]}
bool(0)
p Coverage.result  # coverage measurement is not enabled (RuntimeError)
```

Ruby 2.6 以降では、オプションを指定できます。
Coverage.result(clear: true, stop: false) と指定することで、続けて新しく実行された行だけを記録できます。

```ruby
require "coverage"
Coverage.start(oneshot_lines: true)
load "bool.rb"
p Coverage.result(clear: true, stop: false)  # => {"bool.rb"=>{:oneshot_lines=>[1]}}
bool(0)
p Coverage.result(clear: true, stop: false)  # => {"bool.rb"=>{:oneshot_lines=>[2, 3]}}
bool(nil)
p Coverage.result(clear: true, stop: false)  # => {"bool.rb"=>{:oneshot_lines=>[5]}}
```

上記のコード例で、bool(0) で実行された2行目の条件式は、測定記録がクリアされたあと bool(nil) で実行されても新しく記録されません。
測定記録をクリアしても、記録を開始してから実行されたことまでリセットされているわけではないことに注意して下さい。

- **SEE** [m:Coverage.peek_result]

### def Coverage.peek_result -> Hash

測定を止めることなく、測定中のその時の結果をハッシュで返します。
測定結果の詳細は、[lib:coverage] ライブラリ を参照してください。

これは、Coverage.result(stop: false, clear: false) と同じです。

- **return** -- 測定途中結果を表すハッシュ

- **raise** `RuntimeError` -- [m:Coverage.start] を実行する前に実行された場合に発生します。

```ruby title="bool.rb"
def bool(obj)
  if obj
    true
  else
    false
  end
end
```

```ruby
require "coverage"

Coverage.start

load "bool.rb"
p Coverage.peek_result  # => {"bool.rb"=>[1, 0, 0, nil, 0, nil, nil]}

bool(true)
p Coverage.peek_result  # => {"bool.rb"=>[1, 1, 1, nil, 0, nil, nil]}

bool(false)
p Coverage.peek_result  # => {"bool.rb"=>[1, 2, 1, nil, 1, nil, nil]}
```

- **SEE** [m:Coverage.result]

### def Coverage.running? -> bool

カバレッジ測定中かどうかを返します。カバレッジの測定中とは、Coverage.start の呼び出し後から Coverage.result の呼び出し前です。

```ruby
require 'coverage'
p Coverage.running?    # => false
Coverage.start
p Coverage.running?    # => true
p Coverage.peek_result # => {}
p Coverage.running?    # => true
p Coverage.result      # => {}
p Coverage.running?    # => false
```

### def Coverage.line_stub(file)  -> Array

行カバレッジの配列のスタブを返します。

測定対象となる行の要素は 0, 空行やコメントなどにより測定対象外となる行の要素は nil となります。

```ruby title="foo.rb"
s = 0
10.times do |x|
  s += x
end

if s == 45
  p :ok
else
  p :ng
end
```

このファイルに対して line_stub を実行すると、次のようになります。

```ruby
require "coverage"
p Coverage.line_stub("foo.rb")  # => [0, 0, 0, nil, nil, 0, 0, nil, 0, nil]
```

この例において、空行, else, end の行は測定対象外であるため、nil となっています。

- **param** `file` -- ファイル名を表す文字列

#%since 3.2
### def Coverage.supported?(mode) -> bool

指定したモードのカバレッジ測定がサポートされているかどうかを返します。

- **param** `mode` -- `:lines`、`:branches`、`:methods`、`:eval` のいずれかをシンボルで指定します。

```ruby
require "coverage"
p Coverage.supported?(:lines)  # => true
p Coverage.supported?(:all)    # => false
```

#%end

#%since 3.1
### def Coverage.setup(mode = nil) -> nil
### def Coverage.setup(lines: nil, branches: nil, methods: nil, eval: nil, oneshot_lines: nil) -> nil

カバレッジの測定の準備をします。

このメソッド自体は測定を開始しません。測定を開始するには [m:Coverage.resume] を使います。
準備と開始を同時に行いたい場合は [m:Coverage.start] を使ってください。

- **param** `mode` -- `:all` を指定すると、`lines`、`branches`、`methods`、`eval` の全てを計測対象にします。
              省略した場合は行カバレッジのみが対象になります。
- **param** `lines` -- 真を指定すると行カバレッジを計測対象にします。
- **param** `branches` -- 真を指定すると分岐カバレッジを計測対象にします。
- **param** `methods` -- 真を指定するとメソッドカバレッジを計測対象にします。
- **param** `eval` -- 真を指定すると eval カバレッジを計測対象にします。
- **param** `oneshot_lines` -- 真を指定すると、行カバレッジを 1 度でも実行されたかどうかだけを記録するモード([lib:coverage] ライブラリ参照)で計測対象にします。`lines` と同時には指定できません。

- **raise** `RuntimeError` -- 既に [m:Coverage.setup] 済みの状態で、対象とするモードが異なる引数で呼び出した場合に発生します。

```ruby
require "coverage"
Coverage.setup(lines: true)
p Coverage.state  # => :suspended
Coverage.resume
```

- **SEE** [m:Coverage.resume], [m:Coverage.start]

### def Coverage.resume -> nil

カバレッジの測定を開始、または再開します。

事前に [m:Coverage.setup] で測定の準備をしておく必要があります。

現在のところプロセス全体のカバレッジしか測定できません。スレッドごとのカバレッジは測定できないため、
複数のスレッドを持つプロセスで [m:Coverage.resume] と [m:Coverage.suspend] を使って
特定のコードブロックの実行だけをカバレッジ測定の対象にしようとすると、意図しない結果になることがあります。

- **raise** `RuntimeError` -- [m:Coverage.setup] を実行する前に実行した場合、または既に測定中の場合に発生します。

```ruby
require "coverage"
Coverage.setup
Coverage.resume
p Coverage.state  # => :running
```

- **SEE** [m:Coverage.setup], [m:Coverage.suspend]

### def Coverage.suspend -> nil

カバレッジの測定を一時停止します。

再開するには [m:Coverage.resume] を使います。

- **raise** `RuntimeError` -- 測定中でない場合に発生します。

```ruby
require "coverage"
Coverage.start
Coverage.suspend
p Coverage.state  # => :suspended
```

- **SEE** [m:Coverage.resume]

### def Coverage.state -> Symbol

カバレッジの測定の状態を返します。

`:idle`([m:Coverage.setup] も [m:Coverage.start] も行われていない状態)、`:suspended`(測定の準備はできているが一時停止中の状態)、`:running`(測定中の状態)のいずれかを返します。

```ruby
require "coverage"
p Coverage.state  # => :idle
Coverage.setup
p Coverage.state  # => :suspended
Coverage.resume
p Coverage.state  # => :running
```

#%end

