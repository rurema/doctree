---
library: syslog
include:
  - Syslog::Constants
---
# module Syslog

UNIXのsyslogのラッパーモジュール。
syslog の詳細については [man:syslog(3)] を参照してください。

`````
require 'syslog'

Syslog.open("syslogtest")
Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 100)
Syslog.close
# 書き込まれているか確かめる。
# 但し、実行環境によってログの場所が違う。くわしくはsyslog.confを参照。
File.foreach('/var/log/system.log'){|line|
  line.chomp!
  if /syslogtest/ =~ line
    puts line
  end
}
`````

## Module Functions

### module_function def open(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) -> self
### module_function def open(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) { |syslog| ... } -> self

与えられた引数でsyslogを開きます。以降、他の Syslog モジュール関数が使
用可能となります。

ブロック付きで呼ばれた場合は、self を引数としてブロックを実行し、
最後に [m:Syslog?.close] を行います。

syslog の詳細については [man:syslog(3)] を参照してください。

- **param** `ident` -- すべてのログにつく識別子で、どのプログラムから送られ
             たログなのかを識別するために使われる文字列を指定します。
             指定しない場合はプログラム名が使われます。

- **param** `options` -- Syslog.open や Syslog.log の動作を制御するフラグを指定します。
               指定しない場合は、Syslog::LOG_PID|Syslog::LOG_CONSの値が使われ
               ます。使用できる値は[c:Syslog::Constants] を参照してください。

- **param** `facility` -- ログ出力を行うプログラムの種別を指定します。syslog はこの値
                にしたがって出力先となるログファイルを決定します。 詳しくは、
                [man:syslog.conf(5)],
                [c:Syslog::Constants] を参照してください。

- **raise** `RuntimeError` -- syslogを既に開いていた場合は[c:RuntimeError]が発生します。

- **return** -- self を返します。

syslogを既に開いていた場合は[c:RuntimeError]が発生します。

`````
require 'syslog'

Syslog.open("syslogtest")
Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 100)
begin
  Syslog.open("syslogtest2")
rescue RuntimeError => err
  puts err #=> "syslog already open"
end
`````

options と facility に指定できる値については
[c:Syslog::Constants] を参照してください。

指定例:
```````````
require 'syslog'
Syslog.open('ftpd', Syslog::LOG_PID | Syslog::LOG_NDELAY,
            Syslog::LOG_FTP)
```````````

### module_function def open!(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) { |syslog| ... } -> self
### module_function def reopen(ident=$0, options=Syslog::LOG_PID|Syslog::LOG_CONS, facility=Syslog::LOG_USER) { |syslog| ... } -> self

開いていた syslog を最初にクローズする点を除いて[m:Syslog?.open] と同じです。

- **param** `ident` -- すべてのログにつく識別子で、どのプログラムから送られ
             たログなのかを識別するために使われる文字列を指定します。
             指定しない場合はプログラム名が使われます。

- **param** `options` -- Syslog.open や Syslog.log の動作を制御するフラグを指定します。
               指定しない場合は、Syslog::LOG_PID|Syslog::LOG_CONSの値が使われ
               ます。使用できる値は[c:Syslog::Constants] を参照してください。

- **param** `facility` -- ログ出力を行うプログラムの種別を指定します。syslog はこの値
                にしたがって出力先となるログファイルを決定します。 詳しくは、
                [man:syslog.conf(5)], [c:Syslog::Constants] を参照してく
                ださい。

使用例
`````
require 'syslog'

Syslog.open("syslogtest")
Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 100)
begin
  Syslog.open!("syslogtest2")
  Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 200)
rescue RuntimeError => err
  # RuntimeError は発生しない。
  puts err
end
File.foreach('/var/log/system.log'){|line|
  print line if line =~ /the sky is/
}
`````

- **SEE** [m:Syslog?.open]

### module_function def opened? -> bool

syslog をオープンしていれば真を返します。

使用例
`````
require 'syslog'

p Syslog.opened? #=> false
Syslog.open("syslogtest")
Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 100)
p Syslog.opened? #=> true
`````


