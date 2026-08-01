---
library: _builtin
since: "3.2"
---
# class Enumerator::Product < Enumerator

複数の [c:Enumerable] なオブジェクトの直積(デカルト積)を列挙するためのクラス。

このクラスのオブジェクトは [m:Enumerator.product] から作られます。

各要素は、与えたオブジェクトの数と同じ大きさの配列になります。
右側のオブジェクトほど内側のループになり、最後のオブジェクトが最も速く進みます。

```ruby title="例"
e = Enumerator::Product.new(1..2, ["a", "b"])
e.each do |i, s|
  p [i, s]
end
# => [1, "a"]
#    [1, "b"]
#    [2, "a"]
#    [2, "b"]
```

## Class Methods

### def Enumerator::Product.new(*enums) -> Enumerator::Product

与えた [c:Enumerable] なオブジェクトの直積を列挙する Enumerator を作って返します。

- **param** `enums` -- 直積を取る [c:Enumerable] なオブジェクトを指定します。

```ruby title="例"
e = Enumerator::Product.new(1..3, [4, 5])
p e.to_a # => [[1, 4], [1, 5], [2, 4], [2, 5], [3, 4], [3, 5]]
p e.size # => 6
```

- **SEE** [m:Enumerator.product]

## Instance Methods

### def each { |*args| ... } -> self
### def each -> Enumerator

各オブジェクトの直積の要素を、配列としてブロックに渡して繰り返します。

各オブジェクトに対しては each ではなく each_entry を呼び出します。
そのため、N 個のオブジェクトの直積は、各繰り返しでちょうど N 要素の配列になります。

オブジェクトを1つも与えずに作った場合は、空の引数リストでブロックを1回だけ呼びます。

ブロックを渡さない場合は [c:Enumerator] を返します。

```ruby title="例"
e = Enumerator::Product.new(1..2, ["a", "b"])
e.each do |i, s|
  p [i, s]
end
# => [1, "a"]
#    [1, "b"]
#    [2, "a"]
#    [2, "b"]
```

### def inspect -> String

self を人間が読みやすい形式の文字列にして返します。

```ruby title="例"
e = Enumerator::Product.new(1..3, [4, 5])
p e.inspect # => "#<Enumerator::Product: [1..3, [4, 5]]>"
```

### def rewind -> self

列挙状態を巻き戻します。

self が持つ各オブジェクトに対して、逆順で rewind メソッドを呼びます。
ただし rewind メソッドを持たないオブジェクトに対しては呼びません。

### def size -> Integer | Float::INFINITY | nil

直積の要素数を返します。

各オブジェクトのサイズの積を返します。
サイズが分からないオブジェクトが含まれる場合は nil を、
無限に続くオブジェクトが含まれる場合は [m:Float::INFINITY] を返します。

```ruby title="例"
p Enumerator::Product.new(1..3, [4, 5]).size    # => 6
p Enumerator::Product.new(1.., [4, 5]).size     # => Infinity
```
