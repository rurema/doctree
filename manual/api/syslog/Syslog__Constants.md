---
library: syslog
include:
#@since 2.0.0
  - Syslog::Option
  - Syslog::Facility
  - Syslog::Level
  - Syslog::Macros
#@end
---
# module Syslog::Constants

このモジュールにはシステムで使用可能なLOG_*定数、モジュール関数が定義さ
れています。

例:
```````
require 'syslog'
include Syslog::Constants
```````

それぞれの定数、モジュール関数は以下のモジュールに分けて定義されています。

 - [c:Syslog::Option]
 - [c:Syslog::Facility]
 - [c:Syslog::Level]
 - [c:Syslog::Macros]

