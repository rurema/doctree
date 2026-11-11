---
library: csv
---
# class CSV::MalformedCSVError < RuntimeError

不正な CSV をパースしようとしたときに発生する例外です。

#%since 3.3
入力に不正なバイト列が含まれていた場合は、サブクラスの [c:CSV::InvalidEncodingError] が発生します。
#%end

## Class Methods

### def CSV::MalformedCSVError.new(message, line_number) -> CSV::MalformedCSVError
{: since="2.6.0"}

例外オブジェクトを生成して返します。

例外のメッセージは `message` の後ろに `" in line #{line_number}."` を付けたものになります。`line_number` は [m:CSV::MalformedCSVError#line_number] の戻り値になります。

- **param** `message` -- エラーメッセージを表す文字列を指定します。
- **param** `line_number` -- 例外が発生した行の行番号を指定します。

```ruby title="例"
require "csv"

e = CSV::MalformedCSVError.new("Illegal quoting", 3)
p e.message     # => "Illegal quoting in line 3."
p e.line_number # => 3
```

## Instance Methods

### def line_number -> Integer
{: since="2.6.0"}
### def lineno -> Integer
{: since="2.6.0"}

例外が発生した行の行番号を返します。

```ruby title="例"
require "csv"

begin
  CSV.parse("a,b\n\"c,d\n")
rescue CSV::MalformedCSVError => e
  p e.line_number # => 2
  p e.lineno      # => 2
  p e.message     # => "Unclosed quoted field in line 2."
end
```
