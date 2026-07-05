---
library: openssl
alias:
  - OpenSSL::PKCS7::Signer
---
# class OpenSSL::PKCS7::SignerInfo < Object
署名者の情報を表すクラスです。


## Class Methods
### def new(cert, key, digest) -> OpenSSL::PKCS7::SignerInfo
署名者オブジェクトを証明書、秘密鍵、ダイジェスト方式から生成します。

証明書、秘密鍵、ダイジェスト方式は署名をするために利用します。

- **param** `cert` -- 証明書([c:OpenSSL::X509::Certificate] オブジェクト)
- **param** `key` -- 秘密鍵([c:OpenSSL::PKey::PKey] オブジェクト)
- **param** `digest` -- メッセージダイジェスト方式(文字列もしくは [c:OpenSSL::Digest] オブジェクト)

## Instance Methods

### def issuer -> OpenSSL::X509::Name
### def name -> OpenSSL::X509::Name

署名者の証明書の発行者の名前(DN)を返します。

これと [m:OpenSSL::PKCS7::SignerInfo#serial] で
署名者を一意に識別します。

### def serial -> Integer
署名者の証明書の識別番号を返します。

これと [m:OpenSSL::PKCS7::SignerInfo#issuer] で
署名者を一意に識別します。

### def signed_time -> Time
その署名者が署名した時刻を返します。

