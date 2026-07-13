---
library: webrick/httpauth/digestauth
include:
  - WEBrick::HTTPAuth::Authenticator
---
# class WEBrick::HTTPAuth::DigestAuth < Object

HTTP の Digest 認証のためのクラスです。

[RFC:2617] も参照してください。

```ruby title="例"
require 'webrick'
config = { :Realm => 'DigestAuth example realm' }

htdigest = WEBrick::HTTPAuth::Htdigest.new 'my_password_file'
htdigest.set_passwd config[:Realm], 'username', 'password'
htdigest.flush

config[:UserDB] = htdigest

digest_auth = WEBrick::HTTPAuth::DigestAuth.new config
```

サーブレットの initialize メソッドの中でこのクラスのインスタンスを作成
しないようにしてください。デフォルトでは WEBrick はリクエストのたびにサー
ブレットのインスタンスを生成しますが、
[c:WEBrick::HTTPAuth::DigestAuth] のオブジェクトはリクエストをまたい
で利用しなければならないためです。

## Class Methods

### def make_passwd(realm, user, pass) -> String

与えられた情報を使用してハッシュ化したパスワードを生成します。

- **param** `realm` -- レルムを指定します。

- **param** `user` -- ユーザ名を指定します。

- **param** `pass` -- パスワードを指定します。

### def new(config, default = WEBrick::Config::DigestAuth) -> WEBrick::HTTPAuth::DigestAuth

自身を初期化します。

認証を実行するために、リクエスト間で状態を保存し、複数のリクエストに対
して同一のインスタンスを使用してください。

- **param** `config` -- 設定を保持しているハッシュを指定します。
              :Realm と :UserDB は必ず指定しなければなりません。

- **param** `default` -- デフォルトは [m:WEBrick::Config::DigestAuth] です。

- **SEE** [m:WEBrick::Config::DigestAuth]

## Instance Methods

### def algorithm -> String

アルゴリズムを表す文字列を返します。

### def authenticate(request, response) -> true

クライアントから送られてきたユーザ名とパスワードを認証します。
認証に失敗した場合は challenge を呼びます。

- **param** `request` -- [c:WEBrick::HTTPRequest] のインスタンスを指定します。

- **param** `response` -- [c:WEBrick::HTTPResponse] のインスタンスを指定します。

- **raise** `WEBrick::HTTPStatus::Unauthorized` -- 認証に失敗した場合に発生します。

### def challenge(request, response, stale = false)

クライアントにパスワードを要求するためにレスポンスに WWW-Authenticate ヘッダを
設定し、例外 WEBrick::HTTPStatus::Unauthorized を発生させます。

- **param** `request` -- [c:WEBrick::HTTPRequest] のインスタンスを指定します。

- **param** `response` -- [c:WEBrick::HTTPResponse] のインスタンスを指定します。

- **raise** `WEBrick::HTTPStatus::Unauthorized` -- このメソッドを呼ぶと必ず発生します。

### def qop -> String

Qop キーの値を返します。


