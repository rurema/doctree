#@if (version < "1.9.0")
[[c:String]]クラスのメソッドを追加、再定義し、
日本語を意識した文字列処理を提供します。
対象の文字列のエンコーディングが [[m:$KCODE]] で
指定されたものとして処理します。

[[m:String#chop]]、[[m:String#delete]] といった既存の
メソッドを置き換えるため、別のライブラリの
動作が変化してしまう可能性があります。
そのためこのライブラリを使ってよいのは
利用しているライブラリを含め
動作しているソースすべてが把握可能な場合のみです。

=== 使用例 

  require 'jcode'
  $KCODE = 'EUC' # 漢字コードをEUC-JPに。Windows で Shift JIS なら 'SJIS' にする
  puts 'abcdef'.tr('a-z', 'Ａ-Ｚ')

$KCODE はこのスクリプト自体の文字コードあわせて設定します。

= reopen String

== Methods

#@if (version <= "1.8.6")
--- each_char -> [String]
--- each_char {|char| ... } -> String
文字列中の各文字に対してブロックを呼びだします。
ブロックを指定せずに呼び出された時には、各文字の配列を返します。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'

  require 'jcode'

  zstr = 'ＡＢＣＤＥＦ'
  zstr.each_char do |x|
    print "+#{x}+"
  end                     # => +Ａ++Ｂ++Ｃ++Ｄ++Ｅ++Ｆ+
#@end

#@# --- end_regexp
#@# 
#@# 最後の文字が多バイト文字である文字列にマッチする正規表現を返します。
#@# 再定義された [[m:String#succ]] で内部的に使われます。

--- jcount(str) -> Integer
[[m:String#count]] の日本語対応版です。

self に文字列 str で指定した文字がいくつ含まれているかを数えます

ただし [[m:String#count]] とは異なり利用できるパターンは
"Ａ-Ｄ" のような「^」(否定)を含まないパターンのみであり、
また複数のパターンを取ることはできません。

@param str 出現回数を数える文字のパターン 

例：

  #!/usr/bin/env ruby

  $KCODE = 'e'
  zstr = 'ＡＢＣＤＥＦ'
  hogehoge = 'hogehoge'

  p zstr.count('Ａ')     # => 7   これは正しくない
  p zstr.jcount('ＡＢ')  # => 8 
  p hogehoge.count('g')  # => 2

  require 'jcode'
  p zstr.jcount('Ａ')    # => 1   これは正しい
  p hogehoge.jcount('g') # => 2

  p zstr.jcount('ＡＢ')  # => 2 


--- jlength -> Integer
--- jsize -> Integer

[[m:String#length]] の日本語対応版です。

文字数を整数で返します。

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

--- mbchar? -> Integer|nil

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

#@# 以下の定数、メソッドは内部的に用いられ、ユーザが使うべきでない。  
#@# == Constant
#@# --- PATTERN_SJIS
#@# --- PATTERN_EUC
#@# --- PATTERN_UTF8
#@# --- RE_SJIS
#@# --- RE_EUC
#@# --- RE_UTF8
#@# --- SUCC
#@# --- HashCache 
#@# --- TrPatternCache
#@# --- DeletePatternCache
#@# --- SqueezePatternCache
#@# == Private Instance Methods
#@# --- _regex_quote(str) 
#@# --- _expand_ch(str)
#@# --- _expand_ch_hash(from, to)

= redefine String

== Methods

#@since 1.8.7
--- each_char -> [String]
--- each_char {|char| ... } -> String
文字列中の各文字に対してブロックを呼びだします。
ブロックを指定せずに呼び出された時には、各文字の配列を返します。

例：

  #!/usr/bin/env ruby

  $KCODE = 'EUC'

  require 'jcode'

  zstr = 'ＡＢＣＤＥＦ'
  zstr.each_char do |x|
    print "+#{x}+"
  end                     # => +Ａ++Ｂ++Ｃ++Ｄ++Ｅ++Ｆ+
#@end

--- chop -> String
--- chop! -> String|nil

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

--- delete(str) -> String
--- delete!(str) -> String|nil

[[m:String#delete]] の日本語対応版です。

ただしこのメソッドは置き換え前の物とは異なり
複数の引数を取れません。

@param str 取り除く文字のパターン。

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
    
--- squeeze([str]) -> String
--- squeeze!([str]) -> String|nil

[[m:String#squeeze]] の日本語対応版です。

ただしこのメソッドは置き換え前の物とは異なり、
2つ以上の引数を取ることはできません。

@param str 1文字にまとめる文字のパターン。

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
    
--- succ -> String
--- succ! -> String|nil

[[m:String#succ]] の日本語対応版です。

以下のような次の文字列を返します。

  "あaあ".succ => "あaぃ"
  "rｂ".succ => "rｃ"
  "_紅玉".succ => "_紅桐"

従来の [[m:String#succ]] は、
多バイト文字と半角文字が混在している文字列を
意図通りに処理することができません。
例えば上記のコードは、それぞれ
"あbあ"、"sｂ"、"_紘玉"(最後のは SJIS 環境の場合の例で、
EUC-JP の場合はこうはなりません)を返します。

なお、"99" の次は "100" になるのに対し、
"９９" の次は "１００" にはならないことに注意。
"Ａｚ" や "ｚｚ" も同様です。つまり多バイト文字では
従来の [[m:String#succ]] のようなアルファベットや数字に
関する繰り上げを行わないということです。
#@# CozoH: このあたり、もっと正確で分かりやすい説明が欲しいです。私自身、よく分かっていないので。

--- tr(search, replace) -> String
--- tr!(search, replace) -> String|nil

[[m:String#tr]] の日本語対応版です。

例:

  #!/usr/bin/env ruby

  $KCODE = 'EUC'
  zstr = 'ＡＡＢＢＣＣ'
  hoge = 'hhoge'

  p zstr.tr('Ａ-Ｚ','A-Z')    # => "A疏疏汰汰蛋\303"
  p hoge.tr('a-z','Ａ-Ｚ')    # => "旙旙\332"

  require 'jcode'
  p zstr.tr('Ａ-Ｚ','A-Z')    # => "AABBCC"
  p hoge.tr('a-z','Ａ-Ｚ')    # => "ＨＨＯＧＥ"

@param search    置き換える文字のパターン
@param replace    pattern で指定した文字を置き換える文字
@see [[m:String#tr_s]]

--- tr_s(search, replace) -> String
--- tr_s!(search, replace) -> String|nil

[[m:String#tr_s]] の日本語対応版です。

@param search    置き換える文字のパターン
@param replace    pattern で指定した文字を置き換える文字
@see [[m:String#tr]]

例:
  $KCODE = 'EUC'

  p "foo".tr_s("o", "f")        # => "ff"
  p "ｆｏｏ".tr_s("ｏ", "ｆ")   # => TODO: fill result

  require 'jcode'
  p "foo".tr_s("o", "f")        # => "ff"
  p "ｆｏｏ".tr_s("ｏ", "ｆ")   # => "ｆｆ"

#@end
