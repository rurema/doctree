category Network

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

  * [[RFC:3513]]

== Class Methods

--- new(addr = '::', family = Socket::AF_UNSPEC) -> IPAddr

新しい IPAddr オブジェクトを生成します。

@param addr 0 から [[m:IPAddr::IN6MASK]] までの数値を受け取ります。 
            また、'address', 'address/prefixlen', 'address/mask' の形式も受け付けます。
            プリフィックス長やマスクが指定されると、
            マスクされた IPAddr オブジェクトを返します。
            IPv6 アドレスの場合は、[ ] で囲まれていてもかまいません。

@param family family は自動的に判定されますが、明示的に指定することもできます。

@raise ArgumentError family が Socket::AF_UNSPEC の場合に発生します。

@raise ArgumentError family にサポートされていない address family を指定した場合に発生します。


--- new_ntoh(addr) -> IPAddr

ネットワークバイトオーダーのバイト列から IPAddr オブジェクトを生成します。

@param addr ネットワークバイトオーダーのバイト列。

例:

  require 'ipaddr'
  p IPAddr.new_ntoh("\300\250\001\001")   # => <IPAddr: IPv4:192.168.1.1/255.255.255.255>

--- ntop(addr) -> String

ネットワークバイトオーダーのバイト列で表現された IP アドレスを人間の読める形式に変換します。

@param addr ネットワークバイトオーダーのバイト列。


== Instance Methods

--- &(ipaddr) -> IPAddr

他の IPAddr オブジェクトとのビットごとの論理積により、
新しい IPAddr オブジェクトを生成します。

@param ipaddr 他の IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

--- |(ipaddr) -> IPAddr

他の IPAddr オブジェクトとのビットごとの論理和により、
新しい IPAddr オブジェクトを生成します。

@param ipaddr 他の IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

--- ~ -> IPAddr

ビットごとの論理否定により、新しい IPAddr オブジェクトを生成します。

--- >>(num) -> IPAddr

ビットごとの右シフト演算により、新しい IPAddr オブジェクトを生成します。

@param num 右シフトする桁数。

--- <<(num) -> IPAddr

ビットごとの左シフト演算により、新しい IPAddr オブジェクトを生成します。

@param num 左シフトする桁数。


--- ==(ipaddr) -> bool

IPAddr オブジェクト同士が等しいかを比較します。

@param ipaddr 比較対象の IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

例:

  require "ipaddr"
  p IPAddr.new("192.168.0.1") == IPAddr.new("192.168.0.1/24")   # => false

--- mask(prefixlen)  -> IPAddr

マスクされた新しい IPAddr オブジェクトを返します。
引数にはプリフィックス長とマスクの両方を受け付けます
(e.g. 8, 64, "255.255.255.0")。

@param prefixlen プリフィックス長またはマスクを表す数値か文字列。

--- include?(ipaddr) -> bool
--- ===(ipaddr)      -> bool

与えられた IPAddr オブジェクトが自身の範囲に入っているかを判定します。

@param ipaddr 範囲に入っているかどうか調べる対象となる IPAddr オブジェクト。
              また、数値や文字列も受け付けます。

--- to_i -> Integer

整数に変換します。

例:

  require "ipaddr"
  p IPAddr.new("0.0.1.0").to_i   # => 256

--- to_s -> String

文字列に変換します。

  require 'ipaddr'
  addr6 = IPAddr.new('::1')
  addr6.to_s       #=> "::1"
  addr6.to_string  #=> "0000:0000:0000:0000:0000:0000:0000:0001"

