---
library: openssl
---
# class OpenSSL::X509::Revoked < Object

失効した証明書のクラス。

[m:OpenSSL::X509::CRL#revoked] で返される
失効証明書リストがこのクラスの配列です。

## Class Methods

### def new -> OpenSSL::X509::Revoked

空の Revoked オブジェクトを生成し、返します。

## Instance Methods

### def serial -> OpenSSL::BN

失効した証明書のシリアルを返します。

### def serial=(serial)

失効した証明書のシリアルを設定します。

シリアルは [c:OpenSSL::BN] のインスタンスで指定します。

- **param** `serial` -- 失効した証明書のシリアル
- **SEE** [m:OpenSSL::X509::Revoked#serial]

### def time -> Time

失効した日時を返します。

### def time=(time)

失効した日時を Time オブジェクトで設定します。

- **param** `time` -- 失効日時
- **SEE** [m:OpenSSL::X509::Revoked#time]

### def extensions -> [OpenSSL::X509::Extension]

拡張領域のデータを配列で返します。

### def extensions=(extensions)

拡張領域を extensions で更新します。

extensions には [c:OpenSSL::X509::Extension] の配列を渡します。

更新前の拡張領域のデータは破棄されます。

- **param** `extensions` -- 拡張領域のデータ
- **raise** `OpenSSL::X509::RevokedError` -- 更新に失敗した場合に発生します

### def add_extension(ex) -> OpenSSL::X509::Extension

拡張領域に ex を追加します。

追加するデータは [c:OpenSSL::X509::Extension] のオブジェクトを渡します。

ex を返します。

- **param** `ex` -- 追加するデータ
- **raise** `OpenSSL::X509::RevokedError` -- 追加に失敗した場合に発生します

# class OpenSSL::X509::RevokedError < OpenSSL::OpenSSLError

[c:OpenSSL::X509::Revoked] 関連のエラーが生じたときに発生します。
