WEBrick::HTTPServer のアクセスログの形式を処理するために内部で使われるライブラリです。

= module WEBrick::AccessLog

[[c:WEBrick::HTTPServer]] のアクセスログの形式を処理するために内部で使われるモジュールです。

アクセスログの形式は Apache の mod_log_config の形式に準拠しますが、HTTP ステータスコードを
指定することは出来ません。最後のステータスを表す %>s は %s と同じように解釈されます。

 * [[url:http://httpd.apache.org/docs/mod/mod_log_config.html#formats]]

 "%h %l %u %t \"%r\" %s %b"
 "%{User-Agent}i"

指定できる形式は以下のとおりです。

: %a
  リモート IP アドレス
: %b
  レスポンスのバイト数。HTTP ヘッダは除く。CLF 書式。
  すなわち、1 バイトも送られなかったときは 0 ではなく、 '-' になる
: %{FOOBAR}e
  環境変数 FOOBAR の内容
: %f
  ファイル名
: %h
  リモートホスト
: %{Foobar}i
  サーバに送られたリクエストの Foobar:  ヘッダの内容
: %l
  "-"
: %m
  リクエストメソッド
: %{Foobar}n
  req.attributes
: %{Foobar}o
  応答の Foobar: ヘッダの内容
: %p
  リクエストを扱っているサーバの正式なポート
: %q
  クエリ文字列
: %r
  リクエストの最初の行
: %s
  ステータス。"%>s" はサポートしません。
: %t
  リクエストを受付けた時刻。 CLF の時刻の書式 (標準の英語の書式)
: %{format}t
  format で与えられた書式による時刻。format は [[m:Time#strftime]] の 書式である必要がある。
: %T
  リクエストを扱うのにかかった時間、秒単位
: %u
  リモートユーザ
: %U
  リクエストされた URL パス。クエリ文字列は含まない
: %v
  リクエストを扱っているサーバの正式な ServerName

== Constants

--- CLF_TIME_FORMAT -> String

Apache のアクセスログと同じ時刻の形式を表す文字列です。

@return 以下の文字列を返します。
//emlist{{
  "[%d/%b/%Y:%H:%M:%S %Z]"
//}}

--- COMMON_LOG_FORMAT -> String
--- CLF -> String

Apache のアクセスログで一般的に使われる形式を表す文字列です。

@return 以下の文字列を返します。
//emlist{{
  "%h %l %u %t \"%r\" %s %b"
//}}

--- REFERER_LOG_FORMAT -> String

Apache のアクセスログで一般的に使われるリファラの形式を表す文字列です。

@return 以下の文字列を返します。
//emlist{{
  "%{Referer}i -> %U"
//}}

--- AGENT_LOG_FORMAT -> String

Apache のアクセスログで一般的に使われる User-Agent の形式を表す文字列です。

@return 以下の文字列を返します。
//emlist{{
  "%{User-Agent}i"
//}}

--- COMBINED_LOG_FORMAT -> String

Apache のアクセスログで一般的に使われる形式を表す文字列です。

@return 以下の文字列を返します。
//emlist{{
  "%h %l %u %t \"%r\" %s %b \"%{Referer}i\" \"%{User-agent}i\""
//}}

== Module Functions

--- escape(data) -> String

与えられた文字列が汚染されている場合、制御文字を無効化します。

@param data エスケープする文字列を指定します。

--- format(format_string, params) -> String

与えられたフォーマット文字列とパラメータを使用してログを整形します。

@param format_string フォーマット文字列を指定します。

@param params パラメータを指定します。

--- setup_params(config, request, response) -> Hash

与えられた引数を使用してログ出力に使用するパラメータを作成して返します。

@param config ハッシュを指定します。

@param request [[c:WEBrick::HTTPRequest]] のインスタンスを指定します。

@param response [[c:WEBrick::HTTPResponse]] のインスタンスを指定します。

= class WEBrick::AccessLog::AccessLogError < StandardError

指定されたアクセスログの形式が正しくない場合に発生します。