@see [[m:IPAddr#to_string]]

--- to_string -> String

標準的な文字列表現に変換します。

  require 'ipaddr'
  addr6 = IPAddr.new('::1')
  addr6.to_s       #=> "::1"
  addr6.to_string  #=> "0000:0000:0000:0000:0000:0000:0000:0001"

@see [[m:IPAddr#to_s]]

--- hton -> String

ネットワークオーダーのバイト列に変換します。

--- ipv4? -> bool

IPv4 なら真を返します。

--- ipv6? -> bool

IPv6 なら真を返します。

--- ipv4_mapped? -> bool

IPv4 射影 IPv6 アドレスなら 真を返します。

--- ipv4_compat? -> bool

IPv4 互換 IPv6 アドレスなら 真を返します。

--- ipv4_mapped -> IPAddr

IPv4 アドレスから IPv4 射影 IPv6 アドレスの
新しい IPAddr オブジェクトを返します。

--- ipv4_compat -> IPAddr

IPv4 アドレスから IPv4 互換 IPv6 アドレスの
新しい IPAddr オブジェクトを返します。

--- native -> self | IPAddr

IPv4 射影 IPv6 アドレスや IPv4 互換 IPv6 アドレスから、
IPv4 アドレスの新しい IPAddr オブジェクトを返します。
IPv4 互換でも IPv4 組み込みでもないなら self を返します。

例:

  require "ipaddr"
  p IPAddr.new("0000:0000:0000:0000:0000:ffff:c0a8:0001").native
      # => #<IPAddr: IPv4:192.168.0.1/255.255.255.255>

--- reverse -> String

DNS 逆引きのための文字列を返します。
IPv6 なら [[RFC:3172]] で定義された形式で返します。

例:

  require "ipaddr"
  p IPAddr.new("192.168.0.1").reverse   # => "1.0.168.192.in-addr.arpa"

--- ip6_arpa -> String

IPv6 なら [[RFC:3172]] で定義された形式で DNS 逆引きのための文字列を返します。
IPv4 の場合は例外を発生します。

--- ip6_int -> String

IPv6 なら [[RFC:1886]] 互換形式で DNS 逆引きのための文字列を返します。
IPv4 の場合は例外を発生します。

--- inspect -> String

オブジェクトを人間が読める形式に変換した文字列を返します。

--- family -> Integer

このオブジェクトのアドレスファミリを返します。

@see [[c:Socket]]

--- <=>(other) -> Integer | nil

self と other を比較します。

@param other 比較対象の IPAddr オブジェクト。

@return self と other のアドレスファミリが一致しない場合は nil を返します。
        アドレスファミリが一致する場合は、両方の数値表現を [[m:Integer#<=>]]
        で比較した結果を返します。

@see [[m:Integer#<=>]]

--- succ -> IPAddr

次の IPAddr オブジェクトを返します。

  require 'ipaddr'
  ipaddr = IPAddr.new('192.168.1.1')
  p ipaddr.succ.to_s #=> "192.168.1.2"

--- to_range -> Range

self の IP アドレスとサブネットマスクで取得できる IP アドレスの範囲を
[[c:Range]] オブジェクトとして返します。

例:

  require 'ipaddr'
  IPAddr.new('192.168.1.1').to_range
  #=> #<IPAddr: IPv4:192.168.1.1/255.255.255.255>..#<IPAddr: IPv4:192.168.1.1/255.255.255.255>
  IPAddr.new('::1').to_range
  #=> #<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>..
  #   #<IPAddr: IPv6:0000:0000:0000:0000:0000:0000:0000:0001/ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>


#@since 1.9.2
--- eql?(other) -> bool

自身が other と等しい場合は真を返します。
そうでない場合は偽を返します。

@see [[m:Object#eql?]]

--- hash -> Integer

ハッシュ値を返します。

@see [[m:Object#hash]]

#@end

== Protected Instance Methods

--- set(addr, *family) -> self

このオブジェクトの IP アドレスとアドレスファミリをセットして自身を返します。

@param addr セットする IP アドレスの数値表現。

@param family セットするアドレスファミリ。

--- mask!(mask) -> self

与えられた mask を使用してこのオブジェクトの IP アドレスを破壊的に変更します。

@param mask プレフィックス長を表す文字列か、サブネットマスクを表す文字列。

== Constants

--- IN4MASK -> Integer

IPv4 アドレスの場合に使用するマスク値。

  0xffffffff

--- IN6MASK -> Integer

IPv6 アドレスの場合に使用するマスク値。

  0xffffffffffffffffffffffffffffffff

--- IN6FORMAT -> String

IPv6 アドレスをわかりやすく表示するためのフォーマット文字列。

  "%.4x:%.4x:%.4x:%.4x:%.4x:%.4x:%.4x:%.4x"

