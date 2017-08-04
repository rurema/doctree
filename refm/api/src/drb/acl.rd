drb で用いる ACL(Access Control List)を定義するライブラリ。

= class ACL < Object

drb で用いる ACL(Access Control List)クラス。

Access control list は "allow" と "deny" の2つからなります。
"all" や "*" という文字列は任意のアドレスにマッチします。
[[c:IPAddr]] が取り扱える任意のアドレス/アドレスマスクを
使うことができます。

ACLのエントリーは、以下の例に示すように、
  "allow_or_deny", "addr1",
  "allow_or_deny", "addr2",
     :
という文字列配列で表現されます。

@see [[m:DRb.#install_acl]], [[m:DRb.#start_service]], [[m:DRb::DRbServer.default_acl]], [[m:DRb::DRbServer.new]]

=== 例
ACL を単独で用いる例。
  require "drb/acl"

  list = %w[
    deny all
    allow 192.168.1.1
    allow ::ffff:192.168.1.2
    allow 192.168.1.3
  ]
  
  # From Socket#peeraddr, see also ACL#allow_socket?
  addr = ["AF_INET", 10, "lc630", "192.168.1.3"]
  
  acl = ACL.new
  p acl.allow_addr?(addr) # => true
  
  acl = ACL.new(list, ACL::DENY_ALLOW)
  p acl.allow_addr?(addr) # => true


== Class Methods

--- new(list=nil, order = DENY_ALLOW) -> ACL
新たな ACL オブジェクトを返します。

list で許可/拒否するアドレスのリストを指定し、
order でデフォルトの挙動を指定します。

order に [[c:ACL::DENY_ALLOW]] を指定するとデフォルトで
すべてのアドレスを拒否します。[[c:ACL::ALLOW_DENY]] を指定すると
デフォルトですべてのアドレスを許可します。

  require "drb/acl"

  list = %w[
    deny all
    allow 192.168.1.1
    allow ::ffff:192.168.1.2
    allow 192.168.1.3
  ]
  
  acl = ACL.new(list, ACL::DENY_ALLOW)

@param list ACLに追加するエントリー
@param order デフォルトで全アドレスを許可/拒否するかを指定します

== Instance Methods
--- allow_addr?(addr) -> bool
addr が ACL で許可されているならば真を返します。

@param addr 判定対象のアドレス

--- allow_socket?(soc) -> bool
ソケットに関連付けられたアドレスが ACL で許可されているならば
真を返します。

@param soc 判定対象のソケット

--- install_list(list) -> ()
ACL に list で指定したエントリーを追加します。

  require "drb/acl"
  acl.install_list(["deny", "192.168.1.45"])

@param list 追加するエントリー


== Constants
--- DENY_ALLOW -> Integer
デフォルトですべてのアドレスを拒否することを意味します。

@see [[m:ACL.new]]

--- ALLOW_DENY -> Integer
デフォルトですべてのアドレスを許可することを意味します。
@see [[m:ACL.new]]

--- VERSION -> [String]
ACL のバージョン。

#@# 何故配列なのかは不明
