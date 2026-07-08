---
library: prime
include:
  - Enumerable
---
# class Prime::PseudoPrimeGenerator < Object

擬似素数列の列挙子のための抽象クラスです。

[c:Prime] の各メソッドが使用する低水準の擬似素数列挙子は、 Prime::PseudoPrimeGenerator のインスタンスであることが期待されています。
このクラスを継承する具象クラスは succ, next, rewind をオーバーライドしなければなりません。

独自の素数列挙アルゴリズムを実装しようとする場合を除いて、ユーザーがこのクラスを利用する必要はありません。高水準の [c:Prime] クラスを利用してください。

## Class Methods

### def new(upper_bound = nil) -> Prime::PseudoPrimeGenerator

自身を初期化します。

- **param** `upper_bound` -- 列挙する素数の上界を指定します。

## Instance Methods

### def each {|prime| ... } -> object
### def each -> self

素数を与えられたブロックに渡して評価します。

### def next -> ()
### def succ -> ()

次の擬似素数を返します。
また内部的な位置を進めます。

サブクラスで実装してください。

- **raise** `NotImplementedError` -- 必ず発生します。

### def rewind -> ()

列挙状態を巻き戻します。

サブクラスで実装してください。

- **raise** `NotImplementedError` -- 必ず発生します。

- **SEE** [m:Enumerator#rewind]

### def upper_bound -> Integer | nil

現在の列挙上界を返します。 nil は上界がなく無限に素数を列挙すべきであることを意味します。

### def upper_bound=(upper_bound)

新しい列挙上界をセットします。

- **param** `upper_bound` -- 新しい上界を整数または nil で指定します。 nil は上界がなく無限に素数を列挙すべきであることを意味します。

### def with_index{|prime, index| ... }      -> self
### def each_with_index{|prime, index| ... } -> self
### def with_index      -> Enumerator
### def each_with_index -> Enumerator

与えられたブロックに対して、素数を0起点の連番を渡して評価します。

- **return** -- ブロックを与えられた場合は self を返します。 ブロックを与えられなかった場合は Enumerator を返します。

```ruby title="例"
require 'prime'
Prime::EratosthenesGenerator.new(10).each_with_index do |prime, index|
  p [prime, index]
end
# [2, 0]
# [3, 1]
# [5, 2]
# [7, 3]
```

- **SEE** [m:Enumerator#with_index]

### def with_object(obj){|prime, obj| ... } -> object
### def with_object(obj) -> Enumerator

与えられた任意のオブジェクトと要素をブロックに渡して評価します。

- **param** `obj` -- 任意のオブジェクトを指定します。
- **return** -- 最初に与えられたオブジェクトを返します。
- **return** -- ブロックを与えられた場合は obj を返します。ブロックを与えられなかった場合は Enumerator を返します。

- **SEE** [m:Enumerator#with_object]

