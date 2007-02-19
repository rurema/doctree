#@if (version >= "1.6.6")
= module Syslog
include Syslog::Constants

UNIXのsyslogのラッパーモジュール。

        require 'syslog'

        Syslog.open("syslogtest")
        Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 100)
        Syslog.close

== Module Functions

--- open(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER)
--- open(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) { |syslog| ... }
#@todo

与えられた引数でsyslogを開く。以降、他の Syslog モジュール関数が使
用可能となる。

ブロック付きで呼ばれた場合は、self を引数としてブロックを実行し、
最後に Syslog.close を行う。

syslogを既に開いていた場合は[[c:RuntimeError]]が発生する。

ident はすべてのログにつく識別子で、どのプログラムから送られ
たログなのかを識別するために使われる。通常プログラム名が使われる。

options には、Syslog.open や Syslog.log の動作を制御するフラ
グを指定する。

facility には、ログ出力を行うプログラムの種別を指定する。
syslog はこの値にしたがって出力先となるログファイルを決める。
[[man:syslog.conf(5)]] 参照)

options と facility に指定できる値については
[[c:Syslog::Constants]] を参照。

      例:
        Syslog.open('ftpd', Syslog::LOG_PID | Syslog::LOG_NDELAY,
                    Syslog::LOG_FTP)

self を返す。

syslog の詳細については [[man:syslog(3)]] を参照。

--- open!(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) { |syslog| ... }
--- reopen(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) { |syslog| ... }
#@todo

開いていた syslog を最初にクローズする点を除いて Syslog.open と同じ。

--- opened?
#@todo

syslog をオープンしていれば真を返す。

--- ident
--- options
--- facility
#@todo

最後のopenで与えられた対応する引数を返す。

--- log(priority, format, ...)
#@todo

syslogにメッセージを書き込む。

priority は優先度を示す定数[[c:Syslog::Constants]]参照)。
また、facility([[c:Syslog::Constants]]参照)を論理和で指定す
ることで open で指定した facility を切替えることもできる。

format 以降は [[m:Kernel#sprintf]] と同じ形式の引数を指定する。
メッセージに改行を含める必要はない。

       例:
         Syslog.log(Syslog::LOG_CRIT, "the sky is falling in %d seconds!", 10)

注： [[man:syslog(3)]] のように format に %m は使用できない。

--- emerg(message, ...)
--- alert(message, ...)
--- crit(message, ...)
--- err(message, ...)
--- warning(message, ...)
--- notice(message, ...)
--- info(message, ...)
--- debug(message, ...)
#@todo

Syslog#log()のショートカットメソッド。
システムによっては定義されていないものもある。

       例:
         Syslog.crit("the sky is falling in %d seconds!",5)

--- mask
--- mask=(mask)
#@todo

ログの優先度のマスクを取得または設定する。
マスクは永続的であり、
Syslog.openやSyslog.close
ではリセットされない。
       例:
         Syslog.mask = Syslog::LOG_UPTO(Syslog::LOG_ERR)

--- close
#@todo

syslogを閉じる。

--- instance
#@todo

selfを返す。(旧版との互換性のため)

--- LOG_MASK(priority)
#@todo

1つの優先度に対するマスクを作成する。

--- LOG_UPTO(priority)
#@todo

priorityまでのすべての優先度のマスクを作成する。

= module Syslog::Constants


このモジュールにはシステムで使用可能なLOG_*定数が定義されている。

  例:
    require 'syslog'
    include Syslog::Constants


== Constants
--- LOG_PID
--- LOG_CONS
--- LOG_ODELAY
--- LOG_NDELAY
--- LOG_NOWAIT
--- LOG_PERROR
#@todo
オプション(options)を示す定数。

--- LOG_AUTH
--- LOG_AUTHPRIV
--- LOG_CONSOLE
--- LOG_CRON
--- LOG_DAEMON
--- LOG_FTP
--- LOG_KERN
--- LOG_LPR
--- LOG_MAIL
--- LOG_NEWS
--- LOG_NTP
--- LOG_SECURITY
--- LOG_SYSLOG
--- LOG_USER
--- LOG_UUCP
--- LOG_LOCAL0
--- LOG_LOCAL1
--- LOG_LOCAL2
--- LOG_LOCAL3
--- LOG_LOCAL4
--- LOG_LOCAL5
--- LOG_LOCAL6
--- LOG_LOCAL7
#@todo
機能(facilities)を示す定数。

--- LOG_EMERG
--- LOG_ALERT
--- LOG_CRIT
--- LOG_ERR
--- LOG_WARNING
--- LOG_NOTICE
--- LOG_INFO
--- LOG_DEBUG
#@todo
優先度(priorities)を示す定数。
#@end
