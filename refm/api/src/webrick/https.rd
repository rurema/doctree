#@since 1.8.1
require webrick/ssl

[[c:WEBrick::HTTPServer]] を SSL/TLS に対応させるための実装。
このファイルを require すると WEBrick::HTTPServer が SSL/TLS 対応になります。

= redefine WEBrick::Config

== Constants

--- HTTP
[[m:WEBrick::Config::SSL]] の内容がマージされます。

= redefine WEBrick::HTTPRequest

== Instance Methods

--- cipher

--- server_cert

--- client_cert

--- parse(socket = nil)

--- parse_uri(str, scheme = "http")

--- meta_vars
#@end
