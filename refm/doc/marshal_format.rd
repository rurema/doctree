= Marshal フォーマット

フォーマットバージョン 4.8 を元に記述しています。

=== nil, true, false

それぞれ、'0', 'T', 'F' になります。

#@samplecode
p Marshal.dump(nil).unpack1("x2 a*")   # => "0"
p Marshal.dump(true).unpack1("x2 a*")  # => "T"
p Marshal.dump(false).unpack1("x2 a*") # => "F"
#@end

Ruby 2.1 以前では、インスタンス変数を設定しても dump されません。
Ruby 2.2 以降は freeze されているので、インスタンス変数は設定できません。

=== Fixnum

'i' に続けて Fixnum を表すデータ構造が続きます。

数値部分を表す形式(これは Fixnum に限らず他の箇所でも使われます)は、
2種類の形式があります。

==== 形式 1

数値 n に対して

//emlist{
n == 0:       0
0 < n < 123:  n + 5
-124 < n < 0: n - 5
//}

という数値(1 byte)を格納します。5 を足したり引いたりするのは下記の
形式 2 との区別のためです。

#@samplecode 例
p Marshal.dump(-1).unpack1("x2 a*") # => "i\xFA"
p Marshal.dump(0).unpack1("x2 a*")  # => "i\x00"
p Marshal.dump(1).unpack1("x2 a*")  # => "i\x06"
p Marshal.dump(2).unpack1("x2 a*")  # => "i\a"   ("i\x07")
#@end

形式 1 の範囲を超える数値 N に対しては、以下の形式になります。

==== 形式 2

//emlist{
| len | n_1 | n_2 | n_3 | n_4 |
<-1->  <-       len         ->
byte            bytes
//}

len の値は -4 〜 -1, 1 〜 4 で。符号と後続のデータが n1 〜 n_len
まであることを示します。

#@samplecode
def foo(len, n1, n2 = 0, n3 = 0, n4 = 0)
    case len
    when -3;           n4 = 255
    when -2;      n3 = n4 = 255
    when -1; n2 = n3 = n4 = 255
    end

    n = (0xffffff00 | n1) &
        (0xffff00ff | n2 * 0x100) &
        (0xff00ffff | n3 * 0x10000) &
        (0x00ffffff | n4 * 0x1000000)
    # p "%x" % n
    n = -((n ^ 0xffff_ffff) + 1) if len < 0
    n
end

p Marshal.dump(-125).unpack("x2 acC*") # => ["i", -1, 131]
p foo(-1, 131)                         # => -125
p Marshal.dump(-255).unpack("x2 acC*") # => ["i", -1, 1]
p foo(-1, 1)                           # => -255
p Marshal.dump(-256).unpack("x2 acC*") # => ["i", -1, 0]
p foo(-1, 0)                           # => -256
p Marshal.dump(-257).unpack("x2 acC*") # => ["i", -2, 255, 254]
p foo(-2, 255, 254)                    # => -257
p Marshal.dump(124).unpack("x2 acC*")  # => ["i", 1, 124]
p foo(1, 124)                          # => 124
p Marshal.dump(256).unpack("x2 acC*")  # => ["i", 2, 0, 1]
p foo(2, 0, 1)                         # => 256
#@end

Ruby 1.9.3 以前では、インスタンス変数を設定しても dump されません。
Ruby 2.0 以降は freeze されているので、インスタンス変数は設定できません。

=== instance of the user class

==== String, Regexp, Array, Hash のサブクラス (インスタンス変数なし)

'C' で始まるデータ構造になります。

//emlist{
| 'C' | クラス名(Symbol)の dump | 親クラスのインスタンスの dump |
//}

#@samplecode 例 1
class Foo < Array # (or String, Regexp, Hash)
end
p Marshal.dump(Foo.new([nil])).unpack("x2 a a c a3 aca*")
# => ["C", ":", 8, "Foo", "[", 6, "0"]
#                         ^^^ (or '"', '/', '{')
#@end

==== String, Regexp, Array, Hash のサブクラス (インスタンス変数あり)

