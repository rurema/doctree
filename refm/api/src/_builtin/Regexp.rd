= class Regexp < Object

[[unknown:正規表現]]のクラス。正規表現のリテラルはスラッシュで囲んだ形式
で生成します。

  /^this is regexp/

Regexp.new(string) を使って正規表現オブジェクトを動的に生成する
こともできます。

== Class Methods

--- compile(string[, option[, code]])
--- new(string[, option[, code]])

文字列 string をコンパイルして正規表現オブジェクトを生成して
返します。

第二引数が [[c:Fixnum]] であった場合、その値は

  * [[m:Regexp::IGNORECASE]]
  * [[m:Regexp::MULTILINE]]
  * [[m:Regexp::EXTENDED]]

の論理和でなければなりません。

第二引数が [[c:Fixnum]] 以外であれば真偽値の指定として見なされ、真
(nil, false 以外)であれば [[m:Regexp::IGNORECASE]]
の指定と同じになります。

第三引数が与えられた時には、[[m:$KCODE]] の値にかかわ
らず、指定された文字コードでマッチを行います。文字コードは
$KCODE への代入と同様に文字列引数の最初の一文字で決定されま
す。

第一引数が正規表現であれば内容が同じ(ただし、上記フラグの内容はク
リアされた)正規表現を複製して返します。このとき、複製した正規表現
に対して、第二、第三引数の指定が設定されます。

#@since 1.8.0
((<ruby 1.8 feature>)): 第一引数が正規表現であれば第一引数を複製し
て返します。第二、第三引数は警告の上無視されます。
#@end

正規表現のコンパイルに失敗した場合、例外 [[c:RegexpError]] が発生
します。

--- escape(string[,kcode])
--- quote(string[,kcode])

string の中で正規表現において特別な意味を持つ文字の直前にエ
スケープ文字(バックスラッシュ)を挿入した文字列を返します。省略可能
な引数 kcode で文字列の文字コードを指定します
(省略時は [[m:$KCODE]] の値が使用されます)。

文字コードの指定は $KCODE と同様に行います。

--- last_match

カレントスコープで最後に行った正規表現マッチの [[c:MatchData]] オ
ブジェクトを返します。このメソッドの呼び出しは [[m:$~]]
の参照と同じです。

  /(.)(.)/ =~ "ab"
  p Regexp.last_match      # => #<MatchData:0x4599e58>
  p Regexp.last_match[0]   # => "ab"
  p Regexp.last_match[1]   # => "a"
  p Regexp.last_match[2]   # => "b"
  p Regexp.last_match[3]   # => nil

--- last_match([nth])

整数 nth が 0 の場合、マッチした文字列を返します
([[m:$&]])。それ以外では、nth 番目の括弧にマッチ
した部分文字列を返します([[m:$1]],[[m:$2]],...)。
対応する括弧がない場合やマッチしなかった場合には nil を返し
ます。

  /(.)(.)/ =~ "ab"
  p Regexp.last_match      # => #<MatchData:0x4599e58>
  p Regexp.last_match(0)   # => "ab"
  p Regexp.last_match(1)   # => "a"
  p Regexp.last_match(2)   # => "b"
  p Regexp.last_match(3)   # => nil

正規表現全体がマッチしなかった場合、引数なしの
Regexp.last_match はnil を返すため、
last_match[1] の形式では例外 [[c:NameError]] が発生します。
対して、last_match(1) は nil を返します。

#@since 1.8.1
--- union([pattern, ...])

引数として与えた patttern を選択 | で連結し、Regexp として返します。
結果の Regexp は与えた patttern のどれかにマッチする場合にマッチするものになります。

  p Regexp.union(/a/, /b/, /c/) #=> /(?-mix:a)|(?-mix:b)|(?-mix:c)/

patttern は Regexp または String で与えます。
String で与えた場合、それ自身と等しい文字列のみにマッチするものと解釈され、
エスケープされて結果の Regexp に組み込まれます。

  p Regexp.union("a", "?", "b") # => /a|\?|b/
  p Regexp.union(/a/, "*") # => /(?-mix:a)|\*/

引数をひとつも与えなかった場合、決してマッチしない Regexp を返します。

  p Regexp.union() # => /(?!)/

結果の Regexp が対応する文字コードは引数として与えた Regexp が扱う文字コードに一致します。
固定コードに対してコンパイルされている Regexp を複数与える場合、
それらのコードは一致していなければなりません。
異なる固定コードに対してコンパイルされている Regexp が存在する場合、
ArgumentError が発生します。

  p Regexp.union(/a/e, /b/e) # => /(?-mix:a)|(?-mix:b)/e
  p Regexp.union(/a/e, /b/s) # => ArgumentError

コードが固定されている Regexp とコードが固定されていない Regexp を混ぜた場合、
結果の Regexp は固定されているコードに対応するものになります。

  p Regexp.union(/a/e, /b/) # => /(?-mix:a)|(?-mix:b)/e
