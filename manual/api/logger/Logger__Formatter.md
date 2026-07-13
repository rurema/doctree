---
library: logger
---
# class Logger::Formatter < Object

ロガーのフォーマット文字列を扱うクラス。

[c:Logger] のデフォルトのフォーマッターです。

## Instance Methods

### def call(severity, time, progname, msg) -> String

ログ情報をフォーマットして返します。

- **param** `severity` -- ログレベル。

- **param** `time` -- 時間。[c:Time] クラスのオブジェクト。

- **param** `progname` -- プログラム名

- **param** `msg` -- メッセージ。

#@#noexample

### def datetime_format -> String

ログの日時フォーマットを取得します。

#@#noexample

- **SEE** [m:Time#strftime]

### def datetime_format=(format)

ログの日時フォーマットをセットします。

- **param** `format` -- 日時のフォーマット文字列。[m:Time#strftime] で使用するフォーマット文字列と
              同じものを使用できます。

```ruby title="例"
require 'logger'

formatter = Logger::Formatter.new
p formatter.datetime_format # => nil
formatter.datetime_format = '%Y-%m-%d %H:%M:%S' # => "%Y-%m-%d %H:%M:%S"
p formatter.datetime_format # => "%Y-%m-%d %H:%M:%S"
```

- **SEE** [m:Time#strftime]

## Constants

### const Format -> String

フォーマット文字列。

[m:Logger::Formatter#call] はこのフォーマット文字列に対して、ログレベルの頭文字・日時・
[m:Process.pid]・ログレベル・プログラム名・メッセージの順に値を当てはめます。
プロセス ID ([m:Process.pid]) が含まれる点に注意してください。

