このライブラリは obsolete です。[[lib:digest]] ライブラリを使ってください。

#@since 1.8.6
= class MD5 < Digest::MD5
MD5 ハッシュを生成するためのクラスです。
[[c:Digest::MD5]] を使ってください。

#@else
[[lib:digest/md5]] をロードして  MD5 を Digest::MD5 に置き換えます。

= class MD5
[[c:Digest::MD5]] のエイリアスです。
[[c:Digest::MD5]] を使ってください。
#@end
== Class Methods
#@since 1.8.6
--- new(str = nil) -> MD5

MD5 ハッシュを生成します。

@param str 文字列を指定します。

--- orig_new -> MD5

MD5 ハッシュを生成します。
#@end

--- md5(str) -> MD5

MD5 ハッシュを生成します。

@param str 文字列を指定します。
