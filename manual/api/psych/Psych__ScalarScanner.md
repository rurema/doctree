---
library: psych
---
# class Psych::ScalarScanner

YAML の scalar 型を読み込んで Ruby の built-in 型に変換するクラス。

#@# == Constants
#@# 
#@# --- TIME -> Regexp
#@# #@todo
#@# --- FLOAT

## Class Methods

### def new
新たな ScalarScanner オブジェクトを生成します。

## Instance Methods

### def tokenize(string) -> object
YAML の scalar である文字列を Ruby のオブジェクトに変換した
ものを返します。

```ruby
scanner = Psych::ScalarScanner.new
p scanner.tokenize("yes") # => true
p scanner.tokenize("year") # => "year"
p scanner.tokenize("12") # =>  12
```

- **param** `string` -- 変換文字列

### def parse_time(string) -> Time
文字列を Time オブジェクトに変換します。

- **param** `string` -- 変換文字列
