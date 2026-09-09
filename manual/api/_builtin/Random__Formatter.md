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

### def random_number -> Float
### def random_number(max) -> Integer | Float
### def random_number(range) -> Integer | Float

生の乱数から整形した乱数を生成して返します。[m:Random#rand] とほぼ同じ働きをします。

[c:Random] のインスタンスメソッド、および [c:Random] と [c:SecureRandom] の特異メソッドとして使用できます。

- **param** `max` -- 生成する数値の上限を整数または浮動小数点数で指定します。
         正の整数を指定した場合は 0 以上 max 未満の整数を、
         正の浮動小数点数を指定した場合は 0.0 以上 max 未満の浮動小数点数を返します。
         省略するか、nil、0、負の数を指定した場合は 0.0 以上 1.0 未満の浮動小数点数を返します。
- **param** `range` -- 生成する数値の範囲を [c:Range] で指定します。
         範囲の両端が整数であれば範囲内の整数を、そうでなければ範囲内の浮動小数点数を返します。
         始端が終端より大きいなど空の範囲を指定した場合は 0.0 以上 1.0 未満の浮動小数点数を返します。
- **raise** `ArgumentError` -- 数値にも範囲にも変換できないオブジェクトを指定した場合に発生します。

[m:Random#rand] とは異なり、負の数や空の範囲を指定してもエラーにはならず、
0.0 以上 1.0 未満の浮動小数点数にフォールバックします。

```ruby title="例"
prng = Random.new
p prng.random_number       # => 0.3881631795458004
p prng.random_number(100)  # => 54
p prng.random_number(1..6) # => 3
```

- **SEE** [m:Random#rand]

