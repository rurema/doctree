---
library: _builtin
---
# class TrueClass < Object

true のクラス。
true は TrueClass クラスの唯一のインスタンスです。
true は真を表す代表のオブジェクトです。

## Instance Methods

### def &(other)    -> bool

other が真なら true を, 偽なら false を返します。

- **param** `other` -- 論理積を行なう式です。

& は再定義可能な演算子に分類されていますので、通常は true & other のように使われます。

```ruby title="例"
p true & true     #=> true
p true & false    #=> false
p true & nil      #=> false
p true & (1 == 1) #=> true
p true & (1 + 1)  #=> true

p true.&(true)    #=> true
p true.&(false)   #=> false
p true.&(nil)     #=> false
p true.&(1 == 1)  #=> true
p true.&(1 + 1)   #=> true
```

### def |(other)    -> bool

常に true を返します。

- **param** `other` -- 論理和を行なう式です。

| は再定義可能な演算子に分類されていますので、通常は true | other のように使われます。

```ruby title="例"
p true | true     #=> true
p true | false    #=> true
p true | nil      #=> true
p true | (1 == 1) #=> true
p true | (1 + 1)  #=> true

p true.|(true)    #=> true
p true.|(false)   #=> true
p true.|(nil)     #=> true
p true.|(1 == 1)  #=> true
p true.|(1 + 1)   #=> true
```

### def ^(other)    -> bool

other が真なら false を, 偽なら true を返します。

- **param** `other` -- 排他的論理和を行なう式です。

^ は再定義可能な演算子に分類されていますので、通常は true ^ other のように使われます。

```ruby title="例"
p true ^ true     #=> false
p true ^ false    #=> true
p true ^ nil      #=> true
p true ^ (1 == 1) #=> false
p true ^ (1 + 1)  #=> false

p true.^(true)    #=> false
p true.^(false)   #=> true
p true.^(nil)     #=> true
p true.^(1 == 1)  #=> false
p true.^(1 + 1)   #=> false
```

### def to_s    -> String

常に文字列 "true" を返します。

```ruby title="例"
true.to_s      # => "true"
```

### def inspect -> String

常に文字列 "true" を返します。

```ruby title="例"
true.inspect   # => "true"
```
