---
type: library
category: Network
---
IPアドレスを扱うライブラリです。

# class IPAddr < Object

IP アドレスを表すクラスです。IPv4 と IPv6 のどちらのアドレスも表せます。

```ruby title="例"
require 'ipaddr'
  
ipaddr1 = IPAddr.new("3ffe:505:2::1")
p ipaddr1   # => #<IPAddr: IPv6:3ffe:0505:0002:0000:0000:0000:0000:0001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>
  
ipaddr3 = IPAddr.new("192.168.2.0/24")
p ipaddr3   # => #<IPAddr: IPv4:192.168.2.0/255.255.255.0>
```

### 参照

  - [RFC:3513]

## Class Methods

### def IPAddr.new(addr = '::', family = Socket::AF_UNSPEC) -> IPAddr

新しい IPAddr オブジェクトを生成します。

- **param** `addr` -- 0 から [m:IPAddr::IN6MASK] までの数値を受け取ります。 
            また、'address', 'address/prefixlen', 'address/mask' の形式も受け付けます。
            プリフィックス長やマスクが指定されると、マスクされた IPAddr オブジェクトを返します。
            IPv6 アドレスの場合は、[ ] で囲まれていてもかまいません。

- **param** `family` -- family は自動的に判定されますが、明示的に指定することもできます。

- **raise** `ArgumentError` -- family が Socket::AF_UNSPEC の場合に発生します。

- **raise** `ArgumentError` -- family にサポートされていない address family を指定した場合に発生します。

### def IPAddr.new_ntoh(addr) -> IPAddr

ネットワークバイトオーダーのバイト列から IPAddr オブジェクトを生成します。

- **param** `addr` -- ネットワークバイトオーダーのバイト列。

```ruby title="例"
require 'ipaddr'
p IPAddr.new_ntoh("\300\250\001\001")   # => <IPAddr: IPv4:192.168.1.1/255.255.255.255>
```

### def IPAddr.ntop(addr) -> String

ネットワークバイトオーダーのバイト列で表現された IP アドレスを人間の読める形式に変換します。

- **param** `addr` -- ネットワークバイトオーダーのバイト列。

## Instance Methods

### def &(ipaddr) -> IPAddr

他の IPAddr オブジェクトとのビットごとの論理積により、新しい IPAddr オブジェクトを生成します。

- **param** `ipaddr` -- 他の IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

### def |(ipaddr) -> IPAddr

他の IPAddr オブジェクトとのビットごとの論理和により、新しい IPAddr オブジェクトを生成します。

- **param** `ipaddr` -- 他の IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

### def ~ -> IPAddr

ビットごとの論理否定により、新しい IPAddr オブジェクトを生成します。

### def >>(num) -> IPAddr

ビットごとの右シフト演算により、新しい IPAddr オブジェクトを生成します。

- **param** `num` -- 右シフトする桁数。

### def <<(num) -> IPAddr

ビットごとの左シフト演算により、新しい IPAddr オブジェクトを生成します。

- **param** `num` -- 左シフトする桁数。

### def ==(ipaddr) -> bool

IPAddr オブジェクト同士が等しいかを比較します。

