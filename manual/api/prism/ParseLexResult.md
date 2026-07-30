---
library: prism
since: "3.4"
---
# class Prism::ParseLexResult < Prism::Result

[m:Prism?.parse_lex] や [m:Prism?.parse_lex_file] の戻り値のクラスです。
構文解析と字句解析の両方の結果と、付随情報(コメント・エラー・
警告など。[c:Prism::Result] を参照)を保持します。

Ruby 3.3 の prism にはこのクラスはなく、[c:Prism::ParseResult] が
使われていました(`value` の形式は同じです)。

- **SEE** [m:Prism?.parse_lex], [m:Prism?.parse_lex_file], [c:Prism::Result]

## Instance Methods

### def value -> Array

`[構文木, トークンの配列]` という 2 要素配列を返します。構文木は
`Prism::ProgramNode`、トークンの配列は [c:Prism::LexResult] の
`value` と同じ「[c:Prism::Token] と字句解析器の状態の整数のペア」の
配列です。

```ruby title="例"
require "prism"

ast, tokens = Prism.parse_lex("1 + 2").value
p ast.class      # => Prism::ProgramNode
p tokens.map { |token, _state| token.type }
# => [:INTEGER, :PLUS, :INTEGER, :EOF]
```