#@end

== Instance Methods

--- =~(string)
--- ===(string)

文字列 string との正規表現マッチを行います。マッチした場合、
マッチした位置のインデックスを返します(先頭は0)。マッチしなかった
場合、あるいは string が nil の場合には nil を返
します。

組み込み変数 [[m:$~]] にマッチに関する情報が設定されます。

string がnil でも [[c:String]] オブジェクトでもなけれ
ば例外 [[c:TypeError]] が発生します。

#@since 1.7.0
((<ruby 1.7 feature>)): Regexp#=== は、真偽値を返します。引数が文
字列でないか、マッチしなければ false を、マッチすれば
true を返します。
#@end

--- ~

変数 $_ の値との間でのマッチをとります。ちょうど以下と同じ意
味です。

  self =~ $_

--- casefold?

正規表現が大文字小文字の判定をしないようにコンパイルされている時、
真を返します。

--- kcode

その正規表現が対応するようにコンパイルされている文字コードを
[[m:$KCODE]] と同じ形式で返します。もし、正規表現が固定
コードに対してコンパイルされていない(マッチ時点での $KCODE
の値を用いる)場合には、nil を返します。

--- match(str)
--- match(str[, pos])

[[c:MatchData]] オブジェクトを返す点を除いて、self =~ str と
同じです。マッチしなかった場合 nil を返します。

正規表現にマッチした部分文字列だけが必要な場合に、

  bar = /foo(.*)baz/.match("foobarbaz").to_a[1]
  
  foo, bar, baz = /(foo)(bar)(baz)/.match("foobarbaz").to_a.values_at(1,2,3)

のように使用できます。(to_a は、マッチに失敗した場合を考慮しています。)

#@since 1.8.0
((<ruby 1.8 feature>)):
1.8 の多重代入の規則では右辺が配列でない一つのオブジェクトで to_a
メソッドを持つ場合、右辺に * を付けることで to_a の結果を利用でき
ます。つまり、上記は以下のように書くことができます。(ここでの
`_' は、[[m:$&]] を捨てるために適当に選んだ変数名)

  _, foo, bar, baz = */(foo)(bar)(baz)/.match("foobarbaz")
  p [foo, bar, baz]

  # => ["foo", "bar", "baz"]

このような用途に [[m:MatchData#captures]] が使
えると考えるかも知れませんが、captures では、マッチに失敗した場合、
nil.captures を呼び出そうとして例外 [[c:NoMethodError]] が発生して
しまいます。

  foo, bar, baz = /(foo)(bar)(baz)/.match("foobar").captures

  # => -:1: undefined method `captures' for nil:NilClass (NoMethodError)
#@end

#@since 1.9.0
((<ruby 1.9 feature>)):
省略可能な第二引数 pos を指定すると、マッチの開始位置を pos から行
うよう制御できます(pos のデフォルト値は 0)。

  p(/(.).(.)/.match("foobar", 3).captures)   # => ["b", "r"]
  p(/(.).(.)/.match("foobar", -3).captures)  # => ["b", "r"]

pos を指定しても [[m:MatchData#offset]] 等の結果
には影響しません。つまり、
  re.match(str[pos..-1])
と
  re.match(str, pos)
は異なります。
#@end

--- options

正規表現の生成時に指定されたオプションを返します。戻り値は、
Regexp::EXTENDED, Regexp::IGNORECASE,
Regexp::MULTILINE の論理和です。

  p Regexp::IGNORECASE # => 1
  p //i.options        # => 1

--- source

その正規表現のもととなった文字列表現を生成して返します。

  re = /foo|bar|baz/i
  p re.source     # => "foo|bar|baz"

--- to_s

正規表現の文字列表現を生成して返します。返される文字列は他の正規表
現に埋め込んでもその意味が保持されるようになっています。

  re = /foo|bar|baz/i
  p re.to_s       # => "(?i-mx:foo|bar|baz)"
  p /#{re}+/o     # => /(?i-mx:foo|bar|baz)+/

ただし、後方参照を含む正規表現は意図通りにはならない場合があります。
これは現状、後方参照を番号でしか指定できないためです。

  re = /(foo|bar)\1/      # \1 は、foo か bar
  p /(baz)#{re}/          # \1 は、baz
  
  # => /(baz)(?-mix:(foo|bar)\1)/

== Constants

--- EXTENDED

バックスラッシュでエスケープされていない空白と # から改行までを無
視します。[[unknown:リテラル/正規表現リテラル]] の //x オプションと同じ
です。(空白を入れる場合は\でエスケープして\ (<-空白)と
指定します)

--- IGNORECASE

文字の大小の違いを無視します。
[[unknown:リテラル/正規表現リテラル]] の //i オプションと同じです。

--- MULTILINE

複数行モード。正規表現 "." が改行にマッチするようになります。
[[unknown:リテラル/正規表現リテラル]] の //m オプションと同じです。
