URI (Uniform Resource Identifier) サポートライブラリ

=== 関連 RFC

    * [[RFC:1738]] Uniform Resource Locators (URL)
    * [[RFC:1808]] Relative Uniform Resource Locators
    * [[RFC:2255]] The LDAP URL Format
    * [[RFC:2368]] The mailto URL scheme
    * [[RFC:2373]] IP Version 6 Addressing Architecture
    * [[RFC:2396]] Uniform Resource Identifiers (URI): Generic Syntax
    * [[RFC:2732]] Format for Literal IPv6 Addresses in URL's

#@include(uri/URI)
#@include(uri/Generic)
#@include(uri/FTP)
#@include(uri/HTTP)
#@include(uri/LDAP)
#@include(uri/MailTo)

#@since 1.8.2
= reopen Kernel

== Private Instance Methods

--- URI(uri_str)
#@todo

[[m:URI.parse]]と同じです。
#@end

= class URI::Error < StandardError

すべての URI 例外クラスの基底クラスです。

= class URI::InvalidURIError < URI::Error

不正な URI を指定したときに発生します。

= class URI::InvalidComponentError < URI::Error

不正な構成要素を指定したときに発生します。

= class URI::BadURIError < URI::Error

URI として正しいが、使い方が悪いときに発生します。
