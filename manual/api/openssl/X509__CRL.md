---
library: openssl
---
# class OpenSSL::X509::CRL < Object

CRL(証明書失効リスト) クラス。

CRL とは、危殆化した等なんらかの理由で失効した証明書のリストです。
通常 CA によって発行されるものです。
[c:OpenSSL::X509::Store] に組込むことで失効した証明書の検証を
失敗させることができます。

通常 CRL の信頼性を確認するためには CRL になされた
署名を検証する必要があります。

  - [RFC:5280]

## Class Methods

### def new -> OpenSSL::X509::CRL
### def new(obj) -> OpenSSL::X509::CRL
CRL(証明書失効リスト)オブジェクトを生成します。

新しい OpenSSL::X509::Request オブジェクトを生成します。

引数なしの場合は空の OpenSSL::X509::Request オブジェクトを生成します。

引数が文字列の場合は、PEM 形式もしくは DER 形式であると
みなしてオブジェクトを生成します。

引数が [c:IO] オブジェクトである場合は、そのファイルの中身から
オブジェクトを生成します。

引数が OpenSSL::X509::CRL である場合には、その内容を
コピーしたオブジェクトを生成します。

引数が to_der メソッドを持つ場合は、そのメソッドによって
DER 形式の文字列に変換してからオブジェクトを生成します。

- **param** `obj` -- CRL のデータ
- **raise** `OpenSSL::X509::CRLError` -- オブジェクトの生成に失敗した場合に発生します

## Instance Methods

### def version -> Integer
その CRL が準拠している規格のバージョンを返します。

X.509 v2 CRL であれば 1 を返します。

- **SEE** [m:OpenSSL::X509::CRL#version=]

### def version=(version)
その CRL が準拠している規格のバージョンを設定します。

X.509 v2 CRL であれば 1 を渡します。

- **param** `version` -- 設定するバージョンの整数
- **raise** `OpenSSL::X509::CRLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::X509::CRL#version]

### def signature_algorithm -> String
署名に使ったアルゴリズム名を文字列で返します。

- **raise** `OpenSSL::X509::CRLError` -- 名前の取得に失敗した場合に発生します

### def issuer -> OpenSSL::X509::Name
CRL の発行者を返します。

### def issuer=(issuer)
CRL の発行者を設定します。

- **param** `issuer` -- 発行者の [c:OpenSSL::X509::Name] オブジェクト
- **raise** `OpenSSL::X509::CRLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::X509::CRL#issuer]

### def last_update -> Time
CRL が最後に更新された日時を Time オブジェクトで返します。

### def last_update=(time)
CRL が最後に更新された日時を Time オブジェクトで設定します。

- **param** `time` -- 最終更新日時
- **raise** `OpenSSL::X509::CRLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::X509::CRL#last_update]

### def next_update -> Time
CRL の次回更新日時を Time オブジェクトで返します。

### def next_update=(time)
CRL の次回更新日時を Time オブジェクトで設定します。

- **param** `time` -- 最終更新日時
- **raise** `OpenSSL::X509::CRLError` -- 設定に失敗した場合に発生します
- **SEE** [m:OpenSSL::X509::CRL#next_update]

### def revoked -> [OpenSSL::X509::Revoked]
自身が持っている失効した証明書の配列を返します。


### def revoked=(revs)
失効証明書リストを更新します。

このメソッドを呼びだす前のリストは破棄されます。
revs には失効した証明書を [c:OpenSSL::X509::Revoked] の配列で渡します。

- **param** `revs` -- 設定する失効した証明書の配列
- **raise** `OpenSSL::X509::CRLError` -- 設定に失敗した場合に発生します

### def add_revoked(rev) -> OpenSSL::X509::Revoked
失効証明書リストに新たな要素を加えます。

rev は失効した証明書を表す [c:OpenSSL::X509::Revoked] オブジェクトです。

返り値は rev です。

- **param** `rev` -- 追加する失効した証明書を表すオブジェクト
- **raise** `OpenSSL::X509::CRLError` -- 追加に失敗した場合に発生します

### def sign(pkey, digest) -> self
CRL に秘密鍵で署名します。

- **param** `pkey` -- 秘密鍵([c:OpenSSL::PKey::PKey] オブジェクト)
- **param** `digest` -- ハッシュアルゴリズム
- **raise** `OpenSSL::X509::CRLError` -- 署名に失敗した場合に発生します

### def verify(key) -> bool
発行者の公開鍵で CRL に記載されている署名を検証します。

検証に成功した場合は true を返します。

- **param** `key` -- 公開鍵([c:OpenSSL::PKey::PKey] オブジェクト)
- **raise** `OpenSSL::X509::CRLError` -- 検証時にエラーが生じた場合に発生します

### def to_der -> String
DER 形式に変換します。

- **raise** `OpenSSL::X509::CRLError` -- 変換に失敗した場合に発生します
### def to_pem -> String
### def to_s -> String
PEM 形式に変換します。

- **raise** `OpenSSL::X509::CRLError` -- 変換に失敗した場合に発生します

### def to_text -> String
人間が読める形式に変換します。

- **raise** `OpenSSL::X509::CRLError` -- 変換に失敗した場合に発生します
### def extensions -> [OpenSSL::X509::Extension]
CRL が持っている拡張領域のデータを配列で返します。

### def extensions=(extensions)
CRL の拡張領域を extensions で更新します。

extensions には [c:OpenSSL::X509::Extension] の配列を渡します。

更新前の拡張領域のデータは破棄されます。

- **param** `extensions` -- 拡張領域のデータ
- **raise** `OpenSSL::X509::CRLError` -- 更新に失敗した場合に発生します
### def add_extension(ex) -> OpenSSL::X509::Extension
拡張領域に ex を追加します。

追加するデータは [c:OpenSSL::X509::Extension] のオブジェクトを渡します。

ex を返します。

- **param** `ex` -- 追加するデータ
- **raise** `OpenSSL::X509::CRLError` -- 追加に失敗した場合に発生します

# class OpenSSL::X509::CRLError < OpenSSL::OpenSSLError
[c:OpenSSL::X509::CRL] 関連のエラーが生じたときに発生します。
