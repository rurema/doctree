#@if (version >= "1.6.0")
名前解決に resolv を使用するためのライブラリです。

require resolv

= redefine IPSocket

== Class Methods

--- getaddress(host)
#@todo

[[m:IPSocket.getaddress]]の名前解決に [[lib:resolv]] ライブラリを
使います。

= redefine TCPSocket

== Class Methods

--- new(host, serv, *rest)
#@todo

[[m:TCPSocket.new]]のパラメータ local_host の名前解決に [[lib:resolv]] 
ライブラリを使います。

= redefine UDPSocket

== Instance Methods

--- bind(host, port)
#@todo

[[m:UDPSocket#bind]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

--- connect(host, port)
#@todo

[[m:UDPSocket#connect]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

--- send(mesg, flags, *rest)
#@todo

4 引数の形式で [[m:UDPSocket#send]] 実行したとき、パラメータ host の名前解決に
[[lib:resolv]] ライブラリを使います。

= redefine SOCKSSocket

== Class Methods

--- new(host, serv)
#@todo

[[m:SOCKSocket.new]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

#@end
