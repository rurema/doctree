require rubygems/command
require rubygems/server

ローカルにインストールされている Gem パッケージとそのドキュメントを HTTP サーバに
載せて公開するためのライブラリです。

  Usage: gem server [options]
    Options:
      -p, --port=PORT                  port to listen on
      -d, --dir=GEMDIR                 directory from which to serve gems
          --[no-]daemon                run as a daemon
#@include(common_options)
    Summary:
      Documentation and gem repository HTTP server
    Description:
      The server command starts up a web server that hosts the RDoc for your
      installed gems and can operate as a server for installation of gems on other
      machines.
      
      The cache files for installed gems must exist to use the server as a source
      for gem installation.
      
      To install gems from a running server, use `gem install GEMNAME --source
      http://gem_server_host:8808`
    Defaults:
      --port 8808 --dir /usr/lib/ruby/gems/1.8 --no-daemon


= class Gem::Commands::ServerCommand < Gem::Command

ローカルにインストールされている Gem パッケージとそのドキュメントを HTTP サーバに
載せて公開するためのクラスです。

