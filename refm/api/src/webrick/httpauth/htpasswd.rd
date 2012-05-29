require webrick/httpauth/userdb
require webrick/httpauth/basicauth

Apache の htpasswd 互換のクラスを提供するライブラリです。

= class WEBrick::HTTPAuth::Htpasswd < Object
include WEBrick::HTTPAuth::UserDB

Apache の htpasswd 互換のクラスです。
.htpasswd ファイルを新しく作成することも出来ます。
htpasswd -m (MD5) や -s (SHA) で作成された .htpasswd ファイルには対応していません。


例

 require 'webrick'
 include WEBrick
 htpd = HTTPAuth::Htpasswd.new('dot.htpasswd')
 htpd.set_passwd(nil, 'username', 'supersecretpass')
 htpd.flush
 htpd2 = HTTPAuth::Htpasswd.new('dot.htpasswd')
 pass = htpd2.get_passwd(nil, 'username', false)
 p pass == 'supersecretpass'.crypt(pass[0,2])

== Class Methods

--- new(path) -> WEBrick::HTTPAuth::Htpasswd

Htpasswd オブジェクトを生成します。

@param path パスワードを保存するファイルのパスを与えます。

== Instance Methods

--- delete_passwd(realm, user) -> String

ユーザのパスワードを削除します。realm は無視されます。

@param realm レルムは無視されます。

@param user ユーザ名を指定します。

--- each{|user, pass| ...} -> Hash

ユーザ名とパスワードをブロックに与えて評価します。

--- get_passwd(realm, user, reload_db) -> String

ユーザのパスワードの crypt された文字列を取得します。

@param realm レルムは無視されます。

@param user ユーザ名を指定します。

@param reload_db 真を指定すると [[m:WEBrick::HTTPAuth::Htpasswd#reload]] を呼んでから値を返します。


--- flush(path = nil)
#@# -> discard
ファイルに書き込みます。ファイル名を与えた場合は、そこに書き込みます。

@param path ファイル名を指定します。

--- reload
#@# -> discard
ファイルから再度読み込みます。

--- set_passwd(realm, user, pass)
#@# -> discard
与えられた情報をもとに、パスワードをハッシュ化して保存します。

@param realm レルムは無視されます。

@param user ユーザ名を指定します。

@param pass パスワードを指定します。
