category Network

DNSによる名前解決を行うライブラリです。 Ruby で書かれているため thread-aware であり、並列に多くのホスト名を解決することができます。

DNS モジュールを使うことで、さまざまなリソースを直接ルックアップできます。

なお、単にホスト名から IP アドレスを得たいだけであれば、
[[lib:socket]] ライブラリの [[m:IPSocket.getaddress]] などが使用できます。

=== 例:
  require "resolv"
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
名前解決を試すような、新しいリゾルバオブジェクトを返します。

resolvers の各要素は each_address と each_name という
メソッドを持っていなければなりません。

@param resolvers リゾルバの配列

--- getaddress(name) -> String
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果の最初のアドレスを返します。

ルックアップは /etc/hosts, DNS の順で行います。

  require "resolv"
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

  require "resolv"
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

--- DefaultResolver -> Resolv
[[c:Resolv]] の各クラスメソッドを呼びだしたときに
利用されるリゾルバです。

--- AddressRegex -> Regexp
IPアドレスにマッチする正規表現です。

= class Resolv::ResolvError < StandardError
名前解決に失敗したときに発生する例外のクラスです。

#@# = class Resolv::ResolvTimeout < TimeoutError
#@# 名前解決がタイムアウトしたときに発生する例外のクラスです。
#@# 
#@# この例外はライブラリ内部で rescue されて
#@# Resolv::ResolvError に変換されるので、ユーザは
#@# 利用しないはずです。

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

#@# --- lazy_initialize -> Resolv::Hosts

#@# このメソッドはユーザが使うべきではありません。

#@# [[m:Resolv::Hosts.new]] で指定したファイルを読みこみ、
#@# ルックアップテーブルを生成します。

== Constants

--- DefaultFileName -> String

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

#@if (version <= "1.8.1")
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

  require "resolv"
   Resolv::DNS.new(:nameserver => ['210.251.121.21'],
                   :search => ['ruby-lang.org'],
                   :ndots => 1)
#@end

#@if (version <= "1.8.1")
@param resolv_conf DNSの設定ファイル名を文字列で与えます
#@else
@param resolv_conf DNSの設定を与えます。
#@end

--- open(*args) -> Resolv::DNS
--- open(*args){|dns| ...} -> object

新しい DNS リゾルバを生成します。
ブロックを与えた場合は生成したリゾルバでブロックを呼びだし、
ブロック終了時にリゾルバを閉じます。

ブロックを与えなかった場合は [[m:Resolv::DNS.new]] と
同じです。

@param args DNSの設定を与えます。意味は [[m:Resolv::DNS.new]] 
            の引数と同じです。
@return ブロックを与えた場合はブロックの返す値を返し、
        与えなかった場合は生成したリゾルバを返します。

== Instance Methods

--- getaddress(name) -> Resolv::IPv4 | Resolv::IPv6
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果の最初のアドレスを返します。

@param name ホスト名を文字列もしくは[[c:Resolv::DNS::Name]]のインスタンスで与えます。
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getaddresses(name) -> [Resolv::IPv4 | Resolv::IPv6]
ホスト名 name の IP アドレスをルックアップし、
ルックアップ結果のアドレスリストを返します。

ルックアップに失敗した場合は空の配列が返されます。

@param name ホスト名を文字列もしくは[[c:Resolv::DNS::Name]]のインスタンスで与えます。

--- each_address(name) {|name| ...} -> ()
ホスト名 name の IP アドレスをルックアップし、
各ルックアップ結果のアドレスに対してブロックを評価します。

@param name ホスト名を文字列もしくは[[c:Resolv::DNS::Name]]のインスタンスで与えます。

--- getname(address) -> Resolv::DNS::Name
IP アドレス address のホスト名をルックアップし、
ルックアップ結果の最初のホスト名を返します。

@param address IPアドレスを文字列、 Resolv::IPv4 のインスタンス、
               Resolv::IPv6 のインスタンス、のいずれか与えます。
               
@raise Resolv::ResolvError ルックアップに失敗したときに発生します。

--- getnames(address) -> [Resolv::DNS::Name]
IP アドレス address のホスト名をルックアップし、
ルックアップ結果のホスト名リストを返します。

@param address IPアドレスを文字列、 Resolv::IPv4 のインスタンス、
               Resolv::IPv6 のインスタンス、のいずれか与えます。

--- each_name(address) {|name| ...} -> ()
IP アドレス address のホスト名をルックアップし、
各ルックアップ結果のホスト名に対してブロックを評価します。

@param address IPアドレスを文字列、 Resolv::IPv4 のインスタンス、
               Resolv::IPv6 のインスタンス、のいずれか与えます。

--- getresource(name, typeclass) -> Resolv::DNS::Resource
nameに対応するDNSリソースレコードを取得します。
最初に見つかったリソースを返します。

