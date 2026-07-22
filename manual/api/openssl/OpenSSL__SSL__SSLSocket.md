---
library: openssl
include:
  - Enumerable
  - OpenSSL::SSL::SocketForwarder
  - OpenSSL::Buffering
---
# class OpenSSL::SSL::SSLSocket < Object

ソケットをラップして SSL での認証と暗号通信を実現するためのクラスです。

### 例

SSL/TLS サーバに接続して write します。

```ruby
require 'socket'
require 'openssl'
include OpenSSL
  
ctx = SSL::SSLContext.new
ctx.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER, verify_hostname: true)
  
soc = TCPSocket.new('www.example.com', 443)
ssl = SSL::SSLSocket.new(soc, ctx)
ssl.hostname = 'www.example.com' # SNI
ssl.connect
ssl.post_connection_check('www.example.com')
raise "verification error" if ssl.verify_result != OpenSSL::X509::V_OK
print ssl.peer_cert.to_text
  
# HTTP リクエストを送信
ssl.write("GET / HTTP/1.1\r\n")
ssl.write("Host: www.example.com\r\n")
ssl.write("Connection: close\r\n")
ssl.write("\r\n")
print ssl.read
  
ssl.close
soc.close
```

## Class Methods

### def new(socket) -> OpenSSL::SSL::SSLSocket
### def new(socket, context) -> OpenSSL::SSL::SSLSocket

socket をラップして SSLSocket オブジェクトを生成します。

socket には ラップする [c:TCPSocket] オブジェクトを与え、
context には SSL の設定情報を所持している
[c:OpenSSL::SSL::SSLContext] オブジェクトを与えます。

context を省略した場合は [m:OpenSSL::SSL::SSLContext.new] で
新たにコンテキストを生成してそれを用います。

- **param** `socket` -- ラップするソケット
- **param** `context` -- SSL の設定情報を持つ SSL コンテキストオブジェクト
- **raise** `OpenSSL::SSL::SSLError` -- オブジェクトの生成に失敗した場合に発生します

## Instance Methods

### def io -> IO
### def to_io -> IO

SSLSocket オブジェクトを生成する時に渡されたソケットを返します。

- **SEE** [m:OpenSSL::SSL::SSLSocket.new]

### def context -> OpenSSL::SSL::SSLContext

SSLSocket オブジェクトを生成する時に渡されたコンテクストを返します。

- **SEE** [m:OpenSSL::SSL::SSLSocket.new]

### def sync_close -> bool

SSLSocket を close するときにラップしているソケットも close するかどうかを
返します。

true でソケットも close します。

### def sync_close=(bool)

SSLSocket を close するときにラップしているソケットも close するかどうかを
設定します。

true でソケットも close するようになります。

- **param** `bool` -- 設定する真偽値

### def cert -> OpenSSL::X509::Certificate | nil

自分自身を証明する証明書を返します。

