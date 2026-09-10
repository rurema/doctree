---
library: openssl
---
# module OpenSSL::SSL::SocketForwarder

to_io で返されるソケットオブジェクトにメソッドをフォワードするモジュールです。

[c:OpenSSL::SSL::SSLSocket] や [c:OpenSSL::SSL::SSLServer] といったソケットの SSL ラッパクラスにソケット関連のメソッドを定義するために使われます。

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

### def fileno -> Integer

ラップされているソケットのファイル記述子を表す整数を返します。

[m:IO#fileno] と同様です。

#%since 3.4
### def close_on_exec=(bool)

ラップされているソケットに close-on-exec フラグを設定します。

[m:IO#close_on_exec=] と同様です。

- **param** `bool` -- 設定する close-on-exec フラグを true か false で指定します

#%end

#%since 3.4
### def close_on_exec? -> bool

ラップされているソケットに close-on-exec フラグが設定されていれば true を返します。

[m:IO#close_on_exec?] と同様です。

#%end

#%since 3.4
### def local_address -> Addrinfo

ラップされているソケットのローカルアドレス情報を [c:Addrinfo] オブジェクトとして返します。

[m:BasicSocket#local_address] と同様です。

#%end

#%since 3.4
### def remote_address -> Addrinfo

ラップされているソケットの接続先相手のアドレス情報を [c:Addrinfo] オブジェクトとして返します。

[m:BasicSocket#remote_address] と同様です。

#%end

#%since 3.4
### def timeout -> Numeric | nil
### def timeout=(numeric)

ラップされているソケットに設定されている入出力のタイムアウトを秒単位で取得・設定します。

[m:IO#timeout], [m:IO#timeout=] と同様です。

- **param** `numeric` -- タイムアウトの秒数。nil を指定するとタイムアウトを解除します

#%end

#%since 3.4
### def wait(events, timeout = nil) -> Integer | nil
### def wait(timeout = nil) -> bool | self | nil
### def wait_readable(timeout = nil) -> bool | self | nil

ラップされているソケットが指定したイベント(省略時は読み込み可能)の状態になるまでブロックします。

引数はそのまま [m:IO#wait] と [m:IO#wait_readable] に渡されます。返り値もそれらと同じです。

- **param** `events` -- 待つイベントを [m:IO#wait] と同じ形式で指定します
- **param** `timeout` -- タイムアウトまでの秒数を指定します

#%end

#%since 3.4
### def wait_writable(timeout = nil) -> self | nil

ラップされているソケットが書き込み可能になるまでブロックします。

引数はそのまま [m:IO#wait_writable] に渡されます。返り値も同じです。

- **param** `timeout` -- タイムアウトまでの秒数を指定します

#%end

