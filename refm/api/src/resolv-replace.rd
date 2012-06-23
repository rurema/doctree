category Network

名前解決に resolv を使用するためのライブラリです。

= redefine IPSocket

== Class Methods

--- getaddress(host) -> String
[[m:IPSocket.getaddress]] を置きかえ、
[[lib:resolv]] ライブラリを使い名前解決します。

@param host ホスト名を指定します。
@raise SocketError 名前解決に失敗した場合に発生します。

= redefine TCPSocket

== Class Methods

--- open(host, serv, local_host=nil, local_service=nil) -> TCPSocket
--- new(host, serv, local_host=nil, local_service=nil) -> TCPSocket
[[m:TCPSocket.new]] のパラメータ host と local_host 
の名前解決に [[lib:resolv]] ライブラリを使います。

@param host           ホスト名、または octet decimal によるインターネットアドレスを示す文字列を指定します。
@param service        /etc/services (または NIS) に登録されているサービス名かポート番号を指定します。
@param local_host     ホスト名、または octet decimal によるインターネットアドレスを示す文字列を指定します。
@param local_service  /etc/services (または NIS) に登録されているサービス名かポート番号を指定します。
@raise SocketError 名前解決に失敗した場合に発生します。

= redefine UDPSocket

== Instance Methods

--- bind(host, port) -> Integer
[[m:UDPSocket#bind]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

@param host bindするホスト名を文字列で指定します。
@param port bindするポートを指定します。
@raise SocketError 名前解決に失敗した場合に発生します。

--- connect(host, port) -> Integer
[[m:UDPSocket#connect]] のパラメータ host の名前解決に 
[[lib:resolv]] ライブラリを使います。

@param host connect するホスト名を文字列で指定します。
@param port connect するポートを指定します。
@raise SocketError 名前解決に失敗した場合に発生します。

--- send(mesg, flags , dest_sockaddr=nil) -> Integer
--- send(mesg, flags, host, port) -> Integer
4 引数の形式で [[m:UDPSocket#send]] 実行したとき、
パラメータ host の名前解決に
[[lib:resolv]] ライブラリを使います。

@param mesg 送るデータを文字列で与えます。
@param flags フラグを指定します。
@param host データを送る先のホストを指定します。
@param port データを送る先のポートを指定します。
@raise SocketError 名前解決に失敗した場合に発生します。

= redefine SOCKSSocket

== Class Methods

--- new(host, serv) -> SOCKSSocket
[[m:SOCKSSocket.new]]のパラメータ host の名前解決に [[lib:resolv]] 
ライブラリを使います。

@param host ホスト名を文字列で指定します。
@param serv ホスト名を文字列で指定します。
@raise SocketError 名前解決に失敗した場合に発生します。


