#@# = Pattern matching
= パターンマッチ

  * [[ref:patterns]]
  * [[ref:variable_binding]]
  * [[ref:variable_pinning]]
  * [[ref:matching_non_primitive_objects]]
  * [[ref:guard_clauses]]
  * [[ref:current_feature_status]]
  * [[ref:pattern_syntax]]
  * [[ref:some_undefined_behavior_examples]]

#@since 3.0
#@# Pattern matching is a feature allowing deep matching of structured values: checking the structure and binding the matched parts to local variables.
パターンマッチは、構造化された値に対して、構造をチェックし、マッチした部分をローカル変数に束縛するという、深いマッチを可能にする機能です。(『束縛』は、パターンマッチの輸入元である関数型言語の用語で、Ruby では代入と読み替えても問題ありません)
#@else
#@# Pattern matching is an experimental feature allowing deep matching of structured values: checking the structure and binding the matched parts to local variables.
パターンマッチは、構造化された値に対して、構造をチェックし、マッチした部分をローカル変数に束縛するという、深いマッチを可能にする実験的な機能です。(『束縛』は、パターンマッチの輸入元である関数型言語の用語で、Ruby では代入と読み替えても問題ありません)
#@end

#@since 3.0
#@# Pattern matching in Ruby is implemented with the +case+/+in+ expression:
Rubyでのパターンマッチは case/in 式を用いて実装されています。
#@else
#@# Pattern matching in Ruby is implemented with the +in+ operator, which can be used in a standalone expression:
Rubyでのパターンマッチは in 演算子を用いて実装されており、単体の式や

  <expression> in <pattern>

#@# or within the +case+ statement:
case 文の中で利用できます。
#@end

  case <expression>
  in <pattern1>
    ...
  in <pattern2>
    ...
  in <pattern3>
    ...
  else
    ...
  end

#@# (Note that +in+ and +when+ branches can NOT be mixed in one +case+ expression.)
in 節と when 節は1つの case 式の中に混ぜて書くことはできません。

#@since 3.0
#@# Or with the <code>=></code> operator and the +in+ operator, which can be used in a standalone expression:
『=>』 演算子と in 演算子で、単体の式で使用することも可能です。

  <expression> => <pattern>

  <expression> in <pattern>
#@end

#@# The +case+/+in+ expression is _exhaustive_: if the value of the expression does not match any branch of the +case+ expression (and the +else+ branch is absent), +NoMatchingPatternError+ is raised.
case/in 式は 「網羅的」 です。もし case 式の値がどの節にもマッチせず else 節がない場合、例外 NoMatchingPatternError が発生します。

#@# Therefore, the +case+ expression might be used for conditional matching and unpacking:
そのため、条件付きのマッチや展開に case 式が使われることがあります。

#@samplecode
config = {db: {user: 'admin', password: 'abc123'}}

case config
#@# in db: {user:} # matches subhash and puts matched value in variable user
in db: {user:} # ネストしてハッシュにマッチして、その値を変数userに代入する
  puts "Connect with user '#{user}'"
in connection: {username: }
  puts "Connect with user '#{username}'"
else
  puts "Unrecognized structure of config"
end
#@# # Prints: "Connect with user 'admin'"
# "Connect with user 'admin'" と出力
#@end

#@since 3.0
#@# whilst the <code>=></code> operator is most useful when the expected data structure is known beforehand, to just unpack parts of it:
一方、『=>』 演算子は、期待されるデータ構造があらかじめ分かっている場合に、その一部を展開するのに有効です。
#@else
#@# whilst standalone <code>in</code> statement is most useful when the expected data structure is known beforehand, to just unpack parts of it:
一方、『in』 文は、期待されるデータ構造があらかじめ分かっている場合に、その一部を展開するのに有効です。
#@end

#@samplecode
config = {db: {user: 'admin', password: 'abc123'}}

#@since 3.0
#@# config => {db: {user:}} # will raise if the config's structure is unexpected
config => {db: {user:}} # もし config の構造が期待したものでなかった場合には、例外が発生する
#@else
#@# config in {db: {user:}} # will raise if the config's structure is unexpected
config in {db: {user:}} # もし config の構造が期待したものでなかった場合には、例外が発生する
#@end

