---
type: library
name: rdoc/rdoc
require:
#@since 1.9.1
  - rdoc
  - rdoc/parser/simple
  - rdoc/parser/ruby
  - rdoc/parser/c
#@until 1.9.2
  - rdoc/parser/f95
#@end
#@since 1.9.2
#@until 1.9.3
  - rdoc/parser/perl
#@end
#@end
  - rdoc/stats
  - fileutils
#@else
  - rdoc/parsers/parse_simple
  - rdoc/parsers/parse_rb
  - rdoc/parsers/parse_c
  - rdoc/parsers/parse_f95
  - ftools
#@end
  - rdoc/options
#@until 1.9.2
  - rdoc/diagram
#@end
  - find
  - time
---
#@since 1.9.1
rdoc コマンドのためのサブライブラリです。
#@else
rdoc コマンドのためのライブラリです。
#@end

