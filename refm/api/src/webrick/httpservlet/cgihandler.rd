#@#require rbconfig
#@#require tempfile
require webrick/config
require webrick/httpservlet/abstract

= class WEBrick::HTTPServlet::CGIHandler < WEBrick::HTTPServlet::AbstractServlet

CGI を扱うためのサーブレット。

== Class Methods

--- new(server, name)
name は実行したいローカルの CGI ファイルを文字列で与える。

== Instance Methods

--- do_GET(req, res)
--- do_POST(req, res)

== Constants

--- Ruby

--- CGIRunner
