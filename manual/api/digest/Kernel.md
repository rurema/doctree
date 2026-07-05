---
library: digest
---
# reopen Kernel
## Private Instance Methods
### def Digest(name) -> object

"MD5"や"SHA1"などのダイジェストを示す文字列 name を指定し、
対応するダイジェストのクラスを取得します。

#@since 2.2.0
このメソッドはスレッドセーフです。マルチスレッド環境で
[c:Digest::MD5]などを直接呼び出すと問題があるときはこのメソッドを使
うか、起動時に使用するライブラリを [m:Kernel?.require] してください。
#@end

- **param** `name` -- "MD5"や"SHA1"などのダイジェストを示す文字列を指定します。
- **return** -- Digest::MD5やDigest::SHA1などの対応するダイジェストのクラスを返します。インスタンスではなく、クラスを返します。注意してください。

例: Digest::MD、Digest::SHA1、Digest::SHA512のクラス名を順番に出力する。

`````
require 'digest'
for a in ["MD5", "SHA1", "SHA512"]
  p Digest(a) # => Digest::MD5, Digest::SHA1, Digest::SHA512
end
`````