puts "Connect with user '#{user}'"
#@# # Prints: "Connect with user 'admin'"
# Connect with user 'admin'" と出力
#@end

#@# <code><expression> in <pattern></code> is the same as <code>case <expression>; in <pattern>; true; else false; end</code>.
『<expression> in <pattern>』 は 『<expression>; in <pattern>; true; else false; end』 と等価です。
#@# You can use it when you only want to know if a pattern has been matched or not:
パターンにマッチするかどうかだけを知りたいときに使えます。

#@since 3.0
#@samplecode
users = [{name: "Alice", age: 12}, {name: "Bob", age: 23}]
users.any? {|user| user in {name: /B/, age: 20..} } #=> true
#@end
#@end

#@# See below for more examples and explanations of the syntax.
構文の詳細な例と説明は以下を参照してください。

#@# == Patterns
===[a:patterns] パターン

#@# Patterns can be:
パターンで利用できるものには次のものがあります。

#@#   * any Ruby object (matched by the <code>===</code> operator, like in +when+); (<em>Value pattern</em>)
  * すべてのRubyオブジェクト (when と同じように、『===』演算子でマッチする) (「Value パターン」)
#@#   * array pattern: <code>[<subpattern>, <subpattern>, <subpattern>, ...]</code>; (<em>Array pattern</em>)
  * Array パターン: 『[<subpattern>, <subpattern>, <subpattern>, ...]』 (「Array パターン」)
#@since 3.0
#@#   * find pattern: <code>[*variable, <subpattern>, <subpattern>, <subpattern>, ..., *variable]</code>; (<em>Find pattern</em>)
  * Find パターン: 『[*variable, <subpattern>, <subpattern>, <subpattern>, ..., *variable]』 (「Find パターン」)
#@end
#@#   * hash pattern: <code>{key: <subpattern>, key: <subpattern>, ...}</code> (<em>Hash pattern</em>)
  * Hash パターン: 『{key: <subpattern>, key: <subpattern>, ...}』 (「Hash パターン」)
#@#   * combination of patterns with <code>|</code>; (<em>Alternative pattern</em>)
  * 『|』 でのパターンの組み合わせ (「Alternative パターン」)
#@#   * variable capture: <code><pattern> => variable</code> or <code>variable</code>; (<em>As pattern</em>, <em>Variable pattern</em>)
  * 変数のキャプチャ: 『<pattern> => variable』 または 『variable』 (「As パターン」, 「Variable パターン」)

#@since 3.0
#@# Any pattern can be nested inside array/find/hash patterns where <code><subpattern></code> is specified.
Array/Find/Hash パターンの中に 『<subpattern>』 と書かれている場所では任意のパターンをネストさせることができます。
#@else
#@# Any pattern can be nested inside array/hash patterns where <code><subpattern></code> is specified.
Array/Hash パターンの中に 『<subpattern>』 と書かれている場所では任意のパターンをネストさせることができます。
#@end

#@since 3.0
#@# Array patterns and find patterns match arrays, or objects that respond to +deconstruct+ (see below about the latter).
Array パターン と Find パターン は配列か deconstruct メソッド(後述)を持つオブジェクトにマッチします。
#@else
#@# Array patterns match arrays, or objects that respond to +deconstruct+ (see below about the latter).
Array パターン は配列か deconstruct メソッド(後述)を持つオブジェクトにマッチします。
#@end

#@# Hash patterns match hashes, or objects that respond to +deconstruct_keys+ (see below about the latter). Note that only symbol keys are supported for hash patterns.
Hash パターン はハッシュか deconstruct_keys メソッド(後述)を持つオブジェクトにマッチします。Hash パターン で利用できるキーはシンボルのみです。

#@# An important difference between array and hash pattern behavior is that arrays match only a _whole_ array:
Array パターン と Hash パターン の挙動の重要な違いは Array パターンは配列の 「全ての」 要素がマッチする必要があるということです。

#@samplecode
case [1, 2, 3]
in [Integer, Integer]
  "matched"
else
  "not matched"
