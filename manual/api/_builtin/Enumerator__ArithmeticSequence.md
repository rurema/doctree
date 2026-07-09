---
library: _builtin
since: "2.6.0"
---
# class Enumerator::ArithmeticSequence < Enumerator

等差数列を提供するためのクラス。

ArithmeticSequenceオブジェクトは、[m:Numeric#step], [m:Range#step] によって生成されます。

## Class Methods

## Instance Methods

#@since 2.7.0
### def begin -> Numeric | nil
#@else
### def begin -> Numeric
#@end

初項 (始端) を返します。

- **SEE** [m:Enumerator::ArithmeticSequence#end]

### def end -> Numeric | nil

末項（終端）を返します。

- **SEE** [m:Enumerator::ArithmeticSequence#begin]

### def exclude_end? -> bool

末項（終端）を含まないとき真を返します。

### def step -> Numeric

公差 (各ステップの大きさ) を返します。

### def first      -> Numeric | nil
### def first(n)   -> [Numeric]

等差数列の最初の要素、もしくは最初の n 要素を返します。

- **param** `n` -- 取得する要素数。

### def last      -> Numeric | nil
### def last(n)   -> [Numeric]

等差数列の最後の要素、もしくは最後の n 要素を返します。

- **param** `n` -- 取得する要素数。

### def inspect -> String

自身を人間が読みやすい形の文字列表現にして返します。

### def ==(other) -> bool

Enumerable::ArithmeticSequence として等しいか判定します。

other が Enumerable::ArithmeticSequence で
begin, end, step, exclude_end? が等しい時に
true を返します。

- **param** `other` -- 自身と比較する Enumerable::ArithmeticSequence

### def hash -> Integer

自身のハッシュ値を返します。

begin, end, step, exclude_end? が等しい Enumerable::ArithmeticSequence は
同じハッシュ値を返します。

### def each {|n| ... }   -> self
### def each              -> self

各要素に対してブロックを評価します。

- **return** -- self を返します。

### def size -> Integer | nil

有限なら要素数を返します。
そうでなければ nil を返します。

- **return** -- 要素数または nil を返します。

