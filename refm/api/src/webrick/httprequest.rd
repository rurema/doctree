#@#require timeout
#@#require uri
require webrick/httpversion
require webrick/httpstatus
require webrick/httputils
require webrick/cookie

= class WEBrick::HTTPRequest < Object

[[url:http://shogo.homelinux.org/~ysantoso/webrickguide/html/HTTPRequest.html]]

== Instance Methods

--- [](header_name)
#@todo
リクエストのヘッダの該当する内容を文字列で返す。

#@since 1.8.2
--- accept
#@todo
Accept ヘッダの内容を配列で返す。配列は品質係数(qvalue)でソートされたメディアタイプの文字列の配列。

--- accept_charset
#@todo
Accept-Charset  ヘッダの内容を配列で返す。配列は品質係数(qvalue)でソートされた文字セットの文字列の配列。

--- accept_encoding
#@todo
Accept-Encoding  ヘッダの内容を配列で返す。配列は品質係数(qvalue)でソートされたコーディングの文字列の配列。

--- accept_language
#@todo
Accept-Language  ヘッダの内容を配列で返す。配列は品質係数(qvalue)でソートされた自然言語の文字列の配列。
#@end

--- addr
#@todo
[[m:IPSocket#addr]]と同様。

--- attributes
#@todo

--- body
--- body { ... }
#@todo

#@since 1.8.2
--- content_length
#@todo
content-length を整数で返す。

--- content_type
#@todo
content-type ヘッダを文字列で返す。
#@end

--- cookies
#@todo
[[c:WEBrick::Cookie]] の配列を返す。

--- each {|key, val| ... }
#@todo
ヘッダ名を key、内容を val としてブロックを評価します。

--- fixup
#@todo

--- header
#@todo
ヘッダ名を key、内容を val とするハッシュを返す。key も val も文字列。

--- host
#@todo
host を文字列で返す。

--- http_version
#@todo
[[c:WEBrick::HTTPVersion]] オブジェクトを返す。

--- keep_alive
--- keep_alive?
#@todo
Keep-Alive かどうかを返す。

--- meta_vars
#@todo

--- parse(socket = nil)
#@todo

--- parse_uri(str, scheme = "http")
#@todo

--- path
#@todo
path を文字列で返す。

--- path_info
--- path_info=(value)
#@todo
path と同値。

--- peeraddr
#@todo
[[m:IPSocket#peeraddr]]と同様。

--- port
#@todo
サーバのポートを文字列で返す。

--- query
#@todo
ハッシュを返す。key も val も unescape されている。

--- query_string
#@since 1.8.4
--- query_string=(value)
#@todo
#@end
request_uri.query と同値。

--- raw_header
#@todo

--- request_line
#@todo
クライアントのリクエストの最初の行(GET / HTTP/1.1)を文字列で返す。

--- request_method
#@todo
クライアントのリクエストの HTTP メソッド(GET, POST,...)を文字列で返す。

--- request_time
#@todo
リクエストされた時刻を Time オブジェクトで返す。

--- request_uri
#@todo
[[c:URI]] オブジェクトを返す。

--- script_name
--- script_name=(value)
#@todo

--- to_s
#@todo

--- unparsed_uri
#@todo

--- user
--- user=(value)
#@todo

== Constants

--- BODY_CONTAINABLE_METHODS
#@todo

--- BUFSIZE
#@todo
