ログを記録するためのライブラリです。

=== 説明

5段階のログレベルに分けてログを記録します。

: FATAL
  プログラムをクラッシュさせるような制御不可能なエラー
: ERROR
  エラー
: WARN
  警告
: INFO
  一般的な情報
: DEBUG
  低レベルの情報

全てのメッセージは必ずログレベルを持ちます。また Logger オブジェクトも同じように
ログレベルを持ちます。メッセージのログレベルが Logger オブジェクトのログレベルよりも
低い場合メッセージは記録されません。

普段は INFO しか記録していないが、デバッグ情報が必要になった時には、
Logger オブジェクトのログレベルを DEBUG に下げるなどという使い方をします。

==== 例

  require 'logger'
  logger = Logger.new(STDOUT)
  logger.level = Logger::WARN

  logger.debug("Created logger")
  logger.info("Program started")
  logger.warn("Nothing to do!")

  path = "a_non_existent_file"

  begin
    File.foreach(path) do |line|
      unless line =~ /^(\w+) = (.*)$/
        logger.error("Line in wrong format: #{line.chomp}")
      end
    end
  rescue => err
    logger.fatal("Caught exception; exiting")
    logger.fatal(err)
  end

上の例ではログにはWARN、ERROR、FATALのみが記録されます。
例外オブジェクトも記録するメッセージとして使えます。
下が出力例です。

  W, [2017-12-07T02:22:53.649000 #11601]  WARN -- : Nothing to do!
  F, [2017-12-07T02:22:53.649172 #11601] FATAL -- : Caught exception; exiting
  F, [2017-12-07T02:22:53.649222 #11601] FATAL -- : No such file or directory @ rb_sysopen - a_non_existent_file (Errno::ENOENT)
  logger_sample.rb:12:in `foreach'
  logger_sample.rb:12:in `<main>'

これは log.level が [[m:Logger::WARN]] になっているためです。WARN、
ERROR、FATALログのみが記録の対象になります。DEBUG、INFOログは無視されま
す。

==== 機能

[[c:Logger]] はログファイルの自動切り替え、ログフォーマットの設定、ログ
と一緒に記録するプログラム名の指定といった有用な機能があります。以降で
はその使い方について説明します。

=== 使い方

==== loggerの作成

以下のいずれかの方法でloggerを作成する事ができます([[m:Logger.new]] も参照)。

1. STDERR/STDOUTに出力するように指定

   require 'logger'
   logger = Logger.new(STDERR)
   logger = Logger.new(STDOUT)

2. ログファイル名を指定

   require 'logger'
   logger = Logger.new('logfile.log')

3. [[c:File]] オブジェクトを指定

   require 'logger'
   file = File.open('foo.log', File::WRONLY | File::APPEND)
   # (古いファイルを削除する)新しいログファイルを作成する場合、以下のよ
   # うに File::CREAT を指定。
   # file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
   logger = Logger.new(file)

4. 指定したファイルサイズに達したらログファイルの切り替えを行うように指定。

   require 'logger'
   # 約1,024,000バイトの"古い"ログファイルを10個残す
   logger = Logger.new('foo.log', 10, 1024000)

5. ログファイルの切り替えを daily/weekly/monthly に指定

   require 'logger'
   logger = Logger.new('foo.log', 'daily')
   logger = Logger.new('foo.log', 'weekly')
   logger = Logger.new('foo.log', 'monthly')

==== ログの記録

ログをレベルごとに記録するのに [[m:Logger#fatal]]、[[m:Logger#error]]、
[[m:Logger#warn]]、[[m:Logger#info]]、[[m:Logger#debug]] メソッドを使用
します。動的に任意のログレベルを設定したい場合は [[m:Logger#add]] を使
用します。

1. ブロックを指定

   logger.fatal { "Argument 'foo' not given." }

2. 文字列を指定

   logger.error "Argument #{@foo} mismatch."

3. プログラム名を指定

   logger.info('initialize') { "Initializing..." }

4. ログレベルを指定

   logger.add(Logger::FATAL) { 'Fatal error!' }

ブロック形式だと潜在的に複雑なログを記録する場合に評価をログの記録のタ
イミングまで遅延させる事ができます。例えば以下のようにすると、

  logger.debug { "This is a " + potentially + " expensive operation" }

もしログレベルが INFO 以上であった場合、デバッグメッセージが記録されな
いだけでなくブロックが評価される事もありません(以下だと記録が行われない
のは同じですが、評価されます)。

  logger.debug("This is a " + potentially + " expensive operation")

==== loggerのclose

  logger.close

==== ログレベル設定

1. オリジナルインターフェイス

   logger.sev_threshold = Logger::WARN

2. (ある程度の) Log4r 互換インターフェイス

   logger.level = Logger::INFO

   # DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN

3. [[c:Symbol]] か [[c:String]](大文字小文字の区別を行わない)

   logger.level = :info
   logger.level = 'INFO'

   # :debug < :info < :warn < :error < :fatal < :unknown

#@since 2.4.0
4. コンストラクタ

   require 'logger'
   Logger.new(logdev, level: Logger::INFO)
   Logger.new(logdev, level: :info)
   Logger.new(logdev, level: 'INFO')
#@end

=== フォーマット

ログはデフォルトでは特定のフォーマットで記録されます。デフォルトのフォー
マットとその場合のログの例は以下のようになります。

フォーマット:

  SeverityID, [DateTime #pid] SeverityLabel -- ProgName: message

例:

  I, [1999-03-03T02:34:24.895701 #19074]  INFO -- Main: info.

[[m:Logger#datetime_format=]] を用いてログに記録する時の日時のフォーマッ
トを変更することもできます。

  logger.datetime_format = '%Y-%m-%d %H:%M:%S'
  # e.g. "2004-01-03 00:54:26"

#@since 2.4.0
コンストラクタでも同様にできます。

  require 'logger'
  Logger.new(logdev, datetime_format: '%Y-%m-%d %H:%M:%S')
#@end

[[m:Logger#formatter=]] を用いてフォーマットを変更することもできます。

  logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime}: #{msg}\n"
  end
  # => "2005-09-22 08:51:08 +0900: hello world"

#@since 2.4.0
コンストラクタでも同様にできます。

  require 'logger'
  Logger.new(logdev, formatter: proc {|severity, datetime, progname, msg|
    "#{datetime}: #{msg}\n"
  })
#@end

=== 参考

: Rubyist Magazine
  [[url:https://magazine.rubyist.net/]]
: 標準添付ライブラリ紹介【第 2 回】
  [[url:https://magazine.rubyist.net/articles/0008/0008-BundledLibraries.html]]

= class Logger < Object
include Logger::Severity


ログを記録するためのクラスです。

== Class Methods

#@since 2.4.0
--- new(logdev, shift_age = 0, shift_size = 1048576, level: Logger::Severity::DEBUG, progname: nil, formatter: Formatter.new, datetime_format: nil, shift_period_suffix: '%Y%m%d') -> Logger
#@else
--- new(logdev, shift_age = 0, shift_size = 1048576) -> Logger
#@end

Logger オブジェクトを生成します。

@param logdev ログを書き込むファイル名か、 IO オブジェクト(STDOUT, STDERR など)を指定します。

@param shift_age ログファイルを保持する数か、ログファイルを切り替える頻度を指定します。
                 頻度には daily, weekly, monthly を文字列で指定することができます。
                 省略すると、ログの保存先を切り替えません。

@param shift_size shift_age を整数で指定した場合のみ有効です。
                  このサイズでログファイルを切り替えます。

#@since 2.4.0
@param level ログに記録する時のログレベルを指定します。省略した場合は
             [[m:Logger::Severity::DEBUG]] です。

@param progname ログに記録する時のプログラム名を指定します。省略した場合は nil です。

@param formatter ログに記録する時のログのフォーマッタを指定します。
                 省略した場合は [[c:Logger::Formatter]] インスタンスです。

@param datetime_format ログに記録する時の日時のフォーマットを指定します。
                       省略した場合は '%Y-%m-%d %H:%M:%S' です。

@param shift_period_suffix daily、weekly、monthlyでログファイルの切り替
                           えを行う時のログファイルの名の末尾に追加する
                           文字列のフォーマットを指定します。
                           省略した場合は '%Y%m%d' です。
#@end

例:

  require 'logger'
  logger = Logger.new(STDERR)
  logger = Logger.new(STDOUT)
  logger = Logger.new('logfile.log')
  
  file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
  logger = Logger.new(file, 'daily')
#@since 2.4.0
  logger = Logger.new(file, level: :info)
  logger = Logger.new(file, progname: 'progname')
  logger = Logger.new(file, formatter: formatter)
  logger = Logger.new(file, datetime_format: '%Y-%m-%d %H:%M:%S')
#@end

== Instance Methods

--- <<(msg) -> Integer | nil

ログを出力します。

@param msg ログに出力するメッセージ。

--- add(severity, message = nil, progname = nil) -> true
--- add(severity, message = nil, progname = nil){ ... } -> true
--- log(severity, message = nil, progname = nil) -> true
--- log(severity, message = nil, progname = nil){ ... } -> true

メッセージをログに記録します。

ブロックを与えた場合はブロックを評価した返り値をメッセージとしてログに記録します。
ユーザがこのメソッドを直接使うことはあまりありません。

@param severity ログレベル。[[c:Logger]] クラスで定義されている定数を指定します。
                この値がレシーバーに設定されているレベルよりも低い場合、
                メッセージは記録されません。

@param message ログに出力するメッセージを文字列か例外オブジェクトを指定します。
               省略すると nil が用いられます。

@param progname ログメッセージと一緒に記録するプログラム名を指定します。
                省略すると nil が使用されますが、実際には内部で保持されている値が使用されます。

--- close -> nil

ログ出力に使用していた IO オブジェクトを閉じます。

--- datetime_format -> String | nil

ログに記録する時の日付のフォーマットです。

デフォルトでは nil ですが、この値が nil の場合は日付のフォーマットとして
"%Y-%m-%dT%H:%M:%S.%06d " を使用します。

なお、"%06d" には [[m:Time#strftime]] ではなく、単に [[m:Time#usec]] の
値を [[m:String#%]] でフォーマットしたものが入ります。

@see [[m:Time#strftime]], [[m:Logger#datetime_format=]]


--- datetime_format=(format)

ログに記録する時の日付のフォーマットをセットします。

@see [[m:Time#strftime]], [[m:Logger#datetime_format]]

--- debug? -> bool

現在の Logger オブジェクトが DEBUG 以上のログレベルのメッセージを記録するなら
真を返します。

#@samplecode 例
require 'logger'

logger = Logger.new(STDOUT, level: Logger::Severity::DEBUG)
logger.debug? # => true
logger = Logger.new(STDOUT, level: Logger::Severity::INFO)
logger.debug? # => false
#@end

--- info? -> bool

現在の Logger オブジェクトが INFO 以上のログレベルのメッセージを記録するなら
真を返します。

--- warn? -> bool

現在の Logger オブジェクトが WARN 以上のログレベルのメッセージを記録するなら
真を返します。

--- error? -> bool

現在の Logger オブジェクトが ERROR 以上のログレベルのメッセージを記録するなら
真を返します。

--- fatal? -> bool

現在の Logger オブジェクトが FATAL 以上のログレベルのメッセージを記録するなら
真を返します。

--- debug(progname = nil) -> true
--- debug(progname = nil){ ... } -> true

ログレベルが DEBUG のメッセージを出力します。

現在の Logger のログレベルが DEBUG よりも高い場合、メッセージは出力されません。

ブロックを与えなかった場合は、progname をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして
ログを出力します。

引数とブロックを同時に与えた場合は、progname をプログラム名、ブロックを評価した
結果をメッセージとしてログを出力します。

@param progname ブロックを与えない場合は、メッセージとして文字列または例外オブジェクトを指定します。
                ブロックを与えた場合は、プログラム名を文字列として与えます。

例:

  logger.debug "Waiting for input from user"
  # ...
  logger.debug { "User typed #{input}" }

  logger.debug("MainApp") { "Received connection from #{ip}" }

--- info(progname = nil){ ... } -> true
--- info(progname = nil) -> true

INFO 情報を出力します。

ブロックを与えなかった場合は、progname をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして
ログを出力します。

引数とブロックを同時に与えた場合は、progname をプログラム名、ブロックを評価した
結果をメッセージとしてログを出力します。

@param progname ブロックを与えない場合は、メッセージとして文字列または例外オブジェクトを指定します。
                ブロックを与えた場合は、プログラム名を文字列として与えます。

@see [[m:Logger#debug]]

--- warn(progname = nil){ ... } -> true
--- warn(progname = nil) -> true

WARN 情報を出力します。

ブロックを与えなかった場合は、progname をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして
ログを出力します。

引数とブロックを同時に与えた場合は、progname をプログラム名、ブロックを評価した
結果をメッセージとしてログを出力します。

@param progname ブロックを与えない場合は、メッセージとして文字列または例外オブジェクトを指定します。
                ブロックを与えた場合は、プログラム名を文字列として与えます。

@see [[m:Logger#debug]]

--- error(progname = nil){ ... } -> true
--- error(progname = nil) -> true

ERROR 情報を出力します。

ブロックを与えなかった場合は、progname をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして
ログを出力します。

引数とブロックを同時に与えた場合は、progname をプログラム名、ブロックを評価した
結果をメッセージとしてログを出力します。

@param progname ブロックを与えない場合は、メッセージとして文字列または例外オブジェクトを指定します。
                ブロックを与えた場合は、プログラム名を文字列として与えます。

@see [[m:Logger#debug]]

--- fatal(progname = nil){ ... } -> true
--- fatal(progname = nil) -> true

FATAL 情報を出力します。

ブロックを与えなかった場合は、progname をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして
ログを出力します。

引数とブロックを同時に与えた場合は、progname をプログラム名、ブロックを評価した
結果をメッセージとしてログを出力します。

@param progname ブロックを与えない場合は、メッセージとして文字列または例外オブジェクトを指定します。
                ブロックを与えた場合は、プログラム名を文字列として与えます。

@see [[m:Logger#debug]]

--- unknown(progname = nil){ ... } -> true
--- unknown(progname = nil) -> true

UNKNOWN 情報を出力します。

ブロックを与えなかった場合は、progname をメッセージとしてログを出力します。

ブロックを与えた場合は、ブロックを評価した結果をメッセージとして
ログを出力します。

引数とブロックを同時に与えた場合は、progname をプログラム名、ブロックを評価した
結果をメッセージとしてログを出力します。

@param progname ブロックを与えない場合は、メッセージとして文字列または例外オブジェクトを指定します。
                ブロックを与えた場合は、プログラム名を文字列として与えます。

@see [[m:Logger#debug]]

--- level -> Integer
--- sev_threshold -> Integer

レシーバにセットされているログレベルを取得します。

--- level=(level)
--- sev_threshold=(level)

Logger オブジェクトのログレベルを設定します。ログレベルがこれより低いメッセージは
出力されません。

@param level ログレベルを指定します。

--- progname -> String

ログに出力するプログラム名を取得します。

--- progname=(name)

ログに出力するプログラム名を設定します。

--- formatter -> String

ログを出力する際に使用するフォーマッターを取得します。

このメソッドの返り値が持つ call メソッドは 4 つの引数 (severity, time, program name, message) を受けとります。


--- formatter=(formatter)

ログを出力する際に使用するフォーマッターをセットします。

@param formatter 4 つの引数 (severity, time, program name, message) を受け取る call メソッドを
                 持つオブジェクトを指定します。call メソッドの返り値は文字列にしてください。

  require 'logger'
  logger = Logger.new
  logger.formatter = proc{|severity, datetime, progname, message|
    "#{datetime}: #{message}\n"
  }

== Constants

--- ProgName -> String
ログファイル作成時に使うプログラム名。

--- VERSION -> String
このライブラリのバージョンを表す文字列。

--- SEV_LABEL -> Array

ログレベルのラベルを格納した配列。

#@until 2.2.0
= class Logger::Application < Object
include Logger::Severity

ユーザ定義のアプリケーションにログ機能を簡単に追加することができます。

=== 使用方法

  (1) このクラスのサブクラスとしてユーザ定義のアプリケーションのクラスを定義します。
  (2) ユーザ定義のクラスでメイン処理を行う run メソッドを定義します。
  (3) そのクラスをインスタンス化して start メソッドを呼び出します。


例:

  class FooApp < Application
    def initialize(foo_app, application_specific, arguments)
      super('FooApp') # Name of the application.
    end
  
    def run
      ...
      log(WARN, 'warning', 'my_method1')
      ...
      @log.error('my_method2') { 'Error!' }
      ...
    end
  end
  
  status = FooApp.new(....).start

=== 注意

このクラスは 2.2.0 で gem ライブラリとして切り離されました。2.2.0
以降ではそちらを利用してください。

  * [[url:https://rubygems.org/gems/logger-application]]

== Class Methods

--- new(appname = nil) -> Logger::Application

このクラスを初期化します。

@param appname アプリケーション名を指定します。

== Instance Methods

--- appname -> String

アプリケーション名を取得します。

--- level=(level)

ログのログレベルをセットします。

@param level ログのログレベル。

@see [[c:Logger::Severity]]

--- log(severity, message = nil) -> true
--- log(severity, message = nil){ ... } -> true

メッセージをログに記録します。

ブロックを与えた場合はブロックを評価した返り値をメッセージとしてログに記録します。

@param severity ログレベル。[[c:Logger::Severity]] クラスで定義されている定数を指定します。
                この値がレシーバーに設定されているレベルよりも低い場合、
                メッセージは記録されません。

@param message ログに出力するメッセージを文字列か例外オブジェクトを指定します。
               省略すると nil が用いられます。

@see [[m:Logger#add]]

--- log=(logdev)

ログの出力先をセットします。

@param logdev ログファイル名か IO オブジェクトを指定します。

--- set_log(logdev, shift_age = 0, shift_size = 1024000) -> Integer

内部で使用する [[c:Logger]] のオブジェクトを初期化します。

@param logdev ログを書き込むファイル名か、 IO オブジェクト(STDOUT, STDERR など)を指定します。

@param shift_age ログファイルを保持する数か、ログファイルを切り替える頻度を指定します。
                 頻度には daily, weekly, monthly を文字列で指定することができます。
                 省略すると、ログの保存先を切り替えません。

@param shift_size shift_age を整数で指定した場合のみ有効です。
                  このサイズでログファイルを切り替えます。

@return ログのログレベルを返します。

--- start -> ()

アプリケーションをスタートさせます。

@return run メソッドの返値を返します。

@raise RuntimeError サブクラスで run メソッドを定義していない場合に発生します。
#@end

= class Logger::Formatter < Object

ロガーのフォーマット文字列を扱うクラス。

[[c:Logger]] のデフォルトのフォーマッターです。

== Instance Methods

--- call(severity, time, progname, msg) -> String

ログ情報をフォーマットして返します。

@param severity ログレベル。

@param time 時間。[[c:Time]] クラスのオブジェクト。

@param progname プログラム名

@param msg メッセージ。

--- datetime_format -> String

ログの日時フォーマットを取得します。

@see [[m:Time#strftime]]

--- datetime_format=(format)

ログの日時フォーマットをセットします。

@param format 日時のフォーマット文字列。[[m:Time#strftime]] で使用するフォーマット文字列と
              同じものを使用できます。

@see [[m:Time#strftime]]

== Constants

--- Format -> String

フォーマット文字列。

= class Logger::LogDevice < Object

[[c:Logger]] の内部で使用するログの出力先を表すクラスです。

== Class Methods

--- new(log = nil, opt = {}) -> Logger::LogDevice

ログの出力先を初期化します。

@param log ログの出力先。IO オブジェクトを指定します。
           省略すると nil が使用されますが、実行中に例外が発生します。

@param opt オプションをハッシュで指定します。
           ハッシュのキーには :shift_age, :shift_size を指定します。
           省略すると、それぞれ 7, 1048756 (1 MByte) が使用されます。

@see [[m:Logger.new]]


== Instance Methods

--- close -> nil

出力先の IO オブジェクトを閉じます。

このメソッドは同期されます。

@see [[m:IO#close]]

--- dev -> IO

出力先の IO オブジェクトを取得します。

--- filename -> String | nil

出力先のファイル名を取得します。

出力先がファイルではない場合は nil を返します。

--- write(message) -> Integer

出力先の IO オブジェクトにメッセージを書き込みます。

このメソッドは同期されます。

@see [[m:IO#write]]

#@until 2.3.0
= class Logger::LogDevice::LogDeviceMutex < Object
include MonitorMixin

ログの出力先ファイルを同期するためのクラスです。

@see [[c:MonitorMixin]]

#@end

= module Logger::Severity

[[lib:logger]] で使用するログレベルを定義したモジュール。

== Constants
--- DEBUG -> Integer
ログレベル:デバッグを表す定数です。

--- INFO  -> Integer
ログレベル:情報を表す定数です。

--- WARN  -> Integer
ログレベル:警告を表す定数です。

--- ERROR -> Integer
ログレベル:エラーを表す定数です。

--- FATAL -> Integer
ログレベル:致命的なエラーを表す定数です。

--- UNKNOWN -> Integer
ログレベル:不明なエラーを表す定数です。

= class Logger::Error < RuntimeError

このライブラリで使用する例外です。

= class Logger::ShiftingError < Logger::Error

ログファイルの切り替えに失敗した場合に発生する例外です。
