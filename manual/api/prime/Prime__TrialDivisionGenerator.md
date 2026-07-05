---
library: prime
---
# class Prime::TrialDivisionGenerator < Prime::PseudoPrimeGenerator

[c:Prime::PseudoPrimeGenerator] の具象クラスです。
素数の生成に試行除算法を使用しています。

## Instance Methods

### def next -> Integer
### def succ -> Integer

次の(擬似)素数を返します。なお、この実装においては擬似素数は真に素数です。

また内部的な列挙位置を進めます。

### def rewind -> nil

列挙状態を巻き戻します。

