---
library: _builtin
include:
  - Enumerable
---
# class Struct < Object

構造体クラス。Struct.new はこのクラスのサブクラスを新たに生成します。

個々の構造体はサブクラスから [m:Struct.new] を使って生成します。個々
の構造体サブクラスでは構造体のメンバに対するアクセスメソッドが定義され
ています。

## Class Methods

#@since 3.1
### def new(*args, keyword_init: nil)                     -> Class
### def new(*args, keyword_init: nil) {|subclass| block } -> Class
#@else
### def new(*args, keyword_init: false)                     -> Class
### def new(*args, keyword_init: false) {|subclass| block } -> Class
#@end

[c:Struct] クラスに新しいサブクラスを作って、それを返します。

サブクラスでは構造体のメンバに対するアクセスメソッドが定義されています。

```ruby title="例"
dog = Struct.new("Dog", :name, :age)
fred = dog.new("fred", 5)
fred.age = 6
printf "name:%s age:%d", fred.name, fred.age
#=> "name:fred age:6" を出力します
```

実装の都合により、クラス名の省略は後づけの機能でした。
メンバ名に [c:String] を指定できるのは後方互換性のためだと考えた方が良いでしょう。
したがって、メンバ名は [c:Symbol] で指定するのが無難です。

- **param** `args` -- 構造体を定義するための可変長引数。[c:String] または [c:Symbol] を指定します。
#@since 3.2
- **param** `keyword_init` -- 構造体クラスのインスタンスを生成する際に、キーワード引数を使用するかどうかを指定します。値の意味は次のとおりです。

  - nil: キーワード引数と位置引数のどちらを使用してもよい
  - true: キーワード引数のみ使用できる
  - false: キーワード引数は使用できず、位置引数のみ使用できる

#@else
- **param** `keyword_init` -- true を指定すると、キーワード引数で初期化する構造体を定義します。
#@end
#@if (version == "3.1")
                    Ruby 3.1 では互換性に影響のある使い方をしたときに警告が出るため、
                    従来の挙動を期待する構造体には明示的に false を指定してください。
#@end

#@since 3.2

```ruby title="例"
Point1 = Struct.new(:x, :y)
p Point1.new(1, 2)           # => #<struct Point1 x=1, y=2>
p Point1.new(x: 1, y: 2)     # => #<struct Point1 x=1, y=2>
p Point1.new(x: 1)           # => #<struct Point1 x=1, y=nil>
p Point1.new(y: 2)           # => #<struct Point1 x=nil, y=2>
Point1.new(x: 1, y: 2, z: 3) # ~> ArgumentError: unknown keywords: z

Point2 = Struct.new(:x, :y, keyword_init: nil)
p Point2.new(1, 2)           # => #<struct Point2 x=1, y=2>
p Point2.new(x: 1, y: 2)     # => #<struct Point2 x=1, y=2>
p Point2.new(x: 1)           # => #<struct Point2 x=1, y=nil>
p Point2.new(y: 2)           # => #<struct Point2 x=nil, y=2>
Point2.new(x: 1, y: 2, z: 3) # ~> ArgumentError: unknown keywords: z

Point3 = Struct.new(:x, :y, keyword_init: true)
Point3.new(1, 2)             # => wrong number of arguments (given 2, expected 0) (ArgumentError)
p Point3.new(x: 1, y: 2)     # => #<struct Point3 x=1, y=2>
p Point3.new(x: 1)           # => #<struct Point3 x=1, y=nil>
p Point3.new(y: 2)           # => #<struct Point3 x=nil, y=2>
Point3.new(x: 1, y: 2, z: 3) # ~> ArgumentError: unknown keywords: z

Point4 = Struct.new(:x, :y, keyword_init: false)
p Point4.new(1, 2)           # => #<struct Point4 x=1, y=2>
p Point4.new(x: 1, y: 2)     # => #<struct Point4 x={:x=>1, :y=>2}, y=nil>
                             # これは Point4.new({x: 1, y: 2}) とみなされていることに注意
p Point4.new(x: 1)           # => #<struct Point4 x={:x=>1}, y=nil>
p Point4.new(y: 2)           # => #<struct Point4 x={:y=>2}, y=nil>
p Point4.new(x: 1, y: 2, z: 3) # => #<struct Point4 x={:x=>1, :y=>2, :z=>3}, y=nil>
```

#@else

