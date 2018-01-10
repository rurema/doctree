category I/O

[[m:String#scan]] のフォーマット指定版といえるメソッド [[m:String#scanf]]
を定義します。

組み込みクラス [[c:String]] と [[c:IO]] を拡張します。

=== 例
  require 'scanf'
  
  p "a 10  1.2".            scanf("%s %d %f")   # => ["a", 10, 1.2]
  p "a 10  1.2 b 20 1.5e10".scanf("%s %d %f")   # => ["a", 10, 1.2]
  p "a 10  1.2 b 20 1.5e10".scanf("%s %d %f") {|*v| v}
                  # => [["a", 10, 1.2], ["b", 20, 15000000000.0]]
  
  p "a 10  1.2 b 20 1.5e10 c".scanf("%s %d %f") {|*v| v}
                 # => [["a", 10, 1.2], ["b", 20, 15000000000.0], [["c"]]]
  
                                                       #    [["c"]] (?)
  
  require 'scanf'
  p "a, 10, 1.2".scanf("%s,%d,%f")
  # => ["a,"]      %s が "," を飲み込むからダメらしい
  
  p "a, 10, 1.2".scanf("%1s,%d,%f")
  # => ["a", 10, 1.2]
  
  p "a, 10, 1.2".scanf("%[^,],%d,%f")
  # => ["a", 10, 1.2]

= reopen String

== Instance Methods

--- scanf(format) -> Array
--- scanf(format) {|*ary| ...} -> Array

ブロックを指定しない場合、見つかった文字列を format に従って変
換し、そのオブジェクトの配列を返します。
format で指定した文字列が見つからない場合は空の配列を
生成して返します。

  require 'scanf'
  str = "123 abc 456 def 789 ghi"
  p str.scanf("%d%s") #=> [123, "abc"]

ブロックを指定した場合は scanf を継続して実行し、順次
見つかった文字列を変換したオブジェクトの配列を引数に、ブロックを
実行します。このとき、ブロックの実行結果を要素とする配列を返します。

  require 'scanf'
  str = "123 0x45 678 0x90"
  p str.scanf("%d%x"){|n, s| [n, s]}
  #=> [[123, 69], [678, 144]]

formatに完全にマッチしていなくても、部分的にマッチしていれば、
ブロックは実行されます。

  require 'scanf'
  str = "123 abc 456 def"
  ret = str.scanf("%s%d") { |s, n| [s, n] }
  p ret #=> [["123", nil], ["abc", 456], ["def", nil]]


@param format スキャンするフォーマットを文字列で指定します。
              詳細は、[[ref:m:String#scanf#format]] を参照してください。

使用例:
  require 'scanf'
  str = "123 abc 456 def 789 ghi"
  p str.scanf("%d%s") #=> [123, "abc"]

===[a:format] scanfフォーマット文字列

文字 '%' と(s,d のような)指示子の間に、整数を指定する事により読み込む文字列の幅を
指定する事ができます。もし幅が与えられなければ、無限大の値が規定値として使用されます。
(但し、%c では、この規定値は適用されません。) 
上記の幅が整数 n で与えられた場合、多くても n 個の文字列がマッチします。
このフォーマット文字列によるマッチの実行前、多くの場合入力文字列のスペースは読み飛ばされます。
つまり、スペースは幅の数として数えられない事になります。

動作例;
  require 'scanf'
  p "a           10".scanf("%s %d")  # => ["a", 10]
  p "a10".scanf("%1s %d")      # => ["a", 10]


使用例；
  require 'scanf'
  str = "1234"
  p str.scanf("%1s%3d")  #=> ["1", 234]

#@since 1.9.1
また、1.9 以降では、スペースには全角文字列が含まれます。

動作例；
  # encoding: utf-8
  require 'scanf'

  str = "1　　　　　aaa"
  p str.scanf("%d %s") #=> [1, "aaa"]
#@end

#@# There may be an optional maximum field width, expressed as a decimal
#@# integer, between the % and the conversion. If no width is given, a
#@# default of `infinity' is used (with the exception of the %c specifier;
#@# see below).  Otherwise, given a field width of <em>n</em> for a given
#@# conversion, at most <em>n</em> characters are scanned in processing
#@# that conversion.  Before conversion begins, most conversions skip
#@# white space in the input string; this white space is not counted
#@# against the field width.


: space
 フォーマット中の空白は(0個を含む)任意の数の空白にマッチします。
//emlist{
  require 'scanf'
  p "a           10".scanf("%s %d")  # => ["a", 10]
  p "a10".scanf("%1s %d")            # => ["a", 10]
//}
: %%
 % そのもの

: %d
: %u
 符号付き10進数

: %i
 [[m:Kernel.#Integer]]のように接頭辞を受け付ける符号付き整数

: %o
 符号付き8進数

: %x
: %X
 符号付き16進数

#@since 1.9.2
: %e
#@end
: %f
#@since 1.9.2
: %g
: %E
: %F
: %G
: %a
: %A
#@end
 符号付き浮動小数点数

: %s
 空白文字を含まない文字列
 (幅が指定されているときは指定された文字数か空白文字の直前までの短い方)

: %c
 1文字(幅が指定されているときは指定された文字数)

: [...]
 [[ref:d:spec/regexp#string]]

= reopen IO
== Instance Methods
--- scanf(format) -> Array
--- scanf(format) {|*ary| ...} -> Array

[[m:String#scanf]]も参照してください。

@param format スキャンするフォーマットを文字列で指定します。
              詳細は、[[ref:m:String#scanf#format]] を参照してください。

#@#The trick here is doing a match where you grab one line of input at a time. 
#@#The linebreak may or may not occur at the boundary where the string matches 
#@#a format specifier. And if it does, some rule about whitespace may or may not 
#@#be in effect...
#@#
#@#That’s why this is much more elaborate than the string version.
#@#
#@#For each line: 
#@#
#@#Match succeeds (non-emptily) 
#@#
#@#a) and the last attempted spec/string sub-match succeeded:
#@#
#@#  a-1) could the last spec keep matching?
#@#    yes: save interim results and continue (next line)
#@#
#@#b) The last attempted spec/string did not match:
#@#
#@#  b-1)are we on the next-to-last spec in the string?
#@#
#@#  yes:
#@#    is fmt_string.string_left all spaces?
#@#      yes: does current spec care about input space?
#@#        yes: fatal failure
#@#        no: save interim results and continue
#@#  no: continue  [this state could be analyzed further]
#@#

= reopen Kernel
== Private Instance Methods

--- scanf(format) -> Array
--- scanf(format) {|*ary| ...} -> Array

STDIN.scanf と同じです。
[[m:IO#scanf]]、[[m:Stdin#scanf]]も参照してください。

@param format スキャンするフォーマットを文字列で指定します。
              詳細は、[[ref:m:String#scanf#format]] を参照してください。

@see [[m:IO#scanf]], [[m:Stdin#scanf]]

= module Scanf

scanf ライブラリで使用する名前空間です。

@see [[m:Kernel.#scanf]], [[m:String#scanf]], [[m:IO#scanf]], [[m:Stdin#scanf]]

#@include(scanf/Scanf__FormatString)
#@include(scanf/Scanf__FormatSpecifier)

