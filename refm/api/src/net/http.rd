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


#@include(HTTP)
#@include(HTTPHeader)
#@include(HTTPRequest)
#@include(HTTPResponse)
