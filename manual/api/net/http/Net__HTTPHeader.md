---
library: net/http
---
# module Net::HTTPHeader

HTTP ヘッダのためのモジュールです。

このモジュールを mix-in に @header という(ハッシュを代入してある)
変数への「大文字小文字を無視した」ハッシュ的アクセスメソッドを
提供します。またよくある HTTP ヘッダへの便利なアクセスメソッドも
用意します。

## Instance Methods

#@# --- initialize_http_header(initheader) -> ()
#@# このモジュールを mix-in したクラスの
#@# 初期化時に呼びだし、 このモジュールの各メソッド
#@# を利用可能にします。 
#@# @param initheader 初期化時のヘッダの内容を
#@#                   {ヘッダフィールド名(文字列)=>その中身(文字列)}
#@#                   というハッシュで与えます。

### def [](key) -> String|nil

key ヘッダフィールドを返します。

たとえばキー 'content-length' に対しては  '2048'
のような文字列が得られます。キーが存在しなければ nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req['user-agent'] # => Ruby
```

一種類のヘッダフィールドが一つのヘッダの中に複数存在する
場合にはそれを全て ", " で連結した文字列を返します。
key は大文字小文字を区別しません。

- **param** `key` -- ヘッダフィール名を文字列で与えます。

- **SEE** [m:Net::HTTPHeader#\[\]=],
     [m:Net::HTTPHeader#add_field],
     [m:Net::HTTPHeader#get_fields]

### def []=(key, val)

key ヘッダフィールドに文字列 val をセットします。

key に元々設定されていた値は破棄されます。
key は大文字小文字を区別しません。
val に nil を与えるとそのフィールドを削除します。

- **param** `key` -- ヘッダフィール名を文字列で与えます。
- **param** `val` -- keyで指定したフィールドにセットする文字列を与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req['user-agent'] # => Ruby
req['user-agent'] = "update"
p req['user-agent'] # => update
```

