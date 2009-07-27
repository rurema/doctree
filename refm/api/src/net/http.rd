汎用データ転送プロトコル HTTP を扱うライブラリです。
実装は [[RFC:2616]] に基きます。

=== 使用例

==== ウェブサーバからドキュメントを得る (GET)

  require 'net/http'
  Net::HTTP.version_1_2   # おまじない
  Net::HTTP.start('www.example.com', 80) {|http|
    response = http.get('/index.html')
    puts response.body
  }

また以下は同じ意味で短く書いたものです。

  require 'net/http'
  Net::HTTP.version_1_2   # おまじない
  Net::HTTP.get_print 'www.example.com', '/index.html'

==== フォームの情報を送信する (POST)

  require 'net/http'
  Net::HTTP.version_1_2   # おまじない
  Net::HTTP.start('www.example.com', 80) {|http|
    response = http.post('/cgi-bin/somecgi.rb',
                         'querytype=subject&target=ruby')
  }

(参照: フォームの値の区切り文字について)

==== プロクシ経由のアクセス

Net::HTTP のクラスメソッド Net::HTTP.Proxy は、常にプロクシ経由で
接続するような動作をする、新しいクラスを作成して返します。このクラスは
Net::HTTP を継承しているので Net::HTTP と全く同じように使えます。

  require 'net/http'
  Net::HTTP.version_1_2   # おまじない
  
  $proxy_addr = 'your.proxy.addr'
  $proxy_port = 8080
        :
  Net::HTTP::Proxy($proxy_addr, $proxy_port).start( 'some.www.server' ) {|http|
    # always connect to your.proxy.addr:8080
        :
  }

また Net::HTTP.Proxy は第一引数が nil だと Net::HTTP 自身を返すので
上のコードのように書いておけばプロクシなしの場合にも対応できます。

==== リダイレクトに対応する

以下のメソッド fetch はリダイレクトに対応しています。
limit 回数以上リダイレクトしたらエラーにします。

  require 'uri'
  require 'net/http'
  Net::HTTP.version_1_2    # おまじない
  
  def fetch(uri_str, limit = 10)
    # 適切な例外クラスに変えるべき
    raise ArgumentError, 'http redirect too deep' if limit == 0
    
    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess     then response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else
      response.error!
    end
  end
  
  print fetch('http://www.ruby-lang.org')

==== Basic 認証

  require 'net/http'
  Net::HTTP.version_1_2   # おまじない
  
  req = Net::HTTP::Get.new('/need-auth.cgi')
  req.basic_auth 'account', 'password'
  Net::HTTP.start('www.example.com') {|http|
    response = http.request(req)
    print response.body
  }

=== 新しい仕様への変更と移行措置について

Ruby 1.6 に入っているのが net/http 1.1 で 1.7 以降が 1.2 ですが、
この間ではかなり大きく仕様が変わります。そこで突然に仕様を変更
するのでなく、両方の実装を並存させる時期を設けることにしました。

メソッド HTTP.version_1_2、HTTP.version_1_1 を呼ぶと
そのあとに生成される Net::HTTP オブジェクトはそれぞれの
バージョンの仕様で動作するようになります。以下は使用例です。

  # example
  Net::HTTP.start {|http1| ...(http1 has 1.2 features)... }
  
  Net::HTTP.version_1_1
  Net::HTTP.start {|http2| ...(http2 has 1.1 features)... }
  
  Net::HTTP.version_1_2
  Net::HTTP.start {|http3| ...(http3 has 1.2 features)... }

つまり Ruby 1.6 でも Net::HTTP.version_1_2 を呼べば 1.2 の挙動になりますし、
大半のメソッドは呼べます (Ruby 1.8 でもメソッドが増えているので全てではありません)。
Ruby 1.8 でも Net::HTTP.version_1_1 を呼べば元の挙動にできるので、後方互換性を
保つことができます。

ただし、この機能はスレッドセーフではありません。
つまり、複数スレッドでそれぞれに version_1_1 や version_1_2 を呼んだ場合、
次に生成する Net::HTTP オブジェクトがどちらのバージョンになるかは保証できません。
アプリケーション全体でどちらかのバージョンに固定する必要があります。

なおどちらを使うかですが、これから書くなら断然 version_1_2 です。
require 'net/http' 直後に Net::HTTP.version_1_2 を呼んで
1.1 のことは忘れてください。

=== 例外

