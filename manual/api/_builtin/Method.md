---
library: _builtin
---
# class Method < Object

[m:Object#method] によりオブジェクト化され
たメソッドオブジェクトのクラスです。

メソッドの実体（名前でなく）とレシーバの組を封入します。
[c:Proc] オブジェクトと違ってコンテキストを保持しません。

### Proc との差

[c:Method] は取り出しの対象であるメソッドが
なければ作れませんが、[c:Proc] は準備なしに作れます。その点から
[c:Proc] は使い捨てに向き、[c:Method] は何度も繰り返し生成する
場合に向くと言えます。また内包するコードの大きさという点では
[c:Proc] は小規模、[c:Method] は大規模コードに向くと言えます。

既存のメソッドを [c:Method] オブジェクト化する。

```ruby title="例"
class Foo
  def foo(arg)
    "foo called with arg #{arg}"
  end
end

m = Foo.new.method(:foo)

p m             # => #<Method: Foo#foo>
p m.call(1)     # => "foo called with arg 1"
```

名前のないメソッド(の代わり)が必要なら [c:Proc] を使うと良い。

```ruby title="例"
pr = Proc.new {|arg|
  "proc called with arg #{arg}"
}

p pr            # => #<Proc:0x401b1fcc>
p pr.call(1)    # => "proc called with arg 1"
```

[c:Method] オブジェクトが有用なのは以下のような場合。

```ruby title="例"
class Foo
  def foo() "foo" end
  def bar() "bar" end
  def baz() "baz" end
end

obj = Foo.new

# 任意のキーとメソッドの関係をハッシュに保持しておく
methods = {1 => obj.method(:foo),
           2 => obj.method(:bar),
           3 => obj.method(:baz)}

# キーを使って関連するメソッドを呼び出す
p methods[1].call       # => "foo"
p methods[2].call       # => "bar"
p methods[3].call       # => "baz"
```

しかし、レシーバを固定させる(Method オブジェクトはレシーバを保持する)必
要がないなら [m:Object#public_send]を使う方法も有用。

```ruby title="例"
class Foo
  def foo() "foo" end
  def bar() "bar" end
  def baz() "baz" end
end

# 任意のキーとメソッド(の名前)の関係をハッシュに保持しておく
# レシーバの情報がここにはないことに注意
methods = {1 => :foo,
           2 => :bar,
           3 => :baz}

# キーを使って関連するメソッドを呼び出す
# レシーバは任意(Foo クラスのインスタンスである必要もない)
p Foo.new.public_send(methods[1])      # => "foo"
p Foo.new.public_send(methods[2])      # => "bar"
p Foo.new.public_send(methods[3])      # => "baz"
```

- **SEE** [m:Object#method]

## Instance Methods

### def clone -> Method

自身を複製した [c:Method] オブジェクトを作成して返します。

```ruby title="例"
class Foo
  def foo
    "foo"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
p m.call # => "foo"

p m.clone # => #<Method: Foo#foo>
p m.clone.call # => "foo"
```

### def [](*args) -> object
### def call(*args) -> object
### def call(*args) { ... } -> object
### def ===(*args) -> object

メソッドオブジェクトに封入されているメソッドを起動します。

引数やブロックはそのままメソッドに渡されます。

self[] の形の呼び出しは通常のメソッド呼び出しに見た目を
近付けるためだけに用意されたもので、Array#[]のような
他の [] メソッドとの意味的な関連性はありません。

- **param** `args` -- self に渡される引数。

- **SEE** [m:UnboundMethod#bind_call]
#@until 3.2
- **SEE** [d:spec/safelevel]
#@# セーフレベルに関するその他の詳細
#@end

```ruby title="例"
class Foo
  def foo(arg)
    "foo called with arg #{arg}"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
p m[1]    # => "foo called with arg 1"
p m.call(2) # => "foo called with arg 2"
```

### def <<(callable) -> Proc

self と引数を合成した Proc を返します。

戻り値の Proc は可変長の引数を受け取ります。
戻り値の Proc を呼び出すと、まず受け取った引数を callable に渡して呼び出し、
その戻り値を self に渡して呼び出した結果を返します。

[m:Method#>>] とは呼び出しの順序が逆になります。

- **param** `callable` -- Proc、Method、もしくは任意の call メソッドを持ったオブジェクト。

```ruby title="例"
def f(x)
  x * x
end

def g(x)
  x + x
end

# (3 + 3) * (3 + 3)
p (method(:f) << method(:g)).call(3) # => 36
```

```ruby title="call を定義したオブジェクトを渡す例"
class WordScanner
  def self.call(str)
    str.scan(/\w+/)
  end
end

File.write('testfile', <<~TEXT)
  Hello, World!
  Hello, Ruby!
TEXT

pipeline = method(:pp) << WordScanner << File.method(:read)
pipeline.call('testfile') # => ["Hello", "World", "Hello", "Ruby"]
```

- **SEE** [m:Proc#<<], [m:Proc#>>]

### def >>(callable) -> Proc

self と引数を合成した Proc を返します。

戻り値の Proc は可変長の引数を受け取ります。
戻り値の Proc を呼び出すと、まず受け取った引数を self に渡して呼び出し、
その戻り値を callable に渡して呼び出した結果を返します。

[m:Method#<<] とは呼び出しの順序が逆になります。

- **param** `callable` -- Proc、Method、もしくは任意の call メソッドを持ったオブジェクト。

```ruby title="例"
def f(x)
  x * x
end

def g(x)
  x + x
end

# (3 * 3) + (3 * 3)
p (method(:f) >> method(:g)).call(3) # => 18
```

```ruby title="call を定義したオブジェクトを渡す例"
class WordScanner
  def self.call(str)
    str.scan(/\w+/)
  end
end

File.write('testfile', <<~TEXT)
  Hello, World!
  Hello, Ruby!
TEXT

pipeline = File.method(:read) >> WordScanner >> method(:pp)
pipeline.call('testfile') # => ["Hello", "World", "Hello", "Ruby"]
```

- **SEE** [m:Proc#<<], [m:Proc#>>]

### def arity -> Integer

メソッドが受け付ける引数の数を返します。

ただし、メソッドが可変長引数を受け付ける場合、負の整数

```text
-(必要とされる引数の数 + 1)
```

を返します。C 言語レベルで実装されたメソッドが可変長引数を
受け付ける場合、-1 を返します。

```ruby title="例"
class C
  def u;               end
  def v(a);            end
  def w(*a);           end
  def x(a, b);         end
  def y(a, b, *c);     end
  def z(a, b, *c, &d); end
end

c = C.new
p c.method(:u).arity     #=> 0
p c.method(:v).arity     #=> 1
p c.method(:w).arity     #=> -1
p c.method(:x).arity     #=> 2
p c.method(:y).arity     #=> -3
p c.method(:z).arity     #=> -3

s = "xyz"
p s.method(:size).arity    #=> 0
p s.method(:replace).arity #=> 1
p s.method(:squeeze).arity #=> -1
p s.method(:count).arity   #=> -1
```

- **SEE** [ref:d:glossary#arity]

### def inspect -> String
### def to_s    -> String

self を読みやすい文字列として返します。

以下の形式の文字列を返します。

```text
#<Method: klass1(klass2)#method(arg) foo.rb:2>    (形式1)
```

klass1 は、[m:Method#inspect] では、レシーバのクラス名、
[m:UnboundMethod#inspect] では、[c:UnboundMethod] オブジェクトの生成
元となったクラス／モジュール名です。

klass2 は、実際にそのメソッドを定義しているクラス／モジュール名、
method は、メソッド名を表します。

arg は引数を表します。
「foo.rb:2」は [m:Method#source_location] を表します。
source_location が nil の場合には付きません。

```ruby title="例"
module Foo
  def foo
    "foo"
  end
end
class Bar
  include Foo
  def bar(a, b)
  end
end

p Bar.new.method(:foo)        # => #<Method: Bar(Foo)#foo() test.rb:2>
p Bar.new.method(:bar)        # => #<Method: Bar#bar(a, b) test.rb:8>
```

klass1 と klass2 が同じ場合は以下の形式になります。

```text
#<Method: klass1#method() foo.rb:2>             (形式2)
```

特異メソッドに対しては、

```text
#<Method: obj.method() foo.rb:2>                (形式3)
#<Method: klass1(klass2).method() foo.rb:2>     (形式4)
```

という形式の文字列を返します。二番目の形式では klass1 はレシーバ、
klass2 は実際にそのメソッドを定義しているオブジェクトになります。

```ruby title="例"
# オブジェクトの特異メソッド
obj = ""
class <<obj
  def foo
  end
end
p obj.method(:foo)      # => #<Method: "".foo() foo.rb:4>

# クラスメソッド(クラスの特異メソッド)
class Foo
  def Foo.foo
  end
end
p Foo.method(:foo)      # => #<Method: Foo.foo() foo.rb:11>

# スーパークラスのクラスメソッド
class Bar < Foo
end
p Bar.method(:foo)      # => #<Method: Bar(Foo).foo() foo.rb:11>

# 以下は(形式1)の出力になる
module Baz
  def baz
  end
end

class <<obj
  include Baz
end
p obj.method(:baz)      # => #<Method: String(Baz)#baz() foo.rb:23>
```

- **SEE** [m:Object#inspect]

### def to_proc -> Proc

self を call する [c:Proc] オブジェクトを生成して返します。

```ruby title="例"
class Foo
  def foo
    "foo"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
pr = m.to_proc # => #<Proc:0x007f874d026008 (lambda)>
pr.call # => "foo"
```

### def unbind -> UnboundMethod

self のレシーバとの関連を取り除いた [c:UnboundMethod] オブ
ジェクトを生成して返します。

```ruby title="例"
class Foo
  def foo
    "foo"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
unbound_method = m.unbind # => #<UnboundMethod: Foo#foo>
p unbound_method.bind(Foo.new) # => #<Method: Foo#foo>
```

### def ==(other)     -> bool
### def eql?(other)   -> bool

自身と other が同じインスタンスの同じメソッドを表す場合に
true を返します。そうでない場合に false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。

```ruby title="例"
s = "bar"
a = s.method(:size)
b = s.method(:size)
p a == b                            #=> true
```

### def hash    -> Integer

自身のハッシュ値を返します。

```ruby title="例"
a = method(:==)
b = method(:eql?)
p a.eql? b          # => true
p a.hash == b.hash  # => true
p [a, b].uniq.size  # => 1
```

### def name    -> Symbol

このメソッドの名前を返します。

```ruby title="例"
class Foo
  def foo(arg)
    "foo called with arg #{arg}"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
p m.name # => :foo
```

### def owner    -> Class | Module

このメソッドが定義されている class か module を返します。

```ruby title="例"
class Foo
  def foo(arg)
    "foo called with arg #{arg}"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
p m.owner # => Foo

m = Foo.new.method(:puts) # => #<Method: Foo(Kernel)#puts>
p m.owner # => Kernel
```

### def receiver    -> object

このメソッドオブジェクトのレシーバを返します。

```ruby title="例"
class Foo
  def foo(arg)
    "foo called with arg #{arg}"
  end
end

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
p m.receiver # => #<Foo:0x007fb39203eb78>
p m.receiver.foo(1) # => "foo called with arg 1"
```

### def source_location -> [String, Integer] | nil

ソースコードのファイル名と行番号を配列で返します。

その手続オブジェクトが ruby で定義されていない(つまりネイティブ
である)場合は nil を返します。

- **SEE** [m:Proc#source_location]

```ruby title="例"
# ------- /tmp/foo.rb ---------
class Foo
  def foo; end
end
# ----- end of /tmp/foo.rb ----

require '/tmp/foo'

m = Foo.new.method(:foo) # => #<Method: Foo#foo>
p m.source_location # => ["/tmp/foo.rb", 2]

p method(:puts).source_location # => nil
```

### def parameters -> [object]

Method オブジェクトの引数の情報を返します。

Method オブジェクトが引数を取らなければ空の配列を返します。引数を取る場合は、配列の配列を返し、
各配列の要素は引数の種類に応じた以下のような Symbol と、仮引数の名前を表す Symbol の 2 要素です。
組み込みのメソッドでは、仮引数の名前が取れません。

- **`:req`**:
  必須の引数
- **`:opt`**:
  デフォルト値が指定されたオプショナルな引数
- **`:rest`**:
  * で指定された残りすべての引数
- **`:keyreq`**:
  必須のキーワード引数
- **`:key`**:
  デフォルト値が指定されたオプショナルなキーワード引数
- **`:keyrest`**:
  ** で指定された残りのキーワード引数
- **`:block`**:
  & で指定されたブロック引数

  ```ruby title="例"
  m = Class.new{define_method(:m){|x, y=42, *other, k_x:, k_y: 42, **k_other, &b|}}.instance_method(:m)
  p m.parameters #=> [[:req, :x], [:opt, :y], [:rest, :other], [:keyreq, :k_x], [:key, :k_y], [:keyrest, :k_other], [:block, :b]]
  p File.method(:symlink).parameters #=> [[:req], [:req]]
  ```

- **SEE** [m:Proc#parameters]

### def curry        -> Proc
### def curry(arity) -> Proc

self を元にカリー化した [c:Proc] を返します。

カリー化した [c:Proc] はいくつかの引数をとります。十分な数の引数が与
えられると、元の [c:Proc] に引数を渡し て実行し、結果を返します。引数
の個数が足りないときは、部分適用したカリー化 [c:Proc] を返します。

- **param** `arity` -- 引数の個数を指定します。可変長の引数を指定できるメソッドを
             カリー化する際には必ず指定する必要があります。

```ruby title="例"
def foo(a,b,c)
  [a, b, c]
end

proc  = self.method(:foo).curry
proc2 = proc.call(1, 2)          #=> #<Proc>
proc2.call(3)                    #=> [1,2,3]

def vararg(*args)
  args
end

proc = self.method(:vararg).curry(4)
proc2 = proc.call(:x)      #=> #<Proc>
proc3 = proc2.call(:y, :z) #=> #<Proc>
proc3.call(:a)             #=> [:x, :y, :z, :a]
```

- **SEE** [m:Proc#curry]

### def super_method -> Method | nil

self 内で super を実行した際に実行されるメソッドを [c:Method] オブジェ
クトにして返します。

- **SEE** [m:UnboundMethod#super_method]

```ruby title="例"
class Super
  def foo
    "superclass method"
  end
end

class Sub < Super
  def foo
    "subclass method"
  end
end

m = Sub.new.method(:foo) # => #<Method: Sub#foo>
p m.call # => "subclass method"
p m.super_method # => #<Method: Super#foo>
p m.super_method.call # => "superclass method"
```

### def original_name -> Symbol

オリジナルのメソッド名を返します。

```ruby title="例"
class C
  def foo; end
  alias bar foo
end
p C.new.method(:bar).original_name # => :foo
```

- **SEE** [m:UnboundMethod#original_name]

#@if (version == "3.1")
### def public? -> bool

self が public であるかどうかを返します。

### def protected? -> bool

self が protected であるかどうかを返します。

### def private? -> bool

self が private であるかどうかを返します。
#@end
