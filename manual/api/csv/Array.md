---
library: csv
---
# reopen Array

## Instance Methods

### def to_csv(**options) -> String

CSV.generate_line(self, options) と同様です。

Array オブジェクトを 1 行の CSV 文字列に変換するためのショートカットです。

- **param** `options` -- [m:CSV.generate_line] と同様のオプションを指定します。

```ruby
require 'csv'

p [1, 'Matz', :Ruby, Date.new(1965, 4, 14)].to_csv                                 # => "1,Matz,Ruby,1965-04-14\n"
p [1, 'Matz', :Ruby, Date.new(1965, 4, 14)].to_csv(col_sep: ' ', row_sep: "\r\n")  # => "1 Matz Ruby 1965-04-14\r\n"
```

#@since 3.0
Ruby 3.0 (CSV 3.1.9) から、次のオプションが使えるようになりました。

```ruby
require 'csv'

puts [1, nil].to_csv                             # => 1,
puts [1, nil].to_csv(write_nil_value: "N/A")     # => 1,N/A
puts [2, ""].to_csv                              # => 2,""
puts [2, ""].to_csv(write_empty_value: "BLANK")  # => 2,BLANK
```
#@end

- **SEE** [m:CSV.generate_line]


