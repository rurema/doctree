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

#@include(webrick/GenericServer)
#@include(webrick/HTTPServer)
#@include(webrick/HTTPProxyServer)
#@include(webrick/HTTPResponse)
#@include(webrick/HTTPRequest)
#@#include(webrick/HTTPStatus)
#@include(webrick/HTTPAuth)
#@include(webrick/HTTPAuth__BasicAuth)
#@include(webrick/HTTPAuth__DigestAuth)
#@include(webrick/HTTPAuth__Htpasswd)
#@include(webrick/HTTPAuth__Htdigest)
#@include(webrick/HTTPAuth__Htgroup)
#@#  * WEBrick::HTTPUtils
#@#  * WEBrick::HTTPUtils::FormData
#@include(webrick/HTTPVersion)
#@include(webrick/Cookie)
#@include(webrick/Log)
#@#  * WEBrick::AccessLog
#@#* WEBrick::HTTPServlet
#@include(webrick/HTTPServlet__AbstractServlet)
#@include(webrick/HTTPServlet__FileHandler)
#@include(webrick/HTTPServlet__CGIHandler)
#@include(webrick/HTTPServlet__ProcHandler)
#@#    * WEBrick::HTTPServlet::ERBHandler
