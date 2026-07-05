---
library: net/http
include:
  - Net::HTTPExceptions
alias:
#@since 2.6.0
  - Net::HTTPClientException
#@end
---
# class Net::HTTPServerException < Net::ProtoServerError

HTTP ステータスコード 4xx を受け取ったという例外です。

クライアントのリクエストに誤りがあるか、サーバにリクエストを拒否さ
れた(認証が必要、リソースが存在しないなどで)ことを示します。

[c:Net::HTTPServerException] は Ruby 2.6 から deprecated になりました。
#@since 2.6.0
[c:Net::HTTPClientException] を使用してください。
#@end

