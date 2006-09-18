require 'kconv'

MIME Base64のデコード/エンコードを行うメソッドが定義されています。この
ライブラリはbase64エンコーディングのサンプルスクリプトとして書かれまし
た。

Base64は、3オクテット(8bits * 3 = 24bits)のバイナリコードをASCII文字の
うちの65文字 ([A-Za-z0-9+/]の64文字とpaddingのための'=')だけを使用して
4オクテット(6bits * 4 = 24bits)の印字可能文字列に変換するエンコーディ
ング法です。[[unknown:RFC:2045]]で定義されています。

使用方法:

  irb> require 'base64'
  true
  irb> b64encode("日本語")
  xvzL3Ljs
  "xvzL3Ljs\n"
  irb> decode64('xvzL3Ljs')
  "日本語"
  irb> decode_b("日本語")
  xvzL3Ljs
  "日本語"
  irb> decode_b("=?ISO-2022-JP?B?QyAbJEI4QDhsJV0lJCVzJT80MEE0QClHRhsoQg==?=")
  "C 言語ポインタ完全制覇"

= module Base64

== Module Functions
--- decode64(str)
Base64エンコードされた文字列strをデコードします。

--- encode64(str)
文字列strをBase64エンコードします。

--- decode_b(str)
[[unknown:RFC:2047]] で定義されている encoded-word を
含む文字列strをデコードします。

encoded-word は、
  "=?" + charset + "?" + encoding + "?" + encoded-text + "?="
という形式の文字列で、メールヘッダに使用されます。

この関数は charset として "iso-2022-jp" と "shift_jis" を、
encoding として "B"-encoding (Base64) だけをサポートしています。

バグ:

実際は、内部で Kconv.toeuc を呼んでいるため [[unknown:nkf]]ライブラリ
が勝手にデコードを行ってしまいます([[unknown:NKFの注意|nkf]]を参照のこと)。
したがって、この関数はあまり意味がなくなってしまっています
(昔のKconvの実装はNKFを使用しなかったためこのようなことになって
いるのだと思われます)。

--- b64encode(bin, len = 60)
文字列binをエンコードし、lenの長さで折り返し、表示します。
表示までしてしまうのはサンプルだからです。
