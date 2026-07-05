### const AF_APPLETALK -> Integer
### const PF_APPLETALK -> Integer

Apple talk。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2linux)], [man:socket(2freebsd)], [man:ddp(7linux)]

### const AF_ATM -> Integer
### const PF_ATM -> Integer

ATM。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2freebsd)]

### const AF_AX25 -> Integer
### const PF_AX25 -> Integer

ITU-T X.25 / ISO-8208。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2linux)]

### const AF_CCITT -> Integer
### const PF_CCITT -> Integer
#@todo
CCITT プロトコル。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_CHAOS -> Integer
### const PF_CHAOS -> Integer
#@todo
MIT CHAOS プロトコル。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_CNT -> Integer
### const PF_CNT -> Integer
#@todo
Computer Network Technology。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_COIP -> Integer
### const PF_COIP -> Integer
#@todo
connection-oriented IP。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_DATAKIT -> Integer
### const PF_DATAKIT -> Integer
#@todo
datakit protocol。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_DEC -> Integer
### const PF_DEC -> Integer
#@todo
DECnet protocol。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_DLI -> Integer
### const PF_DLI -> Integer
#@todo
DEC Direct data link interface。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_E164 -> Integer
#@todo
CCITT E.164 recommendation。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_ECMA -> Integer
### const PF_ECMA -> Integer
#@todo
European computer manufacturers。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_HYLINK -> Integer
### const PF_HYLINK -> Integer
#@todo
NSC Hyperchannel。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_IMPLINK -> Integer
### const PF_IMPLINK -> Integer
#@todo
ARPANET IMP。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_INET -> Integer
### const PF_INET -> Integer

IPv4。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:sys/socket.h(header)], [man:socket(2freebsd)], [man:ip(7linux)]

### const AF_INET6 -> Integer
### const PF_INET6 -> Integer

IPv6。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:sys/socket.h(header)], [man:socket(2freebsd)], [man:ipv6(7linux)]

### const AF_IPX -> Integer
### const PF_IPX -> Integer

IPX(Novell Internet Packet eXchange protocol)。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(3linux)]

### const AF_ISDN -> Integer
### const PF_ISDN -> Integer
#@todo
Integrated Services Digital Network。
[m:Socket.open] の第一引数 domain に使用します。

### const AF_ISO -> Integer
### const AF_OSI -> Integer
### const PF_ISO -> Integer
### const PF_OSI -> Integer
#@todo
ISO Open Systems Interconnection protocols。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_LAT -> Integer
### const PF_LAT -> Integer
#@todo
Local Area Transport protocol。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_LINK -> Integer
### const PF_LINK -> Integer
#@todo
Link layer interface。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_MAX -> Integer
対象のプラットフォーム上でのアドレスファミリーの最大の数値。

- **SEE** [m:Socket::Constants::PF_MAX]

### const AF_NATM -> Integer
### const PF_NATM -> Integer
#@todo
Native ATM access。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_NDRV -> Integer
### const PF_NDRV -> Integer
#@todo
Network driver raw access。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_NETBIOS -> Integer
### const PF_NETBIOS -> Integer
#@todo
NetBIOS。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_NETGRAPH -> Integer
### const PF_NETGRAPH -> Integer

Netgraph sockets。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2freebsd)]

### const AF_NS -> Integer
### const PF_NS -> Integer
#@todo
XEROX NS protocol。
[m:Socket.open] の第一引数 domain に使用します。


#@since 1.9.1
### const AF_PACKET -> Integer
### const PF_PACKET -> Integer

デバイスレベルインターフェース。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2linux)], [man:packet(7linux)]     
#@end
### const AF_PPP -> Integer
### const PF_PPP -> Integer
#@todo
Point-to-Point Protocol。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_PUP -> Integer
### const PF_PUP -> Integer

PUP(PARC Universal Packet)。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2freebsd)]

### const AF_ROUTE -> Integer
### const PF_ROUTE -> Integer
#@todo
Internal Routing protocol。
[m:Socket.open] の第一引数 domain に使用します。

#@todo

### const AF_SIP -> Integer
### const PF_SIP -> Integer
#@todo
Simple Internet Protocol。
[m:Socket.open] の第一引数 domain に使用します。


### const AF_SNA -> Integer
### const PF_SNA -> Integer
#@todo
IBM SNA protocol。
[m:Socket.open] の第一引数 domain に使用します。

### const AF_SYSTEM -> Integer
### const PF_SYSTEM -> Integer

#@todo

[m:Socket.open] の第一引数 domain に使用します。

### const AF_LOCAL -> Integer
### const AF_UNIX -> Integer
### const PF_LOCAL -> Integer
### const PF_UNIX -> Integer

Unix domain socket。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:sys/socket.h(header)], [man:unix(7linux)]

### const AF_UNSPEC -> Integer

アドレスファミリー不定。

- **SEE** [m:Socket.open], [man:sys/socket.h(header)]


### const PF_MAX -> Integer
プロトコルファミリーの最大数。

- **SEE** [m:Socket::Constants::AF_MAX]

### const PF_PIP -> Integer
Help Identify PIP packets。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2freebsd)]

### const PF_RTIP -> Integer
Help Identify RTIP packets。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2freebsd)]


### const PF_UNSPEC -> Integer
プロトコルファミリー不定。

- **SEE** [m:Socket::Constants::AF_UNSPEC], [m:Socket.open]


