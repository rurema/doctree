category Network

require webrick/compat
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
require webrick/httprequest
require webrick/httpresponse
require webrick/httpserver
require webrick/httpservlet
require webrick/httpauth

汎用HTTPサーバーフレームワークです。HTTPサーバが簡単に作れます。

WEBrick はサーブレットによって機能します。サーブレットとは
サーバの機能をオブジェクト化したものです。
ファイルを読み込んで返す・forkしてスクリプトを実行する・テンプレートを適用する 
など、「サーバが行なっている様々なこと」を抽象化しオブジェクトにしたものが
サーブレットです。サーブレットは [[c:WEBrick::HTTPServlet::AbstractServlet]] の
サブクラスのインスタンスとして実装されます。

WEBrick はセッション管理の機能を提供しません。

=== WEBrick の概要

以下は Web サーバとして完全に動作するスクリプトです。

 require 'webrick'
 srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
                                 :BindAddress => '127.0.0.1',
                                 :Port => 20080})
 srv.mount('/view.cgi', WEBrick::HTTPServlet::CGIHandler, 'view.rb')
 srv.mount('/foo.html', WEBrick::HTTPServlet::FileHandler, 'hoge.html')
 trap("INT"){ srv.shutdown }
 srv.start

ブラウザで http://127.0.0.1:20080/ にアクセスすることによって確認できます。
また http://127.0.0.1:20080/view.cgi にアクセスするとカレントディレクトリに置かれている
view.rb がCGIスクリプトとして実行されます。http://127.0.0.1:20080/foo.html にアクセスすると
カレントディレクトリ下の hoge.html の内容が表示されます。 

上のスクリプトでは以下のような流れで view.rb は実行されます。

 (1) サーバのパス /view.cgi と CGIHandler がマウントにより結びつけられます。
 (2) パス /view.cgi にアクセスがあるたびにサーバは 'view.rb' を引数として CGIHandler オブジェクトを生成します。
 (3) サーバはリクエストオブジェクトを引数として CGIHandler#service メソッドを呼びます。
 (4) CGIHandler オブジェクトは view.rb を CGI スクリプトとして実行します。

このように WEBrick では Web サーバの機能の大部分がサーブレットの形で提供されています。
またサーブレットを作成することにより新たな機能を Web サーバに追加することもできます。

= module WEBrick

ライブラリ webrick の各クラスを提供するモジュールです。

== Constants

--- VERSION

WEBrick のバージョンを表す文字列です。

 require 'webrick'
 p WEBrick::VERSION   #=> "1.3.1"

  
