テンポラリディレクトリのためのライブラリです。

= reopen Dir

== Class Methods

#@since 1.8.7
--- mktmpdir(prefix_suffix = nil, tmpdir = nil)             -> String
--- mktmpdir(prefix_suffix = nil, tmpdir = nil){|dir| ... } -> object
Dir.mktmpdir creates a temporary directory.
The directory is created with 0700 permission.
The prefix and suffix of the name of the directory is specified by
the optional first argument, prefix_suffix.

 * If it is not specified or nil, "d" is used as the prefix and no suffix is used.
 * If it is a string, it is used as the prefix and no suffix is used.  
 * If it is an array, first element is used as the prefix and second element is used as a suffix.

 Dir.mktmpdir {|dir| dir is ".../d..." }
 Dir.mktmpdir("foo") {|dir| dir is ".../foo..." }
 Dir.mktmpdir(["foo", "bar"]) {|dir| dir is ".../foo...bar" }

The directory is created under Dir.tmpdir or
the optional second argument <i>tmpdir</i> if non-nil value is given.

 Dir.mktmpdir {|dir| dir is "#{Dir.tmpdir}/d..." }
 Dir.mktmpdir(nil, "/var/tmp") {|dir| dir is "/var/tmp/d..." }

If a block is given,
it is yielded with the path of the directory.
The directory and its contents are removed
using FileUtils.remove_entry_secure before Dir.mktmpdir returns.
The value of the block is returned.

 Dir.mktmpdir {|dir|
  use the directory...
   open("#{dir}/foo", "w") { ... }
 }

If a block is not given,
The path of the directory is returned.
In this case, Dir.mktmpdir doesn't remove the directory.

 dir = Dir.mktmpdir
 begin
  use the directory...
   open("#{dir}/foo", "w") { ... }
 ensure
  remove the directory.
   FileUtils.remove_entry_secure dir
 end


#@end

--- tmpdir    -> String

テンポラリファイルを作成するのに使うディレクトリ(テンポラリディレクトリ)の絶対パスを
文字列として返します。
[[m:$SAFE]] によって返す文字列は変わります。

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
  

