---
library: net/http
include:
  - Net::HTTPHeader
---
# class Net::HTTPResponse < Object

HTTP レスポンスを表現するクラスです。
Net::HTTP クラスは実際には HTTPResponse のサブクラスを返します。

## Class Methods

### def body_permitted? -> bool
エンティティボディを含むことが許されているレスポンスクラス
ならば真を、そうでなければ偽を返します。

```ruby title="例"
require 'net/http'

Net::HTTPSuccess.body_permitted?     # => true
Net::HTTPNotModified.body_permitted? # => false
```

## Instance Methods

### def code -> String

HTTP のリザルトコードです。例えば '302' などです。

この値を見ることでレスポンスの種類を判別できますが、
レスポンスオブジェクトがどのクラスのインスタンスかを
見ることでもレスポンスの種類を判別できます。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
response.code # => "200"
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
response.message # => "OK"
```

### def http_version -> String

サーバがサポートしている HTTP のバージョンを文字列で返します。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
response.http_version # => "1.1"
```

### def value -> nil
レスポンスが 2xx(成功)でなかった場合に、対応する
例外を発生させます。

- **raise** `HTTPError` -- レスポンスが 1xx であるか、 net/http が知らない
                 種類のレスポンスである場合に発生します。
- **raise** `HTTPRetriableError` -- レスポンスが 3xx である場合に発生します。
- **raise** `HTTPServerException` -- レスポンスが 4xx である場合に発生します。
- **raise** `HTTPFatalError` -- レスポンスが 5xx である場合に発生します。

```ruby title="例 レスポンスが 2xx(成功)"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
response.value # => nil
```

```ruby title="例 レスポンスが 2xx以外"
require 'net/http'

uri = "http://www.example.com/invalid.html"
response = Net::HTTP.get_response(URI.parse(uri))
begin
  response.value
rescue => e
  e.class # => Net::HTTPServerException
  e.message # => 404 "Not Found"
end
```


### def response -> self
### def header -> self
### def reader_header -> self

互換性を保つためだけに導入されたメソッドです。
使わないでください。

自分自身を返します。

#@#noexample

### def body -> String | () | nil
### def entity -> String | () | nil

エンティティボディを返します。

レスポンスにボディがない場合には nil を返します。

[m:Net::HTTPResponse#read_body] をブロック付きで呼んだ場合には
このメソッドはNet::ReadAdapter のインスタンスを返しますが、
これは使わないでください。

entity は obsolete です。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
response.body[0..10] # => "<!doctype h"
```

### def read_body(dest=nil) -> String|nil
### def read_body {|str| .... } -> ()

ブロックを与えなかった場合にはエンティティボディを
文字列で返します。
ブロックを与えた場合には
エンティティボディを少しずつ取得して順次ブロックに
文字列で与えます。

レスポンスがボディを持たない場合には nil を返します。

```ruby title="例1 ブロックを与えずに一度に結果取得"
require 'net/http'

uri = "http://www.example.com/index.html"
response = Net::HTTP.get_response(URI.parse(uri))
response.read_body[0..10] # => "<!doctype h"
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

一度ブロックを与えずにこのメソッドを呼んだ場合には、
次からはすでに読みだしたボディを文字列として
返します。また一度ブロックを与えてこのメソッドを呼んだ場合には、
次からは Net::ReadAdapter のインスタンスが返ってきますが、
その場合はそのオブジェクトは使わないでください。

dest は obsolete です。使わないでください。
dest を指定した場合には
ボディを少しずつ取得して順次
「dest << ボディの断片」を実行します。

- **param** `dest` -- obsoleteな引数です。利用しないでください。

- **SEE** [m:Net::HTTP#request_get]

## Constants

### const CODE_CLASS_TO_OBJ -> Hash

HTTP レスポンスステータスコードの最初の数字からレスポンスのクラス(分類)を
あらわすクラスへのハッシュです。

```ruby
require 'net/http'
Net::HTTPResponse::CODE_CLASS_TO_OBJ['3'] # => Net::HTTPRedirection
```

### const CODE_TO_OBJ -> Hash

HTTP レスポンスステータスコードから対応するクラスへのハッシュです。

```ruby
require 'net/http'
Net::HTTPResponse::CODE_TO_OBJ['404'] # => Net::HTTPNotFound
```

