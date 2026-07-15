---
type: library
until: "3.2"
category: Math
---
集合を表す Set クラスを提供します。

集合とは重複のないオブジェクトの集まりです。
[c:Array] の持つ演算機能と [c:Hash] の高速な検索機能を合わせ持ちます。

Set は内部記憶として [c:Hash] を使うため、集合要素の等価性は
[m:Object#eql?] と [m:Object#hash] を用いて判断されます。
したがって、集合の各要素には、これらのメソッドが適切に定義されている
必要があります。

Set クラスでは、集合要素を取り出す際の順序は保証されません。

また、set ライブラリを require すると [c:Enumerable] モジュールが
拡張され、[m:Enumerable#to_set] の形で集合オブジェクトを生成できる
ようになります。

### 注意事項

#@since 3.2
集合オブジェクトに対する freeze メソッドの効果は、
内部記憶として保持するハッシュにも適用されます。
#@else
集合オブジェクトに対する taint, untaint, freeze の各
メソッドの効果は、内部記憶として保持するハッシュにも適用されます。

集合オブジェクトおよびその内部記憶にセットされた taint 情報は、
dupおよび clone メソッドによって複製された集合オブジェクトにもコピー
されます。
#@end

### 例
```ruby
require 'set'

set1 = Set.new ["foo", "bar", "baz", "foo"]

p set1                  # => #<Set: {"foo", "bar", "baz"}>
p set1.include?("bar")  # => true

set1.add("heh")
set1.delete("foo")
p set1                  # => #<Set: {"bar", "baz", "heh"}>
```

