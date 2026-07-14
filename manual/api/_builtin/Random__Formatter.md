---
library: _builtin
---
# module Random::Formatter

生成した乱数を 16 進文字列や base64 文字列、UUID など、人が扱いやすい
形式の文字列に整形するためのメソッド群を提供するモジュールです。

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
