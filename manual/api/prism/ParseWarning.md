---
library: prism
---
# class Prism::ParseWarning < Object

[m:Prism::ParseResult#warnings] で得られる、構文解析中に発生した警告を表すクラスです。インターフェースは [c:Prism::ParseError] と同様です。

#%since 3.4
なお、警告として検出される種類は Ruby 3.4 以降(prism 1.x)で大きく増えています。Ruby 3.3 の prism では「曖昧な演算子の解釈」のような一部の警告だけが対象で、未使用のローカル変数や重複したハッシュキーの警告などは検出されません。

#%end

```ruby title="例"
require "prism"

warning = Prism.parse("foo *[1]\n").warnings.first
p warning.class   # => Prism::ParseWarning
p warning.message # => "ambiguous `*` has been interpreted as an argument prefix"
```

- **SEE** [m:Prism::ParseResult#warnings], [c:Prism::ParseError]

## Instance Methods

### def message -> String

警告メッセージを返します。

### def location -> Prism::Location

警告の対象となったソースコード上の位置を表す [c:Prism::Location] を返します。

#%since 3.4
### def type -> Symbol

警告の種類を表すシンボル(例: `:ambiguous_prefix_star`)を返します。

これは警告メッセージの変換レイヤーとの連携のために使われる内部用のシンボルであり、正式な公開 API ではありません。将来のバージョンで予告なく変わる可能性があります。

### def level -> Symbol

警告の深刻度による分類を表すシンボル(`:default` または `:verbose`)を返します。

#%end
