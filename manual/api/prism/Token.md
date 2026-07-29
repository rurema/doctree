---
library: prism
---
# class Prism::Token < Object

[m:Prism?.lex] や [m:Prism?.parse_lex] の結果に含まれる、字句解析で
得られたトークンを表すクラスです。

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

トークンのソースコード上の位置を表す [c:Prism::Location] を
返します。

### def ==(other) -> bool

other が同じ `type` と `value` を持つ `Prism::Token` であれば true を
返します。位置(`location`)は比較しないため、ソースコード上の別の
場所にある同じ内容のトークンどうしも等しいと判定されます。

- **param** `other` -- 比較対象のオブジェクト

```ruby title="例"
require "prism"

tokens = Prism.lex("1 + 1").value
p tokens[0][0] == tokens[2][0] # => true (別の位置の "1" どうし)
```
