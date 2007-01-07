require webrick/httpservlet/abstract
require webrick/httpservlet/filehandler
require webrick/httpservlet/cgihandler
require webrick/httpservlet/erbhandler
require webrick/httpservlet/prochandler

このファイルを require すると、
[[c:WEBrick::HTTPServlet::FileHandler]] に対して
拡張子 .cgi と .rhtml のためのハンドラを設定します。

[[lib:webrick]] や [[lib:webrick/httpserver]] を require すると
このライブラリも一緒に require されます。
