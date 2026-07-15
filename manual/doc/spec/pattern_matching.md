#@# = Pattern matching
# パターンマッチ

  - [ref:patterns]
  - [ref:variable_binding]
  - [ref:variable_pinning]
  - [ref:matching_non_primitive_objects]
  - [ref:guard_clauses]
  - [ref:current_feature_status]
  - [ref:pattern_syntax]
  - [ref:some_undefined_behavior_examples]

#@# Pattern matching is a feature allowing deep matching of structured values: checking the structure and binding the matched parts to local variables.
パターンマッチは、構造化された値に対して、構造をチェックし、マッチした部分をローカル変数に束縛するという、深いマッチを可能にする機能です。(『束縛』は、パターンマッチの輸入元である関数型言語の用語で、Ruby では代入と読み替えても問題ありません)

#@# Pattern matching in Ruby is implemented with the +case+/+in+ expression:
Rubyでのパターンマッチは case/in 式を用いて実装されています。

`````
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
`````

#@# (Note that +in+ and +when+ branches can NOT be mixed in one +case+ expression.)
in 節と when 節は1つの case 式の中に混ぜて書くことはできません。

#@# Or with the <code>=></code> operator and the +in+ operator, which can be used in a standalone expression:
『=>』 演算子と in 演算子で、単体の式で使用することも可能です。

`````
<expression> => <pattern>

<expression> in <pattern>
`````

#@# The +case+/+in+ expression is _exhaustive_: if the value of the expression does not match any branch of the +case+ expression (and the +else+ branch is absent), +NoMatchingPatternError+ is raised.
case/in 式は 「網羅的」 です。もし case 式の値がどの節にもマッチせず else 節がない場合、例外 NoMatchingPatternError が発生します。

#@# Therefore, the +case+ expression might be used for conditional matching and unpacking:
そのため、条件付きのマッチや展開に case 式が使われることがあります。

#@# doc.ruby-lang.org のファイルを生成している ruby のバージョンの問題で，workaroundとして新しいバージョン用のサンプルをemlistにしている
```ruby
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
```

#@# whilst the <code>=></code> operator is most useful when the expected data structure is known beforehand, to just unpack parts of it:
一方、『=>』 演算子は、期待されるデータ構造があらかじめ分かっている場合に、その一部を展開するのに有効です。

```
config = {db: {user: 'admin', password: 'abc123'}}

#@# config => {db: {user:}} # will raise if the config's structure is unexpected
config => {db: {user:}} # もし config の構造が期待したものでなかった場合には、例外が発生する

puts "Connect with user '#{user}'"
#@# # Prints: "Connect with user 'admin'"
# Connect with user 'admin'" と出力
```

#@# <code><expression> in <pattern></code> is the same as <code>case <expression>; in <pattern>; true; else false; end</code>.
『<expression> in <pattern>』 は 『<expression>; in <pattern>; true; else false; end』 と等価です。
#@# You can use it when you only want to know if a pattern has been matched or not:
パターンにマッチするかどうかだけを知りたいときに使えます。

```
users = [{name: "Alice", age: 12}, {name: "Bob", age: 23}]
users.any? {|user| user in {name: /B/, age: 20..} } #=> true
```

#@# See below for more examples and explanations of the syntax.
構文の詳細な例と説明は以下を参照してください。

#@# == Patterns
### パターン {#patterns}

#@# Patterns can be:
パターンで利用できるものには次のものがあります。

#@#   * any Ruby object (matched by the <code>===</code> operator, like in +when+); (<em>Value pattern</em>)
  - すべてのRubyオブジェクト (when と同じように、『===』演算子でマッチする) (「Value パターン」)
#@#   * array pattern: <code>[<subpattern>, <subpattern>, <subpattern>, ...]</code>; (<em>Array pattern</em>)
  - Array パターン: 『[<subpattern>, <subpattern>, <subpattern>, ...]』 (「Array パターン」)
