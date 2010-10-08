#@since 1.8.1
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
#@todo

--- server_cert -> OpenSSL::X509::Certificate
#@todo

サーバ証明書

--- client_cert -> OpenSSL::X509::Certificate
#@todo

クライアント証明書

= redefine WEBrick::HTTPRequest

== Instance Methods

--- parse(socket = nil) -> ()

指定された socket からクライアントのリクエストを読み込み、
自身のアクセサなどを適切に設定します。

@param socket クライアントに接続された IO オブジェクトを指定します。

--- parse_uri(str, scheme = "http")
#@todo should be private

--- meta_vars -> Hash
#@todo


#@end
