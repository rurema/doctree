#@#require time
require webrick/httpversion
require webrick/htmlutils
require webrick/httputils
require webrick/httpstatus

= class WEBrick::HTTPResponse < Object

== Class Methods

--- new(config)
#@todo
HTTPResponse オブジェクトを生成する。config には設定を保存したハッシュを与える。

== Instance Methods

--- [](field)
#@todo
レスポンスのヘッダの該当する内容を文字列で返す。

--- []=(field, val)
#@todo
レスポンスの該当するヘッダに val を設定する。val は文字列。

--- body
--- body=(val)
#@todo
クライアントに返す内容を設定する。val は文字列。

--- chunked?
--- chunked=()
#@todo
レスポンスを chunk に分けてクライアントに返すかどうかを設定する。

--- config
#@todo

--- content_length
--- content_length=(len)
#@todo

--- content_type
--- content_type=(val)
#@todo
content-type ヘッダを設定する。val は文字列。

--- cookies
#@todo
[[c:WEBrick::Cookie]] の配列を返す。

--- each{|key, val| ... }
#@todo
ヘッダ名を key、内容を val としてブロックを評価します。

--- filename
--- filename=(filename)
#@todo

--- header
#@todo
ヘッダ名を key、内容を val とするハッシュを返す。key も val も文字列。

--- http_version
#@todo
HTTP のバージョンを [[c:WEBrick::HTTPVersion]] オブジェクトで返す。

--- keep_alive?
--- keep_alive
--- keep_alive=()
#@todo
keep_alive をオンにするかどうかを設定する。

--- reason_phrase
--- reason_phrase=(val)
#@todo
HTTP のレスポンスの最初の行の reason phrase を設定する。val は文字列。

--- request_http_version
--- request_http_version=(version)
#@todo

--- request_method
--- request_method=(method)
#@todo

--- request_uri
--- request_uri=(uri)
#@todo

--- send_body(socket)
#@todo

--- send_header(socket)
#@todo

--- send_response(socket)
#@todo

--- sent_size
#@todo

--- set_error(ex, backtrace = false)
#@todo

--- set_redirect(status, url)
#@todo

--- setup_header
#@todo

--- status
--- status=(status)
#@todo
status コードを整数で返す。

--- status_line
#@todo

--- to_s
#@todo
