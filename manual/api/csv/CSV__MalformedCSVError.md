---
library: csv
---
# class CSV::MalformedCSVError < RuntimeError

不正な CSV をパースしようとしたときに発生する例外です。

#%since 3.3
入力に不正なバイト列が含まれていた場合は、サブクラスの [c:CSV::InvalidEncodingError] が発生します。
#%end