```ruby title="例"
Point = Struct.new(:x, :y, keyword_init: true) # => Point(keyword_init: true)
p Point.new(x: 1, y: 2) # => #<struct Point x=1, y=2>
p Point.new(x: 1)     # => #<struct Point x=1, y=nil>
p Point.new(y: 2)     # => #<struct Point x=nil, y=2>
Point.new(z: 3)       # ArgumentError (unknown keywords: z)
```

#@if (version == "3.1")

```ruby title="警告が出る例"
Point = Struct.new(:x, :y)
p Point.new(x: 1, y: 2) # => #<struct Point x={:x=>1, :y=>2}, y=nil>
                        # warning: Passing only keyword arguments to Struct#initialize will behave differently from Ruby 3.2. Please use a Hash literal like .new({k: v}) instead of .new(k: v).

# keyword_init: falseを指定すると警告は出ない
Point2 = Struct.new(:x, :y, keyword_init: false)
p Point2.new(x: 1, y: 2)  # => #<struct Point2 x={:x=>1, :y=>2}, y=nil>
```

#@end
#@end

### 第一引数が String の場合

args[0] が [c:String] の場合、クラス名になるので、大文字で始まる必要
があります。つまり、以下のような指定はエラーになります。

```ruby title="例"
p Struct.new('foo', 'bar')
#@since 3.4
# => -:1:in 'new': identifier foo needs to be constant (NameError)
#@else
# => -:1:in `new': identifier foo needs to be constant (NameError)
#@end
```

また args[1..-1] は、[c:Symbol] か [c:String] で指定します。

```ruby title="例"
p Struct.new("Foo", :foo, :bar)   # => Struct::Foo
```

### 第一引数が Symbol の場合

args[0] が [c:Symbol] の場合、生成した構造体クラスは名前の無い
クラスになります。名前の無いクラスは最初に名前を求める際に代入され
ている定数名を検索し、見つかった定数名をクラス名とします。

```ruby title="例"
Foo = Struct.new(:foo, :bar)
p Foo                             # => Foo
```

### ブロックを指定した場合

Struct.new にブロックを指定した場合は定義した Struct をコンテキストにブ
ロックを評価します。また、定義した Struct はブロックパラメータにも渡さ
れます。

```ruby title="例"
Customer = Struct.new(:name, :address) do
  def greeting
    "Hello #{name}!"
  end
end
p Customer.new("Dave", "123 Main").greeting # => "Hello Dave!"
```

Structをカスタマイズする場合はこの方法が推奨されます。無名クラスのサブ
クラスを作成する方法でカスタマイズする場合は無名クラスが使用されなくなっ
てしまうことがあるためです。

- **SEE** [m:Class.new]

### def new(*args) -> Struct
### def [](*args) -> Struct

(このメソッドは Struct の下位クラスにのみ定義されています)
構造体オブジェクトを生成して返します。

- **param** `args` -- 構造体の初期値を指定します。メンバの初期値は指定されなければ nil です。

- **return** -- 構造体クラスのインスタンス。

- **raise** `ArgumentError` -- 構造体のメンバの数よりも多くの引数を指定した場合に発生します。

```ruby title="例"
Foo = Struct.new(:foo, :bar)
foo = Foo.new(1)
p foo.values      # => [1, nil]
```

### def members -> [Symbol]

(このメソッドは Struct の下位クラスにのみ定義されています)
構造体のメンバの名前([c:Symbol])の配列を返します。

```ruby title="例"
Foo = Struct.new(:foo, :bar)
p Foo.members      # => [:foo, :bar]
```

#@since 3.1
### def keyword_init? -> bool | nil

(このメソッドは Struct の下位クラスにのみ定義されています)
構造体が作成されたときに keyword_init: true を指定されていたら true を返します。
false を指定されていたら false を返します。
それ以外の場合は nil を返します。

```ruby title="例"
Foo = Struct.new(:a)
p Foo.keyword_init? # => nil
Bar = Struct.new(:a, keyword_init: true)
p Bar.keyword_init? # => true
Baz = Struct.new(:a, keyword_init: false)
p Baz.keyword_init? # => false
```

#@end
## Instance Methods

### def [](member) -> object

構造体のメンバの値を返します。

- **param** `member` -- [c:Integer] でメンバのインデックスを指定します。
              [c:Symbol], [c:String] でメンバの名前を指定します。

- **raise** `IndexError` -- member が整数で存在しないメンバを指定した場合に発生します。

- **raise** `NameError` -- member が [c:String], [c:Symbol] で存在しないメンバを指定した場合に発生します。

```ruby title="例"
Foo = Struct.new(:foo, :bar)
obj = Foo.new('FOO', 'BAR')
p obj[:foo]     # => "FOO"
p obj['bar']    # => "BAR"
#@since 3.4
# p obj[:baz]     # => in '[]': no member 'baz' in struct (NameError)
#@else
# p obj[:baz]     # => in `[]': no member 'baz' in struct (NameError)
#@end
p obj[0]        # => "FOO"
p obj[1]        # => "BAR"
p obj[-1]       # => "BAR"    # Array のように負のインデックスも指定できます。
#@since 3.4
# p obj[2]        # => in '[]': offset 2 too large for struct(size:2) (IndexError)
#@else
# p obj[2]        # => in `[]': offset 2 too large for struct(size:2) (IndexError)
#@end
```

#@include(Struct.attention)

### def []=(member, value)

構造体の member で指定されたメンバの値を value にして value を返します。

- **param** `member` -- [c:Integer] でメンバのインデックスを指定します。
              [c:Symbol], [c:String] でメンバの名前を指定します。

- **param** `value` -- メンバに設定する値を指定します。

- **raise** `IndexError` -- member が整数で存在しないメンバを指定した場合に発生します。

- **raise** `NameError` -- member が [c:String], [c:Symbol] で存在しないメンバを指定した場合に発生します。

#@include(Struct.attention)

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)

joe["name"] = "Luke"
joe[:zip]   = "90210"

p joe.name #=> "Luke"
p joe.zip  #=> "90210"
```