typeclass は以下のいずれかです。
  * [[c:Resolv::DNS::Resource::IN::ANY]]
  * [[c:Resolv::DNS::Resource::IN::NS]]
  * [[c:Resolv::DNS::Resource::IN::CNAME]]
  * [[c:Resolv::DNS::Resource::IN::SOA]]
  * [[c:Resolv::DNS::Resource::IN::HINFO]]
  * [[c:Resolv::DNS::Resource::IN::MINFO]]
  * [[c:Resolv::DNS::Resource::IN::MX]]
  * [[c:Resolv::DNS::Resource::IN::TXT]]
  * [[c:Resolv::DNS::Resource::IN::A]]
  * [[c:Resolv::DNS::Resource::IN::WKS]]
  * [[c:Resolv::DNS::Resource::IN::PTR]]
  * [[c:Resolv::DNS::Resource::IN::AAAA]]
  * [[c:Resolv::DNS::Resource::IN::SRV]]

ルックアップ結果は Resolv::DNS::Resource （のサブクラス）のインスタンスとなります。
typeclass に Resolv::DNS::Resource::IN::ANY 以外を指定した場合には
そのクラスのインスタンスを返します。

@param name ルックアップ対象となる名前を [[c:Resolv::DNS::Name]] または String で指定します。
@param typeclass レコード種別を指定します。
@raise Resolv::ResolvError ルックアップに失敗した場合に発生します。

--- getresources(name, typeclass) -> [Resolv::DNS::Resource]
nameに対応するDNSリソースレコードを取得します。
見つかったリソース全てを配列にして返します。

typeclass は以下のいずれかです。
  * [[c:Resolv::DNS::Resource::IN::ANY]]
  * [[c:Resolv::DNS::Resource::IN::NS]]
  * [[c:Resolv::DNS::Resource::IN::CNAME]]
  * [[c:Resolv::DNS::Resource::IN::SOA]]
  * [[c:Resolv::DNS::Resource::IN::HINFO]]
  * [[c:Resolv::DNS::Resource::IN::MINFO]]
  * [[c:Resolv::DNS::Resource::IN::MX]]
  * [[c:Resolv::DNS::Resource::IN::TXT]]
  * [[c:Resolv::DNS::Resource::IN::A]]
  * [[c:Resolv::DNS::Resource::IN::WKS]]
  * [[c:Resolv::DNS::Resource::IN::PTR]]
  * [[c:Resolv::DNS::Resource::IN::AAAA]]
  * [[c:Resolv::DNS::Resource::IN::SRV]]

ルックアップ結果は Resolv::DNS::Resource （のサブクラス）のインスタンスとなります。
typeclass に Resolv::DNS::Resource::IN::ANY 以外を指定した場合には
そのクラスのインスタンスを返します。

@param name ルックアップ対象となる名前を [[c:Resolv::DNS::Name]] または String で指定します。
@param typeclass レコード種別を指定します。

--- each_resource(name, typeclass) {|resource| ...} -> ()

nameに対応するDNSリソースレコードを取得します。
見つかったリソースをひとつずつブロックに渡します。

typeclass は以下のいずれかです。
  * [[c:Resolv::DNS::Resource::IN::ANY]]
  * [[c:Resolv::DNS::Resource::IN::NS]]
  * [[c:Resolv::DNS::Resource::IN::CNAME]]
  * [[c:Resolv::DNS::Resource::IN::SOA]]
  * [[c:Resolv::DNS::Resource::IN::HINFO]]
  * [[c:Resolv::DNS::Resource::IN::MINFO]]
  * [[c:Resolv::DNS::Resource::IN::MX]]
  * [[c:Resolv::DNS::Resource::IN::TXT]]
  * [[c:Resolv::DNS::Resource::IN::A]]
  * [[c:Resolv::DNS::Resource::IN::WKS]]
  * [[c:Resolv::DNS::Resource::IN::PTR]]
  * [[c:Resolv::DNS::Resource::IN::AAAA]]
  * [[c:Resolv::DNS::Resource::IN::SRV]]

ルックアップ結果は Resolv::DNS::Resource （のサブクラス）のインスタンスとなります。
typeclass に Resolv::DNS::Resource::IN::ANY 以外を指定した場合には
そのクラスのインスタンスを返します。

@param name ルックアップ対象となる名前を [[c:Resolv::DNS::Name]] または String で指定します。
@param typeclass レコード種別を指定します。

--- close -> ()

DNSリゾルバを閉じます。

#@# --- extract_resources(msg, name, typeclass) {|resource| ...}

#@# このメソッドはユーザが使うべきではありません。

#@# DNSサーバからの返答 msg を name と typeclass でフィルタリングし、
#@# その結果をブロックに渡します。

#@# @param msg DNSサーバからの返答を与えます。[[c:Resolv::DNS::Message]] のインスタンスを与えることができます。
#@# @param name フィルタリングする名前を指定します。
#@# @param typeclass フィルタリングするDNSレコード種別を表します。[[m:Resolv::DNS#getresource]] の typeclass と同じクラスを与えます。
#@# --- lazy_initialize -> Resolv::DNS

#@# このメソッドはユーザが使うべきではありません。

#@# [[m:Resolv::DNS.new]] で与えた設定でインスタンスを実際に初期化します。

#@since 2.0.0
--- timeouts=(values)

DNSリゾルバのタイムアウト時間を設定します。

例:

  dns.timeouts = 3

