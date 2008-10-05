#@since 1.8.0
文字列を高速にスキャンするためのライブラリです。

= class StringScanner < Object

strscan は文字列スキャナライブラリです。
簡単に高速なスキャナを記述できます。

    s = StringScanner.new('This is an example string')
    s.eos?            #=> false

    p s.scan(/\w+/)   #=> "This"
    p s.scan(/\w+/)   #=> nil
    p s.scan(/\s+/)   #=> " "
    p s.scan(/\s+/)   #=> nil
    p s.scan(/\w+/)   #=> "is"
    s.eos?            #=> false

    p s.scan(/\s+/)   #=> " "
    p s.scan(/\w+/)   #=> "an"
    p s.scan(/\s+/)   #=> " "
    p s.scan(/\w+/)   #=> "example"
    p s.scan(/\s+/)   #=> " "
    p s.scan(/\w+/)   #=> "string"
    s.eos?            #=> true

    p s.scan(/\s+/)   #=> nil
    p s.scan(/\w+/)   #=> nil

StringScanner オブジェクトはスキャンする文字列と「スキャンポインタ」のセットです。
スキャンポインタとはスキャンしおわったところを示すインデックスのことです。
オブジェクト作成直後にはスキャンポインタは文字列先頭にあり、
その地点でのみマッチを試します。マッチしたらその後ろにポインタを進めます。

    ## a string and a scan pointer   ("_" = scan pointer)

    s = StringScanner.new('This is an example string')
    _This is an example string     s.eos? = false
    s.scan(/\w+/)
    This_ is an example string     s.eos? = false
    s.scan(/\s+/)
    This _is an example string     s.eos? = false
    s.scan(/\w+/)
    This is_ an example string     s.eos? = false
    s.scan(/\s+/)
    This is _an example string     s.eos? = false
    s.scan(/\w+/)
    This is an_ example string     s.eos? = false
    s.scan(/\s+/)
    This is an _example string     s.eos? = false
    s.scan(/\w+/)
    This is an example_ string     s.eos? = false
    s.scan(/\s+/)
    This is an example _string     s.eos? = false
    s.scan(/\w+/)
    This is an example string_     s.eos? = true

StringScanner は $~ $& $1 $2 …… などの正規表現関連変数を
セットしません。代わりに StringScanner#[], #matched? などの
マッチデータ関連メソッドを使ってください。

== Class Methods

--- new(str, dup = false) -> StringScanner -> StringScanner

新しい StringScanner オブジェクトを生成します。

@param str スキャン対象の文字列を指定します。

#@if (version <= "1.8.0")
@param dup dup が true の時は文字列を複製して freeze します。
           dup が false なら複製せずに freeze します。
#@else
@param dup dup は単に無視します。
           引数の文字列は複製も freeze もされず、そのまま使います。
#@end

使用例
    s = StringScanner.new('This is an example string')
    s.eos?            #=> false

    p s.scan(/\w+/)   #=> "This"
    p s.scan(/\w+/)   #=> nil
    p s.scan(/\s+/)   #=> " "

---  StringScanner.must_C_version -> self
このメソッドは後方互換性のために定義されています。

== Instance Methods

--- [](nth) -> String | nil

前回マッチした正規表現の nth 番目のかっこに対応する部分文字列を
返します。インデックス 0 はマッチした部分全体です。前回のマッチが
失敗していると常に nil を返します。

@param nth 前回マッチした正規表現の nth 番目のかっこに対応する部分文字列を
           返します。


      s = StringScanner.new('test string')
      s.scan(/\w(\w)(\w*)/) # => "test"
      s[0]                  # => "test"
      s[1]                  # => "e"
      s[2]                  # => "st"
      s.scan(/\w+/)         # => nil
      s[0]                  # => nil
      s[1]                  # => nil
      s[2]                  # => nil
      s.scan(/\s+/)         # => " "
      s[0]                  # => " "
      s[1]                  # => nil
      s[2]                  # => nil
      s.scan(/\w(\w)(\w*)/) # => "string"
      s[0]                  # => "string"
      s[1]                  # => "t"
      s[2]                  # => "ring"

