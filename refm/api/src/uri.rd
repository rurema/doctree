category Network

URI (Uniform Resource Identifier) のためのライブラリです。

=== 関連 RFC

以下は実装の際に参照されている RFC であり、最新の RFC であるとは限りません。

  * [[RFC:1738]] Uniform Resource Locators (URL)                       (Updated by [[RFC:2396]])
  * [[RFC:2255]] The LDAP URL Format                                   (Obsoleted by [[RFC:4510]], [[RFC:4516]])
  * [[RFC:2368]] The mailto URL scheme
  * [[RFC:2373]] IP Version 6 Addressing Architecture                  (Obsoleted by [[RFC:3513]])
  * [[RFC:2396]] Uniform Resource Identifiers (URI): Generic Syntax    (Obsoleted by [[rfc:3986]])
  * [[RFC:2732]] Format for Literal IPv6 Addresses in URL's            (Obsoleted by [[rfc:3986]])
  * [[rfc:3986]] Uniform Resource Identifier (URI): Generic Syntax
  * [[rfc:3987]] Internationalized Resource Identifiers (IRIs)

#@include(uri/URI)
#@include(uri/Generic)
#@include(uri/FTP)
#@include(uri/HTTP)
#@include(uri/LDAP)
#@since 1.8.7
#@include(uri/LDAPS)
#@end
#@include(uri/MailTo)

#@since 1.8.2
= reopen Kernel

== Module Functions

--- URI(uri_str) -> object

与えられた URI から該当する [[c:URI::Generic]] のサブクラスのインスタンスを生成して
返します。scheme が指定されていない場合は、[[c:URI::Generic]] オブジェクトを返します。

@param uri_str パースしたい URI を文字列として与えます。

@raise URI::InvalidURIError パースに失敗した場合に発生します。

@see [[m:URI.parse]]

#@end

= class URI::Error < StandardError

すべての URI 例外クラスの基底クラスです。

= class URI::InvalidURIError < URI::Error

不正な URI を指定したときに発生します。

= class URI::InvalidComponentError < URI::Error

不正な構成要素を指定したときに発生します。

= class URI::BadURIError < URI::Error

URI として正しいが、使い方が悪いときに発生します。
