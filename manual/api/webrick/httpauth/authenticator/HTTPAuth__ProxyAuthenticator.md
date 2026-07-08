---
library: webrick/httpauth/authenticator
---
# module WEBrick::HTTPAuth::ProxyAuthenticator

このモジュールはプロキシのためにダイジェスト認証とベーシック認証の両方
の一般的なサポートを提供します。

## Constants

### const RequestField -> "Proxy-Authorization"

リクエストフィールドのキーの名前です。

### const ResponseField -> "Proxy-Authenticate"

レスポンスフィールドのキーの名前です。

### const InfoField -> "Proxy-Authentication-Info"

キーの名前です。

### const AuthException -> Class

[c:WEBrick::HTTPStatus::ProxyAuthenticationRequired] です。

