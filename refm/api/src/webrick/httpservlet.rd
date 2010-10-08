require webrick/httpservlet/abstract
require webrick/httpservlet/filehandler
require webrick/httpservlet/cgihandler
require webrick/httpservlet/erbhandler
require webrick/httpservlet/prochandler

このファイルを [[m:Kernel.#require]] すると、
[[c:WEBrick::HTTPServlet::FileHandler]] に対して
拡張子 .cgi と .rhtml のためのハンドラを設定します。

[[lib:webrick]] や [[lib:webrick/httpserver]] を [[m:Kernel.#require]] すると
このライブラリも一緒に [[m:Kernel.#require]] されます。