end
#=> "not matched"
#@end

#@# while the hash matches even if there are other keys besides the specified part:
一方 Hash パターン は一部のキーだけ指定している場合(指定しているキー以外にもキーが存在する場合)でもマッチします。

#@samplecode
case {a: 1, b: 2, c: 3}
in {a: Integer}
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@# <code>{}</code> is the only exclusion from this rule. It matches only if an empty hash is given:
『{}』 だけはこのルールの例外です。『{}』 は空のハッシュのみマッチします。

#@samplecode
case {a: 1, b: 2, c: 3}
in {}
  "matched"
else
  "not matched"
end
#=> "not matched"
#@end

#@samplecode
case {}
in {}
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@# There is also a way to specify there should be no other keys in the matched hash except those explicitly specified by the pattern, with <code>**nil</code>:
また、パターンで明示的に指定したキー以外のキーが存在しないハッシュにのみ、マッチさせたい場合には、『**nil』 を使います。

#@samplecode
case {a: 1, b: 2}
#@# in {a: Integer, **nil} # this will not match the pattern having keys other than a:
in {a: Integer, **nil} # a: 以外のキーがある場合にはマッチしない
  "matched a part"
in {a: Integer, b: Integer, **nil}
  "matched a whole"
else
  "not matched"
end
#=> "matched a whole"
#@end

#@# Both array and hash patterns support "rest" specification:
Array パターン と Hash パターン ともに残りの部分にマッチする構文をサポートしています。

#@samplecode
case [1, 2, 3]
in [Integer, *]
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@samplecode
case {a: 1, b: 2, c: 3}
in {a: Integer, **}
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@since 3.1
#@# Parentheses around both kinds of patterns could be omitted:
Array パターン や Hash パターン は両端の 『[]』 や 『{}』 といった括弧を省略できます。
#@else
#@since 3.0
#@# In +case+ (but not in <code>=></code> and +in+) expressions, parentheses around both kinds of patterns could be omitted:
case 文 (in 文や => ではない) では、パターン の両端の 『[]』 や 『{}』 といった括弧を省略できます。
#@else
#@# In +case+ (but not in standalone +in+) statement, parentheses around both kinds of patterns could be omitted
case 文 (単体の in 文ではない) では、パターン の両端の 『[]』 や 『{}』 といった括弧を省略できます。
#@end
#@end

#@samplecode
case [1, 2]
in Integer, Integer
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@samplecode
case {a: 1, b: 2, c: 3}
in a: Integer
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@since 3.1
#@samplecode
[1, 2] => a, b
#@end

#@samplecode
[1, 2] in a, b
#@end

#@samplecode
{a: 1, b: 2, c: 3} => a:
#@end
#@end

#@# このコメントの前後のコードブロックを1つにまとめると
#@# {a: 1, b: 2, c: 3} => a: {a: 1, b: 2, c: 3} in a:
#@# と解釈されて duplicated key name で SyntaxError になってしまうのでやむを得ず別々のコードブロックにしている

#@samplecode
{a: 1, b: 2, c: 3} in a:
#@end

#@# Find pattern is similar to array pattern but it can be used to check if the given object has any elements that match the pattern:
Find パターン は Array パターン に似ていますが、オブジェクトの一部の要素がマッチしていることを検査できます。

#@samplecode
case ["a", 1, "b", "c", 2]
in [*, String, String, *]
  "matched"
else
  "not matched"
end
#@end

#@# == Variable binding
===[a:variable_binding] 変数の束縛

#@# Besides deep structural checks, one of the very important features of the pattern matching is the binding of the matched parts to local variables. The basic form of binding is just specifying <code>=> variable_name</code> after the matched (sub)pattern (one might find this similar to storing exceptions in local variables in a <code>rescue ExceptionClass => var</code> clause):
深い構造検査の他のパターンマッチの重要な機能の1つにマッチした部分のローカル変数への束縛があります。束縛の基本的な形はマッチしたパターンの後ろに 『=> 変数名』 と書くことです。(この形は rescue 節で 『rescue ExceptionClass => var』 の形で例外をローカル変数に格納する形に似ています)