#@if (version >= "1.8.1")
--- <<(str) -> self
--- concat(str) -> self

操作対象の文字列に対し str を破壊的に連結します。
マッチ記録は変更されません。

selfを返します。

@param str 操作対象の文字列に対し str を破壊的に連結します。

      s = StringScanner.new('test') # => #<StringScanner 0/4 @ "test">
      s.match(/\w(\w*)/)            # => "test"
      s[0]                          # => "test"
      s[1]                          # => "est"
      s << ' string'                # => #<StringScanner 4/11 "test" @ " stri...">
      s[0]                          # => "test"
      s[1]                          # => "est"
      s.match(/\s+/)                # => " "
      s.match(/\w+/)                # => "string"

この操作は StringScanner.new に渡した文字列にも影響することがあります。

      str = 'test'
      s = StringScanner.new(str) # => #<StringScanner 0/4 @ "test">
      s << ' string'             # => #<StringScanner 0/11 @ "test ...">
      str                        # => "test string"
#@end

#@if (version >= "1.8.1")
--- beginning_of_line? -> bool
--- bol? -> bool
#@todo
スキャンポインタが行頭を指しているなら true を、
行頭以外を指しているなら false を返します。

行頭の定義は、文字列先頭かまたは \n の直後を指していることです。
文字列末尾は必ずしも行頭ではありません。

      s = StringScanner.new("test\nstring")
      s.bol?        # => true
      s.scan(/\w+/)
      s.bol?        # => false
      s.scan(/\n/)
      s.bol?        # => true
      s.scan(/\w+/)
      s.bol?        # => false
#@end

--- check(regexp) -> String | nil
現在位置から regexp とのマッチを試みます。
マッチに成功したらマッチした部分文字列を返します。
マッチに失敗したら nil を返します。

このメソッドはマッチが成功してもスキャンポインタを進めません。

@param regexp マッチに用いる正規表現を指定します。

      s = StringScanner.new('test string')
      s.check(/\w+/) # => "test"
      s.pos          # => 0
      s.matched      # => "test"
      s.check(/\s+/) # => nil
      s.matched      # => nil

--- check_until(regexp) -> String | nil
regexp が一致するまで文字列をスキャンします。
マッチに成功したらスキャン開始位置からマッチ部分の末尾までの部分文字列を返します。
マッチに失敗したら nil を返します。

このメソッドはマッチが成功してもスキャンポインタを進めません。

@param regexp マッチに用いる正規表現を指定します。

      s = StringScanner.new('test string')
      s.check_until(/str/) # => "test str"
      s.matched            # => "str"
      s.pos                # => 0
      s.pre_match          # => "test "

--- eos? -> bool
--- empty? -> bool
スキャンポインタが文字列の末尾を指しているなら true を、
末尾以外を指しているなら false を返します。

      s = StringScanner.new('test string')
      s.eos?        # => false
      s.scan(/\w+/)
      s.scan(/\s+/)
      s.scan(/\w+/)
      s.eos?        # => true

