require webrick/httpversion
require webrick/htmlutils
require webrick/httputils
require webrick/httpstatus

= class WEBrick::HTTPResponse < Object

HTTP のレスポンスを表すためのクラスです。

== Class Methods

--- new(config)
#@todo
HTTPResponse オブジェクトを生成する。config には設定を保存したハッシュを
与えます。:HTTPVersion は必須です。

== Instance Methods

--- [](field)    -> String
#@todo
レスポンスのヘッダの該当する内容を文字列で返します。

@param field ヘッダ名を文字列で指定します。大文字と小文字を区別しません。

--- []=(field, val)
#@todo
レスポンスの該当するヘッダに val を設定する。val は文字列。

@param field ヘッダ名を文字列で指定します。大文字と小文字を区別しません。

@param val ヘッダの値を指定します。to_s メソッドによって文字列に変換されます。

@see [[m:WEBrick::HTTPResponse#chunked?]], [[m:WEBrick::HTTPResponse#content_length]], 
     [[m:WEBrick::HTTPResponse#content_type]]

--- body        -> String | IO
--- body=(val)

クライアントに返す内容(エンティティボディ)を表すアクセサです。

自身が chunked であっても body の値はチャンク形式ではありません。

@param val メッセージボディを文字列か [[c:IO]] オブジェクトで指定します。
           自身が chunked であってもチャンク形式にする必要はありません。
           適切にチャンク形式エンコーディングされます。

--- chunked?     -> bool
--- chunked=(flag)

クライアントに返す内容(エンティティボディ)を chunk に分けてクライアントに
返すかどうかを真偽で表すアクセサです。

自身の [[m:WEBrick::HTTPResponse#request_http_version]] が 1.0 以下である場合、この値は無視されます。

@param flag true を指定した場合、レスポンスを chunk に分けてクライアントに返します。

--- config    -> Hash

自身が生成される時に指定されたハッシュを返します。

#@since 1.8.2
--- content_length         -> Intger | nil
--- content_length=(len)
#@todo

Content-Length ヘッダの値を整数で表すアクセサです。デフォルトは nil です。

: body が String オブジェクトである場合
  content_length の値が nil のとき Content-Length ヘッダには
  body のサイズが使われます。nil でないとき body の実際のサイズとこの値が同じかどうかの検証は行われません。
: body が IO オブジェクトである場合
  content_length の値が nil のとき Content-Length ヘッダはレスポンスに含まれず、IO から全てを読み込ん
  でそれをエンティティボディとします。nil でないとき IO から content_length バイトだけ読み込みそれを
  エンティティボディとします。

また RFC2616 4.4 で定められた Content-Length ヘッダを送ってはいけない場合に当てはまる時には
content_length の値は無視され Content-Length ヘッダはレスポンスに含まれません。

@param len ヘッダの値を整数で指定します。nil を指定することは出来ません。

--- content_type         -> String | nil
--- content_type=(val)
#@todo
Content-Type ヘッダの値を文字列で表すアクセサです。

@param val Content-Type ヘッダの値を文字列で指定します。
#@end

--- cookies    -> [WEBrick::Cookie]

自身が保持する [[c:WEBrick::Cookie]] を表す配列です。

  res.cookies << Cookie.parse_set_cookie(k)

--- each{|key, val| ... }

レスポンスのヘッダ名を key、内容を val としてブロックを評価します。

--- filename            -> String | nil
--- filename=(file)

自身の内容があるファイルのそれである場合に、そのファイル名を文字列で表すアクセサです。
デフォルトは nil です。

@param file ファイル名を表す文字列です。

--- header     -> Hash

ヘッダ名をキー、ヘッダの値を値とするハッシュを返します。ハッシュのキーも値も文字列です。

--- http_version    -> WEBrick::HTTPVersion

レスポンスの HTTP のバージョンを表す [[c:WEBrick::HTTPVersion]] オブジェクトを返します。

--- keep_alive?        -> bool
--- keep_alive         -> bool
--- keep_alive=(flag)

レスポンスの keep_alive が有効であるかを表す真偽です。
デフォルトは false です。

@param flag true を指定すると Keep-Alive を有効にします。

--- reason_phrase         -> String | nil
--- reason_phrase=(val)
#@todo
HTTP のレスポンスの最初の行の reason phrase を文字列で表すアクセサです。
この値が nil の場合 reason phrase は status から生成されます。
デフォルトは nil です。

@param val reason phrase を表す文字列を指定します。

--- request_http_version           -> WEBrick::HTTPVersion
--- request_http_version=(ver)

リクエストの HTTP バージョンを [[c:WEBrick::HTTPVersion]] オブジェクトで表すアクセサです。
デフォルトでは自身の [[m:WEBrick::HTTPResponse#http_version]] が使われます。

@param ver リクエストの HTTP バージョンを [[c:WEBrick::HTTPVersion]] オブジェクトで指定します。

--- request_method          -> String | nil
--- request_method=(method)

リクエストの HTTP メソッドを文字列で表すアクセサです。
デフォルトは nil です。

@param method リクエストの HTTP メソッドを文字列で指定します。

--- request_uri        -> URI | nil
--- request_uri=(uri)

リクエストの URI を [[c:URI]] オブジェクトで表すアクセサです。
デフォルトは nil です。

@param method リクエストの URI を [[c:URI]] オブジェクトで指定します。

--- sent_size    -> Intger

クライアントに送られた内容(エンティティボディ)のバイト数を表す整数を返します。

--- set_error(ex, backtrace = false)
#@todo

--- set_redirect(status, url)
#@todo

指定された url にリダイレクトするためのヘッダと内容(エンティティボディ)を設定し例外 status を
発生させます。

--- status           -> Intger

レスポンスのステータスコードを表す整数を返します。
デフォルトは [[m:WEBrick::HTTPStatus::RC_OK]] です。

--- status=(status)

レスポンスのステータスコードを整数で指定します。
reason_phrase も適切なものに設定します。

@param status ステータスコードを整数で指定します。

--- status_line    -> String

HTTP のステータスラインを文字列で返します。

--- to_s    -> String
#@todo
実際にクライアントに送られるデータを文字列として返します。
