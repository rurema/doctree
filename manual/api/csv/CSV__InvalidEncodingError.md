---
library: csv
since: "3.3"
---
# class CSV::InvalidEncodingError < CSV::MalformedCSVError

不正なバイト列を含む CSV をパースしようとしたときに発生する例外です。

入力のエンコーディングとして正しくないバイト列が見つかった場合に発生します。[c:CSV::MalformedCSVError] のサブクラスなので、[c:CSV::MalformedCSVError] を `rescue` しているコードでも捕捉できます。

```ruby title="例"
require "csv"

begin
  CSV.parse("a,b\n\xFF,1\n")
rescue CSV::MalformedCSVError => e
  p e.class    # => CSV::InvalidEncodingError
  p e.message  # => "Invalid byte sequence in UTF-8 in line 2."
end
```

## Class Methods

### def CSV::InvalidEncodingError.new(encoding, line_number) -> CSV::InvalidEncodingError

例外オブジェクトを生成して返します。

例外のメッセージは `"Invalid byte sequence in #{encoding} in line #{line_number}."` になります。`encoding` は [m:CSV::InvalidEncodingError#encoding] の戻り値に、`line_number` は [m:CSV::MalformedCSVError#line_number] の戻り値になります。

- **param** `encoding` -- 入力のエンコーディングを表す [c:Encoding] オブジェクトを指定します。
- **param** `line_number` -- 不正なバイト列が見つかった行の行番号を指定します。

```ruby title="例"
require "csv"

e = CSV::InvalidEncodingError.new(Encoding::UTF_8, 2)
p e.message     # => "Invalid byte sequence in UTF-8 in line 2."
p e.encoding    # => #<Encoding:UTF-8>
p e.line_number # => 2
```

## Instance Methods

### def encoding -> Encoding

パースしようとした入力のエンコーディングを返します。

```ruby title="例"
require "csv"

begin
  CSV.parse("a,b\n\x81,1\n".force_encoding("Shift_JIS"))
rescue CSV::InvalidEncodingError => e
  p e.encoding # => #<Encoding:Shift_JIS>
  p e.lineno   # => 2
end
```
