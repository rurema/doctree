---
library: net/protocol
---
# class Net::ReadTimeout < Timeout::Error
データを読み出すときにタイムアウトしたときに発生する例外です。

タイムアウトまでの時間は [m:Net::HTTP#read_timeout=]、
[m:Net::FTP#read_timeout=] などで設定します。

