#@since 1.8.1
category Obsolete
#@end

環境変数をグローバル変数としてアクセスするためのライブラリです。
#@since 1.8.1
このライブラリは deprecated です。代替となるライブラリはありません。
#@end

このライブラリを require するだけで環境変数をグローバル変数としてアクセスすることができるようになります。

=== 使用例

  require 'importenv'
  p $USER              # => "matz" (自分のユーザ名)
  $USER = "matz-2.0"
  p ENV["USER"]        # => "matz-2.0"
  p $USER              # => "matz-2.0"
