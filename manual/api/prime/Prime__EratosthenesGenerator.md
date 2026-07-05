---
library: prime
---
# class Prime::EratosthenesGenerator < Prime::PseudoPrimeGenerator

[c:Prime::PseudoPrimeGenerator] の具象クラスです。
素数の生成にエラトステネスのふるいを使用しています。

## Instance Methods

### def next -> Integer
### def succ -> Integer

次の(擬似)素数を返します。なお、この実装においては擬似素数は真に素数です。

また内部的な列挙位置を進めます。

```ruby title="例"
require 'prime'
generator = Prime::EratosthenesGenerator.new
p generator.next #=> 2
p generator.next #=> 3
p generator.succ #=> 5
p generator.succ #=> 7
p generator.next #=> 11
```

### def rewind -> nil

列挙状態を巻き戻します。

```ruby title="例"
require 'prime'
generator = Prime::EratosthenesGenerator.new
p generator.next #=> 2
p generator.next #=> 3
p generator.next #=> 5

generator.rewind

p generator.next #=> 2
```


