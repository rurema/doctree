category Network

ネットワークライブラリ共通の例外クラスを
定義しています。

[[lib:net/http]] や [[lib:net/pop]] などでこのライブラリで
定義された例外クラスやそれらを継承した例外クラスを
利用しています。

= class Net::ProtocolError < StandardError
ネットワークプロトコル上のエラーが起きた場合に
発生する例外です。

= class Net::ProtoSyntaxError < Net::ProtocolError
プロトコル上の文法が正しくない場合に発生する
例外です。

Rubyの現在の標準添付ライブラリ内では使われていません。

= class Net::ProtoFatalError < Net::ProtocolError
サーバへのリクエストが間違っているなど、致命的エラーの
場合に発生するエラーです。

= class Net::ProtoUnknownError < Net::ProtocolError
サーバからのレスポンスが解釈できないなど、不明のエラーが
出た場合に発生する例外です。

= class Net::ProtoServerError < Net::ProtocolError
サーバー側の問題により要求が達成できない場合に
発生する例外です。

= class Net::ProtoAuthError < Net::ProtocolError
認証に問題があった場合に発生する例外です。

= class Net::ProtoCommandError < Net::ProtocolError
Rubyの現在の標準添付ライブラリ内では使われていません。

= class Net::ProtoRetriableError < Net::ProtocolError
alias Net::ProtocRetryError
なんらかの再試行をすることで、処理の継続が可能であるような
エラーが発生した場合に発生する例外です。

#@since 2.0.0
= class Net::OpenTimeout < Timeout::Error
コネクションを開こうとしたときにタイムアウトしたときに発生する例外です。

タイムアウトまでの時間は [[m:Net::HTTP#open_timeout=]]、
[[m:Net::FTP#open_timeout=]] などで設定します。

= class Net::ReadTimeout < Timeout::Error
データを読み出すときにタイムアウトしたときに発生する例外です。

タイムアウトまでの時間は [[m:Net::HTTP#read_timeout=]]、
[[m:Net::FTP#read_timeout=]] などで設定します。

#@end
#@since 2.6.0
= class Net::WriteTimeout < Timeout::Error
データを書き込むときにタイムアウトしたときに発生する例外です。

タイムアウトまでの時間は [[m:Net::HTTP#write_timeout=]]、
[[m:Net::FTP#write_timeout=]] などで設定します。
#@end
