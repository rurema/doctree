---
library: openssl
---
# module OpenSSL::SSL::SocketForwarder 
to_io で返されるソケットオブジェクトにメソッドを
フォワードするモジュールです。

[c:OpenSSL::SSL::SSLSocket] や [c:OpenSSL::SSL::SSLServer] と
いったソケットの SSL ラッパクラスにソケット関連のメソッドを定義するため
に使われます。

## Instance Methods
### def addr -> Array
ラップされているソケットの接続情報を返します。

[m:IPSocket#addr] と同様です。

### def peeraddr -> Array
ラップされているソケットの接続先相手の情報を返します。

[m:IPSocket#peeraddr] と同様です。

### def setsockopt(level, optname, optval) -> 0
ラップされているソケットのオプションを設定します。

[m:BasicSocket#setsockopt] と同様です。

- **param** `level` --    [man:setsockopt(2)] の level に相当する整数を指定します
- **param** `optname` --  [man:setsockopt(2)] の option_name に相当する整数を指定します
- **param** `optval` --  設定される値を文字列で指定します。

- **raise** `Errno::EXXX` --  オプションの設定に失敗した場合発生します。

### def getsockopt(level, optname) -> String
ラップされているソケットのオプションを設定します。

[m:BasicSocket#getsockopt] と同様です。

- **param** `level` --    [man:getsockopt(2)] の 第二引数のlevel に相当する整数を指定します
- **param** `optname` --  [man:getsockopt(2)] の 第三引数のoption_name に相当する整数を指定します


### def fcntl(cmd, arg=0) -> Integer
ラップされているソケットに対してシステムコール fcntl を実行します。

[m:IO#fcntl] と同様です。

- **param** `cmd` -- IO に対するコマンドを、添付ライブラリ [lib:fcntl] が提供している定数で指定します。
- **param** `arg` -- cmd に対する引数を整数、文字列、booleanのいずれかで指定します。
- **raise** `Errno::EXXX` -- fcntl の実行に失敗した場合に発生します。
- **raise** `IOError` -- 既に close されている場合に発生します。

### def closed? -> bool
ラップされているソケットが
close していたら true を返します。

### def do_not_reverse_lookup=(bool)
真を渡すとアドレスからホスト名への逆引きを行わなくなります。

[m:BasicSocket#do_not_reverse_lookup] と同様です。

- **param** `bool` -- 真で逆引きを抑制します

