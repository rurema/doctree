net/ftp に TLS 拡張を実装するライブラリです。

[[RFC:4217]] で定義されている FTP over SSL/TLS (FTPS) を実装しています。
コントロールコネクションを SSL/TLS で暗号化します。

RFCではデータコネクションを TLS で暗号化する機能が定義されていますが、
このライブラリでは実装されていません。

また、SSL/TLS 接続の各パラメータを変更する方法はありません。

上記の問題などより、このライブラリは 1.9.1 以降廃止されます。

= class Net::FTPTLS < Net::FTP
FTP over SSL/TLS を実装したクラスです。

[[c:Net::FTP]] を継承しているため、FTP クラスのメソッドが利用できます。

== Instance Methods

--- connect(host, port=Net::FTP::FTP_PORT) -> ()
host で指定されたホストに接続します。

[[m:Net::FTP#connect]] とは、発生する例外も含めほぼ同じです。

@param host 接続するホスト名です。
@param port 接続するポート番号です。
@see [[m:Net::FTP#connect]]


--- login(user = "anonymous", passwd = nil, acct = nil) -> ()
ホストへのログイン処理を行ないます。

ログインの前に SSL/TLS で暗号化通信を開始します。その他は
[[m:Net::FTP#login]] と同様です。

@param user ログインに使うユーザ名を指定します。
@param passwd ログインに使うパスワードを指定します。
@param acct ログイン後に送る ACCT コマンドのパラメータを指定します。
@see [[m:Net::FTP#login]]



