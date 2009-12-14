[[lib:net/http]] に SSL/TLS 拡張を実装するライブラリです。

[注意] net/https は RFC2818 の 3.1 に定められた
「サーバーの証明書に記載された身元のチェック」を自動では実行しません。
接続しているはずのサーバのホスト名と証明書に記載されているホスト名が
一致するかをライブラリの使用者が各自実装する必要があります。

[[url:http://www.ipa.go.jp/security/rfc/RFC2818JA.html#31]]

[[ruby-dev:25254]]

=== Example

簡単な例を挙げます。
verify_mode に指定する定数に関しては [[c:OpenSSL::SSL]] を参照してください。
必ず use_ssl = true を呼ばなければいけないところに注意してください。

  require 'net/https'
  https = Net::HTTP.new('www.example.com',443)
  https.use_ssl = true
  https.ca_file = '/usr/share/ssl/cert.pem'
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https.verify_depth = 5
  https.start {
    response = https.get('/')
    puts response.body
  }

以下は HTTPS プロクシ経由でアクセスする例です。
プロクシ経由でも通信路は暗号化されます。
詳しくは以下を参照してください。

 * WWWプロキシにおけるSSLトンネリング: [[url:http://www21.ocn.ne.jp/~k-west/SSLandTLS/draft-luotonen-ssl-tunneling-03-Ja.txt]]

  require 'net/https'
  proxy_addr = 'proxy.example.com'
  proxy_port = 3128
  https = Net::HTTP::Proxy(proxy_addr, proxy_port).new('www.example.com',443)
  https.use_ssl = true
  https.ca_file = '/usr/share/ssl/cert.pem'
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  https.verify_depth = 5
  https.start {
    response = https.get('/')
    puts response.body
  }

= reopen Net::HTTP

== Instance Methods

--- use_ssl?
#@todo

HTTP で SSL/TLS を使うなら true を返します。

--- use_ssl=(bool)
#@todo

HTTP で SSL/TLS を使うかどうかを設定します。
HTTPS 使う場合は true を代入します。
デフォルトでは false です。
つまり SSL/TLS を有効にするには必ず use_ssl = true を呼ぶ必要があります。

--- ssl_timeout
#@todo

--- ssl_timeout=(sec)
--- timeout=(sec)
#@todo

--- peer_cert
#@todo

サーバが送ってきた X.509 証明書を
OpenSSL::X509::Certificate オブジェクトとして返します。

--- key
--- key=(key)
#@todo

[[c:OpenSSL::PKey::RSA]] オブジェクトか
[[c:OpenSSL::PKey::DSA]] オブジェクトを設定します。

--- cert
--- cert=(certificate)
#@todo

クライアント証明書として
[[c:OpenSSL::X509::Certificate]] オブジェクトを設定します。

--- ca_file
--- ca_file=(path)
#@todo

PEM 形式で保存された CA 証明書ファイルのパスを設定します。
ファイルには複数の CA 証明書が含まれていても構いません。

--- ca_path
--- ca_path=(path)
#@todo

PEM 形式で保存された CA 証明書ファイルが存在するディレクトリを設定します。

--- verify_mode
--- verify_mode=(mode)
#@todo

サーバ証明書に対する検証モードを設定します。
OpenSSL::SSL::VERIFY_NONE か OpenSSL::SSL::VERIFY_PEER が設定可能です。
[[c:OpenSSL::SSL]] も参照してください。

--- verify_callback
--- verify_callback=(proc)
#@todo

通常のサーバ証明書の検証に加えてさらに適用される
[[c:Proc]] オブジェクトを設定します。

--- verify_depth
--- verify_depth=(depth)
#@todo

サーバ証明書を検証する時の証明書チェーンの最大の深さを設定します。

--- cert_store
--- cert_store=(store)
#@todo

サーバ証明書の検証のために使う信頼している CA 証明書のストレージ
[[c:OpenSSL::X509::Store]] オブジェクトを設定します。
通常は ca_path=(path) や ca_file=(path) を使います。
