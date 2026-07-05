---
library: net/http
include:
  - Net::HTTPExceptions
---
# class Net::HTTPError < Net::ProtocolError

HTTP ステータスコード 1xx を受け取ったという例外です。
または、ステータスコードが未知のものである場合も
これに対応します。

