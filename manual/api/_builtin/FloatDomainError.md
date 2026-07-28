---
library: _builtin
---
# class FloatDomainError < RangeError

正負の無限大や NaN (Not a Number) を、それに対応していない数値クラスに変換しようとしたとき発生します。

```ruby title="FloatDomainErrorが発生する例"
# Integer には正負の無限大や NaN に対応する値が無い
Float::INFINITY.to_i    # ~> FloatDomainError
(-Float::INFINITY).to_i # ~> FloatDomainError
Float::NAN.to_i         # ~> FloatDomainError

# Rational には正負の無限大や NaN に対応する値が無い
Float::INFINITY.to_r    # ~> FloatDomainError
(-Float::INFINITY).to_r # ~> FloatDomainError
Float::NAN.to_r         # ~> FloatDomainError
```