### const PF_XTP -> Integer
#@todo
eXpress Transfer Protocol。




### const SOCK_DGRAM -> Integer

データグラム通信。
[m:Socket.open] の第二引数 type に使用します。

- **SEE** [man:socket(2)], [m:Socket.open]

### const SOCK_PACKET -> Integer

デバイスレベルインターフェース。Obsoleteであり使うべきではない。
[m:Socket.open] の第二引数 type に使用します。

- **SEE** [man:packet(7linux)], [m:Socket.open]

### const SOCK_RAW -> Integer

RAW ソケット。
[m:Socket.open] の第二引数 type に使用します。

- **SEE** [man:sys/socket.h(header)], [man:socket(2linux)], 
     [man:raw(7linux)], [m:Socket.open]

### const SOCK_RDM -> Integer

信頼性のあるデータグラム通信。
[m:Socket.open] の第二引数 type に使用します。

- **SEE** [man:socket(2linux)], [m:Socket.open]

### const SOCK_SEQPACKET -> Integer

固定最大長を持つストリーム通信。
[m:Socket.open] の第二引数 type に使用します。

- **SEE** [m:Socket.open], [man:socket(2)], [man:socket(2linux)],
     [man:socket(2freebsd)]

### const SOCK_STREAM -> Integer

ストリーム通信。
[m:Socket.open] の第二引数 type に使用します。

- **SEE** [m:Socket.open], [man:socket(2)], [man:socket(2linux)],
     [man:socket(2freebsd)]

### const PF_KEY -> Integer
Internal key-management function。
[m:Socket.open] の第一引数 domain に使用します。

- **SEE** [man:socket(2freebsd)]


### const IPPORT_RESERVED -> Integer
利用法が予約されているポート番号の最大値。

### const IPPORT_USERRESERVED -> Integer
ユーザが自由に利用して良いポート番号の最小値。


#@since 1.9.1
### const IPPROTO_AH -> Integer
IPv6 auth header。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

### const IPPROTO_DSTOPTS -> Integer
IPv6 destination option。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

### const IPPROTO_ESP -> Integer
IPv6 Encapsulated Security Payload。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

### const IPPROTO_FRAGMENT -> Integer
IPv6 fragmentation header。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

### const IPPROTO_HOPOPTS -> Integer
IPv6 hop-by-hop options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

### const IPPROTO_ICMPV6 -> Integer
Internet Control Message Protocol for IPv6。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:icmp6(4freebsd)], [rfc:2292]
     

### const IPPROTO_IPV6 -> Integer
Internet Protocol Version 6。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:netinet/in.h(header)]
     [man:ip6(4freebsd)], [man:ipv6(7linux)]
     [rfc:2292]

### const IPPROTO_NONE -> Integer
IP6 no next header。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

### const IPPROTO_ROUTING -> Integer
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [rfc:2292]

#@end
### const IPPROTO_BIP -> Integer
#@todo
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_EGP -> Integer
#@todo
Exterior Gateway Protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_EON -> Integer
#@todo
ISO cnlp。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_GGP -> Integer
#@todo
Gateway to Gateway Protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_HELLO -> Integer
#@todo
"hello" routing protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_ICMP -> Integer
Control message protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:netinet/in.h(header)]
     [man:icmp(4freebsd)], [man:icmp(7linux)]


### const IPPROTO_IDP -> Integer
#@todo
XNS IDP。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_IGMP -> Integer
#@todo
Group Management Protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_IP -> Integer
Internet protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:netinet/in.h(header)]
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IPPROTO_MAX -> Integer
IPPROTO 定数の最大値。

### const IPPROTO_ND -> Integer
#@todo
Sun net disk protocol
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_PUP -> Integer
#@todo
PARC Universal Packet protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_RAW -> Integer
Raw IP packets protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:netinet/in.h(header)]
     [man:ip(4freebsd)], [man:raw(7linux)]

### const IPPROTO_TCP -> Integer
Transmission control protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:netinet/in.h(header)]
     [man:tcp(4freebsd)], [man:tcp(7linux)]


### const IPPROTO_TP -> Integer
#@todo
ISO transport protocol class 4。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

### const IPPROTO_UDP -> Integer
User Datagram Protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。

- **SEE** [man:netinet/in.h(header)]
     [man:udp(4freebsd)], [man:udp(7linux)]

### const IPPROTO_XTP -> Integer
#@todo
Xpress Transport Protocol。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt] の 
level 引数に使用します。

また、[m:Socket.open] の protocol 引数に渡す利用法もあります。



#@# IPプロトコル:
#@# [[m:BasicSocket#getsockopt]], [[m:BasicSocket#setsockopt]] の level 引数に
#@# 使用します。
#@# 
#@# また、[[m:Socket.open]] の
#@# 第一引数 domain に AF_INET もしくは AF_INET6,
#@# 第二引数 type に SOCK_RAW を指定した場合の、
#@# 第三引数 protocol にも使用します。
#@# 
#@# なお、AF_INET で SOCK_STREAM な場合には IPPROTO_TCP を使用できますが、
#@# その場合は 0 を指定しても同じ結果を得られますので通常は使用されません。
#@# AF_INET で SOCK_DGRAM の場合の IPPROTO_UDP も同様です。

### const AI_ADDRCONFIG -> Integer
Accept only if any address is assigned。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

### const AI_ALL -> Integer
Allow all addresses。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

