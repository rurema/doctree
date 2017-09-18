#@since 1.9.1
cgi ライブラリのコア機能を提供するライブラリです。
#@end

= class CGI < Object
include CGI::QueryExtension

CGI スクリプトを書くために必要な機能を提供するクラスです。

== Class Methods
--- parse(query) -> Hash

与えられたクエリ文字列をパースします。

@param query クエリ文字列を指定します。

例：
        require "cgi"

        params = CGI.parse("query_string")
          # {"name1" => ["value1", "value2", ...],
          #  "name2" => ["value1", "value2", ...], ... }

#@since 1.9.1
--- accept_charset -> String

受けとることができるキャラクタセットを文字列で返します。
デフォルトは UTF-8 です。

--- accept_charset=(charset)

受けとることができるキャラクタセットを設定します。

@param charset 文字列でキャラクタセットの名前を指定します。

@see [[d:spec/m17n]]

#@end
#@until 1.9.1
#@include(util.rd)
#@end
== Instance Methods

#@since 1.9.1
--- accept_charset -> String

受けとることができるキャラクタセットを文字列で返します。
デフォルトは UTF-8 です。

@see [[m:CGI.accept_charset]], [[m:CGI.accept_charset=]]

--- nph? -> bool
#@#nodoc

#@end

--- header(options = "text/html") -> String

