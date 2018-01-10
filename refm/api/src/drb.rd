category Network

分散オブジェクトプログラミングのためのライブラリです。

Ruby のプロセスから他のRubyプロセスにあるオブジェクトのメソッド
を呼びだすことができます。他のマシン上のプロセスにも
アクセスできます。

=== 概要
dRuby は Ruby 専用の分散オブジェクトシステムです。
Ruby のみで記述され、TCP socket のような Ruby 本体が提供する
通信手段があれば追加のインストール物なしに利用可能です。
独自のプロトコルで通信し、他の分散オブジェクトシステム
(CORBA, RMI, .NETなど)との相互運用性はありません。

dRuby は
  * 他のプロセスと Ruby オブジェクトのリファレンスをやりとりすること
  * そこからのメソッド呼び出し
  * メソッド呼出の引数/返り値を [[c:Marshal]] でバイト列に変換(マーシャリング)
    して通信先のプロセスと受け渡しすること
    
ができます。これらはすべて透過的に行われます。

リモートプロセスにあるオブジェクトはローカルには [[c:DRb::DRbObject]] の
インスタンスとして表現されます。このオブジェクトはリモートオブジェクトの
proxy のように振舞います。つまり、このオブジェクトのメソッドを呼び出すと
リモートオブジェクトに転送されます。
CORBA の IDL のようなリモートオブジェクトのインターフェースを
静的に宣言する必要はなく、すべては実行時に解決されます。

リモートプロセスからのメソッド呼出しはそれを受け取ったプロセスの
[[c:DRb::DRbServer]] オブジェクトが処理します。
受け取ったメッセージからメソッド呼出し情報を取り出し、ローカルにある
オブジェクトを特定し、
そのメソッドを呼び出し、返り値をリモートの呼び出し元に送ります。
どのようなオブジェクトのメソッドも呼びだすことができます。
何か特別なインターフェースを実装したり、特別な mixin を必要としたりは
しません。
オブジェクトの特定は DRb::DRbServer が自動でします。そのため
オブジェクトの登録のようなことは通常必要ありません。

