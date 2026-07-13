---
type: library
---
HTTP のステータスを表す例外クラスを提供します。

# module WEBrick::HTTPStatus

HTTP のステータスを表す例外クラスを提供するモジュールです。
ステータスコード 200 などの成功の場合も含まれます。

以下のような継承による階層を構成しています。

```text
StandardError
 * WEBrick::HTTPStatus::Status
    * WEBrick::HTTPStatus::Info             (1XX)
    * WEBrick::HTTPStatus::Success          (2XX)
    * WEBrick::HTTPStatus::Redirect         (3XX)
    * WEBrick::HTTPStatus::Error            
       * WEBrick::HTTPStatus::ClientError   (4XX)
       * WEBrick::HTTPStatus::ServerError   (5XX)
```

## Singleton Methods

### def [](code)    -> Class

指定された整数が表すステータスコードに対応する WEBrick::HTTPStatus::Status
のサブクラスを返します。

- **param** `code` -- HTTP のステータスコードを表す整数を指定します。

```ruby
require 'webrick'
p WEBrick::HTTPStatus[200]   #=> WEBrick::HTTPStatus::OK
```

## Module Functions

### module_function def reason_phrase(code)     -> String

指定された整数が表すステータスコードに対応する reason phrase
を表す文字列を返します。

- **param** `code` -- HTTP のステータスコードを表す整数か文字列を指定します。

```ruby
require 'webrick'
p WEBrick::HTTPStatus.reason_phrase(304)   #=> "Not Modified"
```

### module_function def info?(code)    -> bool

指定された整数が表すステータスコードが 1XX である場合に
true を返します。そうでない場合に false を返します。

- **param** `code` -- HTTP のステータスコードを表す整数を指定します。

### module_function def success?(code)    -> bool

指定された整数が表すステータスコードが 2XX である場合に
true を返します。そうでない場合に false を返します。

- **param** `code` -- HTTP のステータスコードを表す整数か文字列を指定します。

### module_function def redirect?(code)    -> bool

指定された整数が表すステータスコードが 3XX である場合に
true を返します。そうでない場合に false を返します。

- **param** `code` -- HTTP のステータスコードを表す整数か文字列を指定します。

### module_function def error?(code)    -> bool

指定された整数が表すステータスコードが 4XX, 5xx である場合に
true を返します。そうでない場合に false を返します。

- **param** `code` -- HTTP のステータスコードを表す整数か文字列を指定します。

### module_function def client_error?(code)    -> bool

指定された整数が表すステータスコードが 4XX である場合に
true を返します。そうでない場合に false を返します。

- **param** `code` -- HTTP のステータスコードを表す整数か文字列を指定します。

### module_function def server_error?(code)    -> bool

指定された整数が表すステータスコードが 5XX である場合に
true を返します。そうでない場合に false を返します。

- **param** `code` -- HTTP のステータスコードを表す整数か文字列を指定します。

## Constants

#@#--- StatusMessage
#@#todo

#@#--- CodeToError
#@#todo

### const RC_CONTINUE
### const RC_SWITCHING_PROTOCOLS
### const RC_OK
### const RC_CREATED
### const RC_ACCEPTED
### const RC_NON_AUTHORITATIVE_INFORMATION
### const RC_NO_CONTENT
### const RC_RESET_CONTENT
### const RC_PARTIAL_CONTENT
### const RC_MULTIPLE_CHOICES
### const RC_MOVED_PERMANENTLY
### const RC_FOUND
### const RC_SEE_OTHER
### const RC_NOT_MODIFIED
### const RC_USE_PROXY
### const RC_TEMPORARY_REDIRECT
### const RC_BAD_REQUEST
### const RC_UNAUTHORIZED
### const RC_PAYMENT_REQUIRED
### const RC_FORBIDDEN
### const RC_NOT_FOUND
### const RC_METHOD_NOT_ALLOWED
### const RC_NOT_ACCEPTABLE
### const RC_PROXY_AUTHENTICATION_REQUIRED
### const RC_REQUEST_TIMEOUT
### const RC_CONFLICT
### const RC_GONE
### const RC_LENGTH_REQUIRED
### const RC_PRECONDITION_FAILED
### const RC_REQUEST_ENTITY_TOO_LARGE
### const RC_REQUEST_URI_TOO_LARGE
### const RC_UNSUPPORTED_MEDIA_TYPE
### const RC_REQUEST_RANGE_NOT_SATISFIABLE
### const RC_EXPECTATION_FAILED
### const RC_INTERNAL_SERVER_ERROR
### const RC_NOT_IMPLEMENTED
### const RC_BAD_GATEWAY
### const RC_SERVICE_UNAVAILABLE
### const RC_GATEWAY_TIMEOUT
### const RC_HTTP_VERSION_NOT_SUPPORTED

HTTP のステータスコードを表す整数です。

```ruby
require 'webrick'
p WEBrick::HTTPStatus::RC_INTERNAL_SERVER_ERROR   #=> 500
```


# class WEBrick::HTTPStatus::Status < StandardError
HTTP のステータスコードの親クラスです。
# class WEBrick::HTTPStatus::Info < WEBrick::HTTPStatus::Status
HTTP のステータスコード情報提供 1XX の親クラスです。
# class WEBrick::HTTPStatus::Success < WEBrick::HTTPStatus::Status
HTTP のステータスコード成功 2XX の親クラスです。
# class WEBrick::HTTPStatus::Redirect < WEBrick::HTTPStatus::Status
HTTP のステータスコード転送 3XX の親クラスです。
# class WEBrick::HTTPStatus::Error < WEBrick::HTTPStatus::Status
HTTP のステータスコードエラーの親クラスです。
# class WEBrick::HTTPStatus::ClientError < WEBrick::HTTPStatus::Error
HTTP のステータスコードクライアントエラー 4XX の親クラスです。
# class WEBrick::HTTPStatus::ServerError < WEBrick::HTTPStatus::Error
HTTP のステータスコードサーバエラー 5XX の親クラスです。

