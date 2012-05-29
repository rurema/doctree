require optparse

[[m:OptionParser#on]] で使用可能なクラスに [[c:Time]] が
追加されます。
オプションの引数は [[c:Time]] クラスのインスタンスに変換されてから、
[[m:OptionParser#on]] のブロックに渡されます。

 require 'optparse/uri'
 opts = OptionParser.new
 
 opts.on("-t TIME", Time){|t|
   p t #=> Sat, Jan 01 2000 00:00:00 +0900
 }
 
 # ruby command -t '2000/01/01 00:00'