#@#   * find pattern: <code>[*variable, <subpattern>, <subpattern>, <subpattern>, ..., *variable]</code>; (<em>Find pattern</em>)
  - Find パターン: 『[*variable, <subpattern>, <subpattern>, <subpattern>, ..., *variable]』 (「Find パターン」)
#@#   * hash pattern: <code>{key: <subpattern>, key: <subpattern>, ...}</code> (<em>Hash pattern</em>)
  - Hash パターン: 『{key: <subpattern>, key: <subpattern>, ...}』 (「Hash パターン」)
#@#   * combination of patterns with <code>|</code>; (<em>Alternative pattern</em>)
  - 『|』 でのパターンの組み合わせ (「Alternative パターン」)
#@#   * variable capture: <code><pattern> => variable</code> or <code>variable</code>; (<em>As pattern</em>, <em>Variable pattern</em>)
  - 変数のキャプチャ: 『<pattern> => variable』 または 『variable』 (「As パターン」, 「Variable パターン」)

#@# Any pattern can be nested inside array/find/hash patterns where <code><subpattern></code> is specified.
Array/Find/Hash パターンの中に 『<subpattern>』 と書かれている場所では任意のパターンをネストさせることができます。

#@# Array patterns and find patterns match arrays, or objects that respond to +deconstruct+ (see below about the latter).
Array パターン と Find パターン は配列か deconstruct メソッド(後述)を持つオブジェクトにマッチします。

#@# Hash patterns match hashes, or objects that respond to +deconstruct_keys+ (see below about the latter). Note that only symbol keys are supported for hash patterns.
Hash パターン はハッシュか deconstruct_keys メソッド(後述)を持つオブジェクトにマッチします。Hash パターン で利用できるキーはシンボルのみです。

#@# An important difference between array and hash pattern behavior is that arrays match only a _whole_ array:
Array パターン と Hash パターン の挙動の重要な違いは Array パターンは配列の 「全ての」 要素がマッチする必要があるということです。

```ruby
p case [1, 2, 3]
in [Integer, Integer]
  "matched"
else
  "not matched"
end
#=> "not matched"
```

#@# while the hash matches even if there are other keys besides the specified part:
一方 Hash パターン は一部のキーだけ指定している場合(指定しているキー以外にもキーが存在する場合)でもマッチします。

```ruby
p case {a: 1, b: 2, c: 3}
in {a: Integer}
  "matched"
else
  "not matched"
end
#=> "matched"
```

#@# <code>{}</code> is the only exclusion from this rule. It matches only if an empty hash is given:
『{}』 だけはこのルールの例外です。『{}』 は空のハッシュのみマッチします。

```ruby
p case {a: 1, b: 2, c: 3}
in {}
  "matched"
else
  "not matched"
end
#=> "not matched"
```

```ruby
p case {}
in {}
  "matched"
else
  "not matched"
end
#=> "matched"
```

#@# There is also a way to specify there should be no other keys in the matched hash except those explicitly specified by the pattern, with <code>**nil</code>:
また、パターンで明示的に指定したキー以外のキーが存在しないハッシュにのみ、マッチさせたい場合には、『**nil』 を使います。

```ruby
p case {a: 1, b: 2}
#@# in {a: Integer, **nil} # this will not match the pattern having keys other than a:
in {a: Integer, **nil} # a: 以外のキーがある場合にはマッチしない
  "matched a part"
in {a: Integer, b: Integer, **nil}
  "matched a whole"
else
  "not matched"
end
#=> "matched a whole"
```

#@# Both array and hash patterns support "rest" specification:
Array パターン と Hash パターン ともに残りの部分にマッチする構文をサポートしています。

```ruby
p case [1, 2, 3]
in [Integer, *]
  "matched"
else
  "not matched"
end
#=> "matched"
```

```ruby
p case {a: 1, b: 2, c: 3}
in {a: Integer, **}
  "matched"
else
  "not matched"
end
#=> "matched"
```

#@since 3.1
#@# Parentheses around both kinds of patterns could be omitted:
Array パターン や Hash パターン は両端の 『[]』 や 『{}』 といった括弧を省略できます。
#@else
#@# In +case+ (but not in <code>=></code> and +in+) expressions, parentheses around both kinds of patterns could be omitted:
case 文 (in 文や => ではない) では、パターン の両端の 『[]』 や 『{}』 といった括弧を省略できます。
#@end

