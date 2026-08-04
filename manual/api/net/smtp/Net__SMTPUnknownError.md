---
library: net/smtp
include:
  - Net::SMTPError
---
# class Net::SMTPUnknownError < Net::ProtoUnknownError

サーバからの応答コードが予期されていない値であった場合に対応する例外クラスです。サーバもしくはクライアントに何らかのバグがあった場合に発生します。

