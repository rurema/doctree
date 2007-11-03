= module WEBrick::AccessLog

WEBrick::HTTPServer のアクセスログの形式を処理するために内部で使われるモジュールです。

アクセスログの形式は Apache の mod_log_config の形式に準拠しますが、HTTP ステータスコードを
指定することは出来ません。最後のステータスを表す %>s は %s と同じように解釈されます。

 "%h %l %u %t \"%r\" %s %b"
 "%{User-Agent}i"

指定できる形式は以下のとおりです。
#@todo
  %a    req.peeraddr[3]
  %b    res.sent_size
  %e    ENV
  %f    res.filename || ""
  %h    req.peeraddr[2]
  %i    req
  %l    "-"
  %m    req.request_method
  %n    req.attributes
  %o    res
  %p    req.port
  %q    req.query_string
  %r    req.request_line.sub(/\x0d?\x0a\z/o, '')
  %s    res.status       # won't support "%>s"
  %t    req.request_time
  %T    Time.now - req.request_time
  %u    req.user || "-"
  %U    req.unparsed_uri
  %v    config[:ServerName]

== Constants

--- CLF_TIME_FORMAT

Apache のアクセスログと同じ時刻の形式を表す以下の文字列です。
  "[%d/%b/%Y:%H:%M:%S %Z]"

--- COMMON_LOG_FORMAT
--- CLF

Apache のアクセスログで一般的に使われる形式を表す以下の文字列です。
  "%h %l %u %t \"%r\" %s %b"

--- REFERER_LOG_FORMAT

Apache のアクセスログで一般的に使われるリファラの形式を表す以下の文字列です。
  "%{Referer}i -> %U"

--- AGENT_LOG_FORMAT

Apache のアクセスログで一般的に使われる User-Agent の形式を表す以下の文字列です。
  "%{User-Agent}i"

--- COMBINED_LOG_FORMAT

Apache のアクセスログで一般的に使われる形式を表す以下の文字列です。
  "%h %l %u %t \"%r\" %s %b \"%{Referer}i\" \"%{User-agent}i\""

= class WEBrick::AccessLog::AccessLogError < StandardError

指定されたアクセスログの形式が正しくない場合に発生します。