#@samplecode
case [1, 2]
in Integer => a, Integer
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"
#@end

#@samplecode
case {a: 1, b: 2, c: 3}
in a: Integer => m
  "matched: #{m}"
else
  "not matched"
end
#=> "matched: 1"
#@end

#@# If no additional check is required, for only binding some part of the data to a variable, a simpler form could be used:
追加のチェックが不要で変数への束縛だけがしたい場合は、より簡潔な記法が利用できます。

#@samplecode
case [1, 2]
in a, Integer
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"
#@end

#@samplecode
case {a: 1, b: 2, c: 3}
in a: m
  "matched: #{m}"
else
  "not matched"
end
#=> "matched: 1"
#@end

#@# For hash patterns, even a simpler form exists: key-only specification (without any sub-pattern) binds the local variable with the key's name, too:
Hash パターンでは、もっと単純に書くこともできます。キーのみを指定することで、キーと同じ名前のローカル変数に値を束縛できます。

#@samplecode
case {a: 1, b: 2, c: 3}
in a:
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"
#@end

#@# Binding works for nested patterns as well:
ネストしたパターンの場合も同様に値の束縛を利用できます。

#@samplecode
case {name: 'John', friends: [{name: 'Jane'}, {name: 'Rajesh'}]}
in name:, friends: [{name: first_friend}, *]
  "matched: #{first_friend}"
else
  "not matched"
end
#=> "matched: Jane"
#@end

#@# The "rest" part of a pattern also can be bound to a variable:
パターンの残りの部分も同様に変数に束縛できます。

#@samplecode
case [1, 2, 3]
in a, *rest
  "matched: #{a}, #{rest}"
else
  "not matched"
end
#=> "matched: 1, [2, 3]"
#@end

#@samplecode
case {a: 1, b: 2, c: 3}
in a:, **rest
  "matched: #{a}, #{rest}"
else
  "not matched"
end
#=> "matched: 1, {:b=>2, :c=>3}"
#@end

#@# Binding to variables currently does NOT work for alternative patterns joined with <code>|</code>:
変数への束縛は現状、『|』 で結合される Alternative パターン と同時には利用できません。

#@samplecode
case {a: 1, b: 2}
in {a: } | Array
  "matched: #{a}"
else
  "not matched"
end
# SyntaxError (illegal variable in alternative pattern (a))
#@end

#@# Variables that start with <code>_</code> are the only exclusions from this rule:
『_』 で始まる変数は例外で、Alternative パターン と同時に利用することができます。

#@samplecode
case {a: 1, b: 2}
in {a: _, b: _foo} | Array
  "matched: #{_}, #{_foo}"
else
  "not matched"
end
# => "matched: 1, 2"
#@end

#@# It is, though, not advised to reuse the bound value, as this pattern's goal is to signify a discarded value.
しかし、『_』 で始まる変数の目的は利用しない値を意味するので、束縛された値を再利用することはオススメしません。

#@# == Variable pinning
===[a:variable_pinning] 変数のピン留め

#@# Due to the variable binding feature, existing local variable can not be straightforwardly used as a sub-pattern:
既に存在しているローカル変数は、サブパターン(Array/Find/Hashパターン構文の <subpattern> の部分) として変数の値をそのまま使うことができません。(これは、変数への束縛の機能を実現するための制限です。)

#@samplecode
expectation = 18

case [1, 2]
in expectation, *rest
  "matched. expectation was: #{expectation}"
else
  "not matched. expectation was: #{expectation}"
end
#@# # expected: "not matched. expectation was: 18"
# 期待する動作："not matched. expectation was: 18"
#@# # real: "matched. expectation was: 1" -- local variable just rewritten
# 実際の動作："matched. expectation was: 1" -- ローカル変数が上書きされてしまっている
#@end

#@# For this case, the pin operator <code>^</code> can be used, to tell Ruby "just use this value as part of the pattern":
この場合、Ruby に「この値をパターンの部品として利用するよ」ということを伝えるためにピン演算子 『^』 を利用することができます。

#@samplecode
expectation = 18
case [1, 2]
in ^expectation, *rest
  "matched. expectation was: #{expectation}"
