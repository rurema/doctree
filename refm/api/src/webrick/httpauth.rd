require webrick/httpauth/basicauth
require webrick/httpauth/digestauth
require webrick/httpauth/htpasswd
require webrick/httpauth/htdigest
require webrick/httpauth/htgroup

= module WEBrick::HTTPAuth

[[unknown:執筆者募集]]

[[url:http://shogo.homelinux.org/~ysantoso/webrickguide/html/HTTP_Authentication.html]]

== Module Functions

--- basic_auth(req, res, realm){|user, pass| ... }
Basic 認証を行う。ブロックは user, pass を引数として呼ばれ、
ブロックが true を返すとユーザを認証したことになる。
ブロックが false を返すと認証に失敗し、
例外 WEBrick::HTTPStatus::Unauthorized を投げる。

  srv.mount_proc('/basic_auth') {|req, res|
    HTTPAuth.basic_auth(req, res, "WEBrick's realm") {|user, pass|
      user == 'webrick' && pass == 'supersecretpassword'
    }
    res.body = "hoge"
  }

--- proxy_basic_auth(req, res, realm){|user, pass| ... }
プロクシー [[c:WEBrick::HTTPProxyServer]] のための Basic 認証を行う。
ブロックは user, pass を引数として呼ばれ、
ブロックが true を返すとユーザを認証したことになる。
ブロックが false を返すと認証に失敗し、例外
WEBrick::HTTPStatus::ProxyAuthenticationRequired を投げる。
