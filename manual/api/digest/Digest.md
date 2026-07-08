---
library: digest
---
# module Digest

## Module Functions

### module_function def hexencode(string) -> String

引数である文字列 string を、16進数に変換した文字列を生成して返します。

- **param** `string` -- 文字列を指定します。

```ruby
require 'digest'

p Digest.hexencode("")     # => ""
p Digest.hexencode("d")    # => "64"
p Digest.hexencode("\1\2") # => "0102"
p Digest.hexencode("\xB0") # => "b0"

p digest = Digest::MD5.digest("ruby")   # => "X\xE5=\x13$\xEE\xF6&_\xDB\x97\xB0\x8E\xD9\xAA\xDF"
p Digest.hexencode(digest)              # => "58e53d1324eef6265fdb97b08ed9aadf"
p Digest::MD5.hexdigest("ruby")         # => "58e53d1324eef6265fdb97b08ed9aadf"

p digest = Digest::SHA1.digest("ruby")   # => "\x18\xE4\x0E\x14\x01\xEE\xF6~\x1A\xE6\x9E\xFA\xB0\x9A\xFBq\xF8\x7F\xFB\x81"
p Digest.hexencode(digest)               # => "18e40e1401eef67e1ae69efab09afb71f87ffb81"
p Digest::SHA1.hexdigest("ruby")         # => "18e40e1401eef67e1ae69efab09afb71f87ffb81"
```

文字列から16進数に変換したハッシュ値を直接得たい場合は、[m:Digest::Base.hexdigest] を使うこともできます。

- **SEE** [m:Digest::Base.hexdigest], [m:Digest::Base#hexdigest]


