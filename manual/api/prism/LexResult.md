---
library: prism
since: "3.4"
---
# class Prism::LexResult < Prism::Result

[m:Prism?.lex] や [m:Prism?.lex_file] の戻り値のクラスです。
字句解析の結果と、付随情報(コメント・エラー・警告など。
[c:Prism::Result] を参照)を保持します。

Ruby 3.3 の prism にはこのクラスはなく、[c:Prism::ParseResult] が
使われていました(`value` の形式は同じです)。

- **SEE** [m:Prism?.lex], [m:Prism?.lex_file], [c:Prism::Result]

## Instance Methods

### def value -> Array

字句解析の結果を、`[トークン, 直前からの字句解析器の状態を表す整数]`
という 2 要素配列の配列で返します。トークンは [c:Prism::Token] の
インスタンスです。

トークンだけの配列が欲しい場合は `value.map(&:first)` のようにします。

```ruby title="例"
require "prism"

result = Prism.lex("1 + 2")
p result.value.map { |token, _state| token.type }
# => [:INTEGER, :PLUS, :INTEGER, :EOF]
```