@param values タイムアウト時間(秒)を数値か数値の配列で指定します。配列
              を指定した場合は応答を受信するまでの再試行時のタイムアウト
              時間も含めて順に設定します。nil を指定した場合はデフォル
              ト値
              ([ 5, second = 5 * 2 / nameserver_count, 2 * second, 4 * second ])
              を使用します。
#@end

== Constants

#@# --- DNSThreadGroup

#@# この定数はユーザが使うべきではありません。

#@# #@until 1.8.5
#@# Resolv::DNS内部で利用される [[c:ThreadGroup]] です。
#@# #@else
#@# この定数はもはや利用されていません。
#@# #@end

--- Port -> Integer

デフォルトの DNS ポート番号です。

--- UDPSize -> Integer

デフォルトの UDP パケットサイズです。

#@# = class Resolv::DNS::Requester < Object

#@# このクラスはユーザが使うべきではありません。

#@# DNSサーバにリクエストを送るクラスのベースクラスとなるクラスです。
#@# 継承して利用します。

#@# == Class Methods

#@# --- new

#@# == Instance Methods

#@# --- close
#@# --- delete(arg)
#@# #@todo

#@# = class Resolv::DNS::Requester::Sender

#@# このクラスはユーザが使うべきではありません。

#@# == Class Methods

#@# --- new(msg, data, sock, queue)
#@# #@todo

#@# == Instance Methods

#@# --- recv(msg)
#@# #@todo

#@# --- queue
#@# #@todo

#@# = class Resolv::DNS::Requester::UnconnectedUDP < Resolv::DNS::Requester

#@# このクラスはユーザが使うべきではありません。

#@# == Class Methods

#@# --- new
#@# #@todo

#@# == Instance Methods

#@# --- sender(msg, data, queue, host, port = Port)
#@# #@todo

#@# = class Resolv::DNS::Requester::UnconnectedUDP::Sender < Resolv::DNS::Requester::Sender
#@# このクラスはユーザが使うべきではありません。

#@# == Class Methods

#@# --- new(msg, data, sock, host, port, queue)
#@# #@todo

#@# == Instance Methods

#@# --- send
#@# #@todo

#@# = class Resolv::DNS::Requester::ConnectedUDP < Resolv::DNS::Requester

#@# このクラスはユーザが使うべきではありません。

#@# == Class Methods

#@# --- new(host, port = Port)
#@# #@todo

#@# == Instance Methods

#@# --- sender(msg, data, queue, host = @host, port = @port)
#@# #@todo

#@# = class Resolv::DNS::Requester::ConnectedUDP::Sender < Resolv::DNS::Requester::Sender
#@# このクラスはユーザが使うべきではありません。

#@# == Instance Methods

#@# --- send
#@# #@todo

#@# = class Resolv::DNS::Requester::TCP < Resolv::DNS::Requester

#@# このクラスはユーザが使うべきではありません。

#@# == Class Methods

#@# --- new(host, port = Port)
#@# #@todo

#@# == Instance Methods

#@# --- sender(msg, data, queue, host = @host, port = @port)
#@# #@todo

#@# = class Resolv::DNS::Requester::TCP::Sender < Resolv::DNS::Requester::Sender

#@# このクラスはユーザが使うべきではありません。

#@# == Instance Methods

#@# --- send
#@# #@todo

= class Resolv::DNS::Requester::RequestError < StandardError

DNS サーバへのリクエストに失敗した場合に発生する例外のクラスです。

= class Resolv::DNS::Resource::Generic < Resolv::DNS::Resource
汎用DNSリソース抽象クラスです。

== Class Methods

#@# --- new(data) -> Resolv::DNS::Resource::Generic
#@# このメソッドはユーザが使うべきではありません。

#@# Resolv::DNS::Resource::Generic のインスタンスを生成して
#@# 返します。

#@# --- create(type_value, class_value) -> object
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::Generic
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。


== Instance Methods

#@# --- data -> object
#@# このメソッドはユーザが使うべきではありません。

#@# DNS リソースのデータを返します。

#@# --- encode_rdata(msg) -> ()
#@# このメソッドはユーザが使うべきではありません。

= class Resolv::DNS::Resource::DomainName < Resolv::DNS::Resource
DNSリソースのドメイン名を表す抽象クラスです。

== Class Methods

#@# --- new(name) -> Resolv::DNS::Resource::DomainName
#@# このメソッドはユーザが使うべきではありません。
#@# #@todo


#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::DomainName
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

== Instance Methods

--- name -> Resolv::DNS::Name
ドメイン名を返します。

#@# --- encode_rdata(msg) -> ()
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

= class Resolv::DNS::Resource::NS < Resolv::DNS::Resource::DomainName

DNS リソースの NS (正式な(authoritative)ネームサーバ) レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で NS レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::NS]] を使うべきです。

#@# == Constants
#@#
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@#
#@# DNSのクエリータイプの NS に対応する整数値です。

= class Resolv::DNS::Resource::CNAME < Resolv::DNS::Resource::DomainName

DNS リソースの CNAME レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で CNAME レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::CNAME]] を使うべきです。

