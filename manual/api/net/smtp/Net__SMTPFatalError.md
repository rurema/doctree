---
library: net/smtp
include:
  - Net::SMTPError
---
# class Net::SMTPFatalError < Net::ProtoFatalError

SMTP 致命的エラー(エラーコード 5xx、 ただし500除く)に対応する
例外クラスです。

