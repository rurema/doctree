CGI プログラムの支援ライブラリです。

CGI プロトコルの詳細については以下の文書を参照してください。

  * [[url:http://Web.Golux.Com/coar/cgi/draft-coar-cgi-v11-03.txt]]
  * [[RFC:3875]]: The Common Gateway Interface (CGI) Version 1.1

=== 使用例

==== フォームフィールドの値を得る

  require "cgi"
  cgi = CGI.new
  values = cgi['field_name']   # <== 'field_name' の配列
    # 'field_name' が指定されていなかったら、 []を返す。 (1.6)
    # 'field_name' が指定されていなかったら、 ""を返す。(1.8)
#@#
  fields = cgi.keys            # <== field nameの配列

#@# returns true if form has 'field_name'
  # フォームに 'field_name' というfield nameがあるときに真
  cgi.has_key?('field_name')
  cgi.include?('field_name')

==== フォームフィールドの値をハッシュとして得る

フォームの値をハッシュとして得るには CGI#params を使います。

  例
  require "cgi"
  cgi = CGI.new
  params = cgi.params

また CGI#params は毎回同じ Hash オブジェクトを返すので
以下のような使いかたもできます。

  cgi.params['new_field_name'] = ["value"]  # 新しいパラメータを加える
  cgi.params['field_name'] = ["new_value"]  # パラメータの値を変える
  cgi.params.delete('field_name')           # パラメータを消去
  cgi.params.clear                          # 全パラメータを消去

==== フォームフィールドの値をファイルに保存する

PStore を使うのが最も簡単です。

  # 保存
  require 'pstore'
  db = PStore.new("query.db")
  db.transaction do
    db["params"] = cgi.params
  end

  # 復帰
  require 'pstore'
  db = PStore.new("query.db")
  db.transaction do
    cgi.params = db["params"]
  end

ただし、PStore は Ruby のバージョンによってデータ互換性が
なくなることがあるので、長い期間データを保存することがある
場合には検討が必要です。

[[c:PStore]] も参照してください。

==== マルチパートフィールドの値を取得する（ファイル送信）

  require "cgi"
  cgi = CGI.new
  value = cgi.params['field_name'][0]   # TempFile オブジェクト（Ruby 1.8では 10240バイト未満の場合は StringIOオブジェクト）
  value.read                            # 本文（送られてきたファイルの中身）
  value.local_path                      # ローカルファイルのパス（Ruby 1.8では存在しない）
  value.original_filename               # 元の名前
  value.content_type                    # content_type



==== クライアントにクッキーを渡す

  require "cgi"
  cgi = CGI.new
  for name, cookie in cgi.cookies
    cookie.expires = Time.now + 30
  end
  cgi.out("cookie" => cgi.cookies){"string"}

  cgi.cookies # { "name1" => cookie1, "name2" => cookie2, ... }

  require "cgi"
  cgi = CGI.new
  cgi.cookies['name'].expires = Time.now + 30
  cgi.out("cookie" => cgi.cookies['name']){"string"}

==== クライアントからクッキーを得る

  require "cgi"
  cgi = CGI.new
  values = cgi.cookies['name']  # values は name クッキーの値の配列。
                                # name クッキーが存在しない場合は空配列を返す。
  names = cgi.cookies.keys      # 全てのクッキーの名前の配列

==== CGI に関連する環境変数の値を取得する

CGI に関連する環境変数の値は直接 ENV から得る他に、
CGI クラスのメソッドで得ることもできます。
基本的には環境変数の名前を downcase したメソッドにマップされます。
例えば AUTH_TYPE には CGI#auth_type が対応します。

  require "cgi"
  cgi = CGI.new
  value = cgi.auth_type

このような環境変数には以下のものがあります。

  * AUTH_TYPE
  * CONTENT_LENGTH
  * CONTENT_TYPE
  * GATEWAY_INTERFACE
  * PATH_INFO
  * PATH_TRANSLATED
  * QUERY_STRING
  * REMOTE_ADDR
  * REMOTE_HOST
  * REMOTE_IDENT
  * REMOTE_USER
  * REQUEST_METHOD
  * SCRIPT_NAME
  * SERVER_NAME
  * SERVER_PORT
  * SERVER_PROTOCOL
  * SERVER_SOFTWARE

#content_length と #server_port
#@if (version == "1.8.1")
(1.8.1に添付のcgiには「CGI#server_portが常に0を返す」というバグがあります)
#@end
は整数を、その他のメソッドは文字列を返します。

HTTP_COOKIE と HTTP_COOKIE2 には
それぞれ raw_cookie と raw_cookie2 が対応します。

  value = cgi.raw_cookie      # ENV["HTTP_COOKIE"]
  value = cgi.raw_cookie2     # ENV["HTTP_COOKIE2"]

最後に、以下の HTTP 関連の環境変数は HTTP_ を除いた部分を downcase
したメソッド名が定義されています。

  例
  value = cgi.accept              # ENV["HTTP_ACCEPT"]
  value = cgi.accept_charset      # ENV["HTTP_ACCEPT_CHARSET"]

このような環境変数には以下のものがあります。

  * HTTP_ACCEPT
  * HTTP_ACCEPT_CHARSET
  * HTTP_ACCEPT_ENCODING
  * HTTP_ACCEPT_LANGUAGE
  * HTTP_CACHE_CONTROL
  * HTTP_FROM
  * HTTP_HOST
  * HTTP_NEGOTIATE
  * HTTP_PRAGMA
  * HTTP_REFERER
  * HTTP_USER_AGENT

CGI に関連する環境変数に関しては
[[url:http://www.w3.org/CGI/]] も参照してください。

==== 標準出力に HTTP ヘッダと HTML を出力する

  require "cgi"
#@#  cgi = CGI.new("html3")  # add HTML generation methods
  cgi = CGI.new("html3")  # HTML生成メソッドを追加
  cgi.out() do
    cgi.html() do
      cgi.head{ cgi.title{"TITLE"} } +
      cgi.body() do
        cgi.form() do
          cgi.textarea("get_text") +
          cgi.br +
          cgi.submit
        end +
        cgi.pre() do
          CGI.escapeHTML(
            "params: " + cgi.params.inspect + "\n" +
            "cookies: " + cgi.cookies.inspect + "\n" +
            ENV.collect() do |key, value|
              key + " --> " + value + "\n"
            end.join("")
          )
        end
      end
    end
  end

  # HTML生成メソッドを追加
  CGI.new("html3")    # html3.2
  CGI.new("html4")    # html4.0 (Strict)
  CGI.new("html4Tr")  # html4.0 Transitional
  CGI.new("html4Fr")  # html4.0 Frameset

==== ファイルのアップロード

[[ruby-list:25399]] を参照してください。

=== オフラインモード

cgi には、コマンドラインから CGI スクリプトを動かすための仕組み（オフラインモード）があります。
コマンドラインから以下のように実行すると、

  $ ruby -r cgi some_script.rb
  (offline mode: enter name=value pairs on standard input)

と聞いてくるので、

  q=hoge&v=foo

などと入力して下さい。クエリーに入力された値がセットされて、スクリプトが実行されます。

なお、Windows 環境の場合、ただ値を入力して Enter を押すだけでは実行されません。キーボードから Ctrl + Z を入力する必要があります。


=== HTMLエレメント出力用メソッド
新たな CGI オブジェクトを生成する際、引数として特定の文字列を与えることによって、そのオブジェクトに HTML 生成用のメソッドを追加することができます。これらのメソッドを利用することにより、「よりRuby的に」HTML 文書を出力することが可能になります。

  例：
#@#  cgi = CGI.new("html3")  # add HTML generation methods (for HTML3.2)
  cgi = CGI.new("html3")  # HTML3.2に準拠したHTML生成メソッドを追加
  cgi.h1
    # <H1></h1>
  cgi.h1{ "content" }
    # <H1>content</H1>
  cgi.h1({ "class" => "foo", "attr" => "bar" }){ "content" }
    # <H1 class="foo" attr="bar">content</H1>

#@#  # add HTML generation methods
  # HTML生成メソッドを追加
  CGI.new("html3")    # html3.2
  CGI.new("html4")    # html4.0 (Strict)
  CGI.new("html4Tr")  # html4.0 Transitional
  CGI.new("html4Fr")  # html4.0 Frameset

HTML 生成メソッドの引数としては、基本的に Hash オブジェクトが与えられる（あるいは何も与えられない）べきです。ただし以下に列挙されたメソッドでは、各メソッドの引数の形式に従って、 Hash オブジェクト以外のものを渡すこともできます。


= class CGI < Object
include CGI::QueryExtension

== Class Methods

--- escape(string) -> String

与えられた文字列を URL エンコードした文字列を新しく作成し返します。

@param string URL エンコードしたい文字列を指定します。

例:
        require "cgi"

        p CGI.escape('@##')   #=> "%40%23%23"

        url = "http://www.example.com/register?url=" + 
          CGI.escape('http://www.example.com/index.rss')
        p url
        #=> "http://www.example.com/register?url=http%3A%2F%2Fwww.example.com%2Findex.rss"

--- unescape(string) -> String

与えられた文字列を URL デコードした文字列を新しく作成し返します。

@param string URL エンコードされている文字列を指定します。

        require "cgi"

        p CGI.unescape('%40%23%23')   #=> "@##"

        p CGI.unescape("http%3A%2F%2Fwww.example.com%2Findex.rss")
        #=> "http://www.example.com/index.rss"

--- escapeHTML(string) -> String

与えられた文字列中の &"<> を実体参照に置換した文字列を新しく作成し返します。

@param string 文字列を指定します。

        require "cgi"

        p CGI.escapeHTML("3 > 1")   #=> "3 &gt; 1"

        print('<script type="text/javascript">alert("警告")</script>')

        p CGI.escapeHTML('<script type="text/javascript">alert("警告")</script>')
        #=> "&lt;script type=&quot;text/javascript&quot;&gt;alert(&quot;警告&quot;)&lt;/script&gt;"

--- unescapeHTML(string) -> String

与えられた文字列中の実体参照のうち、&amp; &gt; &lt; &quot;
と数値指定がされているもの (&#0ffff など) を元の文字列に置換します。

@param string 文字列を指定します。

        require "cgi"

        p CGI.unescapeHTML("3 &gt; 1")   #=> "3 > 1"

--- escapeElement(string, *elements) -> String

第二引数以降に指定したエレメントのタグだけを実体参照に置換します。

@param string 文字列を指定します。

@param elements HTML タグの名前を一つ以上指定します。文字列の配列で指定することも出来ます。

例：
        require "cgi"

        p CGI.escapeElement('<BR><A HREF="url"></A>', "A", "IMG")
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

        p CGI.escapeElement('<BR><A HREF="url"></A>', ["A", "IMG"])
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

--- unescapeElement(string, *element) -> String

特定の要素だけをHTMLエスケープから戻す。

@param string 文字列を指定します。

@param elements HTML タグの名前を一つ以上指定します。文字列の配列で指定することも出来ます。

例：
        require "cgi"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', "A", "IMG")
          # => "&lt;BR&gt;<A HREF="url"></A>"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', %w(A IMG))
          # => "&lt;BR&gt;<A HREF="url"></A>"

--- rfc1123_date(time) -> String

与えられた時刻を [[RFC:1123]] フォーマットに準拠した文字列に変換します。

@param time [[c:Time]] のインスタンスを指定します。

例：
        require "cgi"

        CGI.rfc1123_date(Time.now)
          # => Sat, 1 Jan 2000 00:00:00 GMT

--- parse(query) -> Hash

与えられたクエリ文字列をパースします。

@param query クエリ文字列を指定します。

例：
        require "cgi"

        params = CGI.parse("query_string")
          # {"name1" => ["value1", "value2", ...],
          #  "name2" => ["value1", "value2", ...], ... }
#@# module QueryExtension どうしよ

--- pretty(string, shift = "  ") -> String

HTML を人間に見やすく整形しした文字列を返します。

@param string HTML を指定します。

@param shift インデントに使用する文字列を指定します。デフォルトは半角空白二つです。

例：
        require "cgi"

        print CGI.pretty("<HTML><BODY></BODY></HTML>")
          # <HTML>
          #   <BODY>
          #   </BODY>
          # </HTML>

        print CGI.pretty("<HTML><BODY></BODY></HTML>", "\t")
          # <HTML>
          #         <BODY>
          #         </BODY>
          # </HTML>

== Instance Methods

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
                "my_header1" => "my_value"
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

#@# nodoc
#@# --- CR
#@# 
#@# --- LF
#@# 
#@# --- EOL
#@# 
#@# --- REVISION
#@# 
#@# --- NEEDS_BINMODE
#@# 
#@# --- PATH_SEPARATOR
#@# 
#@# --- HTTP_STATUS
#@# 
#@# --- RFC822_DAYS
#@# 
#@# --- RFC822_MONTHS
#@#

= module CGI::QueryExtension

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

--- content_length -> String

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

--- server_port -> String

ENV['SERVER_PORT'] を返します。

--- server_protocol -> String

ENV['SERVER_PROTOCOL'] を返します。

--- server_software -> String

ENV['SERVER_SOFTWARE'] を返します。

--- user_agent -> String

ENV['HTTP_USER_AGENT'] を返します。

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

#@# = class CGI::Cookie < DelegateClass(Array)
= class CGI::Cookie < Array

クッキーを表すクラスです。

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

= module CGI::TagMaker
#@#nodoc

== Instance Methods

--- nn_element_def(element)
#@todo

--- nOE_element_def(element, append = nil)
#@todo

--- nO_element_def(element)
#@todo

= module CGI::HtmlExtension

HTML を生成するためのメソッドを提供するモジュールです。

例:
   cgi.a("http://www.example.com") { "Example" }
     # => "<A HREF=\"http://www.example.com\">Example</A>"

== Instance Methods

--- a(href = "") -> String
--- a(href = ""){ ... } -> String

a 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

@param href 文字列を指定します。属性をハッシュで指定することもできます。
       
例:
  a("http://www.example.com") { "Example" }
    # => "<A HREF=\"http://www.example.com\">Example</A>"

  a("HREF" => "http://www.example.com", "TARGET" => "_top") { "Example" }
    # => "<A HREF=\"http://www.example.com\" TARGET=\"_top\">Example</A>"

--- base(href = "") -> String

base 要素を生成します。

@param href 文字列を指定します。属性をハッシュで指定することもできます。

例:
  base("http://www.example.com/cgi")
    # => "<BASE HREF=\"http://www.example.com/cgi\">"

--- blockquote(cite = nil) -> String
--- blockquote(cite = nil){ ... } -> String

blockquote 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

@param cite 引用元を指定します。属性をハッシュで指定することもできます。
       
例:
  blockquote("http://www.example.com/quotes/foo.html") { "Foo!" }
    #=> "<BLOCKQUOTE CITE=\"http://www.example.com/quotes/foo.html\">Foo!</BLOCKQUOTE>

--- caption(align = nil) -> String
--- caption(align = nil){ ... } -> String

caption 要素を生成します。

ブロックを与えると、ブロックを評価した結果が内容になります。

@param align 配置を文字列で指定します。(top, bottom, left right が指定可能です)
             属性をハッシュで指定することもできます。
       
例:
  caption("left") { "Capital Cities" }
    # => <CAPTION ALIGN=\"left\">Capital Cities</CAPTION>

--- checkbox(name = "", value = nil, checked = nil) -> String

タイプが checkbox である input 要素を生成します。

@param name name 属性の値を指定します。

@param value value 属性の値を指定します。

@param checked checked 属性の値を指定します。

例:
  checkbox("name", "value", true)
  # => "<INPUT CHECKED NAME=\"name\" TYPE=\"checkbox\" VALUE=\"value\">"

--- checkbox(attributes) -> String

タイプが checkbox である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  checkbox("name" => "name", "value" => "value", "checked" => true)
  # => "<INPUT checked name=\"name\" TYPE=\"checkbox\" value=\"value\">"

--- checkbox_group(name = "", *values) -> String

タイプが checkbox である input 要素のグループを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param name name 属性の値を指定します。

@param values value 属性のリストを指定します。
              それぞれの引数が、単純な文字列の場合、value 属性の値とラベルに同じものが使用されます。
              それぞれの引数が、二要素または三要素の配列の場合、最終要素が true であれば、
              checked 属性をセットします。先頭の要素は value 属性の値になります。

例:
  checkbox_group("name", "foo", "bar", "baz")
    # <INPUT TYPE="checkbox" NAME="name" VALUE="foo">foo
    # <INPUT TYPE="checkbox" NAME="name" VALUE="bar">bar
    # <INPUT TYPE="checkbox" NAME="name" VALUE="baz">baz

  checkbox_group("name", ["foo"], ["bar", true], "baz")
    # <INPUT TYPE="checkbox" NAME="name" VALUE="foo">foo
    # <INPUT TYPE="checkbox" CHECKED NAME="name" VALUE="bar">bar
    # <INPUT TYPE="checkbox" NAME="name" VALUE="baz">baz

  checkbox_group("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
    # <INPUT TYPE="checkbox" NAME="name" VALUE="1">Foo
    # <INPUT TYPE="checkbox" SELECTED NAME="name" VALUE="2">Bar
    # <INPUT TYPE="checkbox" NAME="name" VALUE="Baz">Baz

--- checkbox_group(attributes) -> String

タイプが checkbox である input 要素のグループを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param attributes 属性をハッシュで指定します。

例:
  checkbox_group({ "NAME" => "name",
                   "VALUES" => ["foo", "bar", "baz"] })

  checkbox_group({ "NAME" => "name",
                   "VALUES" => [["foo"], ["bar", true], "baz"] })

  checkbox_group({ "NAME" => "name",
                   "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })

--- file_field(name = "", size = 20, maxlength = nil) -> String

タイプが file である input 要素を生成します。

@param name name 属性の値を指定します。

@param size size 属性の値を指定します。

@param maxlength maxlength 属性の値を指定します。

例:
   file_field("name")
     # <INPUT TYPE="file" NAME="name" SIZE="20">

   file_field("name", 40)
     # <INPUT TYPE="file" NAME="name" SIZE="40">

   file_field("name", 40, 100)
     # <INPUT TYPE="file" NAME="name" SIZE="40" MAXLENGTH="100">

--- file_field(name = "", size = 20, maxlength = nil) -> String

タイプが file である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
   file_field({ "NAME" => "name", "SIZE" => 40 })
     # <INPUT TYPE="file" NAME="name" SIZE="40">


--- form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded") -> String
--- form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded"){ ... } -> String

form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param method method 属性の値として "get" か "post" を指定します。

@param action action 属性の値を指定します。デフォルトは現在の CGI スクリプト名です。

@param enctype enctype 属性の値を指定します。デフォルトは "application/x-www-form-urlencoded" です。

例:
  form{ "string" }
    # <FORM METHOD="post" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

  form("get"){ "string" }
    # <FORM METHOD="get" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

  form("get", "url"){ "string" }
    # <FORM METHOD="get" ACTION="url" ENCTYPE="application/x-www-form-urlencoded">string</FORM>


--- form(attributes) -> String
--- form(attributes){ ... } -> String

form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param attributes 属性をハッシュで指定します。

例:
  form({"METHOD" => "post", ENCTYPE => "enctype"}){ "string" }
    # <FORM METHOD="post" ENCTYPE="enctype">string</FORM>

@see [[m:CGI::HtmlExtension#multipart_form]]

--- hidden(name = "", value = nil) -> String
タイプが hidden である input 要素を生成します。

@param name name 属性の値を指定します。

@param value value 属性の値を指定します。

例:
  hidden("name")
    # <INPUT TYPE="hidden" NAME="name">

  hidden("name", "value")
    # <INPUT TYPE="hidden" NAME="name" VALUE="value">

--- hidden(attributes) -> String
タイプが hidden である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  hidden({ "NAME" => "name", "VALUE" => "reset", "ID" => "foo" })
    # <INPUT TYPE="hidden" NAME="name" VALUE="value" ID="foo">

--- html(attributes = {}) -> String
--- html(attributes = {}){ ... } -> String
トップレベルの html 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param attributes 属性をハッシュで指定します。
                  擬似属性の "PRETTY" に文字列を与えるとその文字列でインデントした HTML を生成します。
                  擬似属性の "DOCTYPE" には DOCTYPE 宣言として使用する文字列を与えることができます。

例:

  html{ "string" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><HTML>string</HTML>

  html({ "LANG" => "ja" }){ "string" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"><HTML LANG="ja">string</HTML>

  html({ "DOCTYPE" => false }){ "string" }
    # <HTML>string</HTML>

  html({ "DOCTYPE" => '<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">' }){ "string" }
    # <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN"><HTML>string</HTML>

  html({ "PRETTY" => "  " }){ "<BODY></BODY>" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    # <HTML>
    #   <BODY>
    #   </BODY>
    # </HTML>

  html({ "PRETTY" => "\t" }){ "<BODY></BODY>" }
    # <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
    # <HTML>
    #         <BODY>
    #         </BODY>
    # </HTML>

  html("PRETTY"){ "<BODY></BODY>" }
    # = html({ "PRETTY" => "  " }){ "<BODY></BODY>" }

  html(if $VERBOSE then "PRETTY" end){ "HTML string" }

--- image_button(src = "", name = nil, alt = nil) -> String
タイプが image の input 要素を生成します。

@param src src 属性の値を指定します。

@param name name 属性の値を指定します。

@param alt alt 属性の値を指定します。

例:
  image_button("url")
    # <INPUT TYPE="image" SRC="url">

  image_button("url", "name", "string")
    # <INPUT TYPE="image" SRC="url" NAME="name" ALT="string">

--- image_button(attributes) -> String
タイプが image の input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  image_button({ "SRC" => "url", "ALT" => "string" })
    # <INPUT TYPE="image" SRC="url" ALT="string">

--- img(src = "", alt = "", width = nil, height = nil) -> String
img 要素を生成します。

@param src src 属性の値を指定します。

@param alt alt 属性の値を指定します。

@param width width 属性の値を指定します。

@param height height 属性の値を指定します。

例:
  img("src", "alt", 100, 50)
    # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">

--- img(attributes) -> String
img 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  img({ "SRC" => "src", "ALT" => "alt", "WIDTH" => 100, "HEIGHT" => 50 })
    # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">

--- multipart_form(action = nil, enctype = "multipart/form-data") -> String
--- multipart_form(action = nil, enctype = "multipart/form-data"){ ... } -> String

enctype 属性に "multipart/form-data" をセットした form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param action action 属性の値を指定します。

@param enctype enctype 属性の値を指定します。

例:
  multipart_form{ "string" }
    # <FORM METHOD="post" ENCTYPE="multipart/form-data">string</FORM>

--- multipart_form(attributes) -> String
--- multipart_form(attributes){ ... } -> String

enctype 属性に "multipart/form-data" をセットした form 要素を生成します。
ブロックを与えると、ブロックを評価した結果が内容になります。

@param attributes 属性をハッシュで指定します。

例:
  multipart_form("url"){ "string" }
    # <FORM METHOD="post" ACTION="url" ENCTYPE="multipart/form-data">string</FORM>

--- password_field(name = "", value = nil, size = 40, maxlength = nil) -> String
タイプが password である input 要素を生成します。

@param name name 属性の値を指定します。

@param value 属性の値を指定します。

@param size size 属性の値を指定します。

@param maxlength maxlength 属性の値を指定します。

例:
  password_field("name")
    # <INPUT TYPE="password" NAME="name" SIZE="40">

  password_field("name", "value")
    # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="40">

  password_field("password", "value", 80, 200)
    # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">

--- password_field(name = "", value = nil, size = 40, maxlength = nil) -> String
タイプが password である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  password_field({ "NAME" => "name", "VALUE" => "value" })
    # <INPUT TYPE="password" NAME="name" VALUE="value">

--- popup_menu(name = "", *values) -> String
--- scrolling_list(name = "", *values) -> String

select 要素を生成します。

@param name name 属性の値を指定します。

@param values option 要素を生成するための情報を一つ以上指定します。
              それぞれ、文字列、一要素、二要素、三要素の配列を指定することができます。
              文字列か一要素の配列である場合は、value 属性の値と option 要素の内容になります。
              三要素の配列である場合は、順に value 属性の値、option 要素の内容、その option 要素が
              選択状態かどうかを表す真偽値となります。
       
        例：
        popup_menu("name", "foo", "bar", "baz")
          # <SELECT NAME="name">
          #   <OPTION VALUE="foo">foo</OPTION>
          #   <OPTION VALUE="bar">bar</OPTION>
          #   <OPTION VALUE="baz">baz</OPTION>
          # </SELECT>

        popup_menu("name", ["foo"], ["bar", true], "baz")
          # <SELECT NAME="name">
          #   <OPTION VALUE="foo">foo</OPTION>
          #   <OPTION VALUE="bar" SELECTED>bar</OPTION>
          #   <OPTION VALUE="baz">baz</OPTION>
          # </SELECT>

        popup_menu("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
          # <SELECT NAME="name">
          #   <OPTION VALUE="1">Foo</OPTION>
          #   <OPTION SELECTED VALUE="2">Bar</OPTION>
          #   <OPTION VALUE="Baz">Baz</OPTION>
          # </SELECT>

--- popup_menu(attributes) -> String
--- scrolling_list(attributes) -> String

select 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
        popup_menu({"NAME" => "name", "SIZE" => 2, "MULTIPLE" => true,
                    "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
          # <SELECT NAME="name" MULTIPLE SIZE="2">
          #   <OPTION VALUE="1">Foo</OPTION>
          #   <OPTION SELECTED VALUE="2">Bar</OPTION>
          #   <OPTION VALUE="Baz">Baz</OPTION>
          # </SELECT>

--- radio_button(name = "", value = nil, checked = nil) -> String

タイプが radio である input 要素を生成します。

@param name name 属性の値を指定します。

@param value value 属性の値を指定します。

@param checked 真ならば checked 属性を設定します。

例:
  radio_button("name", "value")
    # <INPUT TYPE="radio" NAME="name" VALUE="value">
 
  radio_button("name", "value", true)
    # <INPUT TYPE="radio" NAME="name" VALUE="value" CHECKED>

--- radio_button(attributes) -> String

タイプが radio である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  radio_button({ "NAME" => "name", "VALUE" => "value", "ID" => "foo" })
    # <INPUT TYPE="radio" NAME="name" VALUE="value" ID="foo">

--- radio_group(name = "", *values) -> String
タイプが radio である input 要素のリストを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param name name 属性の値を指定します。

@param values value 属性のリストを指定します。
              それぞれの引数が、単純な文字列の場合、value 属性の値とラベルに同じものが使用されます。
              それぞれの引数が、二要素または三要素の配列の場合、最終要素が true であれば、
              checked 属性をセットします。先頭の要素は value 属性の値になります。

例:
  radio_group("name", "foo", "bar", "baz")
    # <INPUT TYPE="radio" NAME="name" VALUE="foo">foo
    # <INPUT TYPE="radio" NAME="name" VALUE="bar">bar
    # <INPUT TYPE="radio" NAME="name" VALUE="baz">baz
  
  radio_group("name", ["foo&quot;], ["bar", true], "baz")
    # <INPUT TYPE="radio" NAME="name" VALUE="foo">foo
    # <INPUT TYPE=&quot;radio" CHECKED NAME="name" VALUE="bar">bar
    # <INPUT TYPE="radio" NAME="name" VALUE="baz">baz
  
  radio_group("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
    # <INPUT TYPE="radio" NAME="name" VALUE="1">Foo
    # <INPUT TYPE="radio" CHECKED NAME="name" VALUE="2">Bar
    # <INPUT TYPE="radio" NAME="name" VALUE="Baz">Baz
  
--- radio_group(name = "", *values) -> String
タイプが radio である input 要素のリストを生成します。

生成される input 要素の name 属性はすべて同じになり、
それぞれの input 要素の後ろにはラベルが続きます。

@param attributes 属性をハッシュで指定します。

例:
  radio_group({ "NAME" => "name",
                "VALUES" => ["foo", "bar", "baz"] })
  
  radio_group({ "NAME" => "name",
                "VALUES" => [["foo"], ["bar", true], "baz"] })
  
  radio_group({ "NAME" => "name",
                "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })

--- reset(value = nil, name = nil) -> String
タイプが reset である input 要素を生成します。

@param value value 属性の値を指定します。

@param name name 属性の値を指定します。

例:
  reset
    # <INPUT TYPE="reset">
  
  reset("reset")
    # <INPUT TYPE="reset" VALUE="reset">
  
--- reset(attributes) -> String
タイプが reset である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

  reset({ "VALUE" => "reset", "ID" => "foo" })
    # <INPUT TYPE="reset" VALUE="reset" ID="foo">

--- submit(value = nil, name = nil) -> String
タイプが submit である input 要素を生成します。

@param value value 属性の値を指定します。

@param name name 属性の値を指定します。

例:
  submit
    # <INPUT TYPE="submit">
  
  submit("ok")
    # <INPUT TYPE="submit" VALUE="ok">
  
  submit("ok", "button1")
    # <INPUT TYPE="submit" VALUE="ok" NAME="button1">
  
--- submit(attributes) -> String
タイプが submit である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
  submit({ "VALUE" => "ok", "NAME" => "button1", "ID" => "foo" })
    # <INPUT TYPE="submit" VALUE="ok" NAME="button1" ID="foo">

--- text_field(name = "", value = nil, size = 40, maxlength = nil) -> String
タイプが text である input 要素を生成します。

@param name name 属性の値を指定します。

@param value 属性の値を指定します。

@param size size 属性の値を指定します。

@param maxlength maxlength 属性の値を指定します。

例:
  text_field("name")
    # <INPUT TYPE="text" NAME="name" SIZE="40">
  
  text_field("name", "value")
    # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="40">
  
  text_field("name", "value", 80)
    # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80">
  
  text_field("name", "value", 80, 200)
    # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">
  
--- text_field(attributes) -> String
タイプが text である input 要素を生成します。

@param attributes 属性をハッシュで指定します。

  text_field({ "NAME" => "name", "VALUE" => "value" })
    # <INPUT TYPE="text" NAME="name" VALUE="value">

--- textarea(name = "", cols = 70, rows = 10) -> String
textarea 要素を生成します。

@param name name 属性の値を指定します。

@param cols cols 属性の値を指定します。

@param rows rows 属性の値を指定します。

例:
   textarea("name")
     # = textarea({ "NAME" => "name", "COLS" => 70, "ROWS" => 10 })

--- textarea(attributes) -> String
textarea 要素を生成します。

@param attributes 属性をハッシュで指定します。

例:
   textarea("name", 40, 5)
     # = textarea({ "NAME" => "name", "COLS" => 40, "ROWS" => 5 })

= module CGI::Html3
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4Fr
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4Tr
#@# nodoc

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo
