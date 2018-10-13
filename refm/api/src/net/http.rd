category Network

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
    res.value
  end

==== プロクシ経由のアクセス

#@until 2.0.0
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
#@else
Net::HTTP は http_proxy 環境変数が存在するならば自動的に
その URI を利用してプロクシを利用します。http_proxyを利用したくないならば
[[m:Net::HTTP.new]] や [[m:Net::HTTP.start]] の proxy_addr 引数に
nil を渡してください。

[[m:Net::HTTP.new]] や [[m:Net::HTTP.start]] の proxy_addr や proxy_port
を指定することでプログラムからプロクシを指定することもできます。

  require 'net/http'

  proxy_addr = 'your.proxy.host'
  proxy_port = 8080
  
  Net::HTTP.new('example.com', nil, proxy_addr, proxy_port).start { |http|
    # always proxy via your.proxy.addr:8080
  }

プロクシの認証をユーザ名とパスワードですることもできます。
詳しくは [[m:Net::HTTP.new]] を参照してください。
#@end

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
      response.value
    end
  end

  print fetch('http://www.example.org')

より詳しくは [[c:Net::HTTPResponse]]、 [[c:Net::HTTPSuccess]]、
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

#@until 1.9.3
=== 新しい仕様への変更と移行措置について

net/http 1.1 の挙動を使いたい場合には[[m:Net::HTTP.version_1_1]] を呼ん
でください。その後 [[m:Net::HTTP.version_1_2]] を呼ぶと挙動が 1.2 に戻
ります。

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
#@end

= class Net::HTTP < Object
alias HTTPSession

HTTP のクライアントのためのクラスです。

== Class Methods

#@until 2.0.0
--- new(address, port = 80, proxy_addr = nil, proxy_port = nil, proxy_user=nil, proxy_pass=nil) -> Net::HTTP
#@else
--- new(address, port = 80, proxy_addr = :ENV, proxy_port = nil, proxy_user=nil, proxy_pass=nil) -> Net::HTTP
#@end

新しい [[c:Net::HTTP]] オブジェクトを生成します。

#@since 2.0.0
proxy_addr に :ENV を指定すると自動的に環境変数 http_proxy からプロクシの URI を
取り出し利用します。この場合環境変数 http_proxy が定義されていない場合には
プロクシは利用せず直接接続します。
#@end

明示的にプロクシのホスト名とポート番号を指定してプロクシを利用することもできます。
このときには proxy_addr にホスト名もしくは IP アドレスを渡します。
このときに proxy_userを指定するとプロクシの認証が行われます


このメソッドは TCP コネクションを張りません。

@param address 接続するホスト名を文字列で指定します。
@param port 接続するポート番号を指定します。
@param proxy_addr プロクシのホスト名もしくはアドレスを文字列で指定します。:ENV を指定すると環境変数 http_proxy を利用してプロクシの設定をします。省略した場合には直接接続します。
@param proxy_port プロクシのポートを指定します。
@param proxy_user プロクシの認証のユーザ名を指定します。省略した場合には認証はなされません。
@param proxy_pass プロクシの認証のパスワードを指定します。


#@until 2.0.0
--- start(address, port = 80, proxy_addr = nil, proxy_port = nil, proxy_user=nil, proxy_pass=nil) -> Net::HTTP
--- start(address, port = 80, proxy_addr = nil, proxy_port = nil, proxy_user=nil, proxy_pass=nil) {|http| .... } -> object
#@else
--- start(address, port = 80, proxy_addr = :ENV, proxy_port = nil, proxy_user=nil, proxy_pass=nil) -> Net::HTTP
--- start(address, port = 80, proxy_addr = :ENV, proxy_port = nil, proxy_user=nil, proxy_pass=nil) {|http| .... } -> object
#@end

新しい [[c:Net::HTTP]] オブジェクトを生成し、
TCP コネクション、 HTTP セッションを開始します。

ブロックを与えた場合には生成したオブジェクトをそのブロックに
渡し、ブロックが終わったときに接続を閉じます。このときは
ブロックの値を返り値とします。

