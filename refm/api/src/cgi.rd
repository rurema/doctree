category Network

#@since 1.9.1
require cgi/core
require cgi/cookie
require cgi/util
require cgi/html
#@end

CGI プログラムの支援ライブラリです。

CGI プロトコルの詳細については以下の文書を参照してください。

  * [[url:http://Web.Golux.Com/coar/cgi/draft-coar-cgi-v11-03.txt]]
  * [[RFC:3875]]: The Common Gateway Interface (CGI) Version 1.1
  * [[url:http://www.w3.org/CGI/]]

=== 使用例

==== フォームフィールドの値を得る

  require "cgi"
  cgi = CGI.new
  values = cgi['field_name']   # <== 'field_name' の配列
  # 'field_name' が指定されていなかったら、 ""を返す。
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
  value = cgi.params['field_name'][0]   # TempFile オブジェクト（10240バイト未満の場合は StringIOオブジェクト）
  value.read                            # 本文（送られてきたファイルの中身）
  value.local_path                      # ローカルファイルのパス
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

例:

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

HTML 生成メソッドの引数としては、基本的に Hash オブジェクトが与えられる（あるいは何も与えられない）べきです。
ただし以下に列挙されたメソッドでは、各メソッドの引数の形式に従って、 Hash オブジェクト以外のものを渡すこともできます。

#@until 1.9.1
#@include(cgi/core.rd)
#@include(cgi/cookie.rd)
#@include(cgi/html.rd)
#@end
