---
library: net/smtp
alias:
  - Net::SMTPSession
---
# class Net::SMTP < Object

SMTP のセッションを表現したクラスです。


## Singleton Methods

### def new(address, port = Net::SMTP.default_port) -> Net::SMTP
新しい SMTP オブジェクトを生成します。
address はSMTPサーバーのFQDNで、
port は接続するポート番号です。
ただし、このメソッドではまだTCPの接続はしません。
[m:Net::SMTP#start] で接続します。

オブジェクトの生成と接続を同時にしたい場合には
[m:Net::SMTP.start] を代わりに使ってください。

- **param** `address` -- 接続先のSMTPサーバの文字列
- **param** `port` -- 接続ポート番号

- **SEE** [m:Net::SMTP.start], [m:Net::SMTP#start]

#@until 1.9.1
### def start(address, port = Net::SMTP.default_port, helo = 'localhost.localdomain', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
### def start(address, port = Net::SMTP.default_port, helo = 'localhost.localdomain', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@else
#@since 3.0
### def start(address, port = Net::SMTP.default_port, tls_verify: true, tls_hostname: nil, helo: 'localhost', user: nil, password: nil, authtype: DEFAULT_AUTH_TYPE) -> Net::SMTP
### def start(address, port = Net::SMTP.default_port, tls_verify: true, tls_hostname: nil, helo: 'localhost', user: nil, password: nil, authtype: DEFAULT_AUTH_TYPE) {|smtp| ... } -> object
#@end
### def start(address, port = Net::SMTP.default_port, helo = 'localhost', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
### def start(address, port = Net::SMTP.default_port, helo = 'localhost', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@end

新しい SMTP オブジェクトを生成し、サーバに接続し、セッションを開始します。


以下と同じです。

#@until 3.0.0
`````
require 'net/smtp'
Net::SMTP.new(address, port).start(helo, user, password, authtype)
`````
#@else
`````
require 'net/smtp'
Net::SMTP.new(address, port).start(helo: helo, user: user, password: password, authtype: authtype)
`````
#@end

このメソッドにブロックを与えた場合には、新しく作られた [c:Net::SMTP] オブジェクト
を引数としてそのブロックを呼び、ブロック終了時に自動的に接続を閉じます。
ブロックを与えなかった場合には新しく作られた [c:Net::SMTP] オブジェクトが
返されます。この場合終了時に [m:Net::SMTP#finish] を呼ぶのは利用者の責任と
なります。

user と password の両方が与えられた場合、
SMTP AUTH コマンドによって認証を行います。
authtype は使用する認証のタイプで、
シンボルで :plain, :login, :cram_md5 を指定します。

Example:

`````
require 'net/smtp'

Net::SMTP.start('smtp.example.com') {|smtp|
  smtp.send_message mail_string, 'from@example.jp', 'to@example.jp'
}
`````

- **param** `address` -- 接続するサーバをホスト名もしくはIPアドレスで指定します
- **param** `port` -- ポート番号、デフォルトは 25 です
- **param** `tls_verify` -- サーバー証明書を検証するか否か
- **param** `tls_hostname` -- サーバー証明書のホスト名
- **param** `helo` -- HELO で名乗るドメイン名です
- **param** `user` -- 認証で使うアカウント名
- **param** `password` -- 認証で使うパスワード
- **param** `authtype` -- 認証の種類(:plain, :login, :cram_md5 のいずれか)

- **raise** `TimeoutError` -- 接続時にタイムアウトした場合に発生します
- **raise** `Net::SMTPUnsupportedCommand` -- TLSをサポートしていないサーバでTLSを使おうとした場合に発生します
- **raise** `Net::SMTPServerBusy` -- SMTPエラーコード420,450の場合に発生します
- **raise** `Net::SMTPSyntaxError` -- SMTPエラーコード500の場合に発生します
- **raise** `Net::SMTPFatalError` -- SMTPエラーコード5xxの場合に発生します

- **SEE** [m:Net::SMTP#start], [m:Net::SMTP.new]
### def default_port -> Integer
SMTPのデフォルトのポート番号(25)を返します。

### def default_submission_port -> Integer
デフォルトのサブミッションポート番号(587)を返します。

### def default_ssl_context -> OpenSSL::SSL::SSLContext
SSL 通信に使われる SSL のコンテキストのデフォルト値を返します。

### def default_tls_port -> Integer
### def default_ssl_port -> Integer
デフォルトのSMTPSのポート番号(465)を返します。


## Instance Methods

### def esmtp? -> bool
### def esmtp -> bool
その Net::SMTP オブジェクトが ESMTP を使う場合に真を返します。
デフォルトは真です。

- **SEE** [m:Net::SMTP#esmtp=]

### def esmtp=(bool)
その Net::SMTP オブジェクトが ESMTP を使うかどうかを指定します。

この指定は [m:Net::SMTP#start] を呼ぶ前にする必要があります。
ESMTPモードで [m:Net::SMTP#start] を呼び、うまくいかなかった
場合には 普通の SMTP モードに切り替えてやりなおします
(逆はしません)。


- **SEE** [m:Net::SMTP#esmtp?]

### def capable_starttls? -> bool
サーバが STARTTLS を広告してきた場合に真を返します。

このメソッドは [m:Net::SMTP#start] などでセッションを開始
した以降にしか正しい値を返しません。


### def capable_cram_md5_auth? -> bool
サーバが AUTH CRAM-MD5 を広告してきた場合に真を返します。

このメソッドは [m:Net::SMTP#start] などでセッションを開始
した以降にしか正しい値を返しません。


### def capable_login_auth? -> bool
サーバが AUTH LOGIN を広告してきた場合に真を返します。

このメソッドは [m:Net::SMTP#start] などでセッションを開始
した以降にしか正しい値を返しません。

### def capable_plain_auth? -> bool
サーバが AUTH PLAIN を広告してきた場合に真を返します。

このメソッドは [m:Net::SMTP#start] などでセッションを開始
した以降にしか正しい値を返しません。

### def capable_auth_types -> [String]
接続したサーバで利用可能な認証を配列で返します。

返り値の配列の要素は、 'PLAIN', 'LOGIN', 'CRAM-MD5' です。

このメソッドは [m:Net::SMTP#start] などでセッションを開始
した以降にしか正しい値を返しません。

### def tls? -> bool
### def ssl? -> bool
その Net::SMTP オブジェクトが SMTPS を利用するならば真を返します。

- **SEE** [m:Net::SMTP#enable_tls], [m:Net::SMTP#disable_tls], [m:Net::SMTP#start]

### def enable_ssl(context = Net::SMTP.default_ssl_context) -> ()
### def enable_tls(context = Net::SMTP.default_ssl_context) -> ()
その Net::SMTP オブジェクトが SMTPS を利用するよう設定します。

このメソッドは [m:Net::SMTP#start] を呼ぶ前に呼ぶ必要があります。

- **param** `context` -- SSL接続で利用する [c:OpenSSL::SSL::SSLContext] 

- **SEE** [m:Net::SMTP#tls?], [m:Net::SMTP#disable_tls]
### def disable_ssl -> ()
### def disable_tls -> ()

その Net::SMTP オブジェクトが SMTPS を利用しないよう設定します。

- **SEE** [m:Net::SMTP#disable_tls], [m:Net::SMTP#tls?]

### def starttls? -> Symbol/nil
その Net::SMTP オブジェクトが STARTTLSを利用するかどうかを返します。

常に利用する(利用できないときは [m:Net::SMTP#start] で例外 
[c:Net::SMTPUnsupportedCommand] を発生) するときは :always を、
利用可能な場合のみ利用する場合は :auto を、
常に利用しない場合には nil を返します。

- **SEE** [m:Net::SMTP#start]

### def starttls_always? -> bool
その Net::SMTP オブジェクトが 常にSTARTTLSを利用する
(利用できない場合には例外を発生する)ならば
真を返します。

- **SEE** [m:Net::SMTP#starttls?], [m:Net::SMTP#starttls_auto?], [m:Net::SMTP#enable_starttls]

### def starttls_auto? -> bool
その Net::SMTP オブジェクトが利用可能な場合にのみにSTARTTLSを利用するならば
真を返します。

- **SEE** [m:Net::SMTP#starttls?], [m:Net::SMTP#starttls_always?], [m:Net::SMTP#enable_starttls_auto]

### def enable_starttls(context = Net::SMTP.default_ssl_context) -> ()
その Net::SMTP オブジェクトが 常にSTARTTLSを利用する
(利用できない場合には例外を発生する)ように設定します。

- **param** `context` -- SSL接続で利用する [c:OpenSSL::SSL::SSLContext] 
- **SEE** [m:Net::SMTP#starttls?], [m:Net::SMTP#starttls_always?], [m:Net::SMTP#enable_starttls_auto]

### def enable_starttls_auto(context = Net::SMTP.default_ssl_context) -> ()
その Net::SMTP オブジェクトがSTARTTLSが利用可能な場合
(つまりサーバがSTARTTLSを広告した場合)のみにSTARTTLSを利用する
ように設定します。

- **SEE** [m:Net::SMTP#starttls?], [m:Net::SMTP#starttls_auto?], [m:Net::SMTP#enable_starttls_auto]
- **param** `context` -- SSL接続で利用する [c:OpenSSL::SSL::SSLContext] 
- **SEE** [m:Net::SMTP#starttls?], [m:Net::SMTP#starttls_auto?], [m:Net::SMTP#enable_starttls]

### def disable_starttls -> ()
その Net::SMTP オブジェクトがSTARTTLSを常に使わないよう設定します。

- **SEE** [m:Net::SMTP#starttls?], [m:Net::SMTP#enable_starttls], [m:Net::SMTP#enable_starttls_auto]

### def set_debug_output(f) -> ()
### def debug_output=(f)
デバッグ出力の出力先を指定します。
このメソッドは深刻なセキュリティホールの原因となりえます。
デバッグ用にのみ利用してください。

- **param** `f` -- デバッグ出力先を [c:IO] (もしくは << というメソッドを持つクラス)で指定します

#@until 1.9.1
### def start(helo = 'localhost.localdomain', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
### def start(helo = 'localhost.localdomain', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@else
#@since 3.0
### def start(helo: 'localhost', user: nil, password: nil, authtype: DEFAULT_AUTH_TYPE) -> Net::SMTP
### def start(helo: 'localhost', user: nil, password: nil, authtype: DEFAULT_AUTH_TYPE) {|smtp| ... } -> object
#@end
### def start(helo = 'localhost', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
### def start(helo = 'localhost', user = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@end
サーバにコネクションを張り、同時に SMTP セッションを開始します。

もしすでにセッションが開始していたら IOError が発生します。

user と password の両方が与えられた場合、
SMTP AUTH コマンドによって認証を行います。
authtype は使用する認証のタイプで、
シンボルで :plain, :login, :cram_md5 を指定します。

このメソッドにブロックを与えた場合には、そのオブジェクト
を引数としてそのブロックを呼び、ブロック終了時に自動的に接続を閉じます。
ブロックを与えなかった場合には自分自身を返します。
この場合終了時に [m:Net::SMTP#finish] を呼ぶのは利用者の責任と
なります。

- **param** `helo` -- HELO で名乗るドメイン名です
- **param** `user` -- 認証で使うアカウント名
- **param** `password` -- 認証で使うパスワード
- **param** `authtype` -- 認証の種類(:plain, :login, :cram_md5 のいずれか)

- **raise** `IOError` -- すでにセッションを開始している場合に発生します
- **raise** `TimeoutError` -- 接続がタイムアウトした場合に発生します
- **raise** `Net::SMTPUnsupportedCommand` -- STARTTLSをサポートしていないサーバでSTARTTLSを利用しようとした場合に発生します
- **raise** `Net::SMTPServerBusy` -- SMTPエラーコード420,450の場合に発生します
- **raise** `Net::SMTPSyntaxError` -- SMTPエラーコード500の場合に発生します
- **raise** `Net::SMTPFatalError` -- SMTPエラーコード5xxの場合に発生します

### def started? -> bool
SMTP セッションが開始されていたら真を返します。

セッションがまだ開始していない、もしくは終了している場合には偽を返します。

- **SEE** [m:Net::SMTP#start], [m:Net::SMTP#finish]

### def inspect -> String
- **SEE** [m:Object#inspect]

### def address -> String

接続先のアドレスを返します。

### def port -> Integer

接続先のポート番号を返します。

### def open_timeout -> Integer

接続時に待つ最大秒数を返します。

デフォルトは30(秒)です。
この秒数たってもコネクションが
開かなければ例外 TimeoutError を発生します。

- **SEE** [m:Net::SMTP#open_timeout=]

### def open_timeout=(n)

接続時に待つ最大秒数を設定します。

- **SEE** [m:Net::SMTP#open_timeout]

### def read_timeout -> Integer
読みこみ ([man:read(2)] 一回) でブロックしてよい最大秒数を返します。

デフォルトは60(秒)です。
この秒数たっても読みこめなければ例外 TimeoutError を発生します。

- **SEE** [m:Net::SMTP#read_timeout=]
### def read_timeout=(n)
読み込みでブロックしてよい最大秒数を設定します。

- **SEE** [m:Net::SMTP#read_timeout]
### def finish -> ()
SMTP セッションを終了します。

- **raise** `IOError` -- セッション開始前にこのメソッドが呼ばれた場合に発生します

- **SEE** [m:Net::SMTP#start]

### def send_message(mailsrc, from_addr, *to_addrs) -> ()
### def send_mail(mailsrc, from_addr, *to_addrs) -> ()
### def sendmail(mailsrc, from_addr, *to_addrs) -> ()

メールを送信します。

mailsrc をメールとして送信します。
mailsrc は each イテレータを持つ
オブジェクトならなんでも構いません(たとえば String や File)。

from_domain は送り主のメールアドレス ('...@...'のかたち) 、
to_addrs には送信先メールアドレスを文字列で渡します。

`````
require 'net/smtp'

Net::SMTP.start('smtp.example.com') {|smtp|
  smtp.send_message mail_string,
                    'from@example.com',
                    'to1@example.net', 'to2@example.net'
}
`````

sendmail は obsolete です。

- **param** `mailsrc` -- メールの内容
- **param** `from_addr` -- 送信元のメールアドレス
- **param** `to_addrs` -- 送信先のメールアドレス(複数可、少なくとも1個)

- **raise** `IOError` -- すでにセッションが終了している場合に発生します
- **raise** `TimeoutError` -- 接続がタイムアウトした場合に発生します
- **raise** `Net::SMTPServerBusy` -- SMTPエラーコード420,450の場合に発生します
- **raise** `Net::SMTPSyntaxError` -- SMTPエラーコード500の場合に発生します
- **raise** `Net::SMTPFatalError` -- SMTPエラーコード5xxの場合に発生します
- **raise** `Net::SMTPUnknownError` -- SMTPエラーコードがプロトコル上不正な場合に発生します

### def open_message_stream(from_addr, *to_addrs) {|f| .... } -> ()
### def ready(from_addr, *to_addrs) {|f| .... } -> ()
メール書き込みの準備をし、書き込み先のストリームオブジェクトを
ブロックに渡します。ブロック終了後、書きこんだ結果が
送られます。

渡されるストリームオブジェクトは以下のメソッドを持っています。
  - puts(str = '') strを出力して CR LFを出力
  - print(str)     strを出力
  - printf(fmt, *args)   sprintf(fmt,*args) を出力
  - write(str)::         str を出力して書き込んだバイト数を返す
  - <<(str)::            str を出力してストリームオブジェクト自身を返す

from_domain は送り主のメールアドレス ('...@...'のかたち) 、
to_addrs には送信先メールアドレスを文字列で渡します。

`````
require 'net/smtp'

Net::SMTP.start('smtp.example.com', 25) {|smtp|
  smtp.open_message_stream('from@example.com', 'to@example.net') {|f|
    f.puts 'From: from@example.com'
    f.puts 'To: to@example.net'
    f.puts 'Subject: test mail'
    f.puts
    f.puts 'This is test mail.'
  }
}
`````

ready は obsolete です。

- **param** `from_addr` -- 送信元のメールアドレス
- **param** `to_addrs` -- 送信先のメールアドレス(複数可、少なくとも1個)

- **raise** `IOError` -- すでにセッションが終了している場合に発生します
- **raise** `TimeoutError` -- 接続がタイムアウトした場合に発生します
- **raise** `Net::SMTPServerBusy` -- SMTPエラーコード420,450の場合に発生します
- **raise** `Net::SMTPSyntaxError` -- SMTPエラーコード500の場合に発生します
- **raise** `Net::SMTPFatalError` -- SMTPエラーコード5xxの場合に発生します
- **raise** `Net::SMTPAuthenticationError` -- 送信に必要な認証を行っていなかった場合に発生します
- **raise** `Net::SMTPUnknownError` -- SMTPエラーコードがプロトコル上不正な場合に発生します

- **SEE** [m:Net::SMTP#send_message]


### def authenticate(user, secret, authtype) -> ()
認証を行います。

このメソッドはセッション開始([m:Net::SMTP#start])後、
メールを送る前に呼びだしてください。

通常は [m:Net::SMTP.start] や [m:Net::SMTP#start] で認証を
行うためこれを利用する必要はないはずです。

- **param** `user` -- 認証で使うアカウント名
- **param** `secret` -- 認証で使うパスワード
- **param** `authtype` -- 認証の種類(:plain, :login, :cram_md5 のいずれか)

- **SEE** [m:Net::SMTP.start], [m:Net::SMTP#start], [m:Net::SMTP#auth_plain], [m:Net::SMTP#auth_login], [m:Net::SMTP#auth_cram_md5]

### def auth_plain(user, secret) -> ()
PLAIN 認証を行います。

このメソッドはセッション開始([m:Net::SMTP#start])後、
メールを送る前に呼びだしてください。

通常は [m:Net::SMTP.start] や [m:Net::SMTP#start] で認証を
行うためこれを利用する必要はないはずです。

- **param** `user` -- 認証で使うアカウント名
- **param** `secret` -- 認証で使うパスワード

### def auth_login(user, secret) -> ()
LOGIN 認証を行います。

このメソッドはセッション開始([m:Net::SMTP#start])後、
メールを送る前に呼びだしてください。

通常は [m:Net::SMTP.start] や [m:Net::SMTP#start] で認証を
行うためこれを利用する必要はないはずです。

- **param** `user` -- 認証で使うアカウント名
- **param** `secret` -- 認証で使うパスワード


### def auth_cram_md5(user, secret) -> ()
CRAM-MD5 認証を行います。

このメソッドはセッション開始([m:Net::SMTP#start])後、
メールを送る前に呼びだしてください。

通常は [m:Net::SMTP.start] や [m:Net::SMTP#start] で認証を
行うためこれを利用する必要はないはずです。

- **param** `user` -- 認証で使うアカウント名
- **param** `secret` -- 認証で使うパスワード

#@since 2.1.0
### def rset -> Net::SMTP::Response
RSET コマンドを送ります。

#@end

### def starttls -> Net::SMTP::Response
STARTTLS コマンドを送ります。

通常は [m:Net::SMTP#start] で STARTTLS が送られるため
利用する必要はないはずです。

### def helo(domain) -> Net::SMTP::Response
HELO コマンドを送ります(標準的な SMTP を使います)。

通常は [m:Net::SMTP.start], [m:Net::SMTP#start] で HELO が
送られるため利用する必要はないはずです。


- **param** `domain` -- HELOで送るドメイン名

### def ehlo(domain) -> Net::SMTP::Response
EHLO コマンドを送ります(ESMTP を使います)。

通常は [m:Net::SMTP.start], [m:Net::SMTP#start] で EHLO が
送られるため利用する必要はないはずです。

- **param** `domain` -- EHLOで送るドメイン名

### def mailfrom(from_addr) -> Net::SMTP::Response
MAILFROM コマンドを送ります。

通常は [m:Net::SMTP#send_message], [m:Net::SMTP#open_message_stream] で
MAILFROM が送られるため利用する必要はないはずです。

- **param** `from_addr` -- 送信元メールアドレス

#@until 1.9.1
### def rcptto_list(to_addrs) -> ()
#@else
### def rcptto_list(to_addrs){ ... } -> object
#@end
RCPTTO コマンドを to_addrs のすべてのメールアドレスに対して送ります。

#@since 1.9.1
コマンドを送った後、ブロックを呼び出します。
このメソッドの返り値はブロックの返り値になります。
#@end

通常は [m:Net::SMTP#send_message], [m:Net::SMTP#open_message_stream] で
RCPTTO が送られるため利用する必要はないはずです。

- **param** `to_addrs` -- 送信先メールアドレスの配列

### def rcptto(to_addr) -> Net::SMTP::Response
RCPTTO コマンドを送ります。

通常は [m:Net::SMTP#send_message], [m:Net::SMTP#open_message_stream] で
RCPTTO が送られるため利用する必要はないはずです。

- **param** `to_addr` -- 送信先メールアドレス

### def data(message) -> Net::SMTP::Response
### def data {|f| .... } -> Net::SMTP::Response
DATA コマンドを送ります。

文字列を引数に与えた場合はそれを本文として送ります。
ブロックを与えた場合にはそのブロックにストリームオブジェクトが渡されます
([m:Net::SMTP#open_message_stream]参考)。

通常は [m:Net::SMTP#send_message], [m:Net::SMTP#open_message_stream] で
DATA が送られるため利用する必要はないはずです。

- **param** `message` -- メールの本文

### def quit -> Net::SMTP::Response
QUIT コマンドを送ります。

通常は [m:Net::SMTP#finish] で
QUIT が送られるため利用する必要はないはずです。


## Constants

### const DEFAULT_AUTH_TYPE -> Symbol
デフォルトの認証スキーム(:plain)です。

#@# internal constants for CRAM-MD5 authentication
#@# --- IMASK
#@# --- OMASK
#@# --- CRAM_BUFSIZE

### const Revision -> String
ファイルのリビジョンです。使わないでください。

