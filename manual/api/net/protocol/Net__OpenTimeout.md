---
library: net/protocol
---
# class Net::OpenTimeout < Timeout::Error
コネクションを開こうとしたときにタイムアウトしたときに発生する例外です。

タイムアウトまでの時間は [m:Net::HTTP#open_timeout=]、
[m:Net::FTP#open_timeout=] などで設定します。

