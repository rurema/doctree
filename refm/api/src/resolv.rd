#@if (version >= "1.6.0")
= class Resolv < Object

Ruby で書かれたリゾルバ(名前解決)ライブラリ。
Ruby で書かれているため thread-aware であり、
並列に多くのホスト名を解決することができます。

DNS モジュールを使うことで、さまざまなリソースを直接ルックアップできます。

なお、単にホスト名から IP アドレスを得たいだけであれば、
[[lib:socket]] ライブラリの [[m:IPSocket.getaddress]] などが使用できます。

[[unknown:執筆者募集]]

=== 例:
  Resolv.getaddress("www.ruby-lang.org")
  Resolv.getname("210.251.121.214").to_s
  Resolv::DNS.new.getresources("www.ruby-lang.org", Resolv::DNS::Resource::IN::A).collect {|r| r.address}
  Resolv::DNS.new.getresources("ruby-lang.org", Resolv::DNS::Resource::IN::MX).collect {|r| [r.exchange.to_s, r.preference]}


=== Bugs
#@#NIS is not supported.
NIS はサポートされていません。

== Class Methods
--- new(resolvers = [Hosts.new, DNS.new])

#@todo

--- getaddress(name)
--- getaddresses(name)
--- each_address(name) {|address| ...}

String のホスト名 name の IP アドレスをルックアップします。

getaddress はルックアップ結果の最初のアドレスを返します。
getaddresses はルックアップ結果のアドレスリストを返します。
each_address はルックアップ結果のアドレスに対するイテレータです。

例:
  Resolv.getaddress("www.ruby-lang.org").to_s #=> "210.251.121.214"

--- getname(address)
--- getnames(address)
--- each_name(address) {|name| ...}

String の IP アドレス address のホスト名をルックアップします。

getname はルックアップ結果の最初のホスト名を返します。
getnames はルックアップ結果のホスト名リストを返します。
each_name はルックアップ結果のアドレスに対するイテレータです。

例:
  Resolv.getname("210.251.121.214").to_s #=> "helium.ruby-lang.org"

== Instance Methods

--- getaddress(name)
--- getaddresses(name)
--- each_address(name) {|name| ...}

String のホスト名 name の IP アドレスをルックアップします。

それぞれ[[m:Resolv.getaddress]], [[m:Resolv.getaddresses]], 
[[m:Resolv.each_address]] と同じ機能です。

--- getname(address)
--- getnames(address)
--- each_name(address) {|name| ...}

String の IP アドレス address のホスト名をルックアップします。

それぞれ[[m:Resolv.getname]], [[m:Resolv.getnames]], 
[[m:Resolv.each_name]] と同じ機能です。

= class Resolv::Hosts < Object

/etc/hosts を使用するホスト名リゾルバです。

== Class Methods

--- new(hosts = '/etc/hosts')

== Instance Methods
--- getaddress(name)
--- getaddresses(name)
--- each_address(name) {|address| ...}

address lookup methods.

--- getname(address)
--- getnames(address)
--- each_name(address) {|name| ...}

hostnames lookup methods.

= class Resolv::DNS < Object

DNS stub resolver.

== Class Methods
--- new(resolv_conf = '/etc/resolv.conf')

== Instance Methods
--- getaddress(name)
--- getaddresses(name)
--- each_address(name) {|address| ...}

address lookup methods.

name は Resolv::Name または String でなければなりません。
ルックアップ結果は Resolv::IPv4 または Resolv::IPv6 のインスタンスとなります。

--- getname(address)
--- getnames(address)
--- each_name(address) {|name| ...}

hostnames lookup methods.

address は Resolv::IPv4, Resolv::IPv6, String のいずれかでなければなりません。
ルックアップ結果は Resolv::Name のインスタンスとなります。

--- getresource(name, typeclass)
--- getresources(name, typeclass)
--- each_resource(name, typeclass) {|resource| ...}

They lookup DNS resources of name.
name は Resolv::Name または String でなければなりません。

typeclass は以下のいずれかです。
  * Resolv::DNS::Resource::IN::ANY
  * Resolv::DNS::Resource::IN::NS
  * Resolv::DNS::Resource::IN::CNAME
  * Resolv::DNS::Resource::IN::SOA
  * Resolv::DNS::Resource::IN::HINFO
  * Resolv::DNS::Resource::IN::MINFO
  * Resolv::DNS::Resource::IN::MX
  * Resolv::DNS::Resource::IN::TXT
  * Resolv::DNS::Resource::IN::ANY
  * Resolv::DNS::Resource::IN::A
  * Resolv::DNS::Resource::IN::WKS
  * Resolv::DNS::Resource::IN::PTR
  * Resolv::DNS::Resource::IN::AAAA

ルックアップ結果は Resolv::DNS::Resource （のサブクラス）のインスタンスとなります。

= class Resolv::DNS::Resource::IN::NS < Resolv::DNS::Resource::NS

== Instance Methods

--- name

= class Resolv::DNS::Resource::IN::CNAME < Resolv::DNS::Resource::CNAME

== Instance Methods

--- name

= class Resolv::DNS::Resource::IN::SOA < Resolv::DNS::Resource::SOA

== Instance Methods

--- mname

--- rname

--- serial

--- refresh

--- retry

--- expire

--- minimum

= class Resolv::DNS::Resource::IN::HINFO < Resolv::DNS::Resource::HINFO

== Instance Methods

--- cpu

--- os

= class Resolv::DNS::Resource::IN::MINFO < Resolv::DNS::Resource::MINFO

== Instance Methods

--- rmailbx

--- emailbx

= class Resolv::DNS::Resource::IN::MX < Resolv::DNS::Resource::MX

== Instance Methods

--- preference

--- exchange

= class Resolv::DNS::Resource::IN::TXT < Resolv::DNS::Resource::TXT

== Instance Methods

--- data

= class Resolv::DNS::Resource::IN::A < Resolv::DNS::Resource::A

== Instance Methods

--- address

= class Resolv::DNS::Resource::IN::WKS < Resolv::DNS::Resource::WKS

== Instance Methods

--- address

--- protocol

--- bitmap

= class Resolv::DNS::Resource::IN::PTR < Resolv::DNS::Resource::PTR

== Instance Methods

--- name

= class Resolv::DNS::Resource::IN::AAAA < Resolv::DNS::Resource::AAAA

== Instance Methods

--- address

= class Resolv::DNS::Name < Object

== Class Methods

--- create(name)

== Instance Methods

--- to_s

= class Resolv::DNS::Resource < Object

= class Resolv::IPv4 < Object

== Class Methods

--- create(address)

== Instance Methods

--- to_s
--- to_name

== Constants

--- Regex
#@#    regular expression for IPv4 address.

IPv4 のアドレスの正規表現です。

= class Resolv::IPv6 < Object

== Class Methods

--- create(address)

== Instance Methods

--- to_s
--- to_name

== Constants

--- Regex
#@#    regular expression for IPv6 address.
IPv6のアドレスの正規表現です。

#@end
