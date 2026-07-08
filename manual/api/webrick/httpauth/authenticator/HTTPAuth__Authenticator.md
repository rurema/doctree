---
library: webrick/httpauth/authenticator
---
# module WEBrick::HTTPAuth::Authenticator

## Instance Methods

### def logger -> object

ロガーオブジェクトを返します。

### def realm -> String

レルムを返します。

### def userdb -> WEBrick::HTTPAuth::Htpasswd | WEBrick::HTTPAuth::Htdigest

認証のためのユーザデータベースを返します。

- **SEE** [c:WEBrick::HTTPAuth::BasicAuth], [c:WEBrick::HTTPAuth::Htdigest]

## Constants

### const RequestField -> String

リクエストフィールドのキーの名前です。

### const ResponseField -> String

レスポンスフィールドのキーの名前です。

### const ResponseInfoField -> String

レスポンスインフォフィールドのキーの名前です。

### const AuthException -> Class

認証失敗時に発生する例外のクラスです。

### const AuthScheme -> nil

認証方法を表わします。派生クラスで上書きしなければなりません。
