category Network

サーバを実装するためのライブラリです。

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
  GServer.in_service?(10001)           # => true
  server.stopped?                      # => false
  
  # サーバを止めます。
  server.shutdown
  
  # すぐさまサーバを止めることもできます。
  GServer.stop(10001)
  # もちろん server.stop でも可能です。

=== 注意

このライブラリは 2.2.0 で gem ライブラリとして切り離されました。2.2.0
以降ではそちらを利用してください。

  * [[url:https://rubygems.org/gems/gserver]]

= class GServer < Object

サーバを実装するためのクラスです。[[c:GServer]] を継承した新しいクラスを定義して使います。
fork ではなくスレッドを使っています。

== Constants

--- DEFAULT_HOST -> String

"127.0.0.1" です。

== Class Methods

--- new(port, host = GServer::DEFAULT_HOST, maxConnections = 4, stdlog = $stderr, audit = false, debug = false)

GServer オブジェクトを生成します。

@param port サーバがリッスンするポートを指定します。

@param host ホストを指定します。

@param maxConnections 最大接続数を指定します。デフォルトは 4 です。

@param stdlog ログの出力先を指定します。デフォルトは標準エラー出力です。

@param audit 真を指定するとサーバの起動時、接続時、切断時、停止時にログを出力します。

@param debug 真を指定するとデバッグログを出力します。

--- in_service?(port, host = GServer::DEFAULT_HOST) -> bool

与えられた host と port で GServer オブジェクトが同じプロセス内で
サービス中なら真を返します。

@param port ポート番号を指定します。

@param host ホストを指定します。

--- stop(port, host = DEFAULT_HOST) -> ()

与えられた host と port に対応する GServer オブジェクトを停止します。

@param port ポート番号を指定します。

@param host ホストを指定します。

== Instance Methods

--- audit -> bool
真であれば、サーバの起動時、接続時、切断時、停止時にログを出力します。

@see [[m:GServer#starting]], [[m:GServer#connecting]], [[m:GServer#disconnecting]], [[m:GServer#stopping]]

--- audit=(bool)

真を指定すると、サーバの起動時、接続時、切断時、停止時にログを出力します。

@param bool 真偽値を指定します。

@see [[m:GServer#starting]], [[m:GServer#connecting]], [[m:GServer#disconnecting]], [[m:GServer#stopping]]

--- connections() -> Integer

現在接続しているクライアントの数を返します。

--- debug -> bool

デバッグモードなら真、そうでないなら偽を返します。

--- debug=(bool)

真を指定するとデバッグモードが有効になります。
偽を指定するとデバッグモードが無効になります。

@param bool 真偽値を指定します。

--- host -> String

ホストを文字列で返します。

--- join

サーバのサービスを実行しているスレッドを [[m:Thread#join]] します。

@see [[m:Thread#join]]

--- maxConnections -> Integer

受け付ける最大接続数を返します。

--- port -> Integer

ポートを数で返します。

--- serve(io) -> nil

何もしません。サブクラスでオーバーライドします。

@param io クライアントと接続している [[c:TCPSocket]] を指定します。

--- shutdown -> true

自身を停止します。

--- start(maxConnections = -1) -> self

自身を起動します。

@param maxConnections 0 より大きい数値を指定すると、最大接続数として設定されます。

--- stdlog -> IO

ログを出力する先の [[c:IO]] オブジェクトを返します。デフォルトは [[m:$stderr]] です。

--- stdlog=(io)

ログを出力する先の [[c:IO]] オブジェクトを設定します。

@param io ログを出力する先の [[c:IO]] オブジェクトを設定します。

--- stop -> ()

自身をすぐに停止します。

--- stopped? -> bool

自身が停止しているなら真を返します。

== Protected Instance Methods

--- connecting(client) -> true

[[m:GServer#audit]] が真ならば、クライアント接続時に呼ばれます。

サブクラスでオーバーライドします。

@param client クライアントと接続している [[c:TCPSocket]] です。

--- disconnecting(clientPort) -> ()

[[m:GServer#audit]] が真ならば、クライアントとの接続終了時に呼ばれます。

サブクラスでオーバーライドします。

@param clientPort 接続していたクライアントのポートです。

--- starting -> ()

[[m:GServer#audit]] が真ならば、サーバ起動時に呼ばれます。
サブクラスでオーバーライドします。

--- stopping -> ()

[[m:GServer#audit]] が真ならば、サーバ停止時に呼ばれます。
サブクラスでオーバーライドします。

--- error(detail) -> ()

[[m:GServer#debug]] が真の場合、例外が発生すると呼ばれます。

@param detail 例外オブジェクトです。

--- log(msg) -> ()

与えられた文字列をログに記録します。

@param msg ログとして記録する文字列を指定します。

