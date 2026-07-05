---
type: library
require:
  - webrick/ssl
---
[c:WEBrick::HTTPServer] を SSL/TLS に対応させるための実装。
このファイルを [m:Kernel?.require] すると [c:WEBrick::HTTPServer] が SSL/TLS 対応になります。

# redefine WEBrick::Config

## Constants

### const HTTP -> Hash

[m:WEBrick::Config::SSL] の内容がマージされています。

# reopen WEBrick::HTTPRequest

## Instance Methods

### def cipher -> Array

現在実際に使われている暗号の情報を配列で返します。 

- **SEE** [m:OpenSSL::SSL::SSLSocket#cipher]

### def server_cert -> OpenSSL::X509::Certificate

サーバ証明書を表すオブジェクトを返します。

- **SEE** [c:OpenSSL::X509::Certificate]

### def client_cert -> OpenSSL::X509::Certificate

クライアント証明書を表すオブジェクトを返します。

- **SEE** [m:OpenSSL::X509::Certificate]

# redefine WEBrick::HTTPRequest

## Instance Methods

### def parse(socket = nil) -> ()

指定された socket からクライアントのリクエストを読み込み、
自身のアクセサなどを適切に設定します。

- **param** `socket` -- クライアントに接続された IO オブジェクトを指定します。

#@#--- parse_uri(str, scheme = "https")
#@#todo should be private

### def meta_vars -> Hash

メタ変数を返します。

