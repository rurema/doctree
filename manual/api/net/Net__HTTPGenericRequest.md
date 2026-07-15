---
library: net/http
include:
  - Net::HTTPHeader
---
# class Net::HTTPGenericRequest < Object

[c:Net::HTTPRequest] のスーパークラスです。
このクラスは直接は使わないでください。

[c:Net::HTTPRequest] のサブクラスを使ってください。

## Class Methods

#@# 
#@# --- new(m, reqbody, resbody, path, initheader = nil)

## Instance Methods

#@# --- inspect


### def body_exist? -> bool
このメソッドは obsolete です。

#@#noexample obsolete のため不要

[m:Net::HTTPGenericRequest#response_body_permitted?]
の別名です。

### def body -> String
サーバに送るリクエストのエンティティボディを返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Post.new(uri.request_uri)
req.body = "Test Post Data"
p req.body # => "Test Post Data"
```

- **SEE** [m:Net::HTTPGenericRequest#body=]

### def body=(body)

サーバに送るリクエストのエンティティボディを文字列で設定します。

- **param** `body` -- 設定するボディを文字列で与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Post.new(uri.request_uri)
req.body = "Test Post Data" # => "Test Post Data"
```

- **SEE** [m:Net::HTTPGenericRequest#body]


### def body_stream -> object
### def body_stream=(f)

サーバに送るリクエストのエンティティボディを
[c:IO] オブジェクトなどのストリームで設定します。
f は read(size) メソッドが定義されている必要があります。

- **param** `f` -- エンティティボディのデータを得るストリームオブジェクトを与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
post = Net::HTTP::Post.new(uri.request_uri)
File.open("/path/to/test", 'rb') do |f|
  # 大きなファイルを扱う際にメモリ消費を少なくできる
  post.body_stream = f
  post["Content-Length"] = f.size.to_s
  post.body_stream # => #<File:/path/to/test>
end
```


### def method -> String
リクエストの HTTP メソッドを文字列で返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Post.new(uri.request_uri)
p req.method # => "POST"
req = Net::HTTP::Get.new(uri.request_uri)
p req.method # => "GET"
```

### def path -> String

リクエストする path を文字列で返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.path # => "/index.html"
```

### def request_body_permitted? -> bool

リクエストにエンティティボディを一緒に送ることが許されている
HTTP メソッド (POST など)の場合真を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
post = Net::HTTP::Post.new(uri.request_uri)
post.request_body_permitted?   # => true

head = Net::HTTP::Head.new(uri.request_uri)
p head.request_body_permitted? # => false
```

### def response_body_permitted? -> bool

サーバからのレスポンスにエンティティボディを含むことが許されている
HTTP メソッド (GET, POST など)の場合真を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
post = Net::HTTP::Post.new(uri.request_uri)
post.response_body_permitted?   # => true

head = Net::HTTP::Head.new(uri.request_uri)
p head.response_body_permitted? # => false
```

