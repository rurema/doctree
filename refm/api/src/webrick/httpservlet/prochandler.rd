require webrick/httpservlet/abstract

[[c:Proc]] を扱うためのサーブレットを提供するライブラリです。

= class WEBrick::HTTPServlet::ProcHandler < WEBrick::HTTPServlet::AbstractServlet

[[c:Proc]] を扱うためのサーブレット。

[[m:WEBrick::HTTPServer#mount]] に引数として与えることは出来ません。
[[m:WEBrick::HTTPServer#mount_proc]]を使ってください。

== Class Methods

--- new(proc) -> WEBrick::HTTPServlet::ProcHandler

自身を初期化します。

@param proc [[c:Proc]] オブジェクトを与えます。クライアントからのリクエストがあった時、
            proc.call(request, response) のように呼び出されます。
            request, response はそれぞれ [[c:WEBrick::HTTPRequest]] オブジェクトと
            [[c:WEBrick::HTTPResponse]] オブジェクトです。

== Instance Methods

--- get_instance(server, *options) -> self

何もせずに自身を返します。

@param server [[m:WEBrick::HTTPServer#mount]] 第3引数以降に指定された値がそのまま与えられます。

@param options [[m:WEBrick::HTTPServer#mount]] 第3引数以降に指定された値がそのまま与えられます。

@see [[m:WEBrick::HTTPServlet::AbstractServlet.get_instance]]

--- do_GET(request, response) -> ()
--- do_POST(request, response) -> ()

GET, POST リクエストを処理します。

@param request クライアントからのリクエストを表す [[c:WEBrick::HTTPRequest]] オブジェクトです。

@param response クライアントへのレスポンスを表す [[c:WEBrick::HTTPResponse]] オブジェクトです。

