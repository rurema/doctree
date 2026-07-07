---
type: library
category: Network
---
汎用データ転送プロトコル HTTP を扱うライブラリです。
実装は [RFC:2616] に基きます。

### 使用例

#### ウェブサーバからドキュメントを得る (GET)

```ruby title="例1: GET して 表示するだけ"
require 'net/http'
print Net::HTTP.get('www.example.com', '/index.html')
```

```ruby title="例2: URI を使う"
require 'net/http'
require 'uri'
print Net::HTTP.get(URI.parse('http://www.example.com/index.html'))
```

```ruby title="例3: より汎用的な例"
require 'net/http'
require 'uri'

url = URI.parse('http://www.example.com/index.html')
res = Net::HTTP.start(url.host, url.port) {|http|
  http.get('/index.html')
}
puts res.body
```

```ruby title="例4: 上の例よりさらに汎用的な例"
require 'net/http'

url = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
puts res.body
```

#### フォームの情報を送信する (POST)

```ruby title="例"
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
req.set_form_data({'from'=>'2005-01-01', 'to'=>'2005-03-31'})
res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
case res
when Net::HTTPSuccess, Net::HTTPRedirection
  # OK
else
  res.value
end
```

#### プロクシ経由のアクセス

Net::HTTP は http_proxy 環境変数が存在するならば自動的に
その URI を利用してプロクシを利用します。http_proxyを利用したくないならば
[m:Net::HTTP.new] や [m:Net::HTTP.start] の proxy_addr 引数に
nil を渡してください。

[m:Net::HTTP.new] や [m:Net::HTTP.start] の proxy_addr や proxy_port
を指定することでプログラムからプロクシを指定することもできます。

```ruby title="例"
require 'net/http'

proxy_addr = 'your.proxy.host'
proxy_port = 8080

Net::HTTP.new('example.com', nil, proxy_addr, proxy_port).start { |http|
  # always proxy via your.proxy.addr:8080
}
```

プロクシの認証をユーザ名とパスワードですることもできます。
詳しくは [m:Net::HTTP.new] を参照してください。


#### リダイレクトに対応する
以下の例の fetch はリダイレクトに対応しています。
limit 回数以上リダイレクトしたらエラーにします。

```ruby title="例"
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
```

より詳しくは [c:Net::HTTPResponse]、 [c:Net::HTTPSuccess]、
[c:Net::HTTPRedirection] を参照してください。

#### Basic 認証

```ruby title="例"
require 'net/http'

Net::HTTP.start('www.example.com') {|http|
  req = Net::HTTP::Get.new('/secret-page.html')
  req.basic_auth 'account', 'password'
  response = http.request(req)
  print response.body
}
```


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

### フォームの値の区切り文字について

POSTで application/x-www-form-urlencoded として複数のフォームの値を送る場合、
現在広く行なわれているのは、 name0=value0&name1=value1 のようにアンパサンド
(`&`) で区切るやりかたです。
この方法は、[RFC:1866] Hypertext Markup Language - 2.0 で初めて公式に登場し、
HTML 4.01 Specification の 17.13.4 Form content types
でもそのように書かれています。

ところが、同じ HTML 4.01 Specification の
B.2.2 Ampersands in URI attribute values では、
この `&` がSGMLの文字実体参照で用いられることが指摘されており、
CGIやサーバの実装者に対し `&` の代わりに
セミコロン `;` をサポートすることを奨めています。

しかし、実際には `;` を解釈しないCGIやサーバもまだまだ見受けられるため
このリファレンスマニュアルでは例として `&` を用いました。

なお Ruby 標準の [lib:cgi] ライブラリでは '&' と ';' の両方サポートしていますので、
[lib:cgi] ライブラリを使って CGI スクリプトを書く場合はこれらの違いを気にする
必要はありません。


