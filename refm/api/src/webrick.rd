汎用HTTPサーバーフレームワーク。HTTPサーバが簡単に作れます。

WEBrick はサーブレットによって機能します。サーブレットとは何か。クライアントがアクセスしてきた時にHTTPサーバが実際に行なうことは ファイルを読み込んで返す・forkしてスクリプトを実行する・テンプレートを適用する など様々です。この「サーバが行なっている様々なこと」を抽象化したのがサーブレットです。

サーブレットはRubyのオブジェクトとして実装されます。
具体的には [[c:WEBrick::HTTPServlet::AbstractServlet]] の
サブクラスのインスタンスです。

WEBrick はセッション管理の機能を提供しません。

 * [[url:http://www.webrick.org/]]
 * [[url:http://shogo.homelinux.org/~ysantoso/WebWiki/WEBrick.html]]
 * [[url:http://pub.cozmixng.org/~the-rwiki/rw-cgi.rb?cmd=view;name=WEBrick]]
 * Rubyist Magazine http://jp.rubyist.net/magazine/
   * WEBrickでプロキシサーバを作って遊ぶ http://jp.rubyist.net/magazine/?0002-WEBrickProxy
 * [[lib:webrick/ssl]]
 * [[lib:webrick/cgi]]

= module WEBrick

== Constants

--- CR

--- CRLF

--- LF

--- VERSION

#@# webrick/compat.rb

#@# webrick/version.rb

#@# webrick/config.rb
#@include(webrick/Config)

#@# webrick/log.rb
#@include(webrick/BasicLog)
#@include(webrick/Log)

#@# webrick/server.rb
#@#include(webrick/ServerError)
#@#include(webrick/SimpleServer)
#@include(webrick/Daemon)
#@include(webrick/GenericServer)

#@# webrick/utils.rb
#@#include(webrick/Utils)

#@# webrick/accesslog.rb
#@include(webrick/AccessLog)

#@# webrick/htmlutils.rb
#@include(webrick/HTMLUtils)

#@# webrick/httputils.rb
#@#include(webrick/HTTPUtils)
#@#include(webrick/HTTPUtils__FormData)

#@# webrick/cookie.rb
#@include(webrick/Cookie)

#@# webrick/httpversion.rb
#@include(webrick/HTTPVersion)

#@# webrick/httpstatus.rb
#@#include(webrick/HTTPStatus)

#@# webrick/htprequest.rb
#@include(webrick/HTTPRequest)

#@# webrick/httpresponse.rb
#@include(webrick/HTTPResponse)

#@# webrick/httpserver.rb
#@#include(webrick/HTTPServerError)
#@include(webrick/HTTPServer)
#@#include(webrick/HTTPServer__MountTable)

#@# webrick/httpservlet.rb
#@include(webrick/httpservlet.rd)
#@#include(WEBrick::HTTPServlet)
#@include(webrick/HTTPServlet__AbstractServlet)
#@include(webrick/HTTPServlet__CGIHandler)
#@include(webrick/HTTPServlet__DefaultFileHandler)
#@include(webrick/HTTPServlet__ERBHandler)
#@include(webrick/HTTPServlet__FileHandler)
#@#include(webrick/HTTPServlet__HTTPServletError)
#@include(webrick/HTTPServlet__ProcHandler)

#@# webrick/httpauth.rb
#@include(webrick/HTTPAuth)
#@include(webrick/HTTPAuth__Authenticator)
#@#include(webrick/HTTPAuth__ProxyAuthenticator)
#@include(webrick/HTTPAuth__BasicAuth)
#@#include(webrick/HTTPAuth__ProxyBasicAuth)
#@include(webrick/HTTPAuth__DigestAuth)
#@#include(webrick/HTTPAuth__ProxyDigestAuth)
#@include(webrick/HTTPAuth__Htpasswd)
#@include(webrick/HTTPAuth__Htdigest)
#@include(webrick/HTTPAuth__Htgroup)
#@include(webrick/HTTPAuth__UserDB)

#@# webrick/httpproxy.rb
#@#include(webrick/httpproxy.rd)
#@include(webrick/NullReader)
#@include(webrick/HTTPProxyServer)

#@# webrick/https.rb
#@include(webrick/https.rd)

#@# webrick/httpservlet/cgi_runner.rb