# class WEBrick::HTTPStatus::EOFError < StandardError

# class WEBrick::HTTPStatus::Continue < WEBrick::HTTPStatus::Info
HTTP のステータスコード 100 Continue を表すクラスです。
# class WEBrick::HTTPStatus::SwitchingProtocols < WEBrick::HTTPStatus::Info
HTTP のステータスコード 101 Switching Protocols を表すクラスです。

# class WEBrick::HTTPStatus::OK < WEBrick::HTTPStatus::Success
HTTP のステータスコード 200 OK を表すクラスです。
# class WEBrick::HTTPStatus::Created < WEBrick::HTTPStatus::Success
HTTP のステータスコード 201 Created を表すクラスです。
# class WEBrick::HTTPStatus::Accepted < WEBrick::HTTPStatus::Success
HTTP のステータスコード 202 Accepted を表すクラスです。
# class WEBrick::HTTPStatus::NonAuthoritativeInformation < WEBrick::HTTPStatus::Success
HTTP のステータスコード 203 Non-Authoritative Information を表すクラスです。
# class WEBrick::HTTPStatus::NoContent < WEBrick::HTTPStatus::Success
HTTP のステータスコード 204 No Content を表すクラスです。
# class WEBrick::HTTPStatus::ResetContent < WEBrick::HTTPStatus::Success
HTTP のステータスコード 205 Reset Content を表すクラスです。
# class WEBrick::HTTPStatus::PartialContent < WEBrick::HTTPStatus::Success
HTTP のステータスコード 206 Partial Content を表すクラスです。
# class WEBrick::HTTPStatus::MultipleChoices < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 300 Multiple Choices を表すクラスです。
# class WEBrick::HTTPStatus::MovedPermanently < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 301 Moved Permanently を表すクラスです。
# class WEBrick::HTTPStatus::Found < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 302 Found を表すクラスです。
# class WEBrick::HTTPStatus::SeeOther < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 303 See Other を表すクラスです。
# class WEBrick::HTTPStatus::NotModified < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 304 Not Modified を表すクラスです。
# class WEBrick::HTTPStatus::UseProxy < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 305 Use Proxy を表すクラスです。
# class WEBrick::HTTPStatus::TemporaryRedirect < WEBrick::HTTPStatus::Redirect
HTTP のステータスコード 307 Temporary Redirect を表すクラスです。

# class WEBrick::HTTPStatus::BadRequest < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 400 Bad Request を表すクラスです。
# class WEBrick::HTTPStatus::Unauthorized < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 401 Unauthorized を表すクラスです。
# class WEBrick::HTTPStatus::PaymentRequired < WEBrick::HTTPStatus::ClientError

# class WEBrick::HTTPStatus::Forbidden < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 403 Forbidden を表すクラスです。
# class WEBrick::HTTPStatus::NotFound < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 404 Not Found を表すクラスです。
# class WEBrick::HTTPStatus::MethodNotAllowed < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 405 Method Not Allowed を表すクラスです。
# class WEBrick::HTTPStatus::NotAcceptable < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 406 Not Acceptable を表すクラスです。
# class WEBrick::HTTPStatus::ProxyAuthenticationRequired < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 407 Proxy Authentication Required を表すクラスです。
# class WEBrick::HTTPStatus::RequestTimeout < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 408 Request Timeout を表すクラスです。
# class WEBrick::HTTPStatus::Conflict < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 409 Conflict を表すクラスです。
# class WEBrick::HTTPStatus::Gone < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 410 Gone を表すクラスです。
# class WEBrick::HTTPStatus::LengthRequired < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 411 Length Required を表すクラスです。
# class WEBrick::HTTPStatus::PreconditionFailed < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 412 Precondition Failed を表すクラスです。
# class WEBrick::HTTPStatus::RequestEntityTooLarge < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 413 Request Entity Too Large を表すクラスです。
# class WEBrick::HTTPStatus::RequestURITooLarge < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 414 Request-URI Too Long を表すクラスです。
# class WEBrick::HTTPStatus::UnsupportedMediaType < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 415 Unsupported Media Type を表すクラスです。
# class WEBrick::HTTPStatus::RequestRangeNotSatisfiable < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 416 Requested Range Not Satisfiable を表すクラスです。
# class WEBrick::HTTPStatus::ExpectationFailed < WEBrick::HTTPStatus::ClientError
HTTP のステータスコード 417 Expectation Failed を表すクラスです。

# class WEBrick::HTTPStatus::InternalServerError < WEBrick::HTTPStatus::ServerError
HTTP のステータスコード 500 Internal Server Error を表すクラスです。
# class WEBrick::HTTPStatus::NotImplemented < WEBrick::HTTPStatus::ServerError
HTTP のステータスコード 501 Not Implemented を表すクラスです。
# class WEBrick::HTTPStatus::BadGateway < WEBrick::HTTPStatus::ServerError
HTTP のステータスコード 502 Bad Gateway を表すクラスです。
# class WEBrick::HTTPStatus::ServiceUnavailable < WEBrick::HTTPStatus::ServerError
HTTP のステータスコード 503 Service Unavailable を表すクラスです。
# class WEBrick::HTTPStatus::GatewayTimeout < WEBrick::HTTPStatus::ServerError
HTTP のステータスコード 504 Gateway Timeout を表すクラスです。
# class WEBrick::HTTPStatus::HTTPVersionNotSupported < WEBrick::HTTPStatus::ServerError
HTTP のステータスコード 505 HTTP Version Not Supported を表すクラスです。
