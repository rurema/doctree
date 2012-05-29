require optparse

[[m:OptionParser#on]] で使用可能な引数に [[c:Shellwords]]
追加されます。
オプションの引数は [[m:Shellwords.#shellwords]] によって配列に変換されてから、
[[m:OptionParser#on]] のブロックに渡されます。

 require 'optparse/shellwords'
 opts = OptionParser.new
 
 opts.on("-s VAL", Shellwords){|a|
   p a #=> ["hoge", "foo", "bar"]
 }
 opts.parse!
 
 # ruby command -s hoge\ foo\ bar