[[m:StringScanner#empty?]] は将来のバージョンで削除される予定です。
代わりに [[m:StringScanner#eos?]] を使ってください。

--- exist?(regexp) -> Fixnum | nil
#@if (version <= "1.8.5")
[注意] このメソッドは Ruby 1.8.5 以前では正しく動作しません。
#@else
#@#Ruby 1.8.6 以降は以下の記述に沿った仕様に変わります。

スキャンポインタの位置から，次にマッチする文字列の末尾までの長さを返します。

マッチに失敗したら nil を返します。

このメソッドはマッチが成功してもスキャンポインタを進めません。

      s = StringScanner.new('test string')
      s.exist?(/s/) # => 3
      s.exist?(//)  # => 0
      s.scan(/\w+/) # => "test"
      s.exist?(/s/) # => 2
      s.exist?(/e/) # => nil
#@end

--- getch
#@todo
一文字スキャンして文字列で返します。
一文字の定義は $KCODE に依存します。
スキャンポインタをその後ろに進めます。
スキャンポインタが文字列の末尾を指すならnilを返します。

      s = StringScanner.new("るびい") # 文字コードはEUC-JPとします
      $KCODE = 'n'                    # 単なるバイト列として認識されます
      s.getch                         # => "\244"
      s.getch                         # => "\353"
      $KCODE = "e"                    # EUC-JPの文字列として認識されます
      s.getch                         # => "び"
      s.getch                         # => "い"
      s.getch                         # => nil


--- get_byte
--- getbyte
#@todo
$KCODE に関らず 1 バイトスキャンして文字列で返します。
スキャンポインタをその後ろに進めます。
スキャンポインタが文字列の末尾を指すなら nil を返します。

      s = StringScanner.new("るびい") # 文字コードはEUC-JPとします
      $KCODE = 'n'                    # 単なるバイト列として認識されます
      s.get_byte                      # => "\244"
      s.get_byte                      # => "\353"
      $KCODE = 'e'                    # やはり単なるバイト列として認識されます
      s.get_byte                      # => "\244"
      s.get_byte                      # => "\323"
      s.get_byte                      # => "\244"
      s.get_byte                      # => "\244"
      s.get_byte                      # => nil

[[m:StringScanner#getbyte]] は将来のバージョンで削除される予定です。
代わりに [[m:StringScanner#get_byte]] を使ってください。

--- inspect
#@todo
StringScannerオブジェクトを表す文字列を返します。

      s = StringScanner.new('test string')
      s.inspect                            # => "#<StringScanner 0/11 @ \"test ...\">"
      s.scan(/\w+/)                        # => "test"
      s.inspect                            # => "#<StringScanner 4/11 \"test\" @ \" stri...\">"
      s.scan(/\s+/)                        # => " "
      s.inspect                            # => "#<StringScanner 5/11 \"test \" @ \"strin...\">"
      s.scan(/\w+/)                        # => "string"
      s.inspect                            # => "#<StringScanner fin>"

文字列にはクラス名の他、以下の情報が含まれます。

    * スキャナポインタの現在位置。
    * スキャン対象の文字列の長さ。
    * スキャンポインタの前後にある文字。上記実行例の @ がスキャンポインタを表します。

--- match?(regexp)
#@todo
スキャンポインタの地点だけで regexp と文字列のマッチを試します。
マッチしたら、スキャンポインタは進めずにマッチした
部分文字列の長さを返します。マッチしなかったら nil を
返します。

        s = StringScanner.new('test string')
        p s.match?(/\w+/)   #=> 4
        p s.match?(/\w+/)   #=> 4
        p s.match?(/\s+/)   #=> nil

--- matched
#@todo
前回マッチした部分文字列を返します。
前回のマッチに失敗していると nil を返します。

      s = StringScanner.new('test string')
      s.matched     # => nil
      s.scan(/\w+/) # => "test"
      s.matched     # => "test"
      s.scan(/\w+/) # => nil
      s.matched     # => nil
      s.scan(/\s+/) # => " "
      s.matched     # => " "

--- matched?
#@todo
前回のマッチが成功していたら true を、
失敗していたら false を返します。

      s = StringScanner.new('test string')
      s.matched?    # => false
      s.scan(/\w+/) # => "test"
      s.matched?    # => true
      s.scan(/\w+/) # => nil
      s.matched?    # => false
      s.scan(/\s+/) # => " "
      s.matched?    # => true

--- matched_size
#@todo
前回マッチした部分文字列の長さを返します。
前回マッチに失敗していたら nil を返します。

      s = StringScanner.new('test string')
      s.matched_size # => nil
      s.scan(/\w+/)  # => "test"
      s.matched_size # => 4
      s.scan(/\w+/)  # => nil
      s.matched_size # => nil

--- peek(bytes)
--- peep(bytes)
#@todo
スキャンポインタから長さ bytes バイト分だけ文字列を返します。

      s = StringScanner.new('test string')
      s.peek(4)   # => "test"

bytes は 0 以上の整数です。
ただし、スキャン対象の文字列の長さを超える分は無視されます。
また、負数を与えると例外 ArgumentError が発生します。
bytes が 0 のとき、またはスキャンポインタが文字列の末尾を
指しているときは空文字列 ("") を返します。

      s = StringScanner.new('test string')
      s.peek(4)     # => "test"
      s.peek(20)    # => "test string"
      s.peek(0)     # => ""
      s.peek(-1)    # ArgumentError: negative string size (or size too big)
      s.scan(/\w+/) # => "test"
      s.scan(/\s+/) # => " "
      s.scan(/\w+/) # => "string"
      s.peek(4)     # => ""

このメソッドを実行してもスキャンポインタは移動しません。

      s = StringScanner.new('test string')
      s.peek(4)     # => "test"
      s.peek(4)     # => "test"
      s.scan(/\w+/) # => "test"
      s.peek(4)     # => " str"
      s.peek(4)     # => " str"

[[m:StringScanner#peep]] は将来のバージョンでは削除される予定です。
代わりに [[m:StringScanner#peek]] を使ってください。

--- pointer
--- pos
#@todo
現在のスキャンポインタのインデックスを返します。

      s = StringScanner.new('test string')
      s.pos         # => 0
      s.scan(/\w+/) # => "test"
      s.pos         # => 4
      s.scan(/\w+/) # => nil
      s.pos         # => 4
      s.scan(/\s+/) # => " "
      s.pos         # => 5

--- pointer=(n)
--- pos=(n)
#@todo
スキャンポインタのインデックスを n にセットします。

n は整数で、バイト単位で指定します。
マッチ対象の文字列の長さを超える値を指定すると例外 RangeError が発生します。
負数を指定すると文字列の末尾からのオフセットとして扱います。

n を返します。

      s = StringScanner.new('test string')
      s.scan(/\w+/) # => "test"
      s.pos = 1     # => 1
      s.scan(/\w+/) # => "est"
      s.pos = 7     # => 7
      s.scan(/\w+/) # => "ring"
      s.pos = 20    # RangeError: index out of range
      s.pos = -4    # => -4
      s.scan(/\w+/) # => "ring"

#@if (version <= "1.8.0")
このメソッドはマッチ記録を捨てます。
#@end

--- post_match
#@todo
前回マッチを行った文字列のうち、マッチしたところよりも後ろの
部分文字列を返します。前回のマッチが失敗していると常に nil を
返します。

      s = StringScanner.new('test string')
      s.post_match  # => nil
      s.scan(/\w+/) # => "test"
      s.post_match  # => " string"
      s.scan(/\w+/) # => nil
      s.post_match  # => nil
      s.scan(/\s+/) # => " "
      s.post_match  # => "string"
      s.scan(/\w+/) # => "string"
      s.post_match  # => ""
      s.scan(/\w+/) # => nil
      s.post_match  # => nil

--- pre_match
#@todo
前回マッチを行った文字列のうち、マッチしたところよりも前の
部分文字列を返します。前回のマッチが失敗していると常に nil を
返します。

      s = StringScanner.new('test string')
      s.pre_match   # => nil
      s.scan(/\w+/) # => "test"
      s.pre_match   # => ""
      s.scan(/\w+/) # => nil
      s.pre_match   # => nil
      s.scan(/\s+/) # => " "
      s.pre_match   # => "test"
      s.scan(/\w+/) # => "string"
      s.pre_match   # => "test "
      s.scan(/\w+/) # => nil
      s.pre_match   # => nil

--- reset
#@todo
スキャンポインタを文字列の先頭 (インデックス 0) に戻し、
マッチ記録を捨てます。

self を返します。

pos = 0と同じ動作です。

      s = StringScanner.new('test string')
      s.scan(/\w+/) # => "test"
      s.matched     # => "test"
      s.pos         # => 4
      s[0]          # => "test"
      s.reset
      s.matched     # => nil
      s[0]          # => nil
      s.pos         # => 0

--- rest
#@todo
文字列の残り (rest) を返します。
具体的には、スキャンポインタが指す位置からの文字列を返します。
スキャンポインタが文字列の末尾を指していたら空文字列 ("") を返します。

      s = StringScanner.new('test string')
      s.rest         # => "test string"
      s.scan(/\w+/)  # => "test"
      s.rest         # => " string"
      s.scan(/\s+/)  # => " "
      s.rest         # => "string"
      s.scan(/\w+/)  # => "string"
      s.rest         # => ""

--- rest?
#@todo
文字列が残っているならば trueを、
残っていないならば false を返します。

[[m:StringScanner#eos?]] と逆の結果を返します。

      s = StringScanner.new('test string')
      s.eos?        # => false
      s.rest?       # => true
      s.scan(/\w+/)
      s.scan(/\s+/)
      s.scan(/\w+/)
      s.eos?        # => true
      s.rest?       # => false

[[m:StringScanner#rest?]] は将来のバージョンで削除される予定です。
代わりに [[m:StringScanner#eos?]] を使ってください。

--- rest_size
--- restsize
#@todo
文字列の残りの長さを返します。
stringscanner.rest.size と同じです。

      s = StringScanner.new('test string')
      s.rest_size # => 11
      s.rest.size # => 11

[[m:StringScanner#restsize]] は将来のバージョンで削除される予定です。
代わりに[[m:StringScanner#rest_size]] を使ってください。

--- scan(regexp)
#@todo
スキャンポインタの地点だけで regexp と文字列のマッチを試します。
マッチしたら、スキャンポインタを進めて正規表現にマッチした
部分文字列を返します。マッチしなかったら nil を返します。

        s = StringScanner.new('test string')
        p s.scan(/\w+/)   #=> "test"
        p s.scan(/\w+/)   #=> nil
        p s.scan(/\s+/)   #=> " "
        p s.scan(/\w+/)   #=> "string"
        p s.scan(/./)     #=> nil

--- scan_full(regexp, s, f)
#@todo
スキャンポインタの位置から regexp と文字列のマッチを試します。
マッチに成功すると、s と f の値によって以下のように動作します。

    * s が true ならばスキャンポインタを進めます。
    * s が false ならばスキャンポインタを進めません。
    * f が true ならばマッチした部分文字列を返します。
    * f が false ならばマッチした部分文字列の長さを返します。

マッチに失敗すると s や f に関係なく nil を返します。

このメソッドは s と f の組み合わせにより、
他のメソッドと同等の動作になります。

    * scan_full(regexp, true, true) は [[m:StringScanner#scan]] と同等。
    * scan_full(regexp, true, false) は [[m:StringScanner#skip]] と同等。
    * scan_full(regexp, false, true) は [[m:StringScanner#check]] と同等。
    * scan_full(regexp, false, false) は [[m:StringScanner#match]] と同等。

--- scan_until(regexp)
#@todo
regexp が一致するまで文字列をスキャンします。
マッチに成功したらスキャンポインタを進めて、
スキャン開始位置からマッチ部分の末尾までの部分文字列を返します。
マッチに失敗したら nil を返します。

      s = StringScanner.new('test string')
      s.scan_until(/str/) # => "test str"
      s.matched           # => "str"
      s.pos               # => 8
      s.pre_match         # => "test "

--- search_full(regexp, s, f)
#@todo
regexp が一致するまで文字列をスキャンします。
マッチに成功すると、s と f の値によって以下のように動作します。

    * s が true ならばスキャンポインタを進めます。
    * s が false ならばスキャンポインタを進めません。
    * f が true ならばマッチした部分文字列を返します。
    * f が false ならばマッチした部分文字列の長さを返します。

マッチに失敗すると s や f に関係なく nil を返します。

このメソッドは s と f の組み合わせにより、
他のメソッドと同等の動作になります。

    * search_full(regexp, true, true) は [[m:StringScanner#scan_until]] と同等。
    * search_full(regexp, true, false) は [[m:StringScanner#skip_until]] と同等。
    * search_full(regexp, false, true) は [[m:StringScanner#check_until]] と同等。
    * search_full(regexp, false, false) は [[m:StringScanner#exist?]] と同等。

--- skip(regexp) -> Fixnum | nil
#@todo
スキャンポインタの地点だけで regexp と文字列のマッチを試します。
マッチしたらスキャンポインタを進めマッチした部分文字列の
長さを返します。マッチしなかったら nil を返します。

@param regexp マッチに使用する正規表現を指定します。

        s = StringScanner.new('test string')
        p s.skip(/\w+/)   #=> 4
        p s.skip(/\w+/)   #=> nil
        p s.skip(/\s+/)   #=> 1
        p s.skip(/\w+/)   #=> 6
        p s.skip(/./)     #=> nil

--- skip_until(regexp)
#@todo
regexp が一致するまで文字列をスキャンします。
マッチに成功したらスキャンポインタを進めて、
スキャン開始位置からマッチ部分の末尾までの部分文字列の長さを返します。
マッチに失敗したら nil を返します。

      s = StringScanner.new('test string')
      s.scan_until(/str/) # => 8
      s.matched           # => "str"
      s.pos               # => 8
      s.pre_match         # => "test "

--- string
#@todo
スキャン対象にしている文字列を返します。

      s = StringScanner.new('test string')
      s.string # => "test string"

#@if (version <= "1.8.0")
#@#Ruby 1.8.0 では
返り値は freeze されています。

      s = StringScanner.new('test string')
      s.string.frozen? # => true
#@else
#@#Ruby 1.8.1 以降では
返り値は freeze されていません。

      s = StringScanner.new('test string')
      s.string.frozen? # => false
#@end

なお、このメソッドは StringScanner.new に渡した
文字列をそのまま返しますが、この仕様が将来に渡って保証されるわけではありません。
この仕様に依存したコードを書かないようにしましょう。

      str = 'test string'
      s = StringScanner.new(str)
      s.string == str    # => true
      s.string.eql?(str) # => true (将来は false になる可能性がある)

また、返り値の文字列に対して破壊的な変更もできますが、
この操作がスキャン対象の文字列を変更することも保証されません。
この仕様に依存したコードを書かないでください。

      str = 'test string'
      s = StringScanner.new(str)
      s.string.replace("0123")
      s.scan(/\w+/)     # => "0123" (将来は "test" が返る可能性あり)
      str               # => "0123" (将来は "test string" が返る可能性あり)

--- string=(str)
#@todo
スキャン対象の文字列を str に変更して、マッチ記録を捨てます。
str を返します。

      str = '0123'
      s = StringScanner.new('test string')
      s.string = str     # => "0123"
      s.scan(/\w+/)      # => "0123"

--- terminate
--- clear
#@todo
スキャンポインタを文字列末尾後まで進め、マッチ記録を捨てます。

self を返します。

pos = self.string.size と同じ動作です。

      s = StringScanner.new('test string')
      s.scan(/\w+/) # => "test"
      s.matched     # => "test"
      s.pos         # => 4
      s[0]          # => "test"
      s.terminate
      s.matched     # => nil
      s[0]          # => nil
      s.pos         # => 11

[[m:StringScanner#clear]] は将来のバージョンで削除される予定です。
代わりに [[m:StringScanner#terminate]] を使ってください。

--- unscan
#@todo
スキャンポインタを前回のマッチの前の位置に戻します。

      s = StringScanner.new('test string')
      s.scan(/\w+/) # => "test"
      s.unscan
      s.scan(/\w+/) # => "test"

このメソッドでポインタを戻せるのは 1 回分だけです。
2 回分以上戻そうとしたときは例外 StringScanner::Error が発生します。
また、まだマッチを一度も行っていないときや、
前回のマッチが失敗していたときも例外 StringScanner::Error が発生します。

      s = StringScanner.new('test string')
      s.unscan      # StringScanner::Error: can't unscan: prev match had failed
      s.scan(/\w+/) # => "test"
      s.unscan
      s.unscan      # StringScanner::Error: can't unscan: prev match had failed
      s.scan(/\w+/) # => "test"
      s.scan(/\w+/) # => nil
      s.unscan      # StringScanner::Error: can't unscan: prev match had failed

selfを返します。

#@# bc-rdoc: detected missing name: matchedsize
--- matchedsize
#@todo

Equivalent to #matched_size. This method is obsolete; use #matched_size
instead.


== Constants

--- Version
#@todo
StringScannerクラスのバージョンを文字列で返します。
この文字列はfreezeされています。

      StringScanner::Version           # => "0.7.0"
      StringScanner::Version.frozen?   # => true

#@end