else
  "not matched. expectation was: #{expectation}"
end
#=> "not matched. expectation was: 18"
#@end

#@# One important usage of variable pinning is specifying that the same value should occur in the pattern several times:
ピン演算子の重要な用途の1つはパターンに複数回出てくる値を明記することです。

#@samplecode
jane = {school: 'high', schools: [{id: 1, level: 'middle'}, {id: 2, level: 'high'}]}
john = {school: 'high', schools: [{id: 1, level: 'middle'}]}

case jane
in school:, schools: [*, {id:, level: ^school}] # select the last school, level should match
  "matched. school: #{id}"
else
  "not matched"
end
#=> "matched. school: 2"

#@# case john # the specified school level is "high", but last school does not match
case john # 指定された school の level は "high" だが、最後の school はマッチしない
in school:, schools: [*, {id:, level: ^school}]
  "matched. school: #{id}"
else
  "not matched"
end
#=> "not matched"
#@end

#@since 3.1
#@# In addition to pinning local variables, you can also pin instance, global, and class variables:
ローカル変数に加えてインスタンス変数やグローバル変数、クラス変数に対してもピン演算子は利用できます。

#@samplecode
$gvar = 1
class A
  @ivar = 2
  @@cvar = 3
  case [1, 2, 3]
  in ^$gvar, ^@ivar, ^@@cvar
    "matched"
  else
    "not matched"
  end
  #=> "matched"
end
#@end

#@# You can also pin the result of arbitrary expressions using parentheses:
また、括弧を使って任意の式に対してピン演算子を利用できます

#@samplecode
a = 1
b = 2
case 3
in ^(a + b)
  "matched"
else
  "not matched"
end
#=> "matched"
#@end
#@end

#@# == Matching non-primitive objects: +deconstruct+ and +deconstruct_keys+
===[a:matching_non_primitive_objects] 非プリミティブなオブジェクトのマッチ: deconstruct メソッドと deconstruct_keys メソッド

#@since 3.0
#@# As already mentioned above, array, find, and hash patterns besides literal arrays and hashes will try to match any object implementing +deconstruct+ (for array/find patterns) or +deconstruct_keys+ (for hash patterns).
既に述べたように、Array/Find/Hash パターンは、配列やハッシュのリテラルの他に、deconstruct メソッド(Array/Find パターン) あるいは deconstruct_keys メソッド(Hash パターン) を定義しているオブジェクトに対しても、マッチを試みます。
#@else
#@# As already mentioned above, hash and array patterns besides literal arrays and hashes will try to match any object implementing +deconstruct+ (for array patterns) or +deconstruct_keys+ (for hash patterns).
既に述べたように、Array/Hash パターンは、配列やハッシュのリテラルの他に、deconstruct メソッド(Array パターン) あるいは deconstruct_keys メソッド(Hash パターン) を定義しているオブジェクトに対しても、マッチを試みます。
#@end

#@samplecode
class Point
  def initialize(x, y)
    @x, @y = x, y
  end

  def deconstruct
    puts "deconstruct called"
    [@x, @y]
  end

  def deconstruct_keys(keys)
    puts "deconstruct_keys called with #{keys.inspect}"
    {x: @x, y: @y}
  end
end

case Point.new(1, -2)
#@# in px, Integer  # sub-patterns and variable binding works
in px, Integer  # パターンと変数への束縛も動きます
  "matched: #{px}"
else
  "not matched"
end
#@# # prints "deconstruct called"
# "deconstruct called" と出力
#=> "matched: 1"

case Point.new(1, -2)
in x: 0.. => px
  "matched: #{px}"
else
  "not matched"
end
#@# # prints: deconstruct_keys called with [:x]
# "deconstruct_keys called with [:x]" と出力
#=> "matched: 1"
#@end

#@# +keys+ are passed to +deconstruct_keys+ to provide a room for optimization in the matched class: if calculating a full hash representation is expensive, one may calculate only the necessary subhash. When the <code>**rest</code> pattern is used, +nil+ is passed as a +keys+ value:
deconstruct_keys メソッドに引数 keys を渡すのは、マッチを行うクラスの実装側に最適化の余地を残すためです。もし、ハッシュのすべての要素を計算するのが重い処理になる場合には、keys で指定された、マッチに必要になる部分のみを計算するように実装しても良いでしょう。

