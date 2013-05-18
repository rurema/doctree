[[c:DRb::ExtServ]] を定義しているライブラリ。

[[lib:drb/extservm]] で定義されている [[c:DRb::ExtServManager]] 
によって管理されるサービスを実現する [[c:DRb::ExtServ]] を
定義しています。

詳しくは [[lib:drb/extservm]] を見てください。

= class DRb::ExtServ < Object
include DRb::DRbUndumped

[[c:DRb::ExtServManager]] で使われるサービスを定義しているクラスです。


== Class Methods

--- new(there, name, server=nil) -> DRb::ExtServ
DRb::ExtServ オブジェクトを生成し、サービスを 
[[c:DRb::ExtServManager]] オブジェクトに登録します。

there で指定した
URI の front オブジェクト(これは [[c:DRb::ExtServManager]] の
インスタンスであるべきです)に name という名前でサービスを登録します。

there, name は [[m:Object::ARGV]] の末尾2つを渡してください。

server には drb の通信に用いる [[c:DRb::DRbServer]] オブジェクトを指定します。
省略した場合は [[m:DRb.#primary_server]] を用います。
[[m:DRb::ExtServ#front]] が返すオブジェクトはこのサーバの
[[m:DRb::DRbServer#front]] が用いられます。

@param there サービスを管理しているプロセスの drb URI
@param name サービスの名前
@param server DRb::DRbServer オブジェクト

== Instance Methods

--- front -> object
サービスの窓口となるオブジェクトを返します。

実際には、[[m:DRb::ExtServ.new]] の server で指定した
[[c:DRb::DRbServer]] オブジェクトの [[m:DRb::DRbServer#front]] 
が返されます。

--- stop_service -> true
サービスを停止します。

[[m:DRb::ExtServManager]] オブジェクトにサービスの停止を伝達し、
[[m:DRb::DRbServer#stop_service]] でサーバを停止します。

このメソッドはリモートから起動することができます。
サーバが停止するため、停止したサービスのリモートオブジェクトは
利用できなくなります。また、サーバの停止により
接続を待ち受けているスレッドが停止します。

サービス停止後、
[[m:DRb::ExtServManager#service]] で同じ名前のサービスを要求すると、
別のプロセスが起動します。

--- alive? -> bool
サービスが起動しているならば真を返します。

リモート側からこのメソッドを呼ぶのはあまり意味がありません。
サービスを停止するとリモートメソッド呼び出しができなくなるためです。

--- server -> DRb::DRbServer
通信に利用しているサーバを返します。

[[m:DRb::ExtServ.new]] で指定した [[c:DRb::DRbServer]] を返します。

