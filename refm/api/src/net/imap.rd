category Network

このライブラリは Internet Message Access Protocol (IMAP) の
クライアントライブラリです。[[RFC:2060]] を元に
実装されています。

=== IMAP の概要

IMAPを利用するには、まずサーバに接続し、
[[m:Net::IMAP#authenticate]] もしくは
[[m:Net::IMAP#login]] で認証します。
IMAP ではメールボックスという概念が重要です。
メールボックスは階層的な名前を持ちます。
各メールボックスはメールを保持することができます。
メールボックスの実装はサーバソフトウェアによって異なります。
Unixシステムでは、ディレクトリ階層上の
ファイルを個々のメールボックスとみなして実装されることが多いです。

メールボックス内のメッセージ(メール)を処理する場合、
まず [[m:Net::IMAP#select]] もしくは
[[m:Net::IMAP#examine]] で処理対象のメールボックスを
指定する必要があります。これらの操作が成功したならば、
「selected」状態に移行し、そのメールボックスが「処理対象の」
メールボックスとなります。このようにしてメールボックスを
選択してから、selected状態を終える(別のメールボックスを選択したり、
接続を終了したり)までをセッションと呼びます。

メッセージには2種類の識別子が存在します。message sequence number と
UID です。

message sequence number はメールボックス内の各メッセージに1から順に
振られた番号です。セッション中に処理対象のメールボックスに
新たなメッセージが追加された場合、そのメッセージの
message sequence number は
最後のメッセージの message sequence number+1となります。
メッセージをメールボックスから消した場合には、連番の穴を埋めるように
message sequence number が付け替えられます。

一方、UID はセッションを越えて恒久的に保持されます。
あるメールボックス内の異なる2つのメッセージが同じ  UID 
を持つことはありません。
これは、メッセージがメールボックスから削除された後でも成立します。

しかし、UID はメールボックス内で昇順であることが
規格上要請されているので、
IMAP を使わないメールアプリケーションがメールの順番を
変えてしまった場合は、UID が振り直されます。

=== 例

デフォルトのメールボックス(INBOX)の送り元とサブジェクトを表示する。
  imap = Net::IMAP.new('mail.example.com')
  imap.authenticate('LOGIN', 'joe_user', 'joes_password')
  imap.examine('INBOX')
  imap.search(["RECENT"]).each do |message_id|
    envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
    puts "#{envelope.from[0].name}: \t#{envelope.subject}"
  end

2003年4月のメールをすべて Mail/sent-mail から "Mail/sent-apr03" へ移動させる

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

=== スレッド安全性
Net::IMAP は並列実行をサポートしています。例として、

  imap = Net::IMAP.new("imap.foo.net", "imap2")
  imap.authenticate("cram-md5", "bar", "password")
  imap.select("inbox")
  fetch_thread = Thread.start { imap.fetch(1..-1, "UID") }
  search_result = imap.search(["BODY", "hello"])
  fetch_result = fetch_thread.value
  imap.disconnect

とすると FETCH コマンドと SEARCH コマンドを並列に実行します。

=== エラーについて
IMAP サーバは以下の3種類のエラーを送ります。

: NO
  コマンドが正常に完了しなかったことを意味します。
  例えば、ログインでのユーザ名/パスワードが間違っていた、
  選択したメールボックスが存在しない、などです。

: BAD
  クライアントからのリクエストをサーバが理解できなかった
  ことを意味します。
  クライアントの現在の状態では使えないコマンドを使おうとした
  場合にも発生します。例えば、
  selected状態(SELECT/EXAMINEでこの状態に移行する)にならずに
  SEARCH コマンドを使おうとした場合に発生します。
  サーバの内部エラー(ディスクが壊れたなど)の場合も
  このエラーが発生します。

: BYE
  サーバが接続を切ろうとしていることを意味します。
  これは通常のログアウト処理で発生します。
  また、ログイン時にサーバが(なんらかの理由で)接続
  したくない場合にも発生します。
  それ以外では、サーバがシャットダウンする場合か
  サーバがタイムアウトする場合に発生します。

これらのエラーはそれぞれ
  * [[c:Net::IMAP::NoResponseError]]
  * [[c:Net::IMAP::BadResponseError]]
  * [[c:Net::IMAP::ByeResponseError]]
という例外クラスに対応しています。
原理的には、これらの例外はサーバにコマンドを送った場合には
常に発生する可能性があります。しかし、このドキュメントでは
よくあるエラーのみ解説します。

IMAP は Socket で通信をするため、IMAPクラスのメソッドは
Socket 関連のエラーが発生するかもしれません。例えば、
通信中に接続が切れると [[c:Errno::EPIPE]] 例外が
発生します。詳しくは [[c:Socket]] などを見てください。

[[c:Net::IMAP::DataFormatError]]、
[[c:Net::IMAP::ResponseParseError]] という例外クラスも
存在します。前者はデータのフォーマットが正しくない場合に、
後者はサーバからのレスポンスがパースできない場合に発生します。
これらのエラーはこのライブラリもしくはサーバに深刻な問題が
あることを意味します。

=== tagged response と untagged response
IMAP プロトコルにおいてサーバからの応答には tagged なものと
untagged なものの2通り存在します。
tagged な応答は、クライアントからのコマンドが
成功もしくは失敗のいずれかで完了したことを表すものです。
一方 untagged な応答はそれ以外の情報を渡すためのものです。
untagged な応答はクライアントからのコマンドの結果の情報を
渡すためにも用いられますし、そうでない(サーバのシャットダウンなど)
自発的応答にも用いられます。

これはそれぞれ
[[c:Net::IMAP::TaggedResponse]] と [[c:Net::IMAP::UntaggedResponse]]
に対応します。

untagged な応答はコマンドの送信とは非同期的にサーバから送られるため、
[[c:Net::IMAP]] オブジェクトはユーザのためこれを
[[m:Net::IMAP#responses]] に記録しておきます。

=== References

  * [IMAP]
    M. Crispin, "INTERNET MESSAGE ACCESS PROTOCOL - VERSION 4rev1",
    RFC 2060, December 1996.

  * [LANGUAGE-TAGS]
    Alvestrand, H., "Tags for the Identification of
    Languages", RFC 1766, March 1995.

  * [MD5]
    Myers, J., and M. Rose, "The Content-MD5 Header Field", RFC
    1864, October 1995.

  * [MIME-IMB]
    Freed, N., and N. Borenstein, "MIME (Multipurpose Internet
    Mail Extensions) Part One: Format of Internet Message Bodies", RFC
    2045, November 1996.

  * [RFC-822]
    Crocker, D., "Standard for the Format of ARPA Internet Text
    Messages", STD 11, RFC 822, University of Delaware, August 1982.

  * [RFC-2087]
    Myers, J., "IMAP4 QUOTA extension", RFC 2087, January 1997.

  * [RFC-2086]
    Myers, J., "IMAP4 ACL extension", RFC 2086, January 1997.

  * [OSSL]
    [[url:http://www.openssl.org]]

  * [RSSL]
    [[url:http://savannah.gnu.org/projects/rubypki]]

以上のうち、いくつかの RFC は obsolete になって置き換えられています。
[[RFC:2060]] は [[RFC:3501]] に、[[RFC:822]] は [[RFC:2822]] に、
置き換えられています。

= class Net::IMAP < Object

IMAP 接続を表現するクラスです。

== Class Methods

#@since 1.9.1
--- new(host, port = 143, usessl = false, certs = nil, verify = true) -> Net::IMAP
--- new(host, options) -> Net::IMAP
#@else
--- new(host, port = 143, usessl = false, certs = nil, verify = false) -> Net::IMAP
#@end

新たな Net::IMAP オブジェクトを生成し、指定したホストの
指定したポートに接続し、接続語の IMAP オブジェクトを返します。

usessl が真ならば、サーバに繋ぐのに SSL/TLS を用います。
SSL/TLS での接続には OpenSSL と [[lib:openssl]] が使える必要があります。
certs は利用する証明書のファイル名もしくは証明書があるディレクトリ名を
文字列で渡します。
certs に nil を渡すと、OpenSSL のデフォルトの証明書を使います。
verify は接続先を検証するかを真偽値で設定します。
真が [[m:OpenSSL::SSL::VERIFY_PEER]] に、
偽が [[m:OpenSSL::SSL::VERIFY_NONE]] に対応します。

#@since 1.9.1
パラメータは Hash で渡すこともできます。以下のキーを使うことができます。
  * :port ポート番号
    省略時は SSL/TLS 使用時→993 不使用時→143 となります。
  * :ssl OpenSSL に渡すパラメータをハッシュで指定します。
    省略時は SSL/TLS を使わず接続します。
    これで渡せるパラメータは
    [[m:OpenSSL::SSL::SSLContext#set_params]] と同じです。
これの :ssl パラメータを使うことで、OpenSSL のパラメータを詳細に
調整できます。


例
  imap = Net::IMAP.new('imap.example.com', :port => 993,
                       :ssl => { :verify_mode => OpenSSL::SSL::VERIFY_PEER,
                                 :timeout => 600 } )
#@end

@param host 接続するホスト名の文字列
@param port 接続するポート番号
@param usessl 真でSSL/TLSを使う
@param certs 証明書のファイル名/ディレクトリ名の文字列
@param verify 真で接続先を検証する
#@since 1.9.1
@param options 各種接続パラメータのハッシュ
#@end

--- debug -> bool

デバッグモードが on になっていれば真を返します。

@see [[m:Net::IMAP#debug=]]

--- debug=(val)
デバッグモードの on/off をします。

真を渡すと on になります。

@param val 設定するデバッグモードの on/off の真偽値
@see [[m:Net::IMAP#debug]]

--- add_authenticator(auth_type, authenticator) -> ()
[[m:Net::IMAP#authenticate]] で使う 
認証用クラスを設定します。

imap ライブラリに新たな認証方式を追加するために用います。

通常は使う必要はないでしょう。もしこれを用いて
認証方式を追加する場合は net/imap.rb の
Net::IMAP::LoginAuthenticator などを参考にしてください。

@param auth_type 認証の種類(文字列)
@param authenticator 認証クラス(Class オブジェクト)

--- decode_utf7(str) -> String
modified UTF-7 の文字列を UTF-8 の文字列に変換します。

modified UTF-7 は IMAP のメールボックス名に使われるエンコーディングで、
UTF-7 を修正したものです。

詳しくは [[RFC:2060]] の 5.1.3 を参照してください。

Net::IMAP ではメールボックス名のエンコードを自動的変換「しない」
ことに注意してください。必要があればユーザが変換すべきです。

@param str 変換対象の modified UTF-7 でエンコードされた文字列
@see [[m:Net::IMAP.encode_utf7]]
--- encode_utf7(str) -> String
UTF-8 の文字列を modified UTF-7 の文字列に変換します。

modified UTF-7 は IMAP のメールボックス名に使われるエンコーディングで、
UTF-7 を修正したものです。

詳しくは [[m:Net::IMAP.encode_utf7]] を見てください。

@param str 変換対象の UTF-8 でエンコードされた文字列
@see [[m:Net::IMAP.decode_utf7]]

#@since 1.9.1

--- format_date(time) -> String
時刻オブジェクトを IMAP の日付フォーマットでの文字列に変換します。

  Net::IMAP.format_date(Time.new(2011, 6, 20))
  # => "20-Jun-2011"

@param time 変換する時刻オブジェクト

--- format_datetime(time) -> String
時刻オブジェクトを IMAP の日付時刻フォーマットでの文字列に変換します

  Net::IMAP.format_datetime(Time.new(2011, 6, 20, 13, 20, 1))
  # => "20-Jun-2011 13:20 +0900"

@param time 変換する時刻オブジェクト

--- max_flag_count -> Integer
サーバからのレスポンスに含まれる flag の上限を返します。

これを越えた flag がレスポンスに含まれている場合は、
[[c:Net::IMAP::FlagCountError]] 例外が発生します。

@see [[m:Net::IMAP.max_flag_count=]]

--- max_flag_count=(count)
サーバからのレスポンスに含まれる flag の上限を設定します。

これを越えた flag がレスポンスに含まれている場合は、
[[c:Net::IMAP::FlagCountError]] 例外が発生します。

デフォルトは 10000 です。通常は変える必要はないでしょう。

@param count 設定する最大値の整数
@see [[m:Net::IMAP.max_flag_count]]
#@end

#@since 2.0.0
--- default_port -> Integer
--- default_imap_port -> Integer

デフォルトの IMAP のポート番号(143)を返します。

@see [[m:Net::IMAP.default_tls_port]]

--- default_tls_port -> Integer
--- default_imaps_port -> Integer
--- default_ssl_port -> Integer

デフォルトの IMAPS のポート番号(993)を返します。

@see [[m:Net::IMAP.default_port]]

#@end

== Methods

--- greeting -> Net::IMAP::UntaggedResponse
サーバから最初に送られてくるメッセージ(greeting message)
を返します。

--- responses -> { String => [object] }
サーバから送られてきた untagged な応答の記録を返します。

untagged な応答は種類ごとに記録されます。
応答の種類には "FLAGS", "OK", "UIDVALIDITY", "EXISTS" などがあり、
この文字列がハッシュテーブルのキーとなります。
そして各種類ごとに配列が用意され、untagged な応答を受信するたびに
その配列の末尾にその内容が記録されます。


例:
  imap.select("inbox")
  p imap.responses["EXISTS"].last
  #=> 2
  p imap.responses["UIDVALIDITY"].last
  #=> 968263756

--- disconnect -> nil
サーバとの接続を切断します。

@see [[m:Net::IMAP#disconnected?]]

--- capability -> [String]
CAPABILITY コマンドを送ってサーバがサポートしている
機能(capabilities)のリストを文字列の配列として返します。

capability は IMAP に関連する RFC などで定義されています。

  imap.capability
  # => ["IMAP4REV1", "UNSELECT", "IDLE", "NAMESPACE", "QUOTA", ... ]

--- noop -> Net::IMAP::TaggedResponse
NOOP コマンドを送ります。

このコマンドは何もしません。

--- logout -> Net::IMAP::TaggedResponse
LOGOUT コマンドを送り、コネクションを切断することを
サーバに伝えます。

--- authenticate(auth_type, user, password) -> Net::IMAP::TaggedResponse

AUTHENTICATE コマンドを送り、クライアントを認証します。

auth_type で利用する認証方式を文字列で指定します。


例:
  imap.authenticate('LOGIN', user, password)

auth_type としては以下がサポートされています。
  * "LOGIN"
  * "PLAIN"
  * "CRAM-MD5"
  * "DIGEST-MD5"

@param auth_type 認証方式を表す文字列
@param user ユーザ名文字列
@param password パスワード文字列
@see [[m:Net::IMAP#login]]

--- login(user, password) -> Net::IMAP::TaggedResponse
LOGIN コマンドを送り、平文でパスワードを送りクライアント
ユーザを認証します。

[[m:Net::IMAP#authenticate]] で "LOGIN" を使うのとは異なる
ことに注意してください。authenticate では AUTHENTICATE コマンドを
送ります。

認証成功時には
認証成功レスポンスを返り値として返します。

認証失敗時には例外が発生します。

@param user ユーザ名文字列
@param password パスワード文字列
@raise Net::IMAP::NoResponseError 認証に失敗した場合に発生します
@see [[m:Net::IMAP#authenticate]]

--- select(mailbox) -> Net::IMAP::TaggedResponse
SELECT コマンドを送り、指定したメールボックスを処理対象の
メールボックスにします。

このコマンドが成功すると、クライアントの状態が「selected」になります。

このコマンドを実行した直後に [[m:Net::IMAP#responses]]["EXISTS"].last
を調べると、メールボックス内のメールの数がわかります。
また、[[m:Net::IMAP#responses]]["RECENT"].lastで、
最新のメールの数がわかります。
これらの値はセッション中に変わりうることに注意してください。
[[m:Net::IMAP#add_response_handler]] を使うとそのような更新情報を
即座に取得できます。

@param mailbox 処理対象としたいメールボックスの名前(文字列)
@raise Net::IMAP::NoResponseError mailboxが存在しない等の理由でコマンドの実行に失敗
       した場合に発生します。

--- examine(mailbox) -> Net::IMAP::TaggedResponse
EXAMINE コマンドを送り、指定したメールボックスを処理対象の
メールボックスにします。

[[m:Net::IMAP#select]] と異なりセッション中はメールボックスが
読み取り専用となります。それ以外は select と同じです。

@param mailbox 処理対象としたいメールボックスの名前(文字列)
@raise Net::IMAP::NoResponseError mailboxが存在しない等の理由でコマンドの実行に失敗
       した場合に発生します。

--- create(mailbox) -> Net::IMAP::TaggedResponse
CREATE  コマンドを送り、新しいメールボックスを作ります。

@param mailbox 新しいメールボックスの名前(文字列)
@raise Net::IMAP::NoResponseError 指定した名前のメールボックスが作れなかった場合に発生します

--- delete(mailbox) -> Net::IMAP::TaggedResponse
DELETE コマンドを送り、指定したメールボックスを削除します。

@param mailbox 削除するメールボックスの名前(文字列)
@raise Net::IMAP::NoResponseError 指定した名前のメールボックスを削除できなかった場合
       に発生します。指定した名前のメールボックスが存在しない場合や、
       ユーザにメールボックスを削除する権限がない場合に発生します。

--- rename(mailbox, newname) -> Net::IMAP::TaggedResponse
RENAME コマンドを送り、指定したメールボックスをリネームします。

@param mailbox リネームするメールボックス(文字列)
@param newname リネーム後の名前(文字列)
@raise Net::IMAP::NoResponseError 指定した名前のメールボックスを
       リネームできなかった場合に発生します。
       指定した名前のメールボックスが存在しない場合や、
       リネーム後の名前を持つメールボックスが既に存在する
       場合に発生します。


--- subscribe(mailbox) -> Net::IMAP::TaggedResponse
SUBSCRIBE コマンドを送り、指定したメールボックスを
"active" もしくは "subscribe" なメールボックスの集合に
追加します。

@param mailbox 追加するメールボックスの名前(文字列)
@raise Net::IMAP::NoResponseError 指定した名前のメールボックスを
       追加できなかった場合に発生します。
       指定した名前のメールボックスが存在しない場合などに
       生じます。

--- unsubscribe(mailbox) -> Net::IMAP::TaggedResponse
UNSUBSCRIBE コマンドを送り、指定したメールボックスを
"active" もしくは "subscribe" なメールボックスの集合から
削除します。

@param mailbox 削除するするメールボックスの名前(文字列)
@raise Net::IMAP::NoResponseError 指定した名前のメールボックスを
       削除できなかった場合に発生します。
       指定した名前のメールボックスが active/subscribe でなかった
       場合などに発生します。

--- list(refname, mailbox) -> [Net::IMAP::MailboxList] | nil

LIST コマンドを送り、クライアントから利用可能なメールボックス名の集合から
引数にマッチするものすべてを返します。

詳しくは  [[RFC:2060]] の 6.3.8 を参照してください。

返り値は [[c:Net::IMAP::MailboxList]] の配列で返します。
返り値が空集合である場合は空の配列でなく nil を返します。

@param refname 参照名(文字列)
@param mailbox 調べるメールボックスの名前(文字列)。ワイルドカードを含んでいてもかまいません。

例:
  imap.create("foo/bar")
  imap.create("foo/baz")
  p imap.list("", "foo/%")
  #=> [#<Net::IMAP::MailboxList attr=[:Noselect], delim="/", name="foo/">, #<Net::IMAP::MailboxList attr=[:Noinferiors, :Marked], delim="/", name="foo/bar">, #<Net::IMAP::MailboxList attr=[:Noinferiors], delim="/", name="foo/baz">]

#@since 1.9.3
--- xlist(refname, mailbox) -> [Net::IMAP::MailboxList]

XLISTコマンドを送り、クライアントから利用可能なメールボックス名の集合から
引数にマッチするものすべてを返します。

[[m:Net::IMAP#list]] とほぼ同様ですが、
「:Sent」などの拡張されたフラグを含むことが異なります。

詳しくは
[[url:http://code.google.com/apis/gmail/imap/]]
を参照してください。

@param refname 参照名(文字列)
@param mailbox 調べるメールボックスの名前(文字列)。ワイルドカードを含んでいてもかまいません。

例:
  imap.create("foo/bar")
  imap.create("foo/baz")
  p imap.xlist("", "foo/%")
  #=> [#<Net::IMAP::MailboxList attr=[:Noselect], delim="/", name="foo/">, \\
  #    #<Net::IMAP::MailboxList attr=[:Noinferiors, :Marked], delim="/", name="foo/bar">, \\
  #    #<Net::IMAP::MailboxList attr=[:Noinferiors], delim="/", name="foo/baz">]

#@end

--- lsub(refname, mailbox) -> [Net::IMAP::MailboxList]

LIST コマンドを送り、active/subscribed なメールボックス名の集合から
引数にマッチするものすべてを返します。

詳しくは  [[RFC:2060]] の 6.3.8 を参照してください。

返り値は [[c:Net::IMAP::MailboxList]] の配列で返します。
返り値が空集合である場合は空の配列でなく nil を返します。

@param refname 参照名(文字列)
@param mailbox 調べるメールボックスの名前(文字列)。ワイルドカードを含んでいてもかまいません。

--- status(mailbox, attr) -> {String => Integer}
STATUS コマンドを送り、mailbox のステータスを得ます。

問い合わせたいステータスは attr に文字列の配列で渡します。

返り値は アトリビュート文字列をキーとするハッシュです。

詳しくは [[RFC:2060]] の 6.3.10 を参考にしてください。

例:
  p imap.status("inbox", ["MESSAGES", "RECENT"])
  #=> {"RECENT"=>0, "MESSAGES"=>44}

@param mailbox 問い合わせ対象のメールボックス(文字列)
@param attr 問合せたいアトリビュート名(文字列)の配列
@raise Net::IMAP::NoResponseError メールボックスが存在しない場合や、
       アトリビュート名が存在しない場合に発生します

--- append(mailbox, message, flags = nil, date_time = nil) -> Net::IMAP::TaggedResponse

APPEND コマンドを送ってメッセージをメールボックスの末尾に追加します。


例:
  imap.append("inbox", <<EOF.gsub(/\n/, "\r\n"), [:Seen], Time.now)
  Subject: hello
  From: someone@example.com
  To: somebody@example.com
  
  hello world
  EOF

@param mailbox メッセージを追加するメールボックス名(文字列)
@param message メッセージ文字列
@param flags メッセージに付加するフラグ([[c:Symbol]] の配列)
@param date_time メッセージの時刻([[c:Time]] オブジェクト)。省略時は現在時刻が使われる
@raise Net::IMAP::NoResponseError メールボックスが存在しない場合に発生します


--- check -> Net::IMAP::TaggedResponse
CHECK コマンドを送り、現在処理しているメールボックスの
チェックポイントを要求します。

チェックポイントの要求とは、サーバ内部で保留状態になっている
操作を完了させることを意味します。例えばメモリ上にあるメールの
データをディスクに書き込むため、fsyncを呼んだりすることです。
実際に何が行なわれるかはサーバの実装によりますし、何も行なわれない
場合もあります。


--- close -> Net::IMAP::TaggedResponse
CLOSE コマンドを送り、処理中のメールボックスを閉じます。

このコマンドによって、どのメールボックスも選択されていない
状態に移行します。
そして \Deleted フラグが付けられたメールがすべて削除されます。

--- expunge -> [Integer] | nil
EXPUNGEコマンドを送り、:Deletedフラグをセットしたメッセージを
すべて処理中のメールボックスから削除します。

削除したメッセージの message sequence number を配列で返します。

@raise Net::IMAP::NoResponseError メールボックスが read-only である場合に発生します

--- search(keys, charset = nil) -> [Integer]
SEARCH コマンドを送り、条件に合うメッセージの message sequence number
を配列で返します。

[[m:Net::IMAP#examine]] もしくは [[m:Net::IMAP#select]] で
指定したメールボックスを検索対象とします。

検索の条件は key に文字列の1次元配列もしくは文字列で渡します。

検索条件は "SUBJECT", "FROM" などを用いることができます。
詳しくは [[RFC:2060]] の 6.4.4 を見てください。

例:
  p imap.search(["SUBJECT", "hello"])
  #=> [1, 6, 7, 8]
  p imap.search(["SUBJECT", "hello", "FROM", "foo@example.com"])
  #=> [6, 7]
  p imap.search('SUBJECT "hello"')
  #=> [1, 6, 7, 8]

@param key 検索キー(文字列の配列もしくは文字列)
@param charset 検索に用いるcharset
@see [[m:Net::IMAP#search]]

--- uid_search(keys, charset = nil) -> [Integer]

UID SEARCH コマンドを送り、条件に合うメッセージの UID
を配列で返します。

[[m:Net::IMAP#examine]] もしくは [[m:Net::IMAP#select]] で
指定したメールボックスを検索対象とします。

検索の条件は key に文字列の1次元配列もしくは文字列で渡します。

検索条件は "SUBJECT", "FROM" などを用いることができます。
詳しくは [[RFC:2060]] の 6.4.4 を見てください。

例:
  p imap.uid_search(["SUBJECT", "hello"])
  #=> [1, 6, 7, 8]
  p imap.uid_search(["SUBJECT", "hello", "FROM", "foo@example.com"])
  #=> [6, 7]
  p imap.uid_search('SUBJECT "hello"')
  #=> [1, 6, 7, 8]

@param key 検索キー(文字列の配列もしくは文字列)
@param charset 検索に用いるcharset
@see [[m:Net::IMAP#uid_search]]

--- fetch(set, attr) -> [Net::IMAP::FetchData]

FETCH コマンドを送り、メールボックス内のメッセージに
関するデータを取得します。

[[m:Net::IMAP#examine]] もしくは [[m:Net::IMAP#select]] で
指定したメールボックスを対象とします。

set で対象とするメッセージを指定します。
これには sequence number、sequence number の配列、もしくは
[[c:Range]] オブジェクトを渡します。
attr には取得するアトリビュートを文字列の配列で渡してください。
指定可能なアトリビュートについては [[m:Net::IMAP::FetchData#attr]] 
を見てください。

例:

  p imap.fetch(6..8, "UID")
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"UID"=>98}>, #<Net::IMAP::FetchData seqno=7, attr={"UID"=>99}>, #<Net::IMAP::FetchData seqno=8, attr={"UID"=>100}>]
  p imap.fetch(6, "BODY[HEADER.FIELDS (SUBJECT)]")
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"BODY[HEADER.FIELDS (SUBJECT)]"=>"Subject: test\r\n\r\n"}>]
  data = imap.uid_fetch(98, ["RFC822.SIZE", "INTERNALDATE"])[0]
  p data.seqno
  #=> 6
  p data.attr["RFC822.SIZE"]
  #=> 611
  p data.attr["INTERNALDATE"]
  #=> "12-Oct-2000 22:40:59 +0900"
  p data.attr["UID"]
  #=> 98

@param set 処理対象のメッセージの sequence number
@param attr アトリビュート(文字列配列)
@see [[m:Net::IMAP#uid_fetch]]

--- uid_fetch(set, attr) -> [Net::IMAP::FetchData]

UID FETCH コマンドを送り、メールボックス内のメッセージに
関するデータを取得します。

[[m:Net::IMAP#examine]] もしくは [[m:Net::IMAP#select]] で
指定したメールボックスを対象とします。

set で対象とするメッセージを指定します。
これには UID、UID の配列、もしくは
[[c:Range]] オブジェクトを渡します。
attr には取得するアトリビュートを文字列の配列で渡してください。
指定可能なアトリビュートについては [[m:Net::IMAP::FetchData#attr]] 
を見てください。

@param set 処理対象のメッセージの UID
@param attr アトリビュート(文字列配列)
@see [[m:Net::IMAP#fetch]]

--- store(set, attr, flags) -> [Net::IMAP::FetchData] | nil
STORE コマンドを送り、メールボックス内のメッセージを
更新します。

set で更新するメッセージを指定します。
これには sequence number、sequence number の配列、もしくは
[[c:Range]] オブジェクトを渡します。

[[m:Net::IMAP#select]] で指定したメールボックスを対象とします。

attr で何をどのように変化させるかを指定します。
以下を指定することができます。
  * "FLAGS"
  * "+FLAGS"
  * "-FLAGS"
それぞれメッセージのフラグの置き換え、追加、削除を意味します。
詳しくは [[RFC:2060]] の 6.4.6 を参考にしてください。

flags には シンボルの配列で置き換え、追加もしくは削除される
フラグを指定します。

返り値は更新された内容を [[c:Net::IMAP::FetchData]] オブジェクトの
配列で返します。

例:

  p imap.store(6..8, "+FLAGS", [:Deleted])
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=7, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=8, attr={"FLAGS"=>[:Seen, :Deleted]}>]

@param set 更新するメッセージのsequence number
@param attr 更新方式(文字列)
@param flags 更新内容([[c:Symbol]] の配列)
@see [[m:Net::IMAP#uid_store]], [[m:Net::IMAP#fetch]]

--- uid_store(set, attr, flags) -> [Net::IMAP::FetchData] | nil

UID STORE コマンドを送り、メールボックス内のメッセージを
更新します。

set で更新するメッセージを指定します。
これには UID、UID の配列、もしくは
[[c:Range]] オブジェクトを渡します。

[[m:Net::IMAP#select]] で指定したメールボックスを対象とします。

attr で何をどのように変化させるかを指定します。
以下を指定することができます。
  * "FLAGS"
  * "+FLAGS"
  * "-FLAGS"
それぞれメッセージのフラグの置き換え、追加、削除を意味します。
詳しくは [[RFC:2060]] の 6.4.6 を参考にしてください。

返り値は更新された内容を [[c:Net::IMAP::FetchData]] オブジェクトの
配列で返します。

@param set 更新するメッセージの UID
@param attr 更新方式(文字列)
@param flags 更新内容([[c:Symbol]] の配列)

@see [[m:Net::IMAP#store]], [[m:Net::IMAP#uid_fetch]]

--- copy(set, mailbox) -> Net::IMAP::TaggedResponse
COPY コマンドを送り、指定したメッセージを
指定したメールボックスの末尾に追加します。

set でコピーするメッセージを指定します。
message sequence number(整数)、
message sequence numberの配列、もしくは [[c:Range]] で
指定します。コピー元のメールボックスは
[[m:Net::IMAP#examine]] もしくは [[m:Net::IMAP#select]] で
指定したものを用います。
mailbox はコピー先のメールボックスです。

@param set コピーするメッセージの message sequence number
@param mailbox コピー先のメールボックス(文字列)
@see [[m:Net::IMAP#uid_copy]]

--- uid_copy(set, mailbox) -> Net::IMAP::TaggedResponse
UID COPY コマンドを送り、指定したメッセージを
指定したメールボックスの末尾に追加します。

set でコピーするメッセージを指定します。
UID (整数)、
UID の配列、もしくは [[c:Range]] で
指定します。コピー元のメールボックスは
[[m:Net::IMAP#examine]] もしくは [[m:Net::IMAP#select]] で
指定したものを用います。
mailbox はコピー先のメールボックスです。

@param set コピーするメッセージの UID
@param mailbox コピー先のメールボックス(文字列)
@see [[m:Net::IMAP#copy]]

--- sort(sort_keys, search_keys, charset) -> [Integer]
--- uid_sort(sort_keys, search_keys, charset) -> [Integer]
SORT コマンド送り、メールボックス内の
メッセージをソートした結果を返します。

SORT コマンドは [[RFC:5256]] で定義されています。
詳しくはそちらを参照してください。
このコマンドは [[m:Net::IMAP#capability]] の返り値を見ることで
利用可能かどうか判断できます。

sort_keys にはソート順を決めるキーを文字列の配列で指定します。
"ARRIVAL", "CC", "FROM", "TO", "SUBJECT" などが指定できます。
詳しくは [[RFC:5265]] の BASE.6.4.SORT の所を見てください。

search_key には検索条件を渡します。[[m:Net::IMAP#search]] と
ほぼ同じです。この条件にマッチするメッセージのみがソートされます。

[[m:Net::IMAP#examine]] もしくは
[[m:Net::IMAP#select]] で指定したメールボックスを対象とします。

返り値は message sequence number の配列を返します。

例:
  p imap.sort(["FROM"], ["ALL"], "US-ASCII")
  #=> [1, 2, 3, 5, 6, 7, 8, 4, 9]
  p imap.sort(["DATE"], ["SUBJECT", "hello"], "US-ASCII")
  #=> [6, 7, 8, 1]
@param sort_key ソート順のキー(文字列配列)
@param search_key 検索条件(文字列配列)
@param charset 検索条件の解釈に用いるCHARSET名(文字列)

--- setquota(mailbox, quota) -> Net::IMAP::TaggedResponse
SETQUOTA コマンドを送り、指定したメールボックスに
quota を設定します。

quota が nil ならば、mailbox の quota を破棄します。
quota が整数なら STORAGE をその値に変更します。

詳しくは [[RFC:2087]] を見てください。
このコマンドは [[m:Net::IMAP#capability]] の返り値を見ることで
利用可能かどうか判断できます。

@param mailbox quota を設定するメールボックス名(文字列)
@param quota quotaの値(ストレージのサイズ、もしくは nil)
@raise Net::IMAP::NoResponseError 指定したメールボックスが quota root 
       でない場合、もしくは権限が存在しない場合に発生します。

--- getquota(mailbox) -> [Net::IMAP::MailboxQuota]
GETQUOTA コマンドを送って
指定したメールボックスの quota の情報を返します。

quota の情報は [[c:Net::IMAP::MailboxQuota]] オブジェクトの配列で
得られます。

詳しくは [[RFC:2087]] を見てください。
このコマンドは [[m:Net::IMAP#capability]] の返り値を見ることで
利用可能かどうか判断できます。

@param mailbox quota 情報を得たいメールボックス名
@raise Net::IMAP::NoResponseError 指定したメールボックスが quota root でない場合に発生します

--- getquotaroot(mailbox) -> [Net::IMAP::MailboxQuotaRoot | Net::IMAP::MailboxQuota]
GETQUOTAROOT コマンドを送って
指定したメールボックスの quota root の一覧と、
関連する quota の情報を返します。

quota root の情報は [[c:Net::IMAP::MailboxQuotaRoot]] のオブジェクトで、
返り値の配列の中に唯一含まれています。
quota の情報はメールボックスに関連付けられた quota root ごとに
[[c:Net::IMAP::MailboxQuota]] オブジェクトで得られます。

詳しくは [[RFC:2087]] を見てください。
このコマンドは [[m:Net::IMAP#capability]] の返り値を見ることで
利用可能かどうか判断できます。

@param mailbox quota root を得たいメールボックス名(文字列)
@raise Net::IMAP::NoResponseError 指定したメールボックスが存在しない場合に発生します

--- setacl(mailbox, user, rights)

SETACL コマンドを送り、指定したメールボックスに
指定したユーザに関する権限を設定します。

rights には設定する権限を表す文字列を指定します。
どのような文字列を指定すべきかは [[RFC:2086]] を参照してください。
rights に nil を渡すと、空文字列を指定したのと同様、つまり
すべての権限を削除します。

@param mailbox 権限を設定するメールボックスの名前(文字列)
@param user 権限を設定するユーザの名前(文字列)
@param rights 権限を表す文字列

--- getacl(mailbox) -> [Net::IMAP::MailboxACLItem]
GETACL コマンドを送り、メールボックスの 
ACL(Access Control List) を取得します。

[[m:Net::IMAP#getacl]] で指定したメールボックスに
対し何らかの権限を持つ各ユーザに対して
[[c:Net::IMAP::MailboxACLItem]] オブジェクトが
作られ、その配列が返されます。

GETACL コマンドは [[RFC:2086]] で定義されています。
詳しくはそちらを参照してください。

@param mailbox メールボックス名(文字列)
@see [[c:Net::IMAP::MailboxACLItem]]

--- add_response_handler(handler) -> ()
--- add_response_handler(handler){|resp| ...} -> ()
レスポンスハンドラを追加します。

レスポンスハンドラはサーバから応答を受け取るごとに
呼びだされます。ハンドラには
[[c:Net::IMAP::TaggedResponse]] もしくは
[[c:Net::IMAP::UntaggedResponse]] オブジェクトが
渡されます。

主にサーバからの非同期的なイベントを受け取るため
に用います。例えば EXISTS 応答を受け取る
(メールボックスに新たなメールが追加されたタイミングで発生します)
ためなどに用いられます。

レスポンスハンドラはメインのスレッドとは別のスレッドで
呼びだされることに注意してください。

例:

  imap.add_response_handler do |resp|
    p resp
  end

@param handler 追加するハンドラ([[c:Proc]] や [[c:Method]] オブジェクト)
@see [[m:Net::IMAP#remove_response_handler]]

--- remove_response_handler(handler) -> ()
レスポンスハンドラを削除します。

@param handler 削除するハンドラ
@see [[m:Net::IMAP#add_response_handler]]

--- response_handlers -> Array
設定されているレスポンスハンドラ全てを
配列で返します。

@see [[m:Net::IMAP#add_response_handler]]

#@since 1.9.1
--- starttls(options) -> Net::IMAP::TaggedResponse
--- starttls(certs, verify) -> Net::IMAP::TaggedResponse

STARTTLS コマンドを送って TLS のセッションを開始します。

options で [[lib:openssl]] に渡すオプションを指定します。
[[m:OpenSSL::SSL::SSLContext#set_params]] の引数と同じ意味です。

互換性のため、certs で証明書or証明書ディレクトリのファイル名(文字列)、
verify で検証するかどうか([[m:Net::IMAP::VERIFY_PEER]]、
[[m:Net::IMAP::VERIFY_NONE]]に対応します)を
指定することができます。

@param options SSL/TLS のオプション([[c:Hash]] オブジェクト)
@param certs 証明書ファイル名、もしくは証明書ディレクトリ名(文字列)
@param verify 真なら SSL/TLS 接続時に証明書を検証します

#@end

#@since 1.8.2
--- disconnected? -> bool

サーバとの接続が切断されていれば真を返します。

@see [[m:Net::IMAP#disconnect]]

#@end

--- thread(algorithm, search_keys, charset) -> [Net::IMAP::ThreadMember]
THREADコマンドを送り、メールボックスを検索した結果を
スレッド形式の木構造で返します。

THREAD コマンドは [[RFC:5256]] で定義されています。
詳しくはそちらを参照してください。
このコマンドは [[m:Net::IMAP#capability]] の返り値を見ることで
利用可能かどうか判断できます。

algorithm は木構造を決定するためのアルゴリズムを指定します。
以下の2つが利用可能です。
  * "ORDEREDSUBJECT" subjectを使って平坦に区切るだけ
  * "REFERENCES" どのメッセージに返事をしているかを見て木構造を作る
詳しくは [[RFC:5256]] を見てください。

search_key には検索条件を渡します。
[[m:Net::IMAP#search]] と同等です。


@param algorithm スレッド構造構築アルゴリズム名(文字列)
@param search_key 検索条件(文字列配列)
@param charset 検索条件の解釈に用いるCHARSET名(文字列)
@see [[c:Net::IMAP::ThreadMember]], [[m:Net::IMAP#uid_thread]]

--- uid_thread(algorithm, search_keys, charset)  -> [Net::IMAP::ThreadMember]
THREADコマンドを送り、メールボックスを検索した結果を
スレッド形式の木構造で返します。

ほぼ [[m:Net::IMAP#thread]] と同じですが、返ってくるオブジェクトの
[[m:Net::IMAP::ThreadMember#seqno]] の内容が message sequence number
ではなく UID となります。

@param algorithm スレッド構造構築アルゴリズム名(文字列)
@param search_key 検索条件(文字列配列)
@param charset 検索条件の解釈に用いるCHARSET名(文字列)
@see [[c:Net::IMAP::ThreadMember]], [[m:Net::IMAP#thread]]


--- client_thread -> Thread
#@until 1.9.1
例外が送出されるスレッドを返します。

#@else
このメソッドは obsolete です。使わないでください。
#@end

--- client_thread=(th)
#@until 1.9.1
例外が送出されるスレッドを設定します。

@param th 設定するスレッド
#@else
このメソッドは obsolete です。使わないでください。
#@end

#@since 1.9.2
--- idle {|resp| ...} -> Net::IMAP::TaggedResponse
IDLE 命令を送り、メールボックスの非同期的変化を待ち受けます。

このメソッドに渡したブロックは
[[m:Net::IMAP#add_response_handler]] によって
レスポンスハンドラとして用いられます。
また、このメソッドが終了する時点で
[[m:Net::IMAP#remove_response_handler]] で
ハンドラが削除されます。

レスポンスハンドラについては
[[m:Net::IMAP#add_response_handler]] を参照してください。

別のスレッドが [[m:Net::IMAP#idle_done]] を呼びだすまで
このメソッドを呼びだしたスレッドは停止します。

この命令は [[RFC:2177]] で定義されています。詳しくはそちらを
参照してください。

--- idle_done -> ()
[[m:Net::IMAP#idle]] で
停止しているスレッドを1つ起こします。
#@end

== Constants
--- SEEN -> Symbol
「:Seen」というシンボルを返します。

そのメッセージが既に読まれていることを意味します。

フラグメッセージ属性として用いられます
([[m:Net::IMAP::FetchData#attr]])。

詳しくは [[RFC:2060]] を参照してください。

--- ANSWERED -> Symbol
「:Answered」というシンボルを返します。

そのメッセージに返答したことを意味します。

フラグメッセージ属性として用いられます
([[m:Net::IMAP::FetchData#attr]])。

詳しくは [[RFC:2060]] を参照してください。

--- FLAGGED -> Symbol
「:Flagged」というシンボルを返します。

そのメッセージに特別なフラグを立てていることを意味します。

フラグメッセージ属性として用いられます
([[m:Net::IMAP::FetchData#attr]])。

詳しくは [[RFC:2060]] を参照してください。

--- DELETED -> Symbol
「:Deleted」というシンボルを返します。

メッセージが削除されていることを意味します。
EXPUNGE で完全に除去されます。

フラグメッセージ属性として用いられます
([[m:Net::IMAP::FetchData#attr]])。

詳しくは [[RFC:2060]] を参照してください。

--- DRAFT -> Symbol
「:Draft」というシンボルを返します。

メッセージが草稿であることを意味します。

フラグメッセージ属性として用いられます
([[m:Net::IMAP::FetchData#attr]])。

詳しくは [[RFC:2060]] を参照してください。

--- RECENT -> Symbol
「:Recent」というシンボルを返します。

メッセージが「最近」メールボックスに到着したことを意味します。

フラグメッセージ属性として用いられます
([[m:Net::IMAP::FetchData#attr]])。

詳しくは [[RFC:2060]] を参照してください。

--- NOINFERIORS -> Symbol
「:Noinferiors」というシンボルを返します。

このメールボックスの
下に子レベルの階層が存在不可能であることを意味します。

LIST応答の属性
([[m:Net::IMAP#list]]、[[m:Net::IMAP::MailboxList#attr]])
として用いられます。

詳しくは [[RFC:2060]] を参照してください。


--- NOSELECT -> Symbol
「:Noselect」というシンボルを返します。

メールボックスが選択可能でないことを意味します。

LIST応答の属性
([[m:Net::IMAP#list]]、[[m:Net::IMAP::MailboxList#attr]])
として用いられます。

詳しくは [[RFC:2060]] を参照してください。
--- MARKED -> Symbol
「:Marked」というシンボルを返します。

メールボックスが「interesting」であるとサーバによって
印付けられていることを意味します。通常メールボックスに
新しいメールが届いていることを意味します。

LIST応答の属性
([[m:Net::IMAP#list]]、[[m:Net::IMAP::MailboxList#attr]])
として用いられます。

詳しくは [[RFC:2060]] を参照してください。

--- UNMARKED -> Symbol
「:Unmarked」というシンボルを返します。

メールボックスが
印付けられていないことを意味します。
メールボックスに新しいメールが届いていないことを意味します。

LIST応答の属性
([[m:Net::IMAP#list]]、[[m:Net::IMAP::MailboxList#attr]])
として用いられます。

詳しくは [[RFC:2060]] を参照してください。

= class Net::IMAP::ContinuationRequest < Struct

IMAP の continuation request (命令継続要求) を表すクラスです。

通常このクラスを直接扱うことはありません。
レスポンスハンドラ([[c:Net::IMAP#add_response_handler]])
に渡されます。

詳しくは [[RFC:2060]] の 7.5 を参照してください。

== Instance Methods

--- data -> Net::IMAP::ResponseText
レスポンスのデータを返します。

--- raw_data -> String
レスポンス文字列を返します。

= class Net::IMAP::UntaggedResponse < Struct

IMAP のタグ付きレスポンスを表すクラスです。

IMAP のレスポンスにはタグ付きのものとタグなしのものがあり、
タグなしのものはクライアントからのコマンド完了応答ではない
レスポンスです。

@see [[c:Net::IMAP::TaggedResponse]]

== Instance Methods

--- name -> String

レスポンスの名前(種類)を返します。

例えば以下のような値を返します。これらの具体的な意味は
[[RFC:2060]] を参考にしてください。
  * "OK"
  * "NO"
  * "BAD"
  * "BYE"
  * "PREAUTH"
  * "CAPABILITY"
  * "LIST"
  * "FLAGS"
  *  etc

--- data -> object

レスポンスを解析した結果のオブジェクトを返します。

レスポンスによって異なるオブジェクトを返します。
[[c:Net::IMAP::MailboxList]] であったりフラグを表わす
シンボルの配列であったりします。

--- raw_data -> String

レスポンス文字列を返します。

@see [[m:Net::IMAP::UntaggedResponse#data]]
= class Net::IMAP::TaggedResponse < Struct

IMAP のタグ付きレスポンスを表すクラスです。

IMAP のレスポンスにはタグ付きのものとタグなしのものがあり、
タグ付きのレスポンスはクライアントが発行したコマンドによる
操作が成功するか失敗するかのどちらかで
完了したことを意味します。タグによって
どのコマンドが完了したのかを示します。

@see [[c:Net::IMAP::UntaggedResponse]]

== Instance Methods

--- tag -> String

レスポンスに対応付けられたタグを返します。

--- name -> String

レスポンスの名前(種類)を返します。

例えば以下のような値を返します。これらの具体的な意味は
[[RFC:2060]] を参考にしてください。
  * "OK"
  * "NO"
  * "BAD"

--- data -> Net::IMAP::ResponseText 

レスポンスを解析したオブジェクトを返します。

@see [[c:Net::IMAP::ResponseText]]

--- raw_data -> String

レスポンス文字列を返します。

@see [[m:Net::IMAP::TaggedResponse#data]]

= class Net::IMAP::ResponseText < Struct

応答のテキストを表すクラスです。

== Instance Methods

--- code -> Net::IMAP::ResponseCode | nil
レスポンスコードを返します。

応答がレスポンスコードを含んでいない場合は nil を返します。

@see [[c:Net::IMAP::ResponseCode]]

--- text -> String
応答のテキストを文字列で返します。

= class Net::IMAP::ResponseCode < Struct

応答のレスポンスコードを表すクラスです。

レスポンスコードについては [[RFC:2060]] の 7.1 を参照してください。

== Instance Methods

--- name -> String
レスポンスコードを表す文字列を返します。
 
"ALERT"、"PERMANENTFLAGS"、"UIDVALIDITY" などを返します。

--- data -> object | nil
レスポンスコードのデータを返します。

レスポンスコードの種類によって返すオブジェクトは異なります。
ない場合は nil を返します。

= class Net::IMAP::MailboxList < Struct

#@since 1.9.3
[[m:Net::IMAP#list]]、[[m:Net::IMAP#xlist]]、[[m:Net::IMAP#lsub]]
#@else
[[m:Net::IMAP#list]]、[[m:Net::IMAP#lsub]]
#@end
で返されるメールボックスのデータを表します。

== Instance Methods

--- attr -> [Symbol]
メールボックスの属性をシンボルの配列で返します。

これで得られるシンボルは [[m:String#capitalize]] でキャピタライズ
されています。

この配列には例えば以下のような値を含んでいます。
詳しくは [[RFC:2060]] 7.2.2 などを参照してください。
以下のもの以外で、IMAP 関連 RFC で拡張された値を含んでいる
場合もあります
  * :Noselect
  * :Noinferiors
  * :Marked
  * :Unmarked

--- delim -> String|nil
階層区切り文字列を返します。

まったく階層が存在しない場合は nil を返します。

--- name -> String
メールボックスの名前を文字列で返します。


= class Net::IMAP::MailboxQuota < Struct

[[m:Net::IMAP#getquota]] や [[m:Net::IMAP#getquotaroot]] で得られる
quota の情報を表すオブジェクトです。

詳しくは [[RFC:2087]] を参照してください。


== Instance Methods

--- mailbox -> String
quota が設定されているメールボックスの名前を返します。

--- usage -> Integer
現在のメールボックス内の使用量を返します。

--- quota -> Integer
メールボックスに指定されている上限値を返します。


= class Net::IMAP::MailboxQuotaRoot < Struct

[[m:Net::IMAP#getquotaroot]] の結果として得られる
quota root 情報を表わすオブジェクトです。

詳しくは [[RFC:2087]] を参照してください。

== Instance Methods

--- mailbox -> String
問い合わせしたメールボックスの名前を返します。

--- quotaroots -> [String]
問い合わせしたメールボックスの quota root 名を配列で返します。

空の場合もありえます。


= class Net::IMAP::MailboxACLItem < Struct

GETACL の応答の各要素を表すクラスです。

[[m:Net::IMAP#getacl]] の返り値として用いられます。

詳しくは [[RFC:2086]] を参照してください。

== Instance Methods

--- user -> String
ユーザ名を返します。

このユーザは
[[m:Net::IMAP#getacl]] で指定したメールボックスに
対し何らかの権限を持っています。

--- rights -> String
アクセス権限を文字列で返します。

[[m:Net::IMAP::MailboxACLItem#user]] で得られるユーザが
持っている権限が返されます。

この文字列の意味については [[RFC:2086]] を参照してください。

= class Net::IMAP::StatusData < Struct
STATUS 応答を表わすクラスです。

== Instance Methods

--- mailbox -> String
メールボックス名を返します。

--- attr -> { String => Integer }
STATUS 応答の内容をハッシュで返します。

ハッシュのキーは
"MESSAGES", "RECENT", "UIDNEXT", "UIDVALIDITY", "UNSEEN"
などが使われます。

詳しくは [[RFC:2060]] の 6.3.10、7.2.4 を見てください。

= class Net::IMAP::FetchData < Object

FETCH コマンドの応答を表すクラスです。

[[m:Net::IMAP#fetch]]、[[m:Net::IMAP#uid_fetch]]、
[[m:Net::IMAP#store]]、[[m:Net::IMAP#uid_store]] の
返り値として利用されます。

== Instance Methods

--- seqno -> Integer

メッセージの sequence number を返します。

[[m:Net::IMAP#uid_fetch]]、[[m:Net::IMAP#uid_store]]であっても
UID ではなく、sequence numberを返します。

--- attr -> { String => object }

各メッセージのアトリビュートの値をハッシュテーブルで返します。

キーはアトリビュート名の文字列、値はアトリビュートの値となります。
値のクラスはアトリビュートによって異なります。

利用可能なアトリビュートは以下の通りです。

: BODY
    BODYSTRUCTURE の拡張データなしの形式。
    [[c:Net::IMAP::BodyTypeBasic]], [[c:Net::IMAP::BodyTypeText]],
    [[c:Net::IMAP::BodyTypeMessage]], [[c:Net::IMAP::BodyTypeMultipart]]
    のいずれか。
: BODY[<section>]<<partial>>
    section で指定されたセクションのボディの内容。文字列。
: BODY.PEEK[<section>]<<partial>>
    section で指定されたセクションのメッセージボディの内容。文字列。
    ただしこれで内容を見ても :Seen フラグを設定しない点が
    BODY[<section>]と同様
: BODYSTRUCTURE
    MIME-IMB でのメッセージボディ。
    [[c:Net::IMAP::BodyTypeBasic]], [[c:Net::IMAP::BodyTypeText]],
    [[c:Net::IMAP::BodyTypeMessage]], [[c:Net::IMAP::BodyTypeMultipart]]
    のいずれか。
: ENVELOPE
    メッセージのエンベロープ。
    [[c:Net::IMAP::Envelope]] オブジェクト。
: FLAGS
    メッセージにセットされたフラグ。
    [[c:Symbol]] の配列。[[m:String#capitalize]] でキャピタライズ
    されている。
: INTERNALDATE
    メッセージの内部日付。文字列。
: RFC822
    BODY[] と同じ。文字列。
: RFC822.HEADER
    BODY.PEEK[HEADER] と同じ。文字列。
: RFC822.SIZE
    メッセージの [[RFC:822]] サイズ。整数。
: RFC822.TEXT
    BODY[TEXT] と同じ。文字列。
: UID
    UID。整数。

詳しくは [[RFC:2060]] の FETCH command の節を見てください。

@see [[m:Net::IMAP#fetch]], [[m:Net::IMAP#uid_fetch]]

= class Net::IMAP::Envelope < Struct

メッセージのエンベロープを表すクラスです。

[[m:Net::IMAP::FetchData#attr]] の要素として用いられます。

== Instance Methods

--- date -> String | nil
日付の文字列を返します。

エンベロープに存在しないときは nil を返します。

--- subject -> String | nil
メッセージのサブジェクトを返します。

エンベロープに存在しないときは nil を返します。


--- from -> [Net::IMAP::Address] | nil
From を [[c:Net::IMAP::Address]] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。


--- sender -> [Net::IMAP::Address] | nil
Sender を [[c:Net::IMAP::Address]] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。


--- reply_to -> [Net::IMAP::Address] | nil
Reply-To を [[c:Net::IMAP::Address]] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。


--- to -> [Net::IMAP::Address] | nil
To を [[c:Net::IMAP::Address]] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。


--- cc -> [Net::IMAP::Address] | nil
Cc を [[c:Net::IMAP::Address]] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。


--- bcc -> [Net::IMAP::Address] | nil
Bcc を [[c:Net::IMAP::Address]] オブジェクトの配列で返します。

エンベロープに存在しないときは nil を返します。


--- in_reply_to -> String | nil
In-reply-to の内容を文字列で返します。

エンベロープに存在しないときは nil を返します。

--- message_id -> String | nil
message_id を文字列で返します。

エンベロープに存在しないときは nil を返します。

= class Net::IMAP::Address < Struct

メールアドレスを表すクラスです。

== Instance Methods

--- name -> String | nil
メールアドレスの [[RFC:822]] の個人名(personal name)を返します。

個人名が存在しない場合は nil を返します。

通常は nil を返します。

--- route -> String | nil
メールアドレスの SMTP at-domain-list を返します。

存在しない場合は nil を返します。

通常は nil を返します。

--- mailbox -> String | nil
メールアドレスのメールボックス名を返します。

これが nil ならばそれは [[RFC:822]] group の終わりを意味します。
これが nil でなく、[[m:Net::IMAP::Address#mailbox]] が nil ならば、
[[RFC:822]] のグループ名を表します。
どれでもなければ、[[RFC:822]] の local-part を表します。

通常は、メールアドレスの「@」の手前を返します。

--- host -> String | nil
メールアドレスのホスト名を返します。

nil は [[RFC:822]] のグループ文法に対応します。
これについては [[m:Net::IMAP::Address#mailbox]] も参照してください。
そうでない場合は [[RFC:822]] のドメイン名を表します。

通常は、メールアドレスの「@」の後ろのドメイン名を返します。

= class Net::IMAP::ContentDisposition < Struct

[[RFC:1806]], [[RFC:2183]] で定義されている MIME の
Content-Disposition フィールドを表すクラスです。

== Instance Methods

--- dsp_type -> String
Content-Disposition フィールドのタイプを文字列で返します。

"INLINE", "ATTACHMENT" などの文字列を返します。

詳しくは [[RFC:2183]] などを見てください。

--- param -> { String => String } | nil
Content-Disposition フィールドのパラメータをハッシュテーブルで
返します。

ハッシュテーブルのキーは以下のような値を取ります。詳しくは
[[RFC:2183]] などを見てください。
  * "FILENAME"
  * "CREATION-DATE"
  * "MODIFICATION-DATE"
  * "READ-DAT"
  * "SIZE"

= class Net::IMAP::ThreadMember < Struct

[[m:Net::IMAP#thread]]、 [[m:Net::IMAP#uid_thread]] から
得られるスレッドの木構造のノードを表すクラスです。

== Instance Methods

--- seqno -> Integer | nil
メッセージの sequence number もしくは UID を返します。

root となるメッセージが存在しない場合しない木の場合は
nil を返します。

--- children -> [Net::IMAP::ThreadMember]
スレッドの木構造における自身の下位の部分を返します。


= class Net::IMAP::BodyTypeBasic < Struct

text 型([[c:Net::IMAP::BodyTypeText]])、
multipart 型([[c:Net::IMAP::BodyTypeMultipart]])、
message 型([[c:Net::IMAP::BodyTypeMessage]])、
のいずれでもないようなメッセージボディ構造を表すクラスです。

添付ファイルなどを表します。
詳しくは MIME のRFC([[RFC:2045]])を参照してください。

== Instance Methods

--- media_type -> String
MIME のメディアタイプを返します。

@see [[m:Net::IMAP::BodyTypeBasic#subtype]]

--- subtype -> String
--- media_subtype -> String
MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

@see [[m:Net::IMAP::BodyTypeBasic#media_type]]

--- param -> { String => String } | nil
MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

@see [[RFC:2045]]

--- content_id -> String | nil
Content-ID の値を文字列で返します。

@see [[RFC:2045]]
--- description -> String | nil
Content-Description の値を文字列で返します。

@see [[RFC:2045]]

--- encoding -> String
Content-Transfer-Encoding の値を文字列で返します。

@see [[RFC:2045]]

--- size -> Integer
ボディのサイズのオクテット数を返します。

--- md5 -> String | nil
ボディの MD5 値を文字列で返します。

--- disposition -> Net::IMAP::ContentDisposition | nil
Content-Dispotition の値を返します。

[[c:Net::IMAP::ContentDisposition]] オブジェクトを返します。

@see [[RFC:1806]], [[RFC:2183]]

--- language -> String | [String] | nil
[[RFC:1766]] で定義されているボディ言語を表わす
文字列もしくは文字列の配列を返します。

--- extension -> Array | nil
メッセージの拡張データを返します。

--- multipart? -> bool
マルチパートかどうかを返します。
false を返します。

= class Net::IMAP::BodyTypeText < Struct

Content-Type が text であるメッセージを表すクラスです。

平文のメールを表します。
詳しくは MIME のRFC([[RFC:2045]])を参照してください。

== Instance Methods

--- media_type -> String
MIME のメディアタイプを返します。

これは "TEXT" を返します。

@see [[m:Net::IMAP::BodyTypeText#subtype]]

--- subtype -> String
--- media_subtype -> String
MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

@see [[m:Net::IMAP::BodyTypeText#media_type]]

--- param -> { String => String } | nil
MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

@see [[RFC:2045]]

--- content_id -> String | nil
Content-ID の値を文字列で返します。

@see [[RFC:2045]]

--- description -> String | nil
Content-Description の値を文字列で返します。

@see [[RFC:2045]]

--- encoding -> String
Content-Transfer-Encoding の値を文字列で返します。

@see [[RFC:2045]]

--- size -> Integer
ボディのサイズのオクテット数を返します。

--- lines -> Integer
ボディの行数を返します。

--- md5 -> String | nil
ボディの MD5 値を文字列で返します。

--- disposition -> Net::IMAP::ContentDisposition | nil
Content-Dispotition の値を返します。

[[c:Net::IMAP::ContentDisposition]] オブジェクトを返します。

@see [[RFC:1806]], [[RFC:2183]]

--- language -> String | [String] | nil
[[RFC:1766]] で定義されているボディ言語を表わす
文字列もしくは文字列の配列を返します。


--- extension -> Array | nil
メッセージの拡張データを返します。

--- multipart? -> bool
マルチパートかどうかを返します。
false を返します。

= class Net::IMAP::BodyTypeMessage < Struct

Content-Type が "message" であるメッセージを表すクラスです。

メールをメールに添付した場合などに使われます。
詳しくは [[RFC:2045]], [[RFC:822]] を参照してください。


== Instance Methods

--- media_type -> String
MIME のメディアタイプを返します。

これは "MESSAGE" を返します。

@see [[m:Net::IMAP::BodyTypeMessage#subtype]]

--- subtype -> String
--- media_subtype -> String

MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

@see [[m:Net::IMAP::BodyTypeMessage#media_type]]

--- param -> { String => String } | nil
MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

@see [[RFC:2045]]

--- content_id -> String | nil
Content-ID の値を文字列で返します。

@see [[RFC:2045]]

--- description -> String | nil
Content-Description の値を文字列で返します。

@see [[RFC:2045]]

--- encoding -> String
Content-Transfer-Encoding の値を文字列で返します。

@see [[RFC:2045]]

--- size -> Integer
ボディのサイズのオクテット数を返します。

--- envelope -> Net::IMAP::Envelpe | nil
メッセージのエンベロープを返します。

--- body -> Net::IMAP::BodyTypeBasic | Net::IMAP::BodyTypeMessage | Net::IMAP::BodyTypeText | Net::IMAP::BodyTypeMultipart

ボディを返します。

--- lines -> Integer
ボディのテキストの行数を返します。

--- md5 -> String | nil
ボディの MD5 値を文字列で返します。

--- disposition -> Net::IMAP::ContentDisposition | nil
Content-Dispotition の値を返します。

[[c:Net::IMAP::ContentDisposition]] オブジェクトを返します。

@see [[RFC:1806]], [[RFC:2183]]

--- language -> String | [String] | nil
[[RFC:1766]] で定義されているボディ言語を表わす
文字列もしくは文字列の配列を返します。

--- extension  -> Array | nil
メッセージの拡張データを返します。

--- multipart?  -> bool
マルチパートかどうかを返します。
false を返します。


= class Net::IMAP::BodyTypeMultipart < Struct

マルチパートなメッセージを表すクラスです。

詳しくは MIME のRFC([[RFC:2045]])を参照してください。

== Instance Methods

--- media_type -> String
MIME のメディアタイプを返します。

"MULTIPART" を返します。

@see [[m:Net::IMAP::BodyTypeMultipart#subtype]]

--- subtype -> String
--- media_subtype -> String
MIME のメディアタイプのサブタイプを返します。
 
media_subtype は obsolete です。

@see [[RFC:2045]], [[m:Net::IMAP::BodyTypeText#media_type]]

--- parts -> [Net::IMAP::BodyTypeBasic | Net::IMAP::BodyTypeText | Net::IMAP::BodyTypeMessage | Net::IMAP::BodyTypeMultipart]

マルチパートの各部分を返します。

--- param -> { String => String }
MIME のボディパラメータをハッシュテーブルで返します。

ハッシュテーブルのキーがパラメータ名となります。

@see [[RFC:2045]]

--- disposition -> Net::IMAP::ContentDisposition | nil
Content-Dispotition の値を返します。

[[c:Net::IMAP::ContentDisposition]] オブジェクトを返します。

@see [[RFC:1806]], [[RFC:2183]]

--- language -> String | [String] | nil
[[RFC:1766]] で定義されているボディ言語を表わす
文字列もしくは文字列の配列を返します。

--- extension -> Array | nil
メッセージの拡張データを返します。

--- multipart? -> bool
マルチパートかどうかを返します。
true を返します。



#@# internal classes:
#@# = class Net::IMAP::Atom
#@# = class Net::IMAP::Literal
#@# = class Net::IMAP::QuotedString
#@# = class Net::IMAP::MessageSet
#@# = class Net::IMAP::RawData


#@# internal classes for authentication
#@# = class Net::IMAP::LoginAuthenticator
#@# 
#@# Authenticator for the "LOGIN" authentication type.
#@# See [[m:Net::IMAP#authenticate]].
#@# 
#@# == Class Methods
#@# 
#@# --- new(user, password)
#@# #@todo
#@# 
#@# == Instance Methods
#@# 
#@# --- process(data)
#@# #@todo
#@# 
#@# 
#@# 
#@# = class Net::IMAP::CramMD5Authenticator
#@# 
#@# Authenticator for the "CRAM-MD5" authentication type.
#@# See [[m:Net::IMAP#authenticate]].
#@# 
#@# == Class Methods
#@# 
#@# --- new(user, password)
#@# #@todo
#@# 
#@# == Instance Methods
#@# 
#@# --- process(challenge)
#@# #@todo
#@# 
#@# 
#@# 
#@# #@since 1.9.1
#@# = class Net::IMAP::PlainAuthenticator
#@# 
#@# Authenticator for the "PLAIN" authentication type.
#@# See [[m:Net::IMAP#authenticate]].
#@# 
#@# == Class Methods
#@# 
#@# --- new(user, password)
#@# #@todo
#@# 
#@# == Instance Methods
#@# 
#@# --- process(data)
#@# #@todo
#@# 
#@# 
#@# 
#@# = class Net::IMAP::DigestMD5Authenticator
#@# 
#@# Authenticator for the "DIGEST-MD5" authentication type.
#@# See [[m:Net::IMAP#authenticate]].
#@# 
#@# == Class Methods
#@# 
#@# --- new(user, password, authname = nil)
#@# #@todo
#@# 
#@# == Instance Methods
#@# 
#@# --- process(challenge)
#@# #@todo
#@# #@end



= class Net::IMAP::Error < StandardError

すべての IMAP 例外クラスのスーパークラス。

= class Net::IMAP::DataFormatError < Net::IMAP::Error

データフォーマットが正しくない場合に発生する例外のクラスです。

= class Net::IMAP::ResponseParseError < Net::IMAP::Error

サーバからのレスポンスが正しくパースできない場合に発生する
例外のクラスです。

= class Net::IMAP::ResponseError < Net::IMAP::Error

サーバからのレスポンスがエラーを示している場合に発生する例外
のクラスです。

実際にはこれを継承した
  * [[c:Net::IMAP::NoResponseError]]
  * [[c:Net::IMAP::BadResponseError]]
  * [[c:Net::IMAP::ByeResponseError]]
これらのクラスの例外が発生します。

== Instance Methods
#@since 1.9.2
--- response -> Net::IMAP::TaggedResponse | Net::IMAP::UntaggedResponse
エラーとなったレスポンスを表すオブジェクトを返します。

--- response=(resp)
エラーとなったレスポンスを表すオブジェクトを設定します。

@param resp 設定するレスポンスオブジェクト
#@end

= class Net::IMAP::NoResponseError < Net::IMAP::ResponseError

サーバから "NO" レスポンスが来た場合に発生する例外のクラスです。
コマンドが正常に完了しなかった場合に発生します。

= class Net::IMAP::BadResponseError < Net::IMAP::ResponseError

サーバから "BAD" レスポンスが来た場合に発生する例外のクラスです。
クライアントからのコマンドが IMAP の規格から外れている場合や
サーバ内部エラーの場合に発生します。

= class Net::IMAP::ByeResponseError < Net::IMAP::ResponseError

サーバから "BYE" レスポンスが来た場合に発生する例外のクラスです。
ログインが拒否された場合や、クライアントが無反応で
タイムアウトした場合に発生します。

#@since 1.9.1
= class Net::IMAP::FlagCountError < Net::IMAP::Error

サーバからのレスポンスに含まれるフラグが多すぎるときに発生する例外です。

この上限は [[m:Net::IMAP.max_flag_count=]] で設定します。

#@end

