---
library: prime
---
# class Prime::Generator23 < Prime::PseudoPrimeGenerator

2と3と、3 より大きくて 2 でも 3 でも割り切れない全ての整数を生成します。

ある整数の素数性を擬似素数による試し割りでチェックする場合、このように低精度だが高速でメモリを消費しない擬似素数生成器が適しています。

一方、 [m:Prime#each] のように素数列を生成する目的にはまったく役に立ちません。

## Instance Methods

### def next -> Integer
### def succ -> Integer

次の擬似素数を返します。

また内部的な列挙位置を進めます。

### def rewind -> nil

列挙状態を巻き戻します。


#@# = class Prime::EratosthenesSieve < Object
#@# internal use

#@# = class Prime::TrialDivision < Object
#@# internal use

