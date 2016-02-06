category Network

#@until 1.9.2
[[lib:net/http]] に SSL/TLS 拡張を実装するライブラリです。

[[c:Net::HTTP]] を再オープンし、SSL/TLS 拡張を追加します。

#@until 1.8.6
[注意] net/https は RFC2818 の 3.1 に定められた
「サーバーの証明書に記載された身元のチェック」を自動では実行しません。
接続しているはずのサーバのホスト名と証明書に記載されているホスト名が
一致するかをライブラリの使用者が各自実装する必要があります。

[[url:http://www.ipa.go.jp/security/rfc/RFC2818JA.html#31]]

[[ruby-dev:25254]]
#@end

=== デフォルトパラメータについて
net/https は [[m:OpenSSL::SSL::SSLContext#set_params]] で
SSLContext を初期化します。そのため
指定されなかったパラメータは [[m:OpenSSL::SSL::SSLContext::DEFAULT_PARAMS]] 
の値で初期化されます。
[[m:Net::HTTP#ca_file=]] も [[m:Net::HTTP#ca_path=]] も 
[[m:Net::HTTP#cert_store]] も設定しなかった場合は 
[[m:OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE]]
が証明書ストアとして用いられます。


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
#@#詳しくは以下を参照してください。
#@# * WWWプロキシにおけるSSLトンネリング: [[url:http://www21.ocn.ne.jp/~k-west/SSLandTLS/draft-luotonen-ssl-tunneling-03-Ja.txt]]

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

--- use_ssl? ->  bool
HTTP で SSL/TLS を使うなら true を返します。

--- use_ssl=(bool)
HTTP で SSL/TLS を使うかどうかを設定します。

HTTPS 使う場合は true を設定します。
セッションを開始する前に設定をしなければなりません。

デフォルトでは false です。
つまり SSL/TLS を有効にするには必ず use_ssl = true を呼ぶ必要があります。

@param bool SSL/TLS を利用するかどうか
@raise IOError セッション開始後に設定を変更しようとすると発生します

--- ssl_timeout -> Integer | nil
SSL/TLS のタイムアウト秒数を返します。

設定されていない場合は nil を返します。

@see [[m:Net::HTTP#ssl_timeout=]],
     [[m:OpenSSL::SSL::SSLContext#ssl_timeout]]

--- ssl_timeout=(sec)
#@until 1.9.1
--- timeout=(sec)
#@end

SSL/TLS のタイムアウト秒数を設定します。

HTTP セッション開始時([[m:Net::HTTP#start]] など)に
[[m:OpenSSL::SSL::SSLContext#ssl_timeout=]] で
タイムアウトを設定します。

デフォルト値は [[m:OpenSSL::SSL::SSLContext#ssl_timeout=]] と
同じで、OpenSSL のデフォルト値(300秒)を用います。

#@until 1.9.1
timeout= は obsolete です。互換性のために
存在します。1.9 では廃止されています。
#@end

@param sec タイムアウト秒数
@see [[m:Net::HTTP#ssl_timeout]],
     [[m:OpenSSL::SSL::SSLContext#ssl_timeout=]]

--- peer_cert -> OpenSSL::X509::Certificate | nil
サーバの証明書を返します。

SSL/TLS が有効でなかったり、接続前である場合には nil
を返します。

@see [[m:OpenSSL::SSL::SSLSocket#peer_cert]]

--- key -> OpenSSL::PKey::PKey | nil
クライアント証明書の秘密鍵を返します。

@see [[m:Net::HTTP#key=]], [[m:OpenSSL::SSL::SSLContext#key]]

--- key=(key)
クライアント証明書の秘密鍵を設定します。

[[c:OpenSSL::PKey::RSA]] オブジェクトか
[[c:OpenSSL::PKey::DSA]] オブジェクトを設定します。

デフォルトは nil (鍵なし)です。

@param key 設定する秘密鍵
@see [[m:Net::HTTP#key]],
     [[m:OpenSSL::SSL::SSLContext#key=]]

--- cert -> OpenSSL::X509::Certificate | nil
クライアント証明書を返します。

@see [[m:Net::HTTP#cert=]], [[m:OpenSSL::SSL::SSLContext#cert]]

--- cert=(certificate)
クライアント証明書を設定します。

デフォルトは nil (クライアント証明書による認証をしない)です。

@param certificate 証明書オブジェクト([[c:OpenSSL::X509::Certificate]])
@see [[m:Net::HTTP#cert]], [[m:OpenSSL::SSL::SSLContext#cert=]]

--- ca_file -> String | nil
信頼する CA 証明書ファイルのパスを返します。

@see [[m:Net::HTTP#ca_file=]], [[m:OpenSSL::SSL::SSLContext#ca_file]]

--- ca_file=(path)
信頼する CA 証明書ファイルのパスを文字列で設定します。

ファイルには複数の証明書を含んでいても構いません。
詳しくは [[m:OpenSSL::SSL::SSLContext#ca_file=]] を見てください。

デフォルトは nil (指定なし)です。

@param path ファイルパス文字列
@see [[m:Net::HTTP#ca_file]], [[m:OpenSSL::SSL::SSLContext#ca_file=]]

--- ca_path -> String | nil
信頼する CA 証明書ファイルが存在するディレクトリを設定します。

@see [[m:Net::HTTP#ca_path=]], [[m:OpenSSL::SSL::SSLContext#ca_path]]

--- ca_path=(path)
信頼する CA 証明書ファイルが存在するディレクトリを設定します。

ファイル名はハッシュ値の文字列にしなければなりません。
詳しくは [[m:OpenSSL::SSL::SSLContext#ca_path=]] を見てください。

デフォルトは nil (指定なし)です。

@param path ディレクトリ名文字列
@see [[m:Net::HTTP#ca_path]], [[m:OpenSSL::SSL::SSLContext#ca_path=]]

--- verify_mode -> Integer | nil
検証モードを返します。

デフォルトは nil です。

--- verify_mode=(mode)
検証モードを設定します。

詳しくは [[m:OpenSSL::SSL::SSLContext#verify_mode]] を見てください。
クライアント側なので、
[[m:OpenSSL::SSL::VERIFY_NONE]] か [[m:OpenSSL::SSL::VERIFY_PEER]]
のいずれかを用います。

デフォルトは nil で、VERIFY_PEER を意味します。

--- verify_callback -> Proc
自身に設定されている検証をフィルタするコールバックを
返します。

デフォルトのコールバックが設定されている場合には nil を返します。

@see [[m:Net::HTTP#verify_callback=]],
     [[m:OpenSSL::X509::Store#verify_callback]],
     [[m:OpenSSL::SSL::SSLContext#verify_callback]]

--- verify_callback=(proc)
検証をフィルタするコールバックを設定します。

詳しくは [[m:OpenSSL::X509::Store#verify_callback=]] や
[[m:OpenSSL::SSL::SSLContext#verify_callback=]] を見てください。

@param proc 設定する [[c:Proc]] オブジェクト
@see [[m:Net::HTTP#verify_callback]],
     [[m:OpenSSL::X509::Store#verify_callback=]],
     [[m:OpenSSL::SSL::SSLContext#verify_callback=]]

--- verify_depth -> Integer
証明書チェイン上の検証する最大の深さを返します。

@see [[m:Net::HTTP#verify_depth=]], [[m:OpenSSL::SSL::SSLContext#verify_depth]]

--- verify_depth=(depth)
証明書チェイン上の検証する最大の深さを設定します。

デフォルトは nil で、この場合 OpenSSL のデフォルト値(9)が使われます。

@param depth 最大深さを表す整数
@see [[m:Net::HTTP#verify_depth]], [[m:OpenSSL::SSL::SSLContext#verify_depth=]]

--- cert_store -> OpenSSL::X509::Store | nil
接続相手の証明書の検証のために使う、信頼している CA 証明書を
含む証明書ストアを返します。

@see [[m:Net::HTTP#cert_store]], [[m:OpenSSL::SSL::SSLContext#cert_store=]]

--- cert_store=(store)
接続相手の証明書の検証のために使う、信頼している CA 証明書を
含む証明書ストアを設定します。

通常は [[m:Net::HTTP#ca_file=]] や [[m:Net::HTTP#ca_path=]] で
設定しますが、より詳細な設定をしたい場合にはこちらを用います。

デフォルトは nil (証明書ストアを指定しない)です。

@see [[m:Net::HTTP#cert_store=]], [[m:OpenSSL::SSL::SSLContext#cert_store]]

#@since 1.9.1
--- ssl_version -> String | Symbol | nil
利用するプロトコルの種類を返します。

@see [[m:Net::HTTP#ssl_version=]]

--- ssl_version=(ver)
利用するプロトコルの種類を文字列もしくは
シンボルで指定します。

[[m:OpenSSL::SSL::SSLContext.new]] で指定できるものと同じです。

@param ver 利用するプロトコルの種類
@see [[m:Net::HTTP#ssl_version]], [[m:OpenSSL::SSL::SSL#ssl_version=]]


--- ciphers -> String | [String] | nil
[[m:Net::HTTP#ciphers]] で設定した値を返します。

[[m:OpenSSL::SSL::SSLContext#ciphers]] が返す値とは
異なるので注意してください。

@see [[m:Net::HTTP#ciphers=]]

--- ciphers=(ciphers)
利用可能な共通鍵暗号を設定します。

[[m:OpenSSL::SSL::SSLContext#ciphers=]] と同じ形式で
設定します。詳しくはそちらを参照してください。

@param ciphers 利用可能にする共通鍵暗号の種類
@see [[m:Net::HTTP#ciphers]]

#@end

#@else
このライブラリは Ruby 1.9.2 で [[lib:net/http]] にマージされました。
そちらを使ってください。

#@end
