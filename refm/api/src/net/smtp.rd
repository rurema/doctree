category Network

メールを送信するためのプロトコル SMTP (Simple Mail Transfer Protocol)
を扱うライブラリです。

ヘッダなどメールのデータを扱うことはできません。
SMTP の実装は [[RFC:2821]] に基いています。

=== 使用例

==== とにかくメールを送る

SMTP を使ってメールを送るにはまず SMTP.start でセッションを開きます。
第一引数がサーバのアドレスで第二引数がポート番号です。
ブロックを使うと File.open と同じように終端処理を自動的にやってくれる
のでおすすめです。

  require 'net/smtp'
  Net::SMTP.start( 'smtp.example.com', 25 ) {|smtp|
    # use smtp object only in this block
  }

smtp-server.example.com は適切な SMTP サーバのアドレスに読みかえてください。
通常は LAN の管理者やプロバイダが SMTP サーバを用意してくれているはずです。

セッションが開いたらあとは [[m:Net::SMTP#send_message]]
でメールを流しこむだけです。

  require 'net/smtp'
  
  Net::SMTP.start('smtp.example.com', 25) {|smtp|
    smtp.send_message(<<-EndOfMail, 'from@example.com', 'to@example.net')
  From: Your Name <from@example.com>
  To: Dest Address <to@example.net>
  Subject: test mail
  Date: Sat, 23 Jun 2001 16:26:43 +0900
  Message-Id: <unique.message.id.string@yourhost.example.com>
  
  This is a test mail.
    EndOfMail
  }

==== セッションを終了する

メールを送ったら [[m:Net::SMTP#finish]] を呼んで
セッションを終了しなければいけません。
File のように GC 時に勝手に close されることもありません。

  # using SMTP#finish
  require 'net/smtp'
  smtp = Net::SMTP.start('smtp.example.com', 25)
  smtp.send_message mail_string, 'from@example.com', 'to@example.net'
  smtp.finish

またブロック付きの [[m:Net::SMTP.start]], [[m:Net::SMTP#start]]
を使うと finish を呼んでくれるので便利です。
可能な限りブロック付きの start を使うのがよいでしょう。

  # using block form of SMTP.start
  require 'net/smtp'
  Net::SMTP.start('smtp.example.com', 25) {|smtp|
    smtp.send_message mail_string, 'from@example.com', 'to@example.net'
  }

==== 文字列以外からの送信

ひとつ上の例では文字列リテラル (ヒアドキュメント) を使って送信しましたが、
each メソッドを持ったオブジェクトからならなんでも送ることができます。
以下は File オブジェクトから直接送信する例です。

  require 'net/smtp'

  Net::SMTP.start('your.smtp.server', 25) {|smtp|
    File.open('Mail/draft/1') {|f|
      smtp.send_message f, 'from@example.com', 'to@example.net'
    }
  }

=== HELO ドメイン

SMTP ではメールを送る側のホストの名前 (HELO ドメインと呼ぶ) を要求
されます。HELO ドメインは [[m:Net::SMTP.start]], [[m:Net::SMTP#start]]
の第三引数 helo_domain に指定します。
たいていの SMTP サーバはこの HELO ドメイン
による認証はあまり真面目に行わないので (簡単に偽造できるからです)
デフォルト値を用いて問題にならないことが多いのですが、セッションを切られる
こともあります。そういうときはとりあえず HELO ドメインを与えてみて
ください。もちろんそれ以外の時も HELO ドメインはちゃんと渡すのが
よいでしょう。

  Net::SMTP.start('smtp.example.com', 25, 'yourdomain.example.com') {|smtp|

よくあるダイヤルアップホストの場合、HELO ドメインには ISP のメール
サーバのドメインを使っておけばたいてい通ります。

=== SMTP認証

[[c:Net::SMTP]] は PLAIN, LOGIN, CRAM MD5 の3つの方法で認証をすることができます。
(認証については [[RFC:2554]], [[RFC:2195]] を参照してください)

認証するためには、[[m:Net::SMTP.start]] もしくは [[m:Net::SMTP#start]]
の引数に追加の引数を渡してください。

  # 例
  Net::SMTP.start('smtp.example.com', 25, 'yourdomain.example.com',
                  'your_account', 'your_password', :cram_md5)

=== TLSを用いたSMTP通信
[[c:Net::SMTP]] は [[RFC:3207]] に基づいた STARTTLS を用いる
方法、もしくは SMTPS と呼ばれる非標準的な方法
(ポート465を用い、通信全体をTLSで包む)
によるメール送信の暗号化が可能です。

この2つは排他で、同時に利用できません。

TLSを用いることで、通信相手の認証、および通信経路の暗号化ができます。
ただし、現在のメール送信の仕組みとして、あるサーバから別のサーバへの
中継を行うことがあります。そこでの通信が認証されているか否か、暗号化され
ているか否かはこの仕組みの範囲外であり、なんらかの保証があるわけでは
ないことに注意してください。メールそのものの暗号化や、メールを
送る人、受け取る人を認証する
必要がある場合は別の方法を考える必要があるでしょう。

  # STARTTLSの例
  smtp = Net::SMTP.new('smtp.example.com', 25)
  # SSLのコンテキストを作成してSSLの設定をし、context に代入しておく
  # TLSを常に使うようにする
  smtp.enable_starttls(context)
  smtp.start() do
    # send messages ...
  end
= class Net::SMTP < Object
alias Net::SMTPSession

SMTP のセッションを表現したクラスです。


== Singleton Methods

--- new(address, port = Net::SMTP.default_port) -> Net::SMTP
新しい SMTP オブジェクトを生成します。
address はSMTPサーバーのFQDNで、
port は接続するポート番号です。
ただし、このメソッドではまだTCPの接続はしません。
[[m:Net::SMTP#start]] で接続します。

オブジェクトの生成と接続を同時にしたい場合には
[[m:Net::SMTP.start]] を代わりに使ってください。

@param address 接続先のSMTPサーバの文字列
@param port 接続ポート番号

@see [[m:Net::SMTP.start]], [[m:Net::SMTP#start]]

#@until 1.9.1
--- start(address, port = Net::SMTP.default_port, helo_domain = 'localhost.localdomain', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
--- start(address, port = Net::SMTP.default_port, helo_domain = 'localhost.localdomain', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@else
--- start(address, port = Net::SMTP.default_port, helo_domain = 'localhost', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
--- start(address, port = Net::SMTP.default_port, helo_domain = 'localhost', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@end

新しい SMTP オブジェクトを生成し、サーバに接続し、セッションを開始します。


以下と同じです。

  Net::SMTP.new(address, port).start(helo_domain, account, password, authtype)

このメソッドにブロックを与えた場合には、新しく作られた [[c:Net::SMTP]] オブジェクト
を引数としてそのブロックを呼び、ブロック終了時に自動的に接続を閉じます。
ブロックを与えなかった場合には新しく作られた [[c:Net::SMTP]] オブジェクトが
返されます。この場合終了時に [[m:Net::SMTP#finish]] を呼ぶのは利用者の責任と
なります。

account と password の両方が与えられた場合、
SMTP AUTH コマンドによって認証を行います。
authtype は使用する認証のタイプで、
シンボルで :plain, :login, :cram_md5 を指定します。

Example:

  require 'net/smtp'

  Net::SMTP.start('smtp.example.com') {|smtp|
    smtp.send_message mail_string, 'from@example.jp', 'to@example.jp'
  }

@param address 接続するサーバをホスト名もしくはIPアドレスで指定します
@param port ポート番号、デフォルトは 25 です
@param helo_domain HELO で名乗るドメイン名です
@param account 認証で使うアカウント名
@param password 認証で使うパスワード
@param authtype 認証の種類(:plain, :login, :cram_md5 のいずれか)

@raise TimeoutError 接続時にタイムアウトした場合に発生します
@raise Net::SMTPUnsupportedCommand TLSをサポートしていないサーバでTLSを使おうとした場合に発生します
@raise Net::SMTPServerBusy SMTPエラーコード420,450の場合に発生します
@raise Net::SMTPSyntaxError SMTPエラーコード500の場合に発生します
@raise Net::SMTPFatalError SMTPエラーコード5xxの場合に発生します

@see [[m:Net::SMTP#start]], [[m:Net::SMTP.new]]
--- default_port -> Integer
SMTPのデフォルトのポート番号(25)を返します。

#@since 1.8.7
--- default_submission_port -> Integer
デフォルトのサブミッションポート番号(587)を返します。

--- default_ssl_context -> OpenSSL::SSL::SSLContext
SSL 通信に使われる SSL のコンテキストのデフォルト値を返します。

--- default_tls_port -> Integer
--- default_ssl_port -> Integer
デフォルトのSMTPSのポート番号(465)を返します。

#@end

== Instance Methods

--- esmtp? -> bool
--- esmtp -> bool
その Net::SMTP オブジェクトが ESMTP を使う場合に真を返します。
デフォルトは真です。

@see [[m:Net::SMTP#esmtp=]]

--- esmtp=(bool)
その Net::SMTP オブジェクトが ESMTP を使うかどうかを指定します。

この指定は [[m:Net::SMTP#start]] を呼ぶ前にする必要があります。
ESMTPモードで [[m:Net::SMTP#start]] を呼び、うまくいかなかった
場合には 普通の SMTP モードに切り替えてやりなおします
(逆はしません)。


@see [[m:Net::SMTP#esmtp?]]

#@since 1.8.7
--- capable_starttls? -> bool
サーバが STARTTLS を広告してきた場合に真を返します。

このメソッドは [[m:Net::SMTP#start]] などでセッションを開始
した以降にしか正しい値を返しません。


--- capable_cram_md5_auth? -> bool
サーバが AUTH CRAM-MD5 を広告してきた場合に真を返します。

このメソッドは [[m:Net::SMTP#start]] などでセッションを開始
した以降にしか正しい値を返しません。


--- capable_login_auth? -> bool
サーバが AUTH LOGIN を広告してきた場合に真を返します。

このメソッドは [[m:Net::SMTP#start]] などでセッションを開始
した以降にしか正しい値を返しません。

--- capable_plain_auth? -> bool
サーバが AUTH PLAIN を広告してきた場合に真を返します。

このメソッドは [[m:Net::SMTP#start]] などでセッションを開始
した以降にしか正しい値を返しません。

--- capable_auth_types -> [String]
接続したサーバで利用可能な認証を配列で返します。

返り値の配列の要素は、 'PLAIN', 'LOGIN', 'CRAM-MD5' です。

このメソッドは [[m:Net::SMTP#start]] などでセッションを開始
した以降にしか正しい値を返しません。

--- tls? -> bool
--- ssl? -> bool
その Net::SMTP オブジェクトが SMTPS を利用するならば真を返します。

@see [[m:Net::SMTP#enable_tls]], [[m:Net::SMTP#disable_tls]], [[m:Net::SMTP#start]]

--- enable_ssl(context = Net::SMTP.default_ssl_context) -> ()
--- enable_tls(context = Net::SMTP.default_ssl_context) -> ()
その Net::SMTP オブジェクトが SMTPS を利用するよう設定します。

このメソッドは [[m:Net::SMTP#start]] を呼ぶ前に呼ぶ必要があります。

@param context SSL接続で利用する [[c:OpenSSL::SSL::SSLContext]] 

@see [[m:Net::SMTP#tls?]], [[m:Net::SMTP#disable_tls]]
--- disable_ssl -> ()
--- disable_tls -> ()

その Net::SMTP オブジェクトが SMTPS を利用しないよう設定します。

@see [[m:Net::SMTP#disable_tls]], [[m:Net::SMTP#tls?]]

--- starttls? -> Symbol/nil
その Net::SMTP オブジェクトが STARTTLSを利用するかどうかを返します。

常に利用する(利用できないときは [[m:Net::SMTP#start]] で例外 
[[c:Net::SMTPUnsupportedCommand]] を発生) するときは :always を、
利用可能な場合のみ利用する場合は :auto を、
常に利用しない場合には nil を返します。

@see [[m:Net::SMTP#start]]

--- starttls_always? -> bool
その Net::SMTP オブジェクトが 常にSTARTTLSを利用する
(利用できない場合には例外を発生する)ならば
真を返します。

@see [[m:Net::SMTP#starttls?]], [[m:Net::SMTP#starttls_auto?]], [[m:Net::SMTP#enable_starttls]]

--- starttls_auto? -> bool
その Net::SMTP オブジェクトが利用可能な場合にのみにSTARTTLSを利用するならば
真を返します。

@see [[m:Net::SMTP#starttls?]], [[m:Net::SMTP#starttls_always?]], [[m:Net::SMTP#enable_starttls_auto]]

--- enable_starttls(context = Net::SMTP.default_ssl_context) -> ()
その Net::SMTP オブジェクトが 常にSTARTTLSを利用する
(利用できない場合には例外を発生する)ように設定します。

@param context SSL接続で利用する [[c:OpenSSL::SSL::SSLContext]] 
@see [[m:Net::SMTP#starttls?]], [[m:Net::SMTP#starttls_always?]], [[m:Net::SMTP#enable_starttls_auto]]

--- enable_starttls_auto(context = Net::SMTP.default_ssl_context) -> ()
その Net::SMTP オブジェクトがSTARTTLSが利用可能な場合
(つまりサーバがSTARTTLSを広告した場合)のみにSTARTTLSを利用する
ように設定します。

@see [[m:Net::SMTP#starttls?]], [[m:Net::SMTP#starttls_auto?]], [[m:Net::SMTP#enable_starttls_auto]]
@param context SSL接続で利用する [[c:OpenSSL::SSL::SSLContext]] 
@see [[m:Net::SMTP#starttls?]], [[m:Net::SMTP#starttls_auto?]], [[m:Net::SMTP#enable_starttls]]

--- disable_starttls -> ()
その Net::SMTP オブジェクトがSTARTTLSを常に使わないよう設定します。

@see [[m:Net::SMTP#starttls?]], [[m:Net::SMTP#enable_starttls]], [[m:Net::SMTP#enable_starttls_auto]]
#@end

--- set_debug_output(f) -> ()
#@since 1.8.7
--- debug_output=(f)
#@end
デバッグ出力の出力先を指定します。
このメソッドは深刻なセキュリティホールの原因となりえます。
デバッグ用にのみ利用してください。

@param f デバッグ出力先を [[c:IO]] (もしくは << というメソッドを持つクラス)で指定します

#@until 1.9.1
--- start(helo_domain = 'localhost.localdomain', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
--- start(helo_domain = 'localhost.localdomain', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@else
--- start(helo_domain = 'localhost', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) -> Net::SMTP
--- start(helo_domain = 'localhost', account = nil, password = nil, authtype = DEFAULT_AUTH_TYPE) {|smtp| .... } -> object
#@end
サーバにコネクションを張り、同時に SMTP セッションを開始します。

もしすでにセッションが開始していたら IOError が発生します。

account と password の両方が与えられた場合、
SMTP AUTH コマンドによって認証を行います。
authtype は使用する認証のタイプで、
シンボルで :plain, :login, :cram_md5 を指定します。

このメソッドにブロックを与えた場合には、そのオブジェクト
を引数としてそのブロックを呼び、ブロック終了時に自動的に接続を閉じます。
ブロックを与えなかった場合には自分自身を返します。
この場合終了時に [[m:Net::SMTP#finish]] を呼ぶのは利用者の責任と
なります。

@param helo_domain HELO で名乗るドメイン名です
@param account 認証で使うアカウント名
@param password 認証で使うパスワード
@param authtype 認証の種類(:plain, :login, :cram_md5 のいずれか)

@raise IOError すでにセッションを開始している場合に発生します
@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::SMTPUnsupportedCommand STARTTLSをサポートしていないサーバでSTARTTLSを利用しようとした場合に発生します
@raise Net::SMTPServerBusy SMTPエラーコード420,450の場合に発生します
@raise Net::SMTPSyntaxError SMTPエラーコード500の場合に発生します
@raise Net::SMTPFatalError SMTPエラーコード5xxの場合に発生します

--- started? -> bool
SMTP セッションが開始されていたら真を返します。

セッションがまだ開始していない、もしくは終了している場合には偽を返します。

@see [[m:Net::SMTP#start]], [[m:Net::SMTP#finish]]

--- inspect -> String
@see [[m:Object#inspect]]

--- address -> String

接続先のアドレスを返します。

--- port -> Integer

接続先のポート番号を返します。

--- open_timeout -> Integer

接続時に待つ最大秒数を返します。

デフォルトは30(秒)です。
この秒数たってもコネクションが
開かなければ例外 TimeoutError を発生します。

@see [[m:Net::SMTP#open_timeout=]]

--- open_timeout=(n)

接続時に待つ最大秒数を設定します。

@see [[m:Net::SMTP#open_timeout]]

--- read_timeout -> Integer
読みこみ ([[man:read(2)]] 一回) でブロックしてよい最大秒数を返します。

デフォルトは60(秒)です。
この秒数たっても読みこめなければ例外 TimeoutError を発生します。

@see [[m:Net::SMTP#read_timeout=]]
--- read_timeout=(n)
読み込みでブロックしてよい最大秒数を設定します。

@see [[m:Net::SMTP#read_timeout]]
--- finish -> ()
SMTP セッションを終了します。

@raise IOError セッション開始前にこのメソッドが呼ばれた場合に発生します

@see [[m:Net::SMTP#start]]

--- send_message(mailsrc, from_addr, *to_addrs) -> ()
--- send_mail(mailsrc, from_addr, *to_addrs) -> ()
--- sendmail(mailsrc, from_addr, *to_addrs) -> ()

メールを送信します。

mailsrc をメールとして送信します。
mailsrc は each イテレータを持つ
オブジェクトならなんでも構いません(たとえば String や File)。

from_domain は送り主のメールアドレス ('...@...'のかたち) 、
to_addrs には送信先メールアドレスを文字列で渡します。

  require 'net/smtp'

  Net::SMTP.start('smtp.example.com') {|smtp|
    smtp.send_message mail_string,
                      'from@example.com',
                      'to1@example.net', 'to2@example.net'
  }

sendmail は obsolete です。

@param mailsrc メールの内容
@param from_addr 送信元のメールアドレス
@param to_addrs 送信先のメールアドレス(複数可、少なくとも1個)

@raise IOError すでにセッションが終了している場合に発生します
@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::SMTPServerBusy SMTPエラーコード420,450の場合に発生します
@raise Net::SMTPSyntaxError SMTPエラーコード500の場合に発生します
@raise Net::SMTPFatalError SMTPエラーコード5xxの場合に発生します
@raise Net::SMTPUnknownError SMTPエラーコードがプロトコル上不正な場合に発生します

--- open_message_stream(from_addr, *to_addrs) {|f| .... } -> ()
--- ready(from_addr, *to_addrs) {|f| .... } -> ()
メール書き込みの準備をし、書き込み先のストリームオブジェクトを
ブロックに渡します。ブロック終了後、書きこんだ結果が
送られます。

渡されるストリームオブジェクトは以下のメソッドを持っています。
  * puts(str = '') strを出力して CR LFを出力
  * print(str)     strを出力
  * printf(fmt, *args)   sprintf(fmt,*args) を出力
  * write(str)::         str を出力して書き込んだバイト数を返す
  * <<(str)::            str を出力してストリームオブジェクト自身を返す

from_domain は送り主のメールアドレス ('...@...'のかたち) 、
to_addrs には送信先メールアドレスを文字列で渡します。

  require 'net/smtp'

  Net::SMTP.start('smtp.exmaple.com', 25) {|smtp|
    smtp.open_message_stream('from@example.com', 'to@example.net') {|f|
      f.puts 'From: from@example.com'
      f.puts 'To: to@example.net'
      f.puts 'Subject: test mail'
      f.puts
      f.puts 'This is test mail.'
    }
  }

ready は obsolete です。

@param from_addr 送信元のメールアドレス
@param to_addrs 送信先のメールアドレス(複数可、少なくとも1個)

@raise IOError すでにセッションが終了している場合に発生します
@raise TimeoutError 接続がタイムアウトした場合に発生します
@raise Net::SMTPServerBusy SMTPエラーコード420,450の場合に発生します
@raise Net::SMTPSyntaxError SMTPエラーコード500の場合に発生します
@raise Net::SMTPFatalError SMTPエラーコード5xxの場合に発生します
@raise Net::SMTPAuthenticationError 送信に必要な認証を行っていなかった場合に発生します
@raise Net::SMTPUnknownError SMTPエラーコードがプロトコル上不正な場合に発生します

@see [[m:Net::SMTP#send_message]]

#@since 1.8.7

--- authenticate(user, secret, authtype) -> ()
認証を行います。

このメソッドはセッション開始([[m:Net::SMTP#start]])後、
メールを送る前に呼びだしてください。

通常は [[m:Net::SMTP.start]] や [[m:Net::SMTP#start]] で認証を
行うためこれを利用する必要はないはずです。

@param user 認証で使うアカウント名
@param secret 認証で使うパスワード
@param authtype 認証の種類(:plain, :login, :cram_md5 のいずれか)

@see [[m:Net::SMTP.start]], [[m:Net::SMTP#start]], [[m:Net::SMTP#auth_plain]], [[m:Net::SMTP#auth_login]], [[m:Net::SMTP#auth_cram_md5]]

--- auth_plain(user, secret) -> ()
PLAIN 認証を行います。

このメソッドはセッション開始([[m:Net::SMTP#start]])後、
メールを送る前に呼びだしてください。

通常は [[m:Net::SMTP.start]] や [[m:Net::SMTP#start]] で認証を
行うためこれを利用する必要はないはずです。

@param user 認証で使うアカウント名
@param secret 認証で使うパスワード

--- auth_login(user, secret) -> ()
LOGIN 認証を行います。

このメソッドはセッション開始([[m:Net::SMTP#start]])後、
メールを送る前に呼びだしてください。

通常は [[m:Net::SMTP.start]] や [[m:Net::SMTP#start]] で認証を
行うためこれを利用する必要はないはずです。

@param user 認証で使うアカウント名
@param secret 認証で使うパスワード


--- auth_cram_md5(user, secret) -> ()
CRAM-MD5 認証を行います。

このメソッドはセッション開始([[m:Net::SMTP#start]])後、
メールを送る前に呼びだしてください。

通常は [[m:Net::SMTP.start]] や [[m:Net::SMTP#start]] で認証を
行うためこれを利用する必要はないはずです。

@param user 認証で使うアカウント名
@param secret 認証で使うパスワード

--- starttls -> Net::SMTP::Response
STARTTLS コマンドを送ります。

通常は [[m:Net::SMTP#start]] で STARTTLS が送られるため
利用する必要はないはずです。

--- helo(domain) -> Net::SMTP::Response
HELO コマンドを送ります(標準的な SMTP を使います)。

通常は [[m:Net::SMTP.start]], [[m:Net::SMTP#start]] で HELO が
送られるため利用する必要はないはずです。


@param domain HELOで送るドメイン名

--- ehlo(domain) -> Net::SMTP::Response
EHLO コマンドを送ります(ESMTP を使います)。

通常は [[m:Net::SMTP.start]], [[m:Net::SMTP#start]] で EHLO が
送られるため利用する必要はないはずです。

@param domain EHLOで送るドメイン名

--- mailfrom(from_addr) -> Net::SMTP::Response
MAILFROM コマンドを送ります。

通常は [[m:Net::SMTP#send_message]], [[m:Net::SMTP#open_message_stream]] で
MAILFROM が送られるため利用する必要はないはずです。

@param from_addr 送信元メールアドレス

--- rcptto_list(to_addrs){ ... } -> object
RCPTTO コマンドを to_addrs のすべてのメールアドレスに対して送ります。

コマンドを送った後、ブロックを呼び出します。
このメソッドの返り値はブロックの返り値になります。

通常は [[m:Net::SMTP#send_message]], [[m:Net::SMTP#open_message_stream]] で
RCPTTO が送られるため利用する必要はないはずです。

@param to_addrs 送信先メールアドレスの配列

--- rcptto(to_addr) -> Net::SMTP::Response
RCPTTO コマンドを送ります。

通常は [[m:Net::SMTP#send_message]], [[m:Net::SMTP#open_message_stream]] で
RCPTTO が送られるため利用する必要はないはずです。

@param to_addr 送信先メールアドレス

--- data(message) -> Net::SMTP::Response
--- data {|f| .... } -> Net::SMTP::Response
DATA コマンドを送ります。

文字列を引数に与えた場合はそれを本文として送ります。
ブロックを与えた場合にはそのブロックにストリームオブジェクトが渡されます
([[m:Net::SMTP#open_message_stream]]参考)。

通常は [[m:Net::SMTP#send_message]], [[m:Net::SMTP#open_message_stream]] で
DATA が送られるため利用する必要はないはずです。

@param message メールの本文

--- quit -> Net::SMTP::Response
QUIT コマンドを送ります。

通常は [[m:Net::SMTP#finish]] で
QUIT が送られるため利用する必要はないはずです。

#@end

== Constants

#@since 1.8.7
--- DEFAULT_AUTH_TYPE -> Symbol
デフォルトの認証スキーム(:plain)です。
#@end

#@# internal constants for CRAM-MD5 authentication
#@# --- IMASK
#@# --- OMASK
#@# --- CRAM_BUFSIZE

--- Revision -> String
ファイルのリビジョンです。使わないでください。

#@since 1.8.7
= class Net::SMTP::Response < Object
[[c:Net::SMTP]] の内部用クラスです。
#@end

= module Net::SMTPError
SMTP 関連の例外に include されるモジュールです。

= class Net::SMTPAuthenticationError < Net::ProtoAuthError
include Net::SMTPError

SMTP 認証エラー(エラーコード 530)に対応する例外クラスです。

= class Net::SMTPServerBusy < Net::ProtoServerError
include Net::SMTPError

SMTP 一時エラーに対応する例外クラスです。
SMTP エラーコード 420, 450 に対応します。

= class Net::SMTPSyntaxError < Net::ProtoSyntaxError
include Net::SMTPError

SMTP コマンド文法エラー(エラーコード 500) に対応する
例外クラスです。

= class Net::SMTPFatalError < Net::ProtoFatalError
include Net::SMTPError

SMTP 致命的エラー(エラーコード 5xx、 ただし500除く)に対応する
例外クラスです。

= class Net::SMTPUnknownError < Net::ProtoUnknownError
include Net::SMTPError

サーバからの応答コードが予期されていない値であった場合に
対応する例外クラスです。サーバもしくはクライアントに何らかの
バグがあった場合に発生します。


= class Net::SMTPUnsupportedCommand < Net::ProtocolError
include Net::SMTPError

サーバで利用できないコマンドを送ろうとした時に発生する
例外のクラスです。

