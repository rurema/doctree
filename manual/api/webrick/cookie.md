---
type: library
require:
  - webrick/httputils
---
# class WEBrick::Cookie < Object

Cookie を表すクラスです。[rfc:2109] に準拠しています。
RFC2109 は [rfc:2965] により破棄されましたが、WEBrick::Cookie クラスは RFC2965 に対応していません。

## Class Methods

### def new(name, value)    -> WEBrick::Cookie

新しい [c:WEBrick::Cookie] オブジェクトを生成して返します。
name にクッキーの名前を、value にクッキーで保持する値を与える。

- **param** `name` -- Cookie の名前を文字列で指定します。

- **param** `value` -- Cookie の値を文字列で指定します。

### def parse(str)    -> [WEBrick::Cookie]

ユーザーエージェントから送られてきた Cookie ヘッダの値 str をパースし、
新しく [c:WEBrick::Cookie] オブジェクトを生成しその配列を返します。
各属性の形式が仕様に準拠しているかを確認しません。

- **param** `str` -- Cookie を表す文字列を指定します。

```ruby
require 'webrick'
include WEBrick
c = Cookie.parse('$Version="1"; Customer="WILE"; $Path="/foo"; P_Number="Rocket"; $Path="/foo/hoge"')
p c[1].name, c[1].path
 
#=> 
"P_Number"
"/foo/hoge"
```

### def parse_set_cookie(str)    -> WEBrick::Cookie

サーバから送られてくる Set-Cookie ヘッダの値 str をパースし、
新しく [c:WEBrick::Cookie] オブジェクトを生成し返します。

- **param** `str` -- Set-Cookie ヘッダの値を文字列で指定します。

```ruby
require 'webrick'
include WEBrick
c = Cookie.parse_set_cookie('Shipping="FedEx"; Version="1"; Path="/acme"')
p c.name, c.value
  
#=>
"Shipping"
"FedEx"
```



### def parse_set_cookies(str)    -> [WEBrick::Cookie]

サーバから送られてくる Set-Cookie ヘッダの値 str をパースし、
新しく [c:WEBrick::Cookie] オブジェクトの配列を生成し返します。

- **param** `str` -- Set-Cookie ヘッダの値を文字列で指定します。


## Instance Methods

### def comment         -> String
### def comment=(value)

コメントを文字列で表すアクセサです。

- **param** `value` -- コメントを文字列で指定します。

### def domain         -> String
### def domain=(value)

ドメイン名を文字列で表すアクセサです。

- **param** `value` -- ドメイン名を表す文字列を指定します。

### def expires    -> Time
### def expires=(value)

有効期限を [c:Time]オブジェクトで表すアクセサです。

- **param** `value` -- 有効期限を [c:Time] オブジェクトまたは文字列を指定します。

### def max_age          -> Integer
### def max_age=(value)

クッキーの寿命を整数(単位は秒)で表すアクセサです。

- **param** `value` -- クッキーの寿命を正の整数で指定します。0 は直ちに破棄される事を意味する。

### def name   -> String

Cookie の名前を文字列で返します。

### def path          -> String
### def path=(value)

パス名を文字列で表すアクセサです。

- **param** `value` -- パス名を文字列で指定します。

### def secure         -> bool
### def secure=(value)

クッキーのSecure属性を真偽値で表すアクセサです。

- **param** `value` -- クッキーのSecure属性を真偽値で指定します。

### def to_s    -> String

クッキーを文字列にして返します。

### def value       -> String
### def value=(str)

クッキーの値を文字列で表すアクセサです。

- **param** `str` -- クッキーの値を文字列で指定します。

### def version           -> Integer
### def version=(value)

Cookie のバージョン番号を整数で表すアクセサです。

- **param** `value` -- Cookie のバージョン番号を整数で指定します。