```ruby
p case [1, 2]
in Integer, Integer
  "matched"
else
  "not matched"
end
#=> "matched"
```

```ruby
p case {a: 1, b: 2, c: 3}
in a: Integer
  "matched"
else
  "not matched"
end
#=> "matched"
```

#@since 3.1

『=>』演算子と in 演算子で括弧を省略する例です。

```
[1, 2] => a, b
```

```
[1, 2] in a, b
```

```
{a: 1, b: 2, c: 3} => a:
```

#@# このコメントの前後のコードブロックを1つにまとめると
#@# {a: 1, b: 2, c: 3} => a: {a: 1, b: 2, c: 3} in a:
#@# と解釈されて duplicated key name で SyntaxError になってしまうのでやむを得ず別々のコードブロックにしている

```
{a: 1, b: 2, c: 3} in a:
```

#@end



#@# Find pattern is similar to array pattern but it can be used to check if the given object has any elements that match the pattern:
Find パターン は Array パターン に似ていますが、オブジェクトの一部の要素がマッチしていることを検査できます。

```
case ["a", 1, "b", "c", 2]
in [*, String, String, *]
  "matched"
else
  "not matched"
end
```

#@# == Variable binding
### 変数の束縛 {#variable_binding}

#@# Besides deep structural checks, one of the very important features of the pattern matching is the binding of the matched parts to local variables. The basic form of binding is just specifying <code>=> variable_name</code> after the matched (sub)pattern (one might find this similar to storing exceptions in local variables in a <code>rescue ExceptionClass => var</code> clause):
深い構造検査の他のパターンマッチの重要な機能の1つにマッチした部分のローカル変数への束縛があります。束縛の基本的な形はマッチしたパターンの後ろに 『=> 変数名』 と書くことです。(この形は rescue 節で 『rescue ExceptionClass => var』 の形で例外をローカル変数に格納する形に似ています)

```ruby
p case [1, 2]
in Integer => a, Integer
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"
```

```ruby
p case {a: 1, b: 2, c: 3}
in a: Integer => m
  "matched: #{m}"
else
  "not matched"
end
#=> "matched: 1"
```

#@# If no additional check is required, for only binding some part of the data to a variable, a simpler form could be used:
追加のチェックが不要で変数への束縛だけがしたい場合は、より簡潔な記法が利用できます。

```ruby
p case [1, 2]
in a, Integer
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"
```

```ruby
p case {a: 1, b: 2, c: 3}
in a: m
  "matched: #{m}"
else
  "not matched"
end
#=> "matched: 1"
```

#@# For hash patterns, even a simpler form exists: key-only specification (without any sub-pattern) binds the local variable with the key's name, too:
Hash パターンでは、もっと単純に書くこともできます。キーのみを指定することで、キーと同じ名前のローカル変数に値を束縛できます。

```ruby
p case {a: 1, b: 2, c: 3}
in a:
  "matched: #{a}"
else
  "not matched"
end
#=> "matched: 1"
```

#@# Binding works for nested patterns as well:
ネストしたパターンの場合も同様に値の束縛を利用できます。

```ruby
p case {name: 'John', friends: [{name: 'Jane'}, {name: 'Rajesh'}]}
in name:, friends: [{name: first_friend}, *]
  "matched: #{first_friend}"
else
  "not matched"
end
#=> "matched: Jane"
```

#@# The "rest" part of a pattern also can be bound to a variable:
パターンの残りの部分も同様に変数に束縛できます。

```ruby
p case [1, 2, 3]
in a, *rest
  "matched: #{a}, #{rest}"
else
  "not matched"
end
#=> "matched: 1, [2, 3]"
```

```ruby
p case {a: 1, b: 2, c: 3}
in a:, **rest
  "matched: #{a}, #{rest}"
else
  "not matched"
end
#=> "matched: 1, {:b=>2, :c=>3}"
```

