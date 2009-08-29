#@if (version >= "1.6.0")
require socket
require timeout

DNSによる名前解決を行うライブラリです。 Ruby で書かれているため thread-aware であり、並列に多くのホスト名を解決することができます。

DNS モジュールを使うことで、さまざまなリソースを直接ルックアップできます。

なお、単にホスト名から IP アドレスを得たいだけであれば、
[[lib:socket]] ライブラリの [[m:IPSocket.getaddress]] などが使用できます。

=== 例:
  Resolv.getaddress("www.ruby-lang.org")
  Resolv.getname("210.251.121.214").to_s
  Resolv::DNS.new.getresources("www.ruby-lang.org", Resolv::DNS::Resource::IN::A).collect {|r| r.address}
  Resolv::DNS.new.getresources("ruby-lang.org", Resolv::DNS::Resource::IN::MX).collect {|r| [r.exchange.to_s, r.preference]}


=== Bugs
#@#NIS is not supported.
NIS はサポートされていません。


= class Resolv < Object
リゾルバを表すクラスです。
このクラス自体は実際には名前解決をせず、
[[m:Resolv.new]] で与えられたリゾルバに順に
問合せることしかしません。

このクラスのクラスメソッドで名前解決をした場合には、
内部で /etc/hosts, DNS の順に問合せます。

順に問合せる過程で、あるリゾルバが1個以上の
結果を返した場合、それ以降のリゾルバには
問い合わせをしません。

== Class Methods
--- new(resolvers = [Hosts.new, DNS.new]) -> Resolv
resolvers に与えたリゾルバの配列を先頭から順に
名前解決を試すような、新しいリソルバオブジェクトを返します。

resolvers の各要素は each_address と each_name という
メソッドを持っていなければなりません。

@param resolvers リゾルバの配列

--- getaddress(name) -> String
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果の最初のアドレスを返します。

ルックアップは /etc/hosts, DNS の順で行います。

  Resolv.getaddress("localhost") #=> "127.0.0.1"
  Resolv.getaddress("www.ruby-lang.org") #=> "221.186.184.68"

@param name ホスト名を文字列で与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getaddresses(name) -> [String]
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果のアドレスリストを返します。

ルックアップは /etc/hosts, DNS の順で行います。
ルックアップに失敗した場合は空の配列が返されます。

@param name ホスト名を文字列で与えます。

--- each_address(name) {|address| ...} -> ()
ホスト名 name の IP アドレスをルックアップし、
各ルックアップ結果のアドレスに対してブロックを評価します。

ルックアップは /etc/hosts, DNS の順で行います。

@param name ホスト名を文字列で与えます。

--- getname(address) -> String
IP アドレス address のホスト名をルックアップし、
ルックアップ結果の最初のホスト名を文字列で返します。

ルックアップは /etc/hosts, DNS の順で行います。

  Resolv.getname("221.186.184.68") #=> "carbon.ruby-lang.org"

@param address IPアドレスを文字列で与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getnames(address) -> [String]
IP アドレス address のホスト名をルックアップし、
ルックアップ結果のホスト名リストを返します。

ルックアップは /etc/hosts, DNS の順で行います。

@param address IPアドレスを文字列で与えます。

--- each_name(address) {|name| ...} -> ()
IP アドレス address のホスト名をルックアップし、
各ルックアップ結果のホスト名に対してブロックを評価します。

ルックアップは /etc/hosts, DNS の順で行います。

@param address IPアドレスを文字列で与えます。

== Instance Methods

--- getaddress(name) -> String
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果の最初のアドレスを返します。

@param name ホスト名を文字列で与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getaddresses(name) -> [String]
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果のアドレスリストを返します。

ルックアップに失敗した場合は空の配列が返されます。

@param name ホスト名を文字列で与えます。

--- each_address(name) {|name| ...} -> ()
ホスト名 name の IP アドレスをルックアップし、
各ルックアップ結果のアドレスに対してブロックを評価します。

@param name ホスト名を文字列で与えます。

