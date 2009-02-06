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
  Net::SMTP.start( 'your.smtp.server', 25 ) {|smtp|
    # use smtp object only in this block
  }

your.smtp.server は適切な SMTP サーバのアドレスに読みかえてください。
通常は LAN の管理者やプロバイダが SMTP サーバを用意してくれているはずです。

セッションが開いたらあとは [[m:Net::SMTP#send_message]]
でメールを流しこむだけです。

  require 'net/smtp'
  
  Net::SMTP.start('your.smtp.server', 25) {|smtp|
    smtp.send_message(<<-EndOfMail, 'your@mail.address', 'to@some.domain')
  From: Your Name <your@mail.address>
  To: Dest Address <to@some.domain>
  Subject: test mail
  Date: Sat, 23 Jun 2001 16:26:43 +0900
  Message-Id: <unique.message.id.string@some.domain>
  
  This is a test mail.
    EndOfMail
  }

==== セッションを終了する

メールを送ったら [[m:Net::SMTP#finish]] を呼んで
セッションを終了しなければいけません。
File のように GC 時に勝手に close されることもありません。
いろいろなところで finish がないソースコードの例を見掛けますが、
すべて誤りです。finish は必ず呼んでください。

またブロック付きの [[m:Net::SMTP.start]], [[m:Net::SMTP#start]]
を使うと finish を呼んでくれるので便利です。
可能な限りブロック付きの start を使うのがよいでしょう。

  require 'net/smtp'

  # using SMTP#finish
  smtp = Net::SMTP.start('your.smtp.server', 25)
  smtp.send_message mail_string, 'from@address', 'to@address'
  smtp.finish
  
  # using block form of SMTP.start
  Net::SMTP.start('your.smtp.server', 25) {|smtp|
    smtp.send_message mail_string, 'from@address', 'to@address'
  }

==== 文字列以外からの送信

ひとつ上の例では文字列リテラル (ヒアドキュメント) を使って送信しましたが、
each メソッドを持ったオブジェクトからならなんでも送ることができます。
以下は File オブジェクトから直接送信する例です。

  require 'net/smtp'

  Net::SMTP.start('your.smtp.server', 25) {|smtp|
    File.open('Mail/draft/1') {|f|
      smtp.send_message f, 'your@mail.address', 'to@some.domain'
    }
  }

==== HELO ドメイン

SMTP ではメールを送る側のホストの名前 (HELO ドメインと呼ぶ) を要求
されるのですが、Net::SMTP ではとりあえず localhost.localdomain と
いう名前を送信しています。たいていの SMTP サーバはこの HELO ドメイン
による認証はあまり真面目に行わないので (簡単に偽造できるからです)
問題にならないことが多いのですが、まれにメールセッションを切られる
こともあります。そういうときはとりあえず HELO ドメインを与えてみて
ください。もちろんそれ以外の時も HELO ドメインはちゃんと渡すのが
ベストです。

HELO ドメインは [[m:Net::SMTP.start]], [[m:Net::SMTP#start]]
の第三引数 helo_domain に指定します。

  Net::SMTP.start('your.smtp.server', 25, 'mail.from.domain') {|smtp|

よくあるダイヤルアップホストの場合、HELO ドメインには ISP のメール
サーバのドメインを使っておけばたいてい通ります。

=== 発生する例外

セッション中に (SMTP レベルの) エラーがおこった場合、
以下の例外が発生します。

: Net::ProtoSyntaxError
    SMTP コマンドの構文ミス (500番台)
: Net::ProtoFatalError
    恒久的なエラー (550番台)
: Net::ProtoUnknownError
    予期しないエラー。おそらくバグ
: Net::ProtoServerBusy
    一時的なエラー (420/450番台)



= class Net::SMTP < Object
#@# class alias: Net::SMTPSession

== Singleton Methods

--- new(address, port = 25)
#@todo

新しい SMTP オブジェクトを生成します。
address はSMTPサーバーのFQDNで、
port は接続するポート番号です。
ただし、このメソッドではまだ接続はしません。

--- start(address, port = 25, helo_domain = 'localhost.localdomain', account = nil, password = nil, authtype = nil)
--- start(address, port = 25, helo_domain = 'localhost.localdomain', account = nil, password = nil, authtype = nil) {|smtp| .... }
#@todo

以下と同じです。

  Net::SMTP.new(address, port).start(helo_domain, account, password, authtype)
  
Example:

  require 'net/smtp'

  Net::SMTP.start('your.smtp.server') {|smtp|
    smtp.send_message mail_string, 'from@mail.address', 'dest@mail.address'
  }

--- default_port
#@todo

The default SMTP port number, 25.

#@since 1.9.1
--- default_ssl_context
#@todo

--- default_ssl_port
#@todo

The default SMTP/SSL port number, 465.

--- default_tls_port
#@todo

The default SMTP/TLS port number, 587.

--- disable_ssl
#@todo

--- disable_tls
#@todo

--- enable_ssl(context = SMTP.default_ssl_context)
#@todo

Enable SMTP/SSL.

--- enable_tls
#@todo

--- ssl_context
#@todo

--- use_ssl?
#@todo

--- use_tls?
#@todo
#@end

== Instance Methods

--- esmtp?
#@todo

--- esmtp
--- esmtp=(bool)
#@todo

--- set_debug_output(f)
#@since 1.9.1
--- debug_output=(f)
#@todo
#@end

--- start(helo_domain = <local host name>, account = nil, password = nil, authtype = nil)
--- start(helo_domain = <local host name>, account = nil, password = nil, authtype = nil) {|smtp| .... }
#@todo

TCP コネクションを張り、同時に SMTP セッションを開始します。
そのとき、こちらのホストの FQDN を helo_domain に指定します。
もしすでにセッションが開始していたら IOError を発生します。

account と password の両方が与えられた場合、
SMTP AUTH コマンドによって認証を行います。
authtype は使用する認証のタイプで、
シンボルで :plain か :cram_md5 を指定します。

--- started?
#@todo

SMTP セッションが開始されていたら真。

--- inspect
#@todo

--- address
#@todo

接続するアドレス

--- port
#@todo

接続するポート番号

--- open_timeout
--- open_timeout=(n)
#@todo

接続時に待つ最大秒数。この秒数たってもコネクションが
開かなければ例外 TimeoutError を発生します。

--- read_timeout
--- read_timeout=(n)
#@todo

読みこみ ([[man:read(2)]] 一回) でブロックしてよい最大秒数。
この秒数たっても読みこめなければ例外 TimeoutError を発生します。

--- finish
#@todo

SMTP セッションを終了します。

セッション開始前にこのメソッドが呼ばれた場合は例外 IOError を発生します。

--- send_message(mailsrc, from_addr, *to_addrs)
--- send_mail(mailsrc, from_addr, *to_addrs)
--- sendmail(mailsrc, from_addr, *to_addrs)
#@todo

mailsrc をメールとして送信します。
mailsrc は each イテレータを持つ
オブジェクトならなんでも構いません (たとえば String や File)。

from_domain は送り主のメールアドレス ('...@...'のかたちのもの) で、
to_addrs には送信先メールアドレスを並べます。

  require 'net/smtp'

  Net::SMTP.start('your.smtp.server') {|smtp|
    smtp.send_message mail_string,
                      'from@mail.address',
                      'dest@mail.address', 'dest2@mail.address'
  }

--- open_message_stream(from_addr, *to_addrs) {|f| .... }
--- ready(from_addr, *to_addrs) {|f| .... }
#@todo

メール書きこみの準備をしたうえで、
write, print, printf, puts メソッドを持つオブジェクト f をブロックにあたえます。
from_addr は送信元メールアドレスで
to_addrs は宛先のメールボックスです。

  require 'net/smtp'

  Net::SMTP.start('your.smtp.server', 25) {|smtp|
    smtp.open_message_stream('from@mail.addr', 'dest@mail.addr') {|f|
      f.puts 'From: aamine@loveruby.net'
      f.puts 'To: someone@somedomain.org'
      f.puts 'Subject: test mail'
      f.puts
      f.puts 'This is test mail.'
    }
  }

#@since 1.9.1
--- use_ssl?
#@todo

--- use_tls?
#@todo

--- disable_ssl
#@todo

--- disable_tls
#@todo

--- enable_ssl
#@todo

--- enable_tls
#@todo

--- authenticate(user, secret, authtype)
#@todo

--- auth_plain(user, secret)
#@todo

Plain authentication.

--- auth_login(user, secret)
#@todo

Login authentication.

--- auth_cram_md5(user, secret)
#@todo

Cram-MD5 authentication.

--- starttls
#@todo

Dispatch STARTTLS command (use SMTP/TLS).

--- helo(domain)
#@todo

Dispatch HELO command (use standard SMTP).

--- ehlo(domain)
#@todo

Dispatch EHLO command (use ESMTP).

--- mailfrom(from_addr)
#@todo

Dispatch MAILFROM command.

--- rcptto_list(to_addrs)
#@todo

Dispatch multiple RCPTTO commands.

--- rcptto(to_addr)
#@todo

Dispatch RCPTTO command.

--- data(message)
--- data {|f| .... }
#@todo

Dispatch DATA command.

--- quit
#@todo

Dispatch QUIT command.
#@end

== Constants

--- Revision
#@todo

File revision.  You cannot assume any specific format.
