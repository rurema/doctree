---
library: rexml/document
---
# class REXML::Formatters::Pretty < REXML::Formatters::Default

XMLドキュメントを(文字列として)見た目良く出力するクラスです。

[c:REXML::Formatters::Default] と
異なり見た目のためテキストの改行や空白を修正して出力します。

```ruby
require 'rexml/document'
require 'rexml/formatters/pretty'
doc = REXML::Document.new <<EOS
<root>
<children>
  <grandchildren foo='bar'/>
</children>
</root>
EOS

pretty_formatter = REXML::Formatters::Pretty.new
output = StringIO.new
pretty_formatter.write(doc, output)
p output.string
# => "<root>\n  <children>\n    <grandchildren foo='bar'/>\n  </children>\n</root>"
# この出力結果は入力のXMLよりも空白が増えている
```

## Class Method
### def new(indentation=2, ie_hack=false) -> REXML::Formatter::Pretty
フォーマッタオブジェクトを生成して返します。

このフォーマッタによる出力はテキストの空白や改行を調整し、
適切なインデントを挿入して読みやすいXMLを出力します。

indentation でインデント幅を(空白の数で)指定します。

ie_hack に真を渡すと、空のタグを閉じる前で空白を挿入します。
これは特定のバージョンのIEのXMLパーサのバグを避けるための機能です。

- **param** `indentation` -- 出力のインデント幅
- **param** `ie_hack` -- 空のタグを閉じる所にスペースを入れるかどうか

## Instance Method

### def compact -> bool
出力をコンパクトにするかどうかを返します。

これが真の場合、出力の空白をできる限り削除しようとします。

デフォルト値は false です。

- **SEE** [m:REXML::Formatters::Pretty#compact=]

### def compact=(c)
出力をコンパクトにするかどうかを設定します。

- **param** `c` -- コンパクトな出力をするかどうかを指定します。
- **SEE** [m:REXML::Formatters::Pretty#compact]

### def width -> Integer
出力のページ幅を返します。

デフォルトは80です。

- **SEE** [m:REXML::Formatters::Pretty#width=]

### def width=(w)
出力のページ幅を設定します。

- **param** `w` -- ページ幅の設定値
- **SEE** [m:REXML::Formatters::Pretty#width]
