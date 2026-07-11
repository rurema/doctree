---
library: socket
---
# class TCPSocket < IPSocket

インターネットドメインのストリーム型ソケットのクラスです。

通常の[c:IO] クラスのサブクラスと同
様の入出力ができます。このクラスによってソケットを用いたクラ
イアントを簡単に記述できるようになります。

ユーザの入力をそのままサーバに転送するプログラムは以下の
ようになります。

`````
require "socket"
  
port = if ARGV.size > 0 then ARGV.shift else 4444 end
print port, "\n"
  
s = TCPSocket.open("localhost", port)
  
while gets
  s.write($_)
  print(s.gets)
end
s.close
`````

## Class Methods

#@if("4.0" <= version)
### def open(host, service, local_host=nil, local_service=nil, resolv_timeout: nil, connect_timeout: nil, open_timeout: nil, fast_fallback: true) -> TCPSocket
### def new(host, service, local_host=nil, local_service=nil, resolv_timeout: nil, connect_timeout: nil, open_timeout: nil, fast_fallback: true) -> TCPSocket
#@end
#@if("3.4" <= version and version < "4.0")
### def open(host, service, local_host=nil, local_service=nil, resolv_timeout: nil, connect_timeout: nil, fast_fallback: true) -> TCPSocket
### def new(host, service, local_host=nil, local_service=nil, resolv_timeout: nil, connect_timeout: nil, fast_fallback: true) -> TCPSocket
#@end
#@if("3.0" <= version and version < "3.4")
### def open(host, service, local_host=nil, local_service=nil, connect_timeout: nil) -> TCPSocket
### def new(host, service, local_host=nil, local_service=nil, connect_timeout: nil) -> TCPSocket
#@end
#@if(version < "3.0")
### def open(host, service, local_host=nil, local_service=nil) -> TCPSocket
### def new(host, service, local_host=nil, local_service=nil) -> TCPSocket
#@end

host で指定したホストの service で指定したポートと接続したソケッ
トを返します。host はホスト名、またはインターネットアドレスを
示す文字列、service は /etc/services (または NIS) に登録されている
サービス名かポート番号です。

#@if (version >= "1.8.0")
引数 local_host, local_service を指定した場合、そのアドレス
に対して [man:bind(2)] します。
#@end

- **param** `host` --           ホスト名、またはインターネットアドレスを示す文字列を指定します。
- **param** `service` --        /etc/services (または NIS) に登録されているサービス名かポート番号を指定します。
- **param** `local_host` --     ホスト名、またはインターネットアドレスを示す文字列を指定します。
- **param** `local_service` --  /etc/services (または NIS) に登録されているサービス名かポート番号を指定します。
#@if (version >= "3.4")
- **param** `resolv_timeout` -- 名前解決のタイムアウトを秒数で指定します。
#@end
#@if (version >= "3.0")
- **param** `connect_timeout` -- 接続確立のタイムアウトを秒数で指定します。
#@end
#@if (version >= "4.0")
- **param** `open_timeout` -- 名前解決から接続確立までのタイムアウトを秒数で指定します。
#@end
#@if (version >= "3.4")
- **param** `fast_fallback` -- Happy Eyeballs Version 2 ([RFC 8305](https://datatracker.ietf.org/doc/html/rfc8305)) を有効にします。
#@end

### def gethostbyname(host) -> Array

ホスト名または IP アドレス (整数または"127.0.0.1"
のような文字列)からホストの情報を返します。ホスト情報は、ホ
スト名、ホストの別名の配列、ホストのアドレスタイプ、ホストの
アドレスを各要素とする配列です。ホストのアドレスは octet
decimal の文字列 ("127.0.0.1"のような文字列) や IPv6
アドレス ("::1" のような文字列) です。

- **param** `host` -- ホスト名または IP アドレス (整数または"127.0.0.1" のような文字列)を指定します。

- **return** -- ホスト名、ホストの別名の配列、ホストのアドレスタイプ、ホストのアドレスを各要素とする配列を返します。

例:

`````
require 'socket'

p TCPSocket.gethostbyname("www.ruby-lang.org")
#=> ["beryllium.ruby-lang.org", [], 2, "210.163.138.100"]
`````
