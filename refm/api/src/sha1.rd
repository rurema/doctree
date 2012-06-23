category Obsolete

このライブラリは obsolete です。[[lib:digest]] ライブラリを使ってください

#@since 1.8.6
[[c:Digest::SHA1]] を継承した SHA1 クラスを定義します。

= class SHA1 < Digest::SHA1

SHA1 ハッシュを生成するためのライブラリです。
[[c:Digest::SHA1]] を使ってください。
#@else
[[lib:digest/sha1]] をロードして  SHA1 を Digest::SHA1 に置き換えます。

= class SHA1

[[c:Digest::SHA1]] のエイリアスです。
[[c:Digest::SHA1]] を使ってください。
#@end
== Singleton Methods
#@since 1.8.6
--- new(str = nil) -> SHA1

SHA1 ハッシュを生成します。

@param str 文字列を指定します。

--- orig_new  -> SHA1

SHA1 ハッシュを生成します。

#@end

--- sha1(arg)  -> SHA1
SHA1 ハッシュを生成します。

@param arg 文字列を指定します。
