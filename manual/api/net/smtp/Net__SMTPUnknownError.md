---
library: net/smtp
include:
  - Net::SMTPError
---
# class Net::SMTPUnknownError < Net::ProtoUnknownError

サーバからの応答コードが予期されていない値であった場合に
対応する例外クラスです。サーバもしくはクライアントに何らかの
バグがあった場合に発生します。

