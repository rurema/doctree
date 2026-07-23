---
library: _builtin
---
# class MatchData < Object

正規表現のマッチに関する情報を扱うためのクラス。

このクラスのインスタンスは、
- [m:Regexp.last_match]
- [m:Regexp#match], [m:String#match]
- [m:$~]
などにより得られます。

## Instance Methods

### def [](n) -> String | nil

n 番目の部分文字列を返します。

0 はマッチ全体を意味します。
n の値が負の時には末尾からのインデックスと見倣します(末尾の
要素が -1 番目)。n 番目の要素が存在しない時には nil を返します。

- **param** `n` -- 返す部分文字列のインデックスを指定します。

```ruby title="例"
/(foo)(bar)(BAZ)?/ =~ "foobarbaz"
p $~.to_a       # => ["foobar", "foo", "bar", nil]
p $~[0]         # => "foobar"
p $~[1]         # => "foo"
p $~[2]         # => "bar"
p $~[3]         # => nil        (マッチしていない)
p $~[4]         # => nil        (範囲外)
p $~[-2]        # => "bar"
```

### def [](range) -> [String]

[c:Range] オブジェクト range の範囲にある要素からなる部分配列を返します。

- **param** `range` -- start..end 範囲式。

```ruby title="例"
/(foo)(bar)/ =~ "foobarbaz"
p $~[0..2]      # => ["foobar", "foo", "bar"]
```

### def [](start, length) -> [String]

start 番目から length 個の要素を含む部分配列を返します。

```ruby title="例"
/(foo)(bar)/ =~ "foobarbaz"
p $~[0, 3]      # => ["foobar", "foo", "bar"]
```

- **SEE** [m:Array#\[\]]

### def [](name) -> String | nil

name という名前付きグループにマッチした文字列を返します。

- **param** `name` -- 名前(シンボルか文字列)
- **raise** `IndexError` -- 指定した名前が正規表現内に含まれていない場合に発生します

```ruby title="例"
p /\$(?<dollars>\d+)\.(?<cents>\d+)/.match("$3.67")[:cents] # => "67"
p /(?<alpha>[a-zA-Z]+)|(?<num>\d+)/.match("aZq")[:num] # => nil
```

### def begin(n) -> Integer | nil

n 番目の部分文字列先頭のオフセットを返します。

0 はマッチ全体を意味します。
n 番目の部分文字列がマッチしていなければ nilを返します。

- **param** `n` -- 部分文字列を指定する数値。

- **raise** `IndexError` -- 範囲外の n を指定した場合に発生します。

```ruby title="例"
/(foo)(bar)(BAZ)?/ =~ "foobarbaz"
p $~.begin(0)   # => 0
p $~.begin(1)   # => 0
p $~.begin(2)   # => 3
p $~.begin(3)   # => nil
#@since 3.4
p $~.begin(4)   # => 'begin': index 4 out of matches (IndexError)
#@else
p $~.begin(4)   # => `begin': index 4 out of matches (IndexError)
#@end
```

- **SEE** [m:MatchData#end]

### def begin(name) -> Integer | nil

name という名前付きグループの部分文字列先頭のオフセットを返します。

name の名前付きグループがマッチしていなければ nil を返します。

- **param** `name` -- 名前(シンボルか文字列)

- **raise** `IndexError` -- 正規表現中で定義されていない name を指定した場合に発生します。

```ruby title="例"
/(?<year>\d{4})年(?<month>\d{1,2})月(?:(?<day>\d{1,2})日)?/ =~ "2021年1月"
p $~.begin('year')    # => 0
p $~.begin(:year)     # => 0
p $~.begin('month')   # => 5
p $~.begin(:month)    # => 5
p $~.begin('day')     # => nil
#@since 3.4
p $~.begin('century') # => 'begin': undefined group name reference: century (IndexError)
#@else
p $~.begin('century') # => `begin': undefined group name reference: century (IndexError)
#@end
```

- **SEE** [m:MatchData#end]

### def end(n) -> Integer | nil

n 番目の部分文字列終端のオフセットを返します。

0 はマッチ全体を意味します。
n 番目の部分文字列がマッチしていなければ nil を返します。

- **param** `n` -- 部分文字列を指定する数値。

- **raise** `IndexError` -- 範囲外の n を指定した場合に発生します。

```ruby title="例"
/(foo)(bar)(BAZ)?/ =~ "foobarbaz"
p $~.end(0)   # => 6
p $~.end(1)   # => 3
p $~.end(2)   # => 6
p $~.end(3)   # => nil
#@since 3.4
p $~.end(4)   # => 'end': index 4 out of matches (IndexError)
#@else
p $~.end(4)   # => `end': index 4 out of matches (IndexError)
#@end
```

- **SEE** [m:MatchData#begin]

### def end(name) -> Integer | nil

name という名前付きグループの部分文字列終端のオフセットを返します。

name の名前付きグループがマッチしていなければ nil を返します。

- **param** `name` -- 名前(シンボルか文字列)

- **raise** `IndexError` -- 正規表現中で定義されていない name を指定した場合に発生します。

```ruby title="例"
/(?<year>\d{4})年(?<month>\d{1,2})月(?:(?<day>\d{1,2})日)?/ =~ "2021年1月"
p $~.end('year')    # => 4
p $~.end(:year)     # => 4
p $~.end('month')   # => 6
p $~.end(:month)    # => 6
p $~.end('day')     # => nil
#@since 3.4
p $~.end('century') # => 'end': undefined group name reference: century (IndexError)
#@else
p $~.end('century') # => `end': undefined group name reference: century (IndexError)
#@end
```

- **SEE** [m:MatchData#begin]

### def captures -> [String]
#@since 3.2
### def deconstruct -> [String]
#@end

[m:$1], [m:$2], ... を格納した配列を返します。

[m:MatchData#to_a] と異なり [m:$&] を要素に含みません。
グループにマッチした部分文字列がなければ対応する要素は nil になります。

```ruby title="例"
/(foo)(bar)(BAZ)?/ =~ "foobarbaz"
p $~.to_a       # => ["foobar", "foo", "bar", nil]
p $~.captures   # => ["foo", "bar", nil]
```

#@since 3.2
- **SEE** [m:MatchData#to_a], [m:MatchData#named_captures], [ref:d:spec/pattern_matching#matching_non_primitive_objects]
#@else
- **SEE** [m:MatchData#to_a], [m:MatchData#named_captures]
#@end

#@since 3.2
### def deconstruct_keys(array_of_names) -> Hash

引数で指定された名前の名前付きキャプチャを [c:Hash] で返します。

[c:Hash] のキーは名前付きキャプチャの名前のシンボル、値はキーの名前に対応した名前付きグループのうち最後にマッチした文字列です。

- **param** `array_of_names` -- 名前付きキャプチャの名前の配列を指定します。nil の場合は全ての名前付きキャプチャを意味します。

```ruby title="例"
m = /(?<hours>\d{2}):(?<minutes>\d{2}):(?<seconds>\d{2})/.match("18:37:22")
p m.deconstruct_keys([:hours, :minutes]) # => {:hours => "18", :minutes => "37"}
p m.deconstruct_keys(nil) # => {:hours => "18", :minutes => "37", :seconds => "22"}

# 名前付きキャプチャが定義されていなかった場合は空のハッシュを返す
m = /(\d{2}):(\d{2}):(\d{2})/.match("18:37:22")
p m.deconstruct_keys(nil) # => {}
```

- **SEE** [ref:d:spec/pattern_matching#matching_non_primitive_objects]
#@end

### def length -> Integer
### def size -> Integer

部分文字列の数を返します(self.to_a.size と同じです)。

```ruby title="例"
/(foo)(bar)(BAZ)?/ =~ "foobarbaz"
p $~.size       # => 4
```

### def offset(n) -> [Integer, Integer] | [nil, nil]

n 番目の部分文字列のオフセットの配列 [start, end] を返
します。

```ruby title="例"
[ self.begin(n), self.end(n) ]
```

と同じです。n番目の部分文字列がマッチしていなければ
[nil, nil] を返します。

- **param** `n` -- 部分文字列を指定する数値

- **raise** `IndexError` -- 範囲外の n を指定した場合に発生します。

#@since 3.2
- **SEE** [m:MatchData#begin], [m:MatchData#end], [m:MatchData#byteoffset]
#@else
- **SEE** [m:MatchData#begin], [m:MatchData#end]
#@end
### def offset(name) -> [Integer, Integer] | [nil, nil]

name という名前付きグループに対応する部分文字列のオフセットの配列 [start, end] を返
します。

```ruby title="例"
[ self.begin(name), self.end(name) ]
```

と同じです。nameの名前付きグループにマッチした部分文字列がなければ
[nil, nil] を返します。

- **param** `name` -- 名前(シンボルか文字列)

- **raise** `IndexError` -- 正規表現中で定義されていない name を指定した場合に発生します。

```ruby title="例"
/(?<year>\d{4})年(?<month>\d{1,2})月(?:(?<day>\d{1,2})日)?/ =~ "2021年1月"
p $~.offset('year')    # => [0, 4]
p $~.offset(:year)     # => [0, 4]
p $~.offset('month')   # => [5, 6]
p $~.offset(:month)    # => [5, 6]
p $~.offset('day')     # => [nil, nil]
#@since 3.4
p $~.offset('century') # => 'offset': undefined group name reference: century (IndexError)
#@else
p $~.offset('century') # => `offset': undefined group name reference: century (IndexError)
#@end
```

#@since 3.2
- **SEE** [m:MatchData#begin], [m:MatchData#end], [m:MatchData#byteoffset]
#@else
- **SEE** [m:MatchData#begin], [m:MatchData#end]
#@end
#@since 3.2
### def byteoffset(n) -> [Integer, Integer] | [nil, nil]

n 番目の部分文字列のバイト単位のオフセットの
配列 [start, end] を返します。

n番目の部分文字列がマッチしていなければ [nil, nil] を返します。

- **param** `n` -- 部分文字列を指定する数値

- **raise** `IndexError` -- 範囲外の n を指定した場合に発生します。

- **SEE** [m:MatchData#offset]

### def byteoffset(name) -> [Integer, Integer] | [nil, nil]

name という名前付きグループに対応する部分文字列のバイト単位のオフセットの
配列 [start, end] を返します。

nameの名前付きグループにマッチした部分文字列がなければ
[nil, nil] を返します。

- **param** `name` -- 名前(シンボルか文字列)

- **raise** `IndexError` -- 正規表現中で定義されていない name を指定した場合に発生します。

```ruby title="例"
/(?<year>\d{4})年(?<month>\d{1,2})月(?:(?<day>\d{1,2})日)?/ =~ "2021年1月"
p $~.byteoffset('year')    # => [0, 4]
p $~.byteoffset(:year)     # => [0, 4]
p $~.byteoffset('month')   # => [7, 8]
p $~.byteoffset(:month)    # => [7, 8]
p $~.byteoffset('day')     # => [nil, nil]
#@since 3.4
p $~.byteoffset('century') # => 'offset': undefined group name reference: century (IndexError)
#@else
p $~.byteoffset('century') # => `offset': undefined group name reference: century (IndexError)
#@end
```

- **SEE** [m:MatchData#offset]
#@end

#@since 3.4
### def bytebegin(n) -> Integer | nil
### def bytebegin(name) -> Integer | nil

n 番目の部分文字列先頭のバイトオフセットを返します。

0 はマッチ全体を意味します。
n 番目の部分文字列がマッチしていなければ nilを返します。

引数に文字列またはシンボルを渡した場合は、対応する名前付きキャプチャの先頭のバイトオフセットを返します。

- **param** `n` -- 部分文字列を指定する数値。
- **param** `name` -- 名前付きキャプチャを指定する文字列またはシンボル。

- **raise** `IndexError` -- 範囲外の n を指定した場合に発生します。
- **raise** `IndexError` -- 正規表現中で定義されていない name を指定した場合に発生します。

```ruby title="例"
/(c).*(いう).*(e.*)/ =~ 'abcあいうdef'
p $~              # => #<MatchData "cあいうdef" 1:"c" 2:"いう" 3:"ef">
p $~.bytebegin(0) # => 2
p $~.bytebegin(1) # => 2
p $~.bytebegin(2) # => 6
p $~.bytebegin(3) # => 13
p $~.bytebegin(4) # => index 4 out of matches (IndexError)
```

```ruby title="シンボルを指定する例"
/(?<key>\S+):\s*(?<value>\S+)/ =~ "name: ruby"
p $~                 # => #<MatchData "name: ruby" key:"name" value:"ruby">
p $~.bytebegin(:key) # => 0
p $~.bytebegin(:value) # => 6
$~.bytebegin(:foo)   # => undefined group name reference: foo (IndexError)
```

### def byteend(n) -> Integer | nil
### def byteend(name) -> Integer | nil

n 番目の部分文字列終端のバイトオフセットを返します。

0 はマッチ全体を意味します。
n 番目の部分文字列がマッチしていなければ nilを返します。

引数に文字列またはシンボルを渡した場合は、対応する名前付きキャプチャの終端のバイトオフセットを返します。

- **param** `n` -- 部分文字列を指定する数値。
- **param** `name` -- 名前付きキャプチャを指定する文字列またはシンボル。

- **raise** `IndexError` -- 範囲外の n を指定した場合に発生します。
- **raise** `IndexError` -- 正規表現中で定義されていない name を指定した場合に発生します。

```ruby title="例"
/(c).*(いう).*(e.*)/ =~ 'abcあいうdef'
p $~            # => #<MatchData "cあいうdef" 1:"c" 2:"いう" 3:"ef">
p $~.byteend(0) # => 15
p $~.byteend(1) # => 3
p $~.byteend(2) # => 12
p $~.byteend(3) # => 15
p $~.byteend(4) # => index 4 out of matches (IndexError)
```

```ruby title="シンボルを指定する例"
/(?<key>\S+):\s*(?<value>\S+)/ =~ "name: ruby"
p $~               # => #<MatchData "name: ruby" key:"name" value:"ruby">
p $~.byteend(:key) # => 4
p $~.byteend(:value) # => 10
$~.byteend(:foo)   # => undefined group name reference: foo (IndexError)
```

#@end

### def post_match -> String

マッチした部分より後ろの文字列を返します([m:$']と同じ)。

```ruby title="例"
/(bar)(BAZ)?/ =~ "foobarbaz"
p $~.post_match # => "baz"
```

- **SEE** [m:MatchData#pre_match]

### def pre_match -> String

マッチした部分より前の文字列を返します([m:$`]と同じ)。