### const AI_CANONNAME -> Integer
Fill in the canonical name。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

### const AI_DEFAULT -> Integer
Default flags for getaddrinfo。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getipnodebyname(3freebsd)]

### const AI_MASK -> Integer
#@todo

### const AI_NUMERICHOST -> Integer
Prevent host name resolution。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

#@since 1.9.1
### const AI_NUMERICSERV -> Integer
Prevent server name resolution。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

#@end
### const AI_PASSIVE -> Integer
Get address to use with bind。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

### const AI_V4MAPPED -> Integer
Accept IPv4-mapped IPv6 addresses。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getaddrinfo(3)]

### const AI_V4MAPPED_CFG -> Integer
Accept IPv4 mapped addresses if the kernel supports it。

[m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getipnodebyname(3freebsd)]

### const EAI_ADDRFAMILY -> Integer
Address family for hostname not supported

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_AGAIN -> Integer
Temporary failure in name resolution

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_BADFLAGS -> Integer
Invalid flags

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_BADHINTS -> Integer
Invalid value for hints

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

#@# 非標準的定数、KAMEで使われているらしい

### const EAI_FAIL -> Integer
Non-recoverable failure in name resolution

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_FAMILY -> Integer
Address family not supported

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_MAX -> Integer

EAI_* 定数の最大値。

### const EAI_MEMORY -> Integer
Memory allocation failure

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_NODATA -> Integer
No address associated with hostname

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)]

### const EAI_NONAME -> Integer
Hostname nor servname, or not known

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

#@since 1.9.1
### const EAI_OVERFLOW -> Integer
Argument buffer overflow

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

#@end

### const EAI_PROTOCOL -> Integer
Resolved protocol is unknown

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_SERVICE -> Integer
Servname not supported for socket type

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_SOCKTYPE -> Integer
Socket type not supported

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを [c:SocketError] に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]

### const EAI_SYSTEM -> Integer
System error returned in errno

[man:getaddrinfo(3)], [man:getnameinfo(3)] などの
エラーコードです。
対応する [m:Socket.getaddrinfo], [m:Addrinfo.getaddrinfo] などは
エラーを適当な例外に変換するため、この定数は直接は利用しません。

- **SEE** [man:getaddrinfo(3linux)], [man:gai_strerror(3freebsd)]



### const INADDR_ALLHOSTS_GROUP -> Integer
Multicast group for all systems on this subset。
IPv4の 244.0.0.1 に対応する整数です。

