---
library: net/protocol
since: "2.0.0"
---
# class Net::OpenTimeout < Timeout::Error

コネクションを開こうとしたときにタイムアウトしたときに発生する例外です。

#%until 4.1
タイムアウトまでの時間は [m:Net::HTTP#open_timeout=]、
[m:Net::FTP#open_timeout=] などで設定します。
#%else
タイムアウトまでの時間は [m:Net::HTTP#open_timeout=] などで設定します。
#%end

# class Net::ReadTimeout < Timeout::Error

データを読み出すときにタイムアウトしたときに発生する例外です。

#%until 4.1
タイムアウトまでの時間は [m:Net::HTTP#read_timeout=]、
[m:Net::FTP#read_timeout=] などで設定します。
#%else
タイムアウトまでの時間は [m:Net::HTTP#read_timeout=] などで設定します。
#%end