#@# Binding to variables currently does NOT work for alternative patterns joined with <code>|</code>:
変数への束縛は現状、『|』 で結合される Alternative パターン と同時には利用できません。

```
case {a: 1, b: 2}
in {a: } | Array
  "matched: #{a}"
else
  "not matched"
end
# SyntaxError (illegal variable in alternative pattern (a))
```

#@# Variables that start with <code>_</code> are the only exclusions from this rule:
『_』 で始まる変数は例外で、Alternative パターン と同時に利用できます。

```ruby
p case {a: 1, b: 2}
in {a: _, b: _foo} | Array
  "matched: #{_}, #{_foo}"
else
  "not matched"
end
# => "matched: 1, 2"
```

#@# It is, though, not advised to reuse the bound value, as this pattern's goal is to signify a discarded value.
しかし、『_』 で始まる変数の目的は利用しない値を意味するので、束縛された値を再利用することはオススメしません。

#@# == Variable pinning
### 変数のピン留め {#variable_pinning}

#@# Due to the variable binding feature, existing local variable can not be straightforwardly used as a sub-pattern:
既に存在しているローカル変数は、サブパターン(Array/Find/Hashパターン構文の <subpattern> の部分) として変数の値をそのまま使うことができません。(これは、変数への束縛の機能を実現するための制限です。)

```ruby
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
```

#@# For this case, the pin operator <code>^</code> can be used, to tell Ruby "just use this value as part of the pattern":
この場合、Ruby に「この値をパターンの部品として利用するよ」ということを伝えるためにピン演算子 『^』 を利用できます。

```ruby
expectation = 18
p case [1, 2]
in ^expectation, *rest
  "matched. expectation was: #{expectation}"
else
  "not matched. expectation was: #{expectation}"
end
#=> "not matched. expectation was: 18"
```

#@# One important usage of variable pinning is specifying that the same value should occur in the pattern several times:
ピン演算子の重要な用途の1つはパターンに複数回出てくる値を明記することです。

```ruby
jane = {school: 'high', schools: [{id: 1, level: 'middle'}, {id: 2, level: 'high'}]}
john = {school: 'high', schools: [{id: 1, level: 'middle'}]}

p case jane
in school:, schools: [*, {id:, level: ^school}] # select the last school, level should match
  "matched. school: #{id}"
else
  "not matched"
end
#=> "matched. school: 2"

#@# case john # the specified school level is "high", but last school does not match
p case john # 指定された school の level は "high" だが、最後の school はマッチしない
in school:, schools: [*, {id:, level: ^school}]
  "matched. school: #{id}"
else
  "not matched"
end
#=> "not matched"
```

#@since 3.1
#@# In addition to pinning local variables, you can also pin instance, global, and class variables:
ローカル変数に加えてインスタンス変数やグローバル変数、クラス変数に対してもピン演算子は利用できます。

```
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
```

#@# You can also pin the result of arbitrary expressions using parentheses:
また、括弧を使って任意の式に対してピン演算子を利用できます

```
a = 1
b = 2
case 3
in ^(a + b)
  "matched"
else
  "not matched"
end
#=> "matched"
```
#@end

#@# == Matching non-primitive objects: +deconstruct+ and +deconstruct_keys+
### 非プリミティブなオブジェクトのマッチ: deconstruct メソッドと deconstruct_keys メソッド {#matching_non_primitive_objects}

#@# As already mentioned above, array, find, and hash patterns besides literal arrays and hashes will try to match any object implementing +deconstruct+ (for array/find patterns) or +deconstruct_keys+ (for hash patterns).
既に述べたように、Array/Find/Hash パターンは、配列やハッシュのリテラルの他に、deconstruct メソッド(Array/Find パターン) あるいは deconstruct_keys メソッド(Hash パターン) を定義しているオブジェクトに対しても、マッチを試みます。

