importenv

require 'importenv' を加えるだけで環境変数をグローバル変数としてアクセスすることができるようになります。

=== 使用例

  require 'importenv'
  p $USER              # => "matz" (自分のユーザ名)
  $USER = "matz-2.0"
  p ENV["USER"]        # => "matz-2.0"
  p $USER              # => "matz-2.0" (*)

=== 注意
Ruby 1.6.2 までは(*)の出力が自分のユーザ名になってしまうバグがありましたが、1.6.3 で修正されました。
