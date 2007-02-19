require webrick/httpauth/userdb
require webrick/httpauth/basicauth
#@#require tempfile

= class WEBrick::HTTPAuth::Htpasswd < Object
include WEBrick::HTTPAuth::UserDB

Apache の htpasswd 互換のクラス。.htpasswd ファイルを新しく作成することも出来る。
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

--- new(path)
#@todo
Htpasswd オブジェクトを生成する。.htpasswd ファイルのパスを path で与える。

== Instance Methods

--- delete_passwd(realm, user)
#@todo
ユーザのパスワードを削除する。realm は無視される。

--- each{|user, pass| ...}
#@todo
各ユーザとパスワードに関してブロックを評価する。

--- get_passwd(realm, user, reload_db)
#@todo
ユーザのパスワードの crypt された文字列を取得する。reload_db が true の場合、
reload を呼んでからパスワードを取得する。realm は無視される。

--- flush(path=nil)
#@todo
ファイルに書き込む。ファイル名 path を与えた場合は、path に書き込む。

--- reload
#@todo
ファイルから再度読み込む。

--- set_passwd(realm, user, pass)
#@todo
ユーザとパスワードを保存する。realm は無視される。
