---
library: _builtin
---
# class NilClass < Object

nil のクラス。
nil は NilClass クラスの唯一のインスタンスです。
nil は false オブジェクトとともに偽を表し、
その他の全てのオブジェクトは真です。

## Instance Methods

### def &(other) -> false

常に false を返します。

- **param** `other` -- 論理積を行なう式です

```ruby title="例"
p nil & true  # => false
p nil & false # => false
p nil & nil # => false
p nil & "a" # => false
```

### def |(other) -> bool

other が真なら true を, 偽なら false を返します。

- **param** `other` -- 論理和を行なう式です

```ruby title="例"
p nil | true # => true
p nil | false  # => false
p nil | nil  # => false
p nil | "a"  # => true
```

### def ^(other) -> bool

other が真なら true を, 偽なら false を返します。

- **param** `other` -- 排他的論理和を行なう式です

```ruby title="例"
p nil ^ true  # => true
p nil ^ false # => false
p nil ^ nil # => false
p nil ^ "a" # => true
```

### def nil? -> bool

常に true を返します。

```ruby title="例"
p nil.nil? # => true
```

### def to_a -> Array

空配列 [] を返します。

```ruby title="例"
p nil.to_a #=> []
```

### def to_f -> Float

0.0 を返します。

```ruby title="例"
p nil.to_f #=> 0.0
```

### def to_i -> Integer

0 を返します。

```ruby title="例"
p nil.to_i #=> 0
```

### def to_s -> String

空文字列 "" を返します。

```ruby title="例"
p nil.to_s # => ""
```

### def to_c -> Complex

0+0i を返します。

```ruby title="例"
p nil.to_c # => (0+0i)
```

### def to_r -> Rational

0/1 を返します。

```ruby title="例"
p nil.to_r # => (0/1)
```

### def rationalize      -> Rational
### def rationalize(eps) -> Rational

0/1 を返します。

- **param** `eps` -- 許容する誤差

引数 eps は常に無視されます。

```ruby title="例"
p nil.rationalize    # => (0/1)
p nil.rationalize(100) # => (0/1)
p nil.rationalize(0.1) # => (0/1)
```

### def to_h -> {}

{} を返します。

```ruby title="例"
p nil.to_h #=> {}
```

### def =~(other) -> nil
{: since="2.6.0"}

右辺に正規表現オブジェクトを置いた正規表現マッチ obj =~ /RE/
をサポートするためのメソッドです。常に nil を返します。

`Object#=~` が deprecated になった Ruby 2.6 で、nil に対するマッチを警告なしに行えるよう追加されました
（`Object#=~` は Ruby 3.2 で削除されています）。

#@#obj が文字列なのを期待していたが nil だった場合などにエラーを発生させずに正常に false を返すことができます。

- **param** `other` -- 任意のオブジェクトです。結果に影響しません。

```ruby title="例"
obj = 'regexp'
p(obj =~ /re/) #=> 0

obj = nil
p(obj =~ /re/) #=> nil
```

- **SEE** [m:String#=~]