『**rest』 パターンが使われた場合には、keys の値として nil が渡されます。

#@samplecode
case Point.new(1, -2)
in x: 0.. => px, **rest
  "matched: #{px}"
else
  "not matched"
end
#@# # prints: deconstruct_keys called with nil
# "deconstruct_keys called with nil" と出力
#=> "matched: 1"
#@end

#@# Additionally, when matching custom classes, the expected class can be specified as part of the pattern and is checked with <code>===</code>
さらに、カスタムクラスに対してマッチする場合には、期待するクラスをパターンの部品として指定することができます。これは 『===』 でチェックされます。

#@samplecode
class SuperPoint < Point
end

case Point.new(1, -2)
in SuperPoint(x: 0.. => px)
  "matched: #{px}"
else
  "not matched"
end
#=> "not matched"

case SuperPoint.new(1, -2)
#@# in SuperPoint[x: 0.. => px] # [] or () parentheses are allowed
in SuperPoint[x: 0.. => px] # 括弧 [] か () が使える
  "matched: #{px}"
else
  "not matched"
end
#=> "matched: 1"
#@end

#@since 3.2
#@# These core and library classes implement deconstruction:
以下のクラスは deconstruct や deconstruct_keys を実装しています。

#@# * MatchData#deconstruct and MatchData#deconstruct_keys;
[[m:MatchData#deconstruct]]
[[m:MatchData#deconstruct_keys]]
#@# * Time#deconstruct_keys, Date#deconstruct_keys, DateTime#deconstruct_keys.
[[m:Time#deconstruct_keys]]
[[m:Date#deconstruct_keys]]
[[m:DateTime#deconstruct_keys]]
#@end

#@# == Guard clauses
===[a:guard_clauses] ガード節

#@# +if+ can be used to attach an additional condition (guard clause) when the pattern matches. This condition may use bound variables:
if を使って、パターンにマッチしたときに評価される追加の条件式(ガード節)を加えることができます。この条件式では、マッチした値を束縛した変数を使うこともできます。

#@samplecode
case [1, 2]
in a, b if b == a*2
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@samplecode
case [1, 1]
in a, b if b == a*2
  "matched"
else
  "not matched"
end
#=> "not matched"
#@end

#@# +unless+ works, too:
unless も利用できます。

#@samplecode
case [1, 1]
in a, b unless b == a*2
  "matched"
else
  "not matched"
end
#=> "matched"
#@end

#@# == Current feature status
===[a:current_feature_status] 機能の現状

#@until 3.2
#@since 3.1
#@# As of Ruby 3.1, find patterns are considered _experimental_: its syntax can change in the future. Every time you use these features in code, a warning will be printed:
Ruby 3.1 の時点では、Find パターンは 「実験的機能」 扱いです。Find パターンの構文は将来的に変更の可能性があります。これらの機能を利用する場合は毎回警告が出力されます。

#@samplecode
[0] => [*, 0, *]
# warning: Find pattern is experimental, and the behavior may change in future versions of Ruby!
# warning: One-line pattern matching is experimental, and the behavior may change in future versions of Ruby!
#@end
#@else
#@since 3.0
#@# As of Ruby 3.0, one-line pattern matching and find pattern are considered _experimental_: its syntax can change in the future. Every time you use these features in code, the warning will be printed:
Ruby 3.0 の時点では、1行パターンマッチ と Find パターンは 「実験的機能」 扱いです。1行パターンマッチ と Find パターンの構文は将来的に変更の可能性があります。これらの機能を利用する場合は毎回警告が出力されます。

#@samplecode
[0] => [*, 0, *]
# warning: Find pattern is experimental, and the behavior may change in future versions of Ruby!
# warning: One-line pattern matching is experimental, and the behavior may change in future versions of Ruby!
#@end
#@else
#@# As of Ruby 2.7, feature is considered _experimental_: its syntax can change in the future, and the performance is not optimized yet. Every time you use pattern matching in code, the warning will be printed:
Ruby 2.7 の時点では、パターンマッチは 「実験的機能」 扱いです。パターンマッチの構文は将来的に変更の可能性があり、まだパフォーマンスが最適化されていません。これらの機能を利用する場合は毎回警告が出力されます。

#@samplecode
{a: 1, b: 2} in {a:}
# warning: Pattern matching is experimental, and the behavior may change in future versions of Ruby!
#@end
#@end
#@end

#@# To suppress this warning, one may use the Warning::[]= method:
この警告を抑制したければ、Warning::[]= メソッドが利用できます。

#@samplecode
Warning[:experimental] = false
#@since 3.0
eval('[0] => [*, 0, *]')
#@else
eval('{a: 1, b: 2} in {a:}')
#@end
#@# # ...no warning printed...
# ...警告は出力されない...
#@end

#@# Note that pattern-matching warnings are raised at compile time, so this will not suppress the warning:
パターンマッチの警告はコンパイル時に発生するため、以下のような場合は警告は抑制できません。

#@samplecode
#@# Warning[:experimental] = false # At the time this line is evaluated, the parsing happened and warning emitted
Warning[:experimental] = false # この行を評価する段階では、構文解析とそれによる警告の発生は、既に終了している
#@since 3.0
[0] => [*, 0, *]
#@else
{a: 1, b: 2} in {a:}
#@end
#@end

#@# So, only subsequently loaded files or `eval`-ed code is affected by switching the flag.
つまり、フラグの切り替えによって影響を受けるのは切り替え以降に load されたファイルや `eval` されたコードに限られます。

#@# Alternatively, the command line option <code>-W:no-experimental</code> can be used to turn off "experimental" feature warnings.
代わりに、コマンドラインオプションとして 『-W:no-experimental』 を渡すことで "experimental" な機能に対する警告を出力させないようにできます。
#@end

#@# == Appendix A. Pattern syntax
===[a:pattern_syntax] 付記A: パターンのシンタックス

#@# Approximate syntax is:
おおよその構文は以下のとおりです。

  pattern: value_pattern
         | variable_pattern
         | alternative_pattern
         | as_pattern
         | array_pattern
#@since 3.0
         | find_pattern
#@end
         | hash_pattern

  value_pattern: literal
               | Constant
#@since 3.1
               | ^local_variable
               | ^instance_variable
               | ^class_variable
               | ^global_variable
               | ^(expression)
#@else
               | ^variable
#@end

  variable_pattern: variable

  alternative_pattern: pattern | pattern | ...

  as_pattern: pattern => variable

  array_pattern: [pattern, ..., *variable]
               | Constant(pattern, ..., *variable)
               | Constant[pattern, ..., *variable]

#@since 3.0
  find_pattern: [*variable, pattern, ..., *variable]
              | Constant(*variable, pattern, ..., *variable)
              | Constant[*variable, pattern, ..., *variable]
#@end

  hash_pattern: {key: pattern, key:, ..., **variable}
              | Constant(key: pattern, key:, ..., **variable)
              | Constant[key: pattern, key:, ..., **variable]

#@# == Appendix B. Some undefined behavior examples
===[a:some_undefined_behavior_examples] 付記B: `未定義` の振る舞いの例

#@# To leave room for optimization in the future, the specification contains some undefined behavior.
将来的な最適化の余地を残すため、仕様には一部 `未定義` の振る舞いが含まれています。

#@# Use of a variable in an unmatched pattern:
#@samplecode マッチしなかったパターンに指定していた変数を使う
case [0, 1]
in [a, 2]
  "not matched"
in b
  "matched"
in c
  "not matched"
end
#@# a #=> undefined
a #=> 未定義
#@# c #=> undefined
c #=> 未定義
#@end

#@# Number of +deconstruct+, +deconstruct_keys+ method calls:
#@samplecode deconstruct メソッドや deconstruct_keys メソッドが呼び出された回数
$i = 0
ary = [0]
def ary.deconstruct
  $i += 1
  self
end
case ary
in [0, 1]
  "not matched"
in [0]
  "matched"
end
#@# $i #=> undefined
$i #=> 未定義
#@end
