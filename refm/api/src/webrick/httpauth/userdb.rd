= module WEBrick::HTTPAuth::UserDB

[[c:WEBrick::HTTPAuth::BasicAuth]], [[c:WEBrick::HTTPAuth::DigestAuth]] で使用しているモジュールです。

== Instance Methods

--- auth_type -> Class

[[c:WEBrick::HTTPAuth::BasicAuth]], [[c:WEBrick::HTTPAuth::DigestAuth]] のいずれかを返します。

--- auth_type=(type)

認証のタイプをセットします。

@param type [[c:WEBrick::HTTPAuth::BasicAuth]], [[c:WEBrick::HTTPAuth::DigestAuth]] のいずれかを指定します。

--- make_passwd(realm, user, pass) -> String

[[m:WEBrick::HTTPAuth::UserDB#auth_type]] の make_passwd を呼び出します。

@param realm レルムを指定します。

@param user ユーザ名を指定します。

@param pass パスワードを指定します。

@see [[m:WEBrick::HTTPAuth::BasicAuth#make_passwd]], [[m:WEBrick::HTTPAuth::DigestAuth#make_passwd]]

--- set_passwd(realm, user, pass)
#@# -> discard
与えられた情報をもとに、パスワードをハッシュ化して保存します。

@param realm レルムを指定します。

@param user ユーザ名を指定します。

@param pass パスワードを指定します。

--- get_passwd(realm, user, reload_db = false) -> String

与えられたレルムとユーザ名からパスワードのハッシュ値を取得して返します。

@param realm レルムを指定します。

@param user ユーザ名を指定します。

@param reload_db 無視されます。
