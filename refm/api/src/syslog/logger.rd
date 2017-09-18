require syslog
require logger

[[c:Logger]] のようなインターフェイスを用いて syslog にログを記録するた
めのサブライブラリです。[[c:Syslog::Logger]] を使って複数のマシンでログ
を集約する事もできます。

デフォルトでは、[[c:Syslog::Logger]] はプログラム名として 'ruby' を使用
します。これを変更したい場合は [[m:Syslog::Logger.new]] の第一引数にプ
ログラム名を渡してください。

[注意] [[c:Syslog::Logger]] のプログラム名の変更は最初の初期化の時だけ
しか行う事ができません。これは [[c:Syslog::Logger]] が syslog を利用す
る上での制限です。(これは [[man:syslog(3)]] の制限でもあります)。一度
[[c:Syslog::Logger]] オブジェクトを作成した後はプログラム名を変更しよう
としても無視されます。

=== 例

ローカルマシンの syslogd にログを保存:

  require 'syslog/logger'

  log = Syslog::Logger.new 'my_program'
  log.info 'this line will be logged via syslog(3)'

環境によっては syslog.conf の設定が必要である可能性があります。FreeBSD
では、/etc/syslog.conf に以下のような記述が必要です。

 !my_program
 *.*                                             /var/log/my_program.log

この場合、/var/log/my_program.log に touch して syslogd に HUP シグナル
を送信する必要があります。(Free BSD だと killall -HUP syslogd)

自動ロテートや自動圧縮などの細かい設定については、
[[man:newsyslog.conf(5)]] や [[man:newsyslog(8)]] を参照してください。

= class Syslog::Logger

[[c:Logger]] のようなインターフェイスを用いて syslog にログを記録するた
めのクラスです。

== Class Methods

--- new(program_name = 'ruby') -> Syslog::Logger

[[c:Syslog::Logger]] オブジェクトを初期化します。

@param program_name [[c:Logger]] との互換性のために用意されています。
                    プログラム名を文字列で指定できますが、最初の
                    [[c:Syslog::Logger]] の初期化時のみ、指定した値がセッ
                    トされます(syslog の仕様で 1 つのプログラム名のみが
                    採用されます)。

--- syslog -> Syslog

内部の [[c:Syslog]] オブジェクトを返します。

デフォルトでは、最初の [[c:Syslog::Logger]] オブジェクトの作成時に作ら
れたものを返します。

--- syslog=(syslog)

内部の [[c:Syslog]] オブジェクトを引数 syslog で指定したものに設定します。

@param syslog [[c:Syslog]] オブジェクトを指定します。

--- make_methods(meth)

ライブラリ内部で使用します。

== Instance Methods

--- unknown(message = nil, &block) -> true

UNKNOWN 情報を出力します。syslog の alert の情報として記録されます。

ブロックを与えなかった場合は、message をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして ログを出力します。

引数とブロックを同時に与えた場合は、message をメッセージとしてログを出
力します(ブロックは評価されません)。

