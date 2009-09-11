汎用データ転送プロトコル HTTP を扱うライブラリです。
実装は [[RFC:2616]] に基きます。

=== 使用例

==== ウェブサーバからドキュメントを得る (GET)

例1: GET して 表示するだけ
  require 'net/http'
  Net::HTTP.get_print 'www.example.com', '/index.html'

例2: [[c:URI]] を使う
  require 'net/http'
  require 'uri'
  Net::HTTP.get_print URI.parse('http://www.example.com/index.html')

例3: より汎用的な例

  require 'net/http'
  require 'uri'
  
  url = URI.parse('http://www.example.com/index.html')
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.get('/index.html')
  }
  puts res.body

例4: 上の例よりさらに汎用的な例
  require 'net/http'
  
  url = URI.parse('http://www.example.com/index.html')
  req = Net::HTTP::Get.new(url.path)
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  puts res.body

==== フォームの情報を送信する (POST)
  require 'net/http'
  require 'uri'

  #例1: POSTするだけ
  res = Net::HTTP.post_form(URI.parse('http://www.example.com/search'),
                            {'q'=>'ruby', 'max'=>'50'})
  puts res.body
  
  #例2: 認証付きで POST する
  res = Net::HTTP.post_form(URI.parse('http://jack:pass@www.example.com/todo.cgi'),
                            {'from'=>'2005-01-01', 'to'=>'2005-03-31'})
  puts res.body

  #例3: より細かく制御する
  url = URI.parse('http://www.example.com/todo.cgi')
  req = Net::HTTP::Post.new(url.path)
  req.basic_auth 'jack', 'pass'
  req.set_form_data({'from'=>'2005-01-01', 'to'=>'2005-03-31'}, ';')
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
  case res
  when Net::HTTPSuccess, Net::HTTPRedirection
    # OK
  else
    res.error!
  end

==== プロクシ経由のアクセス

[[m:Net::HTTP.Proxy]] はプロクシ経由での接続を行なうクラスを
生成して返します。このクラスは [[c:Net::HTTP]] と同じ
メソッドを持ち、同じように動作をします。ただし
接続する際には常にプロクシ経由となります。
  require 'net/http'
  
  proxy_addr = 'your.proxy.host'
  proxy_port = 8080
          :
  Net::HTTP::Proxy(proxy_addr, proxy_port).start('www.example.com') {|http|
    # always connect to your.proxy.addr:8080
          :
  }

また [[m:Net::HTTP.Proxy]] は第一引数が nil だと 
Net::HTTP 自身を返すので
上のコードのように書いておけばプロクシなしの場合にも対応できます。

[[m:Net::HTTP.Proxy]] にはユーザ名とパスワードを取る
オプション引数があり、以下のようにして
プロクシの認証をすることができます。
  proxy_host = 'your.proxy.host'
  proxy_port = 8080
  uri = URI.parse(ENV['http_proxy'])
  proxy_user, proxy_pass = uri.userinfo.split(/:/) if uri.userinfo
  Net::HTTP::Proxy(proxy_host, proxy_port,
                   proxy_user, proxy_pass).start('www.example.com') {|http|
    # always connect to your.proxy.addr:8080 using specified username and password
          :
  }
このライブラリは環境変数 HTTP_PROXY を一切考慮しないこと
に注意してください。プロクシを使いたい場合は上の例のように
明示的に取り扱わなければなりません。

==== リダイレクトに対応する
以下の例の fetch はリダイレクトに対応しています。
limit 回数以上リダイレクトしたらエラーにします。

  require 'net/http'
  require 'uri'
  
  def fetch(uri_str, limit = 10)
    # You should choose better exception. 
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response['location'], limit - 1)
    else
      response.error!
    end
  end

  print fetch('http://www.ruby-lang.org')

より詳しくは [[c:HTTPResponse]]、 [[c:Net::HTTPSuccess]]、
[[c:Net::HTTPRedirection]] を参照してください。

==== Basic 認証

  require 'net/http'
  
  Net::HTTP.start('www.example.com') {|http|
    req = Net::HTTP::Get.new('/secret-page.html')
    req.basic_auth 'account', 'password'
    response = http.request(req)
    print response.body
  }


#@# === 例外

#@# get、head、post メソッドで発生する HTTP プロトコル関連の例外として、
#@# 以下に挙げるものがあります。
#@# ここに挙げる例外クラスの親クラスはすべて Net::ProtocolError クラスで、
#@# response メソッドによってエラーの原因となったレスポンスオブジェクトを
#@# 得ることができます。

#@# : ProtoRetriableError
#@#     HTTP ステータスコード 3xx を受け取った時に発生します。
#@#     リソースが移動したなどの理由により、リクエストを完了させるには更な
#@#     るアクションが必要になります。
#@# : ProtoFatalError
#@#     HTTP ステータスコード 4xx を受け取った時に発生します。
#@#     クライアントのリクエストに誤りがあるか、サーバにリクエストを拒否さ
#@#     れた(認証が必要、リソースが存在しないなどで)ことを示します。
#@# : ProtoServerError
#@#     HTTP ステータスコード 5xx を受け取った時に発生します。
#@#     サーバがリクエストを処理中にエラーが発生したことを示します。
#@# : ProtoUnknownError
#@#     プロトコルのバージョンが上がった、あるいはライブラリのバグなどで、
#@#     ライブラリが対応していない状況が発生しました。

=== フォームの値の区切り文字について

