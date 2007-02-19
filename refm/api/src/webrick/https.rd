#@since 1.8.1
require webrick/ssl

[[c:WEBrick::HTTPServer]] を SSL/TLS に対応させるための実装。
このファイルを require すると WEBrick::HTTPServer が SSL/TLS 対応になります。

= redefine WEBrick::Config

== Constants

--- HTTP
#@todo
[[m:WEBrick::Config::SSL]] の内容がマージされます。

= reopen WEBrick::HTTPRequest

== Instance Methods

--- cipher
#@todo

--- server_cert
#@todo

--- client_cert
#@todo

= redefine WEBrick::HTTPRequest

== Instance Methods

--- parse(socket = nil)
#@todo

--- parse_uri(str, scheme = "http")
#@todo

--- meta_vars
#@todo
#@end