自分自身を証明する証明書を使わなかった場合は nil を返します。
[m:OpenSSL::SSL::SSLSocket#connect] や [m:OpenSSL::SSL::SSLSocket#accept] 
で SSL/TLS ハンドシェイクを行う前にこのメソッドを呼んだ
場合も nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLContext#cert]

### def peer_cert -> OpenSSL::X509::Certificate | nil

接続相手の証明書オブジェクトを返します。

[m:OpenSSL::SSL::SSLSocket#connect] や [m:OpenSSL::SSL::SSLSocket#accept] 
で SSL/TLS ハンドシェイクを行う前にこのメソッドを呼ぶと nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLSocket#peer_cert_chain]

### def peer_cert_chain -> [OpenSSL::X509::Certificate] | nil

接続相手の証明書チェインを [c:OpenSSL::X509::Certificate] オブジェクト
の配列で返します。

[m:OpenSSL::SSL::SSLSocket#connect] や [m:OpenSSL::SSL::SSLSocket#accept] 
で SSL/TLS ハンドシェイクを行う前にこのメソッドを呼ぶと nil を返します。

以下の順の配列を返します。

```text
[接続相手の証明書, 下位CAの証明書,... 中間CAの証明書]
```

ルート CA の証明書は含まれないことに注意してください。

- **SEE** [m:OpenSSL::SSL::SSLSocket#peer_cert]

### def state -> String

現在の状態をアルファベット 6 文字の文字列で返します。

### def cipher -> [String, String, Integer, Integer]

現在実際に使われている暗号の情報を配列で返します。

返される配列の形式は以下の例のように [暗号名, TLS/SSLのバージョン, 鍵長, アルゴリズムで使われる bit 数] となります。

```text
["DES-CBC3-SHA", "TLSv1/SSLv3", 168, 168]
```

[m:OpenSSL::SSL::SSLSocket#connect] や [m:OpenSSL::SSL::SSLSocket#accept] 
で SSL/TLS ハンドシェイクを行う前にこのメソッドを呼ぶと nil を返します。

### def pending -> Integer | nil

OpenSSL内部のバッファが保持している、直ちに読み取り可能な
データのバイト数を返します。

ハンドシェイク開始前には nil を返します。

### def accept -> self

TLS/SSL 通信をサーバモードとして開始し、クライアントからの
ハンドシェイク開始を待ち、クライアントとのハンドシェイクを実行します。

- **raise** `OpenSSL::SSL::SSLError` -- ハンドシェイクに失敗した(VERIFY_PEER で
       証明書の検証に失敗した場合や、プロトコル合意に失敗したなど)
       場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLSocket#connect],
     [m:OpenSSL::SSL::SSLSocket#accept_nonblock]

### def connect -> self

TLS/SSl 通信をクライアントモードとして開始し、
サーバとのハンドシェイクを実行します。

- **raise** `OpenSSL::SSL::SSLError` -- ハンドシェイクに失敗した(VERIFY_PEER で
       証明書の検証に失敗した場合や、プロトコル合意に失敗したなど)
       場合に発生します
- **SEE** [m:OpenSSL::SSL::SSLSocket#accept],
     [m:OpenSSL::SSL::SSLSocket#connect_nonblock]

### def post_connection_check(hostname) -> true

接続後検証を行います。

検証に成功した場合は true を返し、失敗した場合は例外 
[c:OpenSSL::SSL::SSLError] を発生させます。

OpenSSL の API では、
[m:OpenSSL::SSL::SSLSocket#connect] や [m:OpenSSL::SSL::SSLSocket#accept] 
での検証は実用的には不完全です。
CA が証明書に署名してそれが失効していないことしか確認しません。
実用上は証明書に記載されている事項を見て、接続先が妥当であるかを確認する
必要があります。通常は接続先ホストの FQDN と証明書に記載されている FQDN が
一致しているかどうかを調べます。このメソッドはその FQDN のチェックを行ないます。

- **param** `hostname` -- チェックする FQDN の文字列
- **raise** `OpenSSL::SSL::SSLError` -- チェックに失敗した場合に発生します

### def sysclose -> nil

接続を閉じます。相手に'close notify'を送ります。

このメソッドは openssl ライブラリ内で管理しているバッファを
フラッシュせずに接続を閉じます。そのため、通常は
これではなく [m:OpenSSL::Buffering#close] を呼ぶべきです。

[m:OpenSSL::SSL::SSLSocket#sync_close] が真である場合は
このメソッドを呼びだした時点で自身が保持しているソケット
を同時に閉じます。

### def sysread(length, buf=nil) -> String

データをバッファを経由せずに暗号化通信路から読み込み、
読み込んだデータを文字列で返します。

基本的にはこのメソッドは使わず、[c:OpenSSL::Buffering] の
メソッドを使ってデータを読み込むべきです。

length で読み込むバイト数を指定します。

bufに文字列を指定するとその文字列のメモリ領域にデータを直接書き込み、
その String オブジェクトを返します。

[m:IO#sysread] と同様です。

- **param** `length` -- 読み込むバイト数を指定します
- **param** `buf` -- データを書き込むバッファ
- **raise** `EOFError` -- 入力が終端に逹した場合に発生します
- **raise** `OpenSSL::SSL::SSLError` -- 読み込みに失敗した場合に発生します

### def syswrite(string) -> Integer

データをバッファを経由せずに暗号化通信路に書き込みます。

書き込んだバイト数を整数で返します。

基本的にはこのメソッドは使わず、[c:OpenSSL::Buffering] の
メソッドを使ってデータを書き込むべきです。

[m:IO#syswrite] と同様です。

- **param** `string` -- 書き込むデータ文字列
- **raise** `OpenSSL::SSL::SSLError` -- 書き込みに失敗した場合に発生します

### def accept_nonblock -> self

ノンブロッキング方式で
TLS/SSL 通信をサーバモードとして開始し、
クライアントとのハンドシェイクを実行します。

IO が読み込み待ち、もしくは書き込み待ちになった場合は例外を
発生させ、ハンドシェイクを中断します。IO が読み込み/書き込み
可能状態になってからこのメソッドをもう一度呼ぶと
ハンドシェイクを再開します。

- **raise** `OpenSSL::SSL::SSLError` -- ハンドシェイクに失敗した(VERIFY_PEER で
       証明書の検証に失敗した場合や、プロトコル合意に失敗したなど)
       場合に発生します
       (実際は [m:OpenSSL::SSL::SSLError] をこのモジュールで extend した
       例外オブジェクトが生成されます)
- **raise** `OpenSSL::SSL::SSLError` -- ソケットが読み込み/書き込み可能状態になるのを
       待つ必要がある場合に発生します。
       読み込み可能状態を待つ必要がある場合には [c:IO::WaitReadable] を、
       書き込み可能状態を待つ必要がある場合には [c:IO::WaitWritable] を、
       それぞれ extend した例外オブジェクトが生成されます。
- **SEE** [m:OpenSSL::SSL::SSLSocket#connect_nonblock],
     [m:OpenSSL::SSL::SSLSocket#accept]

### def connect_nonblock -> self

ノンブロッキング方式で
TLS/SSL 通信をクライアントモードとして開始し、
サーバとのハンドシェイクを実行します。

IO が読み込み待ち、もしくは書き込み待ちになった場合は例外を
発生させ、ハンドシェイクを中断します。IO が読み込み/書き込み
可能状態になってからこのメソッドをもう一度呼ぶと
ハンドシェイクを再開します。

- **raise** `OpenSSL::SSL::SSLError` -- ハンドシェイクに失敗した(VERIFY_PEER で
       証明書の検証に失敗した場合や、プロトコル合意に失敗したなど)
       場合に発生します
- **raise** `OpenSSL::SSL::SSLError` -- ソケットが読み込み/書き込み可能状態になるのを
       待つ必要がある場合に発生します。
       読み込み可能状態を待つ必要がある場合には [c:IO::WaitReadable] を、
       書き込み可能状態を待つ必要がある場合には [c:IO::WaitWritable] を、
       それぞれ extend した例外オブジェクトが生成されます。
- **SEE** [m:OpenSSL::SSL::SSLSocket#accept_nonblock],
     [m:OpenSSL::SSL::SSLSocket#connect]

### def hostname -> String | nil

TLS の Server Name Indication 拡張で利用するサーバのホスト名を返します。

[m:OpenSSL::SSL::SSLSocket#hostname=] で設定した値がそのまま返されます。

設定していない場合は nil を返します。

- **SEE** [m:OpenSSL::SSL::SSLSocket#hostname=]

### def hostname=(hostname)

TLS の Server Name Indication(SNI) 拡張で利用するサーバのホスト名を設定します。

Server Name Indication については [RFC:3546] を参照してください。

このメソッドはハンドシェイク時にクライアント側がサーバ側に
サーバのホスト名を伝えるために用います。そのため、
クライアント側が [m:OpenSSL::SSL::SSLSocket#connect] を呼ぶ前に
このメソッドでホスト名を指定する必要があります。

hostname に nil を渡すと SNI 拡張を利用しません。

サーバ側については [m:OpenSSL::SSL::SSLContext#servername_cb=] を
参照してください。

- **param** `hostname` -- ホスト名文字列
- **SEE** [m:OpenSSL::SSL::SSLSocket#hostname],
     [m:OpenSSL::SSL::SSLContext#servername_cb],
     [m:OpenSSL::SSL::SSLContext#servername_cb=]

### def session -> OpenSSL::SSL::Session

利用している SSL セッションを [c:OpenSSL::SSL::Session]
オブジェクトで返します。

- **SEE** [m:OpenSSL::SSL::SSLSocket#session=],
     [m:OpenSSL::SSL::SSLSocket#session_reused?]

### def session=(sess)

ハンドシェイクで再利用する SSL セッションを
設定します。

このメソッドはクライアント側でのみ有用です。
セッションを再利用する場合は、
[m:OpenSSL::SSL::SSLSocket#connect] を呼ぶ前に
このメソッドでセッションオブジェクト
([c:OpenSSL::SSL::Session] のインスタンス)
を設定します。

サーバ側の場合 [c:OpenSSL::SSL::SSLContext] がキャッシュの保持と
管理を行います。

- **param** `sess` -- 設定するセッション
- **SEE** [m:OpenSSL::SSL::SSLSocket#session],
     [m:OpenSSL::SSL::SSLSocket#session_reused?]

### def session_reused? -> bool

利用している SSL セッションが再利用されたものである
場合に真を返します。

- **SEE** [c:OpenSSL::SSL::Session],
     [m:OpenSSL::SSL::SSLSocket#session],
     [m:OpenSSL::SSL::SSLSocket#session=]

### def verify_result -> Integer

検証結果のエラーコードを整数値で返します。

エラーコードの整数値は [c:OpenSSL::X509] に定数が定義されています。
詳しくは [ref:c:OpenSSL::X509#verify_error] を見てください。
検証に成功した場合は [m:OpenSSL::X509::V_OK] を返します。