'I' で始まるデータ構造になります。
[[ref:d:marshal_format#instance_variable]]も参照してください。

#@samplecode 例 2: インスタンス変数あり
class Foo < Array # (or String, Regexp, Hash)
  def initialize(obj)
    @foo = false
    super(obj)
  end
end
p Marshal.dump(Foo.new([true])).unpack("x2 a a a c a3 aca caca4 a")
# => ["I", "C", ":", 8, "Foo", "[", 6, "T", 6, ":", 9, "@foo", "F"]
#@end

==== その他

実装上内部構造が異なるため、上記以外では、'o' になります。
([[ref:d:marshal_format#Object]] 参照)

#@samplecode 例
class Foo
end
p Marshal.dump(Foo.new).unpack("x2 a a c a*")
# => ["o", ":", 8, "Foo\x00"]
#@end

=== 'u'

_dump、_load を定義していれば 'u' になります。
インスタンス変数は dump されなくなるので、_dump/_load で対応する必要があります。

//emlist{
| 'u' | クラス名(Symbol)の dump | _dump の結果の長さ(Fixnum形式) | _dump が返す値 |
//}

#@samplecode
# coding: ascii-8bit
class Foo
  def self._load
  end
  def _dump(obj)
    "hogehoge"
  end
end
p Marshal.dump(Foo.new).unpack("x2 a aca3 c a*")
# => ["u", ":", 8, "Foo", 13, "hogehoge"]
#@end

=== 'U'

marshal_dump、marshal_load を定義していれば 'U' になります。
インスタンス変数は dump されなくなるので、marshal_dump/marshal_load
で対応する必要があります。

//emlist{
| 'U' | クラス名(Symbol)の dump | marshal_dump メソッドの戻り値の dump |
//}

#@samplecode
# coding: ascii-8bit
class Foo
  def marshal_dump
    "hogehoge"
  end
  def marshal_load(obj)
  end
end
p Marshal.dump(Foo.new).unpack("x2 a aca3 a c a*")

# => ["U", ":", 8, "Foo", "\"", 13, "hogehoge"]
#@end

===[a:Object] Object

'o' で始まるデータ構造になります。

//emlist{
| 'o' | クラス名(Symbol)のdump | インスタンス変数の数(Fixnum形式) |
| インスタンス変数名(Symbol)のdump(1) | 値(1) |
          :
          :
| インスタンス変数名(Symbol)のdump(n) | 値(n) |
//}

#@samplecode 例 1
p Marshal.dump(Object.new).unpack("x2 a a c a6 c")
# => ["o", ":", 11, "Object", 0]
#@end

#@samplecode 例 2: インスタンス変数あり
class Foo
  def initialize
    @foo = :bar
    @one = 1
  end
end
p Marshal.dump(Foo.new).unpack("x2 a a c a3 c aca4 aca3 aca4 ac")
# => ["o", ":", 8, "Foo", 7,
#     ":", 9, "@foo", ":", 8, "bar",
#     ":", 9, "@one", "i", 6]
#@end

=== Float

'f' で始まるデータ構造になります。

//emlist{
 | 'f' | 数値列の長さ(Fixnum形式) | "%.16g" の文字列 |
//}

#@samplecode
p Marshal.dump(Math::PI).unpack("x2 a c a*")
# => ["f", 22, "3.141592653589793"]

p Marshal.dump(0.0/0).unpack("x2 a c a*")  # => ["f", 8, "nan"]
p Marshal.dump(1.0/0).unpack("x2 a c a*")  # => ["f", 8, "inf"]
p Marshal.dump(-1.0/0).unpack("x2 a c a*") # => ["f", 9, "-inf"]
p Marshal.dump(-0.0).unpack("x2 a c a*")   # => ["f", 9, "-0"]
#@end

==== ruby 1.7 feature

Ruby 1.6 では、nan などの出力は [[man:sprintf(3)]] に依存していて、読み込みは
"nan", "inf", "-inf" 以外は [[man:strtod(3)]] に依存していました。
Ruby 1.7 から、sprintf(3)/strtod(3) への依存はなくなりました。

=== Bignum

'l' で始まるデータ構造になります。

32ビット環境で内部的に Bignum になる Integer は
64ビット環境で Marshal.dump しても、この形式になります。

//emlist{
| 'l' | '+'/'-' | shortの個数(Fixnum形式) | ... |
//}

#@samplecode
p Marshal.dump(2**32).unpack("x2 a a c a*")
# => ["l", "+", 8, "\x00\x00\x00\x00\x01\x00"]
#@end

ruby 1.6.3 では ["l", "+", 8, "\000\000\001\000"] になるバグがありました。

=== String

'"' で始まるデータ構造になります。

//emlist{
| '"' | 長さ(Fixnum形式) | 文字列 |
//}

#@samplecode 例: ascii-8bit の時 (1.8 以前と同じ)
# coding: ascii-8bit
p Marshal.dump("hogehoge").unpack("x2 a c a*")
# => ["\"", 13, "hogehoge"]
#@end

ruby 1.9.0 以降では encoding が 'encoding' という
「@」のつかない内部的なインスタンス変数としてダンプされます。

#@samplecode 例: euc-jp の時
p Marshal.dump("hogehoge".encode("euc-jp")).unpack("x2 a a c a8 c a ca8 aca*")
# => ["I", "\"", 13, "hogehoge", 6, ":", 13, "encoding", "\"", 11, "EUC-JP"]
#@end

ruby 1.9.2 以降では US-ASCII と UTF-8 が 'E' という内部的なインスタンス変数として、
それぞれ false と true という値でダンプされます。

#@samplecode 例: us-ascii の時
# coding: us-ascii
p "hogehoge".encoding # => #<Encoding:US-ASCII>
p Marshal.dump("hogehoge").unpack("x2 a a c a8 c acaa*")
# => ["I", "\"", 13, "hogehoge", 6, ":", 6, "E", "F"]
#@end

#@samplecode 例: utf-8 の時
# coding: utf-8
p "hogehoge".encoding # => #<Encoding:UTF-8>
p Marshal.dump("hogehoge").unpack("x2 a a c a8 c acaa*")
# => ["I", "\"", 13, "hogehoge", 6, ":", 6, "E", "T"]
#@end

=== Regexp

'/' で始まるデータ構造になります。

//emlist{
| '/' | 長さ(Fixnum形式) | ソース文字列 | オプション |
//}

オプションは、[[m:Regexp#options]]の結果 + 漢字コードのフラグ値です。

ruby 1.9 以降では隠しインスタンス変数として String と同様に
encoding が付いています。

#@samplecode 1.9.2 以降での例
p Marshal.dump(/(hoge)*/).unpack("x2 a a c a7 c cacaa")
# => ["I", "/", 12, "(hoge)*", 0, 6, ":", 6, "E", "F"]

p Marshal.dump(/hogehoge/m).unpack("x2 a a c a8 c cacaa")
# => ["I", "/", 13, "hogehoge", 4, 6, ":", 6, "E", "F"]

p Marshal.dump(/hogehoge/e).unpack("x2 a a c a8 c caca8aca*")
# => ["I", "/", 13, "hogehoge", 16, 6, ":", 13, "encoding", "\"", 11, "EUC-JP"]
#@end

=== Array

'[' で始まるデータ構造になります。

//emlist{
| '[' | 要素数(Fixnum形式) | 要素の dump | ... |
//}

#@samplecode 例
p Marshal.dump([true, false, nil]).unpack("x2 a c a a a")
# => ["[", 8, "T", "F", "0"]
#@end

=== Hash

==== Hash without default value

'{' で始まるデータ構造になります。

//emlist{
| '{' | 要素数(Fixnum形式) | キーの dump | 値の dump | ... |
//}

#@samplecode 例
p Marshal.dump({true => false, false => true, nil => nil}).unpack("x2 a c aa aa aa")
# => ["{", 8, "T", "F", "F", "T", "0", "0"]
#@end

==== Hash with default value (not Proc)

'}' で始まるデータ構造になります。

//emlist{
| '}' | 要素数(Fixnum形式) | キーの dump | 値の dump | ... | デフォルト値 |
//}

#@samplecode 例
h = Hash.new(0)
h[10] = 20
p Marshal.dump(h).unpack("x2 a c ac ac ac")
# => ["}", 6, "i", 15, "i", 25, "i", 0]
#@end

==== Hash with default_proc

default_proc が設定されている Hash は dump できません。

#@samplecode
h = Hash.new { }
Marshal.dump(h)
# => TypeError (can't dump hash with default proc)
#@end

=== Struct

構造体クラスのインスタンスのダンプは 'S' で始まるデータ構造になります。

//emlist{
| 'S' | クラス名(Symbol) の dump | メンバの数(Fixnum形式) |
| メンバ名(Symbol) の dump | 値 | ... |
//}

#@samplecode 例
Struct.new("XXX", :foo, :bar)
p Marshal.dump(Struct::XXX.new).unpack("x2 a ac a11 c aca3a aca3a")
# => ["S", ":", 16, "Struct::XXX", 7,
#     ":", 8, "foo", "0",
#     ":", 8, "bar", "0"]
#@end

=== Class/Module (old format)

'M' で始まるデータ構造です。

//emlist{
| 'M' | 長さ(Fixnum形式) | モジュール/クラス名 |
//}

今ではこの形式を dump することはできないので load で例を示しています。

#@samplecode 例
class Mod
end
p Marshal.load([4,7, 'M', 3+5, 'Mod'].pack("ccaca*"))
# => Mod
#@end

===[a:class_module] Class/Module

'c', 'm' で始まるデータ構造です。

//emlist{
| 'c'/'m' | クラス名の長さ(Fixnum 形式) | クラス名 |
//}

#@samplecode 例
class Foo
end
p Marshal.dump(Foo).unpack("x2 a c a*") # => ["c", 8, "Foo"]
#@end

#@samplecode 例 2: クラス/モジュールのインスタンス変数は dump されない
module Bar
  @bar = 1
end
p Bar.instance_eval { @bar } # => 1
File.open('testfile', 'wb') do |f|
  Marshal.dump(Bar, f)
end

# 別プログラム相当にするため remove_const
Object.send :remove_const, :Bar

module Bar
end

p bar = Marshal.load(File.binread('testfile'))
p bar.instance_eval { @bar }
# => nil
#@end

#@samplecode 例 3: クラス変数は dump されない
module Baz
  @@baz = 1
  def self.baz
    @@baz
  end
end
p Baz.baz
# => 1
File.open('testfile', 'wb') do |f|
  Marshal.dump(Baz, f)
end

# 別プログラム相当にするため remove_const
Object.send :remove_const, :Baz

module Baz
  def self.baz
    @@baz
  end
end
p baz = Marshal.load(File.binread('testfile'))
# => Baz
baz.baz
# => uninitialized class variable @@baz in Baz (NameError)
#@end

=== Symbol

':' で始まるデータ構造になります。

//emlist{
| ':' | シンボル名の長さ(Fixnum形式) | シンボル名 |
//}

#@samplecode 例
p Marshal.dump(:foo).unpack("x2 a c a*")
# => [":", 8, "foo"]
#@end

=== Symbol (link)

';' で始まるデータ構造は、対応するシンボル名が既に
dump/load されている場合に使用されます。
番号は内部管理のもので、dump/load 時に Symbol 管理用に
ハッシュテーブルが作られていて、そのレコード位置です。

//emlist{
| ';' | Symbolの実体を指す番号(Fixnum形式) |
//}

#@samplecode 例
p Marshal.dump([:foo, :foo]).unpack("x2 ac aca3 aC*")
# => ["[", 7, ":", 8, "foo", ";", 0]

p Marshal.dump([:foo, :foo, :bar, :bar]).
    unpack("x2 ac aca3 aC aca3 aC*")
# => ["[", 9, ":", 8, "foo", ";", 0, ":", 8, "bar", ";", 6]
#@end

===[a:instance_variable] instance variable

インスタンス変数を持つ Object, Class, Module のインスタンス以外は
'I' で始まるデータ構造になります。

//emlist{
| 'I' | オブジェクトの dump | インスタンス変数の数(Fixnum形式) |
| インスタンス変数名(Symbol) のdump(1) | 値(1) |
          :
          :
| インスタンス変数名(Symbol) のdump(n) | 値(n) |
//}

Object のインスタンスはそれ自身がインスタンス変数を含む構造を持つので
別形式で dump されます。
([[ref:d:marshal_format#Object]] 参照)

この形式は、Array や String のインスタンス用です。

#@samplecode 例
obj = String.new
obj.instance_eval { @foo = :bar }
p Marshal.dump(obj).unpack("x2 a ac c a c a4 aca*")
# => ["I", "\"", 0, 6, ":", 9, "@foo", ":", 8, "bar"]
#@end

クラスやモジュール(Class/Module のインスタンス)は、
インスタンス変数の情報を dump しません。
([[ref:d:marshal_format#class_module]] 参照)

=== link

'@' で始まるデータ構造は、対応するオブジェクトが既に
dump/load されている場合に使用されます。
番号は内部管理のもので、dump/load 時にオブジェクト管理用に
ハッシュテーブルが作られていて、そのレコード位置です。

//emlist{
| '@' | オブジェクトの実体を指す番号(Fixnum形式) |
//}

#@samplecode 例
obj = Object.new
p Marshal.dump([obj, obj]).unpack("x2 ac aaca6c aca*")
# => ["[", 7, "o", ":", 11, "Object", 0, "@", 6, ""]

ary = []
ary.push ary
p Marshal.dump(ary).unpack("x2 acac")
# => ["[", 6, "@", 0]
#@end
