= Rubyで使われる記号の意味（正規表現の複雑な記号は除く）

[[ref:ex]]　[[ref:q]]　[[ref:num]]　[[ref:per]]　[[ref:and]]　[[ref:or]]　
[[ref:plus]]　[[ref:minus]]　[[ref:ast]]　[[ref:slash]]　[[ref:hat]]　[[ref:sq]]　
[[ref:period]]　[[ref:comma]]　[[ref:langl]]　[[ref:rangl]]　[[ref:eq]]　[[ref:tilde]]　
[[ref:dollar]]　[[ref:at]]　[[ref:under]]　[[ref:lbra]][[ref:rbra]]　
[[ref:lbra2]][[ref:rbra2]]　[[ref:lbra3]][[ref:rbra3]]　[[ref:dq]]　[[ref:colon]]　[[ref:ac]]　
[[ref:backslash]]　[[ref:semicolon]]

===[a:ex] !

:  !true 

 not 演算子。[[ref:d:spec/operator#not]]を参照。

: 3 != 5

 「等しくない」比較演算子。[[ref:d:spec/operator#not]]を参照。

: def xxx!

 「!」はメソッド名の一部です。慣用的に、
 同名の(! の無い)メソッドに比べてより破壊的な作用をもつメソッド(例: tr と tr!)で使われます。

: /xxx/ !~ yyy

 正規表現のメソッド =~ の否定。マッチが失敗したらtrueを返します。


===[a:q] ?

:  ?a 

#@since 1.9.1
 [[ref:d:spec/literal#string]]。長さ 1 の文字列。
#@else
 [[ref:d:spec/literal#num]]。文字の ascii コードの数値。
#@end

: def xx?

 この場合の「?」はメソッド名の一部分です。
 慣用的に、真偽値を返すタイプのメソッドを示すために使われます。

: xx ? yy : zz

 [[ref:d:spec/operator#cond]]。三項演算子とも呼ばれます。if xx then yy else zz end と同じ意味です。

: /xxx?/

 正規表現の、量指定子(quantifiers)。直前の正規表現の 0 または 1 回の繰り返し。

===[a:num] #

: #コメント
 [[ref:d:spec/lexical#comment]]。# から行末までがコメントになります。

: xxx #=> 実行結果
: xxx # => 実行結果

 慣用的に実行結果を示すために使われるコメントの書き方。

: #! ruby -Ks

 shebang。[[ref:d:spec/rubycmd#shebang]]を参照。

: # coding: utf-8

 マジックコメント。[[ref:d:spec/m17n#magic_comment]] を参照。

: "a is #{a}"

 [[ref:d:spec/literal#exp]]
//emlist{
  a = 10
  p "a is #{a}"  #=> "a is 10"
//}

: Range#each

 説明文の中でのみ使われます。Ruby言語の要素ではありません。クラスのインスタンスメソッドであることを
 簡単に表示するための表記法です。一方、クラスメソッドは「Range.new」のように「.」でつなぎます。

===[a:per] %

:  10 % 3 

 各クラスで定義された「%」演算子。整数クラスでは「剰余」を意味するメソッド。[[m:Numeric#%]]メソッドなどを参照。

:  "%04b" % 10 

 Stringクラスの「%」演算子。[[m:String#%]] メソッド。文字列中ではフォーマット指定子としても使われる。

: %r{/etc/httpd/logs$} や %w[foo bar baz] ・・ %<文字><区切り文字><文字列><区切り文字>

 [[ref:d:spec/literal#percent]]。<区切り文字>には任意の非英数字を用いることができ、
 <文字>によって式の意味が異なります。なお、最初の <区切り文字> が、左側の角括弧 [、丸括弧 (、
 ブレース {、小なり不等号 <、の場合は、対応する右側の括弧が終わりの <区切り文字> になります。
//emlist{
    p %r{/etc/httpd/logs$} #=> /\/etc\/httpd\/logs$/
    p %w[foo bar baz] #=> ["foo", "bar", "baz"]
//}

: %!STRING!

 % 記法の一種。[[ref:d:spec/literal#percent]]。ダブルクォート文字列で %Q!STRING! と同じ。
//emlist{
    p %!nomad! #=> "nomad"
//}

: % ruby -e "puts 'Hello'"

 コマンドラインへの入力を示す。rubyスクリプト上で入力を行うには `command` や system(command) などと書く

===[a:and] &

: xxx & yyy

 論理積演算子。または類似の演算を行うメソッド。
//emlist{
    p( 3 & 5 ) #=> 1 ・・ 二進数で 0011 & 0101 #=> 0001
//}

: a &= yyy

 「&」メソッドの自己代入演算子。

: xxx && yyy

 「and」演算子。
//emlist{
    p( 3 && 5 ) #=> 5 ・・ 3 も 5 も真なので右の値を返す。
//}

: def xxx(&yyy) ・・ &がついた引数

 メソッド定義のブロック引数。[[ref:d:spec/def#method]]を参照。

: xxx(&b)

 [[c:Proc]] オブジェクトをブロックとして使う。[[ref:d:spec/call#block]] を参照。

: xxx&.yyy

 safe navigation operator（通称「ぼっち演算子」）。xxx が nil でないときにメソッドyyyを呼び出す。[[d:spec/call]] を参照。

===[a:or] |

:  3 | 5 

 論理和演算子または類似のメソッド。二進数で 0011 | 0101 => 0111。

:  3 || 5 

 「or」演算子または類似のメソッド。3 は真なので左の値を返す。

: a ||= xxx

 「||」演算子の自己代入演算子。a が 偽 か 未定義 なら a に xxx を代入する、という意味になります。
//emlist{
  a ||= :some
  p a #=> some
  a ||= :sec
  p a #=> some
//}

: 5.times{|n| p n}

 ブロックパラメータであることを示す区切り文字。

: /xx(xx|xx)/

 正規表現の選択

===[a:plus] +

: 2 + 3

 たし算。または類似の演算を行うメソッド。

: + 3

 正の数を表す、単項演算子+。

: /xxx+/

 正規表現の、量指定子(quantifiers)。直前の表現の 1 回以上の繰り返し

===[a:minus] -

: 3 - 2

 引き算。または類似のメソッド


: 3 * (-5)

 単項 - (マイナス)。混乱を避けるため適宜()でくくるとよい。

: % ruby -w など コマンドラインの入力 -AAA

 コマンドラインオプション

===[a:ast] *

: 2 * 3

 かけ算。または類似の演算を行うメソッド。

: 2**3

 累乗。または類似の演算を行うメソッド。

: def xxx(*yy) ・・ *がついた引数

 メソッド呼出の引数展開。[[d:spec/call]] と [[ref:d:spec/def#method]] を参照。

: x, *y = foo()

 多重代入。[[ref:d:spec/operator#multiassign]] を参照。

: /xx*/

 正規表現の、直前の表現の 0 回以上の繰り返し。できるだけ長くマッチしようとする。
 [[d:spec/regexp]] を参照。

===[a:slash] /

: 10 / 3

 割り算、または類似のメソッド。

: /xxx/

 [[ref:d:spec/literal#regexp]]。

: '1二三四5'.split(//)

  // は空の正規表現を意味する

===[a:hat] ^

:  true ^ true 

 「xor」演算子。排他的論理和。または類似のメソッド。

: a ^= true

 「^」演算子の自己代入演算子。aの論理値の反転。
//emlist{
    p(a=true);p(a^=true);p(a^=true) #=> true false true
//}

: /^xxx/

 正規表現で、行頭。文字列の先頭や改行文字の直後の位置にマッチします。

===[a:colon] :

: :exit等の:のついた識別子

 シンボルリテラル。[[ref:d:spec/literal#symbol]] を参照。

: Net::HTTP

 定数のスコープ演算子。[[ref:d:spec/variables#const]] を参照。

: ::DateTime

 定数のスコープ演算子で、トップレベルの定数であることを示す。Object クラスで
 定義されている定数(トップレベルの定数と言う)を確実に参照するためには
 [[ref:d:spec/variables#const]] を参照。

: xx ? yy : zz

 条件演算子。三項演算子とも呼ばれます。if xx then yy else zz end と同じ意味です。
 [[ref:d:spec/operator#cond]] を参照。

#@until 1.9.1
: if 30 > 20 : ... など 条件式 式 :

 thenの省略形。条件式と式を同一行に書きたいときの表記法。

 Ruby1.9.1 以降では使用できません。
#@end

#@since 1.9.1
: { a:"aaa", b:"bbb" }

 ハッシュの新しい記法。以下と同じです。
//emlist{
{ :a => "aaa", :b => "bbb" }
//}
#@end

===[a:period] .

: xxx.yyy

 オブジェクトのメソッド

: Range.new

 オブジェクトのメソッドだが、説明文の中では特にクラスのクラスメソッド／モジュールの
 モジュールメソッドを示すことに使われます。一方、インスタンスメソッドは「Range#each」のように
 「#」でつなぎます。

: 1 .. 20

 最大値を含む Range オブジェクトを作る範囲演算子です。全体で範囲式といいます。[[ref:d:spec/operator#range]]。

: 1 ... 20

 最大値を含まない Range オブジェクトを作る範囲演算子です。
 全体で範囲式といいます。[[ref:d:spec/operator#range]]。

: if /^begin/ .. /^end/ など 条件式 式 .. 式

 条件式中の範囲式は特別にフリップフロップのように働きます。

//emlist{
    '1234543212345'.each_char { |n| print( (n == ?2)..(n == ?4) ? n : '_' ) } #=> _234___21234_
    #"2"が出るまではfalse、"2"が出てから"4"が出るまではtrue、"4"から"2"まではfalseを返す。
//}

: /xx.xx/

 正規表現の任意の一文字。

===[a:comma] ,

: a,b, = [1,2,3] ・・ 代入の左辺の「,」

 多重代入。[[ref:d:spec/operator#multiassign]]を参照。

: a = b, c

 多重代入。[[ref:d:spec/operator#multiassign]]を参照。

: def foo(bar, baz)

 メソッド引数の区切り。

: { :a => 1, :b => 2 }

 ハッシュの要素の区切り。

: [:a, :b, :c]

 配列の要素の区切り。

: { :a => 1, :b => 2 }.each{|key, val|}

 ブロックパラメータの区切り。

===[a:langl] <

: 3 < 5

 「より小さい」比較演算子

: 3 <= 5

 「より小さいか等しい」比較演算子

: 3 <=> 5

 基本的な比較演算子。ほかの比較演算子はこの演算子を元に [[c:Comparable]] モジュールで定義されています。
 左が大きければ 1, 等しければ0, 右が大きければ -1 を返すように作ることが期待されています。

: 3 << 1

 シフト演算を行うメソッド。または類似のメソッド。[[m:Array#<<]] など。

: a <<= 1

 「<<」演算子の自己代入演算子。
//emlist{
  a = 3
  a <<= 1
  p a #=> 6
//}

: <<EOS または <<-EOS 、<<"EOS" など。

 ヒアドキュメントです。[[ref:d:spec/literal#here]]。ヒアドキュメントは `<<識別子' を含む行の次の行から
 `識別子' だけの行の直前までを文字列とする行指向のリテラルです。

: class Foo < Super

 クラス定義でスーパークラスを指定しています。
 [[ref:d:spec/def#class]]。

: class << obj

 特異クラス定義。[[ref:d:spec/def#singleton_class]]を参照。

===[a:rangl] >

: 3 > 5

 「より大きい」比較演算子

: 3 >= 5

 「より大きいか等しい」比較演算子

: 3 <=> 3

 基本的な比較演算子。ほかの比較演算子はこの演算子を元に [[c:Comparable]] 
 モジュールで定義されています。左が大きければ1, 等しければ0, 右が大きければ -1 
 を返すように作ることが期待されています。

: 3 >> 1

 シフト演算子。または類似のメソッド。

: a >>= 1

 「>>」演算子の自己代入演算子。
//emlist{
  a = 3
  a >>= 1
  p a #=> 1
//}

: { 1 => "11" , 3 => "333" }

 ハッシュのリテラル

#@since 1.9.1
: ->(a,b){ p [a,b] }

 Ruby1.9 で導入された lambda の新しい記法。以下と同じ。
//emlist{
lambda{|a, b| p [a, b] }
//}

#@end

===[a:eq] =

: a = 12

 代入演算子。

: xxx.a = 12

 代入メソッドの呼び出し。

: a == 12

 等号演算子。または類似のメソッド。

: a === 12

 特殊な等号演算子。[[m:Object#===]]での説明：「このメソッドは case 文での比較に用いられます。
 デフォルトは Object#== と同じ働きをしますが、 この挙動はサブクラスで所属性のチェックを実現するため 
 適宜再定義されます」。たとえば、[[m:Range#===]] はother が範囲内に含まれている時に真を返します。

: a += 12 , a *= 12 , a ||= 12 など・・a 二項演算子 = b

 自己代入演算子。[[ref:d:spec/operator#selfassign]]を参照。
//emlist{
  a = 7
  a **= 2
  p a #=> 49
//}

: def xx=

 この場合の「=」はメソッド名の一部分です。このタイプの名前のメソッドを定義すると、
 同時に「=」演算子を定義することになります。

: =begin ・・ =end

 埋め込みドキュメントです。[[ref:d:spec/lexical#embed]]を参照。

: { 1 => "11" , 3 => "333" }

 ハッシュのリテラル

: rescue => XXX

 例外処理で例外結果を変数 XXX に代入します。

: xxx #=> 実行結果

 慣用的に実行結果を示すために使われるコメントの書き方。

===[a:tilde] ~

: '%04b %04b' % [3, ~ 3]

 ビット演算の否定。
//emlist{
 '%04b %04b' % [3, ~ 3] #=> "0011 ..100"
//}

: /xxx/ =~ yyy

 正規表現のメソッド =~ 。正規表現と文字列をマッチさせる。両辺を入れ替えても機能します。

: /xxx/ !~ yyy

 正規表現のメソッド =~ の否定。マッチが失敗したらtrueを返します。

: ~ /xxx/

 /xxx/ =~ $_ の省略形。~の後ろは正規表現でなければいけません。

===[a:dollar] $

: $xxx

 グローバル変数。[[ref:d:spec/variables#global]]を参照。

: $_ や $! など ・・$<1文字の数字、記号>

 特殊変数(組み込み変数)。[[ref:d:spec/variables#builtin]] を参照。

: /xx$/

 正規表現で行末。文字列の末尾や改行文字の直前の位置にマッチします。改行自身は含みません。
 [[d:spec/regexp]]を参照。

===[a:at] @

: @xxx

 インスタンス変数。[[ref:d:spec/variables#instance]]を参照。

: @@xxx

 クラス変数。[[ref:d:spec/variables#class]]を参照。

: def +@ または def -@

 単項演算子 +X や -X を定義するときの表記法。
//emlist{
  class Symbol
    def +@
      self.upcase
    end
  end

  puts(+:joke) #=> JOKE
//}

===[a:under] _

: xxx_yyy

 識別子の中では小文字と同じ扱い

: 123_456

 文字コード以外の数値リテラルには、`_' を含めることができます。 ruby インタプリタは `_' を単に無視し、
 特別な解釈は何もしません。 これは、大きな数値の桁数がひと目でわかるように記述するのに便利です。
 [[ref:d:spec/literal#num]]を参照。

===[a:lbra] {
===[a:rbra] }

: { 1 => "11" , 3 => "333" }

 ハッシュのリテラル

: 5.times{|n| p n}

 ブロック

: /xx{2,3}/

 正規表現の、範囲指定繰り返し制御(interval quantifier)。

: "a is #{a}"

 式展開。[[ref:d:spec/literal#exp]]を参照。
//emlist{
  a = 10
  p "a is #{a}"  #=> "a is 10"
//}

===[a:lbra2] [
===[a:rbra2] ]

: [1,"some",:ok]

 配列のリテラル

: 'abcde'[1,2]

 []メソッドの実行
//emlist{
  class String
    def [](*a)
      '(^^;'
    end
  end
  p( 'abcde'[1,2] )  #=> "(^^;"
//}

: /xx[abc]/

 正規表現の文字クラス指定。

===[a:lbra3] (
===[a:rbra3] )

: (true and false)
: p({})

 丸カッコ()は厳密には、複数の文、式をまとめてひとつの式にするグループ化の()（上の例のカッコ）とメソッドの引数を明示する()（下の例のカッコ）があります。下の例はカッコを省略した場合に引数として解釈されません。例のような特別な場合を除き、普段は使い分けを意識する必要はありません。()は意味が不明瞭にならない範囲で省略が可能です。

===[a:dq] "

: "abc"

 文字列リテラル。式展開などが可能なタイプの文字列リテラルです。
 [[ref:d:spec/literal#string]]を参照。

===[a:sq] '

: 'abc'

 文字列リテラル。最低限のエスケープだけしかしません。式展開などをしたい場合はかわりに""を用います。

===[a:ac] `

: `ls`

 コマンド出力。バッククォート(`)で囲まれた文字列は、コマンドとして実行され、
 その標準出力が文字列として与えられます。[[ref:d:spec/literal#command]]を参照。
//emlist{
    puts `ruby -h`
    #=> Usage: ruby [switches] [--] [programfile] [arguments]
    #=> ....
//}

===[a:backslash] \
バックスラッシュ。環境によって¥に見えたりします。

: puts "abc\"def"

 文字列や正規表現の中のエスケープ。
//emlist{
 puts "abc\"def" #=> abc"def
//}

: xxx \

 継続行。改行の直前に置かれる。パースの段階で直後の改行が存在しないものとして扱われます。
//emlist{
    puts(3 \
    + 4) #=> 7
//}

===[a:semicolon] ;

: a = 3 ;

 式の区切り。改行と同じ

#@since 1.9.1
: [1,2,3].each{|v; z| z = v * 2 ... }

  ブロックローカル変数を宣言するための区切り。
#@end
