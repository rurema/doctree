---
library: net/protocol
since: "2.6.0"
---
# class Net::WriteTimeout < Timeout::Error

データを書き込むときにタイムアウトしたときに発生する例外です。

タイムアウトまでの時間は [m:Net::HTTP#write_timeout=]、
[m:Net::FTP#write_timeout=] などで設定します。
