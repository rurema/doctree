---
type: library
category: Text
---
strscan は 文字列を高速にスキャンするためのライブラリです。

# class StringScanner < Object

StringScanner は文字列スキャナクラスです。
簡単に高速なスキャナを記述できます。

```ruby title="例"
require 'strscan'

s = StringScanner.new('This is an example string')
p s.eos?          #=> false

p s.scan(/\w+/)   #=> "This"
p s.scan(/\w+/)   #=> nil
p s.scan(/\s+/)   #=> " "
p s.scan(/\s+/)   #=> nil
p s.scan(/\w+/)   #=> "is"
p s.eos?          #=> false

p s.scan(/\s+/)   #=> " "
p s.scan(/\w+/)   #=> "an"
p s.scan(/\s+/)   #=> " "
p s.scan(/\w+/)   #=> "example"
p s.scan(/\s+/)   #=> " "
p s.scan(/\w+/)   #=> "string"
p s.eos?          #=> true

p s.scan(/\s+/)   #=> nil
p s.scan(/\w+/)   #=> nil
```

StringScanner オブジェクトはスキャンする文字列と「スキャンポインタ」のセットです。
スキャンポインタとはスキャンしおわったところを示すインデックスのことです。
オブジェクト作成直後にはスキャンポインタは文字列先頭にあり、
その地点でのみマッチを試します。マッチしたらその後ろにポインタを進めます。

```ruby title="例"
require 'strscan'

## a string and a scan pointer   ("_" = scan pointer)

s = StringScanner.new('This is an example string')
# _This is an example string     s.eos? = false
s.scan(/\w+/)
# This_ is an example string     s.eos? = false
s.scan(/\s+/)
# This _is an example string     s.eos? = false
s.scan(/\w+/)
# This is_ an example string     s.eos? = false
s.scan(/\s+/)
# This is _an example string     s.eos? = false
s.scan(/\w+/)
# This is an_ example string     s.eos? = false
s.scan(/\s+/)
# This is an _example string     s.eos? = false
s.scan(/\w+/)
# This is an example_ string     s.eos? = false
s.scan(/\s+/)
# This is an example _string     s.eos? = false
s.scan(/\w+/)
# This is an example string_     s.eos? = true
```

