---
library: socket
since: "1.9.2"
---
# class Socket::Option

[m:BasicSocket#getsockopt]、[m:BasicSocket#setsockopt] で使うソケットオプションの値を表すクラス。

ソケットオプションの具体的な意味は自身の使っているシステムのドキュメントを見てください。

## Class Methods
### def Socket::Option.new(family, level, optname, data) -> Socket::Option

Socket::Option オブジェクト新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `data` -- データ(文字列)

- **SEE** [m:Socket::Option.int], [m:Socket::Option.bool], [m:Socket::Option.linger]

```ruby
require 'socket'

sockopt = Socket::Option.new(:INET, :SOCKET, :KEEPALIVE, [1].pack("i"))
p sockopt # => #<Socket::Option: INET SOCKET KEEPALIVE 1>
```

### def Socket::Option.int(family, level, optname, integer) -> Socket::Option

整数をデータとして持つ Socket::Option オブジェクト新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `integer` -- データ(整数)

### def Socket::Option.bool(family, level, optname, boolean) -> Socket::Option

整数をデータとして持つ Socket::Option オブジェクト新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `boolean` -- データ(真偽値)

```ruby
require 'socket'

p Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, true)
# => #<Socket::Option: INET SOCKET KEEPALIVE 1>

p Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false)
# => #<Socket::Option: AF_INET SOCKET KEEPALIVE 0>
```

### def Socket::Option.linger(onoff, secs) -> Socket::Option

SOL_SOCKET/SO_LINGER 用の Socket::Option オブジェクトを新たに生成し返します。

- **param** `onoff` -- 0/1もしくは真偽値
- **param** `secs` -- 整数値

### def Socket::Option.byte(family, level, optname, integer) -> Socket::Option

1 バイトの整数をデータとして持つ `Socket::Option` オブジェクトを新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `integer` -- データ(1 バイトの整数)

```ruby
require 'socket'

p Socket::Option.byte(:INET, :SOCKET, :KEEPALIVE, 1)
# => #<Socket::Option: INET SOCKET KEEPALIVE "\x01">
```

### def Socket::Option.ipv4_multicast_loop(integer) -> Socket::Option

IPPROTO_IP/IP_MULTICAST_LOOP 用の `Socket::Option` オブジェクトを新たに生成し返します。

- **param** `integer` -- データ(整数)

```ruby
require 'socket'

p Socket::Option.ipv4_multicast_loop(1)
# => #<Socket::Option: INET IP MULTICAST_LOOP 1>
```

### def Socket::Option.ipv4_multicast_ttl(integer) -> Socket::Option

IPPROTO_IP/IP_MULTICAST_TTL 用の `Socket::Option` オブジェクトを新たに生成し返します。

- **param** `integer` -- データ(整数)

```ruby
require 'socket'

p Socket::Option.ipv4_multicast_ttl(10)
# => #<Socket::Option: INET IP MULTICAST_TTL 10>
```

## Instance Methods
### def family -> Integer

ソケットファミリを表す整数を返します。

### def level -> Integer

ソケットオプションレベルを表す整数を返します。

### def optname -> Integer

ソケットのオプション名を表す整数を返します。

### def data -> String
### def to_s -> String

オプションのデータ(内容)を文字列で返します。

内容が整数や真偽値、もしくは struct linger であることがわかっている場合には、
[m:Socket::Option#int], [m:Socket::Option#bool], [m:Socket::Option#linger]
を用いて

to_s は過去との互換性のために存在します。

### def int -> Integer

オプションのデータ(内容)を整数に変換して返します。

- **raise** `TypeError` -- dataのバイト数が不適切である(sizeof(int)と異なる)場合に発生します
- **SEE** [m:Socket::Option#data]

### def bool -> bool

オプションのデータ(内容)を真偽値に変換して返します。

- **raise** `TypeError` -- dataのバイト数が不適切である(sizeof(int)と異なる)場合に発生します
- **SEE** [m:Socket::Option#data]

### def linger -> [bool, Integer]

オプションが SOL_SOCKET/SO_LINGER である場合に、オプションのデータ(内容)を真偽値と整数のペアとして返します。

- **raise** `TypeError` -- dataのバイト数が不適切である(sizeof(struct linger)と異なる)場合や、
                 level/optname が SOL_SOCKET/SO_LINGER でないに発生します
- **SEE** [m:Socket::Option#data]

### def unpack(template) -> Array

data に対し [m:String#unpack] を呼び出し、その結果を返します。

このメソッドは過去との互換性のために存在します。

### def byte -> Integer

オプションのデータ(内容)を 1 バイトの整数に変換して返します。

- **raise** `TypeError` -- dataのバイト数が不適切である(sizeof(char)と異なる)場合に発生します
- **SEE** [m:Socket::Option#data]

### def ipv4_multicast_loop -> Integer

オプションが IPPROTO_IP/IP_MULTICAST_LOOP である場合に、オプションのデータ(内容)を整数に変換して返します。

- **raise** `TypeError` -- family が AF_INET でない、または level/optname が IPPROTO_IP/IP_MULTICAST_LOOP でない場合に発生します
- **SEE** [m:Socket::Option#data]

### def ipv4_multicast_ttl -> Integer

オプションが IPPROTO_IP/IP_MULTICAST_TTL である場合に、オプションのデータ(内容)を整数に変換して返します。

- **raise** `TypeError` -- family が AF_INET でない、または level/optname が IPPROTO_IP/IP_MULTICAST_TTL でない場合に発生します
- **SEE** [m:Socket::Option#data]

