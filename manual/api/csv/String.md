---
library: csv
---
# reopen String

## Instance Methods

### def parse_csv(**options) -> [String]

CSV.parse_line(self, options) と同様です。

1 行の CSV 文字列を、文字列の配列に変換するためのショートカットです。

- **param** `options` -- [m:CSV.new] と同様のオプションを指定します。

```ruby
require "csv"

p "Matz,Ruby\n".parse_csv                                   # => ["Matz", "Ruby"]
p "Matz|Ruby\r\n".parse_csv(col_sep: '|', row_sep: "\r\n")  # => ["Matz", "Ruby"]
```

Ruby 2.6 (CSV 3.0.2) から、次のオプションが使えるようになりました。

```ruby
require 'csv'

p "1,,3\n".parse_csv                        # => ["1", nil, "3"]
p "1,,3\n".parse_csv(nil_value: Float::NAN) # => ["1", NaN, "3"]
```

#@since 2.7.0
Ruby 2.7 (CSV 3.1.2) から、次のオプションが使えるようになりました。

```ruby
require 'csv'

p "Matz,   Ruby\n".parse_csv               # => ["Matz", "   Ruby"]
p "Matz,   Ruby\n".parse_csv(strip: true)  # => ["Matz", "Ruby"]
```
#@end

- **SEE** [m:CSV.new], [c:CSV.parse_line]