- **param** `ipaddr` -- 比較対象の IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.0.1") == IPAddr.new("192.168.0.1/24")   # => false
```

### def mask(prefixlen)  -> IPAddr

マスクされた新しい IPAddr オブジェクトを返します。
引数にはプリフィックス長とマスクの両方を受け付けます
(e.g. 8, 64, "255.255.255.0")。

- **param** `prefixlen` -- プリフィックス長またはマスクを表す数値か文字列。

### def include?(ipaddr) -> bool
### def ===(ipaddr)      -> bool

与えられた IPAddr オブジェクトが自身の範囲に入っているかを判定します。

- **param** `ipaddr` -- 範囲に入っているかどうか調べる対象となる IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

### def to_i -> Integer

整数に変換します。

```ruby title="例"
require "ipaddr"
p IPAddr.new("0.0.1.0").to_i   # => 256
```

### def to_s -> String

文字列に変換します。

```ruby
require 'ipaddr'
addr6 = IPAddr.new('::1')
p addr6.to_s     # => "::1"
p addr6.to_string  # => "0000:0000:0000:0000:0000:0000:0000:0001"
```

- **SEE** [m:IPAddr#to_string]

### def to_string -> String

標準的な文字列表現に変換します。

```ruby
require 'ipaddr'
addr6 = IPAddr.new('::1')
p addr6.to_s     # => "::1"
p addr6.to_string  # => "0000:0000:0000:0000:0000:0000:0000:0001"
```

- **SEE** [m:IPAddr#to_s]

### def hton -> String

ネットワークオーダーのバイト列に変換します。

### def ipv4? -> bool

IPv4 なら真を返します。

### def ipv6? -> bool

IPv6 なら真を返します。

### def ipv4_mapped? -> bool

IPv4 射影 IPv6 アドレスなら 真を返します。

### def ipv4_compat? -> bool

IPv4 互換 IPv6 アドレスなら 真を返します。

### def ipv4_mapped -> IPAddr

IPv4 アドレスから IPv4 射影 IPv6 アドレスの新しい IPAddr オブジェクトを返します。

### def ipv4_compat -> IPAddr

IPv4 アドレスから IPv4 互換 IPv6 アドレスの新しい IPAddr オブジェクトを返します。

### def native -> self | IPAddr

IPv4 射影 IPv6 アドレスや IPv4 互換 IPv6 アドレスから、
IPv4 アドレスの新しい IPAddr オブジェクトを返します。
IPv4 互換でも IPv4 組み込みでもないなら self を返します。

```ruby title="例"
require "ipaddr"
p IPAddr.new("0000:0000:0000:0000:0000:ffff:c0a8:0001").native
    # => #<IPAddr: IPv4:192.168.0.1/255.255.255.255>
```

### def prefix -> Integer

プリフィックス長をビット数で返します。

### def prefix=(prefixlen)

プリフィックス長を prefixlen に設定します。

- **param** `prefixlen` -- 設定したいプリフィックス長をビット数で指定します。

- **raise** `IPAddr::InvalidPrefixError` -- 引数 prefixlen に整数以外のオブジェクトを指定した場合に発生します。

### def reverse -> String

DNS 逆引きのための文字列を返します。
IPv6 なら [RFC:3172] で定義された形式で返します。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.0.1").reverse   # => "1.0.168.192.in-addr.arpa"
```

### def ip6_arpa -> String

IPv6 なら [RFC:3172] で定義された形式で DNS 逆引きのための文字列を返します。
IPv4 の場合は例外を発生します。

### def ip6_int -> String

IPv6 なら [RFC:1886] 互換形式で DNS 逆引きのための文字列を返します。
IPv4 の場合は例外を発生します。

### def inspect -> String

オブジェクトを人間が読める形式に変換した文字列を返します。

### def family -> Integer

このオブジェクトのアドレスファミリを返します。

- **SEE** [c:Socket]

### def <=>(other) -> -1 | 0 | 1 | nil

self と other を比較します。

- **param** `other` -- 比較対象の IPAddr オブジェクト。