現在のスキャンポインタがさす地点以外でもマッチしたい場合は、[m:StringScanner#scan_until]など
を使ってください。

```ruby title="例: scan, scan_until の動作の違い"
require 'strscan'

def case1
  s = StringScanner.new('test string')
  p s.scan(/t/)       #=> "t"
  p s.scan(/\w+/)     #=> "est"
  p s.scan(/string/)  #=> nil
  p s.scan(/\s+/)     #=> " "
  p s.scan(/string/)  #=> "string"
end

def case2
  s = StringScanner.new('test string')
  p s.scan_until(/t/)       #=> "t"
  p s.scan_until(/\w+/)     #=> "est"
  p s.scan_until(/string/)  #=> " string"
  p s.scan_until(/\s+/)     #=> nil
  p s.scan_until(/string/)  #=> nil
end

p "case1"
case1
p "case2"
case2
```

スキャンポインタの位置は文字単位でなくバイト単位となります。

```ruby title="例:"
# 次の行以降の内容を EUC-JP として保存して試してください
# vim:set fileencoding=euc-jp:
require 'strscan'
s = StringScanner.new("るびい") # 文字コードはEUC-JPとします
p s.exist?(/び/) #=> 4
```

StringScanner は $~ $& $1 $2 …… などの正規表現関連変数を
セットしません。代わりに [m:StringScanner#\[\]], [m:StringScanner#matched?] などの
マッチデータ関連メソッドを使ってください。

## Class Methods

### def new(str, dup = false) -> StringScanner 

新しい StringScanner オブジェクトを生成します。

- **param** `str` -- スキャン対象の文字列を指定します。

- **param** `dup` -- dup は単に無視します。
           引数の文字列は複製も freeze もされず、そのまま使います。

```ruby title="例"
require 'strscan'

s = StringScanner.new('This is an example string')
p s.eos?          #=> false

p s.scan(/\w+/)   #=> "This"
p s.scan(/\w+/)   #=> nil
p s.scan(/\s+/)   #=> " "
```

### def  must_C_version -> self

このメソッドは後方互換性のために定義されています。

## Instance Methods

### def [](nth) -> String | nil

前回マッチした正規表現の nth 番目のかっこに対応する部分文字列を
返します。インデックス 0 はマッチした部分全体です。前回のマッチが
失敗していると常に nil を返します。

- **param** `nth` -- 前回マッチした正規表現の nth 番目のかっこに対応する部分文字列を
           返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan(/\w(\w)(\w*)/) # => "test"
p s[0]                # => "test"
p s[1]                # => "e"
p s[2]                # => "st"
p s.scan(/\w+/)       # => nil
p s[0]                # => nil
p s[1]                # => nil
p s[2]                # => nil
p s.scan(/\s+/)       # => " "
p s[0]                # => " "
p s[1]                # => nil
p s[2]                # => nil
p s.scan(/\w(\w)(\w*)/) # => "string"
p s[0]                # => "string"
p s[1]                # => "t"
p s[2]                # => "ring"
```

### def <<(str) -> self
### def concat(str) -> self

操作対象の文字列に対し str を破壊的に連結します。
マッチ記録は変更されません。

selfを返します。

- **param** `str` -- 操作対象の文字列に対し str を破壊的に連結します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test') # => #<StringScanner 0/4 @ "test">
p s.scan(/\w(\w*)/)           # => "test"
p s[0]                        # => "test"
p s[1]                        # => "est"
p s << ' string'              # => #<StringScanner 4/11 "test" @ " stri...">
p s[0]                        # => "test"
p s[1]                        # => "est"
p s.scan(/\s+/)               # => " "
p s.scan(/\w+/)               # => "string"
```

この操作は StringScanner.new に渡した文字列にも影響することがあります。

```ruby title="例"
require 'strscan'

str = 'test'
s = StringScanner.new(str) # => #<StringScanner 0/4 @ "test">
p s << ' string'           # => #<StringScanner 0/11 @ "test ...">
p str                      # => "test string"
```

### def beginning_of_line? -> bool
### def bol? -> bool

スキャンポインタが行頭を指しているなら true を、
行頭以外を指しているなら false を返します。

行頭の定義は、文字列先頭かまたは \n の直後を指していることです。
文字列末尾は必ずしも行頭ではありません。

```ruby title="例"
require 'strscan'

s = StringScanner.new("test\nstring")
p s.bol?      # => true
s.scan(/\w+/)
p s.bol?      # => false
s.scan(/\n/)
p s.bol?      # => true
s.scan(/\w+/)
p s.bol?      # => false
```

### def check(regexp) -> String | nil

現在位置から regexp とのマッチを試みます。
マッチに成功したらマッチした部分文字列を返します。
マッチに失敗したら nil を返します。

このメソッドはマッチが成功してもスキャンポインタを進めません。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.check(/\w+/) # => "test"
p s.pos        # => 0
p s.matched    # => "test"
p s.check(/\s+/) # => nil
p s.matched    # => nil
```

### def check_until(regexp) -> String | nil

regexp が一致するまで文字列をスキャンします。
マッチに成功したらスキャン開始位置からマッチ部分の末尾までの部分文字列を返します。
マッチに失敗したら nil を返します。

このメソッドはマッチが成功してもスキャンポインタを進めません。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.check_until(/str/) # => "test str"
p s.matched          # => "str"
p s.pos              # => 0
p s.pre_match        # => "test "
```

### def eos? -> bool
### def empty? -> bool

スキャンポインタが文字列の末尾を指しているなら true を、
末尾以外を指しているなら false を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.eos?      # => false
s.scan(/\w+/)
s.scan(/\s+/)
s.scan(/\w+/)
p s.eos?      # => true
```

[m:StringScanner#empty?] は将来のバージョンで削除される予定です。
代わりに [m:StringScanner#eos?] を使ってください。

### def exist?(regexp) -> Integer | nil
#@#Ruby 1.8.6 以降は以下の記述に沿った仕様に変わります。

スキャンポインタの位置から，次にマッチする文字列の末尾までの長さを返します。

マッチに失敗したら nil を返します。

このメソッドはマッチが成功してもスキャンポインタを進めません。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.exist?(/s/) # => 3
p s.exist?(//)  # => 0
p s.scan(/\w+/) # => "test"
p s.exist?(/s/) # => 2
p s.exist?(/e/) # => nil
```

### def getch -> String | nil

一文字スキャンして文字列で返します。
スキャンポインタをその後ろに進めます。
スキャンポインタが文字列の末尾を指すならnilを返します。

一文字の定義は、与えた文字列のエンコードに依存します。

```ruby title="例"
require 'strscan'

utf8 = "\u{308B 3073 3044}"
s = StringScanner.new(utf8.encode("UTF-8")) 
p s.getch                         # => "る"
p s.getch                         # => "び"
p s.getch                         # => "い"
p s.getch                         # => nil
```

### def get_byte -> String | nil
### def getbyte -> String | nil

1 バイトスキャンして文字列で返します。
スキャンポインタをその後ろに進めます。
スキャンポインタが文字列の末尾を指すなら nil を返します。

[m:StringScanner#getbyte] は将来のバージョンで削除される予定です。
代わりに [m:StringScanner#get_byte] を使ってください。

```ruby title="例"
require 'strscan'

utf8 = "\u{308B 3073 3044}"
s = StringScanner.new(utf8.encode("EUC-JP"))
p s.get_byte       #=> "\xA4"
p s.get_byte       #=> "\xEB"
p s.get_byte       #=> "\xA4"
p s.get_byte       #=> "\xD3"
p s.get_byte       #=> "\xA4"
p s.get_byte       #=> "\xA4"
p s.get_byte       #=> nil   
```

### def inspect -> String

StringScannerオブジェクトを表す文字列を返します。

文字列にはクラス名の他、以下の情報が含まれます。

    - スキャナポインタの現在位置。
    - スキャン対象の文字列の長さ。
    - スキャンポインタの前後にある文字。上記実行例の @ がスキャンポインタを表します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.inspect                          # => "#<StringScanner 0/11 @ \"test ...\">"
p s.scan(/\w+/)                      # => "test"
p s.inspect                          # => "#<StringScanner 4/11 \"test\" @ \" stri...\">"
p s.scan(/\s+/)                      # => " "
p s.inspect                          # => "#<StringScanner 5/11 \"test \" @ \"strin...\">"
p s.scan(/\w+/)                      # => "string"
p s.inspect                          # => "#<StringScanner fin>"
```

### def match?(regexp) -> Integer | nil

スキャンポインタの地点だけで regexp と文字列のマッチを試します。
マッチしたら、スキャンポインタは進めずにマッチした
部分文字列の長さを返します。マッチしなかったら nil を
返します。

マッチしたサイズは文字単位でなくバイト単位となります。

```ruby
require 'strscan'
def case1(encode)
  utf8 = "\u{308B 3073 3044}"
  s = StringScanner.new(utf8.encode(encode))
  s.match?(/#{"\u{308B}".encode(encode)}/)
end

p case1("EUC-JP")     #=> 2
```

- **param** `regexp` -- マッチに用いる正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.match?(/\w+/)   #=> 4
p s.match?(/\w+/)   #=> 4
p s.match?(/\s+/)   #=> nil
```

### def matched -> String | nil

前回マッチした部分文字列を返します。
前回のマッチに失敗していると nil を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.matched   # => nil
p s.scan(/\w+/) # => "test"
p s.matched   # => "test"
p s.scan(/\w+/) # => nil
p s.matched   # => nil
p s.scan(/\s+/) # => " "
p s.matched   # => " "
```

### def matched? -> bool

前回のマッチが成功していたら true を、
失敗していたら false を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.matched?  # => false
p s.scan(/\w+/) # => "test"
p s.matched?  # => true
p s.scan(/\w+/) # => nil
p s.matched?  # => false
p s.scan(/\s+/) # => " "
p s.matched?  # => true
```

### def matched_size -> Integer | nil

前回マッチした部分文字列の長さを返します。
前回マッチに失敗していたら nil を返します。

マッチしたサイズは文字単位でなくバイト単位となります。

```ruby
require 'strscan'

def run(encode)
  utf8 = "\u{308B 3073 3044}" # るびい
  s = StringScanner.new(utf8.encode(encode))
  s.scan(/#{"\u{308B}".encode(encode)}/)
  s.matched_size
end

p run("UTF-8")     #=> 3
p run("EUC-JP")    #=> 2
p run("Shift_Jis") #=> 2

```

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.matched_size # => nil
p s.scan(/\w+/)  # => "test"
p s.matched_size # => 4
p s.scan(/\w+/)  # => nil
p s.matched_size # => nil
```

### def peek(bytes) -> String
### def peep(bytes) -> String

スキャンポインタから長さ bytes バイト分だけ文字列を返します。

```ruby title="例"
require 'strscan'
s = StringScanner.new('test string')
p s.peek(4) # => "test"
```

また、このメソッドを実行してもスキャンポインタは移動しません。

[m:StringScanner#peep] は将来のバージョンでは削除される予定です。
代わりに [m:StringScanner#peek] を使ってください。

- **param** `bytes` -- 0 以上の整数を指定します。
             ただし、スキャン対象の文字列の長さを超える分は無視されます。
             bytes が 0 のとき、またはスキャンポインタが文字列の末尾を
             指しているときは空文字列 ("") を返します。

- **raise** `ArgumentError` -- bytes に負数を与えると発生します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.peek(4)     # => "test"
p s.peek(20)    # => "test string"
p s.peek(0)     # => ""
begin
  s.peek(-1)
rescue ArgumentError => err
  puts err # negative string size (or size too big)
end
p s.scan(/\w+/) # => "test"
p s.scan(/\s+/) # => " "
p s.scan(/\w+/) # => "string"
p s.peek(4)     # => ""

# このメソッドを実行してもスキャンポインタは移動しません。

s = StringScanner.new('test string')
p s.peek(4)     # => "test"
p s.peek(4)     # => "test"
p s.scan(/\w+/) # => "test"
p s.peek(4)     # => " str"
p s.peek(4)     # => " str"
```

### def pointer -> Integer
### def pos -> Integer

現在のスキャンポインタのインデックスを返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.pos       # => 0
p s.scan(/\w+/) # => "test"
p s.pos       # => 4
p s.scan(/\w+/) # => nil
p s.pos       # => 4
p s.scan(/\s+/) # => " "
p s.pos       # => 5
```

- **SEE** [m:StringScanner#charpos]

### def charpos -> Integer

現在のスキャンポインタのインデックスを文字単位で返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new("abcädeföghi")
p s.charpos         # => 0
p s.scan_until(/ä/) # => "abcä"
p s.pos             # => 5
p s.charpos         # => 4
```

- **SEE** [m:StringScanner#pos]

### def pointer=(n)
### def pos=(n)

スキャンポインタのインデックスを n にセットします。

- **param** `n` -- 整数で、バイト単位で指定します。
         負数を指定すると文字列の末尾からのオフセットとして扱います。
- **raise** `RangeError` --  マッチ対象の文字列の長さを超える値を指定すると発生します。

- **return** -- n を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan(/\w+/) # => "test"
p s.pos = 1     # => 1
p s.scan(/\w+/) # => "est"
p s.pos = 7     # => 7
p s.scan(/\w+/) # => "ring"

begin
  s.pos = 20
rescue RangeError => err
  puts err #=> index out of range
end
p s.pos = -4    # => -4
p s.scan(/\w+/) # => "ring"
```

### def post_match -> String | nil

前回マッチを行った文字列のうち、マッチしたところよりも後ろの
部分文字列を返します。前回のマッチが失敗していると常に nil を
返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.post_match  # => nil
p s.scan(/\w+/) # => "test"
p s.post_match  # => " string"
p s.scan(/\w+/) # => nil
p s.post_match  # => nil
p s.scan(/\s+/) # => " "
p s.post_match  # => "string"
p s.scan(/\w+/) # => "string"
p s.post_match  # => ""
p s.scan(/\w+/) # => nil
p s.post_match  # => nil
```

### def pre_match -> String | nil

前回マッチを行った文字列のうち、マッチしたところよりも前の
部分文字列を返します。前回のマッチが失敗していると常に nil を
返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.pre_match # => nil
p s.scan(/\w+/) # => "test"
p s.pre_match # => ""
p s.scan(/\w+/) # => nil
p s.pre_match # => nil
p s.scan(/\s+/) # => " "
p s.pre_match # => "test"
p s.scan(/\w+/) # => "string"
p s.pre_match # => "test "
p s.scan(/\w+/) # => nil
p s.pre_match # => nil
```

### def reset -> self

スキャンポインタを文字列の先頭 (インデックス 0) に戻し、
マッチ記録を捨てます。

pos = 0と同じ動作です。

- **return** -- self を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan(/\w+/) # => "test"
p s.matched   # => "test"
p s.pos       # => 4
p s[0]        # => "test"
s.reset
p s.matched   # => nil
p s[0]        # => nil
p s.pos       # => 0
```

### def rest -> String

文字列の残り (rest) を返します。
具体的には、スキャンポインタが指す位置からの文字列を返します。

スキャンポインタが文字列の末尾を指していたら空文字列 ("") を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.rest       # => "test string"
p s.scan(/\w+/)  # => "test"
p s.rest       # => " string"
p s.scan(/\s+/)  # => " "
p s.rest       # => "string"
p s.scan(/\w+/)  # => "string"
p s.rest       # => ""
```

### def rest? -> bool

文字列が残っているならば trueを、
残っていないならば false を返します。

[m:StringScanner#eos?] と逆の結果を返します。

[m:StringScanner#rest?] は将来のバージョンで削除される予定です。
代わりに [m:StringScanner#eos?] を使ってください。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.eos?        # => false
p s.rest?       # => true
s.scan(/\w+/)
s.scan(/\s+/)
s.scan(/\w+/)
p s.eos?        # => true
p s.rest?       # => false
```

### def rest_size -> Integer
### def restsize -> Integer

文字列の残りの長さを返します。
stringscanner.rest.size と同じです。

[m:StringScanner#restsize] は将来のバージョンで削除される予定です。
代わりに[m:StringScanner#rest_size] を使ってください。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.rest_size # => 11
p s.rest.size # => 11
```

### def scan(regexp) -> String | nil

スキャンポインタの地点だけで regexp と文字列のマッチを試します。
マッチしたら、スキャンポインタを進めて正規表現にマッチした
部分文字列を返します。マッチしなかったら nil を返します。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan(/\w+/)   #=> "test"
p s.scan(/\w+/)   #=> nil
p s.scan(/\s+/)   #=> " "
p s.scan(/\w+/)   #=> "string"
p s.scan(/./)     #=> nil
```

### def scan_full(regexp, s, f) -> object

スキャンポインタの位置から regexp と文字列のマッチを試します。

マッチに成功すると、s と f の値によって以下のように動作します。

    - s が true ならばスキャンポインタを進めます。
    - s が false ならばスキャンポインタを進めません。
    - f が true ならばマッチした部分文字列を返します。
    - f が false ならばマッチした部分文字列の長さを返します。

マッチに失敗すると s や f に関係なく nil を返します。

このメソッドは s と f の組み合わせにより、
他のメソッドと同等の動作になります。

    - scan_full(regexp, true, true) は [m:StringScanner#scan] と同等。
    - scan_full(regexp, true, false) は [m:StringScanner#skip] と同等。
    - scan_full(regexp, false, true) は [m:StringScanner#check] と同等。
    - scan_full(regexp, false, false) は [m:StringScanner#match?] と同等。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

- **param** `s` -- true ならばスキャンポインタを進めます。
         false ならばスキャンポインタを進めません。

- **param** `f` -- true ならばマッチした部分文字列を返します。
         false ならばマッチした部分文字列の長さを返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan_full(/\w+/, true, true)     #=> "test"
p s.scan_full(/\s+/, false, true)    #=> " "
p s.scan_full(/\s+/, true, false)    #=> 1
p s.scan_full(/\w+/, false, false)   #=> 6
p s.scan_full(/\w+/, true, true)     #=> "string"
```

- **SEE** [m:StringScanner#scan] [m:StringScanner#skip] [m:StringScanner#check]  [m:StringScanner#match?] 

### def scan_until(regexp) -> String | nil

regexp で指定された正規表現とマッチするまで文字列をスキャンします。
マッチに成功したらスキャンポインタを進めて、
スキャン開始位置からマッチ部分の末尾までの部分文字列を返します。
マッチに失敗したら nil を返します。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan_until(/str/) # => "test str"
p s.matched         # => "str"
p s.pos             # => 8
p s.pre_match       # => "test "
```

### def search_full(regexp, s, f) -> object

regexp で指定された正規表現とマッチするまで文字列をスキャンします。

マッチに成功すると、s と f の値によって以下のように動作します。

    - s が true ならばスキャンポインタを進めます。
    - s が false ならばスキャンポインタを進めません。
    - f が true ならばスキャン開始位置からマッチした部分の末尾までの部分文字列を返します。
    - f が false ならばスキャン開始位置からマッチした部分の末尾までの部分文字列の長さを返します。

マッチに失敗すると s や f に関係なく nil を返します。

このメソッドは s と f の組み合わせにより、
他のメソッドと同等の動作になります。

    - search_full(regexp, true, true) は [m:StringScanner#scan_until] と同等。
    - search_full(regexp, true, false) は [m:StringScanner#skip_until] と同等。
    - search_full(regexp, false, true) は [m:StringScanner#check_until] と同等。
    - search_full(regexp, false, false) は [m:StringScanner#exist?] と同等。

- **param** `regexp` -- マッチに用いる正規表現を指定します。

- **param** `s` -- true ならばスキャンポインタを進めます。
         false ならばスキャンポインタを進めません。

- **param** `f` -- true ならばマッチした部分文字列を返します。
         false ならばマッチした部分文字列の長さを返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')   
p s.search_full(/t/, true, true)       #=> "t"
p s.search_full(/str/, false, true)    #=> "est str"
p s.search_full(/string/, true, true)  #=> "est string"
```

- **SEE** [m:StringScanner#scan_until] [m:StringScanner#skip_until] [m:StringScanner#check_until] [m:StringScanner#exist?]

### def skip(regexp) -> Integer | nil

スキャンポインタの地点だけで regexp と文字列のマッチを試します。
マッチしたらスキャンポインタを進めマッチした部分文字列の
長さを返します。マッチしなかったら nil を返します。

- **param** `regexp` -- マッチに使用する正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.skip(/\w+/)   #=> 4
p s.skip(/\w+/)   #=> nil
p s.skip(/\s+/)   #=> 1
p s.skip(/\w+/)   #=> 6
p s.skip(/./)     #=> nil
```

### def skip_until(regexp) -> Integer | nil

regexp が一致するまで文字列をスキャンします。
マッチに成功したらスキャンポインタを進めて、
スキャン開始位置からマッチ部分の末尾までの部分文字列の長さを返します。
マッチに失敗したら nil を返します。

- **param** `regexp` -- マッチに使用する正規表現を指定します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan_until(/str/) # => 8
p s.matched         # => "str"
p s.pos             # => 8
p s.pre_match       # => "test "
```

### def string -> String

スキャン対象にしている文字列を返します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.string # => "test string"
```

#@#Ruby 1.8.1 以降では
返り値は freeze されていません。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.string.frozen? # => false
```

なお、このメソッドは StringScanner.new に渡した
文字列をそのまま返しますが、この仕様が将来に渡って保証されるわけではありません。
この仕様に依存したコードを書かないようにしましょう。

```ruby title="例"
require 'strscan'

str = 'test string'
s = StringScanner.new(str)
p s.string == str  # => true
p s.string.eql?(str) # => true (将来は false になる可能性がある)
```

また、返り値の文字列に対して破壊的な変更もできますが、
この操作がスキャン対象の文字列を変更することも保証されません。
この仕様に依存したコードを書かないでください。

```ruby title="例"
require 'strscan'

str = 'test string'
s = StringScanner.new(str)
s.string.replace("0123")
p s.scan(/\w+/)   # => "0123" (将来は "test" が返る可能性あり)
p str             # => "0123" (将来は "test string" が返る可能性あり)
```

### def string=(str)

スキャン対象の文字列を str に変更して、マッチ記録を捨てます。

- **param** `str` -- スキャン対象の文字列を str に変更して、マッチ記録を捨てます。

- **return** -- str を返します。

```ruby title="例"
require 'strscan'

str = '0123'
s = StringScanner.new('test string')
s.string = str     # => "0123"
p s.scan(/\w+/)    # => "0123"
```

### def terminate -> self
### def clear -> self

スキャンポインタを文字列末尾後まで進め、マッチ記録を捨てます。

- **return** -- self を返します。

pos = self.string.size と同じ動作です。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan(/\w+/) # => "test"
p s.matched   # => "test"
p s.pos       # => 4
p s[0]        # => "test"
s.terminate
p s.matched   # => nil
p s[0]        # => nil
p s.pos       # => 11
```

[m:StringScanner#clear] は将来のバージョンで削除される予定です。
代わりに [m:StringScanner#terminate] を使ってください。

### def unscan -> self

スキャンポインタを前回のマッチの前の位置に戻します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
p s.scan(/\w+/) # => "test"
s.unscan
p s.scan(/\w+/) # => "test"
```

- **return** -- selfを返します。

このメソッドでポインタを戻せるのは 1 回分だけです。
2 回分以上戻そうとしたときは例外 StringScanner::Error が発生します。
また、まだマッチを一度も行っていないときや、
前回のマッチが失敗していたときも例外 StringScanner::Error が発生します。

- **raise** `StringScanner::Error` -- 2 回分以上戻そうとした時や、
                            まだマッチを一度も行っていない時、
                            前回のマッチが失敗していた時に発生します。

```ruby title="例"
require 'strscan'

s = StringScanner.new('test string')
begin
  # マッチを一度も行っていないので、例外が発生する。
  s.unscan
rescue StringScanner::Error => err
  puts err
  # 出力例
  #=> unscan failed: previous match had failed
end
p s.scan(/\w+/) # => "test"
s.unscan
begin
  # 二回以上戻そうとしたので、例外が発生する。
  s.unscan
rescue StringScanner::Error => err
  puts err
  # 出力例
  #=> unscan failed: previous match had failed
end
p s.scan(/\w+/) # => "test"
p s.scan(/\w+/) # => nil
begin
  # 前回のマッチが失敗しているので、例外が発生する。
  s.unscan
rescue => err
  puts err
  # 出力例
  #=> unscan failed: previous match had failed
end
```

#@# bc-rdoc: detected missing name: matchedsize
### def matchedsize -> Integer | nil

[m:StringScanner#matched_size] と同じです。

このメソッドは は将来のバージョンで削除される予定です。
代わりに [m:StringScanner#matched_size] を使ってください。

- **SEE** [m:StringScanner#matched_size] 

## Constants

### const Version -> String

[c:StringScanner] クラスのバージョンを文字列で返します。
この文字列は [m:Object#freeze] されています。

```ruby title="例"
require 'strscan'

p StringScanner::Version         # => "0.7.0"
p StringScanner::Version.frozen? # => true
```

### const Id -> String

[c:StringScanner] クラスの詳しいバージョンを文字列で返します。
この文字列は [m:Object#freeze] されています。

# class StringScanner::Error

スキャン中に発生したエラーをあらわす例外です。

