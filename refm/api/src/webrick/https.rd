require webrick/ssl

[[c:WEBrick::HTTPServer]] を SSL/TLS に対応させるための実装。
このファイルを [[m:Kernel.#require]] すると [[c:WEBrick::HTTPServer]] が SSL/TLS 対応になります。

= redefine WEBrick::Config

== Constants

--- HTTP -> Hash

[[m:WEBrick::Config::SSL]] の内容がマージされています。

= reopen WEBrick::HTTPRequest

== Instance Methods

--- cipher -> Array

現在実際に使われている暗号の情報を配列で返します。 

@see [[m:OpenSSL::SSL::SSLSocket#cipher]]

--- server_cert -> OpenSSL::X509::Certificate

サーバ証明書を表すオブジェクトを返します。

@see [[c:OpenSSL::X509::Certificate]]

--- client_cert -> OpenSSL::X509::Certificate

クライアント証明書を表すオブジェクトを返します。

@see [[m:OpenSSL::X509::Certificate]]

= redefine WEBrick::HTTPRequest

== Instance Methods

--- parse(socket = nil) -> ()

指定された socket からクライアントのリクエストを読み込み、
自身のアクセサなどを適切に設定します。

@param socket クライアントに接続された IO オブジェクトを指定します。

#@#--- parse_uri(str, scheme = "https")
#@#todo should be private

--- meta_vars -> Hash

メタ変数を返します。

