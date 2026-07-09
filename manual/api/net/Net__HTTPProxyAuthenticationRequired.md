---
library: net/http
---
# class Net::HTTPProxyAuthenticationRequired < Net::HTTPClientError
HTTP レスポンス 407 (Proxy Authentication Required) を表現するクラスです。

詳しくは [RFC:7235] Section 3.2 を見てください。

#@since 2.6.0
# class Net::HTTPRequestTimeout < Net::HTTPClientError
alias Net::HTTPRequestTimeOut
#@else
# class Net::HTTPRequestTimeOut < Net::HTTPClientError
#@end
HTTP レスポンス 408 (Request Timeout) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.7 を見てください。