```ruby title="例"
/(bar)(BAZ)?/ =~ "foobarbaz"
p $~.pre_match  # => "foo"
```

- **SEE** [m:MatchData#post_match]

### def string -> String

マッチ対象になった文字列の複製を返します。

返す文字列はフリーズ([m:Object#freeze])されています。

```ruby title="例"
m = /(.)(.)(\d+)(\d)/.match("THX1138.")
p m.string # => "THX1138."
```

### def to_a -> [String]

[m:$&], [m:$1], [m:$2],... を格納した配列を返します。

```ruby title="例"
/(foo)(bar)(BAZ)?/ =~ "foobarbaz"
p $~.to_a       # => ["foobar", "foo", "bar", nil]
```

- **SEE** [m:MatchData#captures]

### def to_s -> String

マッチした文字列全体を返します。

```ruby title="例"
/bar/ =~ "foobarbaz"
p $~            # => #<MatchData:0x401b1be4>
p $~.to_s       # => "bar"
```

### def inspect -> String

self の内容を人間に読みやすい文字列にして返します。

```ruby title="例"
puts /.$/.match("foo").inspect
# => #<MatchData "o">

puts /(.)(.)(.)/.match("foo").inspect
# => #<MatchData "foo" 1:"f" 2:"o" 3:"o">

puts /(.)(.)?(.)/.match("fo").inspect
# => #<MatchData "fo" 1:"f" 2:nil 3:"o">

puts /(?<foo>.)(?<bar>.)(?<baz>.)/.match("hoge").inspect
# => #<MatchData "hog" foo:"h" bar:"o" baz:"g">
```

### def values_at(*index) -> [String]

正規表現中の n 番目の括弧にマッチした部分文字列の配列を返します。

0 番目は [m:$&] のようにマッチした文字列全体を表します。

- **param** `index` -- インデックスを整数またはシンボル(名前付きキャプチャの場合)で 0 個以上指定します。

```ruby title="例"
m = /(foo)(bar)(baz)/.match("foobarbaz")
# same as m.to_a.values_at(...)
p m.values_at(0, 1, 2, 3, 4)      # => ["foobarbaz", "foo", "bar", "baz", nil]
p m.values_at(-1, -2, -3, -4, -5) # => ["baz", "bar", "foo", nil, nil]

m = /(?<a>\d+) *(?<op>[+\-*\/]) *(?<b>\d+)/.match("1 + 2")
p m.to_a                 # => ["1 + 2", "1", "+", "2"]
p m.values_at(:a, :b, :op) # => ["1", "2", "+"]
```

- **SEE** [m:Array#values_at], [m:Array#\[\]]

### def names -> [String]

名前付きキャプチャの名前を文字列配列で返します。

self.regexp.names と同じです。

```ruby title="例"
p /(?<foo>.)(?<bar>.)(?<baz>.)/.match("hoge").names
# => ["foo", "bar", "baz"]

m = /(?<x>.)(?<y>.)?/.match("a") # => #<MatchData "a" x:"a" y:nil>
p m.names                        # => ["x", "y"]
```

### def regexp -> Regexp

自身の元になった正規表現オブジェクトを返します。

```ruby title="例"
m = /a.*b/.match("abc")
p m.regexp # => /a.*b/
```

### def hash -> Integer
{: since=""}

self のマッチ対象になった文字列、元になった正規表現オブジェクト、マッチ
した位置を元にハッシュ値を計算して返します。

### def eql?(other) -> bool
{: since=""}
### def ==(other)   -> bool
{: since=""}

self と other のマッチ対象になった文字列、元になった正規表現オブジェク
ト、マッチした位置が等しければ true を返します。そうでない場合には
false を返します。

- **param** `other` -- 比較対象のオブジェクトを指定します。

```ruby title="文字列"
s = "abc"
m1 = s.match("a")
m2 = s.match("b")
p m1 == m2  # => false
m2 = s.match("a")
p m1 == m2  # => true
```

```ruby title="正規表現"
r = /abc/
m1 = r.match("abc")   # => #<MatchData "abc">
m2 = r.match("abcde") # => #<MatchData "abc">
p m1 == m2  # => false
m2 = r.match("abc")   # => #<MatchData "abc">
p m1 == m2  # => true
```

```ruby title="正規表現のマッチした位置"
r = /abc/
m1 = r.match("abcabc")    # => #<MatchData "abc">
m2 = r.match("abcabc", 3) # => #<MatchData "abc">
p m1 == m2  # => false
m2 = r.match("abcabc", 0) # => #<MatchData "abc">
p m1 == m2  # => true
```

#@since 3.3
### def named_captures(symbolize_names: false) -> Hash
#@else
### def named_captures -> Hash
#@end

名前付きキャプチャをHashで返します。

Hashのキーは名前付きキャプチャの名前です。Hashの値はキーの名前に対応した名前付きグループのうち最後にマッチした文字列です。

- **param** `symbolize_names` -- 真を指定するとハッシュのキーを文字列ではなくシンボルにします。デフォルトは偽です。

```ruby title="例"
m = /(?<a>.)(?<b>.)/.match("01")
p m.named_captures # => {"a" => "0", "b" => "1"}

m = /(?<a>.)(?<b>.)?/.match("0")
p m.named_captures # => {"a" => "0", "b" => nil}

m = /(?<a>.)(?<a>.)/.match("01")
p m.named_captures # => {"a" => "1"}

m = /(?<a>x)|(?<a>y)/.match("x")
p m.named_captures # => {"a" => "x"}
#@since 3.3

m = /(?<a>.)(?<a>.)/.match("01")
p m.named_captures(symbolize_names: true) #=> {:a => "1"}
#@end
```

#@since 3.2
- **SEE** [m:MatchData#captures], [m:MatchData#deconstruct_keys]
#@else
- **SEE** [m:MatchData#captures]
#@end