- **SEE** [url:http://www.iana.org/assignments/multicast-addresses/multicast-addresses.xml], [RFC:5771]

### const INADDR_ANY -> Integer
A socket bound to INADDR_ANY receives packets from 
all interfaces and sends from the default IP address。
IPv4アドレスの 0.0.0.0 に対応する整数です。

- **SEE** [man:netinet/in.h(header)], [man:ip(7linux)], [man:ip(4freebsd)]

### const INADDR_BROADCAST -> Integer
The network broadcast address。
IPv4のブロードキャストアドレス 255.255.255.255 に対応する整数です。

- **SEE** [man:netinet/in.h(header)], [man:ip(7linux)], [man:ip(4freebsd)]

### const INADDR_LOOPBACK -> Integer
The loopback address。
IPv4のループバックアドレス 127.0.0.1 に対応する整数です。

- **SEE** [man:ip(7linux)], [man:ip(4freebsd)]

### const INADDR_MAX_LOCAL_GROUP -> Integer
The last local network multicast group。
IPv4の 244.0.0.255 に対応する整数です。

- **SEE** [url:http://www.iana.org/assignments/multicast-addresses/multicast-addresses.xml], [RFC:5771]

### const INADDR_NONE -> Integer
A bitmask for matching no valid IP address。
エラーを表すアドレス値です。

### const INADDR_UNSPEC_GROUP -> Integer
The reserved multicast group。
IPv4の 244.0.0.0 に対応する整数です。

- **SEE** [url:http://www.iana.org/assignments/multicast-addresses/multicast-addresses.xml], [RFC:5771]

#@since 1.9.1
### const INET6_ADDRSTRLEN -> Integer
IPv6アドレス文字列の最大長。

- **SEE** [man:netinet/in.h(header)]

### const INET_ADDRSTRLEN -> Integer
IPv4アドレス文字列の最大長。

- **SEE** [man:netinet/in.h(header)]

#@end
#@since 1.9.2
### const IFNAMSIZ -> Integer
#@since 1.9.3
### const IF_NAMESIZE -> Integer
#@end

インターフェース名文字列の最大長さ。

- **SEE** [man:net/if.h(header)]

#@end

### const NI_DGRAM -> Integer
The service specified is a datagram service (looks up UDP ports)。

[m:Socket.getnameinfo], [m:Addrinfo#getnameinfo] の引数 flags に渡す
定数です。

`````
require 'socket'
  
Socket.getnameinfo([ Socket::AF_INET, 514, "127.0.0.1"], Socket::NI_DGRAM)
# => ["localhost", "syslog"]
Socket.getnameinfo([ Socket::AF_INET, 514, "127.0.0.1"])
# => ["localhost", "shell"]
`````

- **SEE** [man:getnameinfo(3)]

### const NI_MAXHOST -> Integer

[man:getnameinfo(3)] で用いるホスト名文字列の最大長さ。

- **SEE** [man:getnameinfo(3linux)]

### const NI_MAXSERV -> Integer

[man:getnameinfo(3)] で用いるサービス名文字列の最大長さ。

- **SEE** [man:getnameinfo(3linux)]

### const NI_NAMEREQD -> Integer

A name is required。名前解決できなかった場合にエラーを返すことを意味します。

[m:Socket.getnameinfo], [m:Addrinfo#getnameinfo] の引数 flags に渡す
定数です。

`````
require 'socket'
  
# ここでは 192.0.2.18 は名前解決できないアドレス
Addrinfo.tcp("192.0.2.18", 514).getnameinfo()
# =>["192.0.2.18", "shell"] 
Addrinfo.tcp("192.0.2.18", 514).getnameinfo(Socket::NI_NAMEREQD)
# SocketError が発生する
`````

- **SEE** [man:getnameinfo(3)]

### const NI_NOFQDN -> Integer

An FQDN is not required for local hosts, return only the local part.

[m:Socket.getnameinfo], [m:Addrinfo#getnameinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getnameinfo(3)]

### const NI_NUMERICHOST -> Integer

Return a numeric address.

[m:Socket.getnameinfo], [m:Addrinfo#getnameinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getnameinfo(3)]

### const NI_NUMERICSERV -> Integer
Return the service name as a digit string

[m:Socket.getnameinfo], [m:Addrinfo#getnameinfo] の引数 flags に渡す
定数です。

- **SEE** [man:getnameinfo(3)]

### const IP_ADD_MEMBERSHIP -> Integer
Add a multicast group membership

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]
     
### const IP_DEFAULT_MULTICAST_LOOP -> Integer
#@todo
Default multicast loopback


### const IP_DEFAULT_MULTICAST_TTL -> Integer
#@todo
Default multicast TTL


### const IP_DROP_MEMBERSHIP -> Integer
Drop a multicast group membership。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IP_HDRINCL -> Integer
Header is included with data。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_MAX_MEMBERSHIPS -> Integer
Maximum number multicast groups a socket can join。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_MULTICAST_IF -> Integer
IP multicast interface。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IP_MULTICAST_LOOP -> Integer
IP multicast loopback。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IP_MULTICAST_TTL -> Integer
IP multicast TTL。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IP_OPTIONS -> Integer
IP options to be included in packets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IP_RECVDSTADDR -> Integer
Receive IP destination address with datagram。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_RECVOPTS -> Integer
Receive IP destination address with datagram。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(7linux)]

### const IP_RECVRETOPTS -> Integer
#@todo
Receive all IP options for response

### const IP_RETOPTS -> Integer
IP options to be included in datagrams。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(7linux)]

### const IP_TOS -> Integer
IP type-of-service。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

### const IP_TTL -> Integer
IP time-to-live。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)], [man:ip(7linux)]

#@since 1.9.2
### const IP_ADD_SOURCE_MEMBERSHIP -> Integer
Add a multicast group membership。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_DROP_SOURCE_MEMBERSHIP -> Integer
Drop a multicast group membership。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_BLOCK_SOURCE -> Integer
Block IPv4 multicast packets with a give source address。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_UNBLOCK_SOURCE -> Integer
Unblock IPv4 multicast packets with a give source address。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_DONTFRAG -> Integer
Don't fragment packets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], 
     [man:ip(4freebsd)]

### const IP_FREEBIND -> Integer
Allow binding to nonexistent IP addresses。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_IPSEC_POLICY -> Integer
IPsec security policy。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP],
     [url:http://netbsd.gw.com/cgi-bin/man-cgi?ip++NetBSD-current]

### const IP_MINTTL -> Integer
Minimum TTL allowed for received packets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(4freebsd)]

### const IP_MSFILTER -> Integer
#@todo
Multicast source filtering

### const IP_MTU -> Integer
The Maximum Transmission Unit of the socket。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_MTU_DISCOVER -> Integer
Path MTU discovery。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_ONESBCAST -> Integer
Force outgoing broadcast datagrams to have the undirected broadcast address。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(4freebsd)]

### const IP_PASSSEC -> Integer
#@todo
Retrieve security context with datagram。


### const IP_PKTINFO -> Integer
Receive packet information with datagrams。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_PKTOPTIONS -> Integer
#@todo
Receive packet options with datagrams

### const IP_PMTUDISC_DO -> Integer
Always send DF frames。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_PMTUDISC_DONT -> Integer
Never send DF frames。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_PMTUDISC_WANT -> Integer
Use per-route hints。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_PORTRANGE -> Integer
Set the port range for sockets with unspecified port numbers。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(4freebsd)]

### const IP_RECVERR -> Integer
Enable extended reliable error message passing。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(4freebsd)]

### const IP_RECVIF -> Integer
Receive interface information with datagrams。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(4freebsd)]

### const IP_RECVSLLA -> Integer
#@todo
Receive link-layer address with datagrams

### const IP_RECVTOS -> Integer
Receive TOS with incoming packets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_RECVTTL -> Integer
Receive IP TTL with datagrams。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)], [man:ip(4freebsd)]

### const IP_ROUTER_ALERT -> Integer
Notify transit routers to more closely examine the contents of an IP packet。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(7linux)]

### const IP_SENDSRCADDR -> Integer
ource address for outgoing UDP datagrams。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [man:ip(4freebsd)]

### const IP_XFRM_POLICY -> Integer
#@todo

#@end


