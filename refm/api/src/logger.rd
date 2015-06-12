#@since 1.8.1
ログを記録するためのライブラリです。

=== 使い方

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

[[m:Logger#formatter=]] を用いてフォーマットを変更することができます。

   logger.formatter = proc { |severity, datetime, progname, msg|
     "#{datetime}: #{msg}\n"
   }
   # => "Thu Sep 22 08:51:08 GMT+9:00 2005: hello world"

=== 参考

: Rubyist Magazine
  [[url:http://magazine.rubyist.net/]]
: 標準添付ライブラリ紹介【第 2 回】
  [[url:http://magazine.rubyist.net/?0008-BundledLibraries]]

= class Logger < Object
include Logger::Severity


ログを記録するためのクラスです。

== Class Methods

--- new(logdev, shift_age = 0, shift_size = 1048576) -> Logger

Logger オブジェクトを生成する。

@param logdev ログを書き込むファイル名か、 IO オブジェクト(STDOUT, STDERR など)を指定します。

@param shift_age ログファイルを保持する数か、ログファイルを切り替える頻度を指定します。
                 頻度には daily, weekly, monthly を文字列で指定することができます。
                 省略すると、ログの保存先を切り替えません。

@param shift_size shift_age を整数で指定した場合のみ有効です。
                  このサイズでログファイルを切り替えます。

例:

  logger = Logger.new(STDERR)
  logger = Logger.new(STDOUT)
  logger = Logger.new('logfile.log')
  
  file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
  logger = Logger.new(file, 'daily')


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

#@since 1.8.3
--- formatter -> String

ログを出力する際に使用するフォーマッターを取得します。

このメソッドの返り値が持つ call メソッドは 4 つの引数 (severity, time, program name, message) を受けとります。


--- formatter=(formatter)

ログを出力する際に使用するフォーマッターをセットします。

@param formatter 4 つの引数 (severity, time, program name, message) を受け取る call メソッドを
                 持つオブジェクトを指定します。call メソッドの返り値は文字列にしてください。

  logger = Logger.new
  logger.formatter = proc{|severity, datetime, progname, message|
    "#{datetime}: #{message}\n"
  }

#@end

== Constants

#@until 1.8.3
--- Format -> String

ログ用のフォーマット文字列。

#@end

--- ProgName -> String
ログファイル作成時に使うプログラム名。

#@since 1.9.1
--- VERSION -> String
このライブラリのバージョンを表す文字列。

#@end

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

#@until 1.9.1
--- logdev -> ()

このメソッドは使用されていません。

#@end

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

#@since 1.8.3
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

#@end

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

#@since 1.8.3
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

#@end
