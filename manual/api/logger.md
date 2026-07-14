---
type: library
---
ログを記録するためのライブラリです。

### 説明

6段階のログレベルに分けてログを記録します。

- **`UNKNOWN`**:
  常に記録されるべき不明なエラー
- **`FATAL`**:
  プログラムをクラッシュさせるような制御不可能なエラー
- **`ERROR`**:
  制御可能なエラー
- **`WARN`**:
  警告
- **`INFO`**:
  一般的な情報
- **`DEBUG`**:
  低レベルの情報

全てのメッセージは必ずログレベルを持ちます。また Logger オブジェクトも同じように
ログレベルを持ちます。メッセージのログレベルが Logger オブジェクトのログレベルよりも
低い場合メッセージは記録されません。

普段は INFO しか記録していないが、デバッグ情報が必要になった時には、
Logger オブジェクトのログレベルを DEBUG に下げるなどという使い方をします。

#### 例

```ruby
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
```

上の例ではログにはWARN、ERROR、FATALのみが記録されます。
例外オブジェクトも記録するメッセージとして使えます。
下が出力例です。

```text
W, [2017-12-07T02:22:53.649000 #11601]  WARN -- : Nothing to do!
F, [2017-12-07T02:22:53.649172 #11601] FATAL -- : Caught exception; exiting
F, [2017-12-07T02:22:53.649222 #11601] FATAL -- : No such file or directory @ rb_sysopen - a_non_existent_file (Errno::ENOENT)
logger_sample.rb:12:in `foreach'
logger_sample.rb:12:in `<main>'
```

これは log.level が [m:Logger::WARN] になっているためです。WARN、
ERROR、FATALログのみが記録の対象になります。DEBUG、INFOログは無視されま
す。

#### 機能

[c:Logger] はログファイルの自動切り替え、ログフォーマットの設定、ログ
と一緒に記録するプログラム名の指定といった有用な機能があります。以降で
はその使い方について説明します。

### 使い方

#### loggerの作成

以下のいずれかの方法でloggerを作成する事ができます([m:Logger.new] も参照)。

**1.** STDERR/STDOUTに出力するように指定

```ruby
require 'logger'
logger = Logger.new(STDERR)
logger = Logger.new(STDOUT)
```

**2.** ログファイル名を指定

```ruby
require 'logger'
logger = Logger.new('logfile.log')
```

**3.** [c:File] オブジェクトを指定

```ruby
require 'logger'
file = File.open('foo.log', File::WRONLY | File::APPEND)
# (古いファイルを削除する)新しいログファイルを作成する場合、以下のよ
# うに File::CREAT を指定。
# file = File.open('foo.log', File::WRONLY | File::APPEND | File::CREAT)
logger = Logger.new(file)
```

**4.** 指定したファイルサイズに達したらログファイルの切り替えを行うように指定。

```ruby
require 'logger'
# 約1,024,000バイトの"古い"ログファイルを10個残す
logger = Logger.new('foo.log', 10, 1024000)
```

**5.** ログファイルの切り替えを daily/weekly/monthly に指定

```ruby
require 'logger'
logger = Logger.new('foo.log', 'daily')
logger = Logger.new('foo.log', 'weekly')
logger = Logger.new('foo.log', 'monthly')
```

#### ログの記録

ログをレベルごとに記録するのに [m:Logger#fatal]、[m:Logger#error]、
[m:Logger#warn]、[m:Logger#info]、[m:Logger#debug] メソッドを使用
します。動的に任意のログレベルを設定したい場合は [m:Logger#add] を使
用します。

**1.** ブロックを指定

```ruby
logger.fatal { "Argument 'foo' not given." }
```

**2.** 文字列を指定

```ruby
logger.error "Argument #{@foo} mismatch."
```

**3.** プログラム名を指定

```ruby
logger.info('initialize') { "Initializing..." }
```

**4.** ログレベルを指定

```ruby
logger.add(Logger::FATAL) { 'Fatal error!' }
```

ブロック形式だと潜在的に複雑なログを記録する場合に評価をログの記録のタ
イミングまで遅延させる事ができます。例えば以下のようにすると、

```ruby
logger.debug { "This is a " + potentially + " expensive operation" }
```

もしログレベルが INFO 以上であった場合、デバッグメッセージが記録されな
いだけでなくブロックが評価される事もありません(以下だと記録が行われない
のは同じですが、評価されます)。

```ruby
logger.debug("This is a " + potentially + " expensive operation")
```

#### loggerのclose

```ruby
logger.close
```

#### ログレベル設定

**1.** オリジナルインターフェイス

```ruby
logger.sev_threshold = Logger::WARN
```

**2.** (ある程度の) Log4r 互換インターフェイス

```ruby
logger.level = Logger::INFO

# DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
```

**3.** [c:Symbol] か [c:String](大文字小文字の区別を行わない)

```ruby
logger.level = :info
logger.level = 'INFO'

# :debug < :info < :warn < :error < :fatal < :unknown
```

#@since 2.4.0
**4.** コンストラクタ

```ruby
require 'logger'
Logger.new(logdev, level: Logger::INFO)
Logger.new(logdev, level: :info)
Logger.new(logdev, level: 'INFO')
```
#@end

### フォーマット

ログはデフォルトでは特定のフォーマットで記録されます。デフォルトのフォー
マットとその場合のログの例は以下のようになります。

```text title="フォーマット"
SeverityID, [DateTime #pid] SeverityLabel -- ProgName: message
```

```text title="例"
I, [1999-03-03T02:34:24.895701 #19074]  INFO -- Main: info.
```

[m:Logger#datetime_format=] を用いてログに記録する時の日時のフォーマッ
トを変更することもできます。

```ruby
logger.datetime_format = '%Y-%m-%d %H:%M:%S'
# e.g. "2004-01-03 00:54:26"
```

#@since 2.4.0
コンストラクタでも同様にできます。

```ruby
require 'logger'
Logger.new(logdev, datetime_format: '%Y-%m-%d %H:%M:%S')
```
#@end

[m:Logger#formatter=] を用いてフォーマットを変更することもできます。

```ruby
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
end
# => "2005-09-22 08:51:08 +0900: hello world"
```

#@since 2.4.0
コンストラクタでも同様にできます。

```ruby
require 'logger'
Logger.new(logdev, formatter: proc {|severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
})
```
#@end

### 参考

- **`Rubyist Magazine`**:
  <https://magazine.rubyist.net/>
- **標準添付ライブラリ紹介【第 2 回】**:
  <https://magazine.rubyist.net/articles/0008/0008-BundledLibraries.html>

