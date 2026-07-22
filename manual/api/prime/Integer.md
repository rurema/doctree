---
library: prime
---
# reopen Integer

## Class Methods

### def from_prime_division(pd) -> Integer

素因数分解された結果を元の数値に戻します。

- **param** `pd` -- 整数のペアの配列を指定します。含まれているペアの第一要素は素因数を、
          第二要素はその素因数の指数をあらわします。

- **SEE** [m:Prime#int_from_prime_division]

```ruby title="例"
require 'prime'
p Prime.int_from_prime_division([[2,2], [3,1]])  #=> 12
p Prime.int_from_prime_division([[2,2], [3,2]])  #=> 36
```

### def each_prime(upper_bound){|prime| ... } -> object
### def each_prime(upper_bound) -> Enumerator

全ての素数を列挙し、それぞれの素数をブロックに渡して評価します。

- **param** `upper_bound` -- 任意の正の整数を指定します。列挙の上界です。
                   nil が与えられた場合は無限に列挙し続けます。
- **return** -- ブロックの最後に評価された値を返します。
        ブロックが与えられなかった場合は、[c:Enumerator] と互換性のある外部イテレータを返します。

- **SEE** [m:Prime#each]

## Instance Methods

### def prime_division(generator = Prime::Generator23.new) -> [[Integer, Integer]]

自身を素因数分解した結果を返します。

- **param** `generator` -- 素数生成器のインスタンスを指定します。

- **return** -- 素因数とその指数から成るペアを要素とする配列です。つまり、戻り値の各要素は2要素の配列 [n,e] であり、それぞれの内部配列の第1要素 n は self の素因数、第2要素は n**e が self を割り切る最大の自然数 e です。

- **raise** `ZeroDivisionError` -- self がゼロである場合に発生します。

- **SEE** [m:Prime#prime_division]

```ruby title="例"
require 'prime'
p 12.prime_division #=> [[2,2], [3,1]]
p 10.prime_division #=> [[2,1], [5,1]]
```

### def prime? -> bool

自身が素数である場合、真を返します。
そうでない場合は偽を返します。

```ruby title="例"
require 'prime'
p 1.prime? # => false
p 2.prime? # => true
```

- **SEE** [m:Prime#prime?]
