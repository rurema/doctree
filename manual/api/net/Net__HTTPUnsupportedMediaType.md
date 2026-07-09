---
library: net/http
---
# class Net::HTTPUnsupportedMediaType < Net::HTTPClientError

HTTP レスポンス 415 (Unsupported Media Type) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.13, [RFC:7694] Section 3 を見てください。

#@since 2.6.0
# class Net::HTTPRangeNotSatisfiable < Net::HTTPClientError
alias Net::HTTPRequestedRangeNotSatisfiable
#@else
# class Net::HTTPRequestedRangeNotSatisfiable < Net::HTTPClientError
#@end
HTTP レスポンス 416 (Range Not Satisfiable) を表現するクラスです。

詳しくは [RFC:7233] Section 4.4 を見てください。

