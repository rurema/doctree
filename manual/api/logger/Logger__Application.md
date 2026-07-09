---
library: logger
include:
  - Logger::Severity
until: "2.2.0"
---
# class Logger::Application < Object

ユーザ定義のアプリケーションにログ機能を簡単に追加できます。

### 使用方法

  1. このクラスのサブクラスとしてユーザ定義のアプリケーションのクラスを定義します。
  2. ユーザ定義のクラスでメイン処理を行う run メソッドを定義します。
  3. そのクラスをインスタンス化して start メソッドを呼び出します。


例:

`````
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
`````

### 注意

このクラスは 2.2.0 で gem ライブラリとして切り離されました。2.2.0
以降ではそちらを利用してください。

  - [url:https://rubygems.org/gems/logger-application]

## Class Methods

### def new(appname = nil) -> Logger::Application

このクラスを初期化します。

- **param** `appname` -- アプリケーション名を指定します。

## Instance Methods

### def appname -> String

アプリケーション名を取得します。

### def level=(level)

ログのログレベルをセットします。

- **param** `level` -- ログのログレベル。

- **SEE** [c:Logger::Severity]

### def log(severity, message = nil) -> true
### def log(severity, message = nil){ ... } -> true

メッセージをログに記録します。

ブロックを与えた場合はブロックを評価した返り値をメッセージとしてログに記録します。

- **param** `severity` -- ログレベル。[c:Logger::Severity] クラスで定義されている定数を指定します。
                この値がレシーバーに設定されているレベルよりも低い場合、
                メッセージは記録されません。

- **param** `message` -- ログに出力するメッセージを文字列か例外オブジェクトを指定します。
               省略すると nil が用いられます。

- **SEE** [m:Logger#add]

### def log=(logdev)

ログの出力先をセットします。

- **param** `logdev` -- ログファイル名か IO オブジェクトを指定します。

### def set_log(logdev, shift_age = 0, shift_size = 1024000) -> Integer

内部で使用する [c:Logger] のオブジェクトを初期化します。

- **param** `logdev` -- ログを書き込むファイル名か、 IO オブジェクト(STDOUT, STDERR など)を指定します。

- **param** `shift_age` -- ログファイルを保持する数か、ログファイルを切り替える頻度を指定します。
                 頻度には daily, weekly, monthly を文字列で指定できます。
                 省略すると、ログの保存先を切り替えません。

- **param** `shift_size` -- shift_age を整数で指定した場合のみ有効です。
                  このサイズでログファイルを切り替えます。

- **return** -- ログのログレベルを返します。

### def start -> ()

アプリケーションをスタートさせます。

- **return** -- run メソッドの返値を返します。

- **raise** `RuntimeError` -- サブクラスで run メソッドを定義していない場合に発生します。

