require webrick/httpversion
require webrick/httpstatus
require webrick/httputils
require webrick/cookie

HTTP リクエストのためのクラスを提供するライブラリです。

= class WEBrick::HTTPRequest < Object

HTTP リクエストのためのクラスです。

通常 WEBrick::HTTPRequest オブジェクトはサーブレットの service メソッドや do_XXX メソッドの
引数として与えられるものであり、ユーザが明示的に生成する必要はありません。

== Class Methods

--- new(config) -> WEBrick::HTTPRequest

WEBrick::HTTPRequest を生成して返します。

@param config 設定を保持したハッシュを指定します。

== Instance Methods

--- [](header_name)    -> String

リクエストのヘッダの該当する内容を文字列で返します。

@param header_name ヘッダー名を文字列で指定します。大文字と小文字を区別しません。

--- accept    -> [String]

Accept ヘッダの内容をメディアタイプを表す文字列の配列で返します。
配列は品質係数(qvalue)でソートされています。

--- accept_charset    -> [String]

Accept-Charset  ヘッダの内容を文字セットを表す文字列の配列で返します。
配列は品質係数(qvalue)でソートされています。

--- accept_encoding    -> [String]

Accept-Encoding  ヘッダの内容をコーディングを表す文字列の配列で返します。
配列は品質係数(qvalue)でソートされています。

--- accept_language    -> [String]

Accept-Language  ヘッダの内容を自然言語を表す文字列の配列で返します。
配列は品質係数(qvalue)でソートされています。


--- addr    -> Array

クライアントと接続されているソケットの [[m:IPSocket#addr]] を返します。

--- attributes    -> Hash
#@todo ???

--- body                 -> String | nil
--- body {|chunk| ... }  -> String | nil

クライアントからエンティティボディを読み込み返します。
リクエストにエンティティボディが含まれない場合は nil を返します。

リクエストが chunked 形式であっても返り値はデコードされて返されます。
2回目の呼び出し以降は最初に読み込んだエンティティボディを返します。
ブロックを指定された場合、クライアントからデータを読み込むたびにそのデータ(文字列)
を引数としてブロックを実行します。リクエストが chunked 形式であっても引数はデコードされています。

--- content_length    -> Integer

リクエストの Content-Length ヘッダの値を整数で返します。リクエストに Content-Length ヘッダ
が含まれていない場合は 0 を返します。

--- content_type    -> String | nil

リクエストの Content-Type ヘッダを文字列で返します。


#@since 1.9.3
--- continue
#@todo 1.9.3
Generate HTTP/1.1 100 continue response if the client expects it,
otherwise does nothing.
#@end

--- cookies    -> [WEBrick::Cookie]

リクエストに含まれる Cookie ヘッダの値を [[c:WEBrick::Cookie]] の配列として返します。

--- each {|key, val| ... }

リクエストの各ヘッダ名を key、内容を val としてブロックを評価します。

--- fixup    -> ()

リクエストの残りのエンティティボディを読み込みます。

--- header    -> Hash

ヘッダ名をキー、内容をその値とするハッシュを返します。キーも値も文字列です。

--- host    -> String

リクエスト URI の host を文字列で返します。

--- http_version     -> WEBrick::HTTPVersion

リクエストの HTTP バージョンを表す [[c:WEBrick::HTTPVersion]] オブジェクトを返します。

--- keep_alive     -> bool
--- keep_alive?    -> bool

リクエストが Keep-Alive を要求しているかを真偽で返します。
http_version が 1.1 より小さい場合は Keep-Alive を要求していても無視して
false となります。

--- meta_vars    -> Hash

メタ変数を返します。

メタ変数は「The WWW Common Gateway Interface Version 1.1」のバージョン
3 で定義されています。

@see [[url:http://Web.Golux.Com/coar/cgi/]]

--- parse(socket = nil)    -> ()

指定された socket からクライアントのリクエストを読み込み、
自身のアクセサなどを適切に設定します。

@param socket クライアントに接続された IO オブジェクトを指定します。

--- path    -> String

リクエスト URI のパスを表す文字列を返します。

--- path_info          -> String

リクエスト URI のパスを文字列で返します。デフォルトは path と同じです。

--- path_info=(value)

リクエスト URI のパスをセットします。

@param value リクエスト URI のパスを指定します。

--- peeraddr    -> Array

クライアントと接続されているソケットの [[m:IPSocket#peeraddr]] を返します。

--- port    -> String

サーバのポートを文字列で返します。

--- query    -> Hash

リクエストのクエリーあるいはクライアントがフォームへ入力した値を表すハッシュを返します。

ハッシュのキーも値も unescape されています。ただし multipart/form-data なフォームデータの場合には
ユーザが content-transfer-encoding ヘッダを見て適切に処理する必要があります。

ハッシュの値は正確には文字列ではなく String クラスのサブクラスである [[c:WEBrick::HTTPUtils::FormData]]
クラスのインスタンスです。

multipart/form-data なフォームデータであってもサイズの制限なく、通常のフォームデータと
同じように扱われることに注意してください。クライアントからの入力によっては巨大な文字列が
生成されてしまいます。

例:

  h = req.query
  p h['q']                       #=>  "ruby rails session"  
  p h['upfile']['content-type']  #=>  "plain/text"
  p h['upfile'].filename         #=>  "my_file.txt"
  p h['upfile']                  #=>  "hoge hoge hoge"

--- query_string          -> String

リクエスト URI のクエリーを文字列で表すアクセサです。
デフォルトは request_uri.query です。

--- query_string=(value)

リクエスト URI のクエリーを文字列で表すアクセサです。
デフォルトは request_uri.query です。

@param value クエリーを表す文字列を指定します。

--- raw_header -> String
生のヘッダを返します。

--- request_line -> String

クライアントのリクエストの最初の行(GET / HTTP/1.1)を文字列で返します。

--- request_method     -> String

クライアントのリクエストの HTTP メソッド(GET, POST,...)を文字列で返します。

--- request_time    -> Time

リクエストされた時刻を [[c:Time]] オブジェクトで返します。

--- request_uri -> URI

リクエスト URI を表す [[c:URI]] オブジェクトを返します。

--- script_name          -> String

CGI での環境変数 SCRIPT_NAME を文字列で表すアクセサです。

--- script_name=(value)

CGI での環境変数 SCRIPT_NAME を文字列で表すアクセサです。

@param value SCRIPT_NAME を文字列で指定します。

#@since 1.9.1
--- server_name -> String

サーバの名前を返します。

--- ssl? -> bool

リクエスト URI のスキームが https であれば真を返します。
そうでない場合は偽を返します。

#@end

--- to_s    -> String

リクエストのヘッダとボディをまとめて文字列として返します。

--- unparsed_uri    -> String

リクエストの URI を文字列で返します。

--- user          -> String

REMOTE_USER を文字列として返します。

--- user=(value)

REMOTE_USER を文字列で表したものに値をセットします。

@param value ユーザ名を文字列で指定します。

#@#== Constants

#@#--- BODY_CONTAINABLE_METHODS
#@#todo

#@#--- BUFSIZE
#@#todo
