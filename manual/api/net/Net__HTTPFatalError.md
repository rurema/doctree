---
library: net/http
include:
  - Net::HTTPExceptions
---
# class Net::HTTPFatalError < Net::ProtoFatalError

HTTP ステータスコード 5xx を受け取ったという例外です。

サーバがエラーを起こしているなど、サーバ側で処理を完了できないことを表しています。

