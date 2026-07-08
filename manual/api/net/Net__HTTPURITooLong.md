---
library: net/http
alias:
  - Net::HTTPRequestURITooLong
  - Net::HTTPRequestURITooLarge
---
# class Net::HTTPURITooLong < Net::HTTPClientError
HTTP レスポンス 414 (URI Too Large) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.12 を見てください。

