---
library: socket
since: "2.1.0"
---
# class Socket::Ifaddr < Data

[man:getifaddrs(3)] の結果を表すクラスです。

## Instance Methods

### def inspect -> String

self の情報を人間に読みやすい文字列にして返します。

### def name -> String

self のインターフェイス名を返します。

### def ifindex -> Integer

self のインターフェイスのインデックスを返します。

### def flags -> Integer

self に指定された flags の値を返します。

### def addr -> Addrinfo | nil

self のアドレスを [c:Addrinfo] オブジェクトで返します。
self が利用できない場合は nil を返します。

### def netmask -> Addrinfo | nil

self のネットマスクを [c:Addrinfo] オブジェクトで返します。
self が利用できない場合は nil を返します。

### def broadaddr -> Addrinfo | nil

self のブロードキャストアドレスを [c:Addrinfo] オブジェクトで返します。
self.flags で [m:Socket::IFF_BROADCAST] が有効ではない場合は nil を返します。

### def dstaddr -> Addrinfo | nil

self の宛先アドレスを [c:Addrinfo] オブジェクトで返します。
self.flags で [m:Socket::IFF_POINTOPOINT] が有効ではない場合は nil を返します。

#@since 2.5.0
### def vhid -> Integer | nil

self のバーチャルホストIDを返します。
バーチャルホストIDがない場合は nil を返します。

サポートされていない環境ではメソッド自体が定義されていません。
#@end