```ruby
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

p case Point.new(1, -2)
#@# in px, Integer  # sub-patterns and variable binding works
in px, Integer  # パターンと変数への束縛も動きます
  "matched: #{px}"
else
  "not matched"
end
#@# # prints "deconstruct called"
# "deconstruct called" と出力
#=> "matched: 1"

p case Point.new(1, -2)
in x: 0.. => px
  "matched: #{px}"
else
  "not matched"
end
#@# # prints: deconstruct_keys called with [:x]
# "deconstruct_keys called with [:x]" と出力
#=> "matched: 1"
```

#@# +keys+ are passed to +deconstruct_keys+ to provide a room for optimization in the matched class: if calculating a full hash representation is expensive, one may calculate only the necessary subhash. When the <code>**rest</code> pattern is used, +nil+ is passed as a +keys+ value:
deconstruct_keys メソッドに引数 keys を渡すのは、マッチを行うクラスの実装側に最適化の余地を残すためです。もし、ハッシュのすべての要素を計算するのが重い処理になる場合には、keys で指定された、マッチに必要になる部分のみを計算するように実装しても良いでしょう。

『**rest』 パターンが使われた場合には、keys の値として nil が渡されます。

```ruby
p case Point.new(1, -2)
in x: 0.. => px, **rest
  "matched: #{px}"
else
  "not matched"
end
#@# # prints: deconstruct_keys called with nil
# "deconstruct_keys called with nil" と出力
#=> "matched: 1"
```

#@# Additionally, when matching custom classes, the expected class can be specified as part of the pattern and is checked with <code>===</code>
さらに、カスタムクラスに対してマッチする場合には、期待するクラスをパターンの部品として指定できます。これは 『===』 でチェックされます。

```ruby
class SuperPoint < Point
end

p case Point.new(1, -2)
in SuperPoint(x: 0.. => px)
  "matched: #{px}"
else
  "not matched"
end
#=> "not matched"

p case SuperPoint.new(1, -2)
#@# in SuperPoint[x: 0.. => px] # [] or () parentheses are allowed
in SuperPoint[x: 0.. => px] # 括弧 [] か () が使える
  "matched: #{px}"
else
  "not matched"
end
#=> "matched: 1"
```

#@since 3.2
#@# These core and library classes implement deconstruction:
以下のクラスは deconstruct や deconstruct_keys を実装しています。