--- getname(address) -> String
IP アドレス address のホスト名をルックアップし、
ルックアップ結果の最初のホスト名を文字列で返します。

@param address IPアドレスを文字列で与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getnames(address) -> [String]
IP アドレス address のホスト名をルックアップし、
ルックアップ結果のホスト名リストを返します。

@param address IPアドレスを文字列で与えます。

--- each_name(address) {|name| ...} -> ()
IP アドレス address のホスト名をルックアップし、
各ルックアップ結果のホスト名に対してブロックを評価します。

@param address IPアドレスを文字列で与えます。

== Constants

--- DefaultResolver
[[c:Resolv]] の各クラスメソッドを呼びだしたときに
利用されるリゾルバです。

--- ADDRESSREGEX
IPアドレスにマッチする正規表現です。

= class Resolv::ResolvError < StandardError
名前解決に失敗したときに発生する例外のクラスです。

= class Resolv::ResolvTimeout < TimeoutError
名前解決がタイムアウトしたときに発生する例外のクラスです。

= class Resolv::Hosts < Object

/etc/hosts (Windows であれば 
%SystemRoot%\System32\drivers\etc\hosts など)
を使用するホスト名リゾルバです。

== Class Methods

--- new(hosts = DefaultFileName) -> Resolv::Hosts
hosts というファイル名のファイルを情報源とする
リゾルバを生成し、返します。

@param hosts ホスト情報が書かれたファイルの名前を文字列で与えます。

== Instance Methods

--- getaddress(name) -> String
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果の最初のアドレスを返します。

@param name ホスト名を文字列で与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getaddresses(name) -> [String]
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果のアドレスリストを返します。

ルックアップに失敗した場合は空の配列が返されます。

@param name ホスト名を文字列で与えます。

--- each_address(name) {|name| ...} -> ()
ホスト名 name の IP アドレスをルックアップし、
各ルックアップ結果のアドレスに対してブロックを評価します。

@param name ホスト名を文字列で与えます。

--- getname(address) -> String
IP アドレス address のホスト名をルックアップし、
ルックアップ結果の最初のホスト名を文字列で返します。

@param address IPアドレスを文字列で与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getnames(address) -> [String]
IP アドレス address のホスト名をルックアップし、
ルックアップ結果のホスト名リストを返します。

@param address IPアドレスを文字列で与えます。

--- each_name(address) {|name| ...} -> ()
IP アドレス address のホスト名をルックアップし、
各ルックアップ結果のホスト名に対してブロックを評価します。

ルックアップは /etc/hosts, DNS の順で行います。

@param address IPアドレスを文字列で与えます。

--- lazy_initialize -> Resolv::Hosts

このメソッドはユーザが使うべきではありません。

== Constants

--- DefaultFileName

システム標準の、
ホスト情報が書かれたファイルの名前です。


= class Resolv::DNS < Object

このクラスは DNS を利用した名前解決をするリゾルバを
表します。

このクラスは実際には下位のクラスに処理を依頼します。

