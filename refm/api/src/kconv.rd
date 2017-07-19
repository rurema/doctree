category CharacterEncoding

require nkf

日本語文字コードの変換を手軽に行うためのライブラリです。

kconv を require すると [[c:String]] クラスに変換用のメソッドが定義されます。
[[c:Kconv]] にも同等のメソッドが定義されます。 [[c:Kconv]] には
エンコーディングを表す定数も定義されています。

#@since 1.9.1
1.9.1 以降では、Ruby の m17n 機能を用いてエンコーディングの変換を
行うことができます。1.8 との互換性が問題でないのならば、
m17n 機能を使うほうがよいでしょう。MIMEのデコード等面倒な問題を
避けることができます。
#@end

=== 使用例

  require 'kconv'
  newstring = Kconv.kconv(string, Kconv::JIS, Kconv::AUTO)
  newstring = Kconv.tojis(string)
  newstring = Kconv.toeuc(string)
  newstring = Kconv.tosjis(string)
  guessed_code = Kconv.guess(string)

または

  require 'kconv'
  newstring = string.kconv(Kconv::JIS, Kconv::AUTO)
  newstring = string.tojis
  newstring = string.toeuc
  newstring = string.tosjis


= reopen String

== Instance Methods

--- kconv(out_code, in_code = Kconv::AUTO) -> String

self のエンコーディングを out_code に変換した文字列を
返します。
out_code in_code は [[c:Kconv]] の定数で指定します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]] を使ってください。

@param out_code 変換後のエンコーディングを [[c:Kconv]] の定数で指定します。
@param in_code 変換する文字列のエンコーディングを [[c:Kconv]] の定数で指定します。

