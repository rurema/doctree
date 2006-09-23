#@if (version >= "1.8.0")
#@# = openssl

[[unknown:OpenSSL|URL:http://www.openssl.org]] support library for Ruby.
動作や使える暗号方式は

[[unknown:執筆者募集]]

=== Components

  * [[c:OpenSSL]]
  * OpenSSL::Cipher
    * [[c:OpenSSL::Cipher::Cipher]]
    * 以下のクラスは Cipher を継承している。使い方は Chipher を参照。
    * OpenSSL::Cipher::AES
    * OpenSSL::Cipher::BF
    * OpenSSL::Cipher::CAST5
    * OpenSSL::Cipher::DES
    * OpenSSL::Cipher::IDEA
    * OpenSSL::Cipher::RC2
    * OpenSSL::Cipher::RC4
    * OpenSSL::Cipher::RC5
  * OpenSSL::Digest
    * [[c:OpenSSL::Digest::Digest]]
    * 以下のクラスは Digest を継承している。使い方は Digest を参照。
    * OpenSSL::Digest::DSS1
    * OpenSSL::Digest::MD2
    * OpenSSL::Digest::MD4
    * OpenSSL::Digest::MD5
    * OpenSSL::Digest::MDC2
    * OpenSSL::Digest::RIPEMD160
    * OpenSSL::Digest::SHA
    * OpenSSL::Digest::SHA1
    * OpenSSL::Digest::SHA224
    * OpenSSL::Digest::SHA256
    * OpenSSL::Digest::SHA384
    * OpenSSL::Digest::SHA512
  * OpenSSL::X509
    * [[c:OpenSSL::X509::Certificate]]
    * [[c:OpenSSL::X509::CRL]]
    * [[c:OpenSSL::X509::Extension]]
    * [[c:OpenSSL::X509::Name]]
    * [[c:OpenSSL::X509::Store]]
    * [[c:OpenSSL::X509::StoreContext]]
  * [[c:OpenSSL::SSL]]
    *[[c:OpenSSL::SSL::SSLContext]]
    *[[c:OpenSSL::SSL::SSLServer]]
    *[[c:OpenSSL::SSL::SSLSocket]]
  * [[c:OpenSSL::PKCS7]]
    * [[c:OpenSSL::PKCS7::PKCS7]]
  * OpenSSL::PKey
    * [[c:OpenSSL::PKey::PKey]]
    * [[c:OpenSSL::PKey::RSA]]
    * [[c:OpenSSL::PKey::DSA]]
    * [[c:OpenSSL::PKey::DH]]
  * OpenSSL::Config
  * OpenSSL::Engine
  * [[c:OpenSSL::ASN1]]
    * [[c:OpenSSL::ASN1::ASN1Data]]
      * [[c:OpenSSL::ASN1::Primitive]]
        * OpenSSL::ASN1::Boolean
        * OpenSSL::ASN1::Integer
        * OpenSSL::ASN1::Enumerated
        * OpenSSL::ASN1::BitString
        * OpenSSL::ASN1::OctetString
        * OpenSSL::ASN1::UTF8String
        * OpenSSL::ASN1::NumericString
        * OpenSSL::ASN1::PrintableString
        * OpenSSL::ASN1::T61String
        * OpenSSL::ASN1::VideotexString
        * OpenSSL::ASN1::IA5String
        * OpenSSL::ASN1::GraphicString
        * OpenSSL::ASN1::ISO64String
        * OpenSSL::ASN1::GeneralString
        * OpenSSL::ASN1::UniversalString
        * OpenSSL::ASN1::BMPString
        * OpenSSL::ASN1::Null
        * [[c:OpenSSL::ASN1::ObjectId]]
        * OpenSSL::ASN1::UTCTime
        * OpenSSL::ASN1::GeneralizedTime
      * [[c:OpenSSL::ASN1::Constructive]]
        * OpenSSL::ASN1::Sequence
        * OpenSSL::ASN1::Set

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

=== 例外

  * OpenSSL::OpenSSLError
    * OpenSSL::ASN1::ASN1Error
    * OpenSSL::Cipher::CipherError
    * OpenSSL::Digest::DigestError
    * OpenSSL::PKey::PKeyError
    * OpenSSL::Random::RandomError
    * OpenSSL::SSL::SSLError
    * OpenSSL::X509::AttributeError
    * OpenSSL::X509::CertificateError
    * OpenSSL::X509::CRLError
    * OpenSSL::X509::ExtensionError
    * OpenSSL::X509::NameError
    * OpenSSL::X509::RequestError
    * OpenSSL::X509::RevokedError
    * OpenSSL::X509::StoreError

= module OpenSSL

このページは定数と例外のみを説明しています。

== Constants

--- VERSION

Ruby/OpenSSL のバージョンです。

--- OPENSSL_VERSION

システムにインストールされている OpenSSL 本体のバージョンを表した文字列です。

--- OPENSSL_VERSION_NUMBER

システムにインストールされている OpenSSL 本体のバージョンを表した数です。
[[m:URL:http:#/www.openssl.org/docs/crypto/OPENSSL_VERSION_NUMBER.html]]
も参照してください。
#@end
