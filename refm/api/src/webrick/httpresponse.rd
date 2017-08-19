require webrick/httpversion
require webrick/htmlutils
require webrick/httputils
require webrick/httpstatus

HTTP のレスポンスを表すためのクラスを提供するライブラリです。

= class WEBrick::HTTPResponse < Object

HTTP のレスポンスを表すためのクラスです。

通常 WEBrick::HTTPResponse オブジェクトはサーブレットの service メソッドや do_XXX メソッドの
引数として与えられるものであり、ユーザが明示的に生成する必要はありません。

== Class Methods

--- new(config) -> WEBrick::HTTPResponse

HTTPResponse オブジェクトを生成して返します。

@param config 設定を保存したハッシュを指定します。:HTTPVersion は必須です。

  require 'webrick'
  res = WEBrick::HTTPResponse.new( { :HTTPVersion => "1.1" } )

== Instance Methods

--- [](field)    -> String

レスポンスのヘッダの該当する内容を文字列で返します。

@param field ヘッダ名を文字列で指定します。大文字と小文字を区別しません。

  p res['date']   #=> "Sat, 27 Oct 2007 08:53:03 GMT"

--- []=(field, val)

レスポンスの該当するヘッダに val を設定します。

@param field ヘッダ名を文字列で指定します。大文字と小文字を区別しません。

@param val ヘッダの値を指定します。to_s メソッドによって文字列に変換されます。

  require 'time'
  res['last-modified'] = Time.now.httpdate

