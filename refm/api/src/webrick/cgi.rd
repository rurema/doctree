#@since 1.8.1
require webrick/httprequest
require webrick/httpresponse
require webrick/config

一般の CGI 環境で [[c:WEBrick]] のサーブレットと同じように CGI スクリプトを書くための
ライブラリです。サーバが WEBrick でなくても使うことが出来ます。

サーブレットを作成するのと同じように、[[c:WEBrick::CGI]] のサブクラスでメソッド
do_GET や do_POST を定義することによって CGI スクリプトを書きます。

[[m:WEBrick::CGI#start]] を最後に必ず呼びます。
WEBrick::CGI#start メソッドは service メソッドを呼び出し、service メソッドはリクエストに応じて
do_XXX メソッドを呼び出します。このようにして CGI スクリプトは実行されます。

例:

 #!/usr/local/bin/ruby
 require 'webrick/cgi'

 class MyCGI < WEBrick::CGI
   def do_GET(req, res)
     res["content-type"] = "text/plain"
     ret = "hoge\n"
     res.body = ret
   end
 end
 
 MyCGI.new.start()

=== リンク

 * [[rfc:3875]]

= class WEBrick::CGI < Object

一般の CGI 環境で [[c:WEBrick]] のサーブレットと同じように CGI スクリプトを書くための
クラスです。

== Class Methods

--- new(config={}, *options)    -> WEBrick::CGI
#@todo

CGI オブジェクトを生成してかえします。

@param config 設定を保存したハッシュを指定します。

config で有効なキーとその値は以下のとおりです。

: :ServerName     
 サーバ名を文字列で指定します。
: :HTTPVersion
 HTTP バージョンを [[c:WEBrick::HTTPVersion]] オブジェクトで指定します。
: :RunOnCGI
 CGI スクリプトとして実行されているかを判定するために使われます。
: :NPH            
 NPH スクリプトとして実行される場合に true を設定します。

== Instance Methods

#@since 1.8.3
--- [](key)    -> object

指定された key に対応した自身の設定値を返します。

@param key 設定名を Symbol オブジェクトで指定します。

#@end

#@since 1.8.3
--- config     -> Hash

自身の設定を保持したハッシュを返します。

@see [[m:WEBrick::CGI.new]]
#@end

#@since 1.8.3
--- logger     -> WEBrick::Log

設定されているログオブジェクトを返します。

デフォルトでは WEBrick::BasicLog.new($stderr) です。
#@end

--- do_GET(req, res)        -> ()
--- do_HEAD(req, res)       -> ()
--- do_POST(req, res)       -> ()
--- do_PUT(req, res)        -> ()
--- do_DELETE(req, res)     -> ()
--- do_OPTIONS(req, res)    -> ()

自身の service メソッドから HTTP のリクエストに応じて
呼ばれるメソッドです。WEBrick::CGI のサブクラスはこれらのメソッドを適切に実装し
なければいけません。返り値は特に規定されていません。

クライアントが使う可能性のある RFC で定義された HTTP のメソッドはすべて実装する必要があります。
クライアントからのリクエストに使われないと分かっているメソッドは実装しなくてもかまいません。
実装されていない HTTP メソッドであった場合、自身の service メソッドが
例外を発生させます。

--- service(req, res)     -> ()

指定された [[c:WEBrick::HTTPRequest]] オブジェクト req の [[m:WEBrick::HTTPRequest#request_method]] に応じて、
自身の do_GET, do_HEAD, do_POST, do_OPTIONS... いずれかのメソッドを req と res を引数として呼びます。

特に理由が無い限り WEBrick::CGI のサブクラスがこのメソッドを定義する必要はありません。

@param req クライアントからのリクエストを表す [[m:WEBrick::HTTPRequest]] オブジェクトです。

@param res クライアントへのレスポンスを表す [[m:WEBrick::HTTPResponse]] オブジェクトです。

@raise WEBrick::HTTPStatus::MethodNotAllowed
       指定された [[c:WEBrick::HTTPRequest]] オブジェクト  req が自身に定義されていない
       HTTP のメソッドであった場合発生します。

--- start(env = ENV, stdin = $stdin, stdout = $stdout)     -> ()

自身に定義されたサービスを実行します。

start メソッドは service メソッドを呼び出し、service メソッドはリクエストに応じて
do_XXX メソッドを呼び出します。このようにして CGI スクリプトは実行されます。

@param env CGI スクリプトが受け取った Meta-Variables (環境変数)を保持したハッシュか、
           それと同じ [] メソッドを持ったオブジェクトを指定します。

@param stdin リクエストデータの入力元を [[c:IO]] オブジェクトで指定します。

@param stdout レスポンスデータの出力先を [[c:IO]] オブジェクトで指定します。

= class WEBrick::CGI::CGIError < StandardError

#@end
