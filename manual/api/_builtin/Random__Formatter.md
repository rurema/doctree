---
library: _builtin
---
# module Random::Formatter

生成した乱数を 16 進文字列や base64 文字列、UUID など、人が扱いやすい形式の文字列に整形するためのメソッド群を提供するモジュールです。

このモジュールは [c:Random] に include され、[c:SecureRandom] には
extend されています。ただし、以下の整形用メソッドが定義されるのは
`require "random/formatter"` を読み込んだとき(`require "securerandom"`
でも読み込まれます)です。読み込むと、[c:Random] のインスタンスと
[c:SecureRandom] の両方でこれらのメソッドが使えるようになります。

  - random_bytes
  - hex
  - base64
  - urlsafe_base64
  - alphanumeric
  - uuid など

これらのメソッドの詳しい説明は [c:SecureRandom] を参照してください。

## Instance Methods

#%since 3.3
### def alphanumeric(n = nil, chars: ALPHANUMERIC) -> String
#%else
### def alphanumeric(n = nil) -> String
#%end

ランダムな英数字を生成して返します。

[c:Random] のインスタンスメソッド、および [c:Random] と [c:SecureRandom] の特異メソッドとして使用できます。

- **param** `n` -- 生成される文字列のサイズを整数で指定します。
         nil を指定した場合 n として 16 が使われます。
#%since 3.3
- **param** `chars` -- 生成に使う文字の配列を指定します。
         省略した場合は A-Z, a-z, 0-9 が使われます。
#%end
- **return** -- A-Z, a-z, 0-9 からなる文字列が返されます。
#%since 3.3
         (chars を指定した場合は、chars に含まれる文字からなる文字列が返されます)
#%end

```ruby
require 'random/formatter'

prng = Random.new
p prng.alphanumeric(10) # => "S8baxMJnPl"
p Random.alphanumeric   # => "TmP9OsJHJLtaZYhP"
#%since 3.3

p prng.alphanumeric(10, chars: [*"!".."/"]) # => ",.,++%/''."
#%end
```

- **SEE** [m:SecureRandom.alphanumeric]