#@since 1.9.1
### const IPV6_CHECKSUM -> Integer
Byte offset into a packet where the checksum is located.
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:ip6(4freebsd)],
     [RFC:3542]

### const IPV6_DONTFRAG -> Integer
Don't fragment packets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_DSTOPTS -> Integer
Destination options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3542]

### const IPV6_HOPLIMIT -> Integer
Hop limit。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3542]

### const IPV6_HOPOPTS -> Integer
Hop-by-hop options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3542]

### const IPV6_JOIN_GROUP -> Integer
Join a multicast group。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

### const IPV6_LEAVE_GROUP -> Integer
Leave a multicast group。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

### const IPV6_MULTICAST_HOPS -> Integer
IPv6 multicast hop limit。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

### const IPV6_MULTICAST_IF -> Integer
IP6 multicast interface。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

### const IPV6_MULTICAST_LOOP -> Integer
IP6 multicast loopback。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

### const IPV6_NEXTHOP -> Integer
Next hop address。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_PATHMTU -> Integer
Retrieve current path MTU。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_PKTINFO -> Integer
Receive packet information with datagram。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3542]

### const IPV6_RECVDSTOPTS -> Integer
Receive all IP6 options for response。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RECVHOPLIMIT -> Integer
Receive hop limit with datagram。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RECVHOPOPTS -> Integer
Receive hop-by-hop options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RECVPATHMTU -> Integer
Receive current path MTU with datagram。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RECVPKTINFO -> Integer
Receive destination IP address and incoming interface。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RECVRTHDR -> Integer
Receive routing header。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RECVTCLASS -> Integer
Receive traffic class。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RTHDR -> Integer
Allows removal of sticky routing headers。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RTHDRDSTOPTS -> Integer
Allows removal of sticky destination options header。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_RTHDR_TYPE_0 -> Integer
````
Routing header type 0。
````
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_TCLASS -> Integer
Specify the traffic class。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_UNICAST_HOPS -> Integer
IPv6 unicast hop limit。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

### const IPV6_USE_MIN_MTU -> Integer
Use the minimum MTU size。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3542]

### const IPV6_V6ONLY -> Integer
Only bind IPv6。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IPV6],
     [man:netinet/in.h(header)], [man:ip6(4freebsd)], [man:ipv6(7linux)],
     [RFC:3493]

#@end

#@since 1.9.1
### const IPX_TYPE -> Integer
#@todo

#@end

### const MSG_COMPAT -> Integer
#@todo
End of record

### const MSG_CTRUNC -> Integer
Control data lost before delivery。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:send(2linux)], [man:recv(2linux)],
     [man:send(2freebsd)], [man:recv(2freebsd)]

### const MSG_DONTROUTE -> Integer
Send without using the routing tables。

[m:BasicSocket#send], [m:BasicSocket#sendmsg] の
flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:send(2linux)]
     [man:send(2freebsd)]

### const MSG_DONTWAIT -> Integer
This message should be non-blocking。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:send(2linux)], [man:recv(2linux)],
     [man:recv(2freebsd)]


### const MSG_EOF -> Integer
Data completes connection。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:send(2freebsd)]

### const MSG_EOR -> Integer
Data completes record。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:send(2)], [man:sendto(2)], [man:sendmsg(2)],
     [man:recv(2)], [man:recvfrom(2)], [man:recvmsg(2)],
     [man:send(2linux)], [man:recv(2linux)],
     [man:send(2freebsd)], [man:recv(2freebsd)]

### const MSG_FLUSH -> Integer
#@todo
Start of a hold sequence.  Dumps to so_temp


### const MSG_HAVEMORE -> Integer
#@todo
Data ready to be read


### const MSG_HOLD -> Integer
#@todo
Hold fragment in so_temp

### const MSG_RCVMORE -> Integer
#@todo
Data remains in the current packet

### const MSG_SEND -> Integer
#@todo
Send the packet in so_temp

### const MSG_OOB -> Integer
Process out-of-band data。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:send(2)], [man:sendto(2)], [man:sendmsg(2)],
     [man:recv(2)], [man:recvfrom(2)], [man:recvmsg(2)],
     [man:send(2linux)], [man:recv(2linux)],
     [man:send(2freebsd)], [man:recv(2freebsd)]

### const MSG_PEEK -> Integer
Peek at incoming message。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:send(2)], [man:sendto(2)], [man:sendmsg(2)],
     [man:recv(2)], [man:recvfrom(2)], [man:recvmsg(2)],
     [man:send(2linux)], [man:recv(2linux)],
     [man:send(2freebsd)], [man:recv(2freebsd)]


### const MSG_TRUNC -> Integer
Data discarded before delivery。

