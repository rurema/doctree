= module Shellwords

== Module Functions

--- shellwords(line)
#@todo

Unix シェルのコマンドライン解析に似た空白区切りの単語分割を行い、
単語(文字列)の配列を返します。

空白、シングルクォート(')、ダブルクォート(")、バックスラッシュ(\)
を解釈します。


    require 'shellwords'
    
    p Shellwords.shellwords(%q{  foo bar "foo bar"\ baz 'foo bar'  })
    
    # => ["foo", "bar", "foo bar baz", "foo bar"]
     
    p Shellwords.shellwords(%q{  A B C "D E F" "G","H I"  })
    
    # => ["A", "B", "C", "D E F", "G,H I"]