#@# == Constants
#@#
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@#
#@# DNSのクエリータイプの CNAME に対応する整数値です。


= class Resolv::DNS::Resource::SOA < Resolv::DNS::Resource

DNS リソースの SOA (Start Of Authority) レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で SOA レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::SOA]] を使うべきです。

== Class Methods

--- new(mname, rname, serial, refresh, retry_, expire, minimum) -> Resolv::DNS::Resource::SOA
Resolv::DNS::Resource::SOA のインスタンスを生成して返します。

@param mname 対象のゾーンのマスターゾーンファイルが存在するホスト名
@param rname 対象のドメイン名の管理者名
@param serial ゾーンファイルのバージョン
@param refresh プライマリサーバからの更新をセカンダリサーバが
               チェックする頻度(秒単位)
@param retry セカンダリサーバがプライマリサーバからの情報更新
             に失敗した場合のリトライの頻度(秒単位)
@param expire プライマリサーバから得たゾーン情報の有効期間(秒単位)
@param minimum リソースレコードの最小 TTL (秒単位)


#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::SOA
#@# 
#@# このメソッドはユーザが使うべきではありません。

== Instance Methods

--- mname -> Resolv::DNS::Name
対象のゾーンのマスターゾーンファイルが存在するホスト名を返します。

--- rname -> Resolv::DNS::Name
対象のドメイン名の管理者名を返します。

--- serial -> Integer
ゾーンファイルのバージョンを返します。

--- refresh -> Integer
プライマリサーバからの更新をセカンダリサーバがチェックする
頻度を秒単位で返します。

--- retry -> Integer
セカンダリサーバがプライマリサーバからの情報更新に失敗した場合に
何秒後にリトライするかを返します。

--- expire -> Integer
プライマリサーバから得たゾーン情報をセカンダリサーバが
何秒間有効なものとして保持するかを返します。

--- minimum -> Integer
リソースレコードで TTL の値として使われる最小の秒数を
返します。


#@# --- encode_rdata(msg) -> ()
#@# このメソッドはユーザが使うべきではありません。
#@# #@todo

#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ SOA に対応する整数値です。

= class Resolv::DNS::Resource::PTR < Resolv::DNS::Resource::DomainName
DNS リソースの PTR レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で PTR レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::PTR]] を使うべきです。


#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ PTR に対応する整数値です。

= class Resolv::DNS::Resource::HINFO < Resolv::DNS::Resource
DNS リソースの HINFO レコード
を表す抽象クラスです。

このレコードはホストのハードウェアとソフトウェアの情報を
保持しています。

[[m:Resolv::DNS#getresource]] で HINFO レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::HINFO]] を使うべきです。

== Class Methods

--- new(cpu, os) -> Resolv::DNS::Resource::HINFO
Resolv::DNS::Resource::HINFO のインスタンスを生成します。

@param cpu CPU 名
@param os OS 名

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::HINFO
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# #@todo

== Instance Methods

--- cpu -> String
ホストで使われる CPU 名(ハードウェア名)を返します。

--- os -> String
ホストで使われる OS 名を返します。

#@# --- encode_rdata(msg) -> ()
#@# このメソッドはユーザが使うべきではありません。
#@# #@todo
#@# 
#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ HINFO に対応する整数値です。

= class Resolv::DNS::Resource::MINFO < Resolv::DNS::Resource

DNS リソースの MINFO レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で MINFO レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::MINFO]] を使うべきです。

== Class Methods

--- new(rmailbx, emailbx) -> Resolv::DNS::Resource::MINFO
Resolv::DNS::Resource::MINFO のインスタンスを生成します。

@param rmailbx このメールリストドメイン名
@param emailbx

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::MINFO
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

== Instance Methods

--- rmailbx -> String
メーリングリストもしくはメールボックスの
責任者のドメイン名を返します。

--- emailbx -> String
メーリングリストもしくはメールボックスの
エラーを受け取るメールボックスのドメイン名を
返します。

#@# --- encode_rdata(msg) -> ()
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ MINFO に対応する整数値です。

= class Resolv::DNS::Resource::MX < Resolv::DNS::Resource

DNS リソースの MX レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で MX レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::MX]] を使うべきです。

== Class Methods

--- new(preference, exchange) -> Resolv::DNS::Resource::MX
Resolv::DNS::Resource::MX のインスタンスを返します。

@param preference MXの優先度
@param exchange MXのホスト

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::MX
#@# このメソッドはユーザが使うべきではありません。
#@# #@todo 

== Instance Methods

--- preference -> Integer
このMXレコードの優先度を返します。

--- exchange -> Resolv::DNS::Name
MXのホスト名を返します。

#@# --- encode_rdata(msg) -> ()
#@# このメソッドはユーザが使うべきではありません。
#@# #@todo
#@# 
#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ MX に対応する整数値です。

= class Resolv::DNS::Resource::TXT < Resolv::DNS::Resource
DNS リソースの TXT レコード
を表す抽象クラスです。

