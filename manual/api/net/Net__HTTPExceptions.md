---
library: net/http
---
# module Net::HTTPExceptions

HTTP 例外クラスです。

実際にはこれを include した以下のサブクラスの
例外が発生します。

  - [c:Net::HTTPError]
  - [c:Net::HTTPRetriableError]
  - [c:Net::HTTPServerException]
  - [c:Net::HTTPFatalError]

また、例外を発生させるためには [m:Net::HTTPResponse#value] を
呼ぶ必要があります。

## Instance Methods
### def response -> Net::HTTPResponse

例外の原因となったレスポンスオブジェクトを返します。

```ruby title="例"
require 'net/http'

uri = "http://www.example.com/invalid.html"
response = Net::HTTP.get_response(URI.parse(uri))
begin
  response.value
rescue => e
  p e.response # => #<Net::HTTPNotFound 404 Not Found readbody=true>
end
```

