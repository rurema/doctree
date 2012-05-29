require optparse

[[m:OptionParser#on]] で使用可能なクラスに [[c:URI]] が
追加されます。
オプションの引数は [[c:URI]] クラスのインスタンスに変換されてから、
[[m:OptionParser#on]] のブロックに渡されます。

 require 'optparse/uri'
 opts = OptionParser.new

 opts.on("-u URI", URI){|u|
   p u #=> #<URI::HTTP:0x201267d4 URL:http://www.example.com>
 }
 opts.parse!
 
 # ruby command -u http://www.example.com
