---
library: syslog
---
# module Syslog::Macros

このモジュールには syslog のユーティリティ関数が定義されています。

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

