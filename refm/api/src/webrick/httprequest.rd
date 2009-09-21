require webrick/httpversion
require webrick/httpstatus
require webrick/httputils
require webrick/cookie

= class WEBrick::HTTPRequest < Object

HTTP リクエストのためのクラスです。

通常 WEBrick::HTTPRequest オブジェクトはサーブレットの service メソッドや do_XXX メソッドの
引数として与えられるものであり、ユーザが明示的に生成する必要はありません。

== Class Methods

--- new(config)
#@todo
WEBrick::HTTPRequest を生成して返します。

@param config 設定を保持したハッシュを指定します。

== Instance Methods

--- [](header_name)    -> String

リクエストのヘッダの該当する内容を文字列で返します。

@param header_name ヘッダー名を文字列で指定します。大文字と小文字を区別しません。

#@since 1.8.2
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

#@end

--- addr    -> Array

クライアントと接続されているソケットの [[m:IPSocket#addr]] を返します。

--- attributes    -> Hash
#@todo

--- body                 -> String | nil
--- body {|chunk| ... }  -> String | nil

クライアントからエンティティボディを読み込み返します。
リクエストにエンティティボディが含まれない場合は nil を返します。

リクエストが chunked 形式であっても返り値はデコードされて返されます。
2回目の呼び出し以降は最初に読み込んだエンティティボディを返します。
ブロックを指定された場合、クライアントからデータを読み込むたびにそのデータ(文字列)
を引数としてブロックを実行します。リクエストが chunked 形式であっても引数はデコードされています。

#@since 1.8.2
--- content_length    -> Integer

リクエストの Content-Length ヘッダの値を整数で返します。リクエストに Content-Length ヘッダ
が含まれていない場合は 0 を返します。

--- content_type    -> String | nil

リクエストの Content-Type ヘッダを文字列で返す。

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

リクエスト URI の host を文字列で返す。

--- http_version     -> WEBrick::HTTPVersion

リクエストの HTTP バージョンを表す [[c:WEBrick::HTTPVersion]] オブジェクトを返します。

--- keep_alive     -> bool
--- keep_alive?    -> bool

リクエストが Keep-Alive を要求しているかを真偽で返します。
http_version が 1.1 より小さい場合は Keep-Alive を要求していても無視して
false となります。

--- meta_vars    -> Hash
#@todo
This method provides the metavariables defined by the revision 3
of ``The WWW Common Gateway Interface Version 1.1''.
[[url:http://Web.Golux.Com/coar/cgi/]].

--- parse(socket = nil)    -> ()

指定された socket からクライアントのリクエストを読み込み、
自身のアクセサなどを適切に設定します。

@param socket クライアントに接続された IO オブジェクトを指定します。

--- path    -> String

リクエスト URI のパスを表す文字列を返します。

--- path_info          -> String
--- path_info=(value)
#@todo
リクエスト URI のパスを文字列で表すアクセサです。デフォルトは path と同じです。

@param value 

--- peeraddr    -> Array

クライアントと接続されているソケットの [[m:IPSocket#peeraddr]] を返します。

--- port    -> String
#@todo
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
#@since 1.8.4
--- query_string=(value)
#@end

リクエスト URI のクエリーを文字列で表すアクセサです。
デフォルトは request_uri.query です。

@param value クエリーを表す文字列を指定します。

--- raw_header
#@todo

--- request_line
#@todo
クライアントのリクエストの最初の行(GET / HTTP/1.1)を文字列で返す。

--- request_method     -> String
#@todo
クライアントのリクエストの HTTP メソッド(GET, POST,...)を文字列で返す。

--- request_time    -> Time
#@todo
リクエストされた時刻を [[c:Time]] オブジェクトで返す。

--- request_uri
#@todo
リクエスト URI を表す [[c:URI]] オブジェクトを返します。

--- script_name          -> String
--- script_name=(value)
#@todo

CGI での環境変数 SCRIPT_NAME を文字列で表すアクセサです。

@param value

--- to_s    -> String

リクエストのヘッダとボディをまとめて文字列として返します。

--- unparsed_uri    -> String

リクエストの URI を文字列で返します。

--- user          -> String
--- user=(value)

REMOTE_USER を文字列で表すアクセサです。

@param value ユーザ名を文字列で指定します。

#@#== Constants

#@#--- BODY_CONTAINABLE_METHODS
#@#todo

#@#--- BUFSIZE
#@#todo
