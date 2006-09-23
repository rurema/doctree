組み込みクラス [[c:String]] と [[c:IO]] を拡張します。
[[m:String#scan]] のフォーマット指定版といえるメソッド String#scanf
を定義します。

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

--- scanf(format)
--- scanf(format) {|*ary| ...}

ブロックを指定しない場合、見つかった文字列を format に従って変
換し、そのオブジェクトの配列を返します。
format で指定した文字列が見つからない場合は空の配列を
生成して返します。

ブロックを指定した場合は scanf を継続して実行し、順次
見つかった文字列を変換したオブジェクトの配列を引数にブロックを
実行します。このとき、ブロックの結果の配列を返します。

scanfフォーマット文字列

: space
フォーマット中の空白は(0個を含む)任意の数の空白にマッチします。

  p "a           10".scanf("%s %d")  # => ["a", 10]
  p "a10".scanf("%1s %d")            # => ["a", 10]

: %%
% そのもの

: %d
: %u
符号付き10進数

: %i
[[m:Kernel#Integer]]のように接頭辞を受け付ける符号付き整数

: %o
符号付き8進数

: %x
: %X
符号付き16進数

: %f
: %g
: %e
: %E
符号付き浮動小数点数

: %s
空白文字を含まない文字列
(幅が指定されているときは指定された文字数か空白文字の直前までの短い方)

: %c
1文字(幅が指定されているときは指定された文字数)

: [...]
[[unknown:正規表現/文字クラス]]

= reopen IO
== Instance Methods
--- scanf(format)
--- scanf(format) {|*ary| ...}

[[unknown:執筆者募集]]

= reopen Kernel
== Instance Methods

--- scanf(format)
STDIN.scanf と同じ
