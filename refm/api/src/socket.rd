category Network

socket はプロセス外部との通信 (プロセス間通信、ホスト間通信) を実現します。


=== ソケットアドレス

ソケットというのは通信路の末端です。
たとえば 1対1 の通信では、まず通信路の両端にひとつずつソケットをつくり、
それらのソケットを接続することによって通信路が確立し、相互に通信できるようになります。
この接続時に、一方のソケットにもう一方のソケットの場所を教えてやる必要がありますが、
この場所を指定するものがソケットアドレスです。

ソケットアドレスはソケットの種類によって中身が異なります。
たとえば TCP では IP アドレスとポート番号ですし、
Unix ドメインソケットではソケットファイルを指すパス名です。

#@since 1.9.1
ソケットアドレスを取り扱うための便利で高水準なクラスとして [[c:Addrinfo]] があります。
#@end

[[c:IPSocket]] および [[c:UNIXSocket]] 以下のクラス階層では、
わざわざソケットアドレスという形式にまとめなくてもよいよう、
ソケットアドレスの中身を直接扱えるメソッドが用意されています。

また、[[c:IPSocket]] 以下での IP アドレスとポート番号の指定は、
数値で表現するだけでなく、ホスト名やサービス名が使えます。
これについては以下の「ホスト指定形式」と「サービス指定形式」を参照してください。

また、C のレベルの「ソケットアドレス構造体を pack した文字列」も使用できます。
これは主に低レベルソケットインターフェース ([[c:Socket]]) で用いられます。

====[a:host_format] ホスト指定形式

AF_INET なソケットにおいてホストを指定するには以下のいずれか
の形式を指定します。

  * ホスト名 (例: "localhost")
  * octet decimalによるIPアドレス(文字列) (例: "127.0.0.1")
  * 空文字列 (""), 文字列 "<any>" - INADDR_ANYに相当
  * 文字列 "<broadcast>" - INADDR_BROADCASTに相当
  * IPアドレスを表す 32bit の整数 (例: 0x7f000001)

====[a:service_format] サービス指定形式

サービスを指定するには以下のいずれかの形式を指定します。

  * ポート番号(整数または文字列) (例: 21, "21")
  * サービス名 (例: "ftp")

====[a:pack_string] ソケットアドレス構造体を pack した文字列

ソケットアドレス構造体とは、C 言語の構造体 struct sockaddr_in (IPv4)
や struct sockaddr_un (Unix ドメイン)を指します。
[[c:Socket]] クラスなどソケットの低レベルインタフェースで利用されます。

#@if (version >= "1.8.0")
[[m:Socket.pack_sockaddr_in]],
[[m:Socket.unpack_sockaddr_in]] といったメソッドにより、
例えば、以下のようにしてこの文字列を得ることが出来ます

  require 'socket'
  p Socket.pack_sockaddr_in("echo", "127.0.0.1")
  => "\002\000\000\a\177\000\000\001\000\000\000\000\000\000\000\000"

#@else
また、ruby 1.6 以前では、以下のように [[m:Array#pack]] を使用できます。

  require 'socket'
  p [Socket::AF_INET,
     Socket.getservbyname('echo'),
     127, 0, 0, 1].pack("s n C4 x8")
  => "\002\000\000\a\177\000\000\001\000\000\000\000\000\000\000\000"
#@end

=== ホスト名と IP アドレスの変換

ホスト名から IP アドレスへの変換 (正引き) を行うメソッドは以下のものが用意されています。

#@since 1.9.1
  * [[m:Addrinfo.getaddrinfo]]("www.ruby-lang.org", "http") =>  [#<Addrinfo: 221.186.184.68:80 TCP (www.ruby-lang.org:http)>]
#@end
  * [[m:IPSocket.getaddress]]("www.ruby-lang.org") => "210.163.138.100"
  * [[m:TCPSocket.gethostbyname]]("www.ruby-lang.org") => ["beryllium.ruby-lang.org", [], 2, "210.163.138.100"]
  * [[m:Socket.gethostbyname]]("www.ruby-lang.org") => ["beryllium.ruby-lang.org", [], 2, "\322\243\212d"]
  * [[m:Socket.getaddrinfo]]("www.ruby-lang.org", "http") => [["AF_INET", 80, "beryllium.ruby-lang.org", "210.163.138.100", 2, 1, 6]]

逆に IP アドレスからホスト名への変換 (逆引き) を行うメソッドは以下のものが用意されています。

#@#* TCPSocket.gethostbyname("210.163.138.100") => ["210.163.138.100", [], 2, "210.163.138.100"]
#@#* Socket.gethostbyaddr(host[, type])
#@#* [[m:Socket.getnameinfo]]([Socket::AF_INET, "http", "210.163.138.100"]) => ["beryllium.ruby-lang.org", "www"]
  * [[m:Socket.getnameinfo]]([nil, nil, nil, "210.163.138.100"]) => ["beryllium.ruby-lang.org", 0]
  * [[m:Addrinfo#getnameinfo]] Addrinfo.ip("127.0.0.1").getnameinfo => ["localhost", "0"]


また、[[lib:resolv]] ライブラリも使用できます。

#@include(socket/SocketError)
#@include(socket/BasicSocket)
#@include(socket/IPSocket)
#@include(socket/SOCKSSocket)
#@include(socket/Socket)
#@include(socket/Socket__Constants)
#@include(socket/TCPServer)
#@include(socket/TCPSocket)
#@include(socket/UDPSocket)
#@include(socket/UNIXServer)
#@include(socket/UNIXSocket)
#@since 1.9.1
#@include(socket/Addrinfo)
#@include(socket/Socket__UDPSource)
#@end
#@since 1.9.2
#@include(socket/Socket__AncillaryData)
#@include(socket/Socket__Option)
#@end
#@since 2.1.0
#@include(socket/Socket__Ifaddr)
#@end