@see [[m:WEBrick::HTTPResponse#chunked?]], [[m:WEBrick::HTTPResponse#content_length]], 
     [[m:WEBrick::HTTPResponse#content_type]]

--- body        -> String | IO
クライアントに返す内容(エンティティボディ)を返します。

自身が chunked であっても body の値はチャンク形式ではありません。

--- body=(val)

クライアントに返す内容(エンティティボディ)をセットします。

自身が chunked であっても body の値はチャンク形式ではありません。

@param val メッセージボディを文字列か [[c:IO]] オブジェクトで指定します。
           自身が chunked であってもチャンク形式にする必要はありません。
           適切にチャンク形式エンコーディングされます。

  require 'webrick'
  include WEBrick
  res = HTTPResponse.new( { :HTTPVersion => "1.1" } )
  res.body = 'hoge'
  print res.to_s

  #=> 出力結果
  HTTP/1.1 200 OK
  Connection: Keep-Alive
  Date: Sat, 27 Oct 2007 08:58:49 GMT
  Server:
  Content-Length: 4
  
  hoge

--- chunked?     -> bool
真であればクライアントに返す内容(エンティティボディ)を chunk に分けます。

--- chunked=(flag)

真に設定するとクライアントに返す内容(エンティティボディ)を chunk に分けるようになります。

自身の [[m:WEBrick::HTTPResponse#request_http_version]] が 1.0 以下である場合、この値は無視されます。

@param flag true を指定した場合、レスポンスを chunk に分けてクライアントに返します。

  require 'webrick'
  include WEBrick
  res = HTTPResponse.new( { :HTTPVersion => "1.1" } )
  res.body = 'hoge'
  res.chunked = true
  print res.to_s

  #=> 出力結果
  HTTP/1.1 200 OK
  Connection: Keep-Alive
  Date: Sat, 27 Oct 2007 09:04:28 GMT
  Server:
  Transfer-Encoding: chunked
  
  4
  hoge
  0
  
  #
--- config    -> Hash

自身が生成される時に指定されたハッシュを返します。

#@since 1.8.2
--- content_length         -> Integer | nil
--- content_length=(len)

Content-Length ヘッダの値を整数で表すアクセサです。デフォルトは nil です。

: body が String オブジェクトである場合
  content_length の値が nil のとき Content-Length ヘッダには
  body のサイズが使われます。nil でないとき body の実際のサイズとこの値が同じかどうかの検証は行われません。
: body が IO オブジェクトである場合
  content_length の値が nil のとき Content-Length ヘッダはレスポンスに含まれず、IO から全てを読み込ん
  でそれをエンティティボディとします。nil でないとき IO から content_length バイトだけ読み込みそれを
  エンティティボディとします。

また [[RFC:2616]] 4.4 で定められた Content-Length ヘッダを送ってはいけない場合に当てはまる時には
content_length の値は無視され Content-Length ヘッダはレスポンスに含まれません。

@param len ヘッダの値を整数で指定します。nil を指定することは出来ません。

  require 'webrick'
  include WEBrick
  res = HTTPResponse.new( { :HTTPVersion => "1.1" } )
  f = File.new('testfile')
  res.body = f
  res.content_length = 2
  print res.to_s
  
  #=> 出力結果
  HTTP/1.1 200 OK
  Connection: Keep-Alive
  Date: Sat, 27 Oct 2007 12:04:32 GMT
  Server:
  Content-Length: 2
  
  ho

--- content_type         -> String | nil
Content-Type ヘッダの値を返します。

--- content_type=(val)

Content-Type ヘッダの値をセットします。

@param val Content-Type ヘッダの値を文字列で指定します。

  res.content_type = "text/html"

@see [[m:WEBrick::HTTPUtils.#mime_type]]
#@end

--- cookies    -> [WEBrick::Cookie]

レスポンスの Set-Cookie ヘッダの値を表す [[c:WEBrick::Cookie]] オブジェクトの配列です。
レスポンスに新たに Cookie を加えたい場合はこの配列に [[c:WEBrick::Cookie]] オブジェクトを加えます。

  require 'webrick'
  res.cookies << WEBrick::Cookie.parse_set_cookie(k)

--- each{|key, val| ... }

レスポンスのヘッダ名を key、内容を val としてブロックを評価します。

--- filename            -> String | nil

自身の内容があるファイルのそれである場合に、そのファイル名を返します。
デフォルトは nil です。

--- filename=(file)

自身の内容があるファイルのそれである場合に、そのファイル名をセットします。
デフォルトは nil です。

@param file ファイル名を表す文字列です。

--- header     -> Hash

ヘッダ名をキー、ヘッダの値を値とするハッシュを返します。ハッシュのキーも値も文字列です。

--- http_version    -> WEBrick::HTTPVersion

レスポンスの HTTP のバージョンを表す [[c:WEBrick::HTTPVersion]] オブジェクトを返します。

  require 'webrick'
  res = WEBrick::HTTPResponse.new( { :HTTPVersion => "1.1" } )
  p res.http_version.class                                        #=> WEBrick::HTTPVersion
  p res.http_version.to_s                                         #=> "1.1"

--- keep_alive?        -> bool
--- keep_alive         -> bool

レスポンスの keep_alive が有効である場合は、真を返します。
そうでない場合は偽を返します。
デフォルトは真です。

--- keep_alive=(flag)

真をセットするとレスポンスの keep_alive が有効になります。
デフォルトは真です。

@param flag 真を指定すると Keep-Alive を有効にします。

--- reason_phrase         -> String | nil
HTTP のレスポンスの最初の行の reason phrase を返します。
この値が nil の場合 reason phrase は status から生成されます。
デフォルトは nil です。

--- reason_phrase=(val)

HTTP のレスポンスの最初の行の reason phrase をセットします。
この値が nil の場合 reason phrase は status から生成されます。
デフォルトは nil です。

@param val reason phrase を表す文字列を指定します。

  require 'webrick'
  res = WEBrick::HTTPResponse.new( { :HTTPVersion => "1.1" } )
  res.status = 404
  
  p res.reason_phrase    #=> "Not Found"

--- request_http_version           -> WEBrick::HTTPVersion
リクエストの HTTP バージョンを返します。
デフォルトでは自身の [[m:WEBrick::HTTPResponse#http_version]] が使われます。

--- request_http_version=(ver)

リクエストの HTTP バージョンをセットします。

@param ver リクエストの HTTP バージョンを [[c:WEBrick::HTTPVersion]] オブジェクトで指定します。

--- request_method          -> String | nil
リクエストの HTTP メソッドを返します。

--- request_method=(method)

リクエストの HTTP メソッドをセットします。
デフォルトは nil です。

@param method リクエストの HTTP メソッドを文字列で指定します。

--- request_uri        -> URI | nil
リクエストの URI を返します。

--- request_uri=(uri)

リクエストの URI をセットします。
デフォルトは nil です。

@param uri リクエストの URI を [[c:URI]] オブジェクトで指定します。

--- sent_size    -> Integer

クライアントに送られた内容(エンティティボディ)のバイト数を表す整数を返します。

--- set_error(status, backtrace = false)    -> ()

自身の内容(エンティティボディ)を指定された status のエラーページにします。

@param status [[c:WEBrick::HTTPStatus::Status]] のサブクラスか一般の例外クラスを指定します。

@param backtrace true を指定した場合バックトレースをエラーページに出力します。

--- set_redirect(status, url)    -> ()

指定された url にリダイレクトするためのヘッダと内容(エンティティボディ)を
設定し例外 status を発生させます。

@param status [[c:WEBrick::HTTPStatus::Redirect]] を指定します。

@param url URL を指定します。

例:
  require 'webrick'
  res.set_redirect WEBrick::HTTPStatus::TemporaryRedirect

--- status           -> Integer

レスポンスのステータスコードを表す整数を返します。
デフォルトは [[m:WEBrick::HTTPStatus::RC_OK]] です。

--- status=(status)

レスポンスのステータスコードを整数で指定します。
reason_phrase も適切なものに設定されます。

@param status ステータスコードを整数で指定します。

  require 'webrick'
  res = WEBrick::HTTPResponse.new( { :HTTPVersion => "1.1" } )
  res.status = 404
  
  p res.reason_phrase    #=> "Not Found"

--- status_line    -> String

HTTP のステータスラインを CR+LF 付き文字列で返します。

  require 'webrick'
  res = WEBrick::HTTPResponse.new( { :HTTPVersion => "1.1" } )
  res.status = 404
  
  p res.status_line    #=>  "HTTP/1.1 404 Not Found \r\n"

--- to_s    -> String

実際にクライアントに送られるデータを文字列として返します。

  require 'webrick'
  include WEBrick
  res = HTTPResponse.new( { :HTTPVersion => "1.1" } )
  res.body = 'hoge'
  print res.to_s

  #=> 出力結果
  HTTP/1.1 200 OK
  Connection: Keep-Alive
  Date: Sat, 27 Oct 2007 08:58:49 GMT
  Server:
  Content-Length: 4
  
  hoge
