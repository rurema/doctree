---
library: net/http
---
# class Net::HTTPPreconditionFailed < Net::HTTPClientError
HTTP レスポンス 412 (Precondition Failed) を表現するクラスです。

詳しくは [RFC:7232] Section 4.2, [RFC:8144] Section 3.2 を見てください。

#@since 2.6.0
# class Net::HTTPPayloadTooLarge < Net::HTTPClientError
alias Net::HTTPRequestEntityTooLarge
#@else
# class Net::HTTPRequestEntityTooLarge < Net::HTTPClientError
#@end
HTTP レスポンス 413 (Payload Too Large) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.11 を見てください。

#@since 2.6.0
# class Net::HTTPURITooLong < Net::HTTPClientError
alias Net::HTTPRequestURITooLong
#@else
# class Net::HTTPRequestURITooLong < Net::HTTPClientError
#@end
alias Net::HTTPRequestURITooLarge
HTTP レスポンス 414 (URI Too Large) を表現するクラスです。

詳しくは [RFC:7231] Section 6.5.12 を見てください。

