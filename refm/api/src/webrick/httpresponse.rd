#@#require time
require webrick/httpversion
require webrick/htmlutils
require webrick/httputils
require webrick/httpstatus

= class WEBrick::HTTPResponse < Object

== Class Methods

--- new(config)
HTTPResponse オブジェクトを生成する。config には設定を保存したハッシュを与える。

== Instance Methods

--- [](field)
レスポンスのヘッダの該当する内容を文字列で返す。

--- []=(field, val)
レスポンスの該当するヘッダに val を設定する。val は文字列。

--- body
--- body=(val)
クライアントに返す内容を設定する。val は文字列。

--- chunked?
--- chunked=()
レスポンスを chunk に分けてクライアントに返すかどうかを設定する。

--- config

--- content_length
--- content_length=(len)

--- content_type
--- content_type=(val)
content-type ヘッダを設定する。val は文字列。

--- cookies
[[c:WEBrick::Cookie]] の配列を返す。

--- each{|key, val| ... }
ヘッダ名を key、内容を val としてブロックを評価します。

--- filename
--- filename=(filename)

--- header
ヘッダ名を key、内容を val とするハッシュを返す。key も val も文字列。

--- http_version
HTTP のバージョンを [[c:WEBrick::HTTPVersion]] オブジェクトで返す。

--- keep_alive?
--- keep_alive
--- keep_alive=()
keep_alive をオンにするかどうかを設定する。

--- reason_phrase
--- reason_phrase=(val)
HTTP のレスポンスの最初の行の reason phrase を設定する。val は文字列。

--- request_http_version
--- request_http_version=(version)

--- request_method
--- request_method=(method)

--- request_uri
--- request_uri=(uri)

--- send_body(socket)

--- send_header(socket)

--- send_response(socket)

--- sent_size

--- set_error(ex, backtrace = false)

--- set_redirect(status, url)

--- setup_header

--- status
--- status=(status)
status コードを整数で返す。

--- status_line

--- to_s
