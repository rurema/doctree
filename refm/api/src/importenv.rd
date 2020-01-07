category Obsolete

環境変数をグローバル変数としてアクセスするためのライブラリです。
このライブラリは deprecated です。代替となるライブラリはありません。

このライブラリを require するだけで環境変数をグローバル変数としてアクセスすることができるようになります。

=== 使用例

  require 'importenv'
  p $USER              # => "matz" (自分のユーザ名)
  $USER = "matz-2.0"
  p ENV["USER"]        # => "matz-2.0"
  p $USER              # => "matz-2.0"
