文字コードの変換を手軽に行うためのライブラリです。

kconv を require すると [[c:String]] クラスに以下のメソッドが定義されます。
他のメソッドや定数については [[c:Kconv]] を参照してください。

= reopen String

== Instance Methods

--- kconv(out_code, in_code = Kconv::AUTO)
#@todo

self のエンコーディングを out_code に変換したのを
返します。out_code in_code は Kconv の定数で
指定します。

--- tojis
#@todo

self のエンコーディングを iso-2022-jp に変換した文字列を
返します。

--- toeuc
#@todo

self のエンコーディングを euc-jp に変換した文字列を
返します。

--- tosjis
#@todo

self のエンコーディングを shift_jis に変換した文字列を
返します。

#@if (version >= "1.8.2")
--- toutf8
#@todo

((<ruby 1.8.2 feature>))


self のエンコーディングを utf8 に変換した文字列を
返します。
#@end

#@if (version >= "1.8.2")
--- toutf16
#@todo

((<ruby 1.8.2 feature>))


self のエンコーディングを utf16 に変換した文字列を
返します。
#@end

#@if (version >= "1.8.2")
--- iseuc
#@todo

((<ruby 1.8.2 feature>))


Kconv.iseuc(self) と同じです。
#@end

#@if (version >= "1.8.2")
--- issjis
#@todo

((<ruby 1.8.2 feature>))


Kconv.issjis(self) と同じです。
#@end

#@if (version >= "1.8.2")
--- isutf8
#@todo

((<ruby 1.8.2 feature>))


Kconv.isutf8(self) と同じです。
#@end

= module Kconv

文字コードエンコーディングを変換するためのモジュール。
[[c:Kconv]] は [[lib:nkf]] のラッパーです。

see also: [[m:kconv#String に追加されるメソッド]]

[[trap:Kconv]]

=== 使用例

  newstring = Kconv.kconv(string, Kconv::JIS, Kconv::AUTO)
  newstring = Kconv.tojis(string)
  newstring = Kconv.toeuc(string)
  newstring = Kconv.tosjis(string)
  guessed_code = Kconv.guess(string)

または

  newstring = string.kconv(Kconv::JIS, Kconv::AUTO)
  newstring = string.tojis
  newstring = string.toeuc
  newstring = string.tosjis

== Module Functions

--- kconv(str, out_code, in_code = Kconv::AUTO)
#@todo

文字列 str のエンコーディングを out_code に変換したものを
返します。in_code も指定されていたら str のエンコーディングが
in_code だとして動作します。

out_code in_code は定数で指定します。

--- tojis(str)
#@todo

文字列 str のエンコーディングを iso-2022-jp に変換して返します。
以下と同じです。

  Kconv.kconv(str, Kconv::JIS)

--- toeuc(str)
#@todo

文字列 str のエンコーディングを euc-jp に変換して返します。
以下と同じです。

  Kconv.kconv(str, Kconv::EUC)

--- tosjis(str)
#@todo

文字列 str のエンコーディングを shift_jis に変換して返します。
以下と同じです。

  Kconv.kconv(str, Kconv::SJIS)

--- guess(str)
#@todo

文字列 str のエンコーディングを判定します。戻り値は
Kconv の定数です。

#@since 1.8.2
--- guess_old(str)
#@todo
#@end

#@if (version >= "1.8.2")
--- toutf8(str)
#@todo

((<ruby 1.8.2 feature>)):
文字列 str のエンコーディングを utf8 に変換して返します。
以下と同じです。

  Kconv.kconv(str, Kconv::UTF8)
#@end

#@if (version >= "1.8.2")
--- toutf16(str)
#@todo

((<ruby 1.8.2 feature>)):
文字列 str のエンコーディングを utf16 に変換して返します。
以下と同じです。

  Kconv.kconv(str, Kconv::UTF16)
#@end

#@if (version >= "1.8.2")
--- iseuc(str)
#@todo

((<ruby 1.8.2 feature>)):
以下と同じです。

  Kconv::RegexpEucjp.match(str)
#@end

#@if (version >= "1.8.2")
--- issjis(str)
#@todo

((<ruby 1.8.2 feature>)):
以下と同じです。

  Kconv::RegexpShiftjis.match(str)
#@end

#@if (version >= "1.8.2")
--- isutf8(str)
#@todo

((<ruby 1.8.2 feature>)):
以下と同じです。

  Kconv::RegexpUtf8.match(str)
#@end

== Constants

--- AUTO
#@todo

エンコーディングを自動検出します。
入力の指定でのみ有効です。

--- JIS
#@todo

iso-2022-jp を表します。

--- EUC
#@todo

euc-jp を表します。

--- SJIS
#@todo

shift_jis (シフト JIS / MS 漢字コードとも言う) を表します。

--- BINARY
#@todo

JIS EUC SJIS 以外を表します。

--- UNKNOWN
#@todo

出力においては「エンコーディングを判定できなかった」
入力においては AUTO と同様に「自動検出」を表します。

--- NOCONV
#@todo

変換されないことを表します。

#@if (version >= "1.8.2")
--- ASCII
#@todo

((<ruby 1.8.2 feature>)):
ASCII を表します。
#@end

#@if (version >= "1.8.2")
--- UTF8
#@todo

((<ruby 1.8.2 feature>)):
UTF8 を表します。
#@end

#@if (version >= "1.8.2")
--- UTF16
#@todo

((<ruby 1.8.2 feature>)):
UTF16 を表します。
#@end

#@if (version >= "1.8.2")
--- UTF32
#@todo

((<ruby 1.8.2 feature>)):
UTF32 を表します。
#@end

#@if (version >= "1.8.2")
--- RegexpShiftjis
#@todo

((<ruby 1.8.2 feature>)):
SJIS にマッチする正規表現です。
#@end

#@if (version >= "1.8.2")
--- RegexpEucjp
#@todo

((<ruby 1.8.2 feature>)):
EUCJP にマッチする正規表現です。
#@end

#@if (version >= "1.8.2")
--- RegexpUtf8
#@todo

((<ruby 1.8.2 feature>)):
UTF8 にマッチする正規表現です。
#@end

#@since 1.8.5
--- REVISION
#@todo
#@end

#@if (version >= "1.8.2")
#@if (version <= "1.8.4")
--- Iconv_EUC_JP
--- Iconv_Shift_JIS
--- Iconv_UTF8
#@todo
#@end
#@end
