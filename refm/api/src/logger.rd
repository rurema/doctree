#@since 1.8.1
ログを記録するためのライブラリです。

= class Logger < Object

ログを記録するためのクラスです。

=== 使い方

5段階の重要度に分けてログを記録します。

  * FATAL: プログラムをクラッシュさせるような制御不可能なエラー
  * ERROR: エラー
  * WARN: 警告
  * INFO: 一般的な情報
  * DEBUG: 低レベルの情報

全てのメッセージは必ず重要度を持ちます。また Logger オブジェクトも同じように
重要度を持ちます。メッセージの重要度が Logger オブジェクトの重要度よりも
低い場合メッセージは記録されません。

普段は INFO しか記録していないけど、デバッグ情報が必要になった時には、
Logger オブジェクトの重要度を DEBUG に下げるなどという使い方をします。

例:

  require 'logger'
  log = Logger.new(STDOUT)
  log.level = Logger::WARN
  
  log.debug("Created logger")
  log.info("Program started")
  log.warn("Nothing to do!")

上の例ではログには WARN のみが記録されます。下が出力例です。

  W, [2005-02-10T20:03:56.489954 #12469]  WARN -- : Nothing to do!

例外オブジェクトも記録するメッセージとして使えます。

例:

  require 'logger'
  log = Logger.new(STDOUT)
  log.level = Logger::ERROR
  
  begin
    File.each_line(path) do |line|
      unless line =~ /^(\w+) = (.*)$/
        log.error("Line in wrong format: #{line}")
      end
    end
  rescue => err
    log.fatal("Caught exception; exiting")
    log.fatal(err)
  end

=== 参考

  * [[unknown:Rubyist Magazine|URL:http://jp.rubyist.net/magazine/]]
  * [[unknown:標準添付ライブラリ紹介【第 2 回】 Logger|URL:http://jp.rubyist.net/magazine/?0008-BundledLibraries]]

== Class Methods

--- new(logdev, shift_age = 0, shift_size = 1048576)
#@todo

Logger オブジェクトを生成する。logdev には
記録するファイル名か、write と close が定義されたオブジェクト(IO
オブジェクトなど)を与えます。

例:

  logger = Logger.new(STDERR)
  logger = Logger.new(STDOUT)
  logger = Logger.new('logfile.log')

shift_age に [[c:Integer]] を与えた場合は、rotate したログファイルの
残す個数と解釈されます。shift_size 毎に rotate されます。
shift_age に 'daily', 'weekly', 'monthly' のいずれかの文字列を
与えた場合は、その間隔毎にログは rotate されます。

例:

  file = File.open('foo.log', File::WRONLY | File::APPEND)
  logger = Logger.new(file, 'daily')

shift_size は shift_age に [[c:Integer]] を与えた場合にのみ
有効です。

== Instance Methods

--- <<(msg)
#@todo

--- add(severity, message = nil, progname = nil) { ... }
--- log(severity, message = nil, progname = nil) { ... }
#@todo

メッセージをログに記録します。message は文字列か例外オブジェクトです。
severity にはメッセージの
重要度を DEBUG  = 0 から UNKNOWN = 5 までの定数で指定します。数字が
大きいほど重要度も高くなります。メッセージの重要度 severity が
Logger オブジェクトの level よりも低い場合、メッセージは記録されません。
progname にはログにメッセージと一緒に記録するプログラム名を与えます。
デフォルトはインスタンス変数 @progname です。

ブロックを与えた場合はブロックを評価した返り値をメッセージとしてログに記録します。

ユーザがこのメソッドを直接使うことはあまりありません。

--- close
#@todo

--- datetime_format
--- datetime_format=(format)
#@todo

ログに記録する時の日付のフォーマットです。デフォルトでは "%Y-%m-%dT%H:%M:%S.%06d "
です。[[m:Time#strftime]] を参照して下さい。

--- debug?
#@todo

現在の Logger オブジェクトが DEBUG 以上の重要度のメッセージを記録するなら
真を返します。

--- info?
#@todo

現在の Logger オブジェクトが INFO 以上の重要度のメッセージを記録するなら
真を返します。

--- warn?
#@todo

現在の Logger オブジェクトが WARN 以上の重要度のメッセージを記録するなら
真を返します。

--- error?
#@todo

現在の Logger オブジェクトが ERROR 以上の重要度のメッセージを記録するなら
真を返します。

--- fatal?
#@todo

現在の Logger オブジェクトが FATAL 以上の重要度のメッセージを記録するなら
真を返します。

--- debug(progname = nil) { ... }
--- debug(message = nil)
--- debug { ... }
#@todo

DEBUG 情報 message を記録します。ブロックを与えた場合は、ブロックを評価した
返り値をメッセージとして記録します。現在の Logger の重要度が DEBUG よりも高い場合、
メッセージは記録されません。

例:

  logger.debug "Waiting for input from user"
  # ...
  logger.debug { "User typed #{input}" }

引数とブロックを同時に与えた場合は、progname はプログラム名、ブロックを評価した
返り値がメッセージとなります。

例:

  logger.debug("MainApp") { "Received connection from #{ip}" }

--- info(progname = nil) { ... }
--- info(message = nil)
--- info { ... }
#@todo

INFO 情報を記録します。debug を参照して下さい。

--- warn(progname = nil) { ... }
--- warn(message = nil)
--- warn { ... }
#@todo

WARN 情報を記録します。debug を参照して下さい。

--- error(progname = nil) { ... }
--- error(message = nil)
--- error { ... }
#@todo

ERROR 情報を記録します。debug を参照して下さい。

--- fatal(progname = nil) { ... }
--- fatal(message = nil)
--- fatal { ... }
#@todo

FATAL 情報を記録します。debug を参照して下さい。

--- unknown(progname = nil) { ... }
--- unknown(message = nil)
--- unknown { ... }
#@todo

--- level
--- level=(level)
#@todo

Logger オブジェクトの重要度を設定します。重要度がこれより低いメッセージは
記録されません。

--- sev_threshold
--- sev_threshold=(level)
#@todo

level の別名です。

--- progname
--- progname=(name)
#@todo

ログに記録するプログラム名を設定します。

--- formatter
--- formatter=(formatter)
#@todo

== Constants

--- DEBUG
--- INFO
--- WARN
--- ERROR
--- FATAL
--- UNKNOWN
#@todo

重要度を表す定数です。

#@if (version <= "1.8.2")
--- Format
#@todo
#@end

--- ProgName
#@todo

--- VERSION
#@todo

--- SEV_LABEL
#@todo

= class Logger::Application < Object

== Class Methods

--- new(appname = nil)
#@todo

== Instance Methods

--- appname
#@todo

--- level=(level)
#@todo

--- log(severity, message = nil) { ... }
#@todo

--- log=(logdev)
#@todo

--- logdev
#@todo

--- set_log(logdev, shift_age = 0, shift_size = 1024000)
#@todo

--- start
#@todo

= class Logger::Error < RuntimeError

= class Logger::Formatter < Object

== Class Methods

--- new
#@todo

== Instance Methods

--- call(severity, time, progname, msg)
#@todo

--- datetime_format
--- datetime_format=(format)
#@todo

== Constants

--- Format
#@todo

= class Logger::LogDevice < Object

== Class Methods

--- new(log = nil, opt = {})
#@todo

== Instance Methods

--- close
#@todo

--- dev
#@todo

--- filename
#@todo

--- write(message)
#@todo

= class Logger::LogDevice::LogDeviceMutex < Object
include MonitorMixin

= module Logger::Severity

== Constants

--- DEBUG
--- INFO
--- WARN
--- ERROR
--- FATAL
--- UNKNOWN
#@todo

= class Logger::ShiftingError < Logger::Error
#@end