[[m:Resolv::DNS#getresource]] で TXT レコードを得たい場合は
[[c:Resolv::DNS::Resource::IN::TXT]] を使うべきです。


== Class Methods

--- new(first_string, *rest_strings) -> Resolv::DNS::Resource::TXT
Resolv::DNS::Resource::TXTのインスタンスを生成します。

@param first_string レコードの最初の文字列
@param rest_strings レコードの残りの文字列

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::TXT
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

== Instance Methods

#@# --- encode_rdata(msg) -> ()
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

--- data -> String
TXT レコードの最初の文字列を返します。

--- strings -> [String]
TXT レコードの文字列を配列で返します。

#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ MX に対応する整数値です。

= class Resolv::DNS::Resource::ANY < Resolv::DNS::Query 
DNS のすべてのクラスに対するクエリーを表わす
抽象クラスです。

[[m:Resolv::DNS#getresource]] では
[[c:Resolv::DNS::Resource::IN::ANY]] を使うべきです。

#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ ANY に対応する整数値です。

= module Resolv::DNS::Resource::IN
DNS のインターネットクラスリソースを表すモジュールです。

インターネットクラスリソースを利用する class に
mixinして利用します。

#@# == Constants
#@# 
#@# --- ClassValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクラス IN に対応する整数値です。

= class Resolv::DNS::Resource::IN::NS < Resolv::DNS::Resource::NS
DNS リソースのクラス IN、タイプ NS に対応する
クラスです。

= class Resolv::DNS::Resource::IN::CNAME < Resolv::DNS::Resource::CNAME
DNS リソースのクラス IN、タイプ CNAME に対応する
クラスです。

= class Resolv::DNS::Resource::IN::SOA < Resolv::DNS::Resource::SOA
DNS リソースのクラス IN、タイプ SOA に対応する
クラスです。

= class Resolv::DNS::Resource::IN::HINFO < Resolv::DNS::Resource::HINFO
DNS リソースのクラス IN、タイプ HINFO に対応する
クラスです。

= class Resolv::DNS::Resource::IN::MINFO < Resolv::DNS::Resource::MINFO
DNS リソースのクラス IN、タイプ MINFO に対応する
クラスです。

= class Resolv::DNS::Resource::IN::MX < Resolv::DNS::Resource::MX
DNS リソースのクラス IN、タイプ MX に対応する
クラスです。

= class Resolv::DNS::Resource::IN::TXT < Resolv::DNS::Resource::TXT
DNS リソースのクラス IN、タイプ TXT に対応する
クラスです。

= class Resolv::DNS::Resource::IN::ANY < Resolv::DNS::Resource::ANY
DNS クエリーのクラス IN、タイプ ANY に対応する
クラスです。

#@# == Constants
#@# 
#@# --- ClassValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクラス IN に対応する整数値です。

= class Resolv::DNS::Resource::IN::A < Resolv::DNS::Resource
DNS リソースのクラス IN、タイプ A に対応する
クラスです。

IPv4アドレスリソースを表します。

== Class Methods

--- new(address) -> Resolv::DNS::Resource::IN::A
Resolv::DNS::Resource::IN::A のインスタンスを
生成します。

@param address IPv4アドレス

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::IN::A
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。
#@# 
== Instance Methods

--- address -> Resolv::IPv4
IPv4アドレスを返します。

#@# --- encode_rdata(msg) -> ()
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# == Constants
#@# 
#@# --- TypeValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# DNS のクエリータイプ A に対応する整数値です。


= class Resolv::DNS::Resource::IN::WKS < Resolv::DNS::Resource
DNS リソースのクラス IN、タイプ WKS に対応する
クラスです。

== Class Methods

--- new(address, protocol, bitmap) -> Resolv::DNS::Resource::IN::WKS
Resolv::DNS::Resource::IN::WKS のインスタンスを生成します。

@param address IPv4アドレス
@param protocol IPプロトコル番号
@param bitmap ビットマップ

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::IN::WKS
#@# #@todo

== Instance Methods

--- address -> Resolv::IPv4
IPv4アドレスを返します。

--- protocol -> Integer
IPプロトコル番号を返します。

例えば 6 は TCP に対応します。

--- bitmap -> String
そのホストで利用可能なサービスのビットマップを返します。

例えば [[m:Resolv::DNS::Resource::IN::WKS#protocol]] が 6 (TCP)
の場合、26番目のビットはポート25のサービス(SMTP)に対応しています。
このビットが立っているならば SMTP は利用可能であり、
そうでなければ利用できません。

#@# --- encode_rdata(msg) -> ()
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# == Constants
#@# 
#@# --- TypeValue
#@# #@todo

= class Resolv::DNS::Resource::IN::PTR < Resolv::DNS::Resource::PTR
DNS リソースのクラス IN、タイプ PTR に対応する
クラスです。

= class Resolv::DNS::Resource::IN::AAAA < Resolv::DNS::Resource
DNS リソースのクラス IN、タイプ AAAA に対応する
クラスです。

IPv6アドレスリソースを表します。

== Class Methods

--- new(address) -> Resolv::DNS::Resource::IN::AAAA
Resolv::DNS::Resource::IN::AAAA のインスタンスを
生成します。

@param address IPv6アドレス

#@# --- decode_rdata(msg) -> Resolv::DNS::Resource::IN::AAAA
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。

== Instance Methods

--- address -> Resolv::IPv6
IPv6アドレスを返します。

#@# --- encode_rdata(msg) -> ()
#@# #@todo
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# == Constants
#@# 
#@# --- TypeValue
#@# #@todo

#@if (version >= "1.8.3")

= class Resolv::DNS::Resource::IN::SRV < Resolv::DNS::Resource
DNS リソースのクラス IN、タイプ SRV に対応する
クラスです。

[[RFC:2782]] で定義されています。
利用可能なサービスのホスト名とポート番号を指定するレコードです。

== Class Methods

--- new(priority, weight, port, target) -> Resolv::DNS::Resource::IN::SRV
Resolv::DNS::Resource::IN::SRV のインスタンスを生成します。

@param priority ホストの優先順位
@param weight
@param port ポート番号
@param target ホスト名

#@# --- decode_rdata(msg)
#@# #@todo

== Instance Methods

#@# --- encode_rdata(msg)
#@# #@todo

--- port -> Integer
対象のサービスの対象のホストにおけるポート番号を返します。

--- priority -> Integer
ホストの優先順位を返します。

クライアントは利用可能なホストの中で最も priority が
小さい数値のホストを利用しなければなりません。

priority が同じならば [[m:Resolv::DNS::Resource::IN::SRV#weight]]
で定義されるようにホストを選ぶべきです。

返り値の範囲は 0 から 65535 までの整数値です。

--- target -> Resolv::DNS::Name
対象のホストのホスト名を返します。

--- weight -> Integer
サーバを選択するための「重み」です。

[[m:Resolv::DNS::Resource::IN::SRV#priority]] が同じ場合に
この項目が利用されます。
重みに比例した確率でホストを選択すべきです。
返り値の範囲は 0 から 65535 までの整数です。
選択肢が一つしかない、つまり選択する必要がない場合には
この値は人間が読みやすいよう 0 にすべきです。


#@# == Constants
#@# 
#@# --- TypeValue
#@# #@todo

#@end

#@# = module Resolv::DNS::OpCode
#@# このモジュールはユーザが使うべきではありません。
#@# == Constants
#@# 
#@# --- Query
#@# #@todo
#@# 
#@# --- IQuery
#@# #@todo
#@# 
#@# --- Status
#@# #@todo
#@# 
#@# --- Notify
#@# #@todo
#@# 
#@# --- Update
#@# #@todo
#@# 
#@# = module Resolv::DNS::RCode
#@# 
#@# == Constants
#@# 
#@# --- NoError
#@# #@todo
#@# 
#@# --- FormErr
#@# #@todo
#@# 
#@# --- ServFail
#@# #@todo
#@# 
#@# --- NXDomain
#@# #@todo
#@# 
#@# --- NotImp
#@# #@todo
#@# 
#@# --- Refused
#@# #@todo
#@# 
#@# --- YXDomain
#@# #@todo
#@# 
#@# --- YXRRSet
#@# #@todo
#@# 
#@# --- NXRRSet
#@# #@todo
#@# 
#@# --- NotAuth
#@# #@todo
#@# 
#@# --- NotZone
#@# #@todo
#@# 
#@# --- BADVERS
#@# #@todo
#@# 
#@# --- BADSIG
#@# #@todo
#@# 
#@# --- BADKEY
#@# #@todo
#@# 
#@# --- BADTIME
#@# #@todo
#@# 
#@# --- BADMODE
#@# #@todo
#@# 
#@# --- BADNAME
#@# #@todo
#@# 
#@# --- BADALG
#@# #@todo

= class Resolv::DNS::DecodeError < StandardError
DNSメッセージのデコードに失敗したときに発生する
例外のクラスです。

DNSサーバからの応答が規格的に正しくない場合などに
発生します。

= class Resolv::DNS::EncodeError < StandardError
DNSメッセージのエンコードに失敗したときに発生する
例外のクラスです。

通常このエラーは発生しません。
もし発生したならばライブラリのバグである可能性があります。


#@# = class Resolv::DNS::Config
#@# このクラスはユーザが使うべきではありません。
#@# 
#@# 
#@# == Class Methods
#@# 
#@# --- new(config_info = nil)
#@# #@todo
#@# 
#@# --- default_config_hash(filename = '/etc/resolv.conf')
#@# #@todo
#@# 
#@# --- parse_resolv_conf(filename)
#@# #@todo
#@# 
#@# == Instance Methods
#@# 
#@# --- lazy_initialize
#@# #@todo
#@# 
#@# --- generate_candidates(name)
#@# #@todo
#@# 
#@# --- generate_timeouts
#@# #@todo
#@# 
#@# --- resolv(name)
#@# #@todo
#@# 
#@# --- single?
#@# #@todo
#@# 
#@# == Constants
#@# 
#@# --- InitialTimeout
#@# #@todo

#@# = class Resolv::DNS::Config::NXDomain < Resolv::ResolvError
#@# 問合せたドメイン名が存在しないことを示す例外。
#@# 
#@# ライブラリ内部で握り潰すためユーザは使わないはず。
#@# 

= class Resolv::DNS::Config::OtherResolvError < Resolv::ResolvError
DNS サーバからの応答がエラーであった場合に発生する例外です。

Resolv::DNSの各メソッドがこの例外を発生させる可能性があります。

#@# = class Resolv::DNS::Message < Object
#@# このクラスはユーザが使うべきではありません。
#@# == Class Method
#@# 
#@# --- new(id = ((@@identifier += 1) & 0xffff))
#@# #@todo
#@# 
#@# --- decode(m)
#@# #@todo
#@# 
#@# == Instance Method
#@# 
#@# --- add_question(name, typeclass)
#@# --- each_question
#@# --- add_answer(name, ttl, data)
#@# --- each_answer
#@# --- add_authority(name, ttl, data)
#@# --- each_authority
#@# --- add_additional(name, ttl, data)
#@# --- each_additional
#@# --- each_resource
#@# --- encode
#@# #@todo
#@# 
#@# --- id
#@# --- id=()
#@# #@todo
#@# 
#@# --- qr
#@# --- qr=()
#@# #@todo
#@# 
#@# --- opcode
#@# --- opcode=()
#@# #@todo
#@# 
#@# --- aa
#@# --- aa=()
#@# #@todo
#@# 
#@# --- tc
#@# --- tc=()
#@# #@todo
#@# 
#@# --- rd
#@# --- rd=()
#@# #@todo
#@# 
#@# --- ra
#@# --- ra=()
#@# #@todo
#@# 
#@# --- rcode
#@# --- rcode=()
#@# #@todo
#@# 
#@# --- question
#@# #@todo
#@# 
#@# --- answer
#@# #@todo
#@# 
#@# --- authority
#@# #@todo
#@# 
#@# --- additional
#@# #@todo
#@# 
#@# = class Resolv::DNS::Message::MessageDecoder < Object
#@# 
#@# == Class Method
#@# 
#@# --- new(data)
#@# #@todo
#@# 
#@# == Instance Method
#@# 
#@# --- get_bytes(len)
#@# --- get_length16
#@# --- get_label
#@# --- get_labels(limit = nil)
#@# --- get_name
#@# --- get_question
#@# --- get_rr
#@# --- get_string
#@# --- get_string_list
#@# --- get_unpack(template)
#@# #@todo
#@# 
#@# = class Resolv::DNS::Message::MessageEncoder < Object
#@# 
#@# == Class Methods
#@# 
#@# --- new
#@# #@todo
#@# 
#@# == Instance Method
#@# 
#@# --- put_bytes(d)
#@# --- put_label(d)
#@# --- put_labels(d)
#@# --- put_length16
#@# --- put_name(d)
#@# --- put_pack(template, *d)
#@# --- put_string(d)
#@# --- put_string_list(ds)
#@# #@todo
#@# 
#@# --- to_s
#@# #@todo

= class Resolv::DNS::Query < Object

DNSクエリを表す抽象クラスです。

#@# == Class Methods
#@# 
#@# --- decode_rdata(msg)
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# == Instance Method
#@# 
#@# --- encode_rdata(msg)
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# 
#@# = module Resolv::DNS::Label
#@# ユーザがこのモジュールを使う必要はないでしょう。
#@# 
#@# ドメイン名を取り扱うためのユーティリティモジュールです。
#@# [[c:Resolv::DNS::Name]] から使われます。
#@# 
#@# == Class Methods
#@# 
#@# --- split(name) -> [Resolv::DNS::Label::Str]
#@# 文字列 name を分割して、 [[c:Resolv::DNS::Label::Str]] の配列を返します。
#@# 
#@# @paarm name ドメイン名の文字列。
#@# 
#@# = class Resolv::DNS::Label::Str
#@# ユーザがこのクラスを使う必要はないでしょう。
#@# 
#@# ドメイン名をドットで分割した各要素を表すクラスです。
#@# 
#@# 文字列中の大文字と小文字を同一視するために存在するクラスです。
#@# 
#@# == Class Methods
#@# 
#@# --- new(string) -> Resolv::DNS::Label::Str
#@# 文字列 string から [[c:Resolv::DNS::Label::Str]]のインスタンスを生成します。
#@# 
#@# @param string 
#@# 
#@# == Instance Methods
#@# 
#@# --- string -> String
#@# --- to_s -> String
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# [[m:Resolv::DNS::Label::Str.new]] で引数に与えた文字列を返します。
#@# 
#@# --- downcase -> String
#@# このメソッドはユーザが使うべきではありません。
#@# 
#@# [[m:Resolv::DNS::Label::Str.new]] で引数に与えた文字列を小文字にして返します。
#@# 

= class Resolv::DNS::Name < Object
ドメイン名を表すクラスです。

== Class Methods

--- create(name) -> Resolv::DNS::Name
文字列 name から Resolv::DNS::Name のインスタンスを生成します。

@param name ドメイン名の文字列。最後に"."を置くと絶対パス形式、そうでなければ相対パス形式とみなされます。

--- new(labels, absolute = true) -> Resolv::DNS::Name
Resolv::DNS::Nameのインスタンスを生成します。
labels は [[c:Resolv::DNS::Label::Str]] の配列を与えます。

@param labels ドメイン名を [[c:Resolv::DNS::Label::Str]] の配列として与えます。
@param absolute ドメイン名が絶対パスであるかどうかを 真偽値で与えます。

@see [[m:Resolv::DNS::Name.create]]

== Instance Methods

#@# --- to_a -> [Resolv::DNS::Label::Str]
#@# このメソッドはユーザが使うべきではありません。
#@# 

--- to_s -> String
ドメイン名を文字列として返します。

絶対パス形式であっても返される文字列には最後のドットは含まれません。

#@# --- [](i) -> Resolv::DNS::Label::Str
#@# このメソッドはユーザが使うべきではありません。
#@# 

--- absolute? -> bool
絶対パス形式であるかどうかを返します。

#@# --- length
#@# このメソッドはユーザが使うべきではありません。

--- subdomain_of?(other) -> bool
other が self のサブドメインであるかどうかを返します。

=== 例
  require "resolv"
  domain = Resolv::DNS::Name.create("y.z")
  p Resolv::DNS::Name.create("w.x.y.z").subdomain_of?(domain) #=> true
  p Resolv::DNS::Name.create("x.y.z").subdomain_of?(domain) #=> true
  p Resolv::DNS::Name.create("y.z").subdomain_of?(domain) #=> false
  p Resolv::DNS::Name.create("z").subdomain_of?(domain) #=> false
  p Resolv::DNS::Name.create("x.y.z.").subdomain_of?(domain) #=> false
  p Resolv::DNS::Name.create("w.z").subdomain_of?(domain) #=> false
  

= class Resolv::DNS::Resource < Resolv::DNS::Query
DNSリソースを表す抽象クラスです。

#@# == Class Methods
#@# 
#@# --- decode_rdata(msg)
#@# --- get_class(type_value, class_value)
#@# #@todo
#@# 
#@# == Instance Methods
#@# 
#@# --- encode_rdata(msg)
#@# #@todo
#@# 
#@# == Constants
#@# 
#@# --- ClassHash
#@# この定数はユーザが使うべきではありません。
#@# 
#@# --- ClassValue
#@# この定数はユーザが使うべきではありません。
#@# 
#@# --- ClassInsensitiveTypes
#@# この定数はユーザが使うべきではありません。
#@# 

= class Resolv::IPv4 < Object
IPv4のアドレスを表すクラスです。

== Class Methods

--- create(address) -> Resolv::IPv4

"192.168.0.1" のように "." で区切られた IPv4 表記の文字列 address から
Resolv::IPv4 のインスタンスを生成します。

@param address IPv4 表記の文字列

--- new(address) -> Resolv::IPv4

4 byte の文字列 address から Resolv::IPv4 のインスタンスを生成します。

@param address 4 byte のバイナリ列の IPv4 のアドレス
@see [[m:Resolv::IPv4.create]] 


== Instance Methods

--- address -> String
4byte バイト列の IPv4 アドレスを返します。

--- to_s -> String
ドットで区切られた IPv4 アドレス文字列を返します。

--- to_name -> Resolv::DNS::Name
"x.y.z.w.in-addr.arpa." という形のドメイン名を返します。

== Constants

--- Regex -> Regexp
IPv4 のアドレスの正規表現です。

= class Resolv::IPv6 < Object
IPv6 のアドレスを表すクラスです。

== Class Methods

--- create(address) -> Resolv::IPv6

引数 address で指定した文字列から Resolv::IPv6 のインスタンスを生成しま
す。

@param address human readable な IPv6 アドレスの文字列表現を以下のいず
               れかの形式で指定します。

  * 8Hex
  * CompressedHex
  * 6Hex4Dec
  * CompressedHex4Dec

--- new(address) -> Resolv::IPv6
16 byte の文字列 address から Resolv::IPv6 のインスタンスを生成します。

@param address IPv6アドレスを表す 16 byte の文字列(バイト列)
@see [[m:Resolv::IPv6.create]]

== Instance Methods

--- address -> String
IPv6アドレスを表す 16 byte の文字列(バイト列)を返します。

--- to_s -> String
IPv6 アドレスの文字列表現を返します。

--- to_name -> Resolv::DNS::Name
"h.g.f.e.d.c.b.a.ip6.arpa." という DNS 名を返します。


== Constants

--- Regex -> Regexp
IPv6のアドレスの正規表現です。
[[m:Resolv::IPv6::Regex_6Hex4Dec]],
[[m:Resolv::IPv6::Regex_8Hex]],
[[m:Resolv::IPv6::Regex_CompressedHex]],
[[m:Resolv::IPv6::Regex_CompressedHex4Dec]],
のいずれかとマッチする文字列とマッチします。

--- Regex_6Hex4Dec -> Regexp
--- Regex_8Hex -> Regexp
--- Regex_CompressedHex -> Regexp
--- Regex_CompressedHex4Dec -> Regexp
IPv6の各文字列表記とマッチする正規表現です。順に
  * a:b:c:d:e:f:w.x.y.z
  * a:b:c:d:e:f:g:h
  * a::b
  * a::b:w.x.y.z
という文字列とマッチします。
