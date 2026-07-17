---
library: _builtin
include:
  - Comparable
---
# class Symbol < Object

#@#インターンされた文字列
シンボルを表すクラス。シンボルは任意の文字列と一対一に対応するオブジェクトです。

文字列の代わりに用いることもできますが、必ずしも文字列と同じ振る舞いをするわけではありません。
同じ内容のシンボルはかならず同一のオブジェクトです。

シンボルオブジェクトは以下のようなリテラルで得られます。
#@#リテラル-シンボルリテラルへのリンク貼る

```ruby
:symbol
:'symbol'
%s!symbol! # %記法
```

生成されたシンボルの一覧は [m:Symbol.all_symbols] で得られます。
一番目のリテラルでシンボルを表す場合、`:` の後に
は識別子、メソッド名(`!`,`?`,`=` などの接尾辞を含む)、変数名
(`$`などの接頭辞を含む)、再定義できる演算子のいずれかに適合する
ものしか書くことはできません(そうでなければ文法エラーになります)。
そうでない文字列をシンボルにしたい場合は残りの表記か [m:String#intern] を使用してください。

### シンボルの実装と用途
#### 実装
Rubyの内部実装では、メソッド名や変数名、定数名、クラス名など
の`名前`を整数で管理しています。これは名前を直接文字列として処理するよりも
速度面で有利だからです。そしてその整数をRubyのコード上で表現したものがシンボルです。

シンボルは、ソース上では文字列のように見え、内部では整数として扱われる、両者を仲立ちするような存在です。
#@#表現を変える？

名前を管理するという役割上、シンボルと文字列は一対一に対応します。
また、文字列と違い、immutable (変更不可)であり、同値ならば必ず同一です。

```ruby
p "abc" == "abc" #=> true
p "abc".equal?("abc") #=> false
p :abc == :abc #=> true
p :abc.equal?(:abc) #=> true ←同値ならば同一
```

#### 用途
実用面では、シンボルは文字の意味を明確にします。`名前`を指し示す時など、
文字列そのものが必要なわけではない時に用います。

#@#プログラム内部でしか使わない文字列

  - ハッシュのキー { :key => "value" }
  - アクセサの引数で渡すインスタンス変数名 attr_reader :name
  - メソッド引数で渡すメソッド名 __send__ :to_s
  - C の enum 的な使用 (値そのものは無視してよい場合)

シンボルを使うメリットは

  - 新しく文字列を生成しない分やや効率がよく、比較も高速。
  - 文字の意味がはっきりするのでコードが読みやすくなる
  - immutable なので内容を書き換えられる心配がない
#@#タイプ量が少ない

大抵のメソッドはシンボルの代わりに文字列を引数として渡すこともできるようになっています。

[c:Symbol] クラスのメソッドには、[c:String] クラスのメソッドと同名で似た働きをするものもあります。

#### GC

内部的にシンボルは

  - シンボルの情報を記録するテーブル
  - そのテーブルの要素を指し示すポインタ

の2つにより実装されています。そのため
同じシンボル(同じ文字列から作られたシンボル)を
複製しても同じ要素へのポインタが使われるだけなので
メモリ使用量は普通の文字列と比べて少ないです。

2.2.0 以降においては、テーブルに記録された情報は
Ruby によって GC されます。すなわち、ある使わなくなった
シンボルのテーブル上の情報はGCによって削除されます。

2.1 以前ではこの機能がなかったため、ユーザからの入力を
シンボルに変換するようなプログラムは DoS に対して弱い
可能性がありましたが、
そのような問題は2.2以降では解決されました。

ただし拡張ライブラリ内で rb_intern によって生成された
シンボルに関するテーブル上の情報はGCされませんので注意してください。

## Class Methods

### def all_symbols -> [Symbol]

定義済みの全てのシンボルオブジェクトの配列を返します。

```ruby
p Symbol.all_symbols #=> [:RUBY_PLATFORM, :RUBY_VERSION, ...]
```

リテラルで表記したシンボルのうち、コンパイル時に値が決まるものはその時に生成されます。
それ以外の式展開を含むリテラルや、メソッドで表記されたものは式の評価時に生成されます。
(何にも使われないシンボルは最適化により生成されないことがあります)

```ruby
def number
  'make_3'
end

p Symbol.all_symbols.select{|sym|sym.to_s.include? 'make'}
#=> [:make_1, :make_2]

re  = #確実に生成されるように代入操作を行う
:make_1,
:'make_2',
:"#{number}",
'make_4'.intern

p Symbol.all_symbols.select{|sym|sym.to_s.include? 'make'}
#=> [:make_1, :make_2, :make_3, :make_4]
```

## Instance Methods

### def intern -> self
### def to_sym -> self
self を返します。

```ruby title="例"
p :foo.intern # => :foo
```

- **SEE** [m:String#intern]

### def id2name -> String
### def to_s -> String

シンボルに対応する文字列を返します。

逆に、文字列に対応するシンボルを得るには
[m:String#intern] を使います。

```ruby
p :foo.id2name  # => "foo"
p :foo.id2name.intern == :foo  # => true
```

- **SEE** [m:String#intern]
- **SEE** [m:Symbol#name]
### def name -> String

シンボルに対応する文字列を返します。

[m:Symbol#to_s]と違って freeze された文字列を返します。

```ruby
p :fred.name         # => "fred"
p :fred.name.frozen? # => true
p :fred.to_s         # => "fred"
p :fred.to_s.frozen? # => false
```

- **SEE** [m:Symbol#to_s]
### def to_proc -> Proc
self に対応する Proc オブジェクトを返します。

生成される Proc オブジェクトを呼びだす([m:Proc#call])と、
Proc#callの第一引数をレシーバとして、 self という名前のメソッドを
残りの引数を渡して呼びだします。

生成される Proc オブジェクトは lambda です。
```ruby
p :object_id.to_proc.lambda? # => true
```

```ruby title="明示的に呼ぶ例"
p :to_i.to_proc["ff", 16]  # => 255 ← "ff".to_i(16)と同じ
```

```ruby title="暗黙に呼ばれる例"
# メソッドに & とともにシンボルを渡すと
# to_proc が呼ばれて Proc 化され、
# それがブロックとして渡される。
p (1..3).collect(&:to_s)  # => ["1", "2", "3"]
p (1..3).select(&:odd?) # => [1, 3]
```

- **SEE** [ref:d:spec/call#block]

### def ==(other)        -> true | false

other が同じシンボルの時に真を返します。
そうでない場合は偽を返します。

- **param** `other` -- 比較対象のシンボルを指定します。

```ruby title="例"
p :aaa == :aaa  #=> true
p :aaa == :xxx  #=> false
```

### def start_with?(*prefixes)   -> bool

self の先頭が prefixes のいずれかであるとき true を返します。

(self.to_s.start_with?と同じです。)

- **param** `prefixes` -- パターンを表す文字列または正規表現 (のリスト)

- **SEE** [m:Symbol#end_with?]

- **SEE** [m:String#start_with?]

```ruby
p :hello.start_with?("hell")             #=> true
p :hello.start_with?(/H/i)               #=> true

# returns true if one of the prefixes matches.
p :hello.start_with?("heaven", "hell")   #=> true
p :hello.start_with?("heaven", "paradise") #=> false
```

### def succ -> Symbol
### def next -> Symbol

シンボルに対応する文字列の「次の」文字列に対応するシンボルを返します。

(self.to_s.next.intern と同じです。)

```ruby
p :a.next # => :b
p :foo.next # => :fop
```

- **SEE** [m:String#succ]

### def <=>(other) -> -1 | 0 | 1 | nil

self と other のシンボルに対応する文字列を ASCII コード順で比較して、
self が小さい時には -1、等しい時には 0、大きい時には 1 を返します。

other がシンボルではなく比較できない時には nil を返します。

- **param** `other` -- 比較対象のシンボルを指定します。

```ruby
p :aaa <=> :xxx  # => -1
p :aaa <=> :aaa  # => 0
p :xxx <=> :aaa  # => 1
p :foo <=> "foo" # => nil
```

- **SEE** [m:String#<=>], [m:Symbol#casecmp]

### def casecmp(other) -> -1 | 0 | 1 | nil

[m:Symbol#<=>] と同様にシンボルに対応する文字列の順序を比較しますが、
アルファベットの大文字小文字の違いを無視します。

[m:Symbol#casecmp?] と違って大文字小文字の違いを無視するのは
Unicode 全体ではなく、A-Z/a-z だけです。

- **param** `other` -- 比較対象のシンボルを指定します。

```ruby
p :aBcDeF.casecmp(:abcde)   #=> 1
p :aBcDeF.casecmp(:abcdef)  #=> 0
p :aBcDeF.casecmp(:abcdefg) #=> -1
p :abcdef.casecmp(:ABCDEF)  #=> 0
p :"\u{e4 f6 fc}".casecmp(:"\u{c4 d6 dc}") #=> 1
```

other がシンボルではない場合や、文字列のエンコーディングが非互換の場合は、nil を返します。

```ruby
p :foo.casecmp("foo") #=> nil
p "\u{e4 f6 fc}".encode("ISO-8859-1").to_sym.casecmp(:"\u{c4 d6 dc}") #=> nil
```

- **SEE** [m:String#casecmp], [m:Symbol#<=>], [m:Symbol#casecmp?]

### def casecmp?(other) -> bool | nil

大文字小文字の違いを無視しシンボルを比較します。
シンボルが一致する場合には true を返し、一致しない場合には false を返します。

- **param** `other` -- 比較対象のシンボルを指定します。

```ruby
p :abcdef.casecmp?(:abcde)   #=> false
p :aBcDeF.casecmp?(:abcdef)  #=> true
p :abcdef.casecmp?(:abcdefg) #=> false
p :abcdef.casecmp?(:ABCDEF)  #=> true
p :"\u{e4 f6 fc}".casecmp?(:"\u{c4 d6 dc}") #=> true
```

other がシンボルではない場合や、文字列のエンコーディングが非互換の場合は、nil を返します。

```ruby
p :foo.casecmp?("foo") #=> nil
p "\u{e4 f6 fc}".encode("ISO-8859-1").to_sym.casecmp?(:"\u{c4 d6 dc}") #=> nil
```

- **SEE** [m:String#casecmp?], [m:Symbol#casecmp]

### def =~(other) -> Integer | nil

正規表現 other とのマッチを行います。

(self.to_s =~ other と同じです。)

- **param** `other` -- 比較対象のシンボルを指定します。

- **return** -- マッチが成功すればマッチした位置のインデックスを、そうでなければ nil を返します。

```ruby
p :foo =~ /foo/    # => 0
p :foobar =~ /bar/ # => 3
p :foo =~ /bar/    # => nil
```

- **SEE** [m:String#=~]

### def match(other) -> MatchData | nil

正規表現 other とのマッチを行います。

(self.to_s.match(other) と同じです。)

- **param** `other` -- 比較対象のシンボルを指定します。

- **return** -- マッチが成功すれば MatchData オブジェクトを、そうでなければ nil を返します。

```ruby
p :foo.match(/foo/)    # => #<MatchData "foo">
p :foobar.match(/bar/) # => #<MatchData "bar">
p :foo.match(/bar/)    # => nil
```

- **SEE** [m:String#match]
- **SEE** [m:Symbol#match?]

### def match?(regexp, pos = 0) -> bool

regexp.match?(self, pos) と同じです。
regexp が文字列の場合は、正規表現にコンパイルします。
詳しくは [m:Regexp#match?] を参照してください。

```ruby title="例"
p :Ruby.match?(/R.../)  # => true
p :Ruby.match?('Ruby')  # => true
p :Ruby.match?('Ruby',1)  # => false
p :Ruby.match?('uby',1) # => true
p :Ruby.match?(/P.../)  # => false
p $&                    # => nil
```

- **SEE** [m:Regexp#match?], [m:String#match?]

### def [](nth) -> String | nil
### def slice(nth) -> String | nil

nth 番目の文字を返します。

(self.to_s[nth] と同じです。)

- **param** `nth` -- 文字の位置を表す整数を指定します。

```ruby
p :foo[0] # => "f"
p :foo[1] # => "o"
p :foo[2] # => "o"
```

### def [](nth, len) -> String | nil
### def slice(nth, len) -> String | nil

nth 番目から長さ len の部分文字列を新しく作って返します。

(self.to_s[nth, len] と同じです。)

- **param** `nth` -- 文字の位置を表す整数を指定します。
- **param** `len` -- 文字列の長さを指定します。

```ruby
p :foo[1, 2] # => "oo"
```

### def [](substr) -> String | nil
### def slice(substr) -> String | nil

self が substr を含む場合、一致した文字列を新しく作って返します。

(self.to_s[substr] と同じです。)

```ruby title="例"
p :foobar.slice("foo") # => "foo"
p :foobar.slice("baz") # => nil
```

### def [](regexp, nth = 0) -> String | nil
### def slice(regexp, nth = 0) -> String | nil

正規表現 regexp の nth 番目の括弧にマッチする最初の部分文字列を返します。

(self.to_s[regexp, nth] と同じです。)

- **param** `regexp` -- 正規表現を指定します。

- **param** `nth` -- 取得したい正規表現レジスタのインデックスを指定します。

```ruby
p :foobar[/bar/] # => "bar"
p :foobarbaz[/(ba.)(ba.)/, 0] # => "barbaz"
p :foobarbaz[/(ba.)(ba.)/, 1] # => "bar"
p :foobarbaz[/(ba.)(ba.)/, 2] # => "baz"
```

### def [](range) -> String | nil
### def slice(range) -> String | nil

rangeで指定したインデックスの範囲に含まれる部分文字列を返します。

(self.to_s[range] と同じです。)

- **param** `range` -- 取得したい文字列の範囲を示す [c:Range] オブジェクトを指定します。

```ruby
p :foo[0..1] # => "fo"
```

- **SEE** [m:String#\[\]], [m:String#slice]

### def length -> Integer
### def size -> Integer

シンボルに対応する文字列の長さを返します。

(self.to_s.length と同じです。)

```ruby
p :foo.length #=> 3
```

- **SEE** [m:String#length], [m:String#size]

### def empty? -> bool

自身が :"" (length が 0 のシンボル)かどうかを返します。

```ruby
p :"".empty?  #=> true
p :foo.empty? #=> false
```

- **SEE** [m:String#empty?]

### def end_with?(*suffixes)   -> bool

self の末尾が suffixes のいずれかであるとき true を返します。

(self.to_s.end_with?と同じです。)

- **param** `suffixes` -- パターンを表す文字列 (のリスト)

- **SEE** [m:Symbol#start_with?]

- **SEE** [m:String#end_with?]

```ruby
p :hello.end_with?("ello")             #=> true

# returns true if one of the +suffixes+ matches.
p :hello.end_with?("heaven", "ello")   #=> true
p :hello.end_with?("heaven", "paradise") #=> false
```

### def upcase(*options) -> Symbol

小文字を大文字に変換したシンボルを返します。

(self.to_s.upcase.intern と同じです。)

```ruby
p :foo.upcase #=> :FOO
```

- **SEE** [m:String#upcase]

### def downcase(*options) -> Symbol

大文字を小文字に変換したシンボルを返します。

(self.to_s.downcase.intern と同じです。)

```ruby
p :FOO.downcase #=> :foo
```

- **SEE** [m:String#downcase]

### def capitalize(*options) -> Symbol

シンボルに対応する文字列の先頭の文字を大文字に、残りを小文字に変更した
シンボルを返します。

(self.to_s.capitalize.intern と同じです。)

```ruby
p :foobar.capitalize   #=> :Foobar
p :fooBar.capitalize   #=> :Foobar
p :FOOBAR.capitalize   #=> :Foobar
p :"foobar--".capitalize # => "Foobar--"
```

- **SEE** [m:String#capitalize]

### def swapcase(*options) -> Symbol

'A' から 'Z' までのアルファベット大文字を小文字に、'a' から 'z' までの
アルファベット小文字を大文字に変更したシンボルを返します。

(self.to_s.swapcase.intern と同じです。)

```ruby
p :ABCxyz.swapcase   # => :abcXYZ
p :Access.swapcase   # => :aCCESS
```

- **SEE** [m:String#swapcase]

### def encoding   -> Encoding

シンボルに対応する文字列のエンコーディング情報を表現した [c:Encoding] オブ
ジェクトを返します。

```ruby title="例"
# encoding: utf-8

p :foo.encoding      # => #<Encoding:US-ASCII>
p :あかさたな.encoding # => #<Encoding:UTF-8>
```

- **SEE** [m:String#encoding]

### def inspect    -> String

自身を人間に読みやすい文字列にして返します。

```ruby
p :fred.inspect #=> ":fred"
```