#@# * MatchData#deconstruct and MatchData#deconstruct_keys;
[m:MatchData#deconstruct]
[m:MatchData#deconstruct_keys]
#@# * Time#deconstruct_keys, Date#deconstruct_keys, DateTime#deconstruct_keys.
[m:Time#deconstruct_keys]
[m:Date#deconstruct_keys]
[m:DateTime#deconstruct_keys]
#@end

#@# == Guard clauses
### ガード節 {#guard_clauses}

#@# +if+ can be used to attach an additional condition (guard clause) when the pattern matches. This condition may use bound variables:
if を使って、パターンにマッチしたときに評価される追加の条件式(ガード節)を加えることができます。この条件式では、マッチした値を束縛した変数を使うこともできます。

```ruby
p case [1, 2]
in a, b if b == a*2
  "matched"
else
  "not matched"
end
#=> "matched"
```

```ruby
p case [1, 1]
in a, b if b == a*2
  "matched"
else
  "not matched"
end
#=> "not matched"
```

#@# +unless+ works, too:
unless も利用できます。

```ruby
p case [1, 1]
in a, b unless b == a*2
  "matched"
else
  "not matched"
end
#=> "matched"
```

#@# == Current feature status
### 機能の現状 {#current_feature_status}

#@until 3.2
#@since 3.1
#@# As of Ruby 3.1, find patterns are considered _experimental_: its syntax can change in the future. Every time you use these features in code, a warning will be printed:
Ruby 3.1 の時点では、Find パターンは 「実験的機能」 扱いです。Find パターンの構文は将来的に変更の可能性があります。これらの機能を利用する場合は毎回警告が出力されます。

```
[0] => [*, 0, *]
# warning: Find pattern is experimental, and the behavior may change in future versions of Ruby!
# warning: One-line pattern matching is experimental, and the behavior may change in future versions of Ruby!
```
#@else
#@# As of Ruby 3.0, one-line pattern matching and find pattern are considered _experimental_: its syntax can change in the future. Every time you use these features in code, the warning will be printed:
Ruby 3.0 の時点では、1行パターンマッチ と Find パターンは 「実験的機能」 扱いです。1行パターンマッチ と Find パターンの構文は将来的に変更の可能性があります。これらの機能を利用する場合は毎回警告が出力されます。

```
[0] => [*, 0, *]
# warning: Find pattern is experimental, and the behavior may change in future versions of Ruby!
# warning: One-line pattern matching is experimental, and the behavior may change in future versions of Ruby!
}
#@end

#@# To suppress this warning, one may use the Warning::[]= method:
この警告を抑制したければ、Warning::[]= メソッドが利用できます。

//emlist{
Warning[:experimental] = false
eval('[0] => [*, 0, *]')
#@# # ...no warning printed...
# ...警告は出力されない...
```

#@# Note that pattern-matching warnings are raised at compile time, so this will not suppress the warning:
パターンマッチの警告はコンパイル時に発生するため、以下のような場合は警告は抑制できません。

```
#@# Warning[:experimental] = false # At the time this line is evaluated, the parsing happened and warning emitted
Warning[:experimental] = false # この行を評価する段階では、構文解析とそれによる警告の発生は、既に終了している
[0] => [*, 0, *]
```

#@# So, only subsequently loaded files or `eval`-ed code is affected by switching the flag.
つまり、フラグの切り替えによって影響を受けるのは切り替え以降に load されたファイルや \`eval\` されたコードに限られます。

#@# Alternatively, the command line option <code>-W:no-experimental</code> can be used to turn off "experimental" feature warnings.
代わりに、コマンドラインオプションとして 『-W:no-experimental』 を渡すことで "experimental" な機能に対する警告を出力させないようにできます。
#@end

#@# == Appendix A. Pattern syntax
### 付記A: パターンのシンタックス {#pattern_syntax}

#@# Approximate syntax is:
おおよその構文は以下のとおりです。

`````
pattern: value_pattern
       | variable_pattern
       | alternative_pattern
       | as_pattern
       | array_pattern
`````
````````````
| find_pattern
````````````
`````
       | hash_pattern

value_pattern: literal
             | Constant
`````
#@since 3.1
``````````````````
| ^local_variable
| ^instance_variable
| ^class_variable
| ^global_variable
| ^(expression)
``````````````````
#@else
``````````````````
| ^variable
``````````````````
#@end

`````
variable_pattern: variable

alternative_pattern: pattern | pattern | ...

as_pattern: pattern => variable

array_pattern: [pattern, ..., *variable]
             | Constant(pattern, ..., *variable)
             | Constant[pattern, ..., *variable]
`````

`````
find_pattern: [*variable, pattern, ..., *variable]
            | Constant(*variable, pattern, ..., *variable)
            | Constant[*variable, pattern, ..., *variable]
`````

`````
hash_pattern: {key: pattern, key:, ..., **variable}
            | Constant(key: pattern, key:, ..., **variable)
            | Constant[key: pattern, key:, ..., **variable]
`````

#@# == Appendix B. Some undefined behavior examples
### 付記B: \`未定義\` の振る舞いの例 {#some_undefined_behavior_examples}

#@# To leave room for optimization in the future, the specification contains some undefined behavior.
将来的な最適化の余地を残すため、仕様には一部 \`未定義\` の振る舞いが含まれています。

#@# Use of a variable in an unmatched pattern:
```ruby title="マッチしなかったパターンに指定していた変数を使う"
case [0, 1]
in [a, 2]
  "not matched"
in b
  "matched"
in c
  "not matched"
end
#@# a #=> undefined
p a #=> 未定義
#@# c #=> undefined
p c #=> 未定義
```

#@# Number of +deconstruct+, +deconstruct_keys+ method calls:
```ruby title="deconstruct メソッドや deconstruct_keys メソッドが呼び出された回数"
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
p $i #=> 未定義
```
