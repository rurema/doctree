---
library: prism
---
# class Prism::ParseError < Object

[m:Prism::ParseResult#errors] で得られる、構文解析中に発生した
エラーを表すクラスです。

例外クラスではないことに注意してください。prism はエラー耐性のある
パーサであり、構文エラーがあっても例外を発生させず、見つかった
エラーをこのクラスのインスタンスとして
[m:Prism::ParseResult#errors] に蓄積します。

```ruby title="例"
require "prism"

error = Prism.parse("1 +\n").errors.first
p error.class    # => Prism::ParseError
p error.message  # => "unexpected end-of-input; expected an expression after the operator"
p error.location.start_line # => 1
```

- **SEE** [m:Prism::ParseResult#errors], [c:Prism::ParseWarning]

## Instance Methods

### def message -> String

エラーメッセージを返します。

### def location -> Prism::Location

エラーが発生したソースコード上の位置を表す `Prism::Location` を
返します。該当箇所の文字列そのものは `location.slice` で取得できます。

#%since 3.4
### def type -> Symbol

エラーの種類を表すシンボル(例: `:expect_expression_after_operator`)を
返します。

これはエラーメッセージの変換レイヤーとの連携のために使われる内部用の
シンボルであり、正式な公開 API ではありません。将来のバージョンで
予告なく変わる可能性があります。

### def level -> Symbol

エラーの深刻度による分類を表すシンボル(例: `:syntax`)を返します。

#%end