ブロックを与えなかった場合には生成したオブジェクトを渡します。
利用後にはこのオブジェクトを [[m:Net::HTTP#finish]] してください。

#@since 2.0.0
proxy_addr に :ENV を指定すると環境変数 http_proxy からプロクシの URI を
取り出し利用します。環境変数 http_proxy が定義されていない場合には
プロクシは利用しません。
#@end

このメソッドは以下と同じです。

  require 'net/http'
  Net::HTTP.new(address, port, proxy_addr, proxy_port, proxy_user, proxy_pass).start(&block)

@param address 接続するホスト名を文字列で指定します。
@param port 接続するポート番号を指定します。
@param proxy_addr プロクシのホスト名もしくはアドレスを文字列で指定します。:ENV を指定すると環境変数 http_proxy を利用してプロクシの設定をします。省略した場合には直接接続します。
@param proxy_port プロクシのポートを指定します。
@param proxy_user プロクシの認証のユーザ名を指定します。省略した場合には認証はなされません。
@param proxy_pass プロクシの認証のパスワードを指定します。
#@since 2.0.0
@raise Net::OpenTimeout 接続がタイムアウトしたときに発生します
#@end
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
  require 'net/http'
  require 'uri'
  Net::HTTP.get_print URI.parse('http://www.example.com/index.html')
もしくは
  require 'net/http'
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

送るデータは params に文字列から文字列への [[c:Hash]] として
渡します。

@param uri POST する対象を [[c:URI]] で指定します。
@param params POST するデータです。

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
  http = proxy_class.new('www.example.org')
  http.start {|h|
    h.get('/ja/') # proxy.example.com 経由で接続します。
  }
例2: [[m:Net::HTTP.start]] を使う
  require 'net/http'
  proxy_class = Net::HTTP::Proxy('proxy.example.com', 8080)
  proxy_class.start('www.example.org') {|h|
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

#@until 1.9.3
--- version_1_1 -> ()
ライブラリの動作をバージョン1.1互換にします。

@see [[m:Net::HTTP.version_1_2]], [[m:Net::HTTP.version_1_1?]]
     [[m:Net::HTTP.version_1_2?]]
#@end

#@since 1.9.3
--- version_1_1? -> false
--- is_version_1_1? -> false
何もしません。互換性のために残されており、常に false を返します。

@see [[m:Net::HTTP.version_1_2]], [[m:Net::HTTP.version_1_2?]]
#@else
--- version_1_1? -> bool
--- is_version_1_1? -> bool 
ライブラリの動作がバージョン1.1互換である場合に真を返します。

@see [[m:Net::HTTP.version_1_1]], [[m:Net::HTTP.version_1_2]]
     [[m:Net::HTTP.version_1_2?]]
#@end

#@since 1.9.3
--- version_1_2 -> true
何もしません。互換性のために残されており、常に true を返します。

@see [[m:Net::HTTP.version_1_1?]], [[m:Net::HTTP.version_1_2?]]
#@else
--- version_1_2 -> ()
ライブラリの動作をバージョン1.2互換、つまり
通常の動作にします。

@see [[m:Net::HTTP.version_1_1]], [[m:Net::HTTP.version_1_1?]]
     [[m:Net::HTTP.version_1_2?]]
#@end

#@since 1.9.3
--- version_1_2? -> true
--- is_version_1_2? -> true
何もしません。互換性のために残されており、常に true を返します。

@see [[m:Net::HTTP.version_1_2]], [[m:Net::HTTP.version_1_1?]]
#@else
--- version_1_2? -> bool
--- is_version_1_2? -> bool 
ライブラリの動作がバージョン1.2互換である場合に真を返します。

@see [[m:Net::HTTP.version_1_1]], [[m:Net::HTTP.version_1_2]]
     [[m:Net::HTTP.version_1_1?]]
#@end

== Instance Methods

--- start -> self
--- start {|http| .... } -> object

TCP コネクションを張り、HTTP セッションを開始します。
すでにセッションが開始していたら例外 IOError を発生します。

ブロックを与えた場合には自分自身をそのブロックに
渡し、ブロックが終わったときに接続を閉じます。このときは
ブロックの値を返り値とします。

ブロックを与えなかった場合には自分自身を返します。
利用後にはこのオブジェクトを [[m:Net::HTTP#finish]] してください。

@raise IOError すでにセッションが開始していた場合に発生します。
#@since 2.0.0
@raise Net::OpenTimeout 接続がタイムアウトしたときに発生します
#@end

--- started? -> bool
--- active? -> bool

HTTP セッションが開始されていたら真を返します。

active? は時代遅れのメソッドです。

--- set_debug_output(io) -> ()

デバッグ出力の出力先を指定します。
このメソッドは深刻なセキュリティホールの原因
になるため、デバッグ以外では決して使わないでください。

io に nil を指定するとデバッグ出力を止めます。

@param io 出力先を指定します。このオブジェクトは 
          メソッド << を持っている必要があります。

  http.set_debug_output($stderr)


--- close_on_empty_response -> bool
レスポンスがボディを持っていない場合にコネクションを
閉じるかどうかを返します。

デフォルトでは偽(閉じない)です。

@see [[m:Net::HTTP#close_on_empty_response=]]

--- close_on_empty_response=(bool)
レスポンスがボディを持っていない場合にコネクションを
閉じるかどうかを設定します。


@param bool レスポンスがボディを持っていない場合にコネクションを
            閉じるかどうか指定します。

@see [[m:Net::HTTP#close_on_empty_response]]

--- address -> String

接続するアドレスを返します。

@see [[m:Net::HTTP.new]]
--- port -> Integer

接続するポート番号を返します。

#@since 2.0.0
--- local_host -> String | nil

接続に用いるローカルホスト名を返します。

nil の場合システムが適当にローカルホストを
決めます。

デフォルトは nil です。


@see [[m:Net::HTTP#local_host=]], [[m:Net::HTTP#local_port]]

--- local_host=(host)

接続に用いるローカルホスト名を指定します。

nil の場合システムが適当にローカルホストを
決めます。

デフォルトは nil です。

@param host ホスト名、もしくはアドレスを示す文字列

#@samplecode 例
require 'net/http'

http = Net::HTTP.new("www.example.com")
http.local_host = "192.168.0.5"
http.local_port = "53043"

http.start do |h|
  p h.get("/").body
end
#@end

@see [[m:Net::HTTP#local_host=]], [[m:Net::HTTP#local_port]]

--- local_port -> nil | Integer | String
接続に用いるローカルポートを返します。

nil の場合システムが適当にローカルポートを
決めます。

デフォルトは nil です。

@see [[m:Net::HTTP#local_port=]], [[m:Net::HTTP#local_host]]

--- local_port=(port)
接続に用いるローカルポートを設定します。

nil の場合システムが適当にローカルポートを
決めます。

デフォルトは nil です。

@param port ローカルポート(数値、もしくはサービス名文字列)

#@samplecode 例
require 'net/http'

http = Net::HTTP.new("www.example.com")
http.local_host = "192.168.0.5"
http.local_port = "53043"

http.start do |h|
  p h.get("/").body
end
#@end

@see [[m:Net::HTTP#local_port=]], [[m:Net::HTTP#local_host]]

#@end

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

#@until 2.0.0
@see [[m:Net::HTTP.Proxy]]
#@else
@see [[m:Net::HTTP#proxy_address=]], [[m:Net::HTTP#proxy_port]], [[m:Net::HTTP.new]]
#@end

#@since 2.0.0
--- proxy_address=(address)

プロクシのアドレス(ホスト名、IPアドレス)を指定します。

[[m:Net::HTTP#start]] で接続する前に設定する必要があります。

@param address プロクシのホスト名、もしくはIPアドレスを表す文字列

@see [[m:Net::HTTP#proxy_address=]], [[m:Net::HTTP#proxy_port]], [[m:Net::HTTP.new]]
#@end

--- proxy_port -> Integer|nil
--- proxyport -> Integer|nil

プロクシのポート番号を返します。

プロクシを使わない場合は nil を返します。

proxyport は時代遅れのメソッドです。
#@until 2.0.0
@see [[m:Net::HTTP.Proxy]]
#@else
@see [[m:Net::HTTP#proxy_port=]], [[m:Net::HTTP#proxy_address]], [[m:Net::HTTP.new]]
#@end

#@since 2.0.0
--- proxy_port=(port)

プロクシのポート番号を設定します。

[[m:Net::HTTP#start]] で接続する前に設定する必要があります。

@param port ポート番号(整数、文字列)
@see [[m:Net::HTTP#proxy_port]], [[m:Net::HTTP#proxy_address]], [[m:Net::HTTP.new]]
#@end

--- proxy_pass -> String|nil
プロクシ経由で接続し、さらにプロクシのユーザ認証を
する HTTP オブジェクトなら認証のパスワードを
を返します。

そうでないなら nil を返します。
#@until 2.0.0
@see [[m:Net::HTTP.Proxy]]
#@else
@see [[m:Net::HTTP#proxy_pass=]], [[m:Net::HTTP#proxy_user]], [[m:Net::HTTP.new]]
#@end

#@since 2.0.0
--- proxy_pass=(pass)
プロクシのユーザ認証のパスワードを設定します。

[[m:Net::HTTP#start]] で接続する前に設定する必要があります。

@param pass パスワード文字列
@see [[m:Net::HTTP#proxy_pass]], [[m:Net::HTTP#proxy_user]], [[m:Net::HTTP.new]]
#@end

--- proxy_user -> String|nil
プロクシ経由で接続し、さらにプロクシのユーザ認証を
する HTTP オブジェクトなら認証のユーザ名を
を返します。

そうでないなら nil を返します。

#@until 2.0.0
@see [[m:Net::HTTP.Proxy]]
#@else
@see [[m:Net::HTTP#proxy_pass]], [[m:Net::HTTP#proxy_user=]], [[m:Net::HTTP.new]]
#@end

#@since 2.0.0
--- proxy_user=(user)
プロクシのユーザ認証のユーザ名を設定します。

[[m:Net::HTTP#start]] で接続する前に設定する必要があります。

@param user ユーザ名文字列
@see [[m:Net::HTTP#proxy_pass]], [[m:Net::HTTP#proxy_user]], [[m:Net::HTTP.new]]
#@end

#@since 2.0.0
--- proxy_uri -> String|nil

このメソッドは内部用なので使わないでください。

環境変数 http_proxy から得られるプロクシの URI を返します。

--- proxy_from_env? -> bool

プロクシ情報を環境変数から得る場合に true を返します。

基本的に [[m:Net::HTTP.new]] や [[m:Net::HTTP.start]] の proxy_address
引数に :ENV を渡した場合に true になります。

環境変数 http_proxy が定義されていなくともこの値は true を返します。
その場合にはプロクシは利用されず直接サーバに接続します。

@see [[m:Net::HTTP#proxy_from_env=]] 

--- proxy_from_env=(boolean)

プロクシ情報を環境変数から得るかどうかを指定します。

[[m:Net::HTTP#start]] で接続する前に設定する必要があります。

@param boolean プロクシ情報を環境変数から得るかどうかを指定する真偽値

@see [[m:Net::HTTP#proxy_from_env?]] 
#@end

--- open_timeout -> Integer|nil
接続時に待つ最大秒数を返します。

#@until 2.0.0
この秒数たってもコネクションが
開かなければ例外 [[c:TimeoutError]] を発生します。
#@else
この秒数たってもコネクションが
開かなければ例外 [[c:Net::OpenTimeout]] を発生します。
#@end
#@until 2.3.0
デフォルトは nil(タイムアウトしない)です。
#@else
デフォルトは60(秒)です。
#@end

@see [[m:Net::HTTP#read_timeout]], [[m:Net::HTTP#open_timeout=]]

--- open_timeout=(seconds)
接続時に待つ最大秒数を設定します。

#@until 2.0.0
この秒数たってもコネクションが
開かなければ例外 [[c:TimeoutError]] を発生します。
#@else
この秒数たってもコネクションが
開かなければ例外 [[c:Net::OpenTimeout]] を発生します。
#@end
nilを設定するとタイムアウトしなくなります。

以下のコネクションを開くメソッドで有効です。

  * [[m:Net::HTTP.open]]
  * [[m:Net::HTTP#start]]


@param second 待つ秒数を指定します。
@see [[m:Net::HTTP#read_timeout]], [[m:Net::HTTP#open_timeout]]

--- read_timeout -> Integer|nil
読みこみ([[man:read(2)]]) 一回でブロックしてよい最大秒数
を返します。

#@until 2.0.0
この秒数たっても読みこめなければ例外 [[c:TimeoutError]]
を発生します。
#@else
この秒数たっても読みこめなければ例外 [[c:Net::ReadTimeout]]
を発生します。
#@end

nilはタイムアウトしないことを意味します。

デフォルトは 60 (秒)です。

@see [[m:Net::HTTP#open_timeout]], [[m:Net::HTTP#read_timeout=]]

--- read_timeout=(seconds)

読みこみ([[man:read(2)]]) 一回でブロックしてよい最大秒数を
設定します。

#@until 2.0.0
この秒数たっても読みこめなければ例外 [[c:TimeoutError]]
を発生します。
#@else
この秒数たっても読みこめなければ例外 [[c:Net::ReadTimeout]]
を発生します。
#@end
nilを設定するとタイムアウトしなくなります。

このタイムアウト秒数はサーバとやりとりするメソッドで有効です。

デフォルトは 60 (秒)です。

@param second 待つ秒数を指定します。
@see [[m:Net::HTTP#open_timeout]], [[m:Net::HTTP#read_timeout]]

#@since 2.0.0
--- keep_alive_timeout -> Integer
以前のリクエストで使ったコネクションの再利用(keep-alive)を許可する秒数を
返します。

デフォルトは2(秒)です。

@see [[m:Net::HTTP#keep_alive_timeout=]]

--- keep_alive_timeout=(seconds)
以前のリクエストで使ったコネクションの再利用(keep-alive)を許可する秒数を
設定します。

この秒数以内に同じホストに次のリクエストを送った場合、
ソケットを再利用します。

デフォルトは2(秒)です。これは一般的にサーバ側の keep-alive の秒数
が2秒である場合が多いからです。

@see [[m:Net::HTTP#keep_alive_timeout]]

#@end

--- continue_timeout -> Integer | nil
「100 Continue」レスポンスを待つ秒数を返します。

この秒数待ってもレスポンスが来ない場合は
リクエストボディを送信します。

デフォルトは nil (待たない)です。

@see [[m:Net::HTTP#continue_timeout=]]

--- continue_timeout=(seconds)
「100 Continue」レスポンスを待つ秒数を指定します。

この秒数待ってもレスポンスが来ない場合は
リクエストボディを送信します。

デフォルトは nil (待たない)です。

@param seconds 秒数
@see [[m:Net::HTTP#continue_timeout]]

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
dest を指定した場合には
ボディを少しずつ取得して順次
「dest << ボディの断片」を実行します。

@param path 取得するエンティティのパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@param dest 利用しないでください。

1.1 互換モードの場合は、レスポンスに応じて例外が発生します。
また、返り値が [レスポンスオブジェクト, そのボディ] となります。

  # net/http version 1.1
  response, body = http.get( '/index.html' )
  
  # net/http version 1.2
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

@see [[m:Net::HTTP#request_get]]

--- head(path, header = nil) -> Net::HTTPResponse

サーバ上の path にあるエンティティのヘッダのみを取得します。
[[c:Net::HTTPResponse]] のインスタンスを返します。

header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして
送ります。 header は { 'Accept' = > '*/*', ... } という
形のハッシュでなければいけません。

@param path 取得するエンティティのパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。

1.1 互換モードの場合は、レスポンスに応じて例外が発生します。

  require 'net/http'

  response = nil
  Net::HTTP.start('some.www.server', 80) {|http|
    response = http.head('/index.html')
  }
  p response['content-type']

@see [[m:Net::HTTP#request_head]]

--- post(path, data, header = nil, dest = nil) -> Net::HTTPResponse
--- post(path, data, header = nil, dest = nil) {|body_segment| .... } -> Net::HTTPResponse

サーバ上の path にあるエンティティに対し文字列 data を
POST で送ります。

返り値は [[c:Net::HTTPResponse]] のインスタンスです。

ブロックと一緒に呼びだされたときはエンティティボディを少しずつ文字列として
ブロックに与えます。このとき戻り値の HTTPResponse オブジェクトは有効な body を
持ちません。

POST する場合にはヘッダに Content-Type: を指定する必要があります。
もし header に指定しなかったならば、 Content-Type として
"application/x-www-form-urlencoded" を用います。

dest は時代遅れの引数です。利用しないでください。
dest を指定した場合には
ボディを少しずつ取得して順次
「dest << ボディの断片」を実行します。

@param path POST先のパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@param dest 利用しないでください。

1.1 互換モードの場合は、レスポンスに応じて例外が発生します。
また、返り値が [レスポンスオブジェクト, そのボディ] となります。

例:
  # net/http version 1.1
  response, body = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # version 1.2
  response = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # using block
  File.open('save.html', 'w') {|f|
    http.post('/cgi-bin/search.rb', 'query=subject&target=ruby') do |str|
      f.write str
    end
  }

@see [[m:Net::HTTP#request_post]]

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

@see [[m:Net::HTTP#get]], [[m:Net::HTTPResponse#read_body]]

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


head2 は時代遅れなので使わないでください。

  response = http.request_head('/index.html')
  p response['content-type']

@see [[m:Net::HTTP#head]]

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

post2 は時代遅れなので使わないでください。

  # 例
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

@see [[m:Net::HTTP#post]], [[m:Net::HTTPResponse#read_body]]



--- put(path, data, initheader = nil) -> Net::HTTPResponse
サーバ上の path にあるエンティティに対し文字列 data を
PUT で送ります。

返り値は [[c:Net::HTTPResponse]] のインスタンスです。

@param path 取得するエンティティのパスを文字列で指定します。
@param data 送るデータを文字列で指定します。
@param initheader リクエストの HTTP ヘッダをハッシュで指定します。

@see [[m:Net::HTTP#request_put]]

1.1 互換モードの場合は、レスポンスに応じて例外が発生します。

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

put2 は時代遅れなので使わないでください。

@see [[m:Net::HTTP#put]]


--- send_request(name, path, data = nil, header = nil) -> Net::HTTPResponse
HTTP リクエストをサーバに送り、そのレスポンスを
[[c:Net::HTTPResponse]] のインスタンスとして返します。

@param name リクエストのメソッド名を文字列で与えます。
@param path リクエストのパスを文字列で与えます。
@param data リクエストのボディを文字列で与えます。
@param header リクエストのヘッダをハッシュで与えます。

  response = http.send_request('GET', '/index.html')
  puts response.body

@see [[m:Net::HTTP#request]]

--- request(request, data = nil) -> Net::HTTPResponse
--- request(request, data = nil) {|response| .... } -> Net::HTTPResponse

[[c:Net::HTTPRequest]] オブジェクト request をサーバに送信します。

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
ヘッダを initheader として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Copy]]

--- delete(path, initheader = nil) -> Net::HTTPResponse
サーバの path に DELETE リクエストを
ヘッダを initheader として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Delete]]

--- lock(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に LOCK リクエストを
ヘッダを initheader, ボディを body として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Lock]]

--- mkcol(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に MKCOL リクエストを
ヘッダが initheader, ボディを body として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Mkcol]]

--- move(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に MOVE リクエストを
ヘッダが initheader, ボディを body として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Move]]

--- options(path, initheader = nil) -> Net::HTTPResponse
サーバの path に OPTIONS リクエストを
ヘッダが initheader として送り、
レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Options]]

--- propfind(path, body, initheader = {'Depth' => '0'}) -> Net::HTTPResponse
サーバの path に PROPFIND リクエストを
ヘッダを initheader, ボディを body として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Propfind]]

--- patch(path, data, initheader=nil, dest=nil) -> Net::HTTPResponse
--- patch(path, data, initheader=nil, dest=nil) {|body_segment| ... } -> Net::HTTPResponse

サーバ上の path にあるエンティティに対し文字列 data を
PATCH リクエストで送ります。

返り値は [[c:Net::HTTPResponse]] のインスタンスです。

ブロックと一緒に呼びだされたときはエンティティボディを少しずつ文字列として
ブロックに与えます。このとき戻り値の HTTPResponse オブジェクトは有効な body を
持ちません。

#@# POST する場合にはヘッダに Content-Type: を指定する必要があります。
#@# もし header に指定しなかったならば、 Content-Type として
#@# "application/x-www-form-urlencoded" を用います。

Dest は時代遅れの引数です。利用しないでください。
dest を指定した場合には
ボディを少しずつ取得して順次
「dest << ボディの断片」を実行します。

@param path POST先のパスを文字列で指定します。
@param header リクエストの HTTP ヘッダをハッシュで指定します。
@param dest 利用しないでください。

--- proppatch(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に PROPPATCH リクエストを
ヘッダを initheader, ボディを body として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Proppatch]]

--- trace(path, initheader = nil) -> Net::HTTPResponse
サーバの path に TRACE リクエストを
ヘッダを initheader として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。

@see [[c:Net::HTTP::Trace]]


--- unlock(path, body, initheader = nil) -> Net::HTTPResponse
サーバの path に UNLOCK リクエストを
ヘッダを initheader, ボディを body として送ります。

レスポンスを [[c:Net::HTTPResponse]] のオブジェクト
で返します。

@param path リクエストを送るパスを文字列で与えます。
@param body リクエストのボディを文字列で与えます。
@param initheader リクエストのヘッダを「文字列=>文字列」の
                  ハッシュで与えます。
@see [[c:Net::HTTP::Unlock]]


--- use_ssl? -> bool
SSLを利用して接続する場合に真を返します。

#@until 1.9.2
[[lib:net/https]] を使わない場合には常に偽を返します。
#@end

@see [[lib:net/https]], [[lib:openssl]] 

#@end

#@since 1.9.2
--- use_ssl=(bool)
HTTP で SSL/TLS を使うかどうかを設定します。

HTTPS 使う場合は true を設定します。
セッションを開始する前に設定をしなければなりません。

デフォルトでは false です。
つまり SSL/TLS を有効にするには必ず use_ssl = true を呼ぶ必要があります。

@param bool SSL/TLS を利用するかどうか
@raise IOError セッション開始後に設定を変更しようとすると発生します

--- ssl_timeout -> Integer | nil
SSL/TLS のタイムアウト秒数を返します。

設定されていない場合は nil を返します。

@see [[m:Net::HTTP#ssl_timeout=]],
     [[m:OpenSSL::SSL::SSLContext#ssl_timeout]]

--- ssl_timeout=(sec)

SSL/TLS のタイムアウト秒数を設定します。

HTTP セッション開始時([[m:Net::HTTP#start]] など)に
[[m:OpenSSL::SSL::SSLContext#ssl_timeout=]] で
タイムアウトを設定します。

デフォルト値は [[m:OpenSSL::SSL::SSLContext#ssl_timeout=]] と
同じで、OpenSSL のデフォルト値(300秒)を用います。

@param sec タイムアウト秒数
@see [[m:Net::HTTP#ssl_timeout]],
     [[m:OpenSSL::SSL::SSLContext#ssl_timeout=]]

--- peer_cert -> OpenSSL::X509::Certificate | nil
サーバの証明書を返します。

SSL/TLS が有効でなかったり、接続前である場合には nil
を返します。

@see [[m:OpenSSL::SSL::SSLSocket#peer_cert]]

--- key -> OpenSSL::PKey::PKey | nil
クライアント証明書の秘密鍵を返します。

@see [[m:Net::HTTP#key=]], [[m:OpenSSL::SSL::SSLContext#key]]

--- key=(key)
クライアント証明書の秘密鍵を設定します。

[[c:OpenSSL::PKey::RSA]] オブジェクトか
[[c:OpenSSL::PKey::DSA]] オブジェクトを設定します。

デフォルトは nil (鍵なし)です。

@param key 設定する秘密鍵
@see [[m:Net::HTTP#key]],
     [[m:OpenSSL::SSL::SSLContext#key=]]

--- cert -> OpenSSL::X509::Certificate | nil
クライアント証明書を返します。

@see [[m:Net::HTTP#cert=]], [[m:OpenSSL::SSL::SSLContext#cert]]

--- cert=(certificate)
クライアント証明書を設定します。

デフォルトは nil (クライアント証明書による認証をしない)です。

@param certificate 証明書オブジェクト([[c:OpenSSL::X509::Certificate]])
@see [[m:Net::HTTP#cert]], [[m:OpenSSL::SSL::SSLContext#cert=]]

--- ca_file -> String | nil
信頼する CA 証明書ファイルのパスを返します。

@see [[m:Net::HTTP#ca_file=]], [[m:OpenSSL::SSL::SSLContext#ca_file]]

--- ca_file=(path)
信頼する CA 証明書ファイルのパスを文字列で設定します。

ファイルには複数の証明書を含んでいても構いません。
詳しくは [[m:OpenSSL::SSL::SSLContext#ca_file=]] を見てください。

デフォルトは nil (指定なし)です。

@param path ファイルパス文字列
@see [[m:Net::HTTP#ca_file]], [[m:OpenSSL::SSL::SSLContext#ca_file=]]

--- ca_path -> String | nil
信頼する CA 証明書ファイルが存在するディレクトリを設定します。

@see [[m:Net::HTTP#ca_path=]], [[m:OpenSSL::SSL::SSLContext#ca_path]]

--- ca_path=(path)
信頼する CA 証明書ファイルが存在するディレクトリを設定します。

ファイル名はハッシュ値の文字列にしなければなりません。
詳しくは [[m:OpenSSL::SSL::SSLContext#ca_path=]] を見てください。

デフォルトは nil (指定なし)です。

@param path ディレクトリ名文字列
@see [[m:Net::HTTP#ca_path]], [[m:OpenSSL::SSL::SSLContext#ca_path=]]

--- verify_mode -> Integer | nil
検証モードを返します。

デフォルトは nil です。

--- verify_mode=(mode)
検証モードを設定します。

詳しくは [[m:OpenSSL::SSL::SSLContext#verify_mode]] を見てください。
クライアント側なので、
[[m:OpenSSL::SSL::VERIFY_NONE]] か [[m:OpenSSL::SSL::VERIFY_PEER]]
のいずれかを用います。

デフォルトは nil で、VERIFY_NONE を意味します。

--- verify_callback -> Proc
自身に設定されている検証をフィルタするコールバックを
返します。

デフォルトのコールバックが設定されている場合には nil を返します。

@see [[m:Net::HTTP#verify_callback=]],
     [[m:OpenSSL::X509::Store#verify_callback]],
     [[m:OpenSSL::SSL::SSLContext#verify_callback]]

--- verify_callback=(proc)
検証をフィルタするコールバックを設定します。

詳しくは [[m:OpenSSL::X509::Store#verify_callback=]] や
[[m:OpenSSL::SSL::SSLContext#verify_callback=]] を見てください。

@param proc 設定する [[c:Proc]] オブジェクト
@see [[m:Net::HTTP#verify_callback]],
     [[m:OpenSSL::X509::Store#verify_callback=]],
     [[m:OpenSSL::SSL::SSLContext#verify_callback=]]

--- verify_depth -> Integer
証明書チェイン上の検証する最大の深さを返します。

@see [[m:Net::HTTP#verify_depth=]], [[m:OpenSSL::SSL::SSLContext#verify_depth]]

--- verify_depth=(depth)
証明書チェイン上の検証する最大の深さを設定します。

デフォルトは nil で、この場合 OpenSSL のデフォルト値(9)が使われます。

@param depth 最大深さを表す整数
@see [[m:Net::HTTP#verify_depth]], [[m:OpenSSL::SSL::SSLContext#verify_depth=]]

--- cert_store -> OpenSSL::X509::Store | nil
接続相手の証明書の検証のために使う、信頼している CA 証明書を
含む証明書ストアを返します。

@see [[m:Net::HTTP#cert_store]], [[m:OpenSSL::SSL::SSLContext#cert_store=]]

--- cert_store=(store)
接続相手の証明書の検証のために使う、信頼している CA 証明書を
含む証明書ストアを設定します。

通常は [[m:Net::HTTP#ca_file=]] や [[m:Net::HTTP#ca_path=]] で
設定しますが、より詳細な設定をしたい場合にはこちらを用います。

デフォルトは nil (証明書ストアを指定しない)です。

@see [[m:Net::HTTP#cert_store=]], [[m:OpenSSL::SSL::SSLContext#cert_store]]

--- ssl_version -> String | Symbol | nil
利用するプロトコルの種類を返します。

@see [[m:Net::HTTP#ssl_version=]]

--- ssl_version=(ver)
利用するプロトコルの種類を指定します。

[[m:OpenSSL::SSL::SSLContext.new]] で指定できるものと同じです。

@param ver 利用するプロトコルの種類(文字列 or シンボル)
@see [[m:Net::HTTP#ssl_version]], [[m:OpenSSL::SSL::SSL#ssl_version=]]


--- ciphers -> String | [String] | nil
[[m:Net::HTTP#ciphers]] で設定した値を返します。

[[m:OpenSSL::SSL::SSLContext#ciphers]] が返す値とは
異なるので注意してください。

@see [[m:Net::HTTP#ciphers=]]

--- ciphers=(ciphers)
利用可能な共通鍵暗号を設定します。

[[m:OpenSSL::SSL::SSLContext#ciphers=]] と同じ形式で
設定します。詳しくはそちらを参照してください。

@param ciphers 利用可能にする共通鍵暗号の種類
@see [[m:Net::HTTP#ciphers]]

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

@see [[m:Net::HTTPHeader#[]=]],
#@since 1.8.3
     [[m:Net::HTTPHeader#add_field]],
     [[m:Net::HTTPHeader#get_fields]]
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
     [[m:Net::HTTPHeader#get_fields]]
#@end

#@since 1.8.3
--- add_field(key, val) -> ()

key ヘッダフィールドに val を追加します。

key に元々設定されていた値は破棄されず、それに val 追加されます。

@param key ヘッダフィール名を文字列で与えます。
@param val keyで指定したフィールドに追加する文字列を与えます。
@see [[m:Net::HTTPHeader#[] ]], [[m:Net::HTTPHeader#[]=]],
     [[m:Net::HTTPHeader#get_fields]]

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
@see [[m:Net::HTTPHeader#[] ]], [[m:Net::HTTPHeader#[]=]],
     [[m:Net::HTTPHeader#add_field]]

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
@raise IndexError 引数defaultもブロックも与えられてない時、キーの探索に 失敗すると発生します。
@see [[m:Net::HTTPHeader#[] ]]

--- size -> Integer
--- length -> Integer

このメソッドは obsolete です。

ヘッダフィールドの数を返します。

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
type と params から Content-Type: ヘッダフィールドの
値を設定します。

@param type メディアタイプを文字列で指定します。
@param params パラメータ属性をハッシュで指定します。

--- main_type -> String|nil
"text/html" における "text" のようなタイプを表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

--- sub_type -> String|nil
"text/html" における "html" のようなサブタイプを表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

--- type_params -> Hash
Content-Type のパラメータを {"charset" => "iso-2022-jp"}
という形の [[c:Hash]] で返します。

Content-Type: ヘッダフィールドが存在しない場合には
空のハッシュを返します。

--- form_data=(params)
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
@return 取り除かれたフィールドの値を返します。
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

ヘッダフィールドの正規化名とその値のペアを
ブロックに渡し、呼びだします。

正規化名は name に対し
  name.downcase.split(/-/).capitalize.join('-')
で求まる文字列です。

--- each_capitalized_name {|name| .... } -> ()
保持しているヘッダ名を正規化
('x-my-header' -> 'X-My-Header') 
して、ブロックに渡します。

--- each_name {|name| ... } -> ()
--- each_key {|name| ... } -> ()

保持しているヘッダ名をブロックに渡して呼びだします。

ヘッダ名は小文字で統一されます。

#@samplecode 例
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.each_name { |name| puts name }

# => accept-encoding
# => accept
# => user-agent
#@end

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

@raise Net::HTTPHeaderSyntaxError Range:ヘッダの中身が規格通り
                                  でない場合に発生します。

--- range=(r)
--- range=(n)
--- set_range(i, len) -> ()
--- set_range(r) -> ()
--- set_range(n) -> ()

範囲を指定してエンティティを取得するためのヘッダ Range: をセットします。

以下は同じことを表しています。
  req.range = 0..1023
  req.range = 0...1024
  req.range = 1024
  req.set_range(0, 1024)
  req.set_range(0..1023)
  req.set_range(0...1024)
  req.set_range(1024)

特別な場合として、
n に負数を与えた場合にnは最初から(-n)バイトまでの範囲を表します。
r を x..-1 とした場合には、x が正ならば
x バイト目から最後までの範囲を、
x が負ならば最初から x バイト目までの範囲を表します。

@param r 範囲を [[c:Range]] オブジェクトで与えます。
@param i 範囲の始点を整数で与えます。
@param len 範囲の長さを整数で与えます。
@param n 0からの長さを整数で与えます。

#@# この仕様はどこまで意図的なのだろうか？

#@include(Net__HTTPRequest)

#@include(Net__HTTPResponse)

#@include(Net__HTTPExceptions)

#@# internal classes
#@# = module Net::HTTP::ProxyDelta
