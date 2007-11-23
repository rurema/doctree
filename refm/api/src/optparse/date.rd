require optparse

[[m:OptionParser#on]] で使用可能なクラスに [[c:Date]] と [[c:DateTime]] が
追加されます。
オプションの引数はそれぞれのクラスのインスタンスに変換されてから、
[[m:OptionParser#on]] のブロックに渡されます。

 require 'optparse/date'
 opts = OptionParser.new
 
 opts.on("-d DATE", Date){|d|
   p d.to_s #=> 2000-01-01
 }
 opts.parse!
 
 # ruby command -d 2000/1/1