@see [[m:Kconv.#kconv]]

--- tojis -> String

self のエンコーディングを iso-2022-jp に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-jxm0', str)
を使ってください。

@see [[m:Kconv.#tojis]]
--- toeuc -> String

self のエンコーディングを EUC-JP に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-exm0', str)
を使ってください。

@see [[m:Kconv.#toeuc]]
--- tosjis -> String

self のエンコーディングを shift_jis に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-sxm0', str)
を使ってください。

@see [[m:Kconv.#tosjis]]

#@since 1.8.2
--- toutf8 -> String

self のエンコーディングを UTF-8 に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-wxm0', str)
を使ってください。

@see [[m:Kconv.#toutf8]]
#@end

#@since 1.8.2
--- toutf16 -> String

self のエンコーディングを UTF-16BE に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-w16xm0', str)
を使ってください。

@see [[m:Kconv.#toutf16]]

#@end

#@since 1.9.1
--- toutf32 -> String

self のエンコーディングを UTF-32 に変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-w32xm0', str)
を使ってください。

@see [[m:Kconv.#toutf32]]

--- tolocale -> String
self のエンコーディングをロケールエンコーディングに変換した文字列を
返します。変換元のエンコーディングは文字列の内容から推測します。

ロケールエンコーディングについては [[m:Encoding.locale_charmap]] を見てください。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:String#encode]]
を使ってください。

@see [[m:Kconv.#tolocale]]


#@end

#@since 1.8.2
--- iseuc -> bool

self が EUC-JP なバイト列として正当であるかどうかを判定します。

[[m:Kconv.#iseuc]](self) と同じです。

#@end

#@since 1.8.2
--- issjis -> bool

self が Shift_JIS なバイト列として正当であるかどうかを判定します。


[[m:Kconv.#issjis]] と同じです。

#@end

#@since 1.8.2
--- isutf8 -> bool

self が UTF-8 なバイト列として正当であるかどうかを判定します。

[[m:Kconv.#isutf8]](self) と同じです。
#@end

#@since 1.9.1
--- isjis -> bool

self が ISO-2022-JP なバイト列として正当であるかどうかを判定します。

Kconv.isjis(self) と同じです。

#@end
= module Kconv

文字コードエンコーディングを変換するためのモジュール。
[[c:Kconv]] は [[lib:nkf]] のラッパーです。

#@#[[trap:Kconv]]

== Module Functions

--- kconv(str, out_code, in_code = Kconv::AUTO) -> String

文字列 str のエンコーディングを out_code に変換したものを
返します。in_code も指定されていたら str のエンコーディングが
in_code だとして動作します。

このメソッドはMIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]] を使ってください。

@param str 変換元の文字列
@param out_code 変換後のエンコーディング
@param in_code strのエンコーディング

@see [[m:String#kconv]]

--- tojis(str) -> String

文字列 str のエンコーディングを iso-2022-jp に変換して返します。

Kconv.kconv(str, Kconv::JIS) と同じです。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-jxm0', str)
を使ってください。

@param str 変換元の文字列

@see [[m:Kconv.#kconv]], [[m:String#tojis]]
--- toeuc(str) -> String

文字列 str のエンコーディングを EUC-JP に変換して返します。

Kconv.kconv(str, Kconv::EUC)と同じです。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-exm0', str)
を使ってください。

@param str 変換元の文字列

@see [[m:Kconv.#kconv]], [[m:String#toeuc]]

--- tosjis(str) -> String

文字列 str のエンコーディングを shift_jis に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-sxm0', str)
を使ってください。

Kconv.kconv(str, Kconv::SJIS)と同じです。

@param str 変換元の文字列

@see [[m:Kconv.#kconv]], [[m:String#tosjis]]

#@until 1.9.1
--- guess(str) -> Integer
#@else
--- guess(str) -> Encoding | nil
#@end

文字列 str のエンコーディングを判定します。戻り値は
Kconv の定数です。

このモジュール関数で判定できるのは、
  * ISO-2022-JP ([[m:Kconv::JIS]])
  * Shift_JIS ([[m:Kconv::SJIS]])
  * EUC-JP ([[m:Kconv::EUC]])
#@since 1.8.2
  * ASCII ([[m:Kconv::ASCII]])
  * UTF-8 ([[m:Kconv::UTF8]])
  * UTF-16BE ([[m:Kconv::UTF16]])
#@end
  * 不明 ([[m:Kconv::UNKNOWN]])
  * 以上のどれでもない ([[m:Kconv::BINARY]])
のいずれかです。

@param str エンコーディング判定対象の文字列

#@since 1.8.2
#@until 1.9.1
--- guess_old(str) -> Integer
文字列 str のエンコーディングを判定します。戻り値は
Kconv の定数です。

このモジュール関数で判定できるのは、
  * ISO-2022-JP ([[m:Kconv::JIS]])
  * Shift_JIS ([[m:Kconv::SJIS]])
  * EUC-JP ([[m:Kconv::EUC]])
  * 不明 ([[m:Kconv::UNKNOWN]])
  * 以上のどれでもない ([[m:Kconv::BINARY]])
のいずれかです。

@param str エンコーディング判定対象の文字列
@see [[m:Kconv.#guess]]
#@end
#@end

#@since 1.8.2
--- toutf8(str) -> String

文字列 str のエンコーディングを UTF-8 に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-wxm0', str)
を使ってください。

Kconv.kconv(str, Kconv::UTF8)と同じです。

@param str 変換元の文字列
@see [[m:String#toutf8]]

#@end

#@since 1.8.2
--- toutf16(str) -> String

文字列 str のエンコーディングを UTF-16BE に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-w16xm0', str)
を使ってください。

Kconv.kconv(str, Kconv::UTF16)と同じです。

@param str 変換元の文字列
@see [[m:String#toutf16]]

#@end

#@since 1.9.1
--- toutf32(str) -> String

文字列 str のエンコーディングを UTF-32 に変換して返します。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:NKF.#nkf]]('-w32xm0', str)
を使ってください。

Kconv.kconv(str, Kconv::UTF32)と同じです。

@param str 変換元の文字列
@see [[m:String#toutf32]]

#@end

#@since 1.9.1
--- tolocale(str) -> String

文字列 str のエンコーディングをロケールエンコーディングに変換して返します。

ロケールエンコーディングについては [[m:Encoding.locale_charmap]] を見てください。

このメソッドは MIME エンコードされた文字列を展開し、
いわゆる半角カナを全角に変換します。
これらを変換したくない場合は、 [[m:String#encode]]
を使ってください。

Kconv.kconv(str, Encoding.locale_charmap)と同じです。

@param str 変換元の文字列
@see [[m:String#tolocale]]

#@end

#@since 1.8.2
--- iseuc(str) -> bool
文字列 str が EUC-JP なバイト列として正当であるかどうかを判定します。

@param str 判定対象の文字列
@see [[m:String#iseuc]]

#@end

#@since 1.8.2
--- issjis(str) -> bool
文字列 str が Shift_JIS なバイト列として正当であるかどうかを判定します。

@param str 判定対象の文字列
@see [[m:String#issjis]]

#@end

#@since 1.8.2
--- isutf8(str) -> bool
文字列 str が UTF-8 なバイト列として正当であるかどうかを判定します。

@param str 判定対象の文字列
@see [[m:String#isutf8]]
#@end

#@since 1.9.1
--- isjis(str) -> bool
文字列 str が ISO-2022-JP なバイト列として正当であるかどうかを判定します。

@param str 判定対象の文字列
@see [[m:String#isjis]]
#@end
== Constants

#@until 1.9.1
--- AUTO -> Integer
#@else
--- AUTO -> nil
#@end

エンコーディングを自動検出します。
入力の指定でのみ有効です。

#@until 1.9.1
--- JIS -> Integer
#@else
--- JIS -> Encoding
#@end

ISO-2022-JP を表します。

#@until 1.9.1
--- EUC -> Integer
#@else
--- EUC -> Encoding
#@end

EUC-JP を表します。

#@until 1.9.1
--- SJIS -> Integer
#@else
--- SJIS -> Encoding
#@end

Shift_JIS を表します。
cp932ではないことに注意してください。

#@until 1.9.1
--- BINARY -> Integer
#@else
--- BINARY -> Encoding
#@end

#@since 1.8.2
JIS EUC SJIS 以外を表します。
#@else
JIS EUC SJIS UTF8 UTF16 以外を表します。
#@end
この値は[[m:Kconv.#guess]]の返り値としてのみ用いられます。

#@until 1.9.1
--- UNKNOWN -> Integer
#@else
--- UNKNOWN -> nil
#@end

出力においては「エンコーディングを判定できなかった」
入力においては AUTO と同様に「自動検出」を表します。

#@until 1.9.1
--- NOCONV -> Integer
#@else
--- NOCONV -> nil
#@end

変換されないことを表します。
出力エンコーディングの指定にのみ用います。

#@since 1.8.2
#@until 1.9.1
--- ASCII -> Integer
#@else
--- ASCII -> Encoding
#@end

ASCII を表します。
#@end

#@since 1.8.2
#@until 1.9.1
--- UTF8 -> Integer
#@else
--- UTF8 -> Encoding
#@end

UTF8 を表します。
#@end

#@since 1.8.2
#@until 1.9.1
--- UTF16 -> Integer
#@else
--- UTF16 -> Encoding
#@end

UTF16 を表します。
#@end

#@since 1.8.2
#@until 1.9.1
--- UTF32 -> Integer
#@else
--- UTF32 -> Encoding
#@end

UTF32 を表します。
#@end

#@since 1.8.2
#@until 1.9.1
--- RegexpShiftjis -> Regexp
この定数は使うべきではありません。

--- RegexpEucjp -> Regexp
この定数は使うべきではありません。

--- RegexpUtf8 -> Regexp
この定数は使うべきではありません。
#@end
#@end

#@since 1.8.5
#@until 1.9.1
--- REVISION -> String
この定数は使うべきではありません。
#@end
#@end

#@since 1.8.2
#@until 1.8.5
--- Iconv_EUC_JP -> Regexp
この定数は使うべきではありません。
--- Iconv_Shift_JIS -> Regexp
この定数は使うべきではありません。
--- Iconv_UTF8 -> Regexp
この定数は使うべきではありません。
#@end
#@end