DNSについては以下を参照してください。
  * STD0013
  * [[RFC:1035]]
  * [[url:ftp://ftp.isi.edu/in-notes/iana/assignments/dns-parameters]]
  * etc.

== Class Methods

#@until 1.8.1
--- new(resolv_conf = '/etc/resolv.conf') -> Resolv::DNS
#@else
--- new(resolv_conf = nil) -> Resolv::DNS
#@end

新しい DNS リゾルバを生成します。

#@since 1.8.2
resolv_conf が nil の場合は
/etc/resolv.conf もしくはプラットフォーム固有の
DNS設定を利用します。
resolv_conf が文字列の場合は /etc/resolv.conf と
同じフォーマットのファイルを設定に利用します。
resolv_conf がハッシュの場合は、:nameserver, :search, :ndots
というキーが利用可能です。
それぞれの意味は [[man:resolv.conf(5)]] を参照してください。

   Resolv::DNS.new(:nameserver => ['210.251.121.21'],
                   :search => ['ruby-lang.org'],
                   :ndots => 1)
#@end

#@until 1.8.1
@param resolv_conf DNSの設定ファイル名を文字列で与えます
#@else
@param resolv_conf DNSの設定を与えます。
#@end

--- open(*args)
--- open(*args){|dns| ...}

新しい DNS リゾルバを生成します。
ブロックを与えた場合は生成したリゾルバでブロックを呼びだし、
ブロック終了時にリゾルバを閉じます。

ブロックを与えなかった場合は [[m:Resolv::DNS.new]] と
同じです。

@param args DNSの設定を与えます。意味は [[m:Resolv::DNS.new]] 
            の引数と同じです。

== Instance Methods

--- getaddress(name) -> Resolv::IPv4 | Resolv::IPv6
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果の最初のアドレスを返します。

@param name ホスト名を文字列もしくはResolv::Nameのインスタンスで与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getaddresses(name) -> [Resolv::IPv4 | Resolv::IPv6]
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果のアドレスリストを返します。

ルックアップに失敗した場合は空の配列が返されます。

@param name ホスト名を文字列もしくはResolv::Nameのインスタンスで与えます。

--- each_address(name) {|name| ...} -> ()
ホスト名 name の IP アドレスをルックアップし、
各ルックアップ結果のアドレスに対してブロックを評価します。

@param name ホスト名を文字列もしくはResolv::Nameのインスタンスで与えます。

--- getname(address) -> Resolv::Name
IP アドレス address のホスト名をルックアップし、
ルックアップ結果の最初のホスト名を返します。

@param address IPアドレスを文字列、 Resolv::IPv4 のインスタンス、
               Resolv::IPv6 のインスタンス、のいずれか与えます。
               
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getnames(address) -> [Resolv::Name]
IP アドレス address のホスト名をルックアップし、
ルックアップ結果のホスト名リストを返します。

@param address IPアドレスを文字列、 Resolv::IPv4 のインスタンス、
               Resolv::IPv6 のインスタンス、のいずれか与えます。

--- each_name(address) {|name| ...} -> ()
IP アドレス address のホスト名をルックアップし、
各ルックアップ結果のホスト名に対してブロックを評価します。

@param address IPアドレスを文字列、 Resolv::IPv4 のインスタンス、
               Resolv::IPv6 のインスタンス、のいずれか与えます。

--- getresource(name, typeclass) -> object
--- getresources(name, typeclass) -> [object]
--- each_resource(name, typeclass) {|resource| ...} -> ()

nameに対応するDNSリソースレコードを取得します。

getresource は最初に見つかったリソースを、
getresources は見つかったリソース全てを返します。
each_resource は見つかったリソースをブロックに渡します。

typeclass は以下のいずれかです。
  * Resolv::DNS::Resource::IN::ANY
  * Resolv::DNS::Resource::IN::NS
  * Resolv::DNS::Resource::IN::CNAME
  * Resolv::DNS::Resource::IN::SOA
  * Resolv::DNS::Resource::IN::HINFO
  * Resolv::DNS::Resource::IN::MINFO
  * Resolv::DNS::Resource::IN::MX
  * Resolv::DNS::Resource::IN::TXT
  * Resolv::DNS::Resource::IN::A
  * Resolv::DNS::Resource::IN::WKS
  * Resolv::DNS::Resource::IN::PTR
  * Resolv::DNS::Resource::IN::AAAA

ルックアップ結果は Resolv::DNS::Resource （のサブクラス）のインスタンスとなります。
typeclass に Resolv::DNS::Resource::IN::ANY 以外を指定した場合には
そのクラスのインスタンスを返します。

@param name ルックアップ対象となる名前を [[c:Resolv::Name]] または String で指定します。
@param typeclass レコード種別を指定します。
@raise Resolv::ResolvError getresourceでルックアップに失敗した場合に発生します。

--- close -> ()

DNSリゾルバを閉じます。

--- extract_resources(msg, name, typeclass) {|resource| ...}

このメソッドはユーザが使うべきではありません。

DNSサーバからの返答 msg を name と typeclass でフィルタリングし、
その結果をブロックに渡します。

@param msg DNSサーバからの返答を与えます。[[c:Resolv::DNS::Message]] のインスタンスを与えることができます。
@param name フィルタリングする名前を指定します。
@param typeclass フィルタリングするDNSレコード種別を表します。[[m:Resolv::DNS#getresource]] の typeclass と同じクラスを与えます。
--- lazy_initialize -> Resolv::DNS

このメソッドはユーザが使うべきではありません。

[[m:Resolv::DNS.new]] で与えた設定でインスタンスを実際に初期化します。

== Constants

--- DNSThreadGroup

この定数はユーザが使うべきではありません。

#@until 1.8.5
Resolv::DNS内部で利用される [[c:ThreadGroup]] です。
#@else
この定数はもはや利用されていません。
#@end

--- Port

デフォルトの DNS ポート番号です。

--- UDPSize

デフォルトの UDP パケットサイズです。

= class Resolv::DNS::Requester < Object

== Class Methods

--- new
#@todo

== Instance Methods

--- close
--- delete(arg)
#@todo

= class Resolv::DNS::Requester::Sender

== Class Methods

--- new(msg, data, sock, queue)
#@todo

== Instance Methods

--- recv(msg)
#@todo

--- queue
#@todo

= class Resolv::DNS::Requester::UnconnectedUDP < Resolv::DNS::Requester

== Class Methods

--- new
#@todo

== Instance Methods

--- sender(msg, data, queue, host, port = Port)
#@todo

= class Resolv::DNS::Requester::UnconnectedUDP::Sender < Resolv::DNS::Requester::Sender

== Class Methods

--- new(msg, data, sock, host, port, queue)
#@todo

== Instance Methods

--- send
#@todo

= class Resolv::DNS::Requester::ConnectedUDP < Resolv::DNS::Requester

== Class Methods

--- new(host, port = Port)
#@todo

== Instance Methods

--- sender(msg, data, queue, host = @host, port = @port)
#@todo

= class Resolv::DNS::Requester::ConnectedUDP::Sender < Resolv::DNS::Requester::Sender

== Instance Methods

--- send
#@todo

= class Resolv::DNS::Requester::TCP < Resolv::DNS::Requester

== Class Methods

--- new(host, port = Port)
#@todo

== Instance Methods

--- sender(msg, data, queue, host = @host, port = @port)
#@todo

= class Resolv::DNS::Requester::TCP::Sender < Resolv::DNS::Requester::Sender

== Instance Methods

--- send
#@todo

= class Resolv::DNS::Requester::RequestError < StandardError

= class Resolv::DNS::Resource::Generic < Resolv::DNS::Resource

== Class Methods

--- new(data)
#@todo

--- create(type_value, class_value)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- data
#@todo

--- encode_rdata(msg)
#@todo

= class Resolv::DNS::Resource::DomainName < Resolv::DNS::Resource

== Class Methods

--- new(name)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- name
#@todo

--- encode_rdata(msg)
#@todo

= class Resolv::DNS::Resource::NS < Resolv::DNS::Resource::DomainName

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::CNAME < Resolv::DNS::Resource::DomainName

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::SOA < Resolv::DNS::Resource

== Class Methods

--- new(mname, rname, serial, refresh, retry_, expire, minimum)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- mname
#@todo

--- rname
#@todo

--- serial
#@todo

--- refresh
#@todo

--- retry
#@todo

--- expire
#@todo

--- minimum
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::PTR < Resolv::DNS::Resource::DomainName

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::HINFO < Resolv::DNS::Resource

== Class Methods

--- new(cpu, os)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- cpu
#@todo

--- os
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::MINFO < Resolv::DNS::Resource

== Class Methods

--- new(rmailbx, emailbx)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- rmailbx
#@todo

--- emailbx
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::MX < Resolv::DNS::Resource

== Class Methods

--- new(preference, exchange)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- preference
#@todo

--- exchange
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::TXT < Resolv::DNS::Resource

== Class Methods

--- new(first_string, *rest_strings)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- encode_rdata(msg)
#@todo

--- data
#@todo

--- strings
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::ANY < Resolv::DNS::Query 

== Constants

--- TypeValue
#@todo

= module Resolv::DNS::Resource::IN

== Constants

--- ClassValue
#@todo

= class Resolv::DNS::Resource::IN::NS < Resolv::DNS::Resource::NS

= class Resolv::DNS::Resource::IN::CNAME < Resolv::DNS::Resource::CNAME

= class Resolv::DNS::Resource::IN::SOA < Resolv::DNS::Resource::SOA

= class Resolv::DNS::Resource::IN::HINFO < Resolv::DNS::Resource::HINFO

= class Resolv::DNS::Resource::IN::MINFO < Resolv::DNS::Resource::MINFO

= class Resolv::DNS::Resource::IN::MX < Resolv::DNS::Resource::MX

= class Resolv::DNS::Resource::IN::TXT < Resolv::DNS::Resource::TXT

= class Resolv::DNS::Resource::IN::ANY < Resolv::DNS::Resource::ANY

== Constants

--- ClassValue
#@todo

= class Resolv::DNS::Resource::IN::A < Resolv::DNS::Resource

== Class Methods

--- new(address)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- address
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::IN::WKS < Resolv::DNS::Resource

== Class Methods

--- new(address, protocol, bitmap)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- address
#@todo

--- protocol
#@todo

--- bitmap
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

= class Resolv::DNS::Resource::IN::PTR < Resolv::DNS::Resource::PTR

= class Resolv::DNS::Resource::IN::AAAA < Resolv::DNS::Resource

== Class Methods

--- new(address)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- address
#@todo

--- encode_rdata(msg)
#@todo

== Constants

--- TypeValue
#@todo

#@if (version >= "1.8.3")

= class Resolv::DNS::Resource::IN::SRV < Resolv::DNS::Resource

== Class Methods

--- new(priority, weight, port, target)
#@todo

--- decode_rdata(msg)
#@todo

== Instance Methods

--- encode_rdata(msg)
#@todo

--- port
#@todo

--- priority
#@todo

--- target
#@todo

--- weight
#@todo

== Constants

--- TypeValue
#@todo

#@end

= module Resolv::DNS::OpCode

== Constants

--- Query
#@todo

--- IQuery
#@todo

--- Status
#@todo

--- Notify
#@todo

--- Update
#@todo

= module Resolv::DNS::RCode

== Constants

--- NoError
#@todo

--- FormErr
#@todo

--- ServFail
#@todo

--- NXDomain
#@todo

--- NotImp
#@todo

--- Refused
#@todo

--- YXDomain
#@todo

--- YXRRSet
#@todo

--- NXRRSet
#@todo

--- NotAuth
#@todo

--- NotZone
#@todo

--- BADVERS
#@todo

--- BADSIG
#@todo

--- BADKEY
#@todo

--- BADTIME
#@todo

--- BADMODE
#@todo

--- BADNAME
#@todo

--- BADALG
#@todo

= class Resolv::DNS::DecodeError < StandardError

= class Resolv::DNS::EncodeError < StandardError

= class Resolv::DNS::Config

== Class Methods

--- new(config_info = nil)
#@todo

--- default_config_hash(filename = '/etc/resolv.conf')
#@todo

--- parse_resolv_conf(filename)
#@todo

== Instance Methods

--- lazy_initialize
#@todo

--- generate_candidates(name)
#@todo

--- generate_timeouts
#@todo

--- resolv(name)
#@todo

--- single?
#@todo

== Constants

--- InitialTimeout
#@todo

= class Resolv::DNS::Config::NXDomain < Resolv::ResolvError

= class Resolv::DNS::Config::OtherResolvError < Resolv::ResolvError

= class Resolv::DNS::Message < Object

== Class Method

--- new(id = ((@@identifier += 1) & 0xffff))
#@todo

--- decode(m)
#@todo

== Instance Method

--- add_question(name, typeclass)
--- each_question
--- add_answer(name, ttl, data)
--- each_answer
--- add_authority(name, ttl, data)
--- each_authority
--- add_additional(name, ttl, data)
--- each_additional
--- each_resource
--- encode
#@todo

--- id
--- id=()
#@todo

--- qr
--- qr=()
#@todo

--- opcode
--- opcode=()
#@todo

--- aa
--- aa=()
#@todo

--- tc
--- tc=()
#@todo

--- rd
--- rd=()
#@todo

--- ra
--- ra=()
#@todo

--- rcode
--- rcode=()
#@todo

--- question
#@todo

--- answer
#@todo

--- authority
#@todo

--- additional
#@todo

= class Resolv::DNS::Message::MessageDecoder < Object

== Class Method

--- new(data)
#@todo

== Instance Method

--- get_bytes(len)
--- get_length16
--- get_label
--- get_labels(limit = nil)
--- get_name
--- get_question
--- get_rr
--- get_string
--- get_string_list
--- get_unpack(template)
#@todo

= class Resolv::DNS::Message::MessageEncoder < Object

== Class Methods

--- new
#@todo

== Instance Method

--- put_bytes(d)
--- put_label(d)
--- put_labels(d)
--- put_length16
--- put_name(d)
--- put_pack(template, *d)
--- put_string(d)
--- put_string_list(ds)
#@todo

--- to_s
#@todo

= class Resolv::DNS::Query < Object

== Class Methods

--- decode_rdata(msg)
#@todo

== Instance Method

--- encode_rdata(msg)
#@todo


= module Resolv::DNS::Label

== Class Methods

--- split(name)
#@todo

= class Resolv::DNS::Label::Str

== Class Methods

--- new(string)
#@todo

== Instance Methods

--- string
--- to_s
#@todo

--- downcase
#@todo

= class Resolv::DNS::Name < Object

== Class Methods

--- create(name)
#@todo

--- new(labels, absolute = true)
#@todo

== Instance Methods

--- to_a
--- to_s
--- []
--- absolute?
--- length
--- subdomain_of?(other)
#@todo

= class Resolv::DNS::Resource < Resolv::DNS::Query

== Class Methods

--- decode_rdata(msg)
--- get_class(type_value, class_value)
#@todo

== Instance Methods

--- encode_rdata(msg)
#@todo

== Constants

--- ClassHash
#@todo

--- ClassValue
#@todo

--- ClassInsensitiveTypes
#@todo

= class Resolv::IPv4 < Object

== Class Methods

--- create(address)
#@todo

"192.168.0.1" のように "." で区切られた IPv4 表記の文字列 address から
Resolv::IPv4 のインスタンスを生成します。

--- new(address)
#@todo

4 byte の文字列 address から Resolv::IPv4 のインスタンスを生成します。

== Instance Methods

--- address
#@todo

--- to_s
--- to_name
#@todo

== Constants

--- Regex
#@todo
#@#    regular expression for IPv4 address.

IPv4 のアドレスの正規表現です。

= class Resolv::IPv6 < Object

== Class Methods

--- create(address)
#@todo

以下のいずれかの形式の文字列 address から Resolv::IPv6 のインスタンスを生成します。


  * 8Hex
  * CompressedHex
  * 6Hex4Dec
  * CompressedHex4Dec

--- new(address)
#@todo

16 byte の文字列 address から Resolv::IPv6 のインスタンスを生成します。

== Instance Methods

--- address
#@todo

--- to_s
--- to_name
#@todo

== Constants

--- Regex
#@todo
#@#    regular expression for IPv6 address.
IPv6のアドレスの正規表現です。

--- Regex_6Hex4Dec
--- Regex_8Hex
--- Regex_CompressedHex
--- Regex_CompressedHex4Dec
#@todo

#@end
