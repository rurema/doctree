= reopen Dir

== Class Methods
--- tmpdir
テンポラリファイルを作成するのに使うディレクトリ(テンポラリディレクトリ)の絶対パスを
文字列として返します。
[[m:$SAFE ]]によって返す文字列は変わります。

  # WindowsXPの場合

  require "tmpdir"

  p Dir.tmpdir #=> "C:/DOCUME~1/taro3/LOCALS~1/Temp"
  $SAFE = 1
  p Dir.tmpdir #=> "C:/WINDOWS/temp"
  $SAFE = 2
  p Dir.tmpdir #=> "C:/WINDOWS/temp"
  $SAFE = 3
  p Dir.tmpdir #=> "C:/WINDOWS/temp"

  # Linuxの場合 /tmp に加え、環境変数 ENV['TMPDIR'], ENV['TMP'], ENV['TEMP'], ENV['USERPROFILE']を参照します
  

