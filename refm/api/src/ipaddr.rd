#@since 1.8.0
IPアドレスを扱うライブラリです。

= class IPAddr < Object

IP アドレスを扱うのためのクラスです。

例:

  require 'ipaddr'
  
  ipaddr1 = IPAddr.new("3ffe:505:2::1")
  p ipaddr1   # => #<IPAddr: IPv6:3ffe:0505:0002:0000:0000:0000:0000:0001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>
  
  ipaddr3 = IPAddr.new("192.168.2.0/24")
  p ipaddr3   # => #<IPAddr: IPv4:192.168.2.0/255.255.255.0>

=== 参照

  * [[unknown:rfc:3513]]

== Class Methods

--- new(addr = '::', family = Socket::AF_UNSPEC)
#@todo

新しい IPAddr オブジェクトを生成します。
addr は `address/prefixlen' や 'address/mask' などの形式も受け付けます。
プリフィックス長やマスクが指定されると、
マスクされた IPAddr オブジェクトを返します。
IPv6 アドレスの場合は、[ ] で囲まれていてもかまいません。
family は自動的に判定されますが、明示的に指定することもできます。

--- new_ntoh(addr)
#@todo

ネットワークバイトオーダーのバイト列から IPAddr オブジェクトを生成します。

例:

  require 'ipaddr'
  p IPAddr.new_ntoh("\300\250\001\001")   # => <IPAddr: IPv4:192.168.1.1/255.255.255.255>

--- ntop(addr)
#@todo

ネットワークバイトオーダーのバイト列で表現された IP アドレスを人間の読める形式に変換します。

== Instance Methods

--- &(ipaddr)
#@todo

他の IPAddr オブジェクトとのビットごとの論理積により、
新しい IPAddr オブジェクトを生成します。

--- |(ipaddr)
#@todo

他の IPAddr オブジェクトとのビットごとの論理和により、
新しい IPAddr オブジェクトを生成します。

--- ~
#@todo

ビットごとの論理否定により、新しい IPAddr オブジェクトを生成します。
生成します。

--- >>(num)
#@todo

ビットごとの右シフト演算により、新しい IPAddr オブジェクトを生成します。

--- <<(num)
#@todo

ビットごとの左シフト演算により、新しい IPAddr オブジェクトを生成します。

--- ==(ipaddr)
#@todo

IPAddr オブジェクト同士が等しいかを比較します。

例:

  require "ipaddr"
  p IPAddr.new("192.168.0.1") == IPAddr.new("192.168.0.1/24")   # => false

--- mask(a)
#@todo

マスクされた新しい IPAddr オブジェクトを返します。
引数にはプリフィックス長とマスクの両方を受け付けます
(e.g. 8, 64, "255.255.255.0")。

--- include?(ipaddr)
--- ===(ipaddr)
#@todo

与えられた IPAddr オブジェクトが自身の範囲に入っているかを判定します。

--- to_i
#@todo

整数に変換します。

例:

  require "ipaddr"
  p IPAddr.new("0.0.1.0").to_i   # => 256

--- to_s
#@todo

文字列に変換します。

--- to_string
#@todo

標準的な文字列表現に変換します。

--- hton
#@todo

ネットワークオーダーのバイト列に変換します。

--- ipv4?
#@todo

IPv4 なら真を返します。

--- ipv6?
#@todo

IPv6 なら真を返します。

--- ipv4_mapped?
#@todo

IPv4 射影 IPv6 アドレスなら 真を返します。

--- ipv4_compat?
#@todo

IPv4 互換 IPv6 アドレスなら 真を返します。

--- ipv4_mapped
#@todo

IPv4 アドレスから IPv4 射影 IPv6 アドレスの
新しい IPAddr オブジェクトを返します。

--- ipv4_compat
#@todo

IPv4 アドレスから IPv4 互換 IPv6 アドレスの
新しい IPAddr オブジェクトを返します。

--- native
#@todo

IPv4 射影 IPv6 アドレスや IPv4 互換 IPv6 アドレスから、
IPv4 アドレスの新しい IPAddr オブジェクトを返します。
IPv4 互換でも IPv4 組み込みでもないなら self を返します。

例:

  require "ipaddr"
  p IPAddr.new("0000:0000:0000:0000:0000:ffff:c0a8:0001").native
      # => #<IPAddr: IPv4:192.168.0.1/255.255.255.255>

--- reverse
#@todo

DNS 逆引きのための文字列を返します。
IPv6 なら RFC3172 で定義された形式で返します。

例:

  require "ipaddr"
  p IPAddr.new("192.168.0.1").reverse   # => "1.0.168.192.in-addr.arpa"

--- ip6_arpa
#@todo

IPv6 なら RFC3172 で定義された形式で DNS 逆引きのための文字列を返します。
IPv4 の場合は例外を発生します。

--- ip6_int
#@todo

IPv6 なら RFC1886 互換形式で DNS 逆引きのための文字列を返します。
IPv4 の場合は例外を発生します。

--- inspect
#@todo

--- family
#@todo

== Protected Instance Methods

--- set(addr, *family)
#@todo

--- mask!(mask)
#@todo

== Constants

--- IN4MASK
#@todo

--- IN6MASK
#@todo

--- IN6FORMAT
#@todo

#@end
