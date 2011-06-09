net/telnet に SSL 拡張を実装するライブラリです。

telnet の STATT-TLS option を実装しています。
[[c:Net::Telnet]] に直接機能を追加します。
[[m:Net::Telnet#ssl?]] で SSL 通信が開始されているかどうかを判定します。
これが偽である場合にはサーバが STATT-TLS option を実装していない
など、SSLが利用できないことを意味します。

SSLの証明書などのパラメータを渡す方法は存在しません。

このライブラリは 1.9.1 以降廃止されます。
このライブラリの利用は推奨されません。sshなど、他の手段を使用してください。

= reopen Net::Telnet

== Instance Methods

--- ssl -> bool
--- ssl? -> bool
SSL への移行に成功した場合に真を返します。


--- preprocess(string) -> String
ホストから受け取った文字列の前処理をします。

SSL の処理に必要な処理が付加されています。

@param string 前処理対象の文字列
@return 変換後の文字列

--- waitfor(opt) -> String|nil
--- waitfor(opt){|buf| ...} -> String|nil
指定した正規表現にマッチする文字列がホストから来るまでデータを読み込みます。

SSL の処理に必要な処理が付加されています。

@param opt 待ち合わせに必要な情報を指定します