[m:BasicSocket#send], [m:BasicSocket#sendmsg],
[m:BasicSocket#recv], [m:BasicSocket#recvmsg]
の flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:send(2linux)], [man:recv(2linux)],
     [man:send(2freebsd)], [man:recv(2freebsd)]

### const MSG_WAITALL -> Integer
Wait for full request or error

[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:sys/socket.h(header)],
     [man:recv(2)], [man:recvfrom(2)], [man:recvmsg(2)],
     [man:recv(2linux)],
     [man:recv(2freebsd)]

#@since 1.9.2
### const MSG_CONFIRM -> Integer
Confirm path validity

[m:BasicSocket#send], [m:BasicSocket#sendmsg]
の flags 引数に用います。

- **SEE** [man:send(2linux)]

### const MSG_ERRQUEUE -> Integer
Fetch message from error queue

[m:BasicSocket#recv], [m:BasicSocket#recvmsg] の
flags 引数に用います。

- **SEE** [man:recv(2linux)]

### const MSG_FIN -> Integer
#@todo

### const MSG_MORE -> Integer
Sender will send more

[m:BasicSocket#send], [m:BasicSocket#sendmsg] の
flags 引数に用います。

- **SEE** [man:send(2linux)]

### const MSG_NOSIGNAL -> Integer
Do not generate SIGPIPE

[m:BasicSocket#send], [m:BasicSocket#sendmsg] の
flags 引数に用います。

- **SEE** [man:send(2linux)], [man:send(2freebsd)]

### const MSG_PROXY -> Integer
#@todo
Wait for full request

### const MSG_RST -> Integer
#@todo

### const MSG_SYN -> Integer
#@todo

#@end

#@since 1.9.2
### const MCAST_BLOCK_SOURCE -> Integer
Block multicast packets from this source

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_EXCLUDE -> Integer
Exclusive multicast source filter

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_INCLUDE -> Integer
Inclusive multicast source filter

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_JOIN_GROUP -> Integer
Join a multicast group

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_JOIN_SOURCE_GROUP -> Integer
Join a multicast source group

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_LEAVE_GROUP -> Integer
Leave a multicast group

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_LEAVE_SOURCE_GROUP -> Integer
Leave a multicast source group

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_MSFILTER -> Integer
#@todo
Multicast source filtering

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

### const MCAST_UNBLOCK_SOURCE -> Integer
Unblock multicast packets from this source

[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_IP], [m:Socket::Constants::IPPROTO_IPV6],
     [RFC:3678]

#@end

#@since 1.9.2
### const LOCAL_CONNWAIT -> Integer
Retrieve peer credentials。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:ip(4freebsd)]

### const LOCAL_CREDS -> Integer
Pass credentials to receiver。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:ip(4freebsd)]
### const LOCAL_PEERCRED -> Integer
Pass credentials to receiver。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:ip(4freebsd)]

#@end

#@since 1.9.2
### const SCM_BINTIME -> Integer
Timestamp (bintime).

[c:Socket::AncillaryData] の type として利用します。

- **SEE** [c:Socket::AncillaryData], [m:Socket::AncillaryData#timestamp]
     [m:BasicSocket#sendmsg], [m:BasicSocket#recvmsg]

### const SCM_CREDENTIALS -> Integer
The sender's credentials

[c:Socket::AncillaryData] の type として利用します。

- **SEE** [c:Socket::AncillaryData], 
     [m:BasicSocket#sendmsg], [m:BasicSocket#recvmsg],
     [man:unix(7linux)]

### const SCM_CREDS -> Integer
Process credentials

[c:Socket::AncillaryData] の type として利用します。

- **SEE** [c:Socket::AncillaryData], 
     [m:BasicSocket#sendmsg], [m:BasicSocket#recvmsg],
     [man:unix(4freebsd)]

### const SCM_RIGHTS -> Integer
Access rights.

[c:Socket::AncillaryData] の type として利用します。

- **SEE** [c:Socket::AncillaryData], [m:Socket::AncillaryData#unix_rights]
     [m:BasicSocket#sendmsg], [m:BasicSocket#recvmsg],
     [man:unix(7linux)], [man:unix(4freebsd)],
     [man:sys/socket.h(header)]

### const SCM_TIMESTAMP -> Integer
Timestamp (timeval).

[c:Socket::AncillaryData] の type として利用します。

- **SEE** [c:Socket::AncillaryData], [m:Socket::AncillaryData#timestamp]
     [m:BasicSocket#sendmsg], [m:BasicSocket#recvmsg]

### const SCM_TIMESTAMPNS -> Integer
Timestamp (timespec).

[c:Socket::AncillaryData] の type として利用します。

- **SEE** [c:Socket::AncillaryData], [m:Socket::AncillaryData#timestamp]
     [m:BasicSocket#sendmsg], [m:BasicSocket#recvmsg]

### const SCM_UCRED -> Integer
#@todo
User credentials。

#@end

### const SHUT_RD -> Integer
[m:BasicSocket#shutdown] の how 引数に使用します。

### const SHUT_RDWR -> Integer
[m:BasicSocket#shutdown] の how 引数に使用します。

### const SHUT_WR -> Integer
[m:BasicSocket#shutdown] の how 引数に使用します。

### const SO_ACCEPTCONN -> Integer
Socket has had listen() called on it。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_ACCEPTFILTER -> Integer
set accept filter on listening socket。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:getsockopt(2freebsd)], [m:Socket::Constants::SOL_SOCKET]

### const SO_ATTACH_FILTER -> Integer
Attach socket filter。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:socket(7linux)], [url:http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/networking/filter.txt;hb=HEAD],
     [m:Socket::Constants::SOL_SOCKET]

### const SO_BINDTODEVICE -> Integer
Bind this socket to a particular device。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_BROADCAST -> Integer
Permit sending of broadcast messages。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_DEBUG -> Integer
Debug info recording。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_DETACH_FILTER -> Integer
Detach socket filter。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:socket(7linux)], [url:http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=Documentation/networking/filter.txt;hb=HEAD],
     [m:Socket::Constants::SOL_SOCKET]

### const SO_DONTROUTE -> Integer
Send without using the routing tables。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_DONTTRUNC -> Integer
#@todo
Retain unread data

### const SO_ERROR -> Integer
Get socket error status。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_KEEPALIVE -> Integer
Keep connections alive。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_LINGER -> Integer
Linger on close if data is present。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)],[m:Socket::Constants::SOL_SOCKET]

### const SO_NKE -> Integer
#@todo
socket-level Network Kernel Extension。
#@# OS X socket option?

### const SO_NOSIGPIPE -> Integer
Don't SIGPIPE on EPIPE。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:getsockopt(2freebsd)], [m:Socket::Constants::SOL_SOCKET]

### const SO_NO_CHECK -> Integer
#@todo
Disable checksums。

### const SO_NREAD -> Integer
#@todo
Get first packet byte count。

### const SO_OOBINLINE -> Integer
Leave received out-of-band data in-line。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_PASSCRED -> Integer
Receive SCM_CREDENTIALS messages。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:socket(7linux)], [man:unix(7linux)],
     [m:Socket::Constants::SOL_SOCKET]

### const SO_PEERCRED -> Integer
The credentials of the foreign process connected to this socket。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:socket(7linux)], [man:unix(7linux)], [man:socketpair(2linux)],
     [m:Socket::Constants::SOL_SOCKET]

### const SO_PEERNAME -> Integer
#@todo
Name of the connecting user。

### const SO_PRIORITY -> Integer
The protocol-defined priority for all packets on this socket。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:socket(7linux)], [man:ip(7linux)]

### const SO_RCVBUF -> Integer
Receive buffer size。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_RCVLOWAT -> Integer
Receive low-water mark。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_RCVTIMEO -> Integer
Receive timeout。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)]

### const SO_REUSEADDR -> Integer
Allow local address reuse。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [man:bind(2)],
     [m:Socket::Constants::SOL_SOCKET]

### const SO_REUSEPORT -> Integer
Allow local address and port reuse。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:getsockopt(2freebsd)], [m:Socket::Constants::SOL_SOCKET]
     
### const SO_SECURITY_AUTHENTICATION -> Integer
#@todo

### const SO_SECURITY_ENCRYPTION_NETWORK -> Integer
#@todo

### const SO_SECURITY_ENCRYPTION_TRANSPORT -> Integer
#@todo

### const SO_SNDBUF -> Integer
Send buffer size。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_SNDLOWAT -> Integer
Receive low-water mark。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_SNDTIMEO -> Integer
Send timeout。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_TIMESTAMP -> Integer
Receive timestamp with datagrams (timeval)。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]
     [m:Socket::AncillaryData#timestamp]

### const SO_TYPE -> Integer
Get the socket type。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:sys/socket.h(header)], [man:getsockopt(2freebsd)],
     [man:socket(7linux)], [m:Socket::Constants::SOL_SOCKET]

### const SO_USELOOPBACK -> Integer
#@todo
Bypass hardware when possible。

### const SO_WANTMORE -> Integer
#@todo
Give a hint when more data is ready。

### const SO_WANTOOBFLAG -> Integer
#@todo
OOB data is wanted in MSG_FLAG on receive。

#@since 1.9.2
### const SO_ALLZONES -> Integer
#@todo
Bypass zone boundaries。
#@# Solaris?

### const SO_BINTIME -> Integer
Timestamp (bintime)。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:getsockopt(2freebsd)], [m:Socket::Constants::SOL_SOCKET]
     [m:Socket::Constants::SO_TIMESTAMP],
     [m:Socket::AncillaryData#timestamp]

### const SO_MAC_EXEMPT -> Integer
#@todo
Mandatory Access Control exemption for unlabeled peers。

### const SO_RECVUCRED -> Integer
#@todo
Receive user credentials with datagram。

### const SO_TIMESTAMPNS -> Integer
#@todo
Receive nanosecond timestamp with datagrams (timespec)。

- **SEE** [m:Socket::Constants::SO_TIMESTAMP],
     [m:Socket::AncillaryData#timestamp]

#@end


#@since 1.9.2
### const SOMAXCONN -> Integer
[m:Socket#listen] の backlog の最大長。

- **SEE** [man:sys/socket.h(header)], [man:listen(2)]

#@end

### const SOL_ATALK -> Integer
#@todo
AppleTalk socket options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

### const SOL_AX25 -> Integer
#@todo
AX.25 socket options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

### const SOL_IP -> Integer
IP socket options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

SOL_IP はポータブルではありません。 IPPROTO_IP のほうがよりポータブルです。

- **SEE** [man:getsockopt(2)], [man:setsockopt(2)], [man:ip(7linux)]
     [m:Socket::Constants::IPPROTO_IP]

### const SOL_IPX -> Integer
#@todo
IPX socket options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

### const SOL_SOCKET -> Integer
Socket level options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

- **SEE** [man:getsockopt(2)], [man:setsockopt(2)], 
     [man:sys/socket.h(header)], [man:socket(7linux)]
     [man:getsockopt(2freebsd)]

### const SOL_TCP -> Integer
TCP socket options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_TCP]

### const SOL_UDP -> Integer
UDP socket options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第一引数(level)に使用します。

- **SEE** [m:Socket::Constants::IPPROTO_UDP]

### const SOPRI_BACKGROUND -> Integer
#@todo
Background socket priority

### const SOPRI_INTERACTIVE -> Integer
#@todo
Interactive socket priority

### const SOPRI_NORMAL -> Integer
Normal socket priority
#@todo

### const TCP_MAXSEG -> Integer
Set maximum segment size。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(4freebsd)], [man:tcp(7linux)]

### const TCP_NODELAY -> Integer
Don't delay sending to coalesce packets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(4freebsd)],
     [man:tcp(7linux)], [man:netinet/tcp.h(header)]

#@since 1.9.2
### const TCP_CORK -> Integer
Don't send partial frames。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_DEFER_ACCEPT -> Integer
Don't notify a listening socket until data is ready。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_INFO -> Integer
Retrieve information about this socket。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(4freebsd)], [man:tcp(7linux)]

### const TCP_KEEPCNT -> Integer
Maximum number of keepalive probes allowed before dropping a connection。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_KEEPIDLE -> Integer
Idle time before keepalive probes are sent。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_KEEPINTVL -> Integer
Time between keepalive probes。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_LINGER2 -> Integer
Lifetime of orphaned FIN_WAIT2 sockets。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_MD5SIG -> Integer
Use MD5 digests (RFC2385)。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(4freebsd)], [RFC:2385]

### const TCP_NOOPT -> Integer
Don't use TCP options。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(4freebsd)], [man:tcp(7linux)]

### const TCP_NOPUSH -> Integer
Don't push the last block of write。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(4freebsd)], [man:tcp(7linux)]

### const TCP_QUICKACK -> Integer
Enable quickack mode。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_SYNCNT -> Integer
Number of SYN retransmits before a connection is dropped。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const TCP_WINDOW_CLAMP -> Integer
Clamp the size of the advertised window。
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:tcp(7linux)]

