require webrick/httpauth/userdb
require webrick/httpauth/digestauth

Apache の htdigest 互換機能を提供するライブラリです。

= class WEBrick::HTTPAuth::Htdigest < Object
include WEBrick::HTTPAuth::UserDB

Apache の htdigest 互換のクラス。

例

 require 'webrick'
 include WEBrick
 htd = HTTPAuth::Htdigest.new('dot.htdigest')
 htd.set_passwd('realm', 'username', 'supersecretpass')
 htd.flush
 htd2 = HTTPAuth::Htdigest.new('dot.htdigest')
 p htd2.get_passwd('realm', 'username', false) == '65fe03e5b0a199462186848cc7fda42b'

== Class Methods

--- new(path) -> WEBrick::HTTPAuth::Htdigest
Htdigest オブジェクトを生成します。

@param path パスワードを保存するファイルのパスを与えます。

== Instance Methods

--- delete_passwd(realm, user)
#@# -> discard
realm に属するユーザ user のパスワードを削除します。

@param realm レルムを指定します。

@param user ユーザ名を指定します。

--- each{|user, realm, pass| ... } -> Hash

ユーザ名、レルム、パスワードをブロックに渡して評価します。

--- flush(path = nil) -> ()

ファイルに書き込みます。ファイル名を与えた場合は、そこに書き込みます。

@param path ファイル名を指定します。

--- get_passwd(realm, user, reload_db) -> String

与えられたレルムとユーザ名からパスワードのハッシュ値を取得して返します。

@param realm レルムを指定します。

@param user ユーザ名を指定します。

@param reload_db 真を指定すると [[m:WEBrick::HTTPAuth::Htdigest#reload]] を呼んでから値を返します。

--- reload
#@# -> discard
ファイルから再度読み込みます。

--- set_passwd(realm, user, pass)
#@# -> discard
与えられた情報をもとに、パスワードをハッシュ化して保存します。

@param realm レルムを指定します。

@param user ユーザ名を指定します。

@param pass パスワードを指定します。


