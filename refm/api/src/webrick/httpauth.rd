require webrick/httpauth/basicauth
require webrick/httpauth/digestauth
require webrick/httpauth/htpasswd
require webrick/httpauth/htdigest
require webrick/httpauth/htgroup

ユーザ認証の機能を提供するライブラリです。

= module WEBrick::HTTPAuth

ユーザ認証の機能を提供するモジュールです。

== Module Functions

--- basic_auth(req, res, realm){|user, pass| ... }     -> nil

Basic 認証を行うためのメソッドです。

与えられたブロックは user, pass をブロックパラメータとして渡されて評価されます。
ブロックの評価結果が真である場合、認証が成功したことになります。
ブロックの評価結果が偽である場合、認証は失敗したことになり、例外が発生します。

@param req クライアントからのリクエストを表す [[c:WEBrick::HTTPRequest]] オブジェクトを指定します。

@param res [[c:WEBrick::HTTPResponse]] オブジェクトを指定します。

@param realm 認証のレルムを文字列で指定します。

@raise WEBrick::HTTPStatus::Unauthorized 認証に失敗した場合に発生します。

  require 'webrick'
  srv.mount_proc('/basic_auth') {|req, res|
    HTTPAuth.basic_auth(req, res, "WEBrick's realm") {|user, pass|
      user == 'webrick' && pass == 'supersecretpassword'
    }
    res.body = "hoge"
  }

--- proxy_basic_auth(req, res, realm){|user, pass| ... }     -> nil

プロクシの Basic 認証行うためのメソッドです。

与えられたブロックは user, pass をブロックパラメータとして渡されて評価されます。
ブロックの評価結果が真である場合、認証が成功したことになります。
ブロックの評価結果が偽である場合、認証は失敗したことになり、例外が発生します。

@param req クライアントからのリクエストを表す [[c:WEBrick::HTTPRequest]] オブジェクトを指定します。

@param res [[c:WEBrick::HTTPResponse]] オブジェクトを指定します。

@param realm 認証のレルムを文字列で指定します。

@raise WEBrick::HTTPStatus::ProxyAuthenticationRequired 認証に失敗した場合に発生します。
