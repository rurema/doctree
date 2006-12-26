#@if (version >= "1.6.0")

require socket
require resolv

= redefine IPSocket

== Class Methods

--- getaddress(host)

[[m:IPSocket.getaddress]]の名前解決に [[lib:resolv]] ライブラリを
使います。

= redefine TCPSocket

== Class Methods

--- new(host, serv, *rest)

[[m:TCPSocket.new]]のパラメータ local_host の名前解決に [[lib:resolv]] 
ライブラリを使います。

= redefine UDPSocket

== Instance Methods

--- bind(host, port)

[[m:UDPSocket#bind]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

--- connect(host, port)

[[m:UDPSocket#connect]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

--- send(mesg, flags, *rest)

4 引数の形式で [[m:UDPSocket#send]] 実行したとき、パラメータ host の名前解決に
[[lib:resolv]] ライブラリを使います。

= redefine SOCKSSocket

== Class Methods

--- new(host, serv)

[[m:SOCKSocket.new]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

#@end
