category Network

OpenSSL([[url:https://www.openssl.org/]])
を Ruby から扱うためのライブラリです。

このドキュメントでは SSL/TLS の一般的事項については
解説をしません。利用者は、SSL/TLSの各概念、例えば
以下の事項について理解している必要があります。
  * 暗号と認証に関する一般的概念
  * セキュリティに対する攻撃法
  * 公開鍵暗号と秘密鍵暗号
  * 署名の役割、署名の方法とその検証
  * 公開鍵基盤(PKI, Public Key Infrastructure)
  * X.509 証明書
  * 暗号と乱数について
#@# 要追加
SSLのようなセキュリティ技術は、その利用者に無条件に安全性を
提供することはできません。利用者、とくにSSLでソフトウェアを実装する
プログラマは、 SSL/TLS の技術、それが基づいている概念を理解し、
ライブラリを適切に利用する必要があります。

この文章の内容は無保証です。この文章は内容を検証して書かれて
いますが、間違っている可能性もあります。このライブラリを
セキュリティ的に重大な用途に用いるのであれば、
自分自身でこのドキュメントの内容を検証してください。

OpenSSL は SSL/TLS による通信を提供する高水準なインターフェースと
より基本的な機能を提供する低水準なインターフェースがあります。
基本的には高水準なインターフェースのみを利用すべきです。

低水準なインターフェースを利用する場合には、利用したい機能に
関する十分な知識と注意深さが必要となります。
#@# どれが高水準インターフェースでどれが低水準かの
#@# リストが必要

=== 例

自己署名証明書の作成の例です。自分の秘密鍵で自分の公開鍵に署名しているから自己署名です。

  require 'openssl'
  
  key = OpenSSL::PKey::RSA.new(1024)
  digest = OpenSSL::Digest::SHA1.new()
  
  issu = sub = OpenSSL::X509::Name.new()
  sub.add_entry('C', 'JP')
  sub.add_entry('ST', 'Shimane')
  sub.add_entry('CN', 'Ruby Taro')
  
  cer = OpenSSL::X509::Certificate.new()
  cer.not_before = Time.at(0)
  cer.not_after = Time.at(0)
  cer.public_key = key  # <= 署名する対象となる公開鍵
  cer.serial = 1
  cer.issuer = issu
  cer.subject = sub
  
  cer.sign(key, digest) # <= 署名するのに使う秘密鍵とハッシュ関数
  print cer.to_text

===[a:references] 参考文献
  * [[RFC:5246]]
  * Eric Rescorla. SSL and TLS : Designing and Building Secure Systems.
    邦訳, Eric Rescorla 著 齋藤孝道・鬼頭利之・古森貞監訳.
    マスタリングTCP/IP SSL/TLS編
  * John Viega, Matt Messier and Pravir Chandra. Network Security with OpenSSL:
    Cryptography for Secure Communications. 
    邦訳, John Viega, Matt Messier and Pravir Chandra 著 齋藤孝道監訳.
    OpenSSL -暗号・PKI・SSL/TLSライブラリの詳細-

= module OpenSSL
OpenSSL のすべてのクラス、モジュール、メソッド、定数を
保持しているモジュールです。

== Module functions
--- debug -> bool
デバッグモードが on ならば true を返します。

@see [[m:OpenSSL.#debug=]]

--- debug=(b)
デバッグモードを on/off します。

@see [[m:OpenSSL.#debug]]

--- errors -> [String]
OpenSSL のエラーキューに残っているエラー文字列を返します。

通常、エラーキューはこの拡張ライブラリが空にするため、
これは空の配列を返します。もしそうでないならば
このライブラリのバグです。

--- fips_mode=(bool)

FIPS モードを明示的に on/off します。

@raise OpenSSL::OpenSSLError インストールされている OpenSSL が
       FIPS をサポートしていない場合に発生します。

@see [[m:OpenSSL::OPENSSL_FIPS]]

== Constants

--- VERSION -> String

Ruby/OpenSSL のバージョンです。

--- OPENSSL_VERSION -> String

ビルド時に使われた OpenSSL 本体のバージョンを表した文字列です。

--- OPENSSL_LIBRARY_VERSION -> String

実行時に使われている OpenSSL 本体のバージョンを表した文字列です。

--- OPENSSL_VERSION_NUMBER -> Integer

システムにインストールされている OpenSSL 本体のバージョンを表した数です。
[[url:http://www.openssl.org/docs/crypto/OPENSSL_VERSION_NUMBER.html]]
も参照してください。

#@since 2.0.0
--- OPENSSL_FIPS -> bool

システムにインストールされている OpenSSL が FIPS を
サポートしているならば true です。

していなければ false です。

@see [[m:OpenSSL.#fips_mode=]]

#@end

#@# = module OpenSSL::SSL::SocketForwarder
= class OpenSSL::OpenSSLError < StandardError
すべての OpenSSL 関連の例外クラスのベースとなる例外クラスです。

#@include(openssl/ASN1)
#@include(openssl/ASN1__ASN1Data)
#@include(openssl/ASN1__Constructive)
#@include(openssl/ASN1__ObjectId)
#@include(openssl/ASN1__Primitive)
#@include(openssl/BN)
#@include(openssl/Cipher)
#@include(openssl/Config)
#@include(openssl/Digest)
#@include(openssl/Digest__Digest)
#@include(openssl/Engine) 
#@include(openssl/HMAC)
#@include(openssl/Netscape__SPKI)
#@include(openssl/OCSP)
#@include(openssl/PKCS5)
#@include(openssl/PKCS12)
#@include(openssl/PKCS7)
#@include(openssl/PKey__PKey)
#@include(openssl/PKey__DH)
#@include(openssl/PKey__DSA)
#@include(openssl/PKey__RSA)
#@include(openssl/PKey__EC)
#@include(openssl/Random)
#@include(openssl/SSL)
#@include(openssl/SSL__SSLContext)
#@include(openssl/SSL__SSLServer)
#@include(openssl/SSL__SSLSocket)
#@include(openssl/SSL__Session)
#@include(openssl/X509)
#@include(openssl/X509__Attribute)
#@include(openssl/X509__CRL)
#@include(openssl/X509__Certificate)
#@include(openssl/X509__Extension)
#@include(openssl/X509__ExtensionFactory)
#@include(openssl/X509__Name)
#@include(openssl/X509__Request)
#@include(openssl/X509__Revoked)
#@include(openssl/X509__Store)
#@include(openssl/X509__StoreContext)
