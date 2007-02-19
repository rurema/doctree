require webrick/httpservlet/abstract

= class WEBrick::HTTPServlet::ProcHandler < WEBrick::HTTPServlet::AbstractServlet

[[c:Proc]] を扱うためのサーブレット。

[[m:WEBrick::HTTPServer#mount]] に引数として与えることは
出来ない。[[m:WEBrick::HTTPServer#mount_proc]]を使う。

== Class Methods

--- new(proc)
#@todo
proc には呼び出したい [[c:Proc]] オブジェクトを与える。proc はクライアントからの
リクエストがあった時、proc.call(request, response) のように呼び出される。
[[c:WEBrick::HTTPResponse]] オブジェクトと [[c:WEBrick::HTTPRequest]] オブジェクト。

== Instance Methods

--- get_instance(server, *options)
#@todo

--- do_GET(req, res)
--- do_POST(req, res)
#@todo
