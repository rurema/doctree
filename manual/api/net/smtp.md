---
type: library
category: Network
---
メールを送信するためのプロトコル SMTP (Simple Mail Transfer Protocol)
を扱うライブラリです。

ヘッダなどメールのデータを扱うことはできません。
SMTP の実装は [RFC:2821] に基いています。

### 使用例

#### とにかくメールを送る

SMTP を使ってメールを送るにはまず SMTP.start でセッションを開きます。
第一引数がサーバのアドレスで第二引数がポート番号です。
ブロックを使うと File.open と同じように終端処理を自動的にやってくれる
のでおすすめです。

```ruby
require 'net/smtp'
Net::SMTP.start( 'smtp.example.com', 25 ) {|smtp|
  # use smtp object only in this block
}
```

smtp-server.example.com は適切な SMTP サーバのアドレスに読みかえてください。
通常は LAN の管理者やプロバイダが SMTP サーバを用意してくれているはずです。

セッションが開いたらあとは [m:Net::SMTP#send_message]
でメールを流しこむだけです。

```ruby
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
```

#### セッションを終了する

メールを送ったら [m:Net::SMTP#finish] を呼んで
セッションを終了しなければいけません。
File のように GC 時に勝手に close されることもありません。

```ruby
# using SMTP#finish
require 'net/smtp'
smtp = Net::SMTP.start('smtp.example.com', 25)
smtp.send_message mail_string, 'from@example.com', 'to@example.net'
smtp.finish
```

またブロック付きの [m:Net::SMTP.start], [m:Net::SMTP#start]
を使うと finish を呼んでくれるので便利です。
可能な限りブロック付きの start を使うのがよいでしょう。

```ruby
# using block form of SMTP.start
require 'net/smtp'
Net::SMTP.start('smtp.example.com', 25) {|smtp|
  smtp.send_message mail_string, 'from@example.com', 'to@example.net'
}
```

#### 文字列以外からの送信

ひとつ上の例では文字列リテラル (ヒアドキュメント) を使って送信しましたが、
each メソッドを持ったオブジェクトからならなんでも送ることができます。
以下は File オブジェクトから直接送信する例です。

```ruby
require 'net/smtp'

Net::SMTP.start('your.smtp.server', 25) {|smtp|
  File.open('Mail/draft/1') {|f|
    smtp.send_message f, 'from@example.com', 'to@example.net'
  }
}
```

### HELO ドメイン

SMTP ではメールを送る側のホストの名前 (HELO ドメインと呼ぶ) を要求
されます。HELO ドメインは [m:Net::SMTP.start], [m:Net::SMTP#start]
のキーワード引数 helo に指定します。
たいていの SMTP サーバはこの HELO ドメイン
による認証はあまり真面目に行わないので (簡単に偽造できるからです)
デフォルト値を用いて問題にならないことが多いのですが、セッションを切られる
こともあります。そういうときはとりあえず HELO ドメインを与えてみて
ください。もちろんそれ以外の時も HELO ドメインはちゃんと渡すのが
よいでしょう。

```ruby
require 'net/smtp'
Net::SMTP.start('smtp.example.com', 25, helo: 'yourdomain.example.com')
```

よくあるダイヤルアップホストの場合、HELO ドメインには ISP のメール
サーバのドメインを使っておけばたいてい通ります。

### SMTP認証

[c:Net::SMTP] は PLAIN, LOGIN, CRAM MD5 の3つの方法で認証できます。
(認証については [RFC:2554], [RFC:2195] を参照してください)

認証するためには、[m:Net::SMTP.start] もしくは [m:Net::SMTP#start]
の引数に追加の引数を渡してください。

```ruby
# 例
require 'net/smtp'
Net::SMTP.start('smtp.example.com', 25,
                 user: 'your_account', password: 'your_password', authtype: :cram_md5)
```

### TLSを用いたSMTP通信

[c:Net::SMTP] は [RFC:3207] に基づいた STARTTLS を用いる
方法、もしくは [RFC:8314] に基づいた方法
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

TLS を使用したい場合は enable_tls を使用します。

```ruby
require 'net/smtp'
# TLSの例
smtp = Net::SMTP.new('smtp.example.com', 465)
smtp.enable_tls
smtp.start do
  # send messages ...
end
```

サーバーが STARTTLS をサポートしている場合は自動的に STARTTLS を使用します。
サーバーが STARTTLS をサポートしているのに STARTTLS を使用したくない場合は [m:Net::SMTP#disable_starttls] を使用します。

```ruby
require 'net/smtp'
# STARTTLSを使用したくない例
smtp = Net::SMTP.new('smtp.example.com', 25)
smtp.disable_starttls
smtp.start do
  # send messages ...
end
```

デフォルトではサーバー証明書の検証を行い、正当な証明書でない場合は [c:OpenSSL::SSL::SSLError] 例外が発生します。
証明書の検証を行いたくない場合は +tls_verify: false+ を指定します。

```ruby
require 'net/smtp'
# 証明書の検証を行いたくない場合
Net::SMTP.start('192.168.1.1', 25, tls_verify: false) do |smtp|
  # send messages ...
end
```

サーバー証明書に引数で指定したホスト名が含まれていなければ [c:OpenSSL::SSL::SSLError] 例外が発生します。
証明書に含まれない名前(IPアドレス等)で接続したい場合は、+tls_hostname+ で証明書のホスト名を指定します。

```ruby
require 'net/smtp'
# 証明書と異なるホスト名で接続する場合
Net::SMTP.start('192.168.1.1', 25, tls_hostname: 'smtp.example.com') do |smtp|
  # send messages ...
end
```

