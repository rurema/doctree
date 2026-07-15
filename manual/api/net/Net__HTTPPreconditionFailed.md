---
library: net/http
---
# class Net::HTTPPreconditionFailed < Net::HTTPClientError
HTTP レスポンス 412 (Precondition Failed) を表現するクラスです。

詳しくは [RFC:7232] Section 4.2, [RFC:8144] Section 3.2 を見てください。

# class Net::HTTPPayloadTooLarge < Net::HTTPClientError
alias Net::HTTPRequestEntityTooLarge
HTTP レスポンス 413 (Payload Too Large) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.11 を見てください。

# class Net::HTTPURITooLong < Net::HTTPClientError
alias Net::HTTPRequestURITooLong
alias Net::HTTPRequestURITooLarge
HTTP レスポンス 414 (URI Too Large) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.12 を見てください。