- **return** -- self と other のアドレスファミリが一致しない場合は nil を返します。
        アドレスファミリが一致する場合は、両方の数値表現を [m:Integer#<=>]
        で比較した結果を返します。

- **SEE** [m:Integer#<=>]

### def succ -> IPAddr

次の IPAddr オブジェクトを返します。

```ruby
require 'ipaddr'
ipaddr = IPAddr.new('192.168.1.1')
p ipaddr.succ.to_s # => "192.168.1.2"
```

### def to_range -> Range

self の IP アドレスとサブネットマスクで取得できる IP アドレスの範囲を
[c:Range] オブジェクトとして返します。

```ruby title="例"
require 'ipaddr'
p IPAddr.new('192.168.1.1').to_range
# => #<IPAddr: IPv4:192.168.1.1/255.255.255.255>..#<IPAddr: IPv4:192.168.1.1/255.255.255.255>
p IPAddr.new('::1').to_range
# => #<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>..
#   #<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>
```

### def eql?(other) -> bool

自身が other と等しい場合は真を返します。
そうでない場合は偽を返します。

- **SEE** [m:Object#eql?]

### def hash -> Integer

ハッシュ値を返します。

- **SEE** [m:Object#hash]

#%since 4.0
### def +(offset) -> IPAddr

`self` のアドレス部分に `offset` を足した新しい IPAddr オブジェクトを返します。プリフィックス長(サブネットマスク)は `self` と同じ値のまま保持されます。

- **param** `offset` -- 足し合わせる整数のオフセットです。

- **raise** `IPAddr::InvalidAddressError` -- 演算結果のアドレスが有効な範囲(IPv4 なら 0 から [m:IPAddr::IN4MASK]、IPv6 なら 0 から [m:IPAddr::IN6MASK])を外れた場合に発生します。

```ruby title="例"
require "ipaddr"
ip = IPAddr.new("192.168.1.1")
p (ip + 1).to_s   # => "192.168.1.2"

net = IPAddr.new("192.168.1.0/24")
p (net + 1)       # => #<IPAddr: IPv4:192.168.1.1/255.255.255.0>
```

- **SEE** [m:IPAddr#-]

#%end

#%since 4.0
### def -(offset) -> IPAddr

`self` のアドレス部分から `offset` を引いた新しい IPAddr オブジェクトを返します。プリフィックス長(サブネットマスク)は `self` と同じ値のまま保持されます。

- **param** `offset` -- 引く整数のオフセットです。

- **raise** `IPAddr::InvalidAddressError` -- 演算結果のアドレスが有効な範囲(IPv4 なら 0 から [m:IPAddr::IN4MASK]、IPv6 なら 0 から [m:IPAddr::IN6MASK])を外れた場合に発生します。

```ruby title="例"
require "ipaddr"
ip = IPAddr.new("192.168.1.1")
p (ip - 1).to_s   # => "192.168.1.0"
```

- **SEE** [m:IPAddr#+]

#%end

### def loopback? -> bool

`self` がループバックアドレスなら真を返します。IPv4 の 127.0.0.0/8 と IPv6 の ::1 がループバックアドレスとみなされます。IPv4 射影 IPv6 アドレス範囲内のループバックな IPv4 アドレスもループバックとみなされます。

```ruby title="例"
require "ipaddr"
p IPAddr.new("127.0.0.1").loopback?    # => true
p IPAddr.new("::1").loopback?          # => true
p IPAddr.new("192.168.1.1").loopback?  # => false
```

### def private? -> bool

`self` がプライベートアドレスなら真を返します。[RFC:1918] で定義された IPv4 の 10.0.0.0/8、172.16.0.0/12、192.168.0.0/16 と、[RFC:4193] で定義された IPv6 のユニークローカルアドレス fc00::/7 がプライベートアドレスとみなされます。IPv4 射影 IPv6 アドレス範囲内のプライベートな IPv4 アドレスもプライベートとみなされます。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.1.1").private?  # => true
p IPAddr.new("10.1.2.3").private?     # => true
p IPAddr.new("8.8.8.8").private?      # => false
p IPAddr.new("fc00::1").private?      # => true
```

### def link_local? -> bool
#%since 4.1
### def link_local_unicast? -> bool

#%end

`self` がリンクローカルアドレスなら真を返します。[RFC:3927] で予約された IPv4 の 169.254.0.0/16 と、[RFC:4291] で予約された IPv6 のリンクローカルユニキャストアドレス fe80::/10 がリンクローカルとみなされます。IPv4 射影 IPv6 アドレス範囲内のリンクローカルな IPv4 アドレスもリンクローカルとみなされます。

#%since 4.1
`link_local_unicast?` は `link_local?` の別名です。

#%end

```ruby title="例"
require "ipaddr"
p IPAddr.new("169.254.1.1").link_local?  # => true
p IPAddr.new("fe80::1").link_local?      # => true
p IPAddr.new("192.168.1.1").link_local?  # => false
```

#%since 4.1
### def multicast? -> bool

`self` がマルチキャストアドレスなら真を返します。IPv4 の 224.0.0.0/4 と IPv6 の ff00::/8 がマルチキャストとみなされます。IPv4 射影 IPv6 アドレス範囲内のマルチキャストな IPv4 アドレスもマルチキャストとみなされます。

- **SEE** [m:IPAddr#link_local_multicast?]

#%end

#%since 4.1
### def link_local_multicast? -> bool

`self` がリンクローカルマルチキャストアドレスなら真を返します。IPv4 の 224.0.0.0/24(Local Network Control Block)と IPv6 の ff02::/16 がリンクローカルマルチキャストとみなされます。IPv4 射影 IPv6 アドレス範囲内のリンクローカルマルチキャストな IPv4 アドレスもリンクローカルマルチキャストとみなされます。

- **SEE** [m:IPAddr#multicast?]

#%end

#%since 3.1
### def netmask -> String

サブネットマスクを文字列表現で返します(例: 255.255.0.0)。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.0.0/16").netmask       # => "255.255.0.0"
p IPAddr.new("2001:db8::/32").netmask        # => "ffff:ffff:0000:0000:0000:0000:0000:0000"
```

#%since 3.4
- **SEE** [m:IPAddr#wildcard_mask]

#%end

#%end

#%since 3.4
### def wildcard_mask -> String

ワイルドカードマスク([m:IPAddr#netmask] のビットごとの論理否定)を文字列表現で返します(例: 0.0.255.255)。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.0.0/16").wildcard_mask  # => "0.0.255.255"
```

- **SEE** [m:IPAddr#netmask]

#%end

#%since 3.4
### def cidr -> String

`self` を CIDR 表記(`アドレス/プリフィックス長`)の文字列に変換します。ホストアドレスであってもプリフィックス長を省略しません。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.1.1").cidr      # => "192.168.1.1/32"
p IPAddr.new("192.168.1.0/24").cidr   # => "192.168.1.0/24"
```

- **SEE** [m:IPAddr#to_s], [m:IPAddr#to_string]

#%end

#%since 3.4
### def as_json(*args) -> String

JSON 形式に変換する際に使われる、`self` を表す文字列を返します。

IPv4 アドレスでプリフィックス長が 32 の場合、または IPv6 アドレスでプリフィックス長が 128 の場合は [m:IPAddr#to_s] と同じ文字列を返します。それ以外の場合は [m:IPAddr#cidr] と同じ CIDR 表記の文字列を返します。

- **param** `args` -- JSON ライブラリとの互換性のために受け取りますが、使用されません。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.1.1").as_json      # => "192.168.1.1"
p IPAddr.new("192.168.1.0/24").as_json   # => "192.168.1.0/24"
```

- **SEE** [m:IPAddr#to_json], [m:IPAddr#cidr], [m:IPAddr#to_s]

#%end

#%since 3.4
### def to_json(*args) -> String

`self` を JSON 形式の文字列に変換して返します。内部で [m:IPAddr#as_json] を呼び出し、その結果を二重引用符で囲んだ文字列を返します。

- **param** `args` -- JSON ライブラリとの互換性のために受け取りますが、使用されません。

```ruby title="例"
require "ipaddr"
p IPAddr.new("192.168.1.1").to_json      # => "\"192.168.1.1\""
p IPAddr.new("192.168.1.0/24").to_json   # => "\"192.168.1.0/24\""
```

- **SEE** [m:IPAddr#as_json]

#%end

#%since 3.1
### def zone_id -> String | nil
### def zone_id=(zid)

IPv6 アドレスのゾーン ID を取得・設定します。ゾーン ID は `"%eth0"` のように `%` から始まる文字列で、リンクローカルアドレスなどで通信に使うネットワークインターフェースを指定するために使われます。

- **param** `zid` -- 設定するゾーン ID です。`%` で始まる文字列か、ゾーン ID を削除する場合は nil を指定します。

- **return** -- ゾーン ID が設定されていない場合は nil を返します。

- **raise** `IPAddr::InvalidAddressError` -- `self` が IPv6 アドレスでない場合に発生します(取得・設定のどちらでも発生します)。

- **raise** `IPAddr::InvalidAddressError` -- `zone_id=` において、`zid` が nil でも `%` から始まる文字列でもない場合に発生します。

```ruby title="例"
require "ipaddr"
a = IPAddr.new("fe80::1%eth0")
p a.zone_id            # => "%eth0"

b = IPAddr.new("fe80::1")
b.zone_id = "%eth1"
p b.zone_id            # => "%eth1"
p b.to_s               # => "fe80::1%eth1"
```

- **SEE** [m:IPAddr#to_s]

#%end

## Protected Instance Methods

### def set(addr, *family) -> self

このオブジェクトの IP アドレスとアドレスファミリをセットして自身を返します。

- **param** `addr` -- セットする IP アドレスの数値表現。

- **param** `family` -- セットするアドレスファミリ。

### def mask!(mask) -> self

与えられた mask を使用してこのオブジェクトの IP アドレスを破壊的に変更します。

- **param** `mask` -- プレフィックス長を表す文字列か、サブネットマスクを表す文字列。

## Constants

### const IN4MASK -> Integer

IPv4 アドレスの場合に使用するマスク値。

```ruby
0xffffffff
```

### const IN6MASK -> Integer

IPv6 アドレスの場合に使用するマスク値。

```ruby
0xffffffffffffffffffffffffffffffff
```

### const IN6FORMAT -> String

IPv6 アドレスをわかりやすく表示するためのフォーマット文字列。

```ruby
"%.4x:%.4x:%.4x:%.4x:%.4x:%.4x:%.4x:%.4x"
```

