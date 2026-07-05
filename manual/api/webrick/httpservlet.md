---
type: library
require:
  - webrick/httpservlet/abstract
  - webrick/httpservlet/filehandler
  - webrick/httpservlet/cgihandler
  - webrick/httpservlet/erbhandler
  - webrick/httpservlet/prochandler
---
このファイルを [m:Kernel?.require] すると、
[c:WEBrick::HTTPServlet::FileHandler] に対して
拡張子 .cgi と .rhtml のためのハンドラを設定します。

[lib:webrick] や [lib:webrick/httpserver] を [m:Kernel?.require] すると
このライブラリも一緒に [m:Kernel?.require] されます。
