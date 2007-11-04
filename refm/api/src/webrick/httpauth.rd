require webrick/httpauth/basicauth
require webrick/httpauth/digestauth
require webrick/httpauth/htpasswd
require webrick/httpauth/htdigest
require webrick/httpauth/htgroup

= module WEBrick::HTTPAuth

ユーザ認証の機能を提供するモジュールです。

== Module Functions

--- basic_auth(req, res, realm){|user, pass| ... }     -> nil

Basic 認証を行うためのメソッドです。

ブロックは user, pass を引数として呼ばれ、
ブロックが true を返すと認証が成功したことになります。
ブロックが false を返すと認証に失敗したとみなし、
例外 WEBrick::HTTPStatus::Unauthorized を投げます。

@param req クライアントからのリクエストを表す [[c:WEBrick::HTTPRequest]] オブジェクトを指定します。

@param res [[c:WEBrick::HTTPResponse]] オブジェクトを指定します。

@param realm 認証のレルムを文字列で指定します。

  srv.mount_proc('/basic_auth') {|req, res|
    HTTPAuth.basic_auth(req, res, "WEBrick's realm") {|user, pass|
      user == 'webrick' && pass == 'supersecretpassword'
    }
    res.body = "hoge"
  }

--- proxy_basic_auth(req, res, realm){|user, pass| ... }     -> nil

プロクシーの Basic 認証行うためのメソッドです。

ブロックは user, pass を引数として呼ばれ、
ブロックが true を返すとユーザを認証したことになります。
ブロックが false を返すと認証に失敗し、例外
WEBrick::HTTPStatus::ProxyAuthenticationRequired を投げます。

@param req クライアントからのリクエストを表す [[c:WEBrick::HTTPRequest]] オブジェクトを指定します。

@param res [[c:WEBrick::HTTPResponse]] オブジェクトを指定します。

@param realm 認証のレルムを文字列で指定します。
