---
type: library
require:
  - rubygems/command
#%until 3.1
  - rubygems/server
#%end
---
ローカルにインストールされている Gem パッケージとそのドキュメントを HTTP サーバに載せて公開するためのライブラリです。

#%since 3.1
Ruby 3.1 以降、`gem server` コマンドの実体は rubygems-server gem に移動しました。標準添付として残っているクラスは、rubygems-server gem のインストールを案内するメッセージを表示するだけのスタブです。
#%end

```text
Usage: gem server [options]
  Options:
    -p, --port=PORT                  port to listen on
    -d, --dir=GEMDIR                 directory from which to serve gems
        --[no-]daemon                run as a daemon
```

#%include(common_options)

```text
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
```

# class Gem::Commands::ServerCommand < Gem::Command

ローカルにインストールされている Gem パッケージとそのドキュメントを HTTP サーバに載せて公開するためのクラスです。

