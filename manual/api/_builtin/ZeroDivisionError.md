---
library: _builtin
---
# class ZeroDivisionError < StandardError

ゼロによる除算ができない場合にやろうとすると発生します。

```ruby title="ZeroDivisionError が発生する例"
# Integer や Rational の数値を Integer や Rational のゼロで割ろうとした
3 / 0  # ~> ZeroDivisionError
3r / 0 # ~> ZeroDivisionError
3 / 0r # ~> ZeroDivisionError

# ゼロを除数とした整商や剰余を求めようとした
3.0.div(0.0)     # ~> ZeroDivisionError
3.0.divmod(0.0)  # ~> ZeroDivisionError
3.0 % 0.0        # ~> ZeroDivisionError
3.remainder(0.0) # ~> ZeroDivisionError

# ゼロを素因数分解しようとした
require "prime"

0.prime_division # ~> ZeroDivisionError
```

```ruby title="ゼロで割ることができる例"
# 浮動小数点演算ではゼロで割ることができる
p 1 / 0.0 # => Infinity
p 1.0 / 0 # => Infinity
p 1.fdiv(0) # => Infinity
p 0.0 / 0 # => NaN
```
