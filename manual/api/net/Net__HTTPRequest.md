---
library: net/http
---
# class Net::HTTPRequest < Net::HTTPGenericRequest
HTTP リクエストを抽象化するクラスです。

Net::HTTPRequest は抽象クラスなので実際にはサブクラスの

  - [c:Net::HTTP::Get]
  - [c:Net::HTTP::Head]
  - [c:Net::HTTP::Post]
  - [c:Net::HTTP::Put]
  - [c:Net::HTTP::Copy]
  - [c:Net::HTTP::Delete]
  - [c:Net::HTTP::Lock]
  - [c:Net::HTTP::Mkcol]
  - [c:Net::HTTP::Move]
  - [c:Net::HTTP::Options]
  - [c:Net::HTTP::Propfind]
#@since 2.0.0
  - [c:Net::HTTP::Patch]
#@end
  - [c:Net::HTTP::Proppatch]
  - [c:Net::HTTP::Trace]
  - [c:Net::HTTP::Unlock]

を使用してください。

### 例

```ruby
require 'net/http'
http = Net::HTTP.new('www.example.com', 80)
req = Net::HTTP::Get.new('/somefile')
res = http.request(req)
print res.body
```

## Class Methods
### def new(path, initheader = nil) -> Net::HTTPRequest
HTTP リクエストオブジェクトを生成します。

initheader でリクエストヘッダを指定できます。
{ヘッダフィールド名(文字列)=>その中身(文字列)} という
[c:Hash] を用います。

- **param** `path` -- リクエストする path を文字列で与えます。
- **param** `initheader` -- リクエストヘッダをハッシュで指定します。

#@#noexample

#@# == Constants
#@# --- METHOD -> String
#@# リクエストの HTTP メソッドを文字列で返します。

#@# 実際にはこの定数は各サブクラスで定義されています。

#@# --- REQUEST_HAS_BODY -> bool
#@# リクエストにエンティティボディを一緒に送ることが許されている
#@# HTTP メソッド (POST など)の場合真を返します。
#@#
#@# 実際にはこの定数は各サブクラスで定義されています。

#@# --- RESPONSE_HAS_BODY -> bool
#@# サーバからのレスポンスにエンティティボディを含むことが許されている
#@# HTTP メソッド (GET, POST など)の場合真を返します。
#@#
#@# 実際にはこの定数は各サブクラスで定義されています。