- **SEE** [m:Net::HTTPHeader#\[\]],
     [m:Net::HTTPHeader#add_field],
     [m:Net::HTTPHeader#get_fields]

### def add_field(key, val) -> ()

key ヘッダフィールドに val を追加します。

key に元々設定されていた値は破棄されず、それに val 追加されます。

- **param** `key` -- ヘッダフィール名を文字列で与えます。
- **param** `val` -- keyで指定したフィールドに追加する文字列を与えます。
- **SEE** [m:Net::HTTPHeader#\[\]], [m:Net::HTTPHeader#\[\]=],
     [m:Net::HTTPHeader#get_fields]

```ruby title="例"
request.add_field 'X-My-Header', 'a'
p request['X-My-Header']              #=> "a"
p request.get_fields('X-My-Header')   #=> ["a"]
request.add_field 'X-My-Header', 'b'
p request['X-My-Header']              #=> "a, b"
p request.get_fields('X-My-Header')   #=> ["a", "b"]
request.add_field 'X-My-Header', 'c'
p request['X-My-Header']              #=> "a, b, c"
p request.get_fields('X-My-Header')   #=> ["a", "b", "c"]
```
   
### def get_fields(key) -> [String]

key ヘッダフィールドの値 (文字列) を配列で返します。

たとえばキー 'content-length' に対しては ['2048'] のような
文字列が得られます。一種類のヘッダフィールドが一つのヘッダの中
に複数存在することがありえます。
key は大文字小文字を区別しません。

- **param** `key` -- ヘッダフィール名を文字列で与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
res = Net::HTTP.get_response(uri)
p res.get_fields('accept-ranges') # => ["none"]
```

- **SEE** [m:Net::HTTPHeader#\[\]], [m:Net::HTTPHeader#\[\]=],
     [m:Net::HTTPHeader#add_field]

### def fetch(key) -> String
### def fetch(key, default) -> String
### def fetch(key) {|hash| .... } -> String

key ヘッダフィールドを返します。

たとえばキー 'content-length' に対しては  '2048'
のような文字列が得られます。キーが存在しなければ nil を返します。

該当するキーが登録されてい
ない時には、引数 default が与えられていればその値を、ブロッ
クが与えられていればそのブロックを評価した値を返します。

一種類のヘッダフィールドが一つのヘッダの中に複数存在する
場合にはそれを全て ", " で連結した文字列を返します。
key は大文字小文字を区別しません。

- **param** `key` -- ヘッダフィール名を文字列で与えます。
- **param** `default` -- 該当するキーが登録されていない時の返り値を指定します。
- **raise** `IndexError` -- 引数defaultもブロックも与えられてない時、キーの探索に 失敗すると発生します。

```ruby title="例 key のみ指定。key が存在する"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.fetch("user-agent") # => "Ruby"
```

```ruby title="例 key のみ指定。key が存在しない"
require 'net/http'

begin
  req.fetch("content-length")
rescue => e
  e # => #<KeyError: key not found: "content-length">
end
```

```ruby title="例 key , default を指定"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.fetch("content-length", "default") # => "default"
```

```ruby title="例 key とブロックを指定"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.fetch("content-length") { |e| 99 } # => 99
```

- **SEE** [m:Net::HTTPHeader#\[\]]

### def size -> Integer
### def length -> Integer

このメソッドは obsolete です。

ヘッダフィールドの数を返します。

#@#noexample

### def basic_auth(account, password) -> [String]

Authorization: ヘッダを BASIC 認証用にセットします。

- **param** `account` -- アカウント名を文字列で与えます。
- **param** `password` -- パスワードを文字列で与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.basic_auth("user", "pass") # => ["Basic dXNlcjpwYXNz"]
```

### def chunked? -> bool

Transfer-Encoding: ヘッダフィールドが "chunked" である
場合に真を返します。

Transfer-Encoding: ヘッダフィールドが存在しなかったり、
"chunked" 以外である場合には偽を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.chunked? # => false
req["Transfer-Encoding"] = "chunked"
p req.chunked? # => true
```

### def content_type -> String|nil

"text/html" のような Content-Type を表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/comments.cgi?post=comment')
req = Net::HTTP::Post.new(uri.request_uri)
p req.content_type  # => nil
req.content_type = 'multipart/form-data'
p req.content_type  # => "multipart/form-data"
```

### def content_type=(type)
### def set_content_type(type, params = {})

type と params から Content-Type: ヘッダフィールドの
値を設定します。

- **param** `type` -- メディアタイプを文字列で指定します。
- **param** `params` -- パラメータ属性をハッシュで指定します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.content_type                        # => nil
req.content_type = 'multipart/form-data'  # => "multipart/form-data"
p req.content_type                        # => "multipart/form-data"
```

### def main_type -> String|nil

"text/html" における "text" のようなタイプを表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
res = Net::HTTP.get_response(uri)
p res.main_type # => "text"
```

### def sub_type -> String|nil

"text/html" における "html" のようなサブタイプを表す
文字列を返します。

Content-Type: ヘッダフィールドが存在しない場合には nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
res = Net::HTTP.get_response(uri)
p res.sub_type # => "html"
```

### def type_params -> Hash

Content-Type のパラメータを {"charset" => "iso-2022-jp"}
という形の [c:Hash] で返します。

Content-Type: ヘッダフィールドが存在しない場合には
空のハッシュを返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
res = Net::HTTP.get_response(uri)
p res.type_params # => {"charset"=>"UTF-8"}
```

### def form_data=(params)
### def set_form_data(params, sep = '&') -> ()

HTMLのフォームのデータ params から
ヘッダフィールドとボディを設定します。

ヘッダフィールド Content-Type: には
'application/x-www-form-urlencoded' が設定されます。

- **param** `params` -- HTML のフォームデータの [c:Hash] を与えます。
- **param** `sep` -- データのセパレータを文字列で与えます。

```ruby title="例 form_data"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.form_data = {"q" => ["ruby", "perl"], "lang" => "en"} # => {"q"=>["ruby", "perl"], "lang"=>"en"}
```

```ruby title="例 set_form_data"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.set_form_data({"q" => "ruby", "lang" => "en"}, ';') # => "application/x-www-form-urlencoded"
```

### def content_length -> Integer|nil

Content-Length: ヘッダフィールドの表している値を整数で返します。

ヘッダが設定されていない場合には nil を返します。

- **raise** `Net::HTTPHeaderSyntaxError` -- フィールドの値が不正である場合に
                                  発生します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.content_length  # => nil
req.content_length = 10
p req.content_length  # => 10
```

### def content_length=(len)

Content-Length: ヘッダフィールドに値を設定します。

len に nil を与えると Content-Length: ヘッダフィールドを
削除します。

- **param** `len` -- 設定する値を整数で与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.content_length    # => nil
req.content_length = 10 # => 10
p req.content_length    # => 10
```

### def content_range -> Range|nil

Content-Range: ヘッダフィールドの値を Range で返します。
Range の表わす長さは [m:Net::HTTPHeader#range_length] で得られます。

ヘッダが設定されていない場合には nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.content_range    # => nil
req['Content-Range'] = "bytes 0-499/1234"
p req.content_range    # => 0..499
```

### def range_length -> Integer|nil

Content-Range: ヘッダフィールドの表している長さを整数で返します。

ヘッダが設定されていない場合には nil を返します。

- **raise** `Net::HTTPHeaderSyntaxError` -- Content-Range: ヘッダフィールド
                                  の値が不正である場合に
                                  発生します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req['Content-Range'] = "bytes 1-500/1000"
p req.range_length # => 500
```

1 以外から始まる範囲の場合は、末尾の値との差分に 1 を足した値になります。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req['Content-Range'] = "bytes 200-699/1000"
p req.range_length # => 500
```

### def delete(key) -> [String] | nil

key ヘッダフィールドを削除します。

- **param** `key` -- 削除するフィールド名
- **return** -- 取り除かれたフィールドの値を返します。
        key ヘッダフィールドが存在しなかった場合には
        nil を返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.content_length = 10
p req.content_length  # => 10
p req.delete("Content-Length")  # => ["10"]
p req.content_length  # => nil
```

### def each {|name, val| .... } -> ()
### def each_header {|name, val| .... } -> ()

保持しているヘッダ名とその値をそれぞれ
ブロックに渡して呼びだします。

ヘッダ名は小文字で統一されます。
val は ", " で連結した文字列がブロックに渡されます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.each_header { |key,value| puts "#{key} = #{value}" }

# => accept-encoding = gzip;q=1.0,deflate;q=0.6,identity;q=0.3
# => accept = */*
# => user-agent = Ruby
```

### def each_capitalized {|name, value| .... } -> ()
### def canonical_each {|name, value| .... } -> ()

ヘッダフィールドの正規化名とその値のペアを
ブロックに渡し、呼びだします。

正規化名は name に対し

```ruby
name.downcase.split(/-/).capitalize.join('-')
```

で求まる文字列です。

### def each_capitalized_name {|name| .... } -> ()

保持しているヘッダ名を正規化
('x-my-header' -> 'X-My-Header') 
して、ブロックに渡します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.each_capitalized_name { |key| puts key }

# => Accept-Encoding
# => Accept
# => User-Agent
```

### def each_name {|name| ... } -> ()
### def each_key {|name| ... } -> ()

保持しているヘッダ名をブロックに渡して呼びだします。

ヘッダ名は小文字で統一されます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.each_name { |name| puts name }

# => accept-encoding
# => accept
# => user-agent
```

### def each_value {|value| .... } -> ()

保持しているヘッダの値をブロックに渡し、呼びだします。

渡される文字列は ", " で連結したものです。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req.each_value { |value| puts value }

# => gzip;q=1.0,deflate;q=0.6,identity;q=0.3
# => */*
# => Ruby
```

### def key?(key) -> bool

key というヘッダフィールドがあれば真を返します。
key は大文字小文字を区別しません。

- **param** `key` -- 探すヘッダフィールド名を文字列で与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
res = Net::HTTP.get_response(uri)
p res.key?('content-type')   # => true
p res.key?('nonexist-header')  # => false
```

### def method -> String

リクエストの HTTP メソッドを文字列で返します。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.method # => "GET"
```

### def proxy_basic_auth(account, password) -> [String]

Proxy 認証のために Proxy-Authorization: ヘッダをセットします。

- **param** `account` -- アカウント名を文字列で与えます。
- **param** `password` -- パスワードを文字列で与えます。

```ruby title="例"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
p req.proxy_basic_auth("account", "password") # => ["Basic YWNjb3VudDpwYXNzd29yZA=="]
```

### def range -> Range|nil

Range: ヘッダの示す範囲を [c:Range] オブジェクトで返します。

ヘッダにない場合は nil を返します。

- **raise** `Net::HTTPHeaderSyntaxError` -- Range:ヘッダの中身が規格通り
                                  でない場合に発生します。

```ruby title="例 正常な値"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req['range'] = "bytes=1-5"
p req.range # => [1..5]
```

```ruby title="例 Net::HTTPHeaderSyntaxError"
require 'net/http'

uri = URI.parse('http://www.example.com/index.html')
req = Net::HTTP::Get.new(uri.request_uri)
req['range'] = "invalid"
req.range # ~> Net::HTTPHeaderSyntaxError
```

### def range=(r)
### def range=(n)
### def set_range(i, len) -> ()
### def set_range(r) -> ()
### def set_range(n) -> ()

範囲を指定してエンティティを取得するためのヘッダ Range: をセットします。

以下は同じことを表しています。

```ruby title="例"
req.range = 0..1023
req.range = 0...1024
req.range = 1024
req.set_range(0, 1024)
req.set_range(0..1023)
req.set_range(0...1024)
req.set_range(1024)
```

特別な場合として、
n に負数を与えた場合にnは最初から(-n)バイトまでの範囲を表します。
r を x..-1 とした場合には、x が正ならば
x バイト目から最後までの範囲を、
x が負ならば最初から x バイト目までの範囲を表します。

- **param** `r` -- 範囲を [c:Range] オブジェクトで与えます。
- **param** `i` -- 範囲の始点を整数で与えます。
- **param** `len` -- 範囲の長さを整数で与えます。
- **param** `n` -- 0からの長さを整数で与えます。

#@# この仕様はどこまで意図的なのだろうか？

#@# internal classes
#@# = module Net::HTTP::ProxyDelta