### module_function def ident -> String | nil
### module_function def options -> Integer | nil
### module_function def facility -> Integer | nil

最後のopenで与えられた対応する引数を返します。

使用例
`````
require 'syslog'

Syslog.open("syslogtest")
p Syslog.ident    #=> "syslogtest"
p Syslog.options  #=> 3
p Syslog.facility #=> 8
`````

### module_function def log(priority, format, *arg) -> self

syslogにメッセージを書き込みます。

priority は優先度を示す定数([c:Syslog::Constants]参照)です。
また、facility([c:Syslog::Constants]参照)を論理和で指定す
ることで open で指定した facility を切替えることもできます。

format 以降は [m:Kernel?.sprintf] と同じ形式の引数を指定します。

但し、[man:syslog(3)] のように format に %m は使用できません。

メッセージに改行を含める必要はありません。

- **param** `priority` -- priority は優先度を示す定数を指定します。
                詳しくは、[c:Syslog::Constants]を参照してください。

- **param** `format` -- フォーマット文字列です。

- **param** `arg` -- フォーマットされる引数です。

- **raise** `ArgumentError` -- 引数が２つ以上でない場合に発生します。

例:
`````
require 'syslog'
Syslog.open("syslogtest") {|syslog|
  syslog.log(Syslog::LOG_CRIT, "the sky is falling in %d seconds!", 10)
}
`````


### module_function def emerg(message, *arg) -> self
### module_function def alert(message, *arg) -> self
### module_function def crit(message, *arg) -> self
### module_function def err(message, *arg) -> self
### module_function def warning(message, *arg) -> self
### module_function def notice(message, *arg) -> self
### module_function def info(message, *arg) -> self
### module_function def debug(message, *arg) -> self

Syslog#log()のショートカットメソッド。
システムによっては定義されていないものもあります。

例えば、Syslog.emerg(message, *arg) は、Syslog.log(Syslog::LOG_EMERG, message, *arg)
と同じです。

- **param** `message` -- フォーマット文字列です。[m:Kernel?.sprintf] と同じ形式の引数を指定します。

- **param** `arg` -- フォーマットされる引数です。

- **raise** `ArgumentError` -- 引数が1つ以上でない場合に発生します。

- **raise** `RuntimeError` -- syslog がopen されていない場合発生します。

例:
`````
require 'syslog'
Syslog.open("syslogtest") {|syslog|
  syslog.crit("the sky is falling in %d seconds!",5)
}
`````

### module_function def mask -> Integer | nil
### module_function def mask=(mask)

ログの優先度のマスクを取得または設定します。
マスクは永続的であり、
Syslog.openやSyslog.close
ではリセットされません。

- **param** `mask` -- ログの優先度のマスクを設定します。

- **raise** `RuntimeError` -- syslog がオープンされていない場合、発生します。

使用例

`````
require 'syslog'
include Syslog::Constants
# ログの場所は実行環境によって異なる。詳しくはsyslog.conf を参照
log = '/var/log/ftp.log'

Syslog.open('ftpd', LOG_PID | LOG_NDELAY, LOG_FTP)
Syslog.mask = Syslog::LOG_UPTO(LOG_ERR)

[ LOG_CRIT, LOG_ERR, LOG_WARNING,
  LOG_NOTICE, LOG_INFO, LOG_DEBUG ].each_with_index { |c, i|
  Syslog.log(c, "test for syslog FTP #{c}, #{i}")
}
Syslog.close
File.foreach(log){|line|
  print line if line =~ /FTP/
}
`````

### module_function def close -> nil

syslogを閉じます。

- **raise** `RuntimeError` -- syslog がopen されていない場合発生します。

使用例
`````
require 'syslog'

Syslog.open("syslogtest")
Syslog.log(Syslog::LOG_WARNING, "the sky is falling in %d seconds!", 100)
Syslog.close
`````

### module_function def instance -> self

selfを返します。(旧版との互換性のため)

