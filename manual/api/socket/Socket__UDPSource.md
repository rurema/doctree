---
library: socket
since: "1.9.1"
---
# class Socket::UDPSource

[m:Socket.udp_server_loop] で使われるアドレス情報を保持するクラスです。

## Class methods
### def new(remote_addr, local_addr) {|msg| ... } -> Socket::UDPSource

Socket::UDPSource オブジェクトを生成します。

このメソッドはユーザは直接使いません。[m:Socket.udp_server_loop] が
内部で用います。

- **param** `remote_addr` -- リモートのアドレス([c:Addrinfo] オブジェクト)
- **param** `local_addr` -- ローカルのアドレス([c:Addrinfo] オブジェクト)

## Instance Methods
### def remote_address -> Addrinfo

リモート側のアドレス情報を [c:Addrinfo] オブジェクトで返します。

### def local_address -> Addrinfo

ローカル側のアドレス情報を [c:Addrinfo] オブジェクトで返します。

### def reply(msg) -> ()

msg をリモート側の端点へ送ります。

- **param** `msg` -- 送るメッセージ文字列

