---
library: prism
---
# class Prism::Token < Object

[m:Prism?.lex] や [m:Prism?.parse_lex] の結果に含まれる、字句解析で得られたトークンを表すクラスです。

```ruby title="例"
require "prism"

token, _state = Prism.lex("1 + 2").value.first
p token.class    # => Prism::Token
p token.type     # => :INTEGER
p token.value    # => "1"
p token.location.start_column # => 0
```

- **SEE** [m:Prism?.lex], [m:Prism?.parse_lex]

## Instance Methods

### def type -> Symbol

トークンの種類を表すシンボル(例: `:INTEGER`、`:PLUS`、
`:IDENTIFIER`)を返します。

### def value -> String

トークンに対応するソースコードの文字列を返します。

### def location -> Prism::Location

トークンのソースコード上の位置を表す [c:Prism::Location] を返します。

### def ==(other) -> bool

other が同じ `type` と `value` を持つ `Prism::Token` であれば true を返します。位置(`location`)は比較しないため、ソースコード上の別の場所にある同じ内容のトークンどうしも等しいと判定されます。

- **param** `other` -- 比較対象のオブジェクト

```ruby title="例"
require "prism"

tokens = Prism.lex("1 + 1").value
p tokens[0][0] == tokens[2][0] # => true (別の位置の "1" どうし)
```

### def deconstruct_keys(keys) -> Hash

パターンマッチのハッシュパターン(`case token; in {type:, value:}`)で使われます。`type`・`value`・`location` をキーに持つハッシュを返します。

- **param** `keys` -- 取り出したいキーの配列を指定します。すべて取り出す場合は nil を指定します。

```ruby title="例"
require "prism"

token, _state = Prism.lex("1 + 2").value.first
case token
in {type:, value:}
  p [type, value]
end
# => [:INTEGER, "1"]
```

#%since 4.0
### def deep_freeze -> ()

`self` と、保持しているトークンの文字列・位置情報を frozen にします。

```ruby title="例"
require "prism"

token, _state = Prism.lex("1 + 2").value.first
token.deep_freeze
p token.frozen?       # => true
p token.value.frozen? # => true
```

- **SEE** [m:Prism::Source#deep_freeze]

#%end

#%since 4.1
### def [](index) -> Prism::Token | Integer

`self` を、かつて [m:Prism?.lex] などが返していた `[トークン, 状態]` という 2 要素配列であるかのように振る舞わせるためのメソッドです。

`index` に 0 を指定すると `self` を、1 を指定すると字句解析器の状態を表す整数を返します。

- **param** `index` -- 0 または 1 を指定します。
- **raise** `ArgumentError` -- `index` が 0, 1 のいずれでもない場合に発生します。

- **SEE** [m:Prism::Token#first], [m:Prism?.lex]

### def first -> Prism::Token

`self` を、かつて [m:Prism?.lex] などが返していた `[トークン, 状態]` という 2 要素配列であるかのように振る舞わせるためのメソッドです。

常に `self` を返します。[c:Array] の `first` に合わせた名前のメソッドです。

- **SEE** [`[]`](m:Prism::Token#[]), [m:Prism?.lex]

#%end

