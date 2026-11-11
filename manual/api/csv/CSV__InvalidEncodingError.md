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
