category File

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
[[m:FileUtils.#remove_entry_secure]] を用いて削除し、ブロックの値をかえします。
ブロックが与えられなかった場合は、作成した一時ディレクトリのパスを
返します。この場合、このメソッドは作成した一時ディレクトリを削除しません。

@param prefix_suffix nil の場合は、'd' をデフォルトのプレフィクスとして使用します。サフィックスは付きません。
                     文字列が与えられた場合は、その文字列をプレフィクスとして使用します。サフィックスは付きません。
                     2 要素の配列が与えられた場合は、一つ目の要素をプレフィクス、二つ目の要素をサフィックスとして使用します。

@param tmpdir nil の場合は [[m:Dir.tmpdir]] を使用します。
              そうでない場合は、そのディレクトリを使用します。


使用例
  require 'tmpdir'

  puts Dir.tmpdir
  # 出力例: 動作環境により出力は異なります。
  #=> /cygdrive/c/DOCUME~1/kouya/LOCALS~1/Temp
  Dir.mktmpdir{|dir| 
    puts dir
    # 出力例: 一時ディレクトリ の名前の先頭に'd' をつける。
    #=> /cygdrive/c/DOCUME~1/kouya/LOCALS~1/Temp/d20081011-4524-1m69psi
    #                                            ^                    
  }
  Dir.mktmpdir("foo"){|dir|
    puts dir
    # 出力例:一時ディレクトリ の名前の先頭に'foo' をつける。
    #=> /cygdrive/c/DOCUME~1/kouya/LOCALS~1/Temp/foo20081011-4824-pjvhwx
    #                                            ^^^                    
  }
  Dir.mktmpdir(["foo", "bar"]){|dir| 
    puts dir
    # 出力例: 一時ディレクトリの名前の先頭に'foo' 、最後に'bar'をつける。
    #=> /cygdrive/c/DOCUME~1/kouya/LOCALS~1/Temp/foo20081011-5624-1hyxrqbbar
    #                                            ^^^                     ^^^
  }
  
  Dir.mktmpdir(nil, "/var/tmp") {|dir|
    puts dir
    # 出力例: tmpdir の作成先が'/var/tmp'となる。
    #         さらに、一時ディレクトリ の名前の先頭に'd' をつける。
    #=> /var/tmp/d20081011-5304-h6b13j
  }
  
  memory_dir = nil
  Dir.mktmpdir {|dir|
    memory_dir = dir
    File.open("#{dir}/foo", "w") { |fp|
     fp.puts "hogehoge"
    }
  }
  # ブロックを抜けたら、テンポラリディレクトリは消される。
  p FileTest.directory?(memory_dir) #=> false
  
  dir = Dir.mktmpdir
  # ブロックを与えない場合は、ディレクトリは存在する。
  begin
    File.open("#{dir}/foo", "w") { |fp|
      fp.puts "hogehoge"
    }
  ensure
    FileUtils.remove_entry_secure dir
  end
  p FileTest.directory?(dir) #=> false


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
  

