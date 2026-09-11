---
library: psych
---
# class Psych::ScalarScanner

YAML の scalar 型を読み込んで Ruby の built-in 型に変換するクラス。

#%# == Constants
#%#
#%# --- TIME -> Regexp
#%# #@todo
#%# --- FLOAT

## Class Methods

### def Psych::ScalarScanner.new(class_loader) -> Psych::ScalarScanner

新たな ScalarScanner オブジェクトを生成します。

- **param** `class_loader` -- YAML のタグから Ruby のクラスを解決するための Psych::ClassLoader オブジェクト

## Instance Methods

### def tokenize(string) -> object

YAML の scalar である文字列を Ruby のオブジェクトに変換したものを返します。

```ruby
require 'psych'

scanner = Psych::ScalarScanner.new(Psych::ClassLoader.new)
p scanner.tokenize("yes") # => true
p scanner.tokenize("year") # => "year"
p scanner.tokenize("12") # =>  12
```

- **param** `string` -- 変換文字列

### def parse_time(string) -> Time

文字列を Time オブジェクトに変換します。

- **param** `string` -- 変換文字列

### def parse_int(string) -> Integer

文字列 string を整数に変換して返します。

string に含まれるカンマ(`,`)とアンダースコア(`_`)を取り除いてから [m:Kernel?.Integer] で変換します。

- **param** `string` -- 変換する文字列
- **raise** `ArgumentError` -- string を整数に変換できないときに発生します

