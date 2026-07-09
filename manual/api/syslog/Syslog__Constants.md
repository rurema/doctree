---
library: syslog
---
# module Syslog::Constants
#@since 2.0.0
include Syslog::Option
include Syslog::Facility
include Syslog::Level
include Syslog::Macros
#@end

このモジュールにはシステムで使用可能なLOG_*定数、モジュール関数が定義さ
れています。

例:
```````
require 'syslog'
include Syslog::Constants
```````

#@since 2.0.0
それぞれの定数、モジュール関数は以下のモジュールに分けて定義されています。

 - [c:Syslog::Option]
 - [c:Syslog::Facility]
 - [c:Syslog::Level]
 - [c:Syslog::Macros]

# module Syslog::Macros

このモジュールには syslog のユーティリティ関数が定義されています。
#@end

## Module Functions

### module_function def LOG_MASK(priority) -> Integer

1つの優先度に対するマスクを作成します。

- **param** `priority` -- priority は優先度を示す定数を指定します。
#@since 2.0.0
                詳しくは、[c:Syslog::Level]を参照してください。
#@else
                詳しくは、[c:Syslog::Constants]を参照してください。
#@end

例:
````````````
require 'syslog'
Syslog.mask = Syslog::LOG_MASK(Syslog::LOG_ERR)
````````````

### module_function def LOG_UPTO(priority) -> Integer

priorityまでのすべての優先度のマスクを作成します。

- **param** `priority` -- priority は優先度を示す定数を指定します。
#@since 2.0.0
                詳しくは、[c:Syslog::Level]を参照してください。
#@else
                詳しくは、[c:Syslog::Constants]を参照してください。
#@end

例:
````````````
require 'syslog'
Syslog.mask = Syslog::LOG_UPTO(Syslog::LOG_ERR)
````````````

## Constants

#@since 2.0.0
# module Syslog::Option

このモジュールには syslog のオプション(options)に関する定数が定義されて
います。

## Constants
#@end

### const LOG_PID      -> Integer
### const LOG_CONS     -> Integer
### const LOG_ODELAY   -> Integer
### const LOG_NDELAY   -> Integer
### const LOG_NOWAIT   -> Integer
### const LOG_PERROR   -> Integer

オプション(options)を示す定数。
定数の詳細については [man:syslog(3)] を参照してください。

#@since 2.0.0
# module Syslog::Facility

このモジュールには syslog の機能(facilities)に関する定数が定義されてい
ます。

## Constants
#@end

### const LOG_AUTH     -> Integer
### const LOG_AUTHPRIV -> Integer
### const LOG_CONSOLE  -> Integer
### const LOG_CRON     -> Integer
### const LOG_DAEMON   -> Integer
### const LOG_FTP      -> Integer
### const LOG_KERN     -> Integer
### const LOG_LPR      -> Integer
### const LOG_MAIL     -> Integer
### const LOG_NEWS     -> Integer
### const LOG_NTP      -> Integer
### const LOG_SECURITY -> Integer
### const LOG_SYSLOG   -> Integer
### const LOG_USER     -> Integer
### const LOG_UUCP     -> Integer
### const LOG_LOCAL0   -> Integer
### const LOG_LOCAL1   -> Integer
### const LOG_LOCAL2   -> Integer
### const LOG_LOCAL3   -> Integer
### const LOG_LOCAL4   -> Integer
### const LOG_LOCAL5   -> Integer
### const LOG_LOCAL6   -> Integer
### const LOG_LOCAL7   -> Integer

機能(facilities)を示す定数。

定数 の詳細については [man:syslog(3)] を参照してください。

#@since 2.0.0
# module Syslog::Level

このモジュールには syslog の優先度(priorities)に関する定数が定義されて
います。

## Constants
#@end

### const LOG_EMERG    -> Integer
### const LOG_ALERT    -> Integer
### const LOG_CRIT     -> Integer
### const LOG_ERR      -> Integer
### const LOG_WARNING  -> Integer
### const LOG_NOTICE   -> Integer
### const LOG_INFO     -> Integer
### const LOG_DEBUG    -> Integer

優先度(priorities)を示す定数。
定数 の詳細については [man:syslog(3)] を参照してください。

