#@until 1.9.1
category CharacterEncoding

[[c:String]]クラスのメソッドを追加、再定義し、
日本語を意識した文字列処理を提供します。

対象の文字列のエンコーディングが [[m:$KCODE]] で
あるものとして処理します。つまりスクリプト中で
[[m:$KCODE]] を変更すると以後メソッドの動作が変わります。

[[m:String#chop]]、[[m:String#delete]] といった既存の
メソッドを置き換えるため、別のライブラリの
動作が変化してしまう可能性があります。
そのためこのライブラリを使ってよいのは
利用しているライブラリを含め
動作しているソースすべてが把握可能な場合のみです。

マルチバイト文字列の取扱に関する問題を
このライブラリで解決しようとするのはお勧めしません。
Ruby の文字列のエンコーディングの取り扱いに関しては、
[[d:spec/rubycmd]] の -K オプションの所や、 [[m:$KCODE]] を
見てください。

=== 使用例 

  #!/usr/bin/ruby -Ke
  # -*- coding: euc-jp -*-
  # 漢字コードをEUC-JPに。
  # Windows で Shift JIS なら -Ks, coding: cp932 にする
  
  # jcode ライブラリを読み込み、メソッドの追加、再定義を行う
  require 'jcode' 
  
  # 再定義された String#tr を呼びだす
  puts 'abcdef'.tr('a-z', 'Ａ-Ｚ')

= reopen String

== Methods

#@until 1.8.7
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

@param str 出現回数を数える文字のパターンを文字列で与えます。

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

--- chop! -> self | nil

[[m:String#chop!]] の日本語対応版です。

--- delete(str) -> String

[[m:String#delete]] の日本語対応版です。
指定したパターンの文字列を取り除きます。

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

--- delete!(str) -> self|nil

[[m:String#delete!]] の日本語対応版です。
指定したパターンの文字列を破壊的に取り除きます。

ただしこのメソッドは置き換え前の物とは異なり
複数の引数を取れません。

@param str 取り除く文字のパターン。

--- squeeze(str = nil) -> String

[[m:String#squeeze]] の日本語対応版です。
指定した文字を1文字にまとめた文字列を返します。

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

--- squeeze!(str = nil) -> self | nil

[[m:String#squeeze!]] の日本語対応版です。
指定した文字を1文字にまとめた文字列に自身を置き換えます。

ただしこのメソッドは置き換え前の物とは異なり、
2つ以上の引数を取ることはできません。

@param str 1文字にまとめる文字のパターン。
    
--- succ -> String

[[m:String#succ]] の日本語対応版です。
「次の」文字列を返します。

以下のような次の文字列を返します。

  "あaあ".succ # => "あaぃ"
  "rｂ".succ # => "rｃ"
  "_紅玉".succ # => "_紅桐"

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

--- succ! -> self | nil

[[m:String#succ!]] の日本語対応版です。
自身を「次の」文字列に置き換えます。

--- tr(search, replace) -> String

[[m:String#tr]] の日本語対応版です。
search に含まれる文字を検索し、 replace の対応する文字に
置き換えた文字列を返します。

@param search    置き換える文字のパターン
@param replace    pattern で指定した文字を置き換える文字

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

@see [[m:String#tr_s]]

--- tr!(search, replace) -> self | nil

[[m:String#tr!]] の日本語対応版です。
search に含まれる文字を検索し、 replace の対応する文字に
破壊的に置き換えます。

@param search    置き換える文字のパターン
@param replace    pattern で指定した文字を置き換える文字

--- tr_s(search, replace) -> String

[[m:String#tr_s]] の日本語対応版です。
文字列の中に search 文字列に含まれる文字が存在したら、
replace 文字列の対応する文字に置き換え、
置換した部分内に同一の文字の並びがあったらそれを 
1 文字に圧縮した文字列を返します。

@param search    置き換える文字のパターン
@param replace    pattern で指定した文字を置き換える文字

例:
  $KCODE = 'EUC'

  p "foo".tr_s("o", "f")        # => "ff"
  p "ｆｏｏ".tr_s("ｏ", "ｆ")   # => TODO: fill result

  require 'jcode'
  p "foo".tr_s("o", "f")        # => "ff"
  p "ｆｏｏ".tr_s("ｏ", "ｆ")   # => "ｆｆ"

--- tr_s!(search, replace) -> self | nil

[[m:String#tr_s!]] の日本語対応版です。
文字列の中に search 文字列に含まれる文字が存在したら、
replace 文字列の対応する文字に置き換えます。さらに、
置換した部分内に同一の文字の並びがあったらそれを 
1 文字に圧縮します。

@param search    置き換える文字のパターン
@param replace    pattern で指定した文字を置き換える文字

#@end