### def each {|value| ... } -> self
### def each -> Enumerator

構造体の各メンバに対して繰り返します。

#@include(Struct.attention)

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
joe.each {|x| puts(x) }

# => Joe Smith
#    123 Maple, Anytown NC
#    12345
```

### def each_pair {|member, value| ... } -> self
### def each_pair -> Enumerator

構造体のメンバ名([c:Symbol])と値の組を引数にブロックを繰り返し実行します。

```ruby title="例"
Foo = Struct.new(:foo, :bar)
Foo.new('FOO', 'BAR').each_pair {|m, v| p [m,v]}
# => [:foo, "FOO"]
#    [:bar, "BAR"]
```

#@include(Struct.attention)

### def length -> Integer
### def size -> Integer

構造体のメンバの数を返します。

#@include(Struct.attention)

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
p joe.length #=> 3
```

### def members -> [Symbol]

構造体のメンバの名前([c:Symbol])の配列を返します。

```ruby title="例"
Foo = Struct.new(:foo, :bar)
p Foo.new.members  # => [:foo, :bar]
```

#@include(Struct.attention)

### def values -> [object]
### def to_a -> [object]
### def deconstruct -> [object]

構造体のメンバの値を配列にいれて返します。

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
p Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345).to_a
# => ["Joe Smith", "123 Maple, Anytown NC", 12345]
```

#@include(Struct.attention)

- **SEE** [ref:d:spec/pattern_matching#matching_non_primitive_objects]

### def deconstruct_keys(array_of_names) -> Hash

self のメンバの名前と値の組を [c:Hash] で返します。

- **param** `array_of_names` -- 返り値に含めるメンバの名前の配列を指定します。nil の場合は全てのメンバを意味します。

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
h = joe.deconstruct_keys([:zip, :address])
p h # => {:zip=>12345, :address=>"123 Maple, Anytown NC"}

# 引数が nil の場合は全てのメンバを返します。
h = joe.deconstruct_keys(nil)
p h # => {:name=>"Joseph Smith, Jr.", :address=>"123 Maple, Anytown NC", :zip=>12345}
```

#@include(Struct.attention)

