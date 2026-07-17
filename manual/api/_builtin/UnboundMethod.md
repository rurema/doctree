---
library: _builtin
---
# class UnboundMethod < Object

レシーバを持たないメソッドを表すクラスです。
呼び出すためにはレシーバにバインドする必要があります。

[m:Module#instance_method] や
[m:Method#unbind] により生成し、後で
[m:UnboundMethod#bind] によりレシーバを
割り当てた [c:Method] オブジェクトを作ることができます。

```ruby title="例: Method クラスの冒頭にある例を UnboundMethod で書くと以下のようになります。"
class Foo
  def foo() "foo" end
  def bar() "bar" end
  def baz() "baz" end
end

# 任意のキーとメソッドの関係をハッシュに保持しておく
# レシーバの情報がここにはないことに注意
methods = {1 => Foo.instance_method(:foo),
           2 => Foo.instance_method(:bar),
           3 => Foo.instance_method(:baz)}

# キーを使って関連するメソッドを呼び出す
# レシーバは任意(Foo クラスのインスタンスでなければならない)
p methods[1].bind(Foo.new).call      # => "foo"
p methods[2].bind(Foo.new).call      # => "bar"
p methods[3].bind(Foo.new).call      # => "baz"
```

```ruby title="例: 以下はメソッドの再定義を UnboundMethod を使って行う方法です。普通は alias や super を使います。"
class Foo
  def foo
    p :foo
  end
  @@orig_foo = instance_method :foo
  def foo
    p :bar
    @@orig_foo.bind(self).call
  end
end

Foo.new.foo

# => :bar
#    :foo
```

## Instance Methods

### def bind(obj)    -> Method

self を obj にバインドした [c:Method] オブジェクトを生成して返します。


- **param** `obj` -- 自身をバインドしたいオブジェクトを指定します。ただしバインドできるのは、
           生成元のクラスかそのサブクラスのインスタンスのみです。

- **raise** `TypeError` -- objがbindできないオブジェクトである場合に発生します

```ruby title="例"
# クラスのインスタンスメソッドの UnboundMethod の場合
class Foo
  def foo
    "foo"
  end
end

# UnboundMethod `m' を生成
p m = Foo.instance_method(:foo) # => #<UnboundMethod: Foo#foo>

# Foo のインスタンスをレシーバとする Method オブジェクトを生成
p m.bind(Foo.new)               # => #<Method: Foo#foo>

# Foo のサブクラス Bar のインスタンスをレシーバとする Method
class Bar < Foo
end
p m.bind(Bar.new)               # => #<Method: Bar(Foo)#foo>


# モジュールのインスタンスメソッドの UnboundMethod の場合
module Foo
  def foo
    "foo"
  end
end

# UnboundMethod `m' を生成
p m = Foo.instance_method(:foo) # => #<UnboundMethod: Foo#foo>

# Foo をインクルードしたクラス Bar のインスタンスをレシーバと
# する Method オブジェクトを生成
class Bar
  include Foo
end
p m.bind(Bar.new)               # => #<Method: Bar(Foo)#foo>
```

- **SEE** [m:UnboundMethod#bind_call]
### def bind_call(recv, *args) -> object
### def bind_call(recv, *args) { ... } -> object

self を recv に bind して args を引数として呼び出します。

self.bind(recv).call(*args) と同じ意味です。

```ruby
puts Kernel.instance_method(:inspect).bind_call(BasicObject.new) # => #<BasicObject:0x000055c65e8ea7b8>
```

- **SEE** [m:UnboundMethod#bind], [m:Method#call]
### def arity    -> Integer

メソッドが受け付ける引数の数を返します。

ただし、メソッドが可変長引数を受け付ける場合、負の整数
```text
-(必要とされる引数の数 + 1)
```
を返します。C 言語レベルで実装されたメソッドが可変長引数を
受け付ける場合、-1 を返します。

```ruby title="例"
class C
  def one;    end
  def two(a); end
  def three(*a);  end
  def four(a, b); end
  def five(a, b, *c);    end
  def six(a, b, *c, &d); end
end

p C.instance_method(:one).arity     #=> 0
p C.instance_method(:two).arity     #=> 1
p C.instance_method(:three).arity   #=> -1
p C.instance_method(:four).arity    #=> 2
p C.instance_method(:five).arity    #=> -3
p C.instance_method(:six).arity     #=> -3


p String.instance_method(:size).arity    #=> 0
p String.instance_method(:replace).arity #=> 1
p String.instance_method(:squeeze).arity #=> -1
p String.instance_method(:count).arity   #=> -1
```

### def ==(other)     -> bool
### def eql?(other)   -> bool

自身と other が同じクラスあるいは同じモジュールの同じメソッドを表す場合に
true を返します。そうでない場合に false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。

```ruby title="例"
a = String.instance_method(:size)
b = String.instance_method(:size)
p a == b                            #=> true

c = Array.instance_method(:size)
p a == c                            #=> false
```

### def clone -> UnboundMethod

自身を複製した [c:UnboundMethod] オブジェクトを作成して返します。

```ruby title="例"
a = String.instance_method(:size)
b = a.clone

p a == b     # => true
```

### def inspect -> String
### def to_s    -> String

self を読みやすい文字列として返します。

詳しくは [m:Method#inspect] を参照してください。

```ruby title="例"
p String.instance_method(:count).inspect # => "#<UnboundMethod: String#count>"
```

- **SEE** [m:Method#inspect]

### def hash    -> Integer

自身のハッシュ値を返します。


```ruby title="例"
a = method(:==).unbind
b = method(:eql?).unbind
p a.eql? b          # => true
p a.hash == b.hash  # => true
p [a, b].uniq.size  # => 1
```


### def name    -> Symbol

このメソッドの名前を返します。

```ruby title="例"
a = String.instance_method(:size)
p a.name # => :size
```

### def owner    -> Class | Module

このメソッドが定義されている class か module を返します。

```ruby title="例"
p Integer.instance_method(:to_s).owner # => Integer
p Integer.instance_method(:to_c).owner # => Numeric
p Integer.instance_method(:hash).owner # => Kernel
```


### def source_location -> [String, Integer] | nil

ソースコードのファイル名と行番号を配列で返します。

その手続オブジェクトが ruby で定義されていない(つまりネイティブ
である)場合は nil を返します。

```ruby title="例"
require 'time'

p Time.instance_method(:zone).source_location     # => nil
p Time.instance_method(:httpdate).source_location # => ["/Users/user/.rbenv/versions/2.4.3/lib/ruby/2.4.0/time.rb", 654]
```

- **SEE** [m:Proc#source_location], [m:Method#source_location]

### def parameters -> [object]

UnboundMethod オブジェクトの引数の情報を返します。

詳しくは [m:Method#parameters] を参照してください。

#@#noexample Method#parametersを参照


- **SEE** [m:Proc#parameters], [m:Method#parameters]

### def super_method -> UnboundMethod | nil

self 内で super を実行した際に実行されるメソッドを [c:UnboundMethod] オブジェ
クトにして返します。

#@#noexample Method#super_methodを参照

- **SEE** [m:Method#super_method]

### def original_name -> Symbol

オリジナルのメソッド名を返します。

```ruby title="例"
class C
  def foo; end
  alias bar foo
end
p C.instance_method(:bar).original_name # => :foo
```

- **SEE** [m:Method#original_name]

#@if (version == "3.1")
### def public? -> bool

self が public であるかどうかを返します。

### def protected? -> bool

self が protected であるかどうかを返します。

### def private? -> bool

self が private であるかどうかを返します。
#@end
