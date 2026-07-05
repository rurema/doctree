---
library: base64
---
# module Base64

Base64 エンコード / デコードするためのメソッドを定義したモジュールです。

## Module Functions

### module_function def decode64(str) -> String
与えられた文字列を Base64 デコードしたデータを返します。

このメソッドは [RFC:2045] に対応しています。

- **param** `str` -- Base64 デコードする文字列を指定します。

``````
require 'base64'
str = 'VGhpcyBpcyBsaW5lIG9uZQpUaGlzIG' +
      'lzIGxpbmUgdHdvClRoaXMgaXMgbGlu' +
      'ZSB0aHJlZQpBbmQgc28gb24uLi4K'
puts Base64.decode64(str)

# This is line one
# This is line two
# This is line three
# And so on...
``````


### module_function def encode64(bin) -> String
与えられたデータを Base64 エンコードした文字列を返します。

このメソッドは [RFC:2045] に対応しています。
エンコード後の文字で 60 文字ごとに改行を追加します。

- **param** `bin` -- Base64 エンコードするデータを指定します。


```````
require 'base64'
Base64.encode64("Now is the time for all good coders\nto learn Ruby")

# => Tm93IGlzIHRoZSB0aW1lIGZvciBhbGwgZ29vZCBjb2RlcnMKdG8gbGVhcm4g
#    UnVieQ==
```````


### module_function def strict_decode64(str) -> String
与えられた文字列を Base64 デコードしたデータを返します。

このメソッドは [RFC:4648] に対応しています。


- **param** `str` -- Base64 デコードする文字列を指定します。

- **raise** `ArgumentError` -- 与えられた引数が Base64 エンコードされたデータとして正しい形式ではない場合に発生します。
       例えば、アルファベットでない文字列や CR, LF などが含まれている場合にこの例外は発生します。

### module_function def strict_encode64(bin) -> String
与えられたデータを Base64 エンコードした文字列を返します。

このメソッドは [RFC:4648] に対応しています。
改行コードを追加することはありません。

- **param** `bin` -- Base64 エンコードするデータを指定します。

### module_function def urlsafe_decode64(str) -> String
与えられた文字列を Base64 デコードしたデータを返します。

このメソッドは [RFC:4648] の "Base 64 Encoding with URL and Filename Safe Alphabet" に対応しています。
"-" を "+" に "_" を "/" に置き換えます。

- **param** `str` -- Base64 デコードする文字列を指定します。

- **raise** `ArgumentError` -- 与えられた引数が Base64 エンコードされたデータとして正しい形式ではない場合に発生します。
       例えば、アルファベットでない文字列や CR, LF などが含まれている場合にこの例外は発生します。

### module_function def urlsafe_encode64(bin, padding: true) -> String
与えられたデータを Base64 エンコードした文字列を返します。

このメソッドは [RFC:4648] の "Base 64 Encoding with URL and Filename Safe Alphabet" に対応しています。
"+" を "-" に "/" を "_" に置き換えます。

デフォルトでは戻り値は = によるパディングを含むことがあります。
パディングを含めたくない場合は、padding オプションに false を指定してください。

- **param** `bin` -- Base64 エンコードするデータを指定します。
- **param** `padding` -- false を指定した場合、 = によるパディングが行われなくなります。

```ruby title="例"
require 'base64'

p Base64.urlsafe_encode64('hoge')
# => "aG9nZQ=="

p Base64.urlsafe_encode64('hoge', padding: false)
# => "aG9nZQ"
```


#@if (version <= "1.8.1")
# reopen Kernel

## Private Instance Methods

### def decode64(str) -> String

文字列strをBase64エンコードします。

- **param** `str` -- エンコードしたい文字列です。

### def encode64(str) -> String

文字列strをBase64エンコードします。

- **param** `str` -- エンコードしたい文字列です。

### def decode_b(str) -> String

[RFC:2047] で定義されている encoded-word を含む
文字列 str をデコードします。

encoded-word は、

`````
"=?" + charset + "?" + encoding + "?" + encoded-text + "?="
`````

という形式の文字列で、メールヘッダに使用されます。

この関数は charset として "iso-2022-jp" と "shift_jis" を、
encoding として "B" encoding (Base64) だけをサポートしています。

バグ:

実際は、内部で [m:Kconv?.toeuc] を呼んでいるため、 [lib:Kconv] が内
部的に利用する [lib:nkf] ライブラリが勝手にデコードを行ってしまいます。
したがって、この関数はあまり意味がなくなってしまっています(昔の Kconv
の実装は NKF を使用しなかったためこのようなことになっているのだと思われ
ます)。

- **param** `str` -- デコードしたい文字列です。

### def b64encode(bin, len = 60) -> ()

文字列 bin をエンコードし、len の長さで折り返し、表示します。

表示までしてしまうのはサンプルだからです。

#@end
