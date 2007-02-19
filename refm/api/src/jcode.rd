[[c:String]]クラスのメソッドを追加、再定義し、
日本語を意識した文字列処理を提供します。

=== 使用例 

  require 'jcode'
  $KCODE = 'EUC' # 漢字コードをEUC-JPに。Windows で Shift JIS なら 'SJIS' にする
  puts 'abcdef'.tr('a-z', 'Ａ-Ｚ')

$KCODE はこのスクリプト自体の文字コードあわせて設定します。

= reopen String

== Methods

--- each_char
--- each_char {|char| ... }
#@todo

文字列中の各文字に対して繰り返します。
ブロックを指定せずに呼び出された時には、各文字の配列を返します。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'

  require 'jcode'

  zstr = 'ＡＢＣＤＥＦ'
  zstr.each_char do |x|
    print "+#{x}+"
  end                     # => +Ａ++Ｂ++Ｃ++Ｄ++Ｅ++Ｆ+

#@# --- end_regexp
#@# 
#@# 最後の文字が多バイト文字である文字列にマッチする正規表現を返します。
#@# 再定義された [[m:String#succ]] で内部的に使われます。

--- jcount(str)
#@todo

[[m:String#count]] の日本語対応版です。

例：

  #!/usr/bin/env ruby

  $KCODE = 'e'
  zstr = 'ＡＢＣＤＥＦ'
  hogehoge = 'hogehoge'

  p zstr.count('Ａ')     # => 7   これは正しくない
  p hogehoge.count('g')  # => 2

  require 'jcode'
  p zstr.jcount('Ａ')    # => 1   これは正しい
  p hogehoge.jcount('g') # => 2

--- jlength
--- jsize
#@todo

[[m:String#length]] の日本語対応版です。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'
  zstr = 'ＡＢＣＤＥＦ'
  hogehoge = 'hogehoge'
  
  p zstr.size       # => 12   これは正しくない
  p hogehoge.size   # => 8

  require 'jcode'
  p zstr.jsize      # => 6    これは正しい
  p hogehoge.jsize  # => 8

--- mbchar?
#@todo

self に多バイト文字が最初に現れる位置を返します。
多バイト文字が含まれていなければ nil を返します。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'
  zstr = 'ＡＢＣＤＥＦ'
  hoge = 'hogehoge'

  require 'jcode'
  p zstr.mbchar?   # => 0
  p hoge.mbchar?   # => nil
  

= redefine String

== Methods

--- chop
--- chop!
#@todo

[[m:String#chop]] の日本語対応版です。

例：

  #!/usr/bin/env ruby

  $KCODE = 'e'
  zstr = 'ＡＢＣＤＥＦ'
  hoge = 'hogehoge'

  p zstr.chop       # => "ＡＢＣＤＥ\243"
  p hoge.chop       # => "hogehog"

  require 'jcode'
  p zstr.chop       # => "ＡＢＣＤＥ"
  p hoge.chop       # => "hogehog"

--- delete(str)
--- delete!(str)
#@todo

[[m:String#delete]] の日本語対応版です。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'
  zstr = 'ＡＢＣＤＥＦ'
  hoge = 'hogehoge'

  p zstr.delete("Ａ")  # => "唾津\306"
  p hoge.delete("e")   # => "hoghog"

  require 'jcode'
  p zstr.delete("Ａ")  # => "ＢＣＤＥＦ"
  p hoge.delete("e")   # => "hoghog"
    
--- squeeze([str])
--- squeeze!([str])
#@todo

[[m:String#squeeze]] の日本語対応版です。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'
  zstr = 'ＡＡＢＢＣＣ'
  hoge = 'hhoge'

  p zstr.squeeze   # => "ＡＡＢＢＣＣ"
  p hoge.squeeze   # => "hoge"

  require 'jcode'
  p zstr.squeeze   # => "ＡＢＣ"
  p hoge.squeeze   # => "hoge"
    
--- succ
--- succ!
#@todo

[[m:String#succ]] の日本語対応版です。

以下のような次の文字列を返します。

  "あaあ".succ => "あaぃ"
  "rｂ".succ => "rｃ"
  "_紅玉".succ => "_紅桐"

従来の [[m:String#succ]] は、
多バイト文字と半角文字が混在している文字列を
意図通りに処理することができません。
例えば上記のコードは、それぞれ
"あbあ"、"sｂ"、"_紘玉" を返します。

なお、"99" の次は "100" になるのに対し、
"９９" の次は "１００" にはならないことに注意。
"Ａｚ" や "ｚｚ" も同様です。
#@# CozoH: このあたり、もっと正確で分かりやすい説明が欲しいです。私自身、よく分かっていないので。

--- tr(search, replace)
--- tr!(search, replace)
#@todo

[[m:String#tr]] の日本語対応版です。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'
  zstr = 'ＡＡＢＢＣＣ'
  hoge = 'hhoge'

  p zstr.tr('Ａ-Ｚ','A-Z')    # => "A疏疏汰汰蛋\303"
  p hoge.tr('a-z','Ａ-Ｚ')    # => "旙旙\332"

  require 'jcode'
  p zstr.tr('Ａ-Ｚ','A-Z')    # => "AABBCC"
  p hoge.tr('a-z','Ａ-Ｚ')    # => "ＨＨＯＧＥ"

--- tr_s(search, replace)
--- tr_s!(search, replace)
#@todo

[[m:String#tr_s]] の日本語対応版です。

  $KCODE = 'EUC'

  p "foo".tr_s("o", "f")        # => "ff"
  p "ｆｏｏ".tr_s("ｏ", "ｆ")   # => TODO: fill result

  require 'jcode'
  p "foo".tr_s("o", "f")        # => "ff"
  p "ｆｏｏ".tr_s("ｏ", "ｆ")   # => "ｆｆ"
