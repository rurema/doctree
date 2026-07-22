---
library: net/http
---
# class Net::HTTPServiceUnavailable < Net::HTTPServerError

HTTP レスポンス 503 (Service Unavailable) を表現するクラスです。

詳しくは [RFC:7231] Section 6.6.4 を見てください。

# class Net::HTTPGatewayTimeout < Net::HTTPServerError

alias Net::HTTPGatewayTimeOut
HTTP レスポンス 504 (Gateway Timeout) を表現するクラスです。

詳しくは [RFC:7231] Section 6.6.5 を見てください。

