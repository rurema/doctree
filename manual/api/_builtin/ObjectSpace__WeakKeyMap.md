---
library: _builtin
since: "3.3"
---
# class ObjectSpace::WeakKeyMap < Object

キーへの弱参照を持つ、キーと値の組を保持するクラスです。

キーは他から参照されなくなると GC の対象になり、そのときキーと値の組は
map から取り除かれます。値への参照は強参照なので、map に入っている間は
GC されません。

[c:ObjectSpace::WeakMap] との違いは以下の 3 点です。

  - 値への参照が強参照です。map に入っている間は GC されません。
  - キーの比較が同一性([m:Object#equal?])ではなく等値性([m:Object#eql?])で
    行われます。
  - GC の対象になるオブジェクトだけをキーにできます。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1

# キーは等値性で比較されるので、別のオブジェクトでも引ける
p map["name"] # => 1

key = nil
GC.start
# キーへの参照が無くなったので、キーと値の組が取り除かれる
p map["name"] # => nil
```

上の例の [m:GC.start] は説明のために書いたもので、いつでもこのとおりに
GC されるとは限りません。

同じ値を表すオブジェクトを 1 つだけ保持しておきたい場合、たとえば軽量な値オブジェクトのキャッシュを実装する用途に向いています。
[m:ObjectSpace::WeakKeyMap#getkey] を参照してください。

## Instance Methods

### def [](key) -> object | nil

key に対応する値を返します。

key に対応する組が無い場合は nil を返します。

- **param** `key` -- 探すキーを指定します。等値性([m:Object#eql?])で比較されます。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1

p map["name"] # => 1
p map["zzz"]  # => nil
```

- **SEE** [m:ObjectSpace::WeakKeyMap#\[\]=], [m:ObjectSpace::WeakKeyMap#getkey]

### def []=(key, value)

key に対応する値として value を登録します。

key への参照は弱参照です。他から key を参照するものが無くなると、キーと値の組は GC によって取り除かれます。値そのものへの参照は強参照です。

key に対応する組が既にある場合は、値だけを置き換えます。

- **param** `key` -- キーを指定します。GC の対象になるオブジェクトだけを
             指定できます。

- **param** `value` -- 値を指定します。

- **raise** `ArgumentError` -- GC の対象にならないオブジェクト([c:Integer] や
             [c:Symbol] など)をキーに指定した場合に発生します。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1
p map["name"] # => 1

map[key] = 2
p map["name"] # => 2

map[1] = 3 # ~> ArgumentError
```

- **SEE** [m:ObjectSpace::WeakKeyMap#\[\]]

### def getkey(key) -> object | nil

key と等値なキーが登録されていれば、登録されているほうのオブジェクトを返します。無い場合は nil を返します。

同じ値を表すオブジェクトを 1 つにまとめる用途に使えます。

- **param** `key` -- 探すキーを指定します。

```ruby
value = { amount: 1, currency: "USD" }

cache = ObjectSpace::WeakKeyMap.new
cache[value] = true

# 等値な別のオブジェクトを渡しても、登録済みのオブジェクトが返る
copy = cache.getkey({ amount: 1, currency: "USD" })
p copy.equal?(value) # => true
```

- **SEE** [m:ObjectSpace::WeakKeyMap#\[\]]

### def key?(key) -> bool

key に対応する組があれば true を、無ければ false を返します。

- **param** `key` -- 探すキーを指定します。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1

p map.key?("name") # => true
p map.key?("zzz")  # => false
```

### def delete(key) -> object | nil
### def delete(key) {|key| ... } -> object

key に対応する組を取り除き、その値を返します。

key に対応する組が無い場合、ブロックを指定していなければ nil を返します。
ブロックを指定していれば、key を引数としてブロックを実行し、その結果を返します。
key に対応する組がある場合、ブロックは実行されません。

- **param** `key` -- 取り除く組のキーを指定します。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1

p map.delete("name") # => 1
p map["name"]        # => nil

p map.delete("zzz")                   # => nil
p map.delete("zzz") { |k| "no #{k}" } # => "no zzz"
```

### def clear -> self

すべての組を取り除きます。`self` を返します。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1

map.clear
p map["name"] # => nil
```

### def inspect -> String

`self` の情報を含む文字列を返します。

```ruby
map = ObjectSpace::WeakKeyMap.new
key = "name"
map[key] = 1

p map.inspect # => "#<ObjectSpace::WeakKeyMap:0x00007f8f0a0b1234 size=1>"
```
