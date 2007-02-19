require kconv
require nkf


MIME Base64のデコード/エンコードを行うメソッドが定義されています。
このライブラリは Base64 エンコーディングの
サンプルスクリプトとして書かれました。

Base64 は、3 オクテット (8bits * 3 = 24bits) のバイナリコードを
ASCII 文字のうちの 65 文字 ([A-Za-z0-9+/] の 64 文字と '=')
だけを使用して 4 オクテット (6bits * 4 = 24bits)
の印字可能文字列に変換するエンコーディング法です。
[[RFC:2045]]で定義されています。

=== 使用方法

  require 'base64'

  p b64encode("日本語")      # => "xvzL3Ljs\n"
  p decode64('xvzL3Ljs')     # => "日本語"
  p decode_b("日本語")       # => "日本語"
  p decode_b("=?ISO-2022-JP?B?QyAbJEI4QDhsJV0lJCVzJT80MEE0QClHRhsoQg==?=")
                             # => "C 言語ポインタ完全制覇"


#@since 1.8.2
= module Base64

== Module Functions

--- decode64(str)
#@todo

Base64エンコードされた文字列strをデコードします。

--- encode64(str)
#@todo

文字列strをBase64エンコードします。

--- decode_b(str)
#@todo

[[rfc:2047]] で定義されている encoded-word を含む
文字列 str をデコードします。

encoded-word は、

  "=?" + charset + "?" + encoding + "?" + encoded-text + "?="

という形式の文字列で、メールヘッダに使用されます。

この関数は charset として "iso-2022-jp" と "shift_jis" を、
encoding として "B" encoding (Base64) だけをサポートしています。

バグ:

実際は、内部で Kconv.toeuc を呼んでいるため [[unknown:nkf]] ライブラリ
が勝手にデコードを行ってしまいます ([[unknown:NKFの注意|nkf]]を参照のこと)。
したがって、この関数はあまり意味がなくなってしまっています
(昔の Kconv の実装は NKF を使用しなかったためこのようなことになって
いるのだと思われます)。

--- b64encode(bin, len = 60)
#@todo

文字列 bin をエンコードし、len の長さで折り返し、表示します。

表示までしてしまうのはサンプルだからです。

#@include(base64/Base64__Deprecated)

= reopen Kernel

== Module Functions

--- decode64(str)
#@todo

--- encode64(str)
#@todo

--- decode_b(str)
#@todo

--- b64encode(bin, len = 60)
#@todo

#@end

#@if (version <= "1.8.1")
= reopen Kernel

== Private Instance Methods

--- decode64(str)
#@todo

--- encode64(str)
#@todo

--- decode_b(str)
#@todo

--- b64encode(bin, len = 60)
#@todo

#@end