POSTで application/x-www-form-urlencoded として複数のフォームの値を送る場合、
現在広く行なわれているのは、 name0=value0&name1=value1 のようにアンパサンド
(`&') で区切るやりかたです。
この方法は、[[RFC:1866]] Hypertext Markup Language - 2.0 で初めて公式に登場し、
HTML 4.01 Specification の 17.13.4 Form content types
でもそのように書かれています。

ところが、同じ HTML 4.01 Specification の
B.2.2 Ampersands in URI attribute values では、
この `&' がSGMLの文字実体参照で用いられることが指摘されており、
CGIやサーバの実装者に対し `&' の代わりに
セミコロン `;' をサポートすることを奨めています。

しかし、実際には `;' を解釈しないCGIやサーバもまだまだ見受けられるため
このリファレンスマニュアルでは例として `&' を用いました。

なお Ruby 標準の [[lib:cgi]] ライブラリでは '&' と ';' の両方サポートしていますので、
[[lib:cgi]] ライブラリを使って CGI スクリプトを書く場合はこれらの違いを気にする
必要はありません。


=== 新しい仕様への変更と移行措置について

net/http 1.1 (Ruby 1.6に含まれています)の挙動を使いたい場合には
[[m:Net::HTTP.version_1_1]] を呼んでください。
その後 [[m:Net::HTTP.version_1_2]] を呼ぶと挙動が 1.2 に
戻ります。

  # example
  Net::HTTP.start {|http1| ...(http1 has 1.2 features)... }
  
  Net::HTTP.version_1_1
  Net::HTTP.start {|http2| ...(http2 has 1.1 features)... }
  
  Net::HTTP.version_1_2
  Net::HTTP.start {|http3| ...(http3 has 1.2 features)... }

ただし、この機能はスレッドセーフではありません。
つまり、複数スレッドでそれぞれに version_1_1 や version_1_2 を呼んだ場合、
次に生成する Net::HTTP オブジェクトがどちらのバージョンになるかは保証できません。
アプリケーション全体でどちらかのバージョンに固定する必要があります。
通常この機能は使わないはずです。1.2固定で利用してください。
このドキュメントでは 1.1 互換動作については解説しません。

= class Net::HTTP < Object
alias HTTPSession

HTTP のクライアントのためのクラスです。

== Class Methods

--- new(address, port = 80, proxy_addr = nil, proxy_port = nil, proxy_user=nil, proxy_pass=nil) -> Net::HTTP

新しい [[c:Net::HTTP]] オブジェクトを生成します。

proxy_addr を与えるとプロクシを介して接続するオブジェクトを
生成します。このときに proxy_userを指定するとプロクシの認証が
行われます

このメソッドは TCP コネクションを張りません。

@param address 接続するホスト名を文字列で指定します。
@param port 接続するポート番号を指定します。
@param proxy_addr プロクシのホスト名を指定します。
@param proxy_port プロクシのホスト名を指定します。
@param proxy_user プロクシの認証のユーザ名を指定します。省略した場合には認証はなされません。
@param proxy_pass プロクシの認証のパスワードを指定します。


--- start(address, port = 80, proxy_addr = nil, proxy_port = nil, proxy_user=nil, proxy_pass=nil) -> Net::HTTP
--- start(address, port = 80, proxy_addr = nil, proxy_port = nil, proxy_user=nil, proxy_pass=nil) {|http| .... } -> object

新しい [[c:Net::HTTP]] オブジェクトを生成し、
TCP コネクション、 HTTP セッションを開始します。

ブロックを与えた場合には生成したオブジェクトをそのブロックに
渡し、ブロックが終わったときに接続を閉じます。このときは
ブロックの値を返り値とします。

ブロックを与えなかった場合には生成したオブジェクトを渡します。
利用後にはこのオブジェクトを [[c:Net::HTTP#finish]] してください。

このメソッドは以下と同じです。

  Net::HTTP.new(address, port, proxy_addr, proxy_port, proxy_user, proxy_pass).start(&block)

@param address 接続するホスト名を文字列で指定します。
@param port 接続するポート番号を指定します。
@param proxy_addr プロクシのホスト名を指定します。
@param proxy_port プロクシのホスト名を指定します。
@param proxy_user プロクシの認証のユーザ名を指定します。省略した場合には認証はなされません。
@param proxy_pass プロクシの認証のパスワードを指定します。
@see [[m:Net::HTTP.new]], [[m:Net::HTTP#start]]

--- get(uri) -> String
--- get(host, path, port = 80) -> String
指定した対象に GET リクエストを送り、そのボディを
文字列として返します。

対象の指定方法は [[c:URI]] で指定するか、
(host, port, path) で指定するかのいずれかです。

@param uri データの取得対象を [[c:URI]] で指定します。
@param host 接続先のホストを文字列で指定します。
@param path データの存在するパスを文字列で指定します。
@param port 接続するポートを整数で指定します。
@see [[m:Net::HTTP#get]]

--- get_print(uri) -> ()
--- get_print(host, path, port = 80) -> ()
指定した対象から HTTP でエンティティボディを取得し、
[[m:$stdout]] に出力します。

対象の指定方法は [[c:URI]] で指定するか、
(host, port, path) で指定するかのいずれかです。

@param uri データの取得対象を [[c:URI]] で指定します。
@param host 接続先のホストを文字列で指定します。
@param path データの存在するパスを文字列で指定します。
@param port 接続するポートを整数で指定します。
@see [[m:Net::HTTP.get]]

=== 例
  Net::HTTP.get_print URI.parse('http://www.example.com/index.html')
もしくは
  Net::HTTP.get_print 'www.example.com', '/index.html'

--- get_response(uri) -> Net::HTTPResponse
--- get_response(host, path = nil, port = nil) -> Net::HTTPResponse
指定した対象に GET リクエストを送り、そのレスポンスを
[[c:Net::HTTPResponse]] として返します。

対象の指定方法は [[c:URI]] で指定するか、
(host, port, path) で指定するかのいずれかです。

@param uri データの取得対象を [[c:URI]] で指定します。
@param host 接続先のホストを文字列で指定します。
@param path データの存在するパスを文字列で指定します。
@param port 接続するポートを整数で指定します。
@see [[m:Net::HTTP#get]]

#@since 1.8.3
--- post_form(uri, params) -> Net::HTTPResponse
[[c:URI]] で指定した対象に フォームのデータを HTTP で 
POST します。

送るデータは param に文字列から文字列への [[c:Hash]] として
渡します。

@param uri POST する対象を [[c:URI]] で指定します。
@param param POST するデータです。

#@end

--- proxy_address -> String|nil
自身が ([[m:Net::HTTP.Proxy]] によって作成された) 
プロクシ用のクラスならばプロクシのアドレスを返します。

そうでなければ nil を返します。

@see [[m:Net::HTTP.Proxy]]

--- proxy_port -> Integer|nil
自身が ([[m:Net::HTTP.Proxy]] によって作成された) 
プロクシ用のクラスならばプロクシのポート番号を返します。

そうでなければ nil を返します。

@see [[m:Net::HTTP.Proxy]]

--- proxy_pass -> String|nil
自身が ([[m:Net::HTTP.Proxy]] によって作成された) 
プロクシ用のクラスならばプロクシ認証のパスワードを返します。

そうでなければ nil を返します。

@see [[m:Net::HTTP.Proxy]]

--- proxy_user -> String|nil
自身が ([[m:Net::HTTP.Proxy]] によって作成された) 
プロクシ用のクラスで、かつプロクシの認証を利用する場合は
プロクシ認証のユーザ名を返します。

そうでなければ nil を返します。

@see [[m:Net::HTTP.Proxy]]

#@# --- socket_type -> Net::BufferedIO
#@# 
#@# このメソッドは obsolete です。

--- Proxy(address, port = 80) -> Class

Proxy 経由で http サーバに接続するためのクラスを作成し返します。

このクラスは Net::HTTP を継承しているので Net::HTTP と全く
同じように使えます。指定されたプロクシを常に経由して http サーバ
に接続します。

address が nil のときは Net::HTTP クラスをそのまま返します。

例1: [[m:Net::HTTP.new]] を使う
  require 'net/http'
  proxy_class = Net::HTTP::Proxy('proxy.example.com', 8080)
  http = proxy_class.new('www.ruby-lang.org')
  http.start {|h|
    h.get('/ja/') # proxy.example.com 経由で接続します。
  }
例2: [[m:Net::HTTP.start]] を使う
  require 'net/http'
  proxy_class = Net::HTTP::Proxy('proxy.example.com', 8080)
  proxy_class.start('www.ruby-lang.org') {|h|
    h.get('/ja/') # proxy.example.com 経由で接続します。
  }

@param address プロクシのホスト名を文字列で与えます。
@param port プロクシのポート番号を与えます。

--- proxy_class? -> bool

自身が ([[m:Net::HTTP.Proxy]] によって作成された) プロクシ用のクラスならば真を返し、そうでなければ偽を返します。

@see [[m:Net::HTTP.Proxy]]

#@since 1.8.3
--- http_default_port -> Integer
--- default_port -> Integer
HTTP のデフォルトポート (80) を返します。

--- https_default_port -> Integer
HTTPS のデフォルトポート (443) を返します。

#@end

--- version_1_1 -> ()
ライブラリの動作をバージョン1.1互換にします。

@see [[m:Net::HTTP.version_1_2]], [[m:Net::HTTP.version_1_1?]]
     [[m:Net::HTTP.version_1_2?]]

--- version_1_1? -> bool
--- is_version_1_1? -> bool 
ライブラリの動作がバージョン1.1互換である場合に真を返します。

@see [[m:Net::HTTP.version_1_1]], [[m:Net::HTTP.version_1_2]]
     [[m:Net::HTTP.version_1_2?]]

--- version_1_2 -> ()
ライブラリの動作をバージョン1.2互換、つまり
通常の動作にします。

@see [[m:Net::HTTP.version_1_1]], [[m:Net::HTTP.version_1_1?]]
     [[m:Net::HTTP.version_1_2?]]

--- version_1_2? -> bool
--- is_version_1_2? -> bool 
ライブラリの動作がバージョン1.2互換である場合に真を返します。

@see [[m:Net::HTTP.version_1_1]], [[m:Net::HTTP.version_1_2]]
     [[m:Net::HTTP.version_1_1?]]

== Instance Methods

--- start -> self
--- start {|http| .... } -> object

TCP コネクションを張り、HTTP セッションを開始します。
すでにセッションが開始していたら例外 IOError を発生します。

ブロックを与えた場合には自分自身をそのブロックに
渡し、ブロックが終わったときに接続を閉じます。このときは
ブロックの値を返り値とします。

ブロックを与えなかった場合には自分自身を返します。
利用後にはこのオブジェクトを [[c:Net::HTTP#finish]] してください。

@raise IOError すでにセッションが開始していた場合に発生します。

--- started? -> bool
--- active? -> bool

HTTP セッションが開始されていたら真を返します。

active? は時代遅れのメソッドです。

--- set_debug_output(io) -> ()
#@since 1.9.1
--- debug_outupt=(io)
デバッグ出力を指定します。
このメソッドは深刻なセキュリティホールの原因
になるため、デバッグ以外では決して使わないでください。

@param io 出力先を指定します。このオブジェクトは << という
          メソッドを持っている必要があります。

#@end

--- close_on_empty_response -> bool
--- close_on_empty_response=(bool)
レスポンスがボディを持っていない場合にコネクションを
閉じるかどうかです。デフォルトでは偽(閉じない)です。

@param bool レスポンスがボディを持っていない場合にコネクションを
            閉じるかどうか指定します。

--- address -> String

接続するアドレスを返します。

@see [[m:Net::HTTP.new]]
--- port -> Integer

接続するポート番号を返します。

@see [[m:Net::HTTP.new]]
--- proxy? -> bool

プロクシを介して接続するなら真を返します。

@see [[m:Net::HTTP.Proxy]]

--- proxy_address -> String|nil
--- proxyaddr -> String|nil

プロクシ経由で接続する HTTP オブジェクトならプロクシのアドレス
を返します。

そうでないなら nil を返します。

proxyaddr は時代遅れのメソッドです。

@see [[m:Net::HTTP.Proxy]]

--- proxy_port -> Integer|nil
--- proxyport -> Integer|nil

プロクシ経由で接続する HTTP オブジェクトならプロクシのポート番号
を返します。

そうでないなら nil を返します。

proxyport は時代遅れのメソッドです。
@see [[m:Net::HTTP.Proxy]]
--- proxy_pass -> String|nil
プロクシ経由で接続し、さらにプロクシのユーザ認証を
する HTTP オブジェクトなら認証のパスワードを
を返します。

そうでないなら nil を返します。
@see [[m:Net::HTTP.Proxy]]

--- proxy_user -> String|nil
プロクシ経由で接続し、さらにプロクシのユーザ認証を
する HTTP オブジェクトなら認証のユーザ名を
を返します。

そうでないなら nil を返します。
@see [[m:Net::HTTP.Proxy]]

--- open_timeout -> Integer
--- open_timeout=(seconds)

接続時に待つ最大秒数。この秒数たってもコネクションが
開かなければ例外 [[c:TimeoutError]] を発生します。

@second 待つ秒数を指定します。
@see [[m:Net::HTTP#read_timeout]]

--- read_timeout -> Integer
--- read_timeout=(seconds)

読みこみ ([[man:read(2)]] 一回) でブロックしてよい最大秒数。
この秒数たっても読みこめなければ例外 TimeoutError を発生します。

@second 待つ秒数を指定します。
@see [[m:Net::HTTP#open_timeout]]

--- finish -> ()

HTTP セッションを終了します。セッション開始前にこのメソッドが
呼ばれた場合は例外 IOError を発生します。

@raise IOError セッション開始前に呼ぶと発生します。

--- get(path, header = nil, dest = nil) -> Net::HTTPResponse
--- get(path, header = nil, dest = nil) {|body_segment| .... } -> Net::HTTPResponse

サーバ上の path にあるエンティティを取得し、
[[c:Net::HTTPResponse]] のインスタンスとして返します。

header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして
送ります。 header は { 'Accept' = > '*/*', ... } という
形のハッシュでなければいけません。

ブロックと一緒に呼びだされたときは
エンティティボディを少しずつ文字列として
ブロックに与えます。このとき戻り値の 
[[c:Net::HTTPResponse]] オブジェクトは有効な body を
持ちません。

dest は時代遅れの引数です。利用しないでください。

@param path 取得するエンティティのパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@param dest 利用しないでください。
@see [[m:Net::HTTP#request_get]]

例:
  # net/http version 1.1 (Ruby 1.6.x)
  response, body = http.get( '/index.html' )
  
  # net/http version 1.2 (Ruby 1.8.x or later)
  response = http.get('/index.html')
  
  # compatible in both version
  response , = http.get('/index.html')
  response.body
  
  # compatible, using block
  File.open('save.txt', 'w') {|f|
    http.get('/~foo/', nil) do |str|
      f.write str
    end
  }

--- head(path, header = nil) -> Net::HTTPResponse

サーバ上の path にあるエンティティのヘッダのみを取得します。
[[c:Net::HTTPResponse]] のインスタンスを返します。

header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして
送ります。 header は { 'Accept' = > '*/*', ... } という
形のハッシュでなければいけません。

@param path 取得するエンティティのパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@param dest 利用しないでください。
@see [[m:Net::HTTP#request_head]]

例:
  response = nil
  Net::HTTP.start('some.www.server', 80) {|http|
    response = http.head('/index.html')
  }
  p response['content-type']



--- post(path, data, header = nil, dest = nil) -> Net::HTTPResponse
--- post(path, data, header = nil, dest = nil) {|body_segment| .... } -> Net::HTTPResponse

サーバ上の path にあるエンティティに対し文字列 data を
POST で送ります。

返り値は [[c:Net::HTTPResponse]] のインスタンスです。

ブロックと一緒に呼びだされたときはエンティティボディを少しずつ文字列として
ブロックに与えます。このとき戻り値の HTTPResponse オブジェクトは有効な body を
持ちません。

dest は時代遅れの引数です。利用しないでください。

POST する場合にはヘッダに Content-Type: を指定する必要があります。
もし header に指定しなかったならば、 Content-Type として
"application/x-www-form-urlencoded" を用います。

@param path POST先のパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@param dest 利用しないでください。
@see [[m:Net::HTTP#request_post]]
例:
  # net/http version 1.1 (Ruby 1.6.x)
  response, body = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # version 1.2 (Ruby 1.8.x or later)
  response = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # using block
  File.open('save.html', 'w') {|f|
    http.post('/cgi-bin/search.rb', 'query=subject&target=ruby') do |str|
      f.write str
    end
  }

--- request_get(path, header = nil) -> Net::HTTPResponse
--- request_get(path, header = nil) {|response| .... } -> Net::HTTPResponse
--- get2(path, header = nil) -> Net::HTTPResponse
--- get2(path, header = nil) {|response| .... } -> Net::HTTPResponse

サーバ上の path にあるエンティティを取得します。
[[c:Net::HTTPResponse]] オブジェクトを返します。

header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして
送ります。 header は { 'Accept' = > '*/*', ... } という
形のハッシュでなければいけません。

ブロックとともに呼び出されたときは、
エンティティボディをソケットから読み出す前に、
接続を維持した状態で [[c:Net::HTTPResponse]]
オブジェクトをブロックに渡します。
大きなサイズのボディを一度に読みだすとまずく、
小さなサイズに分けて取りだしたい場合にはこれを利用します。

@param path 取得するエンティティのパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@see [[m:Net::HTTP#get]], [[m:Net::HTTPResponse#read_body]]

  # example
  response = http.request_get('/index.html')
  p response['content-type']
  puts response.body          # body is already read
  
  # using block
  http.request_get('/index.html') {|response|
    p response['content-type']
    response.read_body do |str|   # read body now
      print str
    end
  }

get2 は時代遅れなので使わないでください。

--- request_head(path, header = nil) -> Net::HTTPResponse
--- request_head(path, header = nil) {|response| .... } -> Net::HTTPResponse
--- head2(path, header = nil) -> Net::HTTPResponse
--- head2(path, header = nil) {|response| .... } -> Net::HTTPResponse

サーバ上の path にあるエンティティのヘッダのみを取得します。
[[c:Net::HTTPResponse]] オブジェクトを返します。

header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして
送ります。 header は { 'Accept' = > '*/*', ... } という
形のハッシュでなければいけません。

ブロックとともに呼び出されたときは、
[[m:Net::HTTP#request_get]] と同じ動作を
しますが、そもそもヘッダしか要求していないので
body は空です。そのためこの動作はそれほど意味はありません。

@param path ヘッダを取得するエンティティのパスを
            文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。

@see [[m:Net::HTTP#head]]

例:
  response = http.request_head('/index.html')
  p response['content-type']

head2 は時代遅れなので使わないでください。

--- request_post(path, data, header = nil) -> Net::HTTPResponse
--- request_post(path, data, header = nil) {|response| .... } -> Net::HTTPResponse
--- post2(path, data, header = nil) -> Net::HTTPResponse
--- post2(path, data, header = nil) {|response| .... } -> Net::HTTPResponse

サーバ上の path にあるエンティティに対し文字列 data を
POST で送ります。
返り値は [[c:Net::HTTPResponse]] のインスタンスです。

header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして
送ります。 header は { 'Accept' = > '*/*', ... } という
形のハッシュでなければいけません。

ブロックとともに呼び出されたときは、
エンティティボディをソケットから読み出す前に、
接続を維持した状態で [[c:Net::HTTPResponse]]
オブジェクトをブロックに渡します。

POST する場合にはヘッダに Content-Type: を指定する必要があります。
もし header に指定しなかったならば、 Content-Type として
"application/x-www-form-urlencoded" を用います。

@param path POST先のエンティティのパスを文字列で指定します。
@param data POSTするデータを与えます。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@see [[m:Net::HTTP#post]], [[m:Net::HTTPResponse#read_body]]

  # example
  response = http.request_post('/cgi-bin/nice.rb', 'datadatadata...')
  p response.status
  puts response.body          # body is already read
  
  # using block
  http.request_post('/cgi-bin/nice.rb', 'datadatadata...') {|response|
    p response.status
    p response['content-type']
    response.read_body do |str|   # read body now
      print str
    end
  }

post2 は時代遅れなので使わないでください。


--- put(path, data, initheader = nil) -> Net::HTTPResponse
サーバ上の path にあるエンティティに対し文字列 data を
PUT で送ります。

返り値は [[c:Net::HTTPResponse]] のインスタンスです。

@param path 取得するエンティティのパスを文字列で指定します。
@param data 送るデータを文字列で指定します。
@param initheader リクエストの HTTP ヘッダをハッシュで指定します。

@see [[m:Net::HTTP#request_put]]

--- request_put(path, data, initheader = nil) -> Net::HTTPResponse
--- request_put(path, data, initheader = nil) {|response| .... } -> Net::HTTPResponse
--- put2(path, data, initheader = nil) -> Net::HTTPResponse
--- put2(path, data, initheader = nil) {|response| .... } -> Net::HTTPResponse
サーバ上の path にあるエンティティに対し文字列 data を
PUT で送ります。

返り値は [[c:Net::HTTPResponse]] のインスタンスです。

ブロックとともに呼び出されたときは、
ボディをソケットから読み出す前に、
接続を維持した状態で [[c:Net::HTTPResponse]]
オブジェクトをブロックに渡します。

@param path 取得するエンティティのパスを文字列で指定します。
@param data 送るデータを文字列で指定します。
@param initheader リクエストの HTTP ヘッダをハッシュで指定します。

@see [[m:Net::HTTP#put]]

put2 は時代遅れなので使わないでください。

--- send_request(name, path, data = nil, header = nil) -> Net::HTTPResponse
HTTP リクエストをサーバに送り、そのレスポンスを
[[c:Net::HTTPResponse]] のインスタンスとして返します。

@param name リクエストのメソッド名を文字列で与えます。
@param path リクエストのパスを文字列で与えます。
@param data リクエストのボディを文字列で与えます。
@param header リクエストのヘッダをハッシュで与えます。
@see [[m:Net::HTTP#request]]

例:
  response = http.send_request('GET', '/index.html')
  puts response.body

--- request(request [, data]) -> Net::HTTPResponse
--- request(request [, data]) {|response| .... } -> Net::HTTPResponse

[[c:Net::HTTPResquest]] オブジェクト request をサーバに送信します。
POST/PUT の時は data も与えられます 
(GET/HEAD などで  data を与えると 
[[c:ArgumentError]] を発生します)。

ブロックとともに呼びだされたときは
ソケットからボディを読みこまずに [[c:Net::HTTPResponse]]
オブジェクトをブロックに与えます。

@param request リクエストオブジェクトを与えます。
@param data リクエストのボディを文字列で与えます。
@raise ArgumentError dataを与えるべきでないリクエストでdataを
                     与えた場合に発生します。

@see [[m:Net::HTTP#send_request]]

#@# --- inspect
#@# 

#@since 1.8.3
--- copy(path, initheader = nil) -> Net::HTTPResponse
サーバの path に COPY リクエストを
ヘッダが initheader として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Copy]]


--- delete(path, initheader = nil) -> Net::HTTPResponse
サーバの path に DELETE リクエストを
ヘッダが initheader として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Delete]]


--- lock(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に LOCK リクエストを
ヘッダが initheader, ボディを body として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Lock]]

--- mkcol(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に MKCOL リクエストを
ヘッダが initheader, ボディを body として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Mkcol]]

--- move(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に MOVE リクエストを
ヘッダが initheader, ボディを body として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Move]]

--- options(path, initheader = nil) -> Net::HTTPResponse
サーバの path に OPTIONS リクエストを
ヘッダが initheader として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Options]]


--- propfind(path, body, initheader = {'Depth' => '0'}) -> Net::HTTPResponse
サーバの path に PROPFIND リクエストを
ヘッダが initheader, ボディを body として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Propfind]]


--- proppatch(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に PROPPATCH リクエストを
ヘッダが initheader, ボディを body として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Proppatch]]

--- trace(path, initheader = nil) -> Net::HTTPResponse
サーバの path に TRACE リクエストを
ヘッダが initheader として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Trace]]


--- unlock(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に UNLOCK リクエストを
ヘッダが initheader, ボディを body として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::NTTP::Unlock]]


--- use_ssl? -> bool
SSLを利用して接続する場合に真を返します。

@see [[lib:net/https]], [[lib:openssl]] 

#@end

= module Net::HTTPHeader
HTTP ヘッダのためのモジュールです。

このモジュールを mix-in に @header という(ハッシュを代入してある)
変数への「大文字小文字を無視した」ハッシュ的アクセスメソッドを
提供します。またよくある HTTP ヘッダへの便利なアクセスメソッドも
用意します。

== Instance Methods

#@# --- initialize_http_header(initheader) -> ()
#@# このモジュールを mix-in したクラスの
#@# 初期化時に呼びだし、 このモジュールの各メソッド
#@# を利用可能にします。 
#@# @param initheader 初期化時のヘッダの内容を
#@#                   {ヘッダフィールド名(文字列)=>その中身(文字列)}
#@#                   というハッシュで与えます。

--- [](key) -> String|nil
key ヘッダフィールドを返します。

たとえばキー 'content-length' に対しては  '2048'
のような文字列が得られます。キーが存在しなければ nil を返します。

#@since 1.8.3
一種類のヘッダフィールドが一つのヘッダの中に複数存在する
場合にはそれを全て ", " で連結した文字列を返します。
#@end
key は大文字小文字を区別しません。

@param key ヘッダフィール名を文字列で与えます。

@see [[m:Net::HTTPHeader#[]= ]],
#@since 1.8.3
     [[m:Net::HTTPHeader#add_field]],
     [[m:Net::HTTPHeader#get_field]]
#@end

--- []=(key, val)
key ヘッダフィールドに文字列 val をセットします。

key に元々設定されていた値は破棄されます。
key は大文字小文字を区別しません。
val に nil を与えるとそのフィールドを削除します。

@param key ヘッダフィール名を文字列で与えます。
@param val keyで指定したフィールドにセットする文字列を与えます。

@see [[m:Net::HTTPHeader#[] ]],
#@since 1.8.3
     [[m:Net::HTTPHeader#add_field]],
     [[m:Net::HTTPHeader#get_field]]
#@end

#@since 1.8.3
--- add_field(key, val) -> ()

key ヘッダフィールドに val を追加します。

key に元々設定されていた値は破棄されず、それに val 追加されます。

@param key ヘッダフィール名を文字列で与えます。
@param val keyで指定したフィールドに追加する文字列を与えます。
@see [[m:Net::HTTPHeader#[] ]], [[m:Net::HTTPHeader#[]= ]],
     [[m:Net::HTTPHeader#get_field]]

例:
  request.add_field 'X-My-Header', 'a'
  p request['X-My-Header']              #=> "a"
  p request.get_fields('X-My-Header')   #=> ["a"]
  request.add_field 'X-My-Header', 'b'
  p request['X-My-Header']              #=> "a, b"
  p request.get_fields('X-My-Header')   #=> ["a", "b"]
  request.add_field 'X-My-Header', 'c'
  p request['X-My-Header']              #=> "a, b, c"
  p request.get_fields('X-My-Header')   #=> ["a", "b", "c"]
   
--- get_fields(key) -> [String]
key ヘッダフィールドの値 (文字列) を配列で返します。

たとえばキー 'content-length' に対しては ['2048'] のような
文字列が得られます。一種類のヘッダフィールドが一つのヘッダの中
に複数存在することがありえます。
key は大文字小文字を区別しません。

@param key ヘッダフィール名を文字列で与えます。
@see [[m:Net::HTTPHeader#[] ]], [[m:Net::HTTPHeader#[]= ]],
     [[m:Net::HTTPHeader#add_field]],

#@end

--- fetch(key) -> String
--- fetch(key, default) -> String
--- fetch(key) {|hash| .... } -> String
key ヘッダフィールドを返します。

たとえばキー 'content-length' に対しては  '2048'
のような文字列が得られます。キーが存在しなければ nil を返します。

該当するキーが登録されてい
ない時には、引数 default が与えられていればその値を、ブロッ
クが与えられていればそのブロックを評価した値を返します。

#@since 1.8.3
一種類のヘッダフィールドが一つのヘッダの中に複数存在する
場合にはそれを全て ", " で連結した文字列を返します。
#@end
key は大文字小文字を区別しません。

@param key ヘッダフィール名を文字列で与えます。
@param default 該当するキーが登録されていない時の返り値を指定します。
@raise IndexError IndexError 引数defaultもブロックも与えられてない時、キーの探索に 失敗すると発生します。
@see [[m:Net::HTTPHeader#[] ]

--- size -> Integer
--- length -> Integer

このメソッドは obsolete です。


--- basic_auth(account, password) -> ()
Authorization: ヘッダを BASIC 認証用にセットします。

@param account アカウント名を文字列で与えます。
@param password パスワードを文字列で与えます。

--- chunked? -> bool
Transfer-Encoding: ヘッダフィールドが "chunked" である
場合に真を返します。

Transfer-Encoding: ヘッダフィールドが存在しなかったり、
"chunked" 以外である場合には偽を返します。

--- content_type -> String|nil
"text/html" のような Content-Type を表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

--- content_type=(type)
--- set_content_type(type, params = {})
type と param から Content-Type: ヘッダフィールドの
値を設定します。

--- main_type -> String|nil
"text/html" における "text" のような Content-Type を表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

--- sub_type -> String|nil
"text/html" における "html" のような Content-Type を表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

--- type_params -> Hash
Content-Type のパラメータを {"charset" => "iso-2022-jp"}
というような形の [[c:Hash]] で返します。

Content-Type: ヘッダフィールドが存在しない場合には
空のハッシュを返します。

--- form_data=(params) -> ()
--- set_form_data(params, sep = '&') -> ()
HTMLのフォームのデータ params から
ヘッダフィールドとボディを設定します。

ヘッダフィールド Content-Type: には
'application/x-www-form-urlencoded' が設定されます。

@param params HTML のフォームデータの [[c:Hash]] を与えます。
@param sep データのセパレータを文字列で与えます。

--- content_length -> Integer|nil
Content-Length: ヘッダフィールドの表している値を整数で返します。

ヘッダが設定されていない場合には nil を返します。

@raise Net::HTTPHeaderSyntaxError フィールドの値が不正である場合に
                                  発生します。

--- content_length=(len)
Content-Length: ヘッダフィールドに値を設定します。

len に nil を与えると Content-Length: ヘッダフィールドを
削除します。

@param len 設定する値を整数で与えます。

--- content_range -> Range|nil

Content-Range: ヘッダフィールドの値を Range で返します。
Range の表わす長さは [[m:Net::HTTPHeader#range_length]] で得られます。

ヘッダが設定されていない場合には nil を返します。

--- range_length -> Integer|nil

Content-Range: ヘッダフィールドの表している長さを整数で返します。

ヘッダが設定されていない場合には nil を返します。

@raise Net::HTTPHeaderSyntaxError Content-Range: ヘッダフィールド
                                  の値が不正である場合に
                                  発生します。
                                  
--- delete(key) -> String | nil
key ヘッダフィールドを削除します。

@param key 削除するフィールド名
@param 取り除かれたフィールドの値を返します。
       key ヘッダフィールドが存在しなかった場合には
        nil を返します。

--- each {|name, val| .... } -> ()
--- each_header {|name, val| .... } -> ()

保持しているヘッダ名とその値をそれぞれ
ブロックに渡して呼びだします。

ヘッダ名は小文字で統一されます。
val は ", " で連結した文字列がブロックに渡されます。

--- each_capitalized {|name, value| .... } -> ()
--- canonical_each {|name, value| .... } -> ()

ヘッダフィールドの正式名とその値のペアを
ブロックに渡し、呼びだします。

正式名は name に対し
  name.downcase.split(/-/).capitalize.join('-')
で求まる文字列です。

--- each_capitalized_name {|name| .... } -> ()
保持しているヘッダ名をキャピタライズ
('x-my-header' -> 'X-My-Header') 
して、ブロックに渡します。

--- each_name {|name| ... } -> ()
--- each_key {|name| ... } -> ()

保持しているヘッダ名をブロックに渡して呼びだします。

ヘッダ名は小文字で統一されます。

--- each_value {|value| .... } -> ()
保持しているヘッダの値をブロックに渡し、呼びだします。

渡される文字列は ", " で連結したものです。

--- key?(key) -> bool
key というヘッダフィールドがあれば真を返します。
key は大文字小文字を区別しません。

@param key 探すヘッダフィールド名を文字列で与えます。

--- method -> String

リクエストの HTTP メソッドを文字列で返します。

--- proxy_basic_auth(account, password) -> ()

Proxy 認証のために Proxy-Authorization: ヘッダをセットします。

@param account アカウント名を文字列で与えます。
@param password パスワードを文字列で与えます。

--- range -> Range|nil

Range: ヘッダの示す範囲を [[c:Range]] オブジェクトで返します。

ヘッダにない場合は nil を返します。

@param HTTPHeaderSyntaxError Range:ヘッダの中身が規格通りでない
                             場合に発生します。
--- range=(r)
--- set_range(i, len) -> ()
--- set_range(n) -> ()

範囲を指定してエンティティを取得するためのヘッダ Range: をセットします。

以下の3つは同じことを表しています。
  req.range = 0..1023
  req.set_range(0, 1024)
  req.set_range(1024)

特別な場合として、
n に負数を与えた場合には最初から(-n)バイトまでの範囲を表します。
r を x..-1 とした場合には、x が正ならば
x バイト目から最後までの範囲を、
x が負ならば最初から x バイト目までの範囲を表します。

@param r 範囲を [[c:Range]] オブジェクトで与えます。
@param i 範囲の始点を整数で与えます。
@param len 範囲の長さを整数で与えます。
@param n 0からの長さを整数で与えます。

= class Net::HTTPGenericRequest < Object

include Net::HTTPHeader

[[c:Net::HTTPRequest]] のスーパークラスです。
このクラスは直接は使わないでください。

[[c:Net::HTTPRequest]] のサブクラスを使ってください。

== Class Methods

#@# 
#@# --- new(m, reqbody, resbody, path, initheader = nil)

== Instance Methods

#@# --- inspect


--- body_exist? -> bool
このメソッドは obsolete です。

[[m:Net::HTTPGenericRequest#response_body_permitted?]]
の別名です。

#@since 1.8.0
--- body -> String
サーバに送るリクエストのエンティティボディを返します。

@see [[m:Net::HTTPGenericRequest#body=]]

--- body=(body)

サーバに送るリクエストのエンティティボディを文字列で設定します。

@param body 設定するボディを文字列で与えます。
@see [[m:Net::HTTPGenericRequest#body]]

#@end

#@since 1.9.1
--- body_stream -> object
--- body_stream=(f)

サーバに送るリクエストのエンティティボディを
[[c:IO]] オブジェクトなどのストリームで設定します。
f は read(size) メソッドが定義されている必要があります。

@param f エンティティボディのデータを得るストリームオブジェクトを与えます。

#@end

--- method -> String
リクエストの HTTP メソッドを文字列で返します。

--- path -> String

リクエストする path を文字列で返します。

--- request_body_permitted? -> bool

リクエストにエンティティボディを一緒に送ることが許されている
HTTP メソッド (POST など)の場合真を返します。

--- response_body_permitted? -> bool

サーバからのレスポンスにエンティティボディを含むことが許されている
HTTP メソッド (GET, POST など)の場合真を返します。


= class Net::HTTPRequest < Net::HTTPGenericRequest
HTTP リクエストを抽象化するクラスです。

Net::HTTPRequest は抽象クラスなので実際にはサブクラスの

  * [[c:Net::HTTP::Get]]
  * [[c:Net::HTTP::Head]]
  * [[c:Net::HTTP::Post]]
  * [[c:Net::HTTP::Put]]
  * [[c:Net::HTTP::Copy]]
  * [[c:Net::HTTP::Delete]]
  * [[c:Net::HTTP::Lock]]
  * [[c:Net::HTTP::Mkcol]]
  * [[c:Net::HTTP::Move]]
  * [[c:Net::HTTP::Options]]
  * [[c:Net::HTTP::Propfind]]
  * [[c:Net::HTTP::Proppatch]]
  * [[c:Net::HTTP::Trace]]
  * [[c:Net::HTTP::Unlock]]

を使用してください。

=== 例

  require 'net/http'
  http = Net::HTTP.new('www.example.com', 80)
  req = Net::HTTP::Get.new('/somefile')
  res = http.request(req)
  print res.body

== Class Methods
--- new(path, initheader = nil) -> Net::HTTPRequest
HTTP リクエストオブジェクトを生成します。

initheader でリクエストヘッダを指定することができます。
{ヘッダフィールド名(文字列)=>その中身(文字列)} という
[[c:Hash]] を用います。

@param path リクエストする path を文字列で与えます。
@param initheader リクエストヘッダをハッシュで指定します。

#@# == Constants
#@# --- METHOD -> String
#@# リクエストの HTTP メソッドを文字列で返します。

#@# 実際にはこの定数は各サブクラスで定義されています。

#@# --- REQUEST_HAS_BODY -> bool
#@# リクエストにエンティティボディを一緒に送ることが許されている
#@# HTTP メソッド (POST など)の場合真を返します。

#@# 実際にはこの定数は各サブクラスで定義されています。

#@# --- RESPONSE_HAS_BODY -> bool
#@# サーバからのレスポンスにエンティティボディを含むことが許されている
#@# HTTP メソッド (GET, POST など)の場合真を返します。

実際にはこの定数は各サブクラスで定義されています。

= class Net::HTTP::Head < Net::HTTPRequest
HTTP の HEAD リクエストを表すクラスです。

= class Net::HTTP::Get < Net::HTTPRequest
HTTP の GET リクエストを表すクラスです。

= class Net::HTTP::Post < Net::HTTPRequest
HTTP の POST リクエストを表すクラスです。

= class Net::HTTP::Put < Net::HTTPRequest
HTTP の PUT リクエストを表すクラスです。

= class Net::HTTP::Copy < Net::HTTPRequest
HTTP の COPY リクエストを表すクラスです。

= class Net::HTTP::Delete < Net::HTTPRequest
HTTP の DELETE リクエストを表すクラスです。

= class Net::HTTP::Lock < Net::HTTPRequest
HTTP の LOCK リクエストを表すクラスです。

= class Net::HTTP::Mkcol < Net::HTTPRequest
HTTP の MKCOL リクエストを表すクラスです。

= class Net::HTTP::Move < Net::HTTPRequest
HTTP の MOVE リクエストを表すクラスです。

= class Net::HTTP::Options < Net::HTTPRequest
HTTP の OPTIONS リクエストを表すクラスです。

= class Net::HTTP::Propfind < Net::HTTPRequest
HTTP の PROPFIND リクエストを表すクラスです。

= class Net::HTTP::Proppatch < Net::HTTPRequest
HTTP の PROPPATCH リクエストを表すクラスです。

= class Net::HTTP::Trace < Net::HTTPRequest
HTTP の TRACE リクエストを表すクラスです。

= class Net::HTTP::Unlock < Net::HTTPRequest
HTTP の UNLOCK リクエストを表すクラスです。

= class Net::HTTPResponse < Object
include Net::HTTPHeader

HTTP レスポンスを表現するクラスです。
Net::HTTP クラスは実際には HTTPResponse のサブクラスを返します。

== Class Methods

#@# --- new(http_version, result_code, message) 
#@# ライブラリ内部用メソッドです。使わないでください。

--- body_permitted? -> bool
エンティティボディを含むことが許されているレスポンスクラス
ならば真を、そうでなければ偽を返します。

#@# --- exception_type
#@# --- read_new 
#@# internal use only

== Instance Methods

--- code -> String

HTTP のリザルトコードです。例えば '302' などです。

この値を見ることでレスポンスの種類を判別できますが、
レスポンスオブジェクトがどのクラスのインスタンスかを
見ることでもレスポンスの種類を判別できます。

--- message -> String
--- msg -> String

HTTP サーバがリザルトコードに付加して返すメッセージです。
例えば 'Not Found' などです。

msg は obsolete です。使わないでください。

--- http_version -> String

サーバがサポートしている HTTP のバージョンを文字列で返します。

#@since 1.8.0
--- to_ary -> [Net::HTTPResponse, String]
このメソッドは net/http.rb 1.1 との互換性のために存在します。
#@end

--- value -> nil
レスポンスが 2xx(成功)でなかった場合に、対応する
例外を発生させます。

@raise HTTPError レスポンスが 1xx であるか、 net/http が知らない
                 種類のレスポンスである場合に発生します。
@raise HTTPRetriableError レスポンスが 3xx である場合に発生します。
@raise HTTPFatalError レスポンスが 4xx である場合に発生します。
@raise HTTPServerError レスポンスが 5xx である場合に発生します。


--- response -> self
--- header -> self
--- reader_header -> self

互換性を保つためだけに導入されたメソッドです。
使わないでください。

--- body -> String | () | nil
--- entity -> String | () | nil

エンティティボディを返します。

レスポンスにボディがない場合には nil を返します。

[[m:Net::HTTPResponse#read_body]] をブロック付きで呼んだ場合には
このメソッドはNet::ReadAdapter のインスタンスを返しますが、
これは使わないでください。



entity は obsolete です。

--- read_body(dest=nil) -> String|nil
--- read_body {|str| .... } -> ()

ブロックを与えなかった場合にはエンティティボディを
文字列で返します。
ブロックを与えた場合には
エンティティボディを少しずつ取得して順次ブロックに与えます。

レスポンスがボディを持たない場合には nil を返します。

一度ブロックを与えずにこのメソッドを呼んだ場合には、
次からはすでに読みだしたボディを文字列として
返します。また一度ブロックを与えてこのメソッドを呼んだ場合には、
次からは Net::ReadAdapter のインスタンスが帰ってきますが、
その場合はそのオブジェクトは使わないでください。

dest は obsolete です。使わないでください。

#@# = Constants
#@# --- CODE_CLASS_TO_OBJ
#@# --- CODE_TO_OBJ

= class Net::HTTPUnknownResponse < Net::HTTPResponse
このライブラリが知らないレスポンスを表現するクラスです。

= class Net::HTTPInformation < Net::HTTPResponse
HTTP レスポンス 1xx (Informational) を表現するクラスです。

リクエストが正常に受信し、処理を続けていることを表わして
います。

= class Net::HTTPSuccess < Net::HTTPResponse
HTTP レスポンス 2xx (Success) を表現するクラスです。

リクエストが正常に受信、処理されたことを表しています。

= class Net::HTTPRedirection < Net::HTTPResponse
HTTP レスポンス 3xx (Redirection) を表現するクラスです。

リクエストが正常に受信しましたが、処理を完了するためには
さらなる動作が必要なことを表します。

= class Net::HTTPClientError < Net::HTTPResponse
HTTP レスポンス 4xx (Client Error) を表現するクラスです。

リクエスト構文が間違っているなど、クライアントが間違って
いることを表しています。

= class Net::HTTPServerError < Net::HTTPResponse
HTTP レスポンス 2xx (Server Error) を表現するクラスです。

サーバがエラーを起こしているなど、サーバ側で処理
を完了することができないことを表しています。

= class Net::HTTPContinue < Net::HTTPInformation
HTTP レスポンス 100 (Continue) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPSwitchProtocol < Net::HTTPInformation
HTTP レスポンス 101 (Switching Protocols) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPOK < Net::HTTPSuccess
HTTP レスポンス 200 (OK) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPCreated < Net::HTTPSuccess
HTTP レスポンス 201 (Created) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPAccepted < Net::HTTPSuccess
HTTP レスポンス 202 (Accepted) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPNonAuthoritativeInformation < Net::HTTPSuccess
HTTP レスポンス 203 (Non-Authoritative Information) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPNoContent < Net::HTTPSuccess
HTTP レスポンス 204 (No Content) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPResetContent < Net::HTTPSuccess
HTTP レスポンス 205 (Reset Content) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPPartialContent < Net::HTTPSuccess
HTTP レスポンス 206 (Partial Content) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。


= class Net::HTTPMultipleChoice < Net::HTTPRedirection
HTTP レスポンス 300 (Multiple Choices) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPMovedPermanently < Net::HTTPRedirection
HTTP レスポンス 301 (Moved Permanently) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPFound < Net::HTTPRedirection
alias Net::HTTPMovedTemporarily

HTTP レスポンス 302 (Found) を表現するクラスです。
詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPSeeOther < Net::HTTPRedirection
HTTP レスポンス 303 (See Other) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPNotModified < Net::HTTPRedirection
HTTP レスポンス 304 (Not Modified) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPUseProxy < Net::HTTPRedirection
HTTP レスポンス 305 (Use Proxy) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

#@# 306 unused
= class Net::HTTPTemporaryRedirect < Net::HTTPRedirection
HTTP レスポンス 307 (Temporary Redirect) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。


= class Net::HTTPBadRequest < Net::HTTPClientError
HTTP レスポンス 400 (Bad Request) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPUnauthorized < Net::HTTPClientError
HTTP レスポンス 401 (Unauthorized) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPPaymentRequired < Net::HTTPClientError
HTTP レスポンス 402 (Payment Required) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPForbidden < Net::HTTPClientError
HTTP レスポンス 403 (Forbidden) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPNotFound < Net::HTTPClientError
HTTP レスポンス 404 (Not Found) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPMethodNotAllowed < Net::HTTPClientError
HTTP レスポンス 405  (Method Not Allowed) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPNotAcceptable < Net::HTTPClientError
HTTP レスポンス 406 (Not Acceptable) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPProxyAuthenticationRequired < Net::HTTPClientError
HTTP レスポンス 407 (Proxy Authentication Required) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPRequestTimeOut < Net::HTTPClientError
HTTP レスポンス 408 (Request Time-out) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPConflict < Net::HTTPClientError
HTTP レスポンス 409 (Conflict) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPGone < Net::HTTPClientError
HTTP レスポンス 410 (Gone) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPLengthRequired < Net::HTTPClientError
HTTP レスポンス 411 (Length Required) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPPreconditionFailed < Net::HTTPClientError
HTTP レスポンス 412 (Precondition Failed) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPRequestEntityTooLarge < Net::HTTPClientError
HTTP レスポンス 413 (Request Entity Too Large) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPRequestURITooLong < Net::HTTPClientError
alias Net::HTTPRequestURITooLarge

HTTP レスポンス 414 (Request-URI Too Large) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPUnsupportedMediaType < Net::HTTPClientError

HTTP レスポンス 415 (Unsupported Media Type) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPRequestedRangeNotSatisfiable < Net::HTTPClientError
HTTP レスポンス 416 (Requested range not satisfiable) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPExpectationFailed < Net::HTTPClientError
HTTP レスポンス 417 (Expectation Failed) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。


= class Net::HTTPInternalServerError < Net::HTTPServerError
HTTP レスポンス 500 (Internal Server Error) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPNotImplemented < Net::HTTPServerError
HTTP レスポンス 501 (Not Implemented) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPBadGateway < Net::HTTPServerError
HTTP レスポンス 502 (Bad Gateway) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPServiceUnavailable < Net::HTTPServerError
HTTP レスポンス 503 (Service Unavailable) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPGatewayTimeOut < Net::HTTPServerError
HTTP レスポンス 504 (Gateway Time-out) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。

= class Net::HTTPVersionNotSupported < Net::HTTPServerError
HTTP レスポンス 505 (HTTP Version not supported) を表現するクラスです。

詳しくは [[RFC:2616]] を見てください。


= module Net::HTTPExceptions
HTTP 例外クラスです。

実際にはこれを include した以下のサブクラスの
例外が発生します。

  * [[c:Net::HTTPError]]
  * [[c:Net::HTTPRetriableError]]
  * [[c:Net::HTTPServerError]]
  * [[c:Net::HTTPFatalError]]

また、例外を発生させるためには [[m:HTTPResponse#value]] を
呼ぶ必要があります。

== Instance Methods
--- response -> Net::HTTPResponse
--- data -> Net::HTTPResponse

エラーの原因となったレスポンスオブジェクトを返します。

#@# = class HTTPError < ProtocolError
= class HTTPError < StandardError
include Net::HTTPExceptions

HTTP ステータスコード 1xx を受け取ったという例外です。
または、ステータスコードが未知のものである場合も
これに対応します。

#@# = class HTTPRetriableError < ProtoRetriableError
= class HTTPRetriableError < StandardError
include Net::HTTPExceptions

HTTP ステータスコード 3xx を受け取ったという例外です。

リソースが移動したなどの理由により、リクエストを完了させるには更な
るアクションが必要になります。

#@# = class HTTPServerException < ProtoServerError
= class HTTPServerException < StandardError
include Net::HTTPExceptions

HTTP ステータスコード 5xx を受け取ったという例外です。

クライアントのリクエストに誤りがあるか、サーバにリクエストを拒否さ
れた(認証が必要、リソースが存在しないなどで)ことを示します。

#@# = class HTTPFatalError < ProtoFatalError
= class HTTPFatalError < StandardError
include Net::HTTPExceptions

HTTP ステータスコード 4xx を受け取ったという例外です。

クライアントのリクエストに誤りがあるか、サーバにリクエストを拒否さ
れた(認証が必要、リソースが存在しないなどで)ことを示します。


#@# internal classes
#@# = module Net::HTTP::ProxyDelta
