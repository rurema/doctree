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
#@if (version == "1.8.0")
((- 1.8.1に添付のcgiには「CGI#server_portが常に0を返す」というバグがあります。 -))
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

[[unknown:執筆者募集]]

[[ruby-list:25399]] を参照してください。

=== オフラインモード

[[unknown:執筆者募集]]

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

--- escape(string) -> string
#@todo

string を URL エンコードした文字列を新しく作成し返します。

例:
        require "cgi"

        p CGI.escape('@##')   #=> "%40%23%23"

        url = "http://www.example.com/register?url=" + 
          CGI.escape('http://www.example.com/index.rss')
        p url
        #=> "http://www.example.com/register?url=http%3A%2F%2Fwww.example.com%2Findex.rss"

--- unescape(string) -> string
#@todo

string を URL デコードした文字列を新しく作成し返します。

        require "cgi"

        p CGI.unescape('%40%23%23')   #=> "@##"

        p CGI.unescape("http%3A%2F%2Fwww.example.com%2Findex.rss")
        #=> "http://www.example.com/index.rss"

--- escapeHTML(string) -> string
#@todo

string 中の &"<> を実体参照にエンコードした文字列を新しく作成し返します。

        require "cgi"

        p CGI.escapeHTML("3 > 1")   #=> "3 &gt; 1"

        print('<script type="text/javascript">alert("警告")</script>')

        p CGI.escapeHTML('<script type="text/javascript">alert("警告")</script>')
        #=> "&lt;script type=&quot;text/javascript&quot;&gt;alert(&quot;警告&quot;)&lt;/script&gt;"

--- unescapeHTML(string) -> string
#@todo

string 中の実体参照のうち、&amp; &gt; &lt; &quot;
と数値指定がされているもの (&#0ffff など) だけを外します。

        require "cgi"

        p CGI.unescapeHTML("3 &gt; 1")   #=> "3 > 1"

--- escapeElement(string, *elements) -> string
#@todo

elements に指定したエレメントのタグだけを実体参照に置換します。

例：
        require "cgi"

        p CGI.escapeElement('<BR><A HREF="url"></A>', "A", "IMG")
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

        p CGI.escapeElement('<BR><A HREF="url"></A>', ["A", "IMG"])
             # => "<BR>&lt;A HREF="url"&gt;&lt;/A&gt"

--- unescapeElement(string, *element) -> string
#@todo
特定の要素だけをHTMLエスケープから戻す。

例：
        require "cgi"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', "A", "IMG")
          # => "&lt;BR&gt;<A HREF="url"></A>"

        print CGI.unescapeElement('&lt;BR&gt;&lt;A HREF="url"&gt;&lt;/A&gt;', %w(A IMG))
          # => "&lt;BR&gt;<A HREF="url"></A>"

--- rfc1123_date(time) -> string
#@todo

時刻 time を [[RFC:1123]] フォーマットに準拠した文字列に変換します。

例：
        require "cgi"

        CGI.rfc1123_date(Time.now)
          # => Sat, 1 Jan 2000 00:00:00 GMT

--- parse(query) -> object
#@todo

QUERY_STRING をパースします。

例：
        require "cgi"

        params = CGI.parse("query_string")
          # {"name1" => ["value1", "value2", ...],
          #  "name2" => ["value1", "value2", ...], ... }
#@# module QueryExtension どうしよ

--- pretty(string, shift = "  ") -> string
#@todo

HTML を人間に見やすく整形します。

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

--- header(headers = "text/html")
#@todo

HTTP ヘッダを headers に従って生成します。（ [[m:CGI#out]] と違い、標準出力には出力しません）
[[m:CGI#out]] を使わずに自力で HTML を出力したい場合などに使います。
このメソッドは文字列エンコーディングを変換しません。
[[ruby-list:35911]]

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

例

        cgi = CGI.new('html3')
        print cgi.header({"charset" => "shift_jis"})
        print "<html><head><title>TITLE</title></head>\r\n"
        print "<body>BODY</body></html>\r\n"

--- out(options = "text/html") { .... }
#@todo

HTTP ヘッダと、ブロックで与えられた文字列を標準出力に出力します。

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

HEADリクエスト (REQUEST_METHOD == "HEAD") の場合は HTTP ヘッダのみを出力します。

charset が "iso-2022-jp"・"euc-jp"・"shift_jis" のいずれかで
ある場合は文字列エンコーディングを自動変換し、language を "ja"にします。
#@#((<ruby-list:35911>))

--- print(*strings)
#@todo

引数の文字列を標準出力に出力します。

       例：
       cgi = CGI.new
       cgi.print "This line is a part of content body.\r\n"

== Constants

--- CR
#@todo

--- LF
#@todo

--- EOL
#@todo

--- REVISION
#@todo

--- NEEDS_BINMODE
#@todo

--- PATH_SEPARATOR
#@todo

--- HTTP_STATUS
#@todo

--- RFC822_DAYS
#@todo

--- RFC822_MONTHS
#@todo

= module CGI::QueryExtension

== Instance Methods

--- [](key)
#@todo

文字列 key に対応するパラメータを配列で返します。
key に対応するパラメータが見つからなかった場合は、nil を返します。（[[m:CGI#params]]と等価です）

フォームから入力された値や、URL に埋め込まれた QUERY_STRING のパース結果の取得などに使用します。

#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): 挙動が 1.6 以前の cgi と大きく変化しています ((- この挙動は流動的で、1.8.0, 1.8.1, 1.8.2 の挙動はすべて異なります（1.9.0の挙動は1.8.2と同様です）。 -)) 。メソッドの返り値は配列でなく、文字列 ((- 1.8.1 までは、正確に言うと String ではありません。 -)) になり、それに伴って cgi[key][0] のような書き方は廃止されました。また key に対応するパラメータが存在しなかった場合、nil ではなく "" を返すようになっています。 ruby 1.6 と同じ挙動を望む場合は、[[m:CGI#params]]を利用してください。

この結果、インターフェースがどう変わったのかについては、以下の例を参考にしてください。

      # with ruby 1.6 ---------------------------
      cgi = CGI.new
      cgi['developer']     # => ["Matz"] (Array)
      cgi['developer'][0]  # => "Matz" (String)
      cgi['']              # => nil

      # with ruby 1.8 ---------------------------
      cgi = CGI.new
      cgi['developer']     # => "Matz"
      cgi['developer'][0]  # => obsolete（警告が出ます）
      cgi['']              # => ""

cgi['developer'].is_a?(String) # => 1.8.1まではfalse、1.8.2以降はtrue
#@end

    [[unknown:執筆者募集]]

--- accept
#@todo

ENV['HTTP_ACCEPT']

--- accept_charset
#@todo

ENV['HTTP_ACCEPT_CHARSET']

--- accept_encoding
#@todo

ENV['HTTP_ACCEPT_ENCODING']

--- accept_language
#@todo

ENV['HTTP_ACCEPT_LANGUAGE']

--- auth_type
#@todo

ENV['AUTH_TYPE']

--- cache_control
#@todo

ENV['HTTP_CACHE_CONTROL']

--- content_length
#@todo

ENV['CONTENT_LENGTH']

--- content_type
#@todo

ENV['CONTENT_TYPE']

--- cookies
--- cookies=(value)
#@todo

--- from
#@todo

ENV['HTTP_FROM']

--- gateway_interface
#@todo

ENV['GATEWAY_INTERFACE']

--- has_key?(*args)
--- key?(*args)
--- include?(*args)
#@todo

--- host
#@todo

ENV['HTTP_HOST']

--- keys(*args)
#@todo

--- multipart?
#@todo

マルチパートフォームの場合にtrueが返ります。

       例：
       cgi = CGI.new
       if cgi.multipart?
         field1=cgi['field1'].read
       else
         field1=cgi['field1']
       end

--- negotiate
#@todo

ENV['HTTP_NEGOTIATE']

--- params
#@todo

パラメータを格納したハッシュを返します。

フォームから入力された値や、URLに埋め込まれた QUERY_STRING のパース結果の取得などに使用します。

      cgi = CGI.new
      cgi.params['developer']     # => ["Matz"] (Array)
      cgi.params['developer'][0]  # => "Matz"
      cgi.params['']              # => nil

--- params=(hash)
#@todo

--- path_info
#@todo

ENV['PATH_INFO']

--- path_translated
#@todo

ENV['PATH_TRANSLATED']

--- pragma
#@todo

ENV['HTTP_PRAGMA']

--- query_string
#@todo

ENV['QUERY_STRING']

--- raw_cookie
#@todo

ENV["HTTP_COOKIE"]

--- raw_cookie2
#@todo

ENV["HTTP_COOKIE2"]

--- referer
#@todo

ENV['HTTP_REFERER']

--- remote_addr
#@todo

ENV['REMOTE_ADDR']

--- remote_host
#@todo

ENV['REMOTE_HOST']

--- remote_ident
#@todo

ENV['REMOTE_IDENT']

--- remote_user
#@todo

ENV['REMOTE_USER']

--- request_method
#@todo

ENV['REQUEST_METHOD']

--- script_name
#@todo

ENV['SCRIPT_NAME']

--- server_name
#@todo

ENV['SERVER_NAME']

--- server_port
#@todo

ENV['SERVER_PORT']

--- server_protocol
#@todo

ENV['SERVER_PROTOCOL']

--- server_software
#@todo

ENV['SERVER_SOFTWARE']

--- user_agent
#@todo

ENV['HTTP_USER_AGENT']

= module CGI::QueryExtension::Value

== Instance Methods

--- [](idx, *args)
#@todo

--- first
--- last
#@todo

--- set_params(params)
#@todo

--- to_a
--- to_ary
#@todo

#@# = class CGI::Cookie < DelegateClass(Array)
= class CGI::Cookie < Array

== Class Methods

--- new(name = "", *value)
#@todo

クッキーオブジェクトを作成します。

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

--- parse(raw_cookie)
#@todo

クッキー文字列をパースします。

        例：
        cookies = CGI::Cookie.parse("raw_cookie_string")
          # { "name1" => cookie1, "name2" => cookie2, ... }

== Instance Methods

--- name
--- name=(value)
--- value
--- value=(value)
--- path
--- path=(value)
--- domain
--- domain=(value)
--- expires
--- expires=(value)
--- secure
--- secure=(val)
#@todo

Cookie オブジェクトのアトリビュートです。

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

--- to_s
#@todo

= module CGI::TagMaker

== Instance Methods

--- nn_element_def(element)
#@todo

--- nOE_element_def(element, append = nil)
#@todo

--- nO_element_def(element)
#@todo

= module CGI::HtmlExtension

== Instance Methods

--- a(href = "")
#@todo
       
        例：
        a("url")
          # = a({ "HREF" => "url" })

--- base(href = "")
#@todo
       
        例：
        base("url")
          # = base({ "HREF" => "url" })

--- blockquote(cite = nil)
#@todo
       
        例：
        blockquote("url"){ "string" }
          # = blockquote({ "CITE" => "url" }){ "string" }

--- caption(align = nil)
#@todo
       
        例：
        caption("align"){ "string" }
          # = caption({ "ALIGN" => "align" }){ "string" }

--- checkbox(name = "", value = nil, checked = nil)
#@todo
       
        例：
        checkbox("name")
          # = checkbox({ "NAME" => "name" })

        checkbox("name", "value")
          # = checkbox({ "NAME" => "name", "VALUE" => "value" })

        checkbox("name", "value", true)
          # = checkbox({ "NAME" => "name", "VALUE" => "value", "CHECKED" => true })

--- checkbox_group(name = "", *values)
#@todo
       
        例：
        checkbox_group("name", "foo", "bar", "baz")
          # <INPUT TYPE="checkbox" NAME="name" VALUE="foo">foo
          # <INPUT TYPE="checkbox" NAME="name" VALUE="bar">bar
          # <INPUT TYPE="checkbox" NAME="name" VALUE="baz">baz

        checkbox_group("name", ["foo"], ["bar", true], "baz")
          # <INPUT TYPE="checkbox" NAME="name" VALUE="foo">foo
          # <INPUT TYPE="checkbox" SELECTED NAME="name" VALUE="bar">bar
          # <INPUT TYPE="checkbox" NAME="name" VALUE="baz">baz

        checkbox_group("name", ["1", "Foo"], ["2", "Bar", true], "Baz")
          # <INPUT TYPE="checkbox" NAME="name" VALUE="1">Foo
          # <INPUT TYPE="checkbox" SELECTED NAME="name" VALUE="2">Bar
          # <INPUT TYPE="checkbox" NAME="name" VALUE="Baz">Baz

        checkbox_group({ "NAME" => "name",
                         "VALUES" => ["foo", "bar", "baz"] })

        checkbox_group({ "NAME" => "name",
                         "VALUES" => [["foo"], ["bar", true], "baz"] })

        checkbox_group({ "NAME" => "name",
                         "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })

--- file_field(name = "", size = 20, maxlength = nil)
#@todo
       
        例：
        file_field("name")
          # <INPUT TYPE="file" NAME="name" SIZE="20">

        file_field("name", 40)
          # <INPUT TYPE="file" NAME="name" SIZE="40">

        file_field("name", 40, 100)
          # <INPUT TYPE="file" NAME="name" SIZE="40" MAXLENGTH="100">

        file_field({ "NAME" => "name", "SIZE" => 40 })
          # <INPUT TYPE="file" NAME="name" SIZE="40">

--- form(method = "post", action = nil, enctype = "application/x-www-form-urlencoded")
#@todo
       
        例：
        form{ "string" }
          # <FORM METHOD="post" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

        form("get"){ "string" }
          # <FORM METHOD="get" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

        form("get", "url"){ "string" }
          # <FORM METHOD="get" ACTION="url" ENCTYPE="application/x-www-form-urlencoded">string</FORM>

        form({"METHOD" => "post", ENCTYPE => "enctype"}){ "string" }
          # <FORM METHOD="post" ENCTYPE="enctype">string</FORM>

--- hidden(name = "", value = nil)
#@todo
       
        例：
        hidden("name")
          # <INPUT TYPE="hidden" NAME="name">

        hidden("name", "value")
          # <INPUT TYPE="hidden" NAME="name" VALUE="value">

        hidden({ "NAME" => "name", "VALUE" => "reset", "ID" => "foo" })
          # <INPUT TYPE="hidden" NAME="name" VALUE="value" ID="foo">

--- html(attributes = {})
#@todo
       
        例：

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

--- image_button(src = "", name = nil, alt = nil)
#@todo
       
        例：
        image_button("url")
          # <INPUT TYPE="image" SRC="url">

        image_button("url", "name", "string")
          # <INPUT TYPE="image" SRC="url" NAME="name" ALT="string">

        image_button({ "SRC" => "url", "ATL" => "strng" })
          # <INPUT TYPE="image" SRC="url" ALT="string">

--- img(src = "", alt = "", width = nil, height = nil)
#@todo
       
        例：
        img("src", "alt", 100, 50)
          # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">

        img({ "SRC" => "src", "ALT" => "alt", "WIDTH" => 100, "HEIGHT" => 50 })
          # <IMG SRC="src" ALT="alt" WIDTH="100" HEIGHT="50">

--- multipart_form(action = nil, enctype = "multipart/form-data")
#@todo
       
        例：
        multipart_form{ "string" }
          # <FORM METHOD="post" ENCTYPE="multipart/form-data">string</FORM>

        multipart_form("url"){ "string" }
          # <FORM METHOD="post" ACTION="url" ENCTYPE="multipart/form-data">string</FORM>

--- password_field(name = "", value = nil, size = 40, maxlength = nil)
#@todo
       
        例：
        password_field("name")
          # <INPUT TYPE="password" NAME="name" SIZE="40">

        password_field("name", "value")
          # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="40">

        password_field("password", "value", 80, 200)
          # <INPUT TYPE="password" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">

        password_field({ "NAME" => "name", "VALUE" => "value" })
          # <INPUT TYPE="password" NAME="name" VALUE="value">

--- popup_menu(name = "", *values)
#@todo
       
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

        popup_menu({"NAME" => "name", "SIZE" => 2, "MULTIPLE" => true,
                    "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
          # <SELECT NAME="name" MULTIPLE SIZE="2">
          #   <OPTION VALUE="1">Foo</OPTION>
          #   <OPTION SELECTED VALUE="2">Bar</OPTION>
          #   <OPTION VALUE="Baz">Baz</OPTION>
          # </SELECT>

--- radio_button(name = "", value = nil, checked = nil)
#@todo
       
        例：
        radio_button("name", "value")
          # <INPUT TYPE="radio" NAME="name" VALUE="value">

        radio_button("name", "value", true)
          # <INPUT TYPE="radio" NAME="name" VALUE="value" CHECKED>

        radio_button({ "NAME" => "name", "VALUE" => "value", "ID" => "foo" })
          # <INPUT TYPE="radio" NAME="name" VALUE="value" ID="foo">

--- radio_group(name = "", *values)
#@todo
       
        例：
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

        radio_group({ "NAME" => "name",
                      "VALUES" => ["foo", "bar", "baz"] })

        radio_group({ "NAME" => "name",
                      "VALUES" => [["foo"], ["bar", true], "baz"] })

        radio_group({ "NAME" => "name",
                      "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })

--- reset(value = nil, name = nil)
#@todo
       
        例：
        reset
          # <INPUT TYPE="reset">

        reset("reset")
          # <INPUT TYPE="reset" VALUE="reset">

        reset({ "VALUE" => "reset", "ID" => "foo" })
          # <INPUT TYPE="reset" VALUE="reset" ID="foo">

--- scrolling_list(name = "", *values)
#@todo
       
        例：

        scrolling_list({"NAME" => "name", "SIZE" => 2, "MULTIPLE" => true,
                        "VALUES" => [["1", "Foo"], ["2", "Bar", true], "Baz"] })
          # <SELECT NAME="name" MULTIPLE SIZE="2">
          #   <OPTION VALUE="1">Foo</OPTION>
          #   <OPTION SELECTED VALUE="2">Bar</OPTION>
          #   <OPTION VALUE="Baz">Baz</OPTION>
          # </SELECT>

--- submit(value = nil, name = nil)
#@todo
       
        例：
        submit
          # <INPUT TYPE="submit">

        submit("ok")
          # <INPUT TYPE="submit" VALUE="ok">

        submit("ok", "button1")
          # <INPUT TYPE="submit" VALUE="ok" NAME="button1">

        submit({ "VALUE" => "ok", "NAME" => "button1", "ID" => "foo" })
          # <INPUT TYPE="submit" VALUE="ok" NAME="button1" ID="foo">

--- text_field(name = "", value = nil, size = 40, maxlength = nil)
#@todo
       
        例：
        text_field("name")
          # <INPUT TYPE="text" NAME="name" SIZE="40">

        text_field("name", "value")
          # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="40">

        text_field("name", "value", 80)
          # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80">

        text_field("name", "value", 80, 200)
          # <INPUT TYPE="text" NAME="name" VALUE="value" SIZE="80" MAXLENGTH="200">

        text_field({ "NAME" => "name", "VALUE" => "value" })
          # <INPUT TYPE="text" NAME="name" VALUE="value">

--- textarea(name = "", cols = 70, rows = 10)
#@todo
       
        例：
        textarea("name")
          # = textarea({ "NAME" => "name", "COLS" => 70, "ROWS" => 10 })

        textarea("name", 40, 5)
          # = textarea({ "NAME" => "name", "COLS" => 40, "ROWS" => 5 })

= module CGI::Html3

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4Fr

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo

= module CGI::Html4Tr

== Instance Methods

--- doctype
#@todo

--- element_init
#@todo
