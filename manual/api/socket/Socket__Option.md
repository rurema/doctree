---
library: socket
since: "1.9.2"
---
# class Socket::Option

[m:BasicSocket#getsockopt]、[m:BasicSocket#setsockopt] で
使うソケットオプションの値を表すクラス。

ソケットオプションの具体的な意味は
自身の使っているシステムのドキュメントを見てください。

## Class Methods
### def new(family, level, optname, data) -> Socket::Option

Socket::Option オブジェクト新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、
文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を
指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `data` -- データ(文字列)

- **SEE** [m:Socket::Option.int], [m:Socket::Option.bool], [m:Socket::Option.linger]

`````
require 'socket'

sockopt = Socket::Option.new(:INET, :SOCKET, :KEEPALIVE, [1].pack("i"))
p sockopt #=> #<Socket::Option: INET SOCKET KEEPALIVE 1>
`````

### def int(family, level, optname, integer) -> Socket::Option

整数をデータとして持つ Socket::Option オブジェクト新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、
文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を
指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `integer` -- データ(整数)

### def bool(family, level, optname, boolean) -> Socket::Option

整数をデータとして持つ Socket::Option オブジェクト新たに生成し返します。

family, level, optname には Socket::SOL_SOCKET のような整数の他、
文字列("SOL_SOCKET", "SOCKET")、シンボル(:SOL_SOCKET, :SOCKET)を
指定できます。

- **param** `family` -- ソケットファミリー
- **param** `level` -- ソケットオプションレベル
- **param** `optname` -- オプションの名前
- **param** `boolean` -- データ(真偽値)

`````
require 'socket'

p Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, true)
# => #<Socket::Option: INET SOCKET KEEPALIVE 1>

p Socket::Option.bool(:INET, :SOCKET, :KEEPALIVE, false)
# => #<Socket::Option: AF_INET SOCKET KEEPALIVE 0>
`````

### def linger(onoff, secs) -> Socket::Option
SOL_SOCKET/SO_LINGER 用の Socket::Option オブジェクト
を新たに生成し返します。

- **param** `onoff` -- 0/1もしくは真偽値
- **param** `secs` -- 整数値

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
オプションが SOL_SOCKET/SO_LINGER である場合に、
オプションのデータ(内容)を真偽値と整数のペアとして返します。

- **raise** `TypeError` -- dataのバイト数が不適切である(sizeof(struct linger)と異なる)場合や、
                 level/optname が SOL_SOCKET/SO_LINGER でないに発生します
- **SEE** [m:Socket::Option#data]

### def unpack(template) -> Array
data に対し [m:String#unpack] を呼び出し、その結果を返します。

このメソッドは過去との互換性のために存在します。