@see [[m:Syslog::Logger::LEVEL_MAP]], [[m:Logger#unknown]]

--- unknown? -> bool

self が UNKNOWN 以上の(syslog の alert)ログレベルのメッセージを記録する
場合に true を返します。

--- fatal(message = nil, &block) -> true

FATAL 情報を出力します。syslog の err の情報として記録されます。

ブロックを与えなかった場合は、message をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして ログを出力します。

引数とブロックを同時に与えた場合は、message をメッセージとしてログを出
力します(ブロックは評価されません)。

@see [[m:Syslog::Logger::LEVEL_MAP]], [[m:Logger#fatal]]

--- fatal? -> bool

self が FATAL 以上の(syslog の err)ログレベルのメッセージを記録する場合
に true を返します。

--- error(message = nil, &block) -> true

ERROR 情報を出力します。syslog の warning の情報として記録されます。

ブロックを与えなかった場合は、message をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして ログを出力します。

引数とブロックを同時に与えた場合は、message をメッセージとしてログを出
力します(ブロックは評価されません)。

@see [[m:Syslog::Logger::LEVEL_MAP]], [[m:Logger#error]]

--- error? -> bool

self が ERROR 以上の(syslog の warning)ログレベルのメッセージを記録する
場合に true を返します。

--- warn(message = nil, &block) -> true

WARN 情報を出力します。syslog の notice の情報として記録されます。

ブロックを与えなかった場合は、message をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして ログを出力します。

引数とブロックを同時に与えた場合は、message をメッセージとしてログを出
力します(ブロックは評価されません)。

@see [[m:Syslog::Logger::LEVEL_MAP]], [[m:Logger#warn]]

--- warn? -> bool

self が WARN 以上の(syslog の notice)ログレベルのメッセージを記録する場
合に true を返します。

--- info(message = nil, &block) -> true

INFO 情報を出力します。syslog の info の情報として記録されます。

ブロックを与えなかった場合は、message をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして ログを出力します。

引数とブロックを同時に与えた場合は、message をメッセージとしてログを出
力します(ブロックは評価されません)。

@see [[m:Syslog::Logger::LEVEL_MAP]], [[m:Logger#info]]

--- info? -> bool

self が INFO 以上の(syslog の info)ログレベルのメッセージを記録する場合
に true を返します。

--- debug(message = nil, &block) -> true

DEBUG 情報を出力します。syslog の DEBUG の情報として記録されます。

ブロックを与えなかった場合は、message をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして ログを出力します。

引数とブロックを同時に与えた場合は、message をメッセージとしてログを出
力します(ブロックは評価されません)。

@see [[m:Syslog::Logger::LEVEL_MAP]], [[m:Logger#debug]]

--- debug? -> bool

self が DEBUG 以上の(syslog の debug)ログレベルのメッセージを記録する場
合に true を返します。

--- level -> Integer

self に設定されたログレベルを返します。

ログレベルは [[c:Logger]] と互換性があります。

@see [[m:Syslog::Logger#level=]]

--- level=(val)

self のログレベルを引数 val で指定した値に設定します。

@param val ログレベルを指定します。

@see [[m:Syslog::Logger#level]]

--- formatter -> Logger::Formatter | Proc

ログを出力する際に使用するフォーマッターを取得します。

デフォルトでは [[c:Logger::Formatter]] オブジェクトを返します。

@see [[m:Syslog::Logger#formatter=]]

--- formatter=(formatter)

ログを出力する際に使用するフォーマッターをセットします。

@param formatter 4 つの引数 (severity, time, program name, message) を
                 受け取る call メソッドを 持つオブジェクトを指定します。

引数 formatter が持つ call メソッドは以下の 4 つの引数 (severity,
time, program name, message) を受けとります。

: severity

  このメッセージのログレベル([[c:Logger::Severity]] 参照)。

: time

  このメッセージが記録された時刻を表す [[c:Time]] オブジェクト。

: progname

  無視されます。互換性のために用意されています。

: message

  記録するメッセージ。

call メソッドは文字列を返す必要があります。

@see [[m:Syslog::Logger#formatter]]

--- add(severity, message = nil, progname = nil, &block) -> true

メッセージをログに記録します。[[m:Logger#add]] とほぼ同じ動作をします。

ブロックを与えた場合はブロックを評価した返り値をメッセージとしてログに
記録します。 ユーザがこのメソッドを直接使うことはあまりありません。

@param severity ログレベル。Logger クラスで定義されている定数を指定しま
                す。この値がレシーバーに設定されているレベルよりも低い
                場合、メッセージは記録されません。

@param message ログに出力するメッセージを表すオブジェクトを指定します。
               省略すると nil が用いられます。

@param progname 無視されます。

@see [[m:Logger#add]]

== Constants

--- VERSION -> '2.0'

[[c:Syslog::Logger]] のバージョンを表す文字列です。

--- LEVEL_MAP -> {Integer => Integer}

[[c:Logger]] のログレベルと [[man:syslog(3)]] のログレベルのマッピング
を表す [[c:Hash]] オブジェクトです。

[[c:Syslog::Logger]] では、Ruby アプリケーションからのメッセージはシス
テム上の他のデーモンからの [[man:syslog(3)]] に記録されるメッセージと比
べて、ログレベルを 1 つ下げて記録されます
([[m:Logger::Severity::DEBUG]] と [[m:Logger::Severity::INFO]] は除く)。
例えば、[[m:Logger::Severity::FATAL]] として記録した場合、
[[m:Syslog::Level::LOG_ERR]] として処理されます。

= class Syslog::Logger::Formatter

[[c:Syslog::Logger]] のデフォルトのログフォーマッタクラスです。

==  Instance Methods

--- call(severity, time, progname, message) -> String

引数を元にフォーマットした文字列を返します。

ライブラリ内部で使用します。
