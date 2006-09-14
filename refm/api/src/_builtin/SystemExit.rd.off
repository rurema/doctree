= class SystemExit < Exception

ruby を終了させます。
#@# exitとは少し違いがあります。[[ruby-dev:12785]]

== Class Methods

#@if (version >= "1.7.0")
--- new([status], [error_message])

SystemExit 例外を生成して返します。

第一引数が整数の場合、引数 status を指定したものとみなされま
す。このことを除けば、引数の扱いは [[m:Exception#Exception.new]]
と同じです。

引数 status が指定された場合、終了ステータスとして生成したオ
ブジェクトの [[m:SystemExit#status]] 属性に設定されます(省略時は
0 が設定されます)。

例:

  e = SystemExit.new(1)
  p e.status
  
  => 1
#@end

== Instance Methods

#@if (version >= "1.7.0")
--- status

終了ステータスを返します。終了ステータスは [[m:Kernel#exit]] や
[[m:SystemExit#SystemExit.new]] などで設定されます。

例:

  begin
    exit(1)
  rescue SystemExit
    p $!
    p $!.status
  end
  
  => #<SystemExit: exit>
     1
  
  begin
    raise SystemExit.new(1, "bogus exit")
  rescue SystemExit
    p $!
    p $!.status
  end
  
  => #<SystemExit: bogus exit>
     1
#@end

#@if (version >= "1.8.0")
--- success?

終了ステータスが正常終了を示すなら true を返します。

例:

  begin
    exit(false)
  rescue SystemExit
    p $!
    p $!.status
    p $!.success?
  end
  
  # => #<SystemExit: exit>
       1
       false
#@end