get、head、post メソッドで発生する HTTP プロトコル関連の例外として、
以下に挙げるものがあります。
ここに挙げる例外クラスの親クラスはすべて Net::ProtocolError クラスで、
response メソッドによってエラーの原因となったレスポンスオブジェクトを
得ることができます。

: ProtoRetriableError
    HTTP ステータスコード 3xx を受け取った時に発生します。
    リソースが移動したなどの理由により、リクエストを完了させるには更な
    るアクションが必要になります。
: ProtoFatalError
    HTTP ステータスコード 4xx を受け取った時に発生します。
    クライアントのリクエストに誤りがあるか、サーバにリクエストを拒否さ
    れた(認証が必要、リソースが存在しないなどで)ことを示します。
: ProtoServerError
    HTTP ステータスコード 5xx を受け取った時に発生します。
    サーバがリクエストを処理中にエラーが発生したことを示します。
: ProtoUnknownError
    プロトコルのバージョンが上がった、あるいはライブラリのバグなどで、
    ライブラリが対応していない状況が発生しました。

=== フォームの値の区切り文字について

POSTで application/x-www-form-urlencoded として複数のフォームの値を送る場合、
現在広く行なわれているのは、 name0=value0&name1=value1 のようにアンパサンド
(`&') で区切るやりかたです。
この方法は、RFC1866 Hypertext Markup Language - 2.0 で初めて公式に登場し、
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



= class Net::HTTP < Object

HTTP のクライアントのためのクラスです。

== Class Methods

--- new(address, port = 80, proxy_addr = nil, proxy_port = nil)
#@todo

新しい HTTP オブジェクトを生成します。address は HTTP サーバーの FQDN で、
port は接続するポート番号です。このメソッドではまだ接続はしません。

proxy_addr を与えるとプロクシを介して接続するオブジェクトを生成します。

--- start(address, port = 80, proxy_addr = nil, proxy_port = nil)
--- start(address, port = 80, proxy_addr = nil, proxy_port = nil) {|http| .... }
#@todo

以下と同じです。

  Net::HTTP.new(address, port, proxy_addr, proxy_port).start(&block)

--- get(address, path, port = 80)
#@todo

ホスト address の port 番ポートに接続して path の表現する
エンティティボディを取得し、文字列で返します。

--- get_print(address, path, port = 80)
#@todo

ホスト address の port 番ポートに接続して path の表現する
エンティティボディを取得したうえ、$stdout に << で出力します。

--- get_response(uri)
--- get_response(host, path = nil, port = nil)
#@todo

#@since 1.8.3
--- post_form(uri, params)
#@todo
#@end

--- proxy_address
#@todo

--- proxy_port
#@todo

--- proxy_pass
#@todo

--- proxy_user
#@todo

--- socket_type
#@todo

このメソッドは obsolete です。

--- Proxy(address, port = 80)
#@todo

Proxy 経由で http サーバに接続するためのクラスを作成し返します。
このクラスは Net::HTTP を継承しているので Net::HTTP と全く
同じように使えます。指定されたプロクシを常に経由して http サーバ
に接続します。

  address が nil のときは Net::HTTP クラスをそのまま返します。

  require 'net/http'
  proxy_class = Net::HTTP::Proxy('proxy.example.com', 8080)
  http = proxy_class.new('www.ruby-lang.org')
  http.start {|h|
    h.get('/ja/') # proxy.example.com 経由で接続します。
  }

--- proxy_class?
#@todo

自身が (Proxy メソッドによって作成された) プロクシ用のクラスならば真。

#@since 1.8.3
--- http_default_port
#@end
--- default_port
--- port
#@todo

HTTP のデフォルトポート (80) です。

#@since 1.8.3
--- https_default_port
#@todo

HTTPS のデフォルトポート (443) です。
#@end

--- version_1_1?
--- version_1_1
--- is_version_1_1?
#@todo

ライブラリのバージョンが 1.1 のとき true を返します。
Ruby 1.8 以降では常に false です。

--- version_1_2?
--- version_1_2
--- is_version_1_2?
#@todo

ライブラリのバージョンが 1.2 のとき true を返します。
Ruby 1.8 以降では常に true です。

== Instance Methods

--- start
--- start {|http| .... }
#@todo

TCP コネクションを張り、HTTP セッションを開始します。
すでにセッションが開始していたら例外 IOError を発生します。

イテレータとして呼ばれた時はブロックの間だけセッションを接続し、
ブロック終了とともに自動的にセッションを閉じます。

--- started?
--- active?
#@todo

HTTP セッションが開始されていたら真。

--- set_debug_output(io)
#@since 1.9.1
--- debug_outupt=(io)
#@todo
#@end

--- close_on_empty_response
--- close_on_empty_response=(bool)
#@todo

--- address
#@todo

接続するアドレス

--- port
#@todo

接続するポート番号

--- proxy?
#@todo

プロクシを介して接続するなら真を返します。

--- proxy_address
--- proxyaddr
#@todo

プロクシ経由で接続する HTTP オブジェクトならプロクシのアドレス。
そうでないなら nil。

--- proxy_port
--- proxyport
#@todo

プロクシ経由で接続する HTTP オブジェクトならプロクシのポート。
そうでないなら nil。

--- proxy_pass
#@todo

--- proxy_user
#@todo

--- open_timeout
--- open_timeout=(seconds)
#@todo

接続時に待つ最大秒数。この秒数たってもコネクションが
開かなければ例外 TimeoutError を発生します。

--- read_timeout
--- read_timeout=(seconds)
#@todo

読みこみ ([[man:read(2)]] 一回) でブロックしてよい最大秒数。
この秒数たっても読みこめなければ例外 TimeoutError を発生します。

--- finish
#@todo

HTTP セッションを終了します。セッション開始前にこのメソッドが
呼ばれた場合は例外 IOError を発生します。

--- get(path, header = nil)
--- get(path, header = nil) {|str| .... }
#@todo

サーバ上の path にあるエンティティを取得します。また header が nil
でなければ、リクエストを送るときにその内容を HTTP ヘッダとして書き
こみます。header はハッシュで、「ヘッダ名 => 内容」のような形式で
なければいけません。

戻り値は、バージョン 1.1 では HTTPResponse とエンティティボディ文字列の
二要素の配列です。1.2 では HTTPResponse ただひとつのみです。この場合、
エンティティボディは response.body で得られます。

ブロックとともに呼ばれた時はエンティティボディを少しずつブロックに
与えます。

1.1 では 3xx (再試行可能なエラー)に対しても例外を発生します。この場合
HTTPResponse は例外オブジェクトから err.response で得ることができます。
一方 1.2 では全く例外を発生しません。

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

--- head(path, header = nil)
#@todo

サーバ上の path にあるエンティティのヘッダのみを取得します。
また header が nil でなければリクエストを送るときにその内容を
HTTP ヘッダとして書きこみます。header はハッシュで、
「ヘッダ名 => 内容」のような形式でなければいけません。

HTTPResponse オブジェクトを返します。

net/http version 1.1 では 3xx (再試行可能なエラー) に対しても例外を発生します。
この場合、HTTPResponse は
例外オブジェクトから err.response で得ることができます。
一方 net/http version 1.2 では全く例外を発生しません。

  response = nil
  Net::HTTP.start('some.www.server', 80) {|http|
    response = http.head('/index.html')
  }
  p response['content-type']

--- post(path, data, header = nil, dest = nil)
--- post(path, data, header = nil) {|str| .... }
#@todo

サーバ上の path にあるエンティティに対し文字列 data を
送ります。

戻り値は get と同じように、net/http バージョン 1.1 では HTTPResponse と
エンティティボディ文字列の二要素の配列です。
net/http 1.2 では HTTPResponse ただひとつのみです。
この場合、エンティティボディは response.body で得られます。

header は get メソッドと同じです。

dest を与えた場合には、レスポンスは << メソッドを使って dest に書きこまれます。
dest には << メソッドが定義されたオブジェクト、通常 [[c:String]] オブジェクトか
[[c:Array]] オブジェクトを与えます。
この dest は戻り値の HTTPResponse オブジェクトの body にもなります。

ブロックと一緒に呼びだされたときはエンティティボディを少しずつ文字列として
ブロックに与えます。このとき戻り値の HTTPResponse オブジェクトは有効な body を
持ちません。

dest とブロックを同時に与えてはいけません。
同時に与えた場合は例外 ArgumentError を発生します。

net/http version 1.1 では 3xx (再試行可能なエラー)に対しても例外を発生します。
この場合、HTTPResponse は例外オブジェクトから
err.response で得ることができます。
一方 net/http version 1.2 では全く例外を発生しません。

  # net/http version 1.1 (Ruby 1.6.x)
  response, body = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # version 1.2 (Ruby 1.8.x or later)
  response = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # compatible in both version
  response , = http.post('/cgi-bin/search.rb', 'query=subject&target=ruby')
  
  # compatible, using block
  File.open('save.html', 'w') {|f|
    http.post('/cgi-bin/search.rb', 'query=subject&target=ruby') do |str|
      f.write str
    end
  }

--- request_get(path, header = nil)
--- request_get(path, header = nil) {|response| .... }
--- get2(path, header = nil)
--- get2(path, header = nil) {|response| .... }
#@todo

path にあるエンティティを取得します。
HTTPResponse オブジェクトを返します。

ブロックとともに呼び出されたときは、ブロック実行中は接続を
維持したまま HTTPResponse オブジェクトをブロックに渡します。

このメソッドは HTTP プロトコルに関連した例外は発生させません。

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

--- request_head(path, header = nil)
--- request_head(path, header = nil) {|response| .... }
--- head2(path, header = nil)
--- head2(path, header = nil) {|response| .... }
#@todo

--- request_post(path, data, header = nil)
--- request_post(path, data, header = nil) {|response| .... }
--- post2(path, data, header = nil)
--- post2(path, data, header = nil) {|response| .... }
#@todo

path にあるエンティティを取得します。
HTTPResponse オブジェクトを返します。

ブロックとともに呼び出されたときは、ボディを読みこむ前に
HTTPResponse オブジェクトをブロックに渡します。

このメソッドは HTTP プロトコルに関連した例外は発生させません。

  # example
  response = http.post2('/cgi-bin/nice.rb', 'datadatadata...')
  p response.status
  puts response.body          # body is already read
  
  # using block
  http.post2('/cgi-bin/nice.rb', 'datadatadata...') {|response|
    p response.status
    p response['content-type']
    response.read_body do |str|   # read body now
      print str
    end
  }

--- put(path, data, initheader = nil)
#@todo

--- request_put(path, data, initheader = nil)
--- request_put(path, data, initheader = nil) {|response| .... }
--- put2(path, data, initheader = nil)
--- put2(path, data, initheader = nil) {|response| .... }
#@todo


--- send_request(name, path, data = nil, header = nil)
#@todo

--- request(request [, data])
--- request(request [, data]) {|response| .... }
#@todo

HTTPResquest オブジェクト request を送信します。POST/PUT の時は data も
与えられます (POST/PUT 以外で data を与えると ArgumentError を発生します)。

ブロックとともに呼びだされたときはボディを読みこまずに HTTPResponse
オブジェクトをブロックに与えます。

このメソッドは HTTP プロトコルに関連した例外は発生させません。

--- inspect
#@todo

#@since 1.8.3
--- copy(path, initheader = nil)
#@todo

--- delete(path, initheader = nil)
#@todo

--- lock(path, body, initheader = nil)
#@todo

--- mkcol(path, body, initheader = nil)
#@todo

--- move(path, body, initheader = nil)
#@todo

--- options(path, initheader = nil)
#@todo

--- propfind(path, body, initheader = {'Depth' => '0'})
#@todo

--- proppatch(path, body, initheader = nil)
#@todo

--- trace(path, initheader = nil)
#@todo

--- unlock(path, body, initheader = nil)
#@todo

#@end
= module Net::HTTPHeader

== Instance Methods

--- [](key)
#@todo

key ヘッダフィールド (文字列) を返します。
たとえばキー 'content-length' に対しては '2048' のような文字列が得られます。
key は大文字小文字を区別しません。

--- []=(key)
#@todo

key ヘッダフィールドに val をセットします。
key は大文字小文字を区別しません。

#@since 1.8.3
--- add_field(key, val)
#@todo

key ヘッダフィールドに val を追加します。

--- get_fields(key)
#@todo

key ヘッダフィールドの値 (文字列) を配列で返します。
たとえばキー 'content-length' に対しては ['2048'] のような文字列が得られます。
key は大文字小文字を区別しません。
#@end

--- fetch(key)
--- fetch(key, default)
--- fetch(key) {|hash| .... }
#@todo

--- size
--- length
#@todo

このメソッドは obsolete です。

--- basic_auth(account, password)
#@todo

Authorization: ヘッダを BASIC 認証用にセットします。

--- content_length
--- content_length=(len)
#@todo

Content-Length: ヘッダの値 (整数)。

--- content_type
#@todo

--- content_type=(type)
--- set_content_type(type, params = {})
#@todo

--- main_type
#@todo

--- sub_type
#@todo

--- type_params
#@todo

--- form_data=(params)
--- set_form_data(params, sep = '&')
#@todo

--- content_range
#@todo

Content-Range: ヘッダフィールドの値を Range で返します。
Range の表わす長さは [[m:Net::HTTPHeader#range_length]] で得られます。

--- range_length
#@todo

Content-Range: ヘッダフィールドの表している長さを整数で返します。

--- delete(key)
#@todo

key ヘッダフィールドを削除します。

--- each {|name, val| .... }
--- each_header {|name, val| .... }
#@todo

ヘッダ名とその値に対するくりかえし。ヘッダ名は小文字で統一されます。

--- each_capitalized {|name, value| .... }
--- canonical_each {|name, value| .... }
#@todo

ヘッダフィールドの正式名とその値のペアに対して繰り返します。

--- each_capitalized_name {|name| .... }
#@todo

--- each_name {|name| ... }
--- each_key {|name| ... }
#@todo

--- each_value {|value| .... }
#@todo

--- key?(key)
#@todo

key というヘッダフィールドがあれば真を返します。
key は大文字小文字を区別しません。

--- method
#@todo

リクエストの HTTP メソッドを文字列で返します。

--- path
#@todo

リクエストする path を文字列で返します。

--- proxy_basic_auth(account, password)
#@todo

Proxy 認証のために Proxy-Authorization: ヘッダをセットします。

--- range
#@todo

Range: ヘッダの示す範囲を Range オブジェクトで返します。

--- range=(r)
--- set_range(i, len)
#@todo

範囲を指定してエンティティを取得するためのヘッダ Range: をセットします。
r は Range オブジェクト、i, len は始点と長さです。
= class Net::HTTPRequest < Object

include Net::HTTPHeader

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

--- new(path, initheader = nil)
#@todo

HTTP リクエストオブジェクトを生成します。
リクエストする path を文字列で与えます。

== Instance Methods

--- inspect
#@todo

--- body_exist?
#@todo

#@since 1.8.0
--- body
--- body=(body)
#@todo

サーバに送るリクエストのエンティティボディを文字列で設定します。
#@end

#@since 1.9.1
--- body_stream
--- body_stream=(f)
#@todo

サーバに送るリクエストのエンティティボディを
[[c:IO]] オブジェクトなどのストリームで設定します。
read(size) メソッドが定義されている必要があります。
#@end

--- method
#@todo

リクエストの HTTP メソッドを文字列で返します。

--- path
#@todo

リクエストする path を文字列で返します。

--- request_body_permitted?
#@todo

リクエストにエンティティボディを一緒に送ることが許されている
HTTP メソッド (POST など)の場合真を返します。

--- response_body_permitted?
#@todo

サーバからのレスポンスにエンティティボディを含むことが許されている
HTTP メソッド (GET, POST など)の場合真を返します。



= class Net::HTTP::Head < Net::HTTPRequest

= class Net::HTTP::Get < Net::HTTPRequest

= class Net::HTTP::Post < Net::HTTPRequest

= class Net::HTTP::Put < Net::HTTPRequest

= class Net::HTTP::Copy < Net::HTTPRequest

= class Net::HTTP::Delete < Net::HTTPRequest

= class Net::HTTP::Lock < Net::HTTPRequest

= class Net::HTTP::Mkcol < Net::HTTPRequest

= class Net::HTTP::Move < Net::HTTPRequest

= class Net::HTTP::Options < Net::HTTPRequest

= class Net::HTTP::Propfind < Net::HTTPRequest

= class Net::HTTP::Proppatch < Net::HTTPRequest

= class Net::HTTP::Trace < Net::HTTPRequest

= class Net::HTTP::Unlock < Net::HTTPRequest

= class Net::HTTPResponse < Object

include Net::HTTPHeader

HTTP レスポンスを表現するクラスです。
Net::HTTP クラスは実際には HTTPResponse のサブクラスを返します。

== Class Methods

--- new(http_version, result_code, message)
#@todo

ライブラリ内部用メソッドです。使わないでください。

--- body_permitted?
#@todo

== Instance Methods

--- code
#@todo

HTTP のリザルトコードです。例えば '302' などです。

--- message
--- msg
#@todo

HTTP サーバがリザルトコードに付加して返すメッセージです。
例えば 'Not Found' などです。

--- http_version
#@todo

サーバがサポートしている HTTP のバージョンを文字列で返します。

#@since 1.8.0
--- to_ary
#@todo
#@end

--- value
#@todo

--- response
--- header
--- reader_header
#@todo

互換性を保つためだけに導入されたメソッドです。
使わないでください。

--- body
--- entity
#@todo

エンティティボディです。
[[m:Net::HTTPResponse#read_body]] を呼んでいればその引数 dest、
呼んでいなければエンティティボディを文字列として読みこんで返します。

--- read_body(dest = '')
#@todo

エンティティボディを取得し dest に << メソッドを使って書きこみます。
同じ HTTPResponse オブジェクトに対して二回以上呼ばれた場合、
二回目からはなにもせずに一回目の戻り値をそのまま返します。

--- read_body {|str| .... }
#@todo

エンティティボディを少しずつ取得して順次ブロックに与えます。


= class Net::HTTPUnknownResponse < Net::HTTPResponse

= class Net::HTTPInformation < Net::HTTPResponse
1xx
= class Net::HTTPSuccess < Net::HTTPResponse
2xx
= class Net::HTTPRedirection < Net::HTTPResponse
3xx
= class Net::HTTPClientError < Net::HTTPResponse
4xx
= class Net::HTTPServerError < Net::HTTPResponse
5xx

= class Net::HTTPContinue < Net::HTTPInformation
100
= class Net::HTTPSwitchProtocol < Net::HTTPInformation
101

= class Net::HTTPOK < Net::HTTPSuccess
200
= class Net::HTTPCreated < Net::HTTPSuccess
201
= class Net::HTTPAccepted < Net::HTTPSuccess
202
= class Net::HTTPNonAuthoritativeInformation < Net::HTTPSuccess
203
= class Net::HTTPNoContent < Net::HTTPSuccess
204
= class Net::HTTPResetContent < Net::HTTPSuccess
205
= class Net::HTTPPartialContent < Net::HTTPSuccess
206

= class Net::HTTPMultipleChoice < Net::HTTPRedirection
300
= class Net::HTTPMovedPermanently < Net::HTTPRedirection
301
= class Net::HTTPFound < Net::HTTPRedirection
302
#@# alias: Net::HTTPMovedTemporarily
= class Net::HTTPSeeOther < Net::HTTPRedirection
303
= class Net::HTTPNotModified < Net::HTTPRedirection
304
= class Net::HTTPUseProxy < Net::HTTPRedirection
305
#@# 306 unused
= class Net::HTTPTemporaryRedirect < Net::HTTPRedirection
307

= class Net::HTTPBadRequest < Net::HTTPClientError
400
= class Net::HTTPUnauthorized < Net::HTTPClientError
401
= class Net::HTTPPaymentRequired < Net::HTTPClientError
402
= class Net::HTTPForbidden < Net::HTTPClientError
403
= class Net::HTTPNotFound < Net::HTTPClientError
404
= class Net::HTTPMethodNotAllowed < Net::HTTPClientError
405
= class Net::HTTPNotAcceptable < Net::HTTPClientError
406
= class Net::HTTPProxyAuthenticationRequired < Net::HTTPClientError
407
= class Net::HTTPRequestTimeOut < Net::HTTPClientError
408
= class Net::HTTPConflict < Net::HTTPClientError
409
= class Net::HTTPGone < Net::HTTPClientError
410
= class Net::HTTPLengthRequired < Net::HTTPClientError
411
= class Net::HTTPPreconditionFailed < Net::HTTPClientError
412
= class Net::HTTPRequestEntityTooLarge < Net::HTTPClientError
413
= class Net::HTTPRequestURITooLong < Net::HTTPClientError
#@# alias: Net::HTTPRequestURITooLarge
414
= class Net::HTTPUnsupportedMediaType < Net::HTTPClientError
415
= class Net::HTTPRequestedRangeNotSatisfiable < Net::HTTPClientError
416
= class Net::HTTPExpectationFailed < Net::HTTPClientError
417

= class Net::HTTPInternalServerError < Net::HTTPServerError
500
= class Net::HTTPNotImplemented < Net::HTTPServerError
501
= class Net::HTTPBadGateway < Net::HTTPServerError
502
= class Net::HTTPServiceUnavailable < Net::HTTPServerError
503
= class Net::HTTPGatewayTimeOut < Net::HTTPServerError
504
= class Net::HTTPVersionNotSupported < Net::HTTPServerError
505
