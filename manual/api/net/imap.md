---
type: library
category: Network
---
このライブラリは Internet Message Access Protocol (IMAP) のクライアントライブラリです。[RFC:2060] を元に実装されています。

### IMAP の概要

IMAPを利用するには、まずサーバに接続し、
[m:Net::IMAP#authenticate] もしくは
[m:Net::IMAP#login] で認証します。
IMAP ではメールボックスという概念が重要です。
メールボックスは階層的な名前を持ちます。
各メールボックスはメールを保持できます。
メールボックスの実装はサーバソフトウェアによって異なります。
Unixシステムでは、ディレクトリ階層上のファイルを個々のメールボックスとみなして実装されることが多いです。

メールボックス内のメッセージ(メール)を処理する場合、まず [m:Net::IMAP#select] もしくは
[m:Net::IMAP#examine] で処理対象のメールボックスを指定する必要があります。これらの操作が成功したならば、「selected」状態に移行し、そのメールボックスが「処理対象の」メールボックスとなります。このようにしてメールボックスを選択してから、selected状態を終える(別のメールボックスを選択したり、接続を終了したり)までをセッションと呼びます。

メッセージには2種類の識別子が存在します。message sequence number と
UID です。

message sequence number はメールボックス内の各メッセージに1から順に振られた番号です。セッション中に処理対象のメールボックスに新たなメッセージが追加された場合、そのメッセージの
message sequence number は最後のメッセージの message sequence number+1となります。
メッセージをメールボックスから消した場合には、連番の穴を埋めるように
message sequence number が付け替えられます。

一方、UID はセッションを越えて恒久的に保持されます。
あるメールボックス内の異なる2つのメッセージが同じ  UID
を持つことはありません。
これは、メッセージがメールボックスから削除された後でも成立します。

しかし、UID はメールボックス内で昇順であることが規格上要請されているので、
IMAP を使わないメールアプリケーションがメールの順番を変えてしまった場合は、UID が振り直されます。

### 例

デフォルトのメールボックス(INBOX)の送り元とサブジェクトを表示する。

```ruby
require 'net/imap'

imap = Net::IMAP.new('mail.example.com')
imap.authenticate('LOGIN', 'joe_user', 'joes_password')
imap.examine('INBOX')
imap.search(["RECENT"]).each do |message_id|
  envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
  puts "#{envelope.from[0].name}: \t#{envelope.subject}"
end
```

2003年4月のメールをすべて Mail/sent-mail から "Mail/sent-apr03" へ移動させる

```ruby
require 'net/imap'

imap = Net::IMAP.new('mail.example.com')
imap.authenticate('LOGIN', 'joe_user', 'joes_password')
imap.select('Mail/sent-mail')
if not imap.list('Mail/', 'sent-apr03')
  imap.create('Mail/sent-apr03')
end
imap.search(["BEFORE", "30-Apr-2003", "SINCE", "1-Apr-2003"]).each do |message_id|
  imap.copy(message_id, "Mail/sent-apr03")
  imap.store(message_id, "+FLAGS", [:Deleted])
end
imap.expunge
```

### スレッド安全性

Net::IMAP は並列実行をサポートしています。例として、

```ruby
require 'net/imap'

imap = Net::IMAP.new("imap.foo.net", "imap2")
imap.authenticate("cram-md5", "bar", "password")
imap.select("inbox")
fetch_thread = Thread.start { imap.fetch(1..-1, "UID") }
search_result = imap.search(["BODY", "hello"])
fetch_result = fetch_thread.value
imap.disconnect
```

とすると FETCH コマンドと SEARCH コマンドを並列に実行します。

### エラーについて

IMAP サーバは以下の3種類のエラーを送ります。

- **`NO`**:
  コマンドが正常に完了しなかったことを意味します。
  例えば、ログインでのユーザ名/パスワードが間違っていた、選択したメールボックスが存在しない、などです。

- **`BAD`**:
  クライアントからのリクエストをサーバが理解できなかったことを意味します。
  クライアントの現在の状態では使えないコマンドを使おうとした場合にも発生します。例えば、
  selected状態(SELECT/EXAMINEでこの状態に移行する)にならずに
  SEARCH コマンドを使おうとした場合に発生します。
  サーバの内部エラー(ディスクが壊れたなど)の場合もこのエラーが発生します。

- **`BYE`**:
  サーバが接続を切ろうとしていることを意味します。
  これは通常のログアウト処理で発生します。
  また、ログイン時にサーバが(なんらかの理由で)接続したくない場合にも発生します。
  それ以外では、サーバがシャットダウンする場合かサーバがタイムアウトする場合に発生します。

これらのエラーはそれぞれ
  - [c:Net::IMAP::NoResponseError]
  - [c:Net::IMAP::BadResponseError]
  - [c:Net::IMAP::ByeResponseError]
という例外クラスに対応しています。
原理的には、これらの例外はサーバにコマンドを送った場合には常に発生する可能性があります。しかし、このドキュメントではよくあるエラーのみ解説します。

IMAP は Socket で通信をするため、IMAPクラスのメソッドは
Socket 関連のエラーが発生するかもしれません。例えば、通信中に接続が切れると [c:Errno::EPIPE] 例外が発生します。詳しくは [c:Socket] などを見てください。

[c:Net::IMAP::DataFormatError]、
[c:Net::IMAP::ResponseParseError] という例外クラスも存在します。前者はデータのフォーマットが正しくない場合に、後者はサーバからのレスポンスがパースできない場合に発生します。
これらのエラーはこのライブラリもしくはサーバに深刻な問題があることを意味します。

### tagged response と untagged response

IMAP プロトコルにおいてサーバからの応答には tagged なものと
untagged なものの2通り存在します。
tagged な応答は、クライアントからのコマンドが成功もしくは失敗のいずれかで完了したことを表すものです。
一方 untagged な応答はそれ以外の情報を渡すためのものです。
untagged な応答はクライアントからのコマンドの結果の情報を渡すためにも用いられますし、そうでない(サーバのシャットダウンなど)
自発的応答にも用いられます。

これはそれぞれ
[c:Net::IMAP::TaggedResponse] と [c:Net::IMAP::UntaggedResponse]
に対応します。

untagged な応答はコマンドの送信とは非同期的にサーバから送られるため、
[c:Net::IMAP] オブジェクトはユーザのためこれを
[m:Net::IMAP#responses] に記録しておきます。

### References

  - [IMAP]
    M. Crispin, "INTERNET MESSAGE ACCESS PROTOCOL - VERSION 4rev1",
    RFC 2060, December 1996.

  - [LANGUAGE-TAGS]
    Alvestrand, H., "Tags for the Identification of
    Languages", RFC 1766, March 1995.

  - [MD5]
    Myers, J., and M. Rose, "The Content-MD5 Header Field", RFC
    1864, October 1995.

  - [MIME-IMB]
    Freed, N., and N. Borenstein, "MIME (Multipurpose Internet
    Mail Extensions) Part One: Format of Internet Message Bodies", RFC
    2045, November 1996.

  - [RFC-822]
    Crocker, D., "Standard for the Format of ARPA Internet Text
    Messages", STD 11, RFC 822, University of Delaware, August 1982.

  - [RFC-2087]
    Myers, J., "IMAP4 QUOTA extension", RFC 2087, January 1997.

  - [RFC-2086]
    Myers, J., "IMAP4 ACL extension", RFC 2086, January 1997.

  - [OSSL]
    <https://www.openssl.org/>

  - [RSSL]
    <http://savannah.gnu.org/projects/rubypki>

以上のうち、いくつかの RFC は obsolete になって置き換えられています。
[RFC:2060] は [RFC:3501] に、[RFC:822] は [RFC:2822] に、置き換えられています。

# class Net::IMAP < Object

IMAP 接続を表現するクラスです。

## Class Methods

#%since 4.0
### def Net::IMAP.new(host, port: nil, ssl: nil, response_handlers: nil, config: Net::IMAP::Config.global, **config_options) -> Net::IMAP
#%end
#%version 3.4...4.0
### def Net::IMAP.new(host, port: nil, ssl: nil, config: Net::IMAP::Config.global, **config_options) -> Net::IMAP
#%end
#%version 3.3...3.4
### def Net::IMAP.new(host, port: nil, ssl: nil, open_timeout: 30, idle_response_timeout: 5) -> Net::IMAP
#%end
#%until 3.3
### def Net::IMAP.new(host, port = 143, usessl = false, certs = nil, verify = true) -> Net::IMAP
### def Net::IMAP.new(host, options) -> Net::IMAP
#%end

新たな Net::IMAP オブジェクトを生成し、指定したホストの指定したポートに接続し、接続後の IMAP オブジェクトを返します。

#%since 3.3
`ssl` に真を渡すと、サーバに繋ぐのに SSL/TLS を用います。
`ssl` がハッシュならば、それを [m:OpenSSL::SSL::SSLContext#set_params] に渡して SSL/TLS のパラメータを設定します。
true ならば、[m:OpenSSL::SSL::SSLContext#set_params] の既定のパラメータを使います。
SSL/TLS での接続には OpenSSL と [lib:openssl] が使える必要があります。
`port` を省略すると、SSL/TLS を使うときは 993、使わないときは 143 に接続します。

#%end
#%version 3.3...3.4
`open_timeout` で接続が確立するまで待つ秒数を、`idle_response_timeout` で IDLE の応答を待つ秒数を指定します。

#%end
#%since 4.0
`response_handlers` には受信スレッドを開始する前に追加する応答ハンドラのリストを指定します。
こうすると最初の応答([m:Net::IMAP#greeting])も含めて、サーバからのすべての応答がハンドラで処理されます。

#%end
#%since 3.4
`config` には接続の設定([c:Net::IMAP::Config] オブジェクト)を指定します。
設定のほかに、版の数値(`0.4` など)や名前(`:current` など)やハッシュも [Net::IMAP::Config.[]](m:Net::IMAP::Config.[]) と同じように指定できます。
これは接続ごとに作られる設定([m:Net::IMAP#config])を直接置き換えるのではなく、その継承元になります。
省略時は全体の設定 [m:Net::IMAP::Config.global] が継承元になります。
残りのキーワード引数 `config_options` は [m:Net::IMAP::Config.new] に渡され、接続ごとの設定の初期値になります。
たとえば `open_timeout`(接続が確立するまで待つ秒数。既定値は 30)や `idle_response_timeout`(IDLE の応答を待つ秒数。既定値は 5)を指定できます。

#%end
#%since 3.3
互換性のため、`Net::IMAP.new(host, port)` と `Net::IMAP.new(host, options)`(`options` はハッシュ)の形も受け付けます。
それぞれ `port` を `port:` のキーワード引数に、`options` をキーワード引数に変換し、警告は出ません。
`Net::IMAP.new(host, port, usessl, certs, verify)` の形は非推奨で、警告を出します。
`usessl` が偽ならば `certs` と `verify` は無視され、SSL/TLS を使いません。
`usessl` が真ならば `certs` と `verify` を `ssl` のハッシュに変換します。
`certs` がファイルならば `ca_file` に、ディレクトリならば `ca_path` に変換し、`verify` が真ならば `verify_mode` に [m:OpenSSL::SSL::VERIFY_PEER] を、偽ならば [m:OpenSSL::SSL::VERIFY_NONE] を設定します。

```ruby title="例"
require 'net/imap'

imap = Net::IMAP.new('imap.example.com', port: 993,
                     ssl: { verify_mode: OpenSSL::SSL::VERIFY_PEER,
                            timeout: 600 })
```

#%end
#%since 3.4
この警告は `Warning[:deprecated]` が真のとき(`-W:deprecated` を指定したときなど)だけ表示されます。

#%end
#%until 3.3
usessl が真ならば、サーバに繋ぐのに SSL/TLS を用います。
SSL/TLS での接続には OpenSSL と [lib:openssl] が使える必要があります。
certs は利用する証明書のファイル名もしくは証明書があるディレクトリ名を文字列で渡します。
certs に nil を渡すと、OpenSSL のデフォルトの証明書を使います。
verify は接続先を検証するかを真偽値で設定します。
真が [m:OpenSSL::SSL::VERIFY_PEER] に、偽が [m:OpenSSL::SSL::VERIFY_NONE] に対応します。

パラメータは Hash で渡すこともできます。以下のキーを使うことができます。
  - :port ポート番号
    省略時は SSL/TLS 使用時→993 不使用時→143 となります。
  - :ssl OpenSSL に渡すパラメータをハッシュで指定します。
    省略時は SSL/TLS を使わず接続します。
    これで渡せるパラメータは
    [m:OpenSSL::SSL::SSLContext#set_params] と同じです。
これの :ssl パラメータを使うことで、OpenSSL のパラメータを詳細に調整できます。

```ruby title="例"
require 'net/imap'

imap = Net::IMAP.new('imap.example.com', :port => 993,
                     :ssl => { :verify_mode => OpenSSL::SSL::VERIFY_PEER,
                               :timeout => 600 } )
```

#%end
- **param** `host` -- 接続するホスト名の文字列
- **param** `port` -- 接続するポート番号
#%since 3.3
- **param** `ssl` -- 真で SSL/TLS を使う。ハッシュなら [m:OpenSSL::SSL::SSLContext#set_params] に渡すパラメータ
#%end
#%version 3.3...3.4
- **param** `open_timeout` -- 接続が確立するまで待つ秒数
- **param** `idle_response_timeout` -- IDLE の応答を待つ秒数
#%end
#%since 4.0
- **param** `response_handlers` -- 受信スレッドを開始する前に追加する応答ハンドラのリスト
#%end
#%since 3.4
- **param** `config` -- 接続ごとの設定の継承元とする [c:Net::IMAP::Config] オブジェクト。版の数値や名前やハッシュも指定できます
- **param** `config_options` -- 接続ごとの設定の初期値(`open_timeout` など)
#%end
#%until 3.3
- **param** `usessl` -- 真でSSL/TLSを使う
- **param** `certs` -- 証明書のファイル名/ディレクトリ名の文字列
- **param** `verify` -- 真で接続先を検証する
- **param** `options` -- 各種接続パラメータのハッシュ
#%end
#%since 3.3
- **raise** `ArgumentError` -- 互換のための形の引数とキーワード引数を同時に渡した場合や、`options` のハッシュと `usessl` などを同時に渡した場合に発生します
#%end

#%since 3.4
### def Net::IMAP.config -> Net::IMAP::Config

全体の設定 [m:Net::IMAP::Config.global] を返します。

[m:Net::IMAP.new] で `config` を省略すると、接続ごとの設定 [m:Net::IMAP#config] はこの設定を継承します。

```ruby title="例"
require 'net/imap'

p Net::IMAP.config.equal?(Net::IMAP::Config.global) # => true
p Net::IMAP.config.open_timeout                     # => 30
```

- **SEE** [c:Net::IMAP::Config], [m:Net::IMAP#config]

#%end
### def Net::IMAP.debug -> bool

デバッグモードが on になっていれば真を返します。

#%since 3.4
全体の設定 [m:Net::IMAP::Config#debug] の値を返します。

#%end
- **SEE** [m:Net::IMAP.debug=]

### def Net::IMAP.debug=(val)

デバッグモードの on/off をします。

真を渡すと on になります。

#%since 3.4
全体の設定 [m:Net::IMAP::Config#debug=] に設定します。

#%end
- **param** `val` -- 設定するデバッグモードの on/off の真偽値
- **SEE** [m:Net::IMAP.debug]

### def Net::IMAP.add_authenticator(auth_type, authenticator) -> ()

[m:Net::IMAP#authenticate] で使う
認証用クラスを設定します。

imap ライブラリに新たな認証方式を追加するために用います。

通常は使う必要はないでしょう。もしこれを用いて認証方式を追加する場合は net/imap.rb の
Net::IMAP::LoginAuthenticator などを参考にしてください。

- **param** `auth_type` -- 認証の種類(文字列)
- **param** `authenticator` -- 認証クラス(Class オブジェクト)

### def Net::IMAP.decode_utf7(str) -> String

modified UTF-7 の文字列を UTF-8 の文字列に変換します。

modified UTF-7 は IMAP のメールボックス名に使われるエンコーディングで、
UTF-7 を修正したものです。

詳しくは [RFC:2060] の 5.1.3 を参照してください。

Net::IMAP ではメールボックス名のエンコードを自動的変換「しない」ことに注意してください。必要があればユーザが変換すべきです。

- **param** `str` -- 変換対象の modified UTF-7 でエンコードされた文字列
- **SEE** [m:Net::IMAP.encode_utf7]

### def Net::IMAP.encode_utf7(str) -> String

UTF-8 の文字列を modified UTF-7 の文字列に変換します。

modified UTF-7 は IMAP のメールボックス名に使われるエンコーディングで、
UTF-7 を修正したものです。

詳しくは [m:Net::IMAP.encode_utf7] を見てください。

- **param** `str` -- 変換対象の UTF-8 でエンコードされた文字列
- **SEE** [m:Net::IMAP.decode_utf7]

### def Net::IMAP.format_date(time) -> String

時刻オブジェクトを IMAP の日付フォーマットでの文字列に変換します。

```ruby
require 'net/imap'

p Net::IMAP.format_date(Time.new(2011, 6, 20))
# => "20-Jun-2011"
```

- **param** `time` -- 変換する時刻オブジェクト

### def Net::IMAP.format_datetime(time) -> String

時刻オブジェクトを IMAP の日付時刻フォーマットでの文字列に変換します

```ruby
require 'net/imap'

p Net::IMAP.format_datetime(Time.new(2011, 6, 20, 13, 20, 1))
# => "20-Jun-2011 13:20 +0900"
```

- **param** `time` -- 変換する時刻オブジェクト

#%until 3.1
### def Net::IMAP.max_flag_count -> Integer

サーバからのレスポンスに含まれる flag の上限を返します。

これを越えた flag がレスポンスに含まれている場合は、
[c:Net::IMAP::FlagCountError] 例外が発生します。

- **SEE** [m:Net::IMAP.max_flag_count=]

### def Net::IMAP.max_flag_count=(count)

サーバからのレスポンスに含まれる flag の上限を設定します。

これを越えた flag がレスポンスに含まれている場合は、
[c:Net::IMAP::FlagCountError] 例外が発生します。

デフォルトは 10000 です。通常は変える必要はないでしょう。

- **param** `count` -- 設定する最大値の整数
- **SEE** [m:Net::IMAP.max_flag_count]

#%end
### def Net::IMAP.default_port -> Integer
### def Net::IMAP.default_imap_port -> Integer

デフォルトの IMAP のポート番号(143)を返します。

- **SEE** [m:Net::IMAP.default_tls_port]

### def Net::IMAP.default_tls_port -> Integer
### def Net::IMAP.default_imaps_port -> Integer
### def Net::IMAP.default_ssl_port -> Integer

デフォルトの IMAPS のポート番号(993)を返します。

- **SEE** [m:Net::IMAP.default_port]

## Methods

### def greeting -> Net::IMAP::UntaggedResponse

サーバから最初に送られてくるメッセージ(greeting message)
を返します。

#%since 3.4
### def config -> Net::IMAP::Config

接続ごとの設定を返します。

この設定は [m:Net::IMAP.new] で接続ごとに作られ、`config` で指定した設定(省略時は全体の設定 [m:Net::IMAP.config])を継承します。
[m:Net::IMAP.new] の残りのキーワード引数が、この設定の初期値になります。

- **SEE** [c:Net::IMAP::Config], [m:Net::IMAP.config]

#%end
### def open_timeout -> Integer

接続が確立するまで待つ秒数を返します。

#%since 3.4
接続の設定 [m:Net::IMAP::Config#open_timeout] の値を返します。

#%end
- **SEE** [m:Net::IMAP.new]

### def idle_response_timeout -> Integer

IDLE の応答を待つ秒数を返します。

#%since 3.4
接続の設定 [m:Net::IMAP::Config#idle_response_timeout] の値を返します。

#%end
- **SEE** [m:Net::IMAP#idle]

#%since 4.0
### def max_response_size -> Integer | nil

サーバの応答 1 つの大きさの上限(バイト数)を返します。

接続の設定 [m:Net::IMAP::Config#max_response_size] の値を返します。
nil は上限がないことを表します。

- **SEE** [m:Net::IMAP#max_response_size=]

### def max_response_size=(val)

サーバの応答 1 つの大きさの上限(バイト数)を設定します。

接続の設定 [m:Net::IMAP::Config#max_response_size=] に設定します。

- **param** `val` -- 上限のバイト数。nil で上限をなくします。
- **SEE** [m:Net::IMAP#max_response_size]

#%end
#%since 3.4
### def responses -> { String => [object] }
### def responses(type) -> [object]
### def responses {|hash| ... } -> object
### def responses(type) {|array| ... } -> object
#%end
#%version 3.3...3.4
### def responses -> { String => [object] }
### def responses {|hash| ... } -> object
### def responses(type) {|array| ... } -> object
#%end
#%until 3.3
### def responses -> { String => [object] }
#%end

サーバから送られてきた untagged な応答の記録を返します。

untagged な応答は種類ごとに記録されます。
応答の種類には "FLAGS", "OK", "UIDVALIDITY", "EXISTS" などがあり、この文字列がハッシュテーブルのキーとなります。
そして各種類ごとに配列が用意され、untagged な応答を受信するたびにその配列の末尾にその内容が記録されます。

#%since 3.3
ブロックを渡すと、記録をブロックに渡してブロックの値を返します。
`type` を指定するとその種類の応答の配列だけを渡します(`type` は大文字に変換して探します)。
ブロックの実行中は受信スレッドなどが記録を更新しないよう同期されます。
ブロックの外で記録のハッシュやその配列を扱うのはスレッド安全ではないため、下の例のようにブロックを渡して使います。

#%end
#%since 4.0
ブロックを渡さないときは、`type` を指定するとその種類の応答の配列を凍結した複製を返します。
`type` を指定しないときの動作は接続の設定 [m:Net::IMAP::Config#responses_without_block] で決まり、既定値の `:frozen_dup` では記録のハッシュを凍結した複製(値の配列も凍結したもの)を返します。
`:raise` を設定すると [c:ArgumentError] が発生します。

#%end
#%version 3.4...4.0
ブロックを渡さないときは、`type` を指定するとその種類の応答の配列を凍結した複製を返します。
`type` を指定しないときの動作は接続の設定 [m:Net::IMAP::Config#responses_without_block] で決まり、既定値の `:warn` では非推奨の警告(カテゴリは `:deprecated`)を出して記録のハッシュそのものを返します。
`:frozen_dup` を設定すると記録のハッシュを凍結した複製(値の配列も凍結したもの)を、`:raise` を設定すると [c:ArgumentError] が発生します。

#%end
#%version 3.3...3.4
ブロックを渡さずに `type` を指定すると [c:ArgumentError] が発生します。
ブロックも `type` も渡さないときは記録のハッシュそのものを返します。
ブロックを渡さずに呼ぶ形は非推奨ですが、警告は出ません。

#%end

```ruby title="例"
imap.select("inbox")
#%since 3.3
p imap.responses("EXISTS", &:last)
# => 2
p imap.responses("UIDVALIDITY", &:last)
# => 968263756
#%else
p imap.responses["EXISTS"].last
# => 2
p imap.responses["UIDVALIDITY"].last
# => 968263756
#%end

```

#%since 3.3
- **param** `type` -- 応答の種類("EXISTS" など)を文字列で指定します。
#%end
#%version 3.3...3.4
- **raise** `ArgumentError` -- ブロックを渡さずに `type` を指定した場合に発生します。
#%end
#%since 3.4
- **raise** `ArgumentError` -- ブロックも `type` も渡さず、設定 `responses_without_block` が `:raise` の場合に発生します。
#%end

#%since 4.1
### def disconnect(timeout: nil) -> nil
#%else
### def disconnect -> nil
#%end

サーバとの接続を切断します。

#%since 4.1
- **param** `timeout` -- 受信スレッドの終了を待つ秒数の上限を指定します。nil なら終了するまで待ちます。
#%end
- **SEE** [m:Net::IMAP#disconnected?]

### def capability -> [String]

CAPABILITY コマンドを送ってサーバがサポートしている機能(capabilities)のリストを文字列の配列として返します。

capability は IMAP に関連する RFC などで定義されています。

```ruby
p imap.capability
# => ["IMAP4REV1", "UNSELECT", "IDLE", "NAMESPACE", "QUOTA", ... ]
```

### def noop -> Net::IMAP::TaggedResponse

NOOP コマンドを送ります。

このコマンドは何もしません。

### def logout -> Net::IMAP::TaggedResponse

LOGOUT コマンドを送り、コネクションを切断することをサーバに伝えます。

#%since 3.3
### def authenticate(mechanism, *creds, sasl_ir: true, **props) -> Net::IMAP::TaggedResponse
#%end
#%version 3.2...3.3
### def authenticate(mechanism, *creds, **props) -> Net::IMAP::TaggedResponse
#%end
#%until 3.2
### def authenticate(auth_type, user, password) -> Net::IMAP::TaggedResponse
#%end

AUTHENTICATE コマンドを送り、クライアントを認証します。

#%since 3.2
`mechanism` で利用する SASL の認証方式を文字列で指定します。
残りの引数とブロックはその認証方式の実装にそのまま渡されます。
渡す認証情報(ユーザ名、パスワード、アクセストークンなど)は認証方式ごとに異なります。
#%else
auth_type で利用する認証方式を文字列で指定します。
#%end

```ruby title="例"
#%since 3.3
imap.authenticate('PLAIN', user, password)
#%else
imap.authenticate('LOGIN', user, password)
#%end

```

#%since 3.3
`mechanism` としては以下がサポートされています。
  - "ANONYMOUS"
  - "EXTERNAL"
  - "OAUTHBEARER"
  - "PLAIN"
  - "SCRAM-SHA-1"
  - "SCRAM-SHA-256"
  - "XOAUTH2"
  - "LOGIN"(非推奨)
  - "CRAM-MD5"(非推奨)
  - "DIGEST-MD5"(非推奨)

非推奨の認証方式は互換性のために残されているもので、使うと警告を出します。
`"LOGIN"` の代わりには `"PLAIN"` を使います。
`"XOAUTH2"` は非標準で `"OAUTHBEARER"` に置き換えられたものですが、広く使われています。
#%end
#%version 3.2...3.3
`mechanism` としては以下がサポートされています。
#%end
#%until 3.2
auth_type としては以下がサポートされています。
#%end
#%until 3.3
  - "LOGIN"
  - "PLAIN"
  - "CRAM-MD5"
  - "DIGEST-MD5"
#%end

#%since 3.3
サーバが SASL-IR 拡張([RFC:4959])と指定した認証方式に対応していて、認証方式がクライアントから先に応答するものであれば、`sasl_ir` が真のときは最初の応答を AUTHENTICATE コマンドの引数として送り、往復を 1 回省きます。

#%end
#%since 3.4
`sasl_ir` の既定値は接続の設定 [m:Net::IMAP::Config#sasl_ir] の値で、その既定値は true です。

#%end
#%since 3.2
- **param** `mechanism` -- 認証方式を表す文字列
- **param** `creds` -- 認証方式の実装に渡す認証情報。認証方式ごとに異なります
#%end
#%since 3.3
- **param** `sasl_ir` -- 偽を指定すると最初の応答を AUTHENTICATE コマンドの引数として送りません
#%end
#%since 3.2
- **param** `props` -- 認証方式の実装に渡すキーワード引数。認証方式ごとに異なります
#%else
- **param** `auth_type` -- 認証方式を表す文字列
- **param** `user` -- ユーザ名文字列
- **param** `password` -- パスワード文字列
#%end
- **SEE** [m:Net::IMAP#login]

### def login(user, password) -> Net::IMAP::TaggedResponse

LOGIN コマンドを送り、平文でパスワードを送りクライアントユーザを認証します。

[m:Net::IMAP#authenticate] で "LOGIN" を使うのとは異なることに注意してください。authenticate では AUTHENTICATE コマンドを送ります。

認証成功時には認証成功レスポンスを返り値として返します。

認証失敗時には例外が発生します。

- **param** `user` -- ユーザ名文字列
- **param** `password` -- パスワード文字列
- **raise** `Net::IMAP::NoResponseError` -- 認証に失敗した場合に発生します
- **SEE** [m:Net::IMAP#authenticate]

#%since 3.3
### def select(mailbox, condstore: false) -> Net::IMAP::TaggedResponse
#%else
### def select(mailbox) -> Net::IMAP::TaggedResponse
#%end

SELECT コマンドを送り、指定したメールボックスを処理対象のメールボックスにします。

このコマンドが成功すると、クライアントの状態が「selected」になります。

このコマンドを実行した直後に [m:Net::IMAP#responses]["EXISTS"].last
を調べると、メールボックス内のメールの数がわかります。
また、[m:Net::IMAP#responses]["RECENT"].lastで、最新のメールの数がわかります。
これらの値はセッション中に変わりうることに注意してください。
[m:Net::IMAP#add_response_handler] を使うとそのような更新情報を即座に取得できます。

- **param** `mailbox` -- 処理対象としたいメールボックスの名前(文字列)
#%since 3.3
- **param** `condstore` -- 真を指定すると CONDSTORE 拡張([RFC:7162])を有効にします。メールボックスが mod-sequence の保持に対応していれば HIGHESTMODSEQ 応答コードが untagged な応答として送られ、以後の FETCH の応答に mod-sequence が含まれます。
#%end
- **raise** `Net::IMAP::NoResponseError` -- mailboxが存在しない等の理由でコマンドの実行に失敗した場合に発生します。

#%since 3.3
### def examine(mailbox, condstore: false) -> Net::IMAP::TaggedResponse
#%else
### def examine(mailbox) -> Net::IMAP::TaggedResponse
#%end

EXAMINE コマンドを送り、指定したメールボックスを処理対象のメールボックスにします。

[m:Net::IMAP#select] と異なりセッション中はメールボックスが読み取り専用となります。それ以外は select と同じです。

- **param** `mailbox` -- 処理対象としたいメールボックスの名前(文字列)
#%since 3.3
- **param** `condstore` -- 真を指定すると CONDSTORE 拡張([RFC:7162])を有効にします。メールボックスが mod-sequence の保持に対応していれば HIGHESTMODSEQ 応答コードが untagged な応答として送られ、以後の FETCH の応答に mod-sequence が含まれます。
#%end
- **raise** `Net::IMAP::NoResponseError` -- mailboxが存在しない等の理由でコマンドの実行に失敗した場合に発生します。

### def create(mailbox) -> Net::IMAP::TaggedResponse

CREATE  コマンドを送り、新しいメールボックスを作ります。

- **param** `mailbox` -- 新しいメールボックスの名前(文字列)
- **raise** `Net::IMAP::NoResponseError` -- 指定した名前のメールボックスが作れなかった場合に発生します

### def delete(mailbox) -> Net::IMAP::TaggedResponse

DELETE コマンドを送り、指定したメールボックスを削除します。

- **param** `mailbox` -- 削除するメールボックスの名前(文字列)
- **raise** `Net::IMAP::NoResponseError` -- 指定した名前のメールボックスを削除できなかった場合に発生します。指定した名前のメールボックスが存在しない場合や、ユーザにメールボックスを削除する権限がない場合に発生します。

### def rename(mailbox, newname) -> Net::IMAP::TaggedResponse

RENAME コマンドを送り、指定したメールボックスをリネームします。

- **param** `mailbox` -- リネームするメールボックス(文字列)
- **param** `newname` -- リネーム後の名前(文字列)
- **raise** `Net::IMAP::NoResponseError` -- 指定した名前のメールボックスをリネームできなかった場合に発生します。
       指定した名前のメールボックスが存在しない場合や、リネーム後の名前を持つメールボックスが既に存在する場合に発生します。

### def subscribe(mailbox) -> Net::IMAP::TaggedResponse

SUBSCRIBE コマンドを送り、指定したメールボックスを
"active" もしくは "subscribe" なメールボックスの集合に追加します。

- **param** `mailbox` -- 追加するメールボックスの名前(文字列)
- **raise** `Net::IMAP::NoResponseError` -- 指定した名前のメールボックスを追加できなかった場合に発生します。
       指定した名前のメールボックスが存在しない場合などに生じます。

### def unsubscribe(mailbox) -> Net::IMAP::TaggedResponse

UNSUBSCRIBE コマンドを送り、指定したメールボックスを
"active" もしくは "subscribe" なメールボックスの集合から削除します。

- **param** `mailbox` -- 削除するするメールボックスの名前(文字列)
- **raise** `Net::IMAP::NoResponseError` -- 指定した名前のメールボックスを削除できなかった場合に発生します。
       指定した名前のメールボックスが active/subscribe でなかった場合などに発生します。

### def list(refname, mailbox) -> [Net::IMAP::MailboxList] | nil

LIST コマンドを送り、クライアントから利用可能なメールボックス名の集合から引数にマッチするものすべてを返します。

詳しくは  [RFC:2060] の 6.3.8 を参照してください。

返り値は [c:Net::IMAP::MailboxList] の配列で返します。
返り値が空集合である場合は空の配列でなく nil を返します。

- **param** `refname` -- 参照名(文字列)
- **param** `mailbox` -- 調べるメールボックスの名前(文字列)。ワイルドカードを含んでいてもかまいません。

```ruby title="例"
imap.create("foo/bar")
imap.create("foo/baz")
p imap.list("", "foo/%")
# => [#<Net::IMAP::MailboxList attr=[:Noselect], delim="/", name="foo/">, #<Net::IMAP::MailboxList attr=[:Noinferiors, :Marked], delim="/", name="foo/bar">, #<Net::IMAP::MailboxList attr=[:Noinferiors], delim="/", name="foo/baz">]
```

### def xlist(refname, mailbox) -> [Net::IMAP::MailboxList]

XLISTコマンドを送り、クライアントから利用可能なメールボックス名の集合から引数にマッチするものすべてを返します。

[m:Net::IMAP#list] とほぼ同様ですが、「:Sent」などの拡張されたフラグを含むことが異なります。

詳しくは
<http://code.google.com/apis/gmail/imap/>
を参照してください。

- **param** `refname` -- 参照名(文字列)
- **param** `mailbox` -- 調べるメールボックスの名前(文字列)。ワイルドカードを含んでいてもかまいません。

```ruby title="例"
imap.create("foo/bar")
imap.create("foo/baz")
p imap.xlist("", "foo/%")
# => [#<Net::IMAP::MailboxList attr=[:Noselect], delim="/", name="foo/">, \\
#    #<Net::IMAP::MailboxList attr=[:Noinferiors, :Marked], delim="/", name="foo/bar">, \\
#    #<Net::IMAP::MailboxList attr=[:Noinferiors], delim="/", name="foo/baz">]
```

### def lsub(refname, mailbox) -> [Net::IMAP::MailboxList]

LIST コマンドを送り、active/subscribed なメールボックス名の集合から引数にマッチするものすべてを返します。

詳しくは  [RFC:2060] の 6.3.8 を参照してください。

返り値は [c:Net::IMAP::MailboxList] の配列で返します。
返り値が空集合である場合は空の配列でなく nil を返します。

- **param** `refname` -- 参照名(文字列)
- **param** `mailbox` -- 調べるメールボックスの名前(文字列)。ワイルドカードを含んでいてもかまいません。

### def status(mailbox, attr) -> {String => Integer}

STATUS コマンドを送り、mailbox のステータスを得ます。

問い合わせたいステータスは attr に文字列の配列で渡します。

返り値は アトリビュート文字列をキーとするハッシュです。

詳しくは [RFC:2060] の 6.3.10 を参考にしてください。

```ruby title="例"
p imap.status("inbox", ["MESSAGES", "RECENT"])
#%since 3.4
# => {"RECENT" => 0, "MESSAGES" => 44}
#%else
# => {"RECENT"=>0, "MESSAGES"=>44}
#%end

```

- **param** `mailbox` -- 問い合わせ対象のメールボックス(文字列)
- **param** `attr` -- 問合せたいアトリビュート名(文字列)の配列
- **raise** `Net::IMAP::NoResponseError` -- メールボックスが存在しない場合や、アトリビュート名が存在しない場合に発生します

### def append(mailbox, message, flags = nil, date_time = nil) -> Net::IMAP::TaggedResponse

APPEND コマンドを送ってメッセージをメールボックスの末尾に追加します。

```ruby title="例"
imap.append("inbox", <<EOF.gsub(/\n/, "\r\n"), [:Seen], Time.now)
Subject: hello
From: someone@example.com
To: somebody@example.com
  
hello world
EOF
```

- **param** `mailbox` -- メッセージを追加するメールボックス名(文字列)
- **param** `message` -- メッセージ文字列
- **param** `flags` -- メッセージに付加するフラグ([c:Symbol] の配列)
- **param** `date_time` -- メッセージの時刻([c:Time] オブジェクト)。省略時は現在時刻が使われる
- **raise** `Net::IMAP::NoResponseError` -- メールボックスが存在しない場合に発生します

### def check -> Net::IMAP::TaggedResponse

CHECK コマンドを送り、現在処理しているメールボックスのチェックポイントを要求します。

チェックポイントの要求とは、サーバ内部で保留状態になっている操作を完了させることを意味します。例えばメモリ上にあるメールのデータをディスクに書き込むため、fsyncを呼んだりすることです。
実際に何が行なわれるかはサーバの実装によりますし、何も行なわれない場合もあります。

### def close -> Net::IMAP::TaggedResponse

CLOSE コマンドを送り、処理中のメールボックスを閉じます。

このコマンドによって、どのメールボックスも選択されていない状態に移行します。
そして \Deleted フラグが付けられたメールがすべて削除されます。

### def expunge -> [Integer] | nil

EXPUNGEコマンドを送り、:Deletedフラグをセットしたメッセージをすべて処理中のメールボックスから削除します。

削除したメッセージの message sequence number を配列で返します。

- **raise** `Net::IMAP::NoResponseError` -- メールボックスが read-only である場合に発生します

### def search(keys, charset = nil) -> [Integer]

SEARCH コマンドを送り、条件に合うメッセージの message sequence number
を配列で返します。

[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したメールボックスを検索対象とします。

検索の条件は key に文字列の1次元配列もしくは文字列で渡します。

検索条件は "SUBJECT", "FROM" などを用いることができます。
詳しくは [RFC:2060] の 6.4.4 を見てください。

```ruby title="例"
p imap.search(["SUBJECT", "hello"])
# => [1, 6, 7, 8]
p imap.search(["SUBJECT", "hello", "FROM", "foo@example.com"])
# => [6, 7]
p imap.search('SUBJECT "hello"')
# => [1, 6, 7, 8]
```

- **param** `keys` -- 検索キー(文字列の配列もしくは文字列)
- **param** `charset` -- 検索に用いるcharset
- **SEE** [m:Net::IMAP#search]

### def uid_search(keys, charset = nil) -> [Integer]

UID SEARCH コマンドを送り、条件に合うメッセージの UID
を配列で返します。

[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したメールボックスを検索対象とします。

検索の条件は key に文字列の1次元配列もしくは文字列で渡します。

検索条件は "SUBJECT", "FROM" などを用いることができます。
詳しくは [RFC:2060] の 6.4.4 を見てください。

```ruby title="例"
p imap.uid_search(["SUBJECT", "hello"])
# => [1, 6, 7, 8]
p imap.uid_search(["SUBJECT", "hello", "FROM", "foo@example.com"])
# => [6, 7]
p imap.uid_search('SUBJECT "hello"')
# => [1, 6, 7, 8]
```

- **param** `keys` -- 検索キー(文字列の配列もしくは文字列)
- **param** `charset` -- 検索に用いるcharset
- **SEE** [m:Net::IMAP#uid_search]

#%since 3.3
### def fetch(set, attr, changedsince: nil) -> [Net::IMAP::FetchData]
#%else
### def fetch(set, attr) -> [Net::IMAP::FetchData]
#%end

FETCH コマンドを送り、メールボックス内のメッセージに関するデータを取得します。

[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したメールボックスを対象とします。

set で対象とするメッセージを指定します。
これには sequence number、sequence number の配列、もしくは
[c:Range] オブジェクトを渡します。
attr には取得するアトリビュートを文字列の配列で渡してください。
指定可能なアトリビュートについては [m:Net::IMAP::FetchData#attr]
を見てください。

```ruby title="例"
p imap.fetch(6..8, "UID")
#%since 3.4
# => [#<Net::IMAP::FetchData seqno=6, attr={"UID" => 98}>, #<Net::IMAP::FetchData seqno=7, attr={"UID" => 99}>, #<Net::IMAP::FetchData seqno=8, attr={"UID" => 100}>]
p imap.fetch(6, "BODY[HEADER.FIELDS (SUBJECT)]")
# => [#<Net::IMAP::FetchData seqno=6, attr={"BODY[HEADER.FIELDS (SUBJECT)]" => "Subject: test\r\n\r\n"}>]
#%else
# => [#<Net::IMAP::FetchData seqno=6, attr={"UID"=>98}>, #<Net::IMAP::FetchData seqno=7, attr={"UID"=>99}>, #<Net::IMAP::FetchData seqno=8, attr={"UID"=>100}>]
p imap.fetch(6, "BODY[HEADER.FIELDS (SUBJECT)]")
# => [#<Net::IMAP::FetchData seqno=6, attr={"BODY[HEADER.FIELDS (SUBJECT)]"=>"Subject: test\r\n\r\n"}>]
#%end
data = imap.uid_fetch(98, ["RFC822.SIZE", "INTERNALDATE"])[0]
p data.seqno
# => 6
p data.attr["RFC822.SIZE"]
# => 611
p data.attr["INTERNALDATE"]
# => "12-Oct-2000 22:40:59 +0900"
p data.attr["UID"]
# => 98
```

- **param** `set` -- 処理対象のメッセージの sequence number
- **param** `attr` -- アトリビュート(文字列配列)
#%since 3.3
- **param** `changedsince` -- mod-sequence を整数で指定すると、mod-sequence がそれより大きいメッセージだけを対象にします。指定すると CONDSTORE 拡張([RFC:7162])を暗黙に有効にします。
#%end
- **SEE** [m:Net::IMAP#uid_fetch]

#%since 3.4
### def uid_fetch(set, attr, changedsince: nil, partial: nil) -> [Net::IMAP::FetchData]
#%end
#%version 3.3...3.4
### def uid_fetch(set, attr, changedsince: nil) -> [Net::IMAP::FetchData]
#%end
#%until 3.3
### def uid_fetch(set, attr) -> [Net::IMAP::FetchData]
#%end

UID FETCH コマンドを送り、メールボックス内のメッセージに関するデータを取得します。

[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したメールボックスを対象とします。

set で対象とするメッセージを指定します。
これには UID、UID の配列、もしくは
[c:Range] オブジェクトを渡します。
attr には取得するアトリビュートを文字列の配列で渡してください。
指定可能なアトリビュートについては [m:Net::IMAP::FetchData#attr]
を見てください。

- **param** `set` -- 処理対象のメッセージの UID
- **param** `attr` -- アトリビュート(文字列配列)
#%since 3.3
- **param** `changedsince` -- mod-sequence を整数で指定すると、mod-sequence がそれより大きいメッセージだけを対象にします。指定すると CONDSTORE 拡張([RFC:7162])を暗黙に有効にします。
#%end
#%since 3.4
- **param** `partial` -- 返す結果の範囲を [c:Range] で指定し、件数を制限します。`1..500` で `set` のうち最初の 500 件、`-500..-1` で最後の 500 件です。サーバが PARTIAL 拡張([RFC:9394])に対応している必要があります。
#%end
- **SEE** [m:Net::IMAP#fetch]

#%since 3.3
### def store(set, attr, flags, unchangedsince: nil) -> [Net::IMAP::FetchData] | nil
#%else
### def store(set, attr, flags) -> [Net::IMAP::FetchData] | nil
#%end

STORE コマンドを送り、メールボックス内のメッセージを更新します。

set で更新するメッセージを指定します。
これには sequence number、sequence number の配列、もしくは
[c:Range] オブジェクトを渡します。

[m:Net::IMAP#select] で指定したメールボックスを対象とします。

attr で何をどのように変化させるかを指定します。
以下を指定できます。
  - "FLAGS"
  - "+FLAGS"
  - "-FLAGS"
それぞれメッセージのフラグの置き換え、追加、削除を意味します。
詳しくは [RFC:2060] の 6.4.6 を参考にしてください。

flags には シンボルの配列で置き換え、追加もしくは削除されるフラグを指定します。

返り値は更新された内容を [c:Net::IMAP::FetchData] オブジェクトの配列で返します。

```ruby title="例"
p imap.store(6..8, "+FLAGS", [:Deleted])
#%since 3.4
# => [#<Net::IMAP::FetchData seqno=6, attr={"FLAGS" => [:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=7, attr={"FLAGS" => [:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=8, attr={"FLAGS" => [:Seen, :Deleted]}>]
#%else
# => [#<Net::IMAP::FetchData seqno=6, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=7, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=8, attr={"FLAGS"=>[:Seen, :Deleted]}>]
#%end

```

- **param** `set` -- 更新するメッセージのsequence number
- **param** `attr` -- 更新方式(文字列)
- **param** `flags` -- 更新内容([c:Symbol] の配列)
#%since 3.3
- **param** `unchangedsince` -- mod-sequence を整数で指定すると、mod-sequence がそれより大きいメッセージは更新しません。更新しなかったメッセージは MODIFIED 応答コードで返されます。指定すると CONDSTORE 拡張([RFC:7162])を暗黙に有効にします。
#%end
- **SEE** [m:Net::IMAP#uid_store], [m:Net::IMAP#fetch]

#%since 3.3
### def uid_store(set, attr, flags, unchangedsince: nil) -> [Net::IMAP::FetchData] | nil
#%else
### def uid_store(set, attr, flags) -> [Net::IMAP::FetchData] | nil
#%end

UID STORE コマンドを送り、メールボックス内のメッセージを更新します。

set で更新するメッセージを指定します。
これには UID、UID の配列、もしくは
[c:Range] オブジェクトを渡します。

[m:Net::IMAP#select] で指定したメールボックスを対象とします。

attr で何をどのように変化させるかを指定します。
以下を指定できます。
  - "FLAGS"
  - "+FLAGS"
  - "-FLAGS"
それぞれメッセージのフラグの置き換え、追加、削除を意味します。
詳しくは [RFC:2060] の 6.4.6 を参考にしてください。

返り値は更新された内容を [c:Net::IMAP::FetchData] オブジェクトの配列で返します。

- **param** `set` -- 更新するメッセージの UID
- **param** `attr` -- 更新方式(文字列)
- **param** `flags` -- 更新内容([c:Symbol] の配列)
#%since 3.3
- **param** `unchangedsince` -- mod-sequence を整数で指定すると、mod-sequence がそれより大きいメッセージは更新しません。更新しなかったメッセージは MODIFIED 応答コードで返されます。指定すると CONDSTORE 拡張([RFC:7162])を暗黙に有効にします。
#%end

- **SEE** [m:Net::IMAP#store], [m:Net::IMAP#uid_fetch]

### def copy(set, mailbox) -> Net::IMAP::TaggedResponse

COPY コマンドを送り、指定したメッセージを指定したメールボックスの末尾に追加します。

set でコピーするメッセージを指定します。
message sequence number(整数)、
message sequence numberの配列、もしくは [c:Range] で指定します。コピー元のメールボックスは
[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したものを用います。
mailbox はコピー先のメールボックスです。

- **param** `set` -- コピーするメッセージの message sequence number
- **param** `mailbox` -- コピー先のメールボックス(文字列)
- **SEE** [m:Net::IMAP#uid_copy]

### def uid_copy(set, mailbox) -> Net::IMAP::TaggedResponse

UID COPY コマンドを送り、指定したメッセージを指定したメールボックスの末尾に追加します。

set でコピーするメッセージを指定します。
UID (整数)、
UID の配列、もしくは [c:Range] で指定します。コピー元のメールボックスは
[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したものを用います。
mailbox はコピー先のメールボックスです。

- **param** `set` -- コピーするメッセージの UID
- **param** `mailbox` -- コピー先のメールボックス(文字列)
- **SEE** [m:Net::IMAP#copy]

### def move(set, mailbox) -> Net::IMAP::TaggedResponse

MOVEコマンドを送り、set で指定したメッセージを mailbox の末尾に移動させます。

set はmessage sequence number(整数)、
message sequence numberの配列、もしくは [c:Range] で指定します。

コピー元のメールボックスは
[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したものを用います。

- **param** `set` -- 移動するメッセージの message sequence number(整数、整数の配列、整数の Range)
- **param** `mailbox` -- 移動先のメールボックス(文字列)
- **SEE** [m:Net::IMAP#uid_move], [RFC:6851]

### def uid_move(set, mailbox) -> Net::IMAP::TaggedResponse

MOVEコマンドを送り、set でUIDで指定したメッセージを mailbox の末尾に移動させます。

set には UID、UID の配列、もしくは
[c:Range] オブジェクトを渡します。

コピー元のメールボックスは
[m:Net::IMAP#examine] もしくは [m:Net::IMAP#select] で指定したものを用います。

- **param** `set` -- 移動するメッセージのUID(整数、整数の配列、整数の Range)
- **param** `mailbox` -- 移動先のメールボックス(文字列)
- **SEE** [m:Net::IMAP#move], [RFC:6851]

### def sort(sort_keys, search_keys, charset) -> [Integer]
### def uid_sort(sort_keys, search_keys, charset) -> [Integer]

SORT コマンド送り、メールボックス内のメッセージをソートした結果を返します。

SORT コマンドは [RFC:5256] で定義されています。
詳しくはそちらを参照してください。
このコマンドは [m:Net::IMAP#capability] の返り値を見ることで利用可能かどうか判断できます。

sort_keys にはソート順を決めるキーを文字列の配列で指定します。
"ARRIVAL", "CC", "FROM", "TO", "SUBJECT" などが指定できます。
詳しくは [RFC:5265] の BASE.6.4.SORT の所を見てください。

search_key には検索条件を渡します。[m:Net::IMAP#search] とほぼ同じです。この条件にマッチするメッセージのみがソートされます。

[m:Net::IMAP#examine] もしくは
[m:Net::IMAP#select] で指定したメールボックスを対象とします。

返り値は message sequence number の配列を返します。

```ruby title="例"
p imap.sort(["FROM"], ["ALL"], "US-ASCII")
# => [1, 2, 3, 5, 6, 7, 8, 4, 9]
p imap.sort(["DATE"], ["SUBJECT", "hello"], "US-ASCII")
# => [6, 7, 8, 1]
```

- **param** `sort_keys` -- ソート順のキー(文字列配列)
- **param** `search_keys` -- 検索条件(文字列配列)
- **param** `charset` -- 検索条件の解釈に用いるCHARSET名(文字列)

### def setquota(mailbox, quota) -> Net::IMAP::TaggedResponse

SETQUOTA コマンドを送り、指定したメールボックスに
quota を設定します。

quota が nil ならば、mailbox の quota を破棄します。
quota が整数なら STORAGE をその値に変更します。

詳しくは [RFC:2087] を見てください。
このコマンドは [m:Net::IMAP#capability] の返り値を見ることで利用可能かどうか判断できます。

- **param** `mailbox` -- quota を設定するメールボックス名(文字列)
- **param** `quota` -- quotaの値(ストレージのサイズ、もしくは nil)
- **raise** `Net::IMAP::NoResponseError` -- 指定したメールボックスが quota root 
       でない場合、もしくは権限が存在しない場合に発生します。

### def getquota(mailbox) -> [Net::IMAP::MailboxQuota]

GETQUOTA コマンドを送って指定したメールボックスの quota の情報を返します。

quota の情報は [c:Net::IMAP::MailboxQuota] オブジェクトの配列で得られます。

詳しくは [RFC:2087] を見てください。
このコマンドは [m:Net::IMAP#capability] の返り値を見ることで利用可能かどうか判断できます。

- **param** `mailbox` -- quota 情報を得たいメールボックス名
- **raise** `Net::IMAP::NoResponseError` -- 指定したメールボックスが quota root でない場合に発生します

### def getquotaroot(mailbox) -> [Net::IMAP::MailboxQuotaRoot | Net::IMAP::MailboxQuota]

GETQUOTAROOT コマンドを送って指定したメールボックスの quota root の一覧と、関連する quota の情報を返します。

quota root の情報は [c:Net::IMAP::MailboxQuotaRoot] のオブジェクトで、返り値の配列の中に唯一含まれています。
quota の情報はメールボックスに関連付けられた quota root ごとに
[c:Net::IMAP::MailboxQuota] オブジェクトで得られます。

詳しくは [RFC:2087] を見てください。
このコマンドは [m:Net::IMAP#capability] の返り値を見ることで利用可能かどうか判断できます。

- **param** `mailbox` -- quota root を得たいメールボックス名(文字列)
- **raise** `Net::IMAP::NoResponseError` -- 指定したメールボックスが存在しない場合に発生します

### def setacl(mailbox, user, rights)

SETACL コマンドを送り、指定したメールボックスに指定したユーザに関する権限を設定します。

rights には設定する権限を表す文字列を指定します。
どのような文字列を指定すべきかは [RFC:2086] を参照してください。
rights に nil を渡すと、空文字列を指定したのと同様、つまりすべての権限を削除します。

- **param** `mailbox` -- 権限を設定するメールボックスの名前(文字列)
- **param** `user` -- 権限を設定するユーザの名前(文字列)
- **param** `rights` -- 権限を表す文字列

### def getacl(mailbox) -> [Net::IMAP::MailboxACLItem]

GETACL コマンドを送り、メールボックスの
ACL(Access Control List) を取得します。

[m:Net::IMAP#getacl] で指定したメールボックスに対し何らかの権限を持つ各ユーザに対して
[c:Net::IMAP::MailboxACLItem] オブジェクトが作られ、その配列が返されます。

GETACL コマンドは [RFC:2086] で定義されています。
詳しくはそちらを参照してください。

- **param** `mailbox` -- メールボックス名(文字列)
- **SEE** [c:Net::IMAP::MailboxACLItem]

### def add_response_handler(handler) -> ()
### def add_response_handler(handler){|resp| ...} -> ()

レスポンスハンドラを追加します。

レスポンスハンドラはサーバから応答を受け取るごとに呼びだされます。ハンドラには
[c:Net::IMAP::TaggedResponse] もしくは
[c:Net::IMAP::UntaggedResponse] オブジェクトが渡されます。

主にサーバからの非同期的なイベントを受け取るために用います。例えば EXISTS 応答を受け取る
(メールボックスに新たなメールが追加されたタイミングで発生します)
ためなどに用いられます。

レスポンスハンドラはメインのスレッドとは別のスレッドで呼びだされることに注意してください。

```ruby title="例"
imap.add_response_handler do |resp|
  p resp
end
```

- **param** `handler` -- 追加するハンドラ([c:Proc] や [c:Method] オブジェクト)
- **SEE** [m:Net::IMAP#remove_response_handler]

### def remove_response_handler(handler) -> ()

レスポンスハンドラを削除します。

- **param** `handler` -- 削除するハンドラ
- **SEE** [m:Net::IMAP#add_response_handler]

### def response_handlers -> Array

設定されているレスポンスハンドラ全てを配列で返します。

- **SEE** [m:Net::IMAP#add_response_handler]

#%since 3.3
### def starttls(**options) -> Net::IMAP::TaggedResponse
#%else
### def starttls(options) -> Net::IMAP::TaggedResponse
### def starttls(certs, verify) -> Net::IMAP::TaggedResponse
#%end

STARTTLS コマンドを送って TLS のセッションを開始します。

#%since 3.3
キーワード引数 `options` は [m:OpenSSL::SSL::SSLContext#set_params] にそのまま渡されます。
キーは [c:OpenSSL::SSL::SSLContext] の属性の代入メソッドの名前です。
TLS の交渉とホスト名の検証が両方成功してから返ります。

#%end
#%since 4.0
サーバが TLS の開始に同意した後、接続の設定 [m:Net::IMAP::Config#open_timeout] の秒数まで待ち、それを超えると [c:Net::OpenTimeout] が発生します。

#%end
#%since 3.3
互換性のため、`starttls(options)`(`options` はハッシュ)と `starttls(certs, verify)` の形も受け付けます。
`starttls(options)` はハッシュをキーワード引数に変換します。
`starttls(certs, verify)` の形は非推奨で、警告を出します。
`certs` と `verify` は [m:Net::IMAP.new] の `certs` と `verify` と同じように変換します。
#%end
#%since 3.4
この警告は `Warning[:deprecated]` が真のとき(`-W:deprecated` を指定したときなど)だけ表示されます。
#%end
#%until 3.3
options で [lib:openssl] に渡すオプションを指定します。
[m:OpenSSL::SSL::SSLContext#set_params] の引数と同じ意味です。

互換性のため、certs で証明書or証明書ディレクトリのファイル名(文字列)、
verify で検証するかどうか([m:OpenSSL::SSL::VERIFY_PEER]、
[m:OpenSSL::SSL::VERIFY_NONE]に対応します)を指定できます。
#%end

#%since 3.3
- **param** `options` -- [m:OpenSSL::SSL::SSLContext#set_params] に渡す SSL/TLS のパラメータ
- **raise** `ArgumentError` -- 互換のための形の引数とキーワード引数を同時に渡した場合や、`options` のハッシュと `verify` を同時に渡した場合に発生します
#%else
- **param** `options` -- SSL/TLS のオプション([c:Hash] オブジェクト)
- **param** `certs` -- 証明書ファイル名、もしくは証明書ディレクトリ名(文字列)
- **param** `verify` -- 真なら SSL/TLS 接続時に証明書を検証します
#%end

### def disconnected? -> bool

サーバとの接続が切断されていれば真を返します。

- **SEE** [m:Net::IMAP#disconnect]

### def thread(algorithm, search_keys, charset) -> [Net::IMAP::ThreadMember]

THREADコマンドを送り、メールボックスを検索した結果をスレッド形式の木構造で返します。

THREAD コマンドは [RFC:5256] で定義されています。
詳しくはそちらを参照してください。
このコマンドは [m:Net::IMAP#capability] の返り値を見ることで利用可能かどうか判断できます。

algorithm は木構造を決定するためのアルゴリズムを指定します。
以下の2つが利用可能です。
  - "ORDEREDSUBJECT" subjectを使って平坦に区切るだけ
  - "REFERENCES" どのメッセージに返事をしているかを見て木構造を作る
詳しくは [RFC:5256] を見てください。

search_key には検索条件を渡します。
[m:Net::IMAP#search] と同等です。

- **param** `algorithm` -- スレッド構造構築アルゴリズム名(文字列)
- **param** `search_keys` -- 検索条件(文字列配列)
- **param** `charset` -- 検索条件の解釈に用いるCHARSET名(文字列)
- **SEE** [c:Net::IMAP::ThreadMember], [m:Net::IMAP#uid_thread]

### def uid_thread(algorithm, search_keys, charset)  -> [Net::IMAP::ThreadMember]

THREADコマンドを送り、メールボックスを検索した結果をスレッド形式の木構造で返します。

ほぼ [m:Net::IMAP#thread] と同じですが、返ってくるオブジェクトの
[m:Net::IMAP::ThreadMember#seqno] の内容が message sequence number
ではなく UID となります。

- **param** `algorithm` -- スレッド構造構築アルゴリズム名(文字列)
- **param** `search_keys` -- 検索条件(文字列配列)
- **param** `charset` -- 検索条件の解釈に用いるCHARSET名(文字列)
- **SEE** [c:Net::IMAP::ThreadMember], [m:Net::IMAP#thread]

#%until 3.4
### def client_thread -> Thread

このメソッドは obsolete です。使わないでください。
#%end

#%until 3.3
### def client_thread=(th)

このメソッドは obsolete です。使わないでください。
#%end

### def idle {|resp| ...} -> Net::IMAP::TaggedResponse

IDLE 命令を送り、メールボックスの非同期的変化を待ち受けます。

このメソッドに渡したブロックは
[m:Net::IMAP#add_response_handler] によってレスポンスハンドラとして用いられます。
また、このメソッドが終了する時点で
[m:Net::IMAP#remove_response_handler] でハンドラが削除されます。

レスポンスハンドラについては
[m:Net::IMAP#add_response_handler] を参照してください。

別のスレッドが [m:Net::IMAP#idle_done] を呼びだすまでこのメソッドを呼びだしたスレッドは停止します。

この命令は [RFC:2177] で定義されています。詳しくはそちらを参照してください。

### def idle_done -> ()

[m:Net::IMAP#idle] で停止しているスレッドを1つ起こします。

## Constants
### const SEEN -> Symbol

「:Seen」というシンボルを返します。

そのメッセージが既に読まれていることを意味します。

フラグメッセージ属性として用いられます
([m:Net::IMAP::FetchData#attr])。

詳しくは [RFC:2060] を参照してください。

### const ANSWERED -> Symbol

「:Answered」というシンボルを返します。

そのメッセージに返答したことを意味します。

フラグメッセージ属性として用いられます
([m:Net::IMAP::FetchData#attr])。

詳しくは [RFC:2060] を参照してください。

### const FLAGGED -> Symbol

「:Flagged」というシンボルを返します。

そのメッセージに特別なフラグを立てていることを意味します。

フラグメッセージ属性として用いられます
([m:Net::IMAP::FetchData#attr])。

詳しくは [RFC:2060] を参照してください。

### const DELETED -> Symbol

「:Deleted」というシンボルを返します。

メッセージが削除されていることを意味します。
EXPUNGE で完全に除去されます。

フラグメッセージ属性として用いられます
([m:Net::IMAP::FetchData#attr])。

詳しくは [RFC:2060] を参照してください。

### const DRAFT -> Symbol

「:Draft」というシンボルを返します。

メッセージが草稿であることを意味します。

フラグメッセージ属性として用いられます
([m:Net::IMAP::FetchData#attr])。

詳しくは [RFC:2060] を参照してください。

### const RECENT -> Symbol

「:Recent」というシンボルを返します。

メッセージが「最近」メールボックスに到着したことを意味します。

フラグメッセージ属性として用いられます
([m:Net::IMAP::FetchData#attr])。

詳しくは [RFC:2060] を参照してください。

### const NOINFERIORS -> Symbol

「:Noinferiors」というシンボルを返します。

このメールボックスの下に子レベルの階層が存在不可能であることを意味します。

LIST応答の属性
([m:Net::IMAP#list]、[m:Net::IMAP::MailboxList#attr])
として用いられます。

詳しくは [RFC:2060] を参照してください。

### const NOSELECT -> Symbol

「:Noselect」というシンボルを返します。

メールボックスが選択可能でないことを意味します。

LIST応答の属性
([m:Net::IMAP#list]、[m:Net::IMAP::MailboxList#attr])
として用いられます。

詳しくは [RFC:2060] を参照してください。

### const MARKED -> Symbol

「:Marked」というシンボルを返します。

メールボックスが「interesting」であるとサーバによって印付けられていることを意味します。通常メールボックスに新しいメールが届いていることを意味します。

LIST応答の属性
([m:Net::IMAP#list]、[m:Net::IMAP::MailboxList#attr])
として用いられます。

詳しくは [RFC:2060] を参照してください。

### const UNMARKED -> Symbol

「:Unmarked」というシンボルを返します。

メールボックスが印付けられていないことを意味します。
メールボックスに新しいメールが届いていないことを意味します。

LIST応答の属性
([m:Net::IMAP#list]、[m:Net::IMAP::MailboxList#attr])
として用いられます。

詳しくは [RFC:2060] を参照してください。

#%since 3.4
# class Net::IMAP::Config < Object

[c:Net::IMAP] の動作の設定を表すクラスです。

全体の設定は [m:Net::IMAP.config] または [m:Net::IMAP::Config.global] で、接続ごとの設定は [m:Net::IMAP#config] で得られます。
[m:Net::IMAP.new] は、`config` で指定した設定(省略時は全体の設定)を継承元とする接続ごとの設定を作り、残りのキーワード引数をその初期値にします。

各設定は継承元([m:Net::IMAP::Config#parent] で得られます)を持ち、自身で値を設定していない属性は継承元の値を返します。
継承元の値は参照するたびに調べるので、継承元の値を変えると、それを継承している設定にもすぐに反映されます。
既定では、接続ごとの設定は全体の設定を、全体の設定は [m:Net::IMAP::Config.default] を継承します。

```ruby title="継承の例"
require 'net/imap'

parent = Net::IMAP::Config.new(open_timeout: 10)
config = parent.new(idle_response_timeout: 3)
p config.open_timeout              # => 10
p config.inherited?(:open_timeout) # => true
parent.open_timeout = 20
p config.open_timeout              # => 20
p config.idle_response_timeout     # => 3
```

[m:Net::IMAP.new] の `config` に net-imap の版の数値(`0.4` など)を渡すと、その版の既定値を使えます。
版ごとの既定値は [Net::IMAP::Config.[]](m:Net::IMAP::Config.[]) で得られる凍結済みの設定で、その継承元は全体の設定です。
ただし `debug` は版ごとの既定値に含まれず、全体の設定から継承します。
版の数値のかわりに、次の名前も使えます。

- `:current` は、現在の版の既定値です。
- `:default` は、`:current` と同じです。[m:Net::IMAP::Config.default] とは別のオブジェクトで、`debug` を全体の設定から継承します。
- `:next` は、次の版で予定している既定値です。
- `:future` は、将来の版で予定している既定値です。
#%since 4.0
- `:original` は、版の数値 `0.0` と同じで、設定の仕組みが入る前の動作に合わせた既定値です。
#%end

```ruby title="版ごとの既定値の例"
require 'net/imap'

p Net::IMAP::Config[0.3].sasl_ir                 # => false
p Net::IMAP::Config[0.4].sasl_ir                 # => true
p Net::IMAP::Config[0.4].responses_without_block # => :silence_deprecation_warning
p Net::IMAP::Config[0.4].frozen?                 # => true
Net::IMAP.debug = true
p Net::IMAP::Config[0.4].debug                   # => true
```

既にある設定の属性をある版の既定値にするには [m:Net::IMAP::Config#load_defaults] を使います。

設定の変更はスレッド間で同期されません。

## Class Methods

### def Net::IMAP::Config.default -> Net::IMAP::Config

組み込みの既定値を持つ設定を返します。

この設定は凍結されていて、継承元を持ちません。
全体の設定 [m:Net::IMAP::Config.global] の継承元です。

- **SEE** [m:Net::IMAP::Config.global]

### def Net::IMAP::Config.global -> Net::IMAP::Config

全体の設定を返します。

[m:Net::IMAP.config] と同じオブジェクトです。
この設定は凍結されておらず、継承元は [m:Net::IMAP::Config.default] です。
[m:Net::IMAP::Config.new] で `parent` を省略したときや、[m:Net::IMAP.new] で `config` を省略したときの継承元になります。

- **SEE** [m:Net::IMAP.config], [m:Net::IMAP::Config.default]

### def Net::IMAP::Config.version_defaults -> {object => Net::IMAP::Config}

版ごとの既定値の設定を、版の数値や名前をキーとして保持するハッシュを返します。

[Net::IMAP::Config.[]](m:Net::IMAP::Config.[]) はこのハッシュから設定を取り出します。
ハッシュも、値の設定も凍結されています。

#%since 4.0
キーは版の数値(`0.0` から `1.0` までの `0.1` 刻みの [c:Rational] と [c:Float])と名前(`:original`、`:default`、`:current`、`:next`、`:future`)です。
キーに一致しない数値や文字列は、版の数値や名前に変換して探します。

#%else
キーは版の数値(`0` と、`0.0` から `0.6` までの `0.1` 刻みの [c:Float])と名前(`:default`、`:current`、`:next`、`:future`)です。

#%end
- **SEE** [Net::IMAP::Config.[]](m:Net::IMAP::Config.[])

### def Net::IMAP::Config.[](config) -> Net::IMAP::Config

`config` に対応する設定を返します。

`config` には次のものを指定できます。

- [c:Net::IMAP::Config] オブジェクトを指定すると、それをそのまま返します。
- ハッシュ(`to_hash` に応答するオブジェクト)を指定すると、その内容を属性の値とし、全体の設定を継承元とする凍結済みの新しい設定を返します。
- 版の数値(`0.4` など)を指定すると、その版の既定値の設定を返します。
- 名前(`:current` など)を指定すると、その名前の既定値の設定を返します。
#%since 4.0
- 文字列(`"0.5"` など)を指定すると、版の数値や名前に変換して、その既定値の設定を返します。
#%end

版の数値や名前で得られる設定は凍結済みで、継承元は全体の設定です。

- **param** `config` -- 設定、ハッシュ、版の数値、名前のいずれか
- **raise** `RangeError` -- 未知の版の数値を指定した場合に発生します。
#%since 4.0
- **raise** `KeyError` -- 未知の名前(シンボルか文字列)を指定した場合に発生します。
- **raise** `TypeError` -- 上記以外のもの(nil など)を指定した場合に発生します。
#%else
- **raise** `KeyError` -- 未知の名前を指定した場合に発生します。
- **raise** `TypeError` -- 上記以外のもの(nil や文字列など)を指定した場合に発生します。
#%end

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config[{open_timeout: 1}]
p config.open_timeout # => 1
p config.frozen?      # => true
p Net::IMAP::Config[Net::IMAP::Config.default].equal?(Net::IMAP::Config.default) # => true
```

- **SEE** [m:Net::IMAP::Config.version_defaults], [m:Net::IMAP::Config.new]

### def Net::IMAP::Config.new(parent = Net::IMAP::Config.global, **attrs) -> Net::IMAP::Config
### def Net::IMAP::Config.new(parent = Net::IMAP::Config.global, **attrs) {|config| ... } -> Net::IMAP::Config

`parent` を継承元とする新しい設定を作り、`attrs` で属性の値を設定して返します。

`parent` は [Net::IMAP::Config.[]](m:Net::IMAP::Config.[]) で変換するので、設定のほかに版の数値や名前やハッシュも指定できます。
ブロックを渡すと、作った設定をブロックに渡してから返します。

- **param** `parent` -- 継承元の設定。省略時は全体の設定
- **param** `attrs` -- 設定する属性の名前と値
- **raise** `ArgumentError` -- `attrs` に未知の属性名がある場合や、属性に不正な値を指定した場合に発生します。
- **raise** `TypeError` -- `parent` に設定に変換できないもの(nil など)を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new(open_timeout: 10)
p config.open_timeout                            # => 10
p config.parent.equal?(Net::IMAP::Config.global) # => true
p Net::IMAP::Config.new(0.3).sasl_ir             # => false
```

- **SEE** [m:Net::IMAP::Config#new], [m:Net::IMAP::Config#with]

## Instance Methods

### def debug -> bool
### def debug? -> bool

デバッグモードが on になっていれば真を返します。

on のときは、サーバとの間で送受信したデータを標準エラー出力に出力し、応答の解析に失敗したときの警告も詳しくなります。
既定値は false です。
版ごとの既定値の設定はこの属性を全体の設定から継承し、[m:Net::IMAP::Config#load_defaults] もこの属性を変えません。
[m:Net::IMAP.debug] は全体の設定のこの属性を返します。

#%#noexample Net::IMAP::Config#debug= を参照

- **SEE** [m:Net::IMAP::Config#debug=], [m:Net::IMAP.debug]

### def debug=(val)

デバッグモードの on/off を設定します。

`val` は真偽値に変換します。

- **param** `val` -- 真で on、偽で off にします。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.debug = 1
p config.debug              # => true
p config.inherited?(:debug) # => false
```

- **SEE** [m:Net::IMAP::Config#debug], [m:Net::IMAP.debug=]

### def open_timeout -> Integer

接続が確立するまで待つ秒数を返します。

[m:Net::IMAP.new] で TCP の接続と TLS の開始のそれぞれに適用し、この秒数を超えると [c:Net::OpenTimeout] が発生します。
既定値は 30 です。

#%since 4.0
[m:Net::IMAP#starttls] でも使います。

#%end

#%#noexample Net::IMAP::Config.new を参照

- **SEE** [m:Net::IMAP::Config#open_timeout=], [m:Net::IMAP#open_timeout]

### def open_timeout=(val)

接続が確立するまで待つ秒数を設定します。

`val` は [m:Kernel?.Integer] で整数に変換します。

- **param** `val` -- 待つ秒数
- **raise** `ArgumentError` -- 整数に変換できない文字列を指定した場合に発生します。

- **SEE** [m:Net::IMAP::Config#open_timeout]

### def idle_response_timeout -> Integer

IDLE の応答を待つ秒数を返します。

[m:Net::IMAP#idle] で IDLE を終えるよう要求してから、応答を受け取るまで待つ秒数です。
既定値は 5 です。

#%#noexample Net::IMAP::Config#idle_response_timeout= を参照

- **SEE** [m:Net::IMAP::Config#idle_response_timeout=], [m:Net::IMAP#idle_response_timeout], [m:Net::IMAP#idle_done]

### def idle_response_timeout=(val)

IDLE の応答を待つ秒数を設定します。

`val` は [m:Kernel?.Integer] で整数に変換します。

- **param** `val` -- 待つ秒数
- **raise** `ArgumentError` -- 整数に変換できない文字列を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.idle_response_timeout = "10"
p config.idle_response_timeout # => 10
```

- **SEE** [m:Net::IMAP::Config#idle_response_timeout]

#%since 4.0
### def sasl_ir -> Symbol | bool
### def sasl_ir? -> Symbol | bool
#%else
### def sasl_ir -> bool
### def sasl_ir? -> bool
#%end

[m:Net::IMAP#authenticate] で SASL-IR 拡張([RFC:4959])を使うかどうかを返します。

サーバと認証方式の両方が SASL-IR 拡張に対応しているときに使います。
[m:Net::IMAP#authenticate] で `sasl_ir` を指定すると、そちらが優先されます。

#%since 4.0
値の意味は次のとおりです。

- false のときは、SASL-IR 拡張を使いません。
- `:when_capabilities_cached` のときは、サーバの機能一覧を取得済みのときだけ SASL-IR 拡張を使い、機能一覧を調べるための CAPABILITY コマンドは送りません。
- true のときは、SASL-IR 拡張を使います。

#%end
既定値は true です。
版ごとの既定値は、`0.3` 以前が false、`0.4` 以降が true です。

#%#noexample Net::IMAP::Config#sasl_ir= を参照

- **SEE** [m:Net::IMAP::Config#sasl_ir=], [m:Net::IMAP#authenticate]

### def sasl_ir=(val)

[m:Net::IMAP#authenticate] で SASL-IR 拡張を使うかどうかを設定します。

#%since 4.0
`val` には false、`:when_capabilities_cached`、true のいずれかを指定します。

- **param** `val` -- false、`:when_capabilities_cached`、true のいずれか
- **raise** `ArgumentError` -- 上記以外の値を指定した場合に発生します。
#%else
`val` は真偽値に変換します。

- **param** `val` -- 真で使い、偽で使いません。
#%end

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.sasl_ir = false
p config.sasl_ir # => false
```

- **SEE** [m:Net::IMAP::Config#sasl_ir]

### def enforce_logindisabled -> Symbol | bool

[m:Net::IMAP#login] の前に、サーバの機能一覧に LOGINDISABLED があるかを確認するかどうかを返します。

確認して LOGINDISABLED があったときは、LOGIN コマンドを送らずに `Net::IMAP::LoginDisabledError` が発生します。
値の意味は次のとおりです。

- false のときは、確認せずに LOGIN コマンドを送ります。
- `:when_capabilities_cached` のときは、サーバの機能一覧を取得済みのときだけ確認し、機能一覧を調べるための CAPABILITY コマンドは送りません。
- true のときは、確認します。機能一覧が未取得なら、LOGIN コマンドの前に CAPABILITY コマンドを送ります。

既定値は true です。
版ごとの既定値は、`0.4` 以前が false、`0.5` 以降が true です。

#%#noexample Net::IMAP::Config#enforce_logindisabled= を参照

- **SEE** [m:Net::IMAP::Config#enforce_logindisabled=], [m:Net::IMAP#login]

### def enforce_logindisabled=(val)

[m:Net::IMAP#login] の前に、サーバの機能一覧に LOGINDISABLED があるかを確認するかどうかを設定します。

- **param** `val` -- false、`:when_capabilities_cached`、true のいずれか
- **raise** `ArgumentError` -- 上記以外の値を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.enforce_logindisabled = :when_capabilities_cached
p config.enforce_logindisabled # => :when_capabilities_cached
```

- **SEE** [m:Net::IMAP::Config#enforce_logindisabled]

#%since 4.1
### def max_non_synchronizing_literal -> Integer

同期しないリテラルとして送るデータの大きさの上限(バイト数)を返します。

同期しないリテラルは、サーバが続行を許可するのを待たずに送るリテラルです。
サーバの機能一覧を取得済みで、LITERAL+、LITERAL-、IMAP4rev2 のいずれかを含むときに、大きさがこの上限以下のデータを同期しないリテラルとして送ります。
LITERAL- と IMAP4rev2 では、大きさが 4096 バイト以下であることも必要です。
-1 にすると、同期しないリテラルを送りません。
既定値は 16384(16 KiB)です。
版ごとの既定値は、`0.5` 以前が -1、`0.6` 以降が 16384 です。

#%#noexample Net::IMAP::Config#max_non_synchronizing_literal= を参照

- **SEE** [m:Net::IMAP::Config#max_non_synchronizing_literal=]

### def max_non_synchronizing_literal=(val)

同期しないリテラルとして送るデータの大きさの上限(バイト数)を設定します。

`val` は [m:Kernel?.Integer] で整数に変換します。

- **param** `val` -- 上限のバイト数。-1 で同期しないリテラルを送りません。
- **raise** `ArgumentError` -- 整数に変換できない文字列を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.max_non_synchronizing_literal = -1
p config.max_non_synchronizing_literal # => -1
```

- **SEE** [m:Net::IMAP::Config#max_non_synchronizing_literal]

#%end
#%since 4.0
### def max_response_size -> Integer | nil

サーバの応答 1 つの大きさの上限(バイト数)を返します。

nil は上限がないことを表します。
応答の大きさが上限に達するか、リテラルを読むと上限を超えるときは、`Net::IMAP::ResponseTooLargeError` が発生して接続を閉じます。
この上限は応答 1 つごとのもので、応答の数や、記録される未処理の応答の量は制限しません。
既定値は 536870912(512 MiB)で、信頼できないサーバに接続するときはもっと小さい値にするべきです。
版ごとの既定値は、`0.4` 以前が nil、`0.5` 以降が 536870912 です。

値を変えてもすぐには反映されないことがあります。
受信スレッドが前の値で次の応答を待っていることがあるためで、[m:Net::IMAP#noop] などで応答を受け取ると新しい値が使われます。

#%#noexample Net::IMAP::Config#max_response_size= を参照

- **SEE** [m:Net::IMAP::Config#max_response_size=], [m:Net::IMAP#max_response_size]

### def max_response_size=(val)

サーバの応答 1 つの大きさの上限(バイト数)を設定します。

`val` は nil でなければ [m:Kernel?.Integer] で整数に変換します。

- **param** `val` -- 上限のバイト数。nil で上限をなくします。
- **raise** `ArgumentError` -- 整数に変換できない文字列を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.max_response_size = "1024"
p config.max_response_size # => 1024
config.max_response_size = nil
p config.max_response_size # => nil
```

- **SEE** [m:Net::IMAP::Config#max_response_size], [m:Net::IMAP#max_response_size=]

#%end
### def responses_without_block -> Symbol

[m:Net::IMAP#responses] を `type` もブロックも渡さずに呼んだときの動作を返します。

値の意味は次のとおりです。

- `:silence_deprecation_warning` のときは、警告を出さずに記録のハッシュそのものを返します。
- `:warn` のときは、非推奨の警告を出して記録のハッシュそのものを返します。
- `:frozen_dup` のときは、記録のハッシュを凍結した複製(値の配列も凍結したもの)を返します。
- `:raise` のときは、[c:ArgumentError] が発生します。

記録のハッシュそのものを扱うのはスレッド安全ではありません。

#%since 4.0
既定値は `:frozen_dup` です。

#%else
既定値は `:warn` です。

#%end
版ごとの既定値は、`0.4` 以前が `:silence_deprecation_warning`、`0.5` が `:warn`、`0.6` 以降が `:frozen_dup` です。

#%#noexample Net::IMAP::Config#responses_without_block= を参照

- **SEE** [m:Net::IMAP::Config#responses_without_block=], [m:Net::IMAP#responses]

### def responses_without_block=(val)

[m:Net::IMAP#responses] を `type` もブロックも渡さずに呼んだときの動作を設定します。

- **param** `val` -- `:silence_deprecation_warning`、`:warn`、`:frozen_dup`、`:raise` のいずれか
- **raise** `ArgumentError` -- 上記以外の値を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.responses_without_block = :raise
p config.responses_without_block # => :raise
```

- **SEE** [m:Net::IMAP::Config#responses_without_block]

#%since 4.0
### def parser_use_deprecated_uidplus_data -> Symbol | bool

COPYUID と APPENDUID の応答コードを解析するときに非推奨の警告を出すかどうかを返します。

この属性の値は解析の結果に影響しません。
true か `:up_to_max_size` のときは、COPYUID と APPENDUID の応答コードを解析するたびに非推奨の警告(カテゴリは `:deprecated`)を出します。
false のときは警告を出しません。
既定値は false です。
版ごとの既定値は、`0.4` 以前が true、`0.5` が `:up_to_max_size`、`0.6` 以降が false です。

#%#noexample Net::IMAP::Config#parser_use_deprecated_uidplus_data= を参照

- **SEE** [m:Net::IMAP::Config#parser_use_deprecated_uidplus_data=]

### def parser_use_deprecated_uidplus_data=(val)

COPYUID と APPENDUID の応答コードを解析するときに非推奨の警告を出すかどうかを設定します。

- **param** `val` -- true、`:up_to_max_size`、false のいずれか
- **raise** `ArgumentError` -- 上記以外の値を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.parser_use_deprecated_uidplus_data = :up_to_max_size
p config.parser_use_deprecated_uidplus_data # => :up_to_max_size
```

- **SEE** [m:Net::IMAP::Config#parser_use_deprecated_uidplus_data]

### def parser_max_deprecated_uidplus_data_size -> Integer

互換のために残されている属性の値を返します。

この属性の値は無視され、COPYUID と APPENDUID の応答コードの解析にも警告にも影響しません。
既定値は 0 です。
版ごとの既定値は、`0.3` 以前が 10000、`0.4` が 1000、`0.5` が 100、`0.6` 以降が 0 です。

#%#noexample Net::IMAP::Config#parser_max_deprecated_uidplus_data_size= を参照

- **SEE** [m:Net::IMAP::Config#parser_max_deprecated_uidplus_data_size=]

### def parser_max_deprecated_uidplus_data_size=(val)

互換のために残されている属性の値を設定します。

`val` は [m:Kernel?.Integer] で整数に変換します。

- **param** `val` -- 設定する整数
- **raise** `ArgumentError` -- 整数に変換できない文字列を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.parser_max_deprecated_uidplus_data_size = 100
p config.parser_max_deprecated_uidplus_data_size # => 100
```

- **SEE** [m:Net::IMAP::Config#parser_max_deprecated_uidplus_data_size]

#%end
### def parent -> Net::IMAP::Config | nil

継承元の設定を返します。

継承元を持たない [m:Net::IMAP::Config.default] では nil を返します。

```ruby title="例"
require 'net/imap'

p Net::IMAP::Config.global.parent.equal?(Net::IMAP::Config.default) # => true
p Net::IMAP::Config.default.parent                                   # => nil
```

### def new(**attrs) -> Net::IMAP::Config

`self` を継承元とする新しい設定を作り、`attrs` で属性の値を設定して返します。

`Net::IMAP::Config.new(self, **attrs)` と同じです。

- **param** `attrs` -- 設定する属性の名前と値
- **raise** `ArgumentError` -- `attrs` に未知の属性名がある場合や、属性に不正な値を指定した場合に発生します。

#%#noexample Net::IMAP::Config クラスの継承の例を参照

- **SEE** [m:Net::IMAP::Config.new], [m:Net::IMAP::Config#with]

### def update(**attrs) -> self

`attrs` で属性の値を設定して `self` を返します。

不正な値があって例外が発生したときは、それより前の属性だけが設定されていることがあります。

- **param** `attrs` -- 設定する属性の名前と値
- **raise** `ArgumentError` -- `attrs` に未知の属性名がある場合や、属性に不正な値を指定した場合に発生します。未知の属性名があるときは、どの属性も設定しません。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new
config.update(open_timeout: 1, debug: true)
p config.open_timeout # => 1
p config.debug        # => true
```

### def with(**attrs) -> Net::IMAP::Config
### def with(**attrs) {|config| ... } -> object

`self` を継承元とする新しい設定を作り、`attrs` で属性の値を設定して返します。

`self` が凍結されているときは、新しい設定も凍結します。
ブロックを渡すと、新しい設定をブロックに渡し、ブロックの値を返します。

- **param** `attrs` -- 設定する属性の名前と値
- **raise** `ArgumentError` -- `attrs` を 1 つも指定しなかった場合や、未知の属性名がある場合、属性に不正な値を指定した場合に発生します。

```ruby title="例"
require 'net/imap'

base = Net::IMAP::Config.new.freeze
config = base.with(open_timeout: 3)
p config.open_timeout        # => 3
p config.parent.equal?(base) # => true
p config.frozen?             # => true
p base.with(open_timeout: 3) {|c| c.open_timeout * 2 } # => 6
```

- **SEE** [m:Net::IMAP::Config#new]

### def load_defaults(version) -> self

`debug` 以外の属性に `version` の版の既定値を設定して `self` を返します。

継承元は変わりません。
設定した属性は継承元から継承しなくなります。
`version` は [Net::IMAP::Config.[]](m:Net::IMAP::Config.[]) と同じように、版の数値や名前で指定します。

#%since 4.0
版の数値や名前を表す文字列も指定できます。

#%end
- **param** `version` -- 版の数値か名前
- **raise** `ArgumentError` -- `version` が数値でもシンボルでも文字列でもない場合に発生します。
- **raise** `RangeError` -- 未知の版の数値を指定した場合に発生します。
- **raise** `KeyError` -- 未知の名前を指定した場合に発生します。
#%until 4.0
- **raise** `TypeError` -- 文字列を指定した場合に発生します。
#%end

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new(debug: true)
config.load_defaults(0.4)
p config.enforce_logindisabled              # => false
p config.responses_without_block            # => :silence_deprecation_warning
p config.debug                              # => true
p config.inherited?(:enforce_logindisabled) # => false
```

#%since 4.0
### def inherited?(*attrs) -> bool

`attrs` の属性がすべて継承元から継承されていれば真を返します。

`attrs` を省略すると、すべての属性を調べます。
1 つでも `self` で値を設定した属性があれば偽を返します。

- **param** `attrs` -- 属性の名前のシンボル

#%else
### def inherited?(attr) -> bool

`attr` の属性が継承元から継承されていれば真を返します。

`self` で値を設定した属性なら偽を返します。

- **param** `attr` -- 属性の名前のシンボル

#%end

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new(open_timeout: 1)
p config.inherited?(:open_timeout) # => false
p config.inherited?(:debug)        # => true
```

- **SEE** [m:Net::IMAP::Config#reset]

#%since 4.1
### def inherits_defaults?(*attrs) -> bool | Rational | nil

`attrs` の属性がすべて既定値の設定から継承されているかどうかを返します。

`attrs` を省略すると、すべての属性を調べます。
すべて [m:Net::IMAP::Config.default] から継承していれば true を、版ごとの既定値の設定から継承していればその版の数値([c:Rational])を返します。
全体の設定で値を設定した属性を継承していれば nil を、`self` やほかの継承元で値を設定した属性があれば false を返します。

- **param** `attrs` -- 属性の名前のシンボル

```ruby title="例"
require 'net/imap'

p Net::IMAP::Config.new.inherits_defaults?                  # => true
p Net::IMAP::Config.new(open_timeout: 1).inherits_defaults? # => false
p Net::IMAP::Config[0.4].inherits_defaults?                 # => (2/5)
```

- **SEE** [m:Net::IMAP::Config#overrides?]

### def overrides?(*attrs) -> bool

`attrs` の属性のうち 1 つでも `self` で値を設定したものがあれば真を返します。

`attrs` を省略すると、すべての属性を調べます。

- **param** `attrs` -- 属性の名前のシンボル

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new(open_timeout: 1)
p config.overrides?                # => true
p config.overrides?(:debug)        # => false
p Net::IMAP::Config.new.overrides? # => false
```

- **SEE** [m:Net::IMAP::Config#inherited?]

#%end
### def reset(attr) -> object
### def reset -> self

属性を継承元から継承するように戻します。

`attr` を指定すると、その属性を戻し、`self` で設定していた値を返します。
その属性が既に継承されていれば nil を返します。
`attr` を省略するか nil を指定すると、すべての属性を戻して `self` を返します。

- **param** `attr` -- 属性の名前のシンボル

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new(open_timeout: 1)
p config.reset(:open_timeout) # => 1
p config.open_timeout         # => 30
p config.reset(:open_timeout) # => nil
```

- **SEE** [m:Net::IMAP::Config#inherited?]

### def to_h -> {Symbol => object}

すべての属性の名前と値をハッシュにして返します。

値は継承元から継承したものも含みます。

```ruby title="例"
require 'net/imap'

config = Net::IMAP::Config.new(open_timeout: 1)
p config.to_h[:open_timeout]          # => 1
p config.to_h[:idle_response_timeout] # => 5
```

### def freeze -> self

`self` を凍結します。

凍結した設定の属性を変更しようとすると [c:FrozenError] が発生します。

#%since 4.0
### def inspect -> String
### def to_s -> String

`self` で値を設定した属性と継承の連鎖を表す文字列を返します。

継承元で値を設定した属性も、継承元ごとに再帰的に示します。
既定値の設定から継承した属性は示しません。

```ruby title="例"
require 'net/imap'

Net::IMAP.debug = true
p Net::IMAP::Config.global
# => #<Net::IMAP::Config.global debug=true inherits from Net::IMAP::Config.default>
```

- **SEE** [m:Net::IMAP::Config#pretty_print], [m:Net::IMAP::Config#to_h]

### def pretty_print(pp) -> ()

[lib:pp] で、すべての属性と継承の連鎖を表す文字列を出力するのに使います。

継承した属性は、それを継承した継承元とともに示します。

- **param** `pp` -- [c:PP] オブジェクト

- **SEE** [m:Net::IMAP::Config#inspect]

#%end
#%end

# class Net::IMAP::ContinuationRequest < Struct

IMAP の continuation request (命令継続要求) を表すクラスです。

通常このクラスを直接扱うことはありません。
レスポンスハンドラ([m:Net::IMAP#add_response_handler])
に渡されます。

詳しくは [RFC:2060] の 7.5 を参照してください。

## Instance Methods

### def data -> Net::IMAP::ResponseText

レスポンスのデータを返します。

### def raw_data -> String

レスポンス文字列を返します。

# class Net::IMAP::UntaggedResponse < Struct

IMAP のタグ付きレスポンスを表すクラスです。

IMAP のレスポンスにはタグ付きのものとタグなしのものがあり、タグなしのものはクライアントからのコマンド完了応答ではないレスポンスです。

- **SEE** [c:Net::IMAP::TaggedResponse]

## Instance Methods

### def name -> String

レスポンスの名前(種類)を返します。

例えば以下のような値を返します。これらの具体的な意味は
[RFC:2060] を参考にしてください。
  - "OK"
  - "NO"
  - "BAD"
  - "BYE"
  - "PREAUTH"
  - "CAPABILITY"
  - "LIST"
  - "FLAGS"
  -  etc

### def data -> object

レスポンスを解析した結果のオブジェクトを返します。

レスポンスによって異なるオブジェクトを返します。
[c:Net::IMAP::MailboxList] であったりフラグを表わすシンボルの配列であったりします。

### def raw_data -> String

レスポンス文字列を返します。

- **SEE** [m:Net::IMAP::UntaggedResponse#data]

# class Net::IMAP::TaggedResponse < Struct

IMAP のタグ付きレスポンスを表すクラスです。

IMAP のレスポンスにはタグ付きのものとタグなしのものがあり、タグ付きのレスポンスはクライアントが発行したコマンドによる操作が成功するか失敗するかのどちらかで完了したことを意味します。タグによってどのコマンドが完了したのかを示します。

- **SEE** [c:Net::IMAP::UntaggedResponse]

## Instance Methods

### def tag -> String

レスポンスに対応付けられたタグを返します。

### def name -> String

レスポンスの名前(種類)を返します。

例えば以下のような値を返します。これらの具体的な意味は
[RFC:2060] を参考にしてください。
  - "OK"
  - "NO"
  - "BAD"

### def data -> Net::IMAP::ResponseText

レスポンスを解析したオブジェクトを返します。

- **SEE** [c:Net::IMAP::ResponseText]

### def raw_data -> String

レスポンス文字列を返します。

- **SEE** [m:Net::IMAP::TaggedResponse#data]

# class Net::IMAP::ResponseText < Struct

応答のテキストを表すクラスです。

## Instance Methods

### def code -> Net::IMAP::ResponseCode | nil

レスポンスコードを返します。

応答がレスポンスコードを含んでいない場合は nil を返します。

- **SEE** [c:Net::IMAP::ResponseCode]

### def text -> String

応答のテキストを文字列で返します。

# class Net::IMAP::ResponseCode < Struct

応答のレスポンスコードを表すクラスです。

レスポンスコードについては [RFC:2060] の 7.1 を参照してください。

## Instance Methods

### def name -> String

レスポンスコードを表す文字列を返します。
 
"ALERT"、"PERMANENTFLAGS"、"UIDVALIDITY" などを返します。

### def data -> object | nil

レスポンスコードのデータを返します。

レスポンスコードの種類によって返すオブジェクトは異なります。
ない場合は nil を返します。

# class Net::IMAP::MailboxList < Struct

[m:Net::IMAP#list]、[m:Net::IMAP#xlist]、[m:Net::IMAP#lsub]
で返されるメールボックスのデータを表します。

## Instance Methods

### def attr -> [Symbol]

メールボックスの属性をシンボルの配列で返します。

これで得られるシンボルは [m:String#capitalize] でキャピタライズされています。

この配列には例えば以下のような値を含んでいます。
詳しくは [RFC:2060] 7.2.2 などを参照してください。
以下のもの以外で、IMAP 関連 RFC で拡張された値を含んでいる場合もあります
  - :Noselect
  - :Noinferiors
  - :Marked
  - :Unmarked

### def delim -> String|nil

階層区切り文字列を返します。

まったく階層が存在しない場合は nil を返します。

### def name -> String

メールボックスの名前を文字列で返します。

# class Net::IMAP::MailboxQuota < Struct

[m:Net::IMAP#getquota] や [m:Net::IMAP#getquotaroot] で得られる
quota の情報を表すオブジェクトです。

詳しくは [RFC:2087] を参照してください。

## Instance Methods

### def mailbox -> String

quota が設定されているメールボックスの名前を返します。

### def usage -> Integer

現在のメールボックス内の使用量を返します。

### def quota -> Integer

メールボックスに指定されている上限値を返します。

# class Net::IMAP::MailboxQuotaRoot < Struct

[m:Net::IMAP#getquotaroot] の結果として得られる
quota root 情報を表わすオブジェクトです。

詳しくは [RFC:2087] を参照してください。

## Instance Methods

### def mailbox -> String

問い合わせしたメールボックスの名前を返します。

### def quotaroots -> [String]

問い合わせしたメールボックスの quota root 名を配列で返します。

空の場合もありえます。

# class Net::IMAP::MailboxACLItem < Struct

GETACL の応答の各要素を表すクラスです。

[m:Net::IMAP#getacl] の返り値として用いられます。

詳しくは [RFC:2086] を参照してください。

## Instance Methods

### def user -> String

ユーザ名を返します。

このユーザは
[m:Net::IMAP#getacl] で指定したメールボックスに対し何らかの権限を持っています。

### def rights -> String

アクセス権限を文字列で返します。

[m:Net::IMAP::MailboxACLItem#user] で得られるユーザが持っている権限が返されます。

この文字列の意味については [RFC:2086] を参照してください。

# class Net::IMAP::StatusData < Struct

STATUS 応答を表わすクラスです。

## Instance Methods

### def mailbox -> String

メールボックス名を返します。

### def attr -> { String => Integer }

STATUS 応答の内容をハッシュで返します。

ハッシュのキーは
"MESSAGES", "RECENT", "UIDNEXT", "UIDVALIDITY", "UNSEEN"
などが使われます。

詳しくは [RFC:2060] の 6.3.10、7.2.4 を見てください。

# class Net::IMAP::FetchData < Object

FETCH コマンドの応答を表すクラスです。

[m:Net::IMAP#fetch]、[m:Net::IMAP#uid_fetch]、
[m:Net::IMAP#store]、[m:Net::IMAP#uid_store] の返り値として利用されます。

## Instance Methods

### def seqno -> Integer

メッセージの sequence number を返します。

[m:Net::IMAP#uid_fetch]、[m:Net::IMAP#uid_store]であっても
UID ではなく、sequence numberを返します。

### def attr -> { String => object }

各メッセージのアトリビュートの値をハッシュテーブルで返します。

キーはアトリビュート名の文字列、値はアトリビュートの値となります。
値のクラスはアトリビュートによって異なります。

利用可能なアトリビュートは以下の通りです。

- **`BODY`**:
    BODYSTRUCTURE の拡張データなしの形式。
    [c:Net::IMAP::BodyTypeBasic], [c:Net::IMAP::BodyTypeText],
    [c:Net::IMAP::BodyTypeMessage], [c:Net::IMAP::BodyTypeMultipart]
    のいずれか。
- **`BODY[<section>]<<partial>>`**:
    section で指定されたセクションのボディの内容。文字列。
- **`BODY.PEEK[<section>]<<partial>>`**:
    section で指定されたセクションのメッセージボディの内容。文字列。
    ただしこれで内容を見ても :Seen フラグを設定しない点が
    BODY[<section>]と同様
- **`BODYSTRUCTURE`**:
    MIME-IMB でのメッセージボディ。
    [c:Net::IMAP::BodyTypeBasic], [c:Net::IMAP::BodyTypeText],
    [c:Net::IMAP::BodyTypeMessage], [c:Net::IMAP::BodyTypeMultipart]
    のいずれか。
- **`ENVELOPE`**:
    メッセージのエンベロープ。
    [c:Net::IMAP::Envelope] オブジェクト。
- **`FLAGS`**:
    メッセージにセットされたフラグ。
    [c:Symbol] の配列。[m:String#capitalize] でキャピタライズされている。
- **`INTERNALDATE`**:
    メッセージの内部日付。文字列。
- **`RFC822`**:
    BODY[] と同じ。文字列。
- **`RFC822.HEADER`**:
    BODY.PEEK[HEADER] と同じ。文字列。
- **`RFC822.SIZE`**:
    メッセージの [RFC:822] サイズ。整数。
- **`RFC822.TEXT`**:
    BODY[TEXT] と同じ。文字列。
- **`UID`**:
    UID。整数。

詳しくは [RFC:2060] の FETCH command の節を見てください。

- **SEE** [m:Net::IMAP#fetch], [m:Net::IMAP#uid_fetch]

# class Net::IMAP::Envelope < Struct

メッセージのエンベロープを表すクラスです。

[m:Net::IMAP::FetchData#attr] の要素として用いられます。

## Instance Methods

### def date -> String | nil

日付の文字列を返します。

エンベロープに存在しないときは nil を返します。

### def subject -> String | nil

メッセージのサブジェクトを返します。

エンベロープに存在しないときは nil を返します。

### def from -> [Net::IMAP::Address] | nil

From を [c:Net::IMAP::Address] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。

### def sender -> [Net::IMAP::Address] | nil

Sender を [c:Net::IMAP::Address] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。

### def reply_to -> [Net::IMAP::Address] | nil

Reply-To を [c:Net::IMAP::Address] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。

### def to -> [Net::IMAP::Address] | nil

To を [c:Net::IMAP::Address] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。

### def cc -> [Net::IMAP::Address] | nil

Cc を [c:Net::IMAP::Address] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。

### def bcc -> [Net::IMAP::Address] | nil

Bcc を [c:Net::IMAP::Address] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。

### def in_reply_to -> String | nil

In-reply-to の内容を文字列で返します。

エンベロープに存在しないときは nil を返します。

### def message_id -> String | nil

message_id を文字列で返します。

エンベロープに存在しないときは nil を返します。

# class Net::IMAP::Address < Struct

メールアドレスを表すクラスです。

## Instance Methods

### def name -> String | nil

メールアドレスの [RFC:822] の個人名(personal name)を返します。

個人名が存在しない場合は nil を返します。

通常は nil を返します。

### def route -> String | nil

メールアドレスの SMTP at-domain-list を返します。

存在しない場合は nil を返します。

通常は nil を返します。

### def mailbox -> String | nil

メールアドレスのメールボックス名を返します。

これが nil ならばそれは [RFC:822] group の終わりを意味します。
これが nil でなく、[m:Net::IMAP::Address#mailbox] が nil ならば、
[RFC:822] のグループ名を表します。
どれでもなければ、[RFC:822] の local-part を表します。

通常は、メールアドレスの「@」の手前を返します。

### def host -> String | nil

メールアドレスのホスト名を返します。

nil は [RFC:822] のグループ文法に対応します。
これについては [m:Net::IMAP::Address#mailbox] も参照してください。
そうでない場合は [RFC:822] のドメイン名を表します。

通常は、メールアドレスの「@」の後ろのドメイン名を返します。

# class Net::IMAP::ContentDisposition < Struct

[RFC:1806], [RFC:2183] で定義されている MIME の
Content-Disposition フィールドを表すクラスです。

## Instance Methods

### def dsp_type -> String

Content-Disposition フィールドのタイプを文字列で返します。

"INLINE", "ATTACHMENT" などの文字列を返します。

詳しくは [RFC:2183] などを見てください。

### def param -> { String => String } | nil

Content-Disposition フィールドのパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーは以下のような値を取ります。詳しくは
[RFC:2183] などを見てください。
  - "FILENAME"
  - "CREATION-DATE"
  - "MODIFICATION-DATE"
  - "READ-DAT"
  - "SIZE"

# class Net::IMAP::ThreadMember < Struct

[m:Net::IMAP#thread]、 [m:Net::IMAP#uid_thread] から得られるスレッドの木構造のノードを表すクラスです。

## Instance Methods

### def seqno -> Integer | nil

メッセージの sequence number もしくは UID を返します。

root となるメッセージが存在しない場合しない木の場合は
nil を返します。

### def children -> [Net::IMAP::ThreadMember]

スレッドの木構造における自身の下位の部分を返します。

# class Net::IMAP::BodyTypeBasic < Struct

text 型([c:Net::IMAP::BodyTypeText])、
multipart 型([c:Net::IMAP::BodyTypeMultipart])、
message 型([c:Net::IMAP::BodyTypeMessage])、のいずれでもないようなメッセージボディ構造を表すクラスです。

添付ファイルなどを表します。
詳しくは MIME のRFC([RFC:2045])を参照してください。

## Instance Methods

### def media_type -> String

MIME のメディアタイプを返します。

- **SEE** [m:Net::IMAP::BodyTypeBasic#subtype]

### def subtype -> String
### def media_subtype -> String

MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

- **SEE** [m:Net::IMAP::BodyTypeBasic#media_type]

### def param -> { String => String } | nil

MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

- **SEE** [RFC:2045]

### def content_id -> String | nil

Content-ID の値を文字列で返します。

- **SEE** [RFC:2045]

### def description -> String | nil

Content-Description の値を文字列で返します。

- **SEE** [RFC:2045]

### def encoding -> String

Content-Transfer-Encoding の値を文字列で返します。

- **SEE** [RFC:2045]

### def size -> Integer

ボディのサイズのオクテット数を返します。

### def md5 -> String | nil

ボディの MD5 値を文字列で返します。

### def disposition -> Net::IMAP::ContentDisposition | nil

Content-Dispotition の値を返します。

[c:Net::IMAP::ContentDisposition] オブジェクトを返します。

- **SEE** [RFC:1806], [RFC:2183]

### def language -> String | [String] | nil

[RFC:1766] で定義されているボディ言語を表わす文字列もしくは文字列の配列を返します。

### def extension -> Array | nil

メッセージの拡張データを返します。

### def multipart? -> bool

マルチパートかどうかを返します。
false を返します。

# class Net::IMAP::BodyTypeText < Struct

Content-Type が text であるメッセージを表すクラスです。

平文のメールを表します。
詳しくは MIME のRFC([RFC:2045])を参照してください。

## Instance Methods

### def media_type -> String

MIME のメディアタイプを返します。

これは "TEXT" を返します。

- **SEE** [m:Net::IMAP::BodyTypeText#subtype]

### def subtype -> String
### def media_subtype -> String

MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

- **SEE** [m:Net::IMAP::BodyTypeText#media_type]

### def param -> { String => String } | nil

MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

- **SEE** [RFC:2045]

### def content_id -> String | nil

Content-ID の値を文字列で返します。

- **SEE** [RFC:2045]

### def description -> String | nil

Content-Description の値を文字列で返します。

- **SEE** [RFC:2045]

### def encoding -> String

Content-Transfer-Encoding の値を文字列で返します。

- **SEE** [RFC:2045]

### def size -> Integer

ボディのサイズのオクテット数を返します。

### def lines -> Integer

ボディの行数を返します。

### def md5 -> String | nil

ボディの MD5 値を文字列で返します。

### def disposition -> Net::IMAP::ContentDisposition | nil

Content-Dispotition の値を返します。

[c:Net::IMAP::ContentDisposition] オブジェクトを返します。

- **SEE** [RFC:1806], [RFC:2183]

### def language -> String | [String] | nil

[RFC:1766] で定義されているボディ言語を表わす文字列もしくは文字列の配列を返します。

### def extension -> Array | nil

メッセージの拡張データを返します。

### def multipart? -> bool

マルチパートかどうかを返します。
false を返します。

# class Net::IMAP::BodyTypeMessage < Struct

Content-Type が "message" であるメッセージを表すクラスです。

メールをメールに添付した場合などに使われます。
詳しくは [RFC:2045], [RFC:822] を参照してください。

## Instance Methods

### def media_type -> String

MIME のメディアタイプを返します。

これは "MESSAGE" を返します。

- **SEE** [m:Net::IMAP::BodyTypeMessage#subtype]

### def subtype -> String
### def media_subtype -> String

MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

- **SEE** [m:Net::IMAP::BodyTypeMessage#media_type]

### def param -> { String => String } | nil

MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

- **SEE** [RFC:2045]

### def content_id -> String | nil

Content-ID の値を文字列で返します。

- **SEE** [RFC:2045]

### def description -> String | nil

Content-Description の値を文字列で返します。

- **SEE** [RFC:2045]

### def encoding -> String

Content-Transfer-Encoding の値を文字列で返します。

- **SEE** [RFC:2045]

### def size -> Integer

ボディのサイズのオクテット数を返します。

### def envelope -> Net::IMAP::Envelpe | nil

メッセージのエンベロープを返します。

### def body -> Net::IMAP::BodyTypeBasic | Net::IMAP::BodyTypeMessage | Net::IMAP::BodyTypeText | Net::IMAP::BodyTypeMultipart

ボディを返します。

### def lines -> Integer

ボディのテキストの行数を返します。

### def md5 -> String | nil

ボディの MD5 値を文字列で返します。

### def disposition -> Net::IMAP::ContentDisposition | nil

Content-Dispotition の値を返します。

[c:Net::IMAP::ContentDisposition] オブジェクトを返します。

- **SEE** [RFC:1806], [RFC:2183]

### def language -> String | [String] | nil

[RFC:1766] で定義されているボディ言語を表わす文字列もしくは文字列の配列を返します。

### def extension  -> Array | nil

メッセージの拡張データを返します。

### def multipart?  -> bool

マルチパートかどうかを返します。
false を返します。

# class Net::IMAP::BodyTypeMultipart < Struct

マルチパートなメッセージを表すクラスです。

詳しくは MIME のRFC([RFC:2045])を参照してください。

## Instance Methods

### def media_type -> String

MIME のメディアタイプを返します。

"MULTIPART" を返します。

- **SEE** [m:Net::IMAP::BodyTypeMultipart#subtype]

### def subtype -> String
### def media_subtype -> String

MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

- **SEE** [RFC:2045], [m:Net::IMAP::BodyTypeText#media_type]

### def parts -> [Net::IMAP::BodyTypeBasic | Net::IMAP::BodyTypeText | Net::IMAP::BodyTypeMessage | Net::IMAP::BodyTypeMultipart]

マルチパートの各部分を返します。

### def param -> { String => String }

MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

- **SEE** [RFC:2045]

### def disposition -> Net::IMAP::ContentDisposition | nil

Content-Dispotition の値を返します。

[c:Net::IMAP::ContentDisposition] オブジェクトを返します。

- **SEE** [RFC:1806], [RFC:2183]

### def language -> String | [String] | nil

[RFC:1766] で定義されているボディ言語を表わす文字列もしくは文字列の配列を返します。

### def extension -> Array | nil

メッセージの拡張データを返します。

### def multipart? -> bool

マルチパートかどうかを返します。
true を返します。

#%# internal classes:
#%# = class Net::IMAP::Atom
#%# = class Net::IMAP::Literal
#%# = class Net::IMAP::QuotedString
#%# = class Net::IMAP::MessageSet
#%# = class Net::IMAP::RawData

#%# internal classes for authentication
#%# = class Net::IMAP::LoginAuthenticator
#%#
#%# Authenticator for the "LOGIN" authentication type.
#%# See [[m:Net::IMAP#authenticate]].
#%#
#%# == Class Methods
#%#
#%# --- new(user, password)
#%# #@todo
#%#
#%# == Instance Methods
#%#
#%# --- process(data)
#%# #@todo
#%#
#%#
#%#
#%# = class Net::IMAP::CramMD5Authenticator
#%#
#%# Authenticator for the "CRAM-MD5" authentication type.
#%# See [[m:Net::IMAP#authenticate]].
#%#
#%# == Class Methods
#%#
#%# --- new(user, password)
#%# #@todo
#%#
#%# == Instance Methods
#%#
#%# --- process(challenge)
#%# #@todo
#%#
#%#
#%#
#%# #@since 1.9.1
#%# = class Net::IMAP::PlainAuthenticator
#%#
#%# Authenticator for the "PLAIN" authentication type.
#%# See [[m:Net::IMAP#authenticate]].
#%#
#%# == Class Methods
#%#
#%# --- new(user, password)
#%# #@todo
#%#
#%# == Instance Methods
#%#
#%# --- process(data)
#%# #@todo
#%#
#%#
#%#
#%# = class Net::IMAP::DigestMD5Authenticator
#%#
#%# Authenticator for the "DIGEST-MD5" authentication type.
#%# See [[m:Net::IMAP#authenticate]].
#%#
#%# == Class Methods
#%#
#%# --- new(user, password, authname = nil)
#%# #@todo
#%#
#%# == Instance Methods
#%#
#%# --- process(challenge)
#%# #@todo
#%# #@end

# class Net::IMAP::Error < StandardError

すべての IMAP 例外クラスのスーパークラス。

# class Net::IMAP::DataFormatError < Net::IMAP::Error

データフォーマットが正しくない場合に発生する例外のクラスです。

# class Net::IMAP::ResponseParseError < Net::IMAP::Error

サーバからのレスポンスが正しくパースできない場合に発生する例外のクラスです。

# class Net::IMAP::ResponseError < Net::IMAP::Error

サーバからのレスポンスがエラーを示している場合に発生する例外のクラスです。

実際にはこれを継承した
  - [c:Net::IMAP::NoResponseError]
  - [c:Net::IMAP::BadResponseError]
  - [c:Net::IMAP::ByeResponseError]
これらのクラスの例外が発生します。

## Instance Methods
### def response -> Net::IMAP::TaggedResponse | Net::IMAP::UntaggedResponse

エラーとなったレスポンスを表すオブジェクトを返します。

### def response=(resp)

エラーとなったレスポンスを表すオブジェクトを設定します。

- **param** `resp` -- 設定するレスポンスオブジェクト

# class Net::IMAP::NoResponseError < Net::IMAP::ResponseError

サーバから "NO" レスポンスが来た場合に発生する例外のクラスです。
コマンドが正常に完了しなかった場合に発生します。

# class Net::IMAP::BadResponseError < Net::IMAP::ResponseError

サーバから "BAD" レスポンスが来た場合に発生する例外のクラスです。
クライアントからのコマンドが IMAP の規格から外れている場合やサーバ内部エラーの場合に発生します。

# class Net::IMAP::ByeResponseError < Net::IMAP::ResponseError

サーバから "BYE" レスポンスが来た場合に発生する例外のクラスです。
ログインが拒否された場合や、クライアントが無反応でタイムアウトした場合に発生します。

# class Net::IMAP::FlagCountError < Net::IMAP::Error

サーバからのレスポンスに含まれるフラグが多すぎるときに発生する例外です。

#%until 3.1
この上限は [m:Net::IMAP.max_flag_count=] で設定します。
#%end

