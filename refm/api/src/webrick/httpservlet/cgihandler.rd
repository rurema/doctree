require webrick/config
require webrick/httpservlet/abstract

CGI を扱うためのサーブレットを提供するライブラリです。

= class WEBrick::HTTPServlet::CGIHandler < WEBrick::HTTPServlet::AbstractServlet

CGI を扱うためのサーブレットです。

== Class Methods

--- new(server, name) -> WEBrick::HTTPServlet::CGIHandler

自身を初期化します。

@param server [[c:WEBrick::GenericServer]] のサブクラスのインスタンスを
              指定します。

@param name 実行したい CGI のファイルを文字列で与えます。


== Instance Methods

--- do_GET(request, response) -> ()
--- do_POST(request, response) -> ()

GET, POST リクエストを処理します。

@param request [[c:WEBrick::HTTPRequest]] のインスタンスを指定します。

@param response [[c:WEBrick::HTTPResponse]] のインスタンスを指定します。

== Constants

--- Ruby -> String

Ruby のパスを返します。

--- CGIRunner -> String

CGI を実行するためのコマンドを返します。
