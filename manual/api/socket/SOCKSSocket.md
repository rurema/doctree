---
library: socket
---
# class SOCKSSocket < TCPSocket

[c:TCPSocket] を SOCKS(<http://www.sw.nec.co.jp/middle/socks/>) 対応したクラスです。

## Class Methods

### def SOCKSSocket.open(host, service) -> SOCKSSocket
### def SOCKSSocket.new(host, service) -> SOCKSSocket

host で指定したホストの service で指定したポートと接続したソケットを返します。host はホスト名、またはインターネットアドレスを示す文字列、service は /etc/services (または NIS) に登録されているサービス名かポート番号です。

- **param** `host` --  ホスト名、またはインターネットアドレスを示す文字列を指定します。
- **param** `service` -- /etc/services (または NIS) に登録されているサービス名かポート番号です。

## Instance Methods

### def close -> nil

ソケットを閉じます。