[[c:DRb::DRbServer]] に URI(例: druby://example.com:8787)を関連付けること
で、他のプロセスからの通信(リモートメソッド呼び出し)ができるようになります
(逆に言うと、URIを指定しないことで、他のプロセスからのリモートメソッド
呼び出しを拒否することができます)。
また、DRb::DRbServer に「フロントオブジェクト」を登録しておくと、
サーバの URI からそのオブジェクトをリモートオブジェクト
として取り出すことができます。通常はこのオブジェクトから辿って
必要な(リモート)オブジェクトを取り出します。


リモートメソッド呼び出しはかなりの部分、同じプロセス内の
オブジェクトのメソッドを呼び出すのと同じ動作をします。
ブロック付きのメソッド呼び出しもできますし、
リモートプロセス上で生じた例外はローカルプロセス上に
転送されます。DRb 関連の例外は [[c:DRb::DRbError]] の
サブクラスです。

リモートメソッド呼び出しの引数や返り値には任意の Ruby オブジェクト
が使えます。デフォルトではオブジェクトをマーシャリングして
渡され、受け取った側が元のオブジェクトに戻します。つまり
オブジェクトはコピーされます。これは通常の同一プロセス上での
メソッド呼び出しと大きく異なる点です(通常のメソッド呼び出しでは
オブジェクトへのリファレンスが渡されます)。

ただし、マーシャリング不可能なオブジェクトは dRuby によって
ある種のリファレンスとして取り扱われます。これは [[c:DRb::DRbObject]]
のインスタンスとして表現されます。これはリモートオブジェクトの
proxy として動作し、proxy のメソッドを呼び出すと上に説明した通りの
方法でリモートオブジェクトのメソッドを呼び出します。

マーシャンリング可能なオブジェクトを DRbObject でリファレンスとして
渡したい、つまりコピーでなくリファレンスで渡したい場合は
そのオブジェクトに
[[c:DRb::DRbUndumped]] を [[m:Module#include]] します。

dRuby はブロック付きのメソッド呼び出しをサポートしていますが、
[[c:Proc]] はマーシャリング不可能なので、ブロックの中身は
(リモート側でなく)ローカルプロセス上で実行されます。
リモート側がブロックを呼び出そうとすると、ブロックの引数が
リモート側からローカル側に(上で説明したようにコピーもしくは dRuby のリファレンス
オブジェクトとして)渡され、ブロックが実行され、その返り値がリモート側に
送られます。

=== セキュリティ

dRuby でインターネット上に公開するサービスを作るべきではありません。
イントラネットのサービスとして動かす場合もセキュリティには気を使う
必要があるでしょう。

あるオブジェクトへの外部からのアクセスを許可すると、単にそのオブジェクトの
メソッドを外部から呼び出せるだけでなく、任意の Ruby のコードを実行できて
しまいます。例えば以下のようなことができます。

  # !! 危険 !!
  ro = DRbObject.new_with_uri("druby://your.server.com:8989")
  class << ro
    # リモートオブジェクトの instance_eval を呼ぶため
    # ローカルオブジェクトの instance_eval を取り除く
    undef :instance_eval  
  end
  ro.instance_eval("DANGEROUS RUBY CODE!")

このような instance_eval による危険性は [[m:$SAFE]] を 1 以上に
することで防げます。
[[m:DRb.#start_service]] の :safe_level オプションで
リモートからのメソッド呼び出しのコンテキストで指定されるセーフレベルを
指定できます。

また、[[c:DRb::DRbServer]] にはアクセスコントロールリスト(アクセスを許可/拒否
する IP のリスト)によりアクセス制御をすることができます。
この機能は [[c:ACL]] で実現されています。
このアクセス制御は単体で使うのではなく、
適切なファイアウォールと併用すべきです。

=== リファレンス
  * [[url:http://www2a.biglobe.ne.jp/~seki/ruby/druby.html]]
  * [[url:http://www.ruby-doc.org/stdlib/libdoc/drb/rdoc/index.html]]

=== Example
単純なクライアント-サーバシステムの例。

ターミナルを2つサーバ側/クライアント側として起動して、サーバ側を
先に動かしてください。

==== サーバ側コード
  require 'drb/drb'
  
  # 通信を待ち受ける URI
  URI="druby://localhost:8787"
  
  class TimeServer
  
    def get_current_time
      return Time.now
    end
  
  end
  
  # サーバ側でリクエストを受け付けるオブジェクト
  FRONT_OBJECT=TimeServer.new
  
  # サーバを起動する
  DRb.start_service(URI, FRONT_OBJECT, :safe_level => 1)
  # DRb のスレッドが終了するのを待つ
  DRb.thread.join

==== クライアント側コード
  require 'drb/drb'
  
  # 接続先の URI
  SERVER_URI="druby://localhost:8787"
  
  # DRbサーバを起動する
  # この例には必要ないが、front オブジェクト以外の
  # リモートオブジェクトのメソッドを呼び出す時には必要
  DRb.start_service
  # リモートオブジェクトの取得
  timeserver = DRbObject.new_with_uri(SERVER_URI)
  # リモートメソッドの呼び出し
  puts timeserver.get_current_time

= module DRb
drb ライブラリの名前空間となるモジュール。

== Module Functions

--- config -> { Symbol => Object }
カレントサーバの設定を返します。

カレントサーバが存在しない場合は、デフォルトの設定を返します。

@see [[m:DRb.#current_server]]

--- current_server -> DRb::DRbServer
「カレントサーバ」を返します。

リモートメソッドが呼び出された場合、そのスレッドでは、その呼び出しを管理している
サーバがカレントサーバとなります。そうでない場合はプライマリサーバとなります。

通常、カレントサーバとプライマリサーバは一致しますが、複数のサーバを
異なる URI で起動した場合などにはこの2つが異なる場合があります。

@raise DRb::DRbServerNotFound カレントサーバが存在しない場合に発生します
@see [[m:DRb.#primary_server]]

#@# --- fetch_server(uri)
#@# #@todo


--- front -> object
カレントサーバのフロントオブジェクトを返します。

@raise DRbServerNotFound カレントサーバが存在しない場合に発生します
@see [[m:DRb.#current_server]]

--- here?(uri) -> bool
uri がカレントサーバに紐付けられたものであれば真を返します。

@see [[m:DRb.#current_server]]

--- install_acl(acl) -> ()
サーバ起動時の :acl オプションのデフォルト値を指定します。

内部的には [[m:DRb::DRbServer.default_acl]] を呼び出すだけです。

@see [[c:ACL]]

--- install_id_conv(idconv) -> ()
サーバ起動時の :id_conv オプションのデフォルト値を指定します。

内部的には [[m:DRb::DRbServer.default_id_conv]] を呼び出すだけです。


#@# --- regist_server(server) -> ()
#@# #@todo
#@# --- remove_server(server)
#@# #@todo

--- primary_server -> DRb::DRbServer|nil
ローカルプロセスのプライマリサーバーを返します。

プライマリサーバとは [[m:DRb.#start_service]] によって
起動されるサーバです。

サーバが動いていない場合は nil を返します。

@see [[m:DRb.#stop_service]]

--- primary_server=(server)
ローカルプロセスのプライマリサーバーを変更します。

通常、プライマリサーバは [[m:DRb.#start_service]] などが
設定するものであり、ユーザが変更すべきではありません。
このメソッドは dRuby の内部構造を良く理解した上で利用してください。

--- start_service(uri=nil, front=nil, config_or_acl=nil) -> ()

dRuby のサービス(サーバ)を起動します。

これで起動したサーバはプロセスのプライマリサーバとなります。
すでにプライマリサーバが存在する場合は上書きされます。

#@include(drb/start-service)

@see [[m:DRb.#primary_server]], [[m:DRb::DRbServer.new]]

--- stop_service -> ()
ローカルプロセス内の dRuby サーバ(プライマリサーバ)を停止します。

サーバが動いていない場合は何もしません。

--- thread -> Thread|nil
プライマリサーバが動作しているスレッドを返します。

プライマリサーバが存在しない場合は nil を返します。

@see [[m:DRb.#primary_server]]

#@# --- to_id(obj)
#@# #@todo
#@# 
#@# Get a reference id for an object using the current server.
#@# 
#@# This raises a DRbServerNotFound error if there is no current
#@# server. See #current_server.
#@# 
#@# --- to_obj(ref)
#@# #@todo
#@# 
#@# Convert a reference into an object using the current server.
#@# 
#@# This raises a DRbServerNotFound error if there is no current
#@# server. See #current_server.

--- uri -> String
カレントサーバに紐付けられた URI を返します。

@see [[m:DRb.#current_server]]


= class DRb::DRbError < RuntimeError
drb ライブラリ固有の例外を表すクラス

= class DRb::DRbServerNotFound < DRb::DRbError

カレントサーバが見付からない場合に発生する例外のクラス

@see [[m:DRb.#current_server]]

= class DRb::DRbRemoteError < DRb::DRbError
例外オブジェクトを wrap したクラス

== Instance Methods
--- reason -> String
wrapされている例外クラスの名前を返します。

#@include(drb/DRbIdConv)
#@include(drb/DRbObject)
#@include(drb/DRbServer)
#@include(drb/DRbUnknown)
#@include(drb/DRbUndumped)
#@include(drb/DRbProtocol)