HTTP ヘッダを options に従って生成します。 [[m:CGI#out]] と違い、標準出力には出力しません。
[[m:CGI#out]] を使わずに自力で HTML を出力したい場合などに使います。
このメソッドは文字列エンコーディングを変換しません。

ヘッダのキーとしては以下が利用可能です。

: type
  Content-Type ヘッダです。デフォルトは "text/html" です。
: charset
  ボディのキャラクタセットを Content-Type ヘッダに追加します。
: nph
  真偽値を指定します。真ならば、HTTP のバージョン、ステータスコード、
  Date ヘッダをセットします。また Server と Connection の各ヘッダにもデフォルト値をセットします。
  偽を指定する場合は、これらの値を明示的にセットしてください。
: status
  HTTP のステータスコードを指定します。
  このリストの下に利用可能なステータスコードのリストがあります。
: server
  サーバソフトウェアの名称指定します。Server ヘッダに対応します。
: connection
  接続の種類を指定します。Connection ヘッダに対応します。
: length
  送信するコンテンツの長さを指定します。Content-Length ヘッダに対応します。
: language
  送信するコンテンツの言語を指定します。Content-Language ヘッダに対応します。
: expires
  送信するコンテンツの有効期限を [[c:Time]] のインスタンスで指定します。
  Expires ヘッダに対応します。
: cookie
  クッキーとして文字列か [[c:CGI::Cookie]] のインスタンス、またはそれらの配列かハッシュを指定します。
  一つ以上の Set-Cookie ヘッダに対応します。

status パラメータには以下の文字列が使えます。

        "OK"                  --> "200 OK"
        "PARTIAL_CONTENT"     --> "206 Partial Content"
        "MULTIPLE_CHOICES"    --> "300 Multiple Choices"
        "MOVED"               --> "301 Moved Permanently"
        "REDIRECT"            --> "302 Found"
        "NOT_MODIFIED"        --> "304 Not Modified"
        "BAD_REQUEST"         --> "400 Bad Request"
        "AUTH_REQUIRED"       --> "401 Authorization Required"
        "FORBIDDEN"           --> "403 Forbidden"
        "NOT_FOUND"           --> "404 Not Found"
        "METHOD_NOT_ALLOWED"  --> "405 Method Not Allowed"
        "NOT_ACCEPTABLE"      --> "406 Not Acceptable"
        "LENGTH_REQUIRED"     --> "411 Length Required"
        "PRECONDITION_FAILED" --> "412 Rrecondition Failed"
        "SERVER_ERROR"        --> "500 Internal Server Error"
        "NOT_IMPLEMENTED"     --> "501 Method Not Implemented"
        "BAD_GATEWAY"         --> "502 Bad Gateway"
        "VARIANT_ALSO_VARIES" --> "506 Variant Also Negotiates"

@param options [[c:Hash]] か文字列で HTTP ヘッダを生成するための情報を指定します。

例：
        header
          # Content-Type: text/html

        header("text/plain")
          # Content-Type: text/plain

        header({"nph"        => true,
                "status"     => "OK",  # == "200 OK"
                  # "status"     => "200 GOOD",
                "server"     => ENV['SERVER_SOFTWARE'],
                "connection" => "close",
                "type"       => "text/html",
                "charset"    => "iso-2022-jp",
                  # Content-Type: text/html; charset=iso-2022-jp
                "language"   => "ja",
                "expires"    => Time.now + 30,
                "cookie"     => [cookie1, cookie2],
                "my_header1" => "my_value",
                "my_header2" => "my_value"})

例：
        cgi = CGI.new('html3')
        print cgi.header({"charset" => "shift_jis", "status" => "OK"})
        print "<html><head><title>TITLE</title></head>\r\n"
        print "<body>BODY</body></html>\r\n"

@see [[ruby-list:35911]]

--- out(options = "text/html") { .... }

HTTP ヘッダと、ブロックで与えられた文字列を標準出力に出力します。

HEADリクエスト (REQUEST_METHOD == "HEAD") の場合は HTTP ヘッダのみを出力します。

charset が "iso-2022-jp"・"euc-jp"・"shift_jis" のいずれかで
ある場合は文字列エンコーディングを自動変換し、language を "ja"にします。

@param options [[c:Hash]] か文字列で HTTP ヘッダを生成するための情報を指定します。

例：
        cgi = CGI.new
        cgi.out{ "string" }
          # Content-Type: text/html
          # Content-Length: 6
          #
          # string

        cgi.out("text/plain"){ "string" }
          # Content-Type: text/plain
          # Content-Length: 6
          #
          # string

        cgi.out({"nph"        => true,
                 "status"     => "OK",  # == "200 OK"
                 "server"     => ENV['SERVER_SOFTWARE'],
                 "connection" => "close",
                 "type"       => "text/html",
                 "charset"    => "iso-2022-jp",
                   # Content-Type: text/html; charset=iso-2022-jp
                 "language"   => "ja",
                 "expires"    => Time.now + (3600 * 24 * 30),
                 "cookie"     => [cookie1, cookie2],
                 "my_header1" => "my_value",
                 "my_header2" => "my_value"}){ "string" }

@see [[m:CGI#header]]

--- print(*strings)
#@todo

引数の文字列を標準出力に出力します。
cgi.print は $DEFAULT_OUTPUT.print と等価です。

例：
       cgi = CGI.new
       cgi.print "This line is a part of content body.\r\n"

== Constants

--- CR -> String

キャリッジリターンを表す文字列です。

--- LF -> String

ラインフィードを表す文字列です。

--- EOL -> String

改行文字です。

#@# --- REVISION -> String
#@# nodoc

#@since 1.9.2
--- NEEDS_BINMODE -> bool

ファイルを開くときにバイナリモードが必要かどうかを表す定数です。
プラットフォーム依存の定数です。
#@end

--- PATH_SEPARATOR -> Hash

パスの区切り文字を格納します。

--- HTTP_STATUS -> Hash

HTTP のステータスコードを表すハッシュです。

#@until 1.9.1
#@# 1.9.1 以降は cgi/util.rd を参照
--- RFC822_DAYS -> [String]

[[rfc:822]] で定義されている曜日の略称を返します。

@see [[rfc:822]]

--- RFC822_MONTHS -> [String]

[[rfc:822]] で定義されている月名の略称を返します。

@see [[rfc:822]]
#@end
#@since 1.9.1
--- MAX_MULTIPART_LENGTH -> Integer

Maximum content length of multipart data

--- MAX_MULTIPART_COUNT -> Integer

Maximum number of request parameters when multipart

#@end
= module CGI::QueryExtension

クエリ文字列を扱うためのメソッドを定義しているモジュールです。

== Instance Methods

--- [](key) -> Array

文字列 key に対応するパラメータを配列で返します。
key に対応するパラメータが見つからなかった場合は、nil を返します。（[[m:CGI#params]]と等価です）

フォームから入力された値や、URL に埋め込まれた QUERY_STRING のパース結果の取得などに使用します。

@param key キーを文字列で指定します。

--- accept -> String

ENV['HTTP_ACCEPT'] を返します。

--- accept_charset -> String

ENV['HTTP_ACCEPT_CHARSET'] を返します。

--- accept_encoding -> String

ENV['HTTP_ACCEPT_ENCODING'] を返します。

--- accept_language -> String

ENV['HTTP_ACCEPT_LANGUAGE'] を返します。

--- auth_type -> String

ENV['AUTH_TYPE'] を返します。

--- cache_control -> String

ENV['HTTP_CACHE_CONTROL'] を返します。

--- content_length -> Integer

ENV['CONTENT_LENGTH'] を返します。

--- content_type -> String

ENV['CONTENT_TYPE'] を返します。

--- cookies -> Hash

クッキーの名前と値をペアにした要素を持つハッシュを返します。

--- cookies=(value)

クッキーをセットします。

@param value クッキーの名前と値をペアにした要素を持つハッシュを指定します。

--- from -> String

ENV['HTTP_FROM'] を返します。

--- gateway_interface -> String

ENV['GATEWAY_INTERFACE'] を返します。

--- has_key?(*args) -> bool
--- key?(*args) -> bool
--- include?(*args) -> bool

与えられたキーがクエリに含まれている場合は、真を返します。
そうでない場合は、偽を返します。

@param args キーを一つ以上指定します。

--- host -> String

ENV['HTTP_HOST'] を返します。

--- keys(*args) -> [String]

すべてのパラメータのキーを配列として返します。

--- multipart? -> bool

マルチパートフォームの場合は、真を返します。
そうでない場合は、偽を返します。

       例：
       cgi = CGI.new
       if cgi.multipart?
         field1=cgi['field1'].read
       else
         field1=cgi['field1']
       end

--- negotiate -> String

ENV['HTTP_NEGOTIATE'] を返します。

--- params -> Hash

パラメータを格納したハッシュを返します。

フォームから入力された値や、URLに埋め込まれた QUERY_STRING のパース結果の取得などに使用します。

      cgi = CGI.new
      cgi.params['developer']     # => ["Matz"] (Array)
      cgi.params['developer'][0]  # => "Matz"
      cgi.params['']              # => nil

--- params=(hash)

与えられたハッシュをパラメータにセットします。

@param hash ハッシュを指定します。


--- path_info -> String

ENV['PATH_INFO'] を返します。

--- path_translated -> String

ENV['PATH_TRANSLATED'] を返します。

--- pragma -> String

ENV['HTTP_PRAGMA'] を返します。

--- query_string -> String

ENV['QUERY_STRING'] を返します。

--- raw_cookie -> String

ENV["HTTP_COOKIE"] を返します。

--- raw_cookie2 -> String

ENV["HTTP_COOKIE2"] を返します。

--- referer -> String

ENV['HTTP_REFERER'] を返します。

--- remote_addr -> String

ENV['REMOTE_ADDR'] を返します。

--- remote_host -> String

ENV['REMOTE_HOST'] を返します。

--- remote_ident -> String

ENV['REMOTE_IDENT'] を返します。

--- remote_user -> String

ENV['REMOTE_USER'] を返します。

--- request_method -> String

ENV['REQUEST_METHOD'] を返します。

--- script_name -> String

ENV['SCRIPT_NAME'] を返します。

--- server_name -> String

ENV['SERVER_NAME'] を返します。

--- server_port -> Integer

ENV['SERVER_PORT'] を返します。

--- server_protocol -> String

ENV['SERVER_PROTOCOL'] を返します。

--- server_software -> String

ENV['SERVER_SOFTWARE'] を返します。

--- user_agent -> String

ENV['HTTP_USER_AGENT'] を返します。

#@since 1.9.1
--- create_body(is_large) -> StringIO | Tempfile
#@# nodoc

--- files -> Hash

アップロードされたファイルの名前とその内容を表すオブジェクトをペアとする要素を持つハッシュを返します。

--- unescape_filename? -> bool
#@# nodoc

#@end

= module CGI::QueryExtension::Value
#@# nodoc

== Instance Methods

--- [](idx, *args)
#@todo

--- first -> self
--- last  -> self
#@todo

--- set_params(params)
#@todo

--- to_a -> Array
--- to_ary -> Array
#@todo

= class CGI::InvalidEncoding < Exception

不正な文字エンコーディングが現れたときに発生する例外です。

