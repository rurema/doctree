---
type: library
---

Base64 エンコード / デコードを行うメソッドを定義したモジュールを提供するライブラリです。

Base64 は、3 オクテット (8bits * 3 = 24bits) のバイナリコードを
ASCII 文字のうちの 65 文字 ([A-Za-z0-9+/] の 64 文字と '=')
だけを使用して 4 オクテット (6bits * 4 = 24bits)
の印字可能文字列に変換するエンコーディング法です。
[RFC:2045], [RFC:4648] で定義されています。

このライブラリは 1.8 系統に添付されていた base64 ライブラリとは違います。
もはやサンプルスクリプトではありません。

### 使用方法

```ruby
require "base64"

enc   = Base64.encode64('Send reinforcements')
                    # => "U2VuZCByZWluZm9yY2VtZW50cw==\n"
plain = Base64.decode64(enc)
                    # => "Send reinforcements"
```

データをエンコードするために Base64 エンコードを使用するのは、あらゆるバイナリデータを
表示可能な文字列に変換するためです。

