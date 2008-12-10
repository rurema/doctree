
OpenSSL がインストールされていないシステムがあるかもしれないので、
OpenSSL が使えるかどうかを確認するためのライブラリです。

= reopen Gem

== Singleton Methods

--- ssl_available? -> bool

現在実行中のプラットフォームで OpenSSL が有効である場合は真を返します。
そうでない場合は偽を返します。

--- ensure_ssl_available

OpenSSL が使用可能でない場合は例外を発生させます。

@raise Gem::Exception OpenSSL が有効でない場合に発生します。


= module Gem::SSL
#@todo

== Constants

--- PKEY_RSA -> Symbol | Class
#@todo

--- DIGEST_SHA1 -> Symbol | Class
#@todo
