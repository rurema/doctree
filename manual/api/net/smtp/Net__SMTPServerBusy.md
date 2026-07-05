---
library: net/smtp
include:
  - Net::SMTPError
---
# class Net::SMTPServerBusy < Net::ProtoServerError

SMTP 一時エラーに対応する例外クラスです。
SMTP エラーコード 420, 450 に対応します。

