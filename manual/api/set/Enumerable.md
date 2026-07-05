---
library: set
until: "3.2"
---
# reopen Enumerable

## Instance Methods

### def to_set(klass = Set, *args) -> Set
### def to_set(klass = Set, *args) {|o| ... } -> Set

Enumerable オブジェクトの要素から、新しい集合オブジェクトを作ります。

引数 klass を与えた場合、Set クラスの代わりに、指定した集合クラスの
インスタンスを作ります。
#@since 3.0
この引数を指定することで、ユーザ定義の集合クラスのインスタンスを作ることができます
(ここでいう集合クラスとは、Setとメソッド/クラスメソッドで互換性のあるクラスです。
Ruby 2.7 以前は SortedSet が定義されていました)。
#@else
この引数を指定することで、SortedSet あるいはその他のユーザ定義の
集合クラスのインスタンスを作ることができます
(ここでいう集合クラスとは、Setとメソッド/クラスメソッドで互換性のあるクラスです)。
#@end
引数 args およびブロックは、集合オブジェクトを生成するための new
メソッドに渡されます。


- **param** `klass` -- 生成する集合クラスを指定します。
- **param** `args` -- 集合クラスのオブジェクト初期化メソッドに渡す引数を指定します。
- **param** `block` -- 集合クラスのオブジェクト初期化メソッドに渡すブロックを指定します。
- **return** -- 生成された集合オブジェクトを返します。

```ruby
require 'set'
p [30, 10, 20].to_set
#=> #<Set: {30, 10, 20}>
#@until 3.0
p [30, 10, 20].to_set(SortedSet)
#=> #<SortedSet: {10, 20, 30}>
#@end
MySet = Class.new(Set)
p [30, 10, 20].to_set(MySet)
#=> #<MySet: {10, 20, 30}>
p [30, 10, 20].to_set {|num| num / 10}
#=> #<Set: {3, 1, 2}>
```

- **SEE** [m:Set.new]

