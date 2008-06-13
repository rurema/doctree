テンポラリディレクトリのためのライブラリです。

= reopen Dir

== Class Methods

#@since 1.8.7
--- mktmpdir(prefix_suffix = nil, tmpdir = nil)             -> String
--- mktmpdir(prefix_suffix = nil, tmpdir = nil){|dir| ... } -> object

一時ディレクトリを作成します。

作成されたディレクトリのパーミッションは 0700 です。

ブロックが与えられた場合は、ブロックの評価が終わると
作成された一時ディレクトリやその配下にあったファイルを
[[m:FileUtils.remove_entry_secure]] を用いて削除します。
ブロックが与えられなかった場合は、作成した一時ディレクトリのパスを
返します。この場合、このメソッドは作成した一時ディレクトリを削除しません。

@param prefix_suffic nil の場合は、'd' をデフォルトのプレフィクスとして使用します。サフィックスは付きません。
                     文字列が与えられた場合は、その文字列をプレフィクスとして使用します。サフィックスは付きません。
                     2 要素の配列が与えられた場合は、一つ目の要素をプレフィクス、二つ目の要素をサフィックスとして使用します。

@param tmpdir nil の場合は [[m:Dir.#tmpdir]] を使用します。
              そうでない場合は、そのディレクトリを使用します。


  Dir.mktmpdir{|dir| dir is ".../d..." }
  Dir.mktmpdir("foo"){|dir| dir is ".../foo..." }
  Dir.mktmpdir(["foo", "bar"]){|dir| dir is ".../foo...bar" }
  
  Dir.mktmpdir {|dir| dir is "#{Dir.tmpdir}/d..." }
  Dir.mktmpdir(nil, "/var/tmp") {|dir| dir is "/var/tmp/d..." }
  
  Dir.mktmpdir {|dir|
    use the directory...
    open("#{dir}/foo", "w") { ... }
  }
  
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
  