- **SEE** [ref:d:spec/pattern_matching#matching_non_primitive_objects]

### def inspect -> String
### def to_s    -> String

self の内容を人間に読みやすい文字列にして返します。

#@include(Struct.attention)

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
joe = Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345)
p joe.inspect # => "#<struct Customer name=\"Joe Smith\", address=\"123 Maple, Anytown NC\", zip=12345>"
```

### def select {|i| ... } -> [object]
### def select -> Enumerator
### def filter {|i| ... } -> [object]
### def filter -> Enumerator

構造体のメンバの値に対してブロックを評価した値が真であった要素を全て含
む配列を返します。真になる要素がひとつもなかった場合は空の配列を返しま
す。

ブロックを省略した場合は [c:Enumerator] を返します。

```ruby title="例"
Lots = Struct.new(:a, :b, :c, :d, :e, :f)
l = Lots.new(11, 22, 33, 44, 55, 66)
p l.select {|v| (v % 2).zero? } #=> [22, 44, 66]
```

#@include(Struct.attention)

- **SEE** [m:Enumerable#select]

### def values_at(*members) -> [object]

引数で指定されたメンバの値の配列を返します。

- **param** `members` -- [c:Integer] か [c:Range] でメンバのインデックスを指定します。

- **raise** `IndexError` -- member が整数で存在しないメンバを指定した場合に発生します。

```ruby title="例"
Foo = Struct.new(:foo, :bar, :baz)
obj = Foo.new('FOO', 'BAR', 'BAZ')
p obj.values_at(0, 1, 2)    # => ["FOO", "BAR", "BAZ"]
```

#@include(Struct.attention)

### def dig(key, ...) -> object | nil

self 以下のネストしたオブジェクトを dig メソッドで再帰的に参照して返し
ます。途中のオブジェクトが nil であった場合は nil を返します。

- **param** `key` -- キーを任意個指定します。

```ruby title="例"
klass = Struct.new(:a)
o = klass.new(klass.new({b: [1, 2, 3]}))

p o.dig(:a, :a, :b, 0)            # => 1
p o.dig(:b, 0)                    # => nil
```

- **SEE** [m:Array#dig], [m:Hash#dig], [m:OpenStruct#dig]

### def ==(other)    -> bool

self と other のクラスが同じであり、各メンバが == メソッドで比較して等しい場合に
true を返します。そうでない場合に false を返します。

- **param** `other` -- self と比較したいオブジェクトを指定します。

```ruby title="例"
Dog = Struct.new(:name, :age)
dog1 = Dog.new("fred", 5)
dog2 = Dog.new("fred", 5)

p dog1 == dog2                #=> true
p dog1.eql?(dog2)             #=> true
p dog1.equal?(dog2)           #=> false
```

#@include(Struct.attention)

- **SEE** [m:Struct#eql?]

### def eql?(other)    -> bool

self と other のクラスが同じであり、各メンバが eql? メソッドで比較して等しい場合に
true を返します。そうでない場合に false を返します。

- **param** `other` -- self と比較したいオブジェクトを指定します。

```ruby title="例"
Dog = Struct.new(:name, :age)
dog1 = Dog.new("fred", 5)
dog2 = Dog.new("fred", 5)

p dog1 == dog2                #=> true
p dog1.eql?(dog2)             #=> true
p dog1.equal?(dog2)           #=> false
```

#@include(Struct.attention)

- **SEE** [m:Struct#==]

### def equal?(other)   -> bool

指定された other が self 自身である場合のみ真を返します。
これは [c:Object] クラスで定義されたデフォルトの動作で
す。

#@include(Struct.attention)

#@#noexample Object#equal? のデフォルトの動作と変わらないため

- **SEE** [m:Struct#eql?], [m:Struct#==]

### def hash    -> Integer

self が保持するメンバのハッシュ値を元にして算出した整数を返します。
self が保持するメンバの値が変化すればこのメソッドが返す値も変化します。

```ruby title="例"
Dog = Struct.new(:name, :age)
dog = Dog.new("fred", 5)
p dog.hash                    #=> 7917421
dog.name = "john"
p dog.hash                    #=> -38913223
```

#@include(Struct.attention)
### def to_h -> Hash
### def to_h {|member, value| block } -> Hash

self のメンバ名([c:Symbol])と値の組を [c:Hash] にして返します。

```ruby title="例"
Customer = Struct.new(:name, :address, :zip)
p Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345).to_h
# => {:name=>"Joe Smith", :address=>"123 Maple, Anytown NC", :zip=>12345}
```

ブロックを指定すると各ペアでブロックを呼び出し、
その結果をペアとして使います。

```ruby title="ブロック付きの例"
Customer = Struct.new(:name, :address, :zip)
p Customer.new("Joe Smith", "123 Maple, Anytown NC", 12345).to_h {|member, value|
  [member, value*2]
} # => {:name=>"Joe SmithJoe Smith", :address=>"123 Maple, Anytown NC123 Maple, Anytown NC", :zip=>24690}
```

#@include(Struct.attention)