### const UDP_CORK -> Integer
Don't send partial frames
[m:BasicSocket#getsockopt], [m:BasicSocket#setsockopt]
の第2引数(optname)に使用します。

- **SEE** [man:udp(7linux)]

#@end

#@since 2.1.0
### const IFF_802_1Q_VLAN

802.1Q VLAN device

### const IFF_ALLMULTI

receive all multicast packets

### const IFF_ALTPHYS

use alternate physical connection

### const IFF_AUTOMEDIA

auto media select active

### const IFF_BONDING

bonding master or slave

### const IFF_BRIDGE_PORT

device used as bridge port

### const IFF_BROADCAST

broadcast address valid

### const IFF_CANTCONFIG

unconfigurable using ioctl(2)

### const IFF_DEBUG

turn on debugging

### const IFF_DISABLE_NETPOLL

disable netpoll at run-time

### const IFF_DONT_BRIDGE

disallow bridging this ether dev

### const IFF_DORMANT

driver signals dormant

### const IFF_DRV_OACTIVE

tx hardware queue is full

### const IFF_DRV_RUNNING

resources allocated

### const IFF_DYING

interface is winding down

### const IFF_DYNAMIC

dialup device with changing addresses

### const IFF_EBRIDGE

ethernet bridging device

### const IFF_ECHO

echo sent packets

### const IFF_ISATAP

ISATAP interface (RFC4214)

### const IFF_LINK0

per link layer defined bit 0

### const IFF_LINK1

per link layer defined bit 1

### const IFF_LINK2

per link layer defined bit 2

### const IFF_LIVE_ADDR_CHANGE

hardware address change when it's running

### const IFF_LOOPBACK

loopback net

### const IFF_LOWER_UP

driver signals L1 up

### const IFF_MACVLAN_PORT

device used as macvlan port

### const IFF_MASTER

master of a load balancer

### const IFF_MASTER_8023AD

bonding master, 802.3ad.

### const IFF_MASTER_ALB

bonding master, balance-alb.

### const IFF_MASTER_ARPMON

bonding master, ARP mon in use

### const IFF_MONITOR

user-requested monitor mode

### const IFF_MULTICAST

supports multicast

### const IFF_NOARP

no address resolution protocol

### const IFF_NOTRAILERS

avoid use of trailers

### const IFF_OACTIVE

transmission in progress

### const IFF_OVS_DATAPATH

device used as Open vSwitch datapath port

### const IFF_POINTOPOINT

point-to-point link

### const IFF_PORTSEL

can set media type

### const IFF_PPROMISC

user-requested promisc mode

### const IFF_PROMISC

receive all packets

### const IFF_RENAMING

interface is being renamed

### const IFF_ROUTE

routing entry installed

### const IFF_RUNNING

resources allocated

### const IFF_SIMPLEX

can't hear own transmissions

### const IFF_SLAVE

slave of a load balancer

### const IFF_SLAVE_INACTIVE

bonding slave not the curr. active

### const IFF_SLAVE_NEEDARP

need ARPs for validation

### const IFF_SMART

interface manages own routes

### const IFF_STATICARP

static ARP

### const IFF_SUPP_NOFCS

sending custom FCS

### const IFF_TEAM_PORT

used as team port

### const IFF_TX_SKB_SHARING

sharing skbs on transmit

### const IFF_UNICAST_FLT

unicast filtering

### const IFF_UP

interface is up

### const IFF_WAN_HDLC

WAN HDLC device

### const IFF_XMIT_DST_RELEASE

dev_hard_start_xmit() is allowed to release skb->dst

### const IFF_VOLATILE

volatile flags

### const IFF_CANTCHANGE

flags not changeable
#@end
