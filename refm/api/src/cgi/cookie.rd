#@since 1.9.1
HTTP クッキーを利用するためのクラスを定義したライブラリです。
#@end

#@# = class CGI::Cookie < DelegateClass(Array)
= class CGI::Cookie < Array

クッキーを表すクラスです。

例:
  cookie1 = CGI::Cookie.new("name", "value1", "value2", ...)
  cookie1 = CGI::Cookie.new({"name" => "name", "value" => "value"})
  cookie1 = CGI::Cookie.new({'name'    => 'name',
                             'value'   => ['value1', 'value2', ...],
                             'path'    => 'path',   # optional
                             'domain'  => 'domain', # optional
                             'expires' => Time.now, # optional
                             'secure'  => true      # optional
                            })

  cgi.out({"cookie" => [cookie1, cookie2]}){ "string" }

  name    = cookie1.name
  values  = cookie1.value
  path    = cookie1.path
  domain  = cookie1.domain
  expires = cookie1.expires
  secure  = cookie1.secure

  cookie1.name    = 'name'
  cookie1.value   = ['value1', 'value2', ...]
  cookie1.path    = 'path'
  cookie1.domain  = 'domain'
  cookie1.expires = Time.now + 30
  cookie1.secure  = true

@see [[rfc:2965]]

== Class Methods

--- new(name = "", *value) -> CGI::Cookie

クッキーオブジェクトを作成します。

第一引数にハッシュを指定する場合は、以下のキーが使用可能です。

: name
  クッキーの名前を指定します。必須。
: value
  クッキーの値、または値のリストを指定します。
: path
  このクッキーを適用するパスを指定します。デフォルトはこの CGI スクリプトのベースディレクトリです。
: domain
  このクッキーを適用するドメインを指定します。
: expires
  このクッキーの有効期限を [[c:Time]] のインスタンスで指定します。
: secure
  真を指定すると、このクッキーはセキュアクッキーになります。
  デフォルトは偽です。セキュアクッキーは HTTPS の時のみ送信されます。

@param name クッキーの名前を文字列で指定します。
            クッキーの名前と値を要素とするハッシュを指定します。

@param value name が文字列である場合、値のリストを一つ以上指定します。

        例：
        cookie1 = CGI::Cookie.new("name", "value1", "value2", ...)
        cookie1 = CGI::Cookie.new({"name" => "name", "value" => "value"})
        cookie1 = CGI::Cookie.new({'name'    => 'name',
                                   'value'   => ['value1', 'value2', ...],
                                   'path'    => 'path',   # optional
                                   'domain'  => 'domain', # optional
                                   'expires' => Time.now, # optional
                                   'secure'  => true      # optional
                                  })

        cgi.out({"cookie" => [cookie1, cookie2]}){ "string" }

        name    = cookie1.name
        values  = cookie1.value
        path    = cookie1.path
        domain  = cookie1.domain
        expires = cookie1.expires
        secure  = cookie1.secure

        cookie1.name    = 'name'
        cookie1.value   = ['value1', 'value2', ...]
        cookie1.path    = 'path'
        cookie1.domain  = 'domain'
        cookie1.expires = Time.now + 30
        cookie1.secure  = true

--- parse(raw_cookie) -> Hash

クッキー文字列をパースします。

@param raw_cookie 生のクッキーを表す文字列を指定します。

        例：
        cookies = CGI::Cookie.parse("raw_cookie_string")
          # { "name1" => cookie1, "name2" => cookie2, ... }

== Instance Methods

--- name -> String

クッキーの名前を返します。

--- name=(value)

クッキーの名前をセットします。

@param value 名前を指定します。 

--- value -> Array

クッキーの値を返します。

--- value=(value)

クッキーの値をセットします。

@param value 変更後の値を指定します。

--- path -> String

クッキーを適用するパスを返します。

--- path=(value)

クッキーを適用するパスをセットします。

@param value パスを指定します。

--- domain -> String

クッキーを適用するドメインを返します。

--- domain=(value)

クッキーを適用するドメインをセットします。

@param value ドメインを指定します。

--- expires -> Time

クッキーの有効期限を返します。

--- expires=(value)

クッキーの有効期限をセットします。

@param value 有効期限を [[c:Time]] のインスタンスで指定します。

--- secure -> bool

自身がセキュアクッキーである場合は、真を返します。
そうでない場合は、偽を返します。

--- secure=(val)

セキュアクッキーであるかどうかを変更します。

@param val 真を指定すると自身はセキュアクッキーになります。

--- to_s -> String

クッキーの文字列表現を返します。
