---
library: net/http
include:
  - Net::HTTPExceptions
---
# class Net::HTTPRetriableError < Net::ProtoRetriableError

HTTP ステータスコード 3xx を受け取ったという例外です。

リソースが移動したなどの理由により、リクエストを完了させるには更な
るアクションが必要になります。

