---
library: _builtin
---
# module Comparable

比較演算を許すクラスのための Mix-in です。このモジュールをインクルー
ドするクラスは、基本的な比較演算子である <=> 演算子を定義してい
る必要があります。

self <=> other は
 - self が other より大きいなら正の整数
 - self と other が等しいなら 0
 - self が other より小さいなら負の整数
 - self と other が比較できない場合は nil
をそれぞれ返すことが期待されています。

他の比較演算子は、 <=> 演算子を利用して定義されます。

## Instance Methods

### def ==(other)    -> bool

比較演算子 <=> をもとにオブジェクト同士を比較します。
<=> が 0 を返した時に、true を返します。
それ以外を返した場合は、false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。

```ruby title="例"
p 1 == 1 # => true
p 1 == 2 # => false
```

### def >(other)    -> bool

比較演算子 <=> をもとにオブジェクト同士を比較します。
<=> が正の整数を返した場合に、true を返します。
それ以外の整数を返した場合に、false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。
- **raise** `ArgumentError` -- <=> が nil を返したときに発生します。

```ruby title="例"
p 1 > 0 # => true
p 1 > 1 # => false
```

### def >=(other)    -> bool

比較演算子 <=> をもとにオブジェクト同士を比較します。
<=> が正の整数か 0 を返した場合に、true を返します。
それ以外の整数を返した場合に、false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。
- **raise** `ArgumentError` -- <=> が nil を返したときに発生します。

```ruby title="例"
p 1 >= 0 # => true
p 1 >= 1 # => true
p 1 >= 2 # => false
```

### def <(other)    -> bool

比較演算子 <=> をもとにオブジェクト同士を比較します。
<=> が負の整数を返した場合に、true を返します。
それ以外の整数を返した場合に、false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。
- **raise** `ArgumentError` -- <=> が nil を返したときに発生します。

```ruby title="例"
p 1 < 1 # => false
p 1 < 2 # => true
```

### def <=(other)    -> bool

比較演算子 <=> をもとにオブジェクト同士を比較します。
<=> が負の整数か 0 を返した場合に、true を返します。
それ以外の整数を返した場合に、false を返します。

- **param** `other` -- 自身と比較したいオブジェクトを指定します。
- **raise** `ArgumentError` -- <=> が nil を返したときに発生します。

```ruby title="例"
p 1 <= 0 # => false
p 1 <= 1 # => true
p 1 <= 2 # => true
```

### def between?(min, max)    -> bool

比較演算子 <=> をもとに self が min と max の範囲内(min, max
を含みます)にあるかを判断します。

以下のコードと同じです。
```ruby
self >= min and self <= max
```

- **param** `min` -- 範囲の下端を表すオブジェクトを指定します。

- **param** `max` -- 範囲の上端を表すオブジェクトを指定します。

- **raise** `ArgumentError` -- self <=> min か、self <=> max が nil を返
                     したときに発生します。

```ruby title="例"
p 3.between?(1, 5)             # => true
p 6.between?(1, 5)             # => false
p 'cat'.between?('ant', 'dog') # => true
p 'gnu'.between?('ant', 'dog') # => false
```

### def clamp(min, max)  -> object
### def clamp(range)     -> object

self を範囲内に収めます。

min と max の2つの引数が渡された場合は次のようになります。
self <=> min が負数を返したときは min を、
self <=> max が正数を返したときは max を、
それ以外の場合は self を返します。

min が nil の場合、min は self よりも小さい値として扱われます。
max が nil の場合、max は self よりも大きい値として扱われます。

range が1つ渡された場合は次のようになります。
self <=> range.begin が負数を返したときは range.begin を、
self <=> range.end が正数を返したときは range.end を、
それ以外の場合は self を返します。

range.begin が nil の場合、range.begin は self よりも小さい値として扱われます。
range.end が nil の場合、range.end は self よりも大きい値として扱われます。

- **param** `min` -- 範囲の下端を表すオブジェクトを指定します。

- **param** `max` -- 範囲の上端を表すオブジェクトを指定します。

- **param** `range` -- 範囲を表す Range オブジェクトを指定します。

- **raise** `ArgumentError` -- rangeが終端を含まない範囲オブジェクトであり、
                     終端が nil でないときに発生します。

```ruby title="例"
p 12.clamp(0, 100)       #=> 12
p 523.clamp(0, 100)      #=> 100
p -3.123.clamp(0, 100)   #=> 0

p 'd'.clamp('a', 'f')    #=> 'd'
p 'z'.clamp('a', 'f')    #=> 'f'
```

```ruby title="nil を渡す例"
p 5.clamp(0, nil)        #=> 5
p 5.clamp(nil, 0)        #=> 0
p 5.clamp(nil, nil)      #=> 5
```

```ruby title="range を渡す例"
p 12.clamp(0..100)   #=> 12
p 523.clamp(0..100)  #=> 100
p -3.123.clamp(0..100) #=> 0

p 'd'.clamp('a'..'f')  #=> 'd'
p 'z'.clamp('a'..'f')  #=> 'f'

100.clamp(0...100)   # ArgumentError
```

```ruby title="range の始端か終端が nil の場合"
p -20.clamp(0..) #=> 0
p 523.clamp(..100) #=> 100
```
