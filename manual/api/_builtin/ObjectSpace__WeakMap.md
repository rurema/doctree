---
library: _builtin
since: "2.0.0"
---
# class ObjectSpace::WeakMap

GC の対象になるオブジェクトへの weak reference を持つクラスです。
#@since 4.0
[c:WeakRef] クラスの内部で使用されているほか、[m:ObjectSpace?._id2ref] が
deprecated になった Ruby 4.0 以降では、オブジェクト ID からオブジェクトを
引く用途([m:Object#object_id] をキーとしてオブジェクトを保持しておく方法)
の代替としても案内されています。詳しくは [m:ObjectSpace?._id2ref] を参照
してください。
#@else
主に [c:WeakRef] クラスの内部で使用されるため、[lib:weakref] ライブラリ
経由で使用してください。
#@end

## Public Instance Methods

### def [](key) -> object | nil

引数 key で指定されたオブジェクトが参照するオブジェクトを返します。

参照先のオブジェクトが存在しない場合、GC されている場合、対象外のオブジェ
クトを参照している場合に nil を返します。

- **param** `key` -- 参照元のオブジェクトを指定します。

判定はオブジェクトの同一性([m:Object#equal?])によって行われます。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

p weak_map[key]    # => "test"
p weak_map["text"] # => nil (内容は同じでも別オブジェクトなので nil)
```

- **SEE** [m:ObjectSpace::WeakMap#\[\]=], [m:ObjectSpace::WeakMap#key?]

### def []=(key, value)

引数 key から引数 value への参照を作成します。

- **param** `key` -- 参照元のオブジェクトを指定します。

- **param** `value` -- 参照先のオブジェクトを指定します。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test" # => test
p weak_map[key] # => test
```

#@since 3.3
### def delete(key) -> object | nil
### def delete(key) {|key| ... } -> object

引数 key に対応するエントリを取り除きます。

- **param** `key` -- 取り除くエントリの参照元のオブジェクトを指定します。

- **return** -- 取り除かれたエントリの参照先のオブジェクトを返します。
        key に対応するエントリが存在しない場合は nil を返します。

ブロックを指定した場合、key に対応するエントリが存在しない時に限りブロックが評価され、
その結果を返します。key に対応するエントリが存在する場合、ブロックは評価されません。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "foo"
weak_map[key] = "test"

p weak_map.delete(key) # => "test"
p weak_map[key]        # => nil
p weak_map.delete(key) # => nil

p weak_map.delete("bar") { |k| "#{k} not found" } # => "bar not found"
```

- **SEE** [m:ObjectSpace::WeakMap#\[\]=]
#@end

### def key?(key)     -> bool
### def include?(key) -> bool
### def member?(key)  -> bool

引数 key を参照元とするエントリを保持している場合に true を返します。

判定はオブジェクトの同一性([m:Object#equal?])によって行われます。
== や eql? による判定は行われないため、内容が等しくても別オブジェクトであれば
false になります。

- **param** `key` -- 探索するオブジェクトを指定します。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

p weak_map.key?(key)     # => true
p weak_map.include?(key) # => true
p weak_map.member?(key)  # => true

p weak_map.key?("text")  # => false (内容は同じでも別オブジェクトなので false)
```

- **SEE** [m:ObjectSpace::WeakMap#\[\]]

### def each {|key, value| ... } -> self
### def each_pair {|key, value| ... } -> self

保持しているエントリの参照元オブジェクトと参照先オブジェクトを引数としてブロックを評価します。

GC によって参照先が回収されたエントリは反復の対象になりません。反復の順序は不定です。

[c:Hash] など他の反復可能なクラスと異なり、ブロックを省略しても [c:Enumerator] は
返しません。エントリが1つ以上ある状態でブロックを指定せずに呼び出すと
LocalJumpError が発生します。

each_pair は each のエイリアスです。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

weak_map.each { |k, v| p [k, v] } # => ["text", "test"]
```

- **SEE** [m:ObjectSpace::WeakMap#each_key], [m:ObjectSpace::WeakMap#each_value]

### def each_key {|key| ... } -> self

保持しているエントリの参照元オブジェクトを引数としてブロックを評価します。

GC によって参照先が回収されたエントリは反復の対象になりません。反復の順序は不定です。

[c:Hash] など他の反復可能なクラスと異なり、ブロックを省略しても [c:Enumerator] は
返しません。エントリが1つ以上ある状態でブロックを指定せずに呼び出すと
LocalJumpError が発生します。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

weak_map.each_key { |k| p k } # => "text"
```

- **SEE** [m:ObjectSpace::WeakMap#each], [m:ObjectSpace::WeakMap#each_value]

### def each_value {|value| ... } -> self

保持しているエントリの参照先オブジェクトを引数としてブロックを評価します。

GC によって参照先が回収されたエントリは反復の対象になりません。反復の順序は不定です。

[c:Hash] など他の反復可能なクラスと異なり、ブロックを省略しても [c:Enumerator] は
返しません。エントリが1つ以上ある状態でブロックを指定せずに呼び出すと
LocalJumpError が発生します。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

weak_map.each_value { |v| p v } # => "test"
```

- **SEE** [m:ObjectSpace::WeakMap#each], [m:ObjectSpace::WeakMap#each_key]

### def keys -> [object]

保持しているエントリの参照元オブジェクトからなる配列を返します。

GC によって参照先が回収されたエントリのキーは含まれません。返される配列の要素の
順序は不定です。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

p weak_map.keys # => ["text"]
```

- **SEE** [m:ObjectSpace::WeakMap#values]

### def values -> [object]

保持しているエントリの参照先オブジェクトからなる配列を返します。

GC によって回収されたエントリの値は含まれません。返される配列の要素の順序は
不定です。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

p weak_map.values # => ["test"]
```

- **SEE** [m:ObjectSpace::WeakMap#keys]

### def size   -> Integer
### def length -> Integer

保持しているエントリの数を返します。GC によって回収されたエントリは数えません。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
key = "text"
weak_map[key] = "test"

p weak_map.size   # => 1
p weak_map.length # => 1
```

### def inspect -> String

self の情報を人間に読みやすい文字列にして返します。

各エントリは `参照元 => 参照先` の形式で出力されます。[c:Integer]・[c:Symbol]・
true・false・nil などの immediate な値はそれ自身を [m:Object#inspect] した結果が
使われますが、それ以外のオブジェクトは to_s や inspect を呼び出さずに
`#<クラス名:0xアドレス>` の形式で表示されます。

```ruby title="例"
weak_map = ObjectSpace::WeakMap.new
weak_map[:key] = 1

p weak_map.inspect # => "#<ObjectSpace::WeakMap:0x00007f5b6c0a5d20: :key => 1>"
```
