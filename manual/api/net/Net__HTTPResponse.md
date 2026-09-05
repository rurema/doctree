---
library: net/http
include:
  - Net::HTTPHeader
---
# class Net::HTTPResponse < Object

HTTP レスポンスを表現するクラスです。
Net::HTTP クラスは実際には HTTPResponse のサブクラスを返します。

## Class Methods

### def Net::HTTPResponse.body_permitted? -> bool

エンティティボディを含むことが許されているレスポンスクラスならば真を、そうでなければ偽を返します。

```ruby title="例"
require 'net/http'

p Net::HTTPSuccess.body_permitted?   # => true
p Net::HTTPNotModified.body_permitted? # => false
```

## Instance Methods

### def code -> String

HTTP のリザルトコードです。例えば '302' などです。

この値を見ることでレスポンスの種類を判別できますが、レスポンスオブジェクトがどのクラスのインスタンスかを見ることでもレスポンスの種類を判別できます。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
p response.code # => "200"
```

### def message -> String
### def msg -> String

HTTP サーバがリザルトコードに付加して返すメッセージです。
例えば 'Not Found' などです。

msg は obsolete です。使わないでください。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
p response.message # => "OK"
```

### def http_version -> String

サーバがサポートしている HTTP のバージョンを文字列で返します。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
p response.http_version # => "1.1"
```

### def value -> nil

レスポンスが 2xx(成功)でなかった場合に、対応する例外を発生させます。

- **raise** `HTTPError` -- レスポンスが 1xx であるか、 net/http が知らない種類のレスポンスである場合に発生します。
- **raise** `HTTPRetriableError` -- レスポンスが 3xx である場合に発生します。
- **raise** `HTTPServerException` -- レスポンスが 4xx である場合に発生します。
- **raise** `HTTPFatalError` -- レスポンスが 5xx である場合に発生します。

```ruby title="例 レスポンスが 2xx(成功)"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
p response.value # => nil
```

```ruby title="例 レスポンスが 2xx以外"
require 'net/http'

uri = "http://www.example.com/invalid.html"
response = Net::HTTP.get_response(URI.parse(uri))
begin
  response.value
rescue => e
  e.class # => Net::HTTPServerException
  p e.message # => 404 "Not Found"
end
```

### def response -> self
### def header -> self
### def reader_header -> self

互換性を保つためだけに導入されたメソッドです。
使わないでください。

自分自身を返します。

#%#noexample

### def body -> String | () | nil
### def entity -> String | () | nil

エンティティボディを返します。

レスポンスにボディがない場合には nil を返します。

[m:Net::HTTPResponse#read_body] をブロック付きで呼んだ場合にはこのメソッドはNet::ReadAdapter のインスタンスを返しますが、これは使わないでください。

entity は obsolete です。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
p response.body[0..10] # => "<!doctype h"
```

### def read_body(dest=nil) -> String|nil
### def read_body {|str| .... } -> ()

ブロックを与えなかった場合にはエンティティボディを文字列で返します。
ブロックを与えた場合にはエンティティボディを少しずつ取得して順次ブロックに文字列で与えます。

レスポンスがボディを持たない場合には nil を返します。

```ruby title="例1 ブロックを与えずに一度に結果取得"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
p response.read_body[0..10] # => "<!doctype h"
```

```ruby title="例2 ブロックを与えて大きいファイルを取得"
require 'net/http'

uri = URI.parse('http://www.example.com/path/to/big.file')
Net::HTTP.start(uri.host, uri.port) do |http|
  File.open("/path/to/big.file", "w") do |f|
    # Net::HTTP#request_get と Net::HTTPResponse#read_body で少しずつ読み書き。メモリ消費が少ない。
    http.request_get(uri.path) do |response|
      response.read_body do |s|
        f.write(s)
      end
    end
  end
end
```

一度ブロックを与えずにこのメソッドを呼んだ場合には、次からはすでに読みだしたボディを文字列として返します。また一度ブロックを与えてこのメソッドを呼んだ場合には、次からは Net::ReadAdapter のインスタンスが返ってきますが、その場合はそのオブジェクトは使わないでください。

dest は obsolete です。使わないでください。
dest を指定した場合にはボディを少しずつ取得して順次「dest << ボディの断片」を実行します。

- **param** `dest` -- obsoleteな引数です。利用しないでください。

- **SEE** [m:Net::HTTP#request_get]

### def body=(value)

エンティティボディを value に設定します。

- **param** `value` -- 設定するボディを文字列で指定します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
response = Net::HTTP.get_response(uri)
response.body = 'dummy'
p response.body # => "dummy"
```

- **SEE** [m:Net::HTTPResponse#body], [m:Net::HTTPResponse#read_body]

#%since 3.2
### def body_encoding -> Encoding | false
### def body_encoding=(value)

エンティティボディを読み込む際に使うエンコーディングを取得・設定します。

デフォルトは false で、この場合ボディの内容からエンコーディングが推測されます。

value には [c:Encoding] オブジェクト、またはエンコーディング名を表す文字列を指定できます。文字列を指定した場合は [m:Encoding.find] を使って [c:Encoding] オブジェクトに変換されます。

- **param** `value` -- 使用するエンコーディング ([c:Encoding] オブジェクトまたはその名前を表す文字列)

```ruby title="例"
require 'net/http'

http = Net::HTTP.new('www.example.com')
req = Net::HTTP::Get.new('/')
http.request(req) do |res|
  res.body_encoding = "UTF-8"
  p res.body.encoding # => #<Encoding:UTF-8>
end
```

#%end

### def decode_content -> bool
### def decode_content=(bool)

エンティティボディの `Content-Encoding:` を自動的に展開するかどうかを取得・設定します。

ユーザがリクエストヘッダフィールド `Accept-Encoding:` を明示的に設定・削除していなかった場合に、自動的に真が設定されます。真の場合、[m:Net::HTTPResponse#read_body] などでボディを読み込む際に、レスポンスの `Content-Encoding:` が gzip や deflate であればボディを透過的に展開します。

- **param** `bool` -- `Content-Encoding:` を自動的に展開するかどうかを真偽値で指定します。
- **SEE** [m:Net::HTTPGenericRequest#decode_content]

#%since 3.2
### def ignore_eof -> bool
### def ignore_eof=(bool)

`Content-Length:` ヘッダフィールドが指定されたボディを読み込む際に、EOF (End Of File) を無視するかどうかを取得・設定します。

- **param** `bool` -- EOF を無視するかどうかを真偽値で指定します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
response = Net::HTTP.get_response(uri)
response.ignore_eof = false
p response.ignore_eof # => false
```

- **SEE** [m:Net::HTTP#ignore_eof]

#%end

### def uri -> URI | nil

このレスポンスの取得に使われた [c:URI] オブジェクトを返します。

リクエストの生成に URI オブジェクトを使わなかった場合は nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
response = Net::HTTP.get_response(uri)
p response.uri # => #<URI::HTTP http://www.example.com/index.html>
```

- **SEE** [m:Net::HTTPGenericRequest#uri]

## Constants

### const CODE_CLASS_TO_OBJ -> Hash

HTTP レスポンスステータスコードの最初の数字からレスポンスのクラス(分類)をあらわすクラスへのハッシュです。

```ruby
require 'net/http'
p Net::HTTPResponse::CODE_CLASS_TO_OBJ['3'] # => Net::HTTPRedirection
```

### const CODE_TO_OBJ -> Hash

HTTP レスポンスステータスコードから対応するクラスへのハッシュです。

```ruby
require 'net/http'
p Net::HTTPResponse::CODE_TO_OBJ['404'] # => Net::HTTPNotFound
```

