#@if (version >= "1.8.0")
サーバを実装するためのライブラリです。

= class GServer < Object

サーバを実装するためのクラスです。GServer を継承した新しいクラスを定義して使います。
fork ではなくスレッドを使っています。

例:

  #
  # 1970年からの経過時間を秒で返すサーバの例です。
  #
  class TimeServer < GServer
    def initialize(port=10001, *args)
      super(port, *args)
    end
    def serve(io)
      io.puts(Time.now.to_i)
    end
  end
  
  # ログを取る設定でサーバをスタートします。
  server = TimeServer.new
  server.audit = true                  # Turn logging on.
  server.start
  
  # まだサーバが動いているかを確認してみましょう。
  GServer.in_service?(10001)           # -> true
  server.stopped?                      # -> false
  
  # サーバを止めます。
  server.shutdown
  
  # すぐさまサーバを止めることもできます。
  GServer.stop(10001)
  # もちろん server.stop でも可能です。

=== 参照
[[url:http://www.ruby-doc.org/stdlib/libdoc/gserver/rdoc/]]

== Constants

--- DEFAULT_HOST
#@todo

"127.0.0.1" です。

== Class Methods

--- new(port, host = DEFAULT_HOST, maxConnections = 4, stdlog = $stderr, audit = false, debug = false)
#@todo

GServer オブジェクトを生成します。

--- in_service?(port, host = DEFAULT_HOST)
#@todo

与えられた host と port で GServer オブジェクトが同じプロセス内で
サービス中なら真を返します。

--- stop(port, host = DEFAULT_HOST)
#@todo

与えられた host と port に対応する GServer オブジェクトを停止します。

== Instance Methods

--- audit
#@todo

メソッド starting, connecting, disconnecting, stopping をそれぞれ定められた時に呼ぶなら true、そうでないなら false を返します。

--- audit=(bool)
#@todo

true なら GServer はログを取るためのメソッド
starting, connecting, disconnecting, stoppingを
それぞれ定められた時に呼びます。

--- connecting(client)
#@todo

audit が true に設定されているなら、クライアント接続時に呼ばれます。
client はクライアントと接続している [[c:TCPSocket]] です。
サブクラスでオーバーライドします。

--- connections()
#@todo

現在接続しているクライアントの数を返します。

--- disconnecting(clientPort)
#@todo

audit が true に設定されているなら、クライアントとの接続終了時に呼ばれます。
clientPort は接続していたクライアントのポートです。
サブクラスでオーバーライドします。

--- debug
#@todo

デバッグモードなら true、そうでないなら false を返します。

--- debug=(bool)
#@todo

デバッグモードにするかどうかを設定します。

--- error(detail)
#@todo

debug が true に設定されている時、例外が発生すると呼ばれます。
detail は例外オブジェクトです。protected メソッドです。

--- host
#@todo

ホストを文字列で返します。

--- join
#@todo

サーバのサービスを実行しているスレッドを join します。

--- log(msg)
#@todo

文字列 msg をログに記録します。protected メソッドです。

--- maxConnections
#@todo

受け付ける最大接続数を返します。

--- port
#@todo

ポートを数で返します。

--- serve(io)
#@todo

何もしません。サブクラスでオーバーライドします。

--- shutdown
#@todo

GServer を停止します。

--- start(maxConnections = -1)
#@todo

GServer を起動します。 0 より大きい maxConnections を与えたなら、
最大接続数として設定されます。

--- starting
#@todo

audit が true に設定されているなら、サーバ起動時に呼ばれます。
サブクラスでオーバーライドします。

--- stdlog
#@todo

ログを出力する先の [[c:IO]] オブジェクトを返します。デフォルトは $stderr です。

--- stdlog=(io)
#@todo

ログを出力する先の [[c:IO]] オブジェクトを設定します。デフォルトは $stderr です。

--- stop
#@todo

GServer をすぐに停止します。

--- stopping
#@todo

audit が true に設定されているなら、サーバ停止時に呼ばれます。
サブクラスでオーバーライドします。

--- stopped?
#@todo

GServer が停止しているなら真を返します。
#@end
