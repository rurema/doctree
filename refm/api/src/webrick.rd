require webrick/compat
require webrick/version
require webrick/config
require webrick/log
require webrick/server
require webrick/utils
require webrick/accesslog
require webrick/htmlutils
require webrick/httputils
require webrick/cookie
require webrick/httpversion
require webrick/httpstatus
require webrick/htprequest
require webrick/httpresponse
require webrick/httpserver
require webrick/httpservlet
require webrick/httpauth

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
