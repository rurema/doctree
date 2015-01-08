category Text

文字列に [[c:IO]] と同じインタフェースを持たせるためのライブラリです。

= class StringIO < Data

文字列に [[c:IO]] と同じインタフェースを持たせるためのクラスです。

例:

  require "stringio"
  sio = StringIO.new("hoge", 'r+')
  p sio.read                 #=> "hoge"
  sio.rewind
  p sio.read(1)              #=> "h"
  sio.write("OGE")
  sio.rewind
  p sio.read                 #=> "hOGE"

=== 例外
StringIO オブジェクトは大抵の場合 IO オブジェクトと同じ例外を発生させます。
例えば次の例では write は IOError を発生させます。

  require "stringio"
  sio = StringIO.new("hoge")
  sio.close
  sio.write("a")
  # => in `write': not opened for writing (IOError)

== Class Methods

--- new(string = '', mode = 'r+')                 -> StringIO
--- open(string = '', mode = 'r+')                -> StringIO
--- open(string = '', mode = 'r+') {|io| ... }    -> object

StringIO オブジェクトを生成して返します。

与えられた string がフリーズされている場合には、mode はデフォルトでは読み取りのみに設定されます。
ブロックを与えた場合は生成した StringIO オブジェクトを引数としてブロックを評価してその結果を返します。

@param string 生成される StringIO のデータを文字列で指定します。
              この文字列はバッファとして使われます。[[m:StringIO#write]] などによって、
              string 自身も書き換えられます。

@param mode [[m:Kernel.#open]] 同様文字列か整数で指定します。

@raise Errno::EACCES string がフリーズされていて、mode が書き込み可能に設定されている場合に発生します。

        require 'stringio'
         
        s = "foo"
        io = StringIO.new(s)
        p io.getc       # => 102
        p io.pos        # => 1
        p io.size       # => 3
        io << "bar"   
        p io.size       # => 4
        p s             # => "fbar"
        io.rewind
        p io.gets       # => "fbar"

        StringIO.open("hoge"){|io|
          p io.string   # => "hoge"
        }

== Instance Methods

--- string    -> String

自身が表す文字列を返します。

返されるのは生成時に与えられたバッファとして使われている文字列です。
文字列は複製されないことに注意して下さい。

例:

  sio = StringIO.new
  sio << "abc"
  s = sio.string
  p s                    #=> "abc"
  sio << "xyz"
  p s                    #=> "abcxyz"

--- string=(buf)

自身が表す文字列を指定された buf に変更します。

buf はバッファとして使われ、書き込みメソッドによって書き換えられます。
自身は読み書き両用になりますが、
buf がフリーズされている場合には読み取り専用になります。
pos と lineno は 0 にセットされます。

#@if (version < "1.8.3")
buf が nil の場合は、StringIO への読み書きは禁止されます。
#@end

@param buf 自身が新たに表す文字列を指定します。

#@if (version >= "1.8.3")
@raise TypeError buf が nil の場合に発生します。
#@end

--- <<(obj)    -> self

obj を pos の位置に書き込みます。 必要なら obj.to_s を呼んで
文字列に変換します。 self を返します。

@param obj 自身に書き込みたい、文字列か to_s が定義されたオブジェクトを指定します。

--- binmode    -> self

何もせずに self を返します。

--- close      -> nil

自身を close します。以後、自身に対する読み書きが禁止されます。
close された StringIO に読み書き等が行われると IOError が発生します。

@raise IOError 自身がすでに close されていた時に発生します。

--- close_read    -> nil

自身に対する読み取りを禁止します。

@raise IOError 自身がすでに読み取り不可だった場合に発生します。

--- close_write    -> nil

自身に対する書き込みを禁止します。

@raise IOError 自身がすでに書き込み不可だった場合に発生します。

--- closed?    -> bool

自身が既に close されていた場合に true を返します。そうでない場合は、false を返します。

      sio = StringIO.open("hoge")
      p sio.closed? # => false
      sio.close_read
      p sio.closed? # => false
      sio.close_write
      sio.closed?   # => true

--- closed_read?    -> bool

自身に対する読み取りが禁止されているなら true を返します。そうでない場合は、false を返します。

--- closed_write?    -> bool

自身に対する書き込みが禁止されているなら true を返します。そうでない場合は、false を返します。

--- each(rs = $/){|line| ... }       -> self
--- each_line(rs = $/){|line| ... }  -> self
#@since 1.8.7
--- lines(rs = $/){|line| ... }      -> self
#@since 1.9.1
--- each(rs = $/)       -> Enumerator
--- each_line(rs = $/)  -> Enumerator
--- lines(rs = $/)      -> Enumerator
#@else
--- each(rs = $/)       -> Enumerable::Enumerator
--- each_line(rs = $/)  -> Enumerable::Enumerator
--- lines(rs = $/)      -> Enumerable::Enumerator
#@end
#@end

自身から 1 行ずつ読み込み、それを引数として与えられたブロックを実行します。

@param rs 行の区切りを文字列で指定します。rs に nil を指定すると行区切りなしとみなします。空文字列 "" を指定すると連続する改行を行の区切りとみなします(パラグラフモード)。

@raise IOError 自身が読み取り不可なら発生します。

  a = StringIO.new("hoge\nfoo\n")
  a.each{|l| p l }
  
  #=>
  "hoge\n"
  "foo\n"

@see [[m:$/]]

--- each_byte{|ch| ... }    -> self
#@since 1.8.7
--- bytes{|ch| ... }        -> self
#@since 1.9.1
--- each_byte -> Enumerator
--- bytes     -> Enumerator
#@else
--- each_byte -> Enumerable::Enumerator
--- bytes     -> Enumerable::Enumerator
#@end
#@end

自身から 1 バイトずつ読み込み、整数 ch に変換し、それを引数として与えられたブロックを実行します。

@raise IOError 自身が読み取り不可なら発生します。

  a = StringIO.new("hoge")
  a.each_byte{|ch| p ch }
  
  #=>
  104
  111
  103
  101

--- eof    -> bool
--- eof?   -> bool

自身の pos が文字列の終端にあれば true を返します。そうでないなら false を返します。

--- fcntl    -> ()

例外 [[c:NotImplementedError]] が常に発生します。

--- fileno    -> nil

何もせず nil を返します。

--- flush    -> self

何もせずに self を返します。

--- fsync    -> 0

何もせずに 0 を返します。

--- getc    -> Integer | nil
#@since 1.8.7
--- getbyte -> Integer | nil
#@end

自身から 1 文字読み込んで、その文字に対応する Fixnum を返します。
文字列の終端に到達した時には nil を返します。 

@raise IOError 自身が読み取り不可なら発生します。

  a = StringIO.new("ho")
  a.getc                   #=> 104
  a.getc                   #=> 111
  a.getc                   #=> nil

--- gets(rs = $/)    -> String | nil

自身から 1 行読み込んで、その文字列を返します。文字列の終端に到達した時には nil を返します。
[[m:$_]] に読み込んだ行がセットされます。

@param rs 行の区切りを文字列で指定します。rs に nil を指定すると行区切りなしとみなします。空文字列 "" を指定すると連続する改行を行の区切りとみなします(パラグラフモード)。

@raise IOError 自身が読み込み用にオープンされていなければ発生します。

  a = StringIO.new("hoge")
  a.gets                  #=> "hoge"
  $_                      #=> "hoge"
  a.gets                  #=> nil
  $_                      #=> nil

@see [[m:$/]]

--- isatty    -> false

何もせず false を返します。

--- lineno    -> Integer

現在の行番号を返します。これは [[m:StringIO#gets]] が呼ばれた回数です。

--- lineno=(n)

現在の行番号を n にセットします。

@param n 行番号を整数で指定します。

#@until 1.9.2
--- path    -> nil

StringIO には対応するパスはないので nil を返します。

#@end
--- pid    -> nil

何もせず nil を返します。

--- pos    -> Integer
--- tell   -> Integer

自身の現在の位置を返します。

--- pos=(n)

自身の位置を n に移動します。自身が表す文字列のサイズより大きくても構いません。

@param n 自身の位置を整数で指定します。

@raise Errno::EINVAL n がマイナスである場合に発生します。

  a = StringIO.new("hoge", 'r+')
  a.pos = 10
  a << 'Z'
  a.string                        #=> "hoge\000\000\000\000\000\000Z"

--- print()        -> nil
--- print(*obj)    -> nil

自身に引数を順に出力します。引数を省略した場合は、[[m:$_]] を出力します。
引数の扱いは [[m:Kernel.#print]] を参照して下さい。

@param obj 書き込みたいオブジェクトを指定します。

@raise IOError 自身が書き込み用にオープンされていなければ発生します。

  a = StringIO.new("", 'r+')
  a.print("hoge", "bar", "foo")
  a.string                     #=> "hogebarfoo"

--- printf(format, *obj)    -> nil

指定されたフォーマットに従い各引数 obj を文字列に変換して、自身に出力します。

@param format 文字列のフォーマットを指定します。[[m:Kernel.#format]] を参照して下さい。

@param obj 書き込みたいオブジェクトを指定します。

@raise IOError 自身が書き込み用にオープンされていなければ発生します。

  a = StringIO.new("", 'r+')
  a.printf("%c%c%c", 97, 98, 99)
  a.string                      #=> "abc"

--- putc(ch)    -> object

文字 ch を自身に書き込みます。 ch が数字なら 0 〜 255 の範囲の対応する文字書き込みます。 
ch が文字列なら、その先頭の文字を書き込みます。ch を返します。

@param ch 書き込みたい文字を、整数か文字列で指定します。ch が Float や Rational であっても、整数に変換されてから書き込まれます。

@raise IOError 自身が書き込み用にオープンされていなければ発生します。

--- puts(*obj)    -> nil

obj と改行を順番に自身に出力します。引数がなければ改行のみを出力します。
詳しい仕様は [[m:Kernel.#puts]] を参照して下さい。

@param obj 書き込みたいオブジェクトを指定します。

@raise IOError 自身が書き込み用にオープンされていなければ発生します。

  a = StringIO.new("", 'r+')
  a.puts("hoge", "bar", "foo")
  a.string                     #=> "hoge\nbar\nfoo\n"

--- read                  -> String
--- read(len)             -> String | nil
--- read(len, outbuf)     -> String

自身から len バイト読み込んで返します。len が省略された場合は、最後まで読み込んで返します。
詳しい仕様は [[m:IO#read]] を参照して下さい。

@param len 読み込みたい長さを整数で指定します。詳しい仕様は [[m:IO#read]] を参照して下さい。

@param outbuf 読み込んだ文字列を出力するバッファを文字列で指定します。指定した文字列オブジェクトが
              あらかじめ length 長の領域であれば、余計なメモリの割当てが行われません。指定した文字列の
              長さが length と異なる場合、その文字列は一旦 length 長に拡張(あるいは縮小)されたあと、
              実際に読み込んだデータのサイズになります。[[m:IO#read]] と同じです。

@raise IOError 自身が読み込み用にオープンされていなければ発生します。

--- readchar    -> Integer
#@since 1.8.7
--- readbyte    -> Integer
#@end

自身から 1 文字読み込んで、その文字に対応する整数を返します。

文字列の終端に到達した時には例外 [[c:EOFError]] を発生させます。

 a = StringIO.new("hoge")
 a.readchar               #=> 104

@raise EOFError 文字列の終端に到達した時に発生します。

--- readline(rs = $/)    -> String

自身から 1 行読み込んで、その文字列を返します。

文字列の終端に到達した時には、例外 EOFError を発生させます。
[[m:IO#readline]] と違い読み込んだ文字列を変数 [[m:$_]] にセットしません。

@param rs 行の区切りを文字列で指定します。rs に nil を指定すると行区切りなしとみなします。空文字列 "" を指定すると連続する改行を行の区切りとみなします(パラグラフモード)。

@raise EOFError 文字列の終端に到達した時に発生します。

@raise IOError 自身が読み込み用にオープンされていなければ発生します。

  a = StringIO.new("hoge\nfoo\nbar\n")
  a.readline                           #=> "hoge\n"
  a.readline(nil)                      #=> "foo\nbar\n"
  a.readline                           #=> EOFError が発生する

@see [[m:$/]]

--- readlines(rs = $/)    -> [String]

自身からデータを全て読み込んで、その各行を要素としてもつ配列を返します。 
既に文字列の終端に達していれば空配列 [] を返します。 

@param rs 行の区切りを文字列で指定します。rs に nil を指定すると行区切りなしとみなします。空文字列 "" を指定すると連続する改行を行の区切りとみなします(パラグラフモード)。

@raise IOError 自身が読み込み用にオープンされていなければ発生します。

  a = StringIO.new("hoge\nfoo\nbar\n")
  a.readlines                          #=> ["hoge\n", "foo\n", "bar\n"]
  a.readlines                          #=> []

@see [[m:$/]]

--- reopen(sio)           -> StringIO

自身が表す文字列が指定された StringIO と同じものになります。

@param sio 自身が表したい StringIO を指定します。

例: 

  require 'stringio'
  sio = StringIO.new("hoge", 'r+')
  sio2 = StringIO.new("foo", 'r+')
  sio.reopen(sio2)
  p sio.read                       #=> "foo"

--- reopen(str, mode = 'r+')     -> StringIO

自身が表す文字列が指定された文字列 str になります。

与えられた str がフリーズされている場合には、mode はデフォルトでは読み取りのみに設定されます。
ブロックを与えた場合は生成した StringIO オブジェクトを引数としてブロックを評価します。

@param str 自身が表したい文字列を指定します。
           この文字列はバッファとして使われます。[[m:StringIO#write]] などによって、
           str 自身も書き換えられます。

@param mode [[m:Kernel.#open]] 同様文字列か整数で自身のモードを指定します。

@raise Errno::EACCES str がフリーズされていて、mode が書き込み可能に設定されている場合に発生します。

例: 

  require 'stringio'
  sio = StringIO.new("hoge", 'r+')
  sio.reopen('foo')
  p sio.read                      #=> "foo"

--- rewind    -> 0

自身の pos と lineno をそれぞれ 0 にします。

--- seek(offset, whence = IO::SEEK_SET) -> 0

自身の pos を whence の位置から offset バイトだけ移動させます。 

@param offset 移動させたいバイト数を整数で指定します。

@param whence 以下のいずれかの定数を指定します。

 * IO::SEEK_SET: ファイルの先頭から (デフォルト)
 * IO::SEEK_CUR: 現在のファイルポインタから
 * IO::SEEK_END: ファイルの末尾から

@raise Errno::EINVAL offset + whence がマイナスである場合に発生します。

@raise ArgumentError whence が上の SEEK_SET, SEEK_CUR, SEEK_END 以外だった場合に発生します。

--- size    -> Integer
--- length  -> Integer

文字列の長さを返します。

--- sync    -> true

何もせずに true を返します。

--- sync=(bool)

何もせずに bool を返します。

@param bool true か false を指定します。

--- sysread                  -> String
--- sysread(len)             -> String
--- sysread(len, outbuf)     -> String
#@since 1.9.1
--- readpartial               -> String
--- readpartial(len)          -> String
--- readpartial(len, outbuf)  -> String
#@end
#@since 1.9.2
--- read_nonblock(maxlen, outbuf = "") -> String
#@end

自身から len バイト読み込んで返します。
[[m:StringIO#read]] と同じです。ただし、文字列の終端に達した場合、EOFError を投げます。

@param len 読み込みたい長さを整数で指定します。[[m:StringIO#read]] と同じです。

@param outbuf 読み込んだ文字列を出力するバッファを文字列で指定します。指定した文字列オブジェクトが
              あらかじめ length 長の領域であれば、余計なメモリの割当てが行われません。指定した文字列の
              長さが length と異なる場合、その文字列は一旦 length 長に拡張(あるいは縮小)されたあと、
              実際に読み込んだデータのサイズになります。[[m:IO#read]] と同じです。

@raise EOFError 文字列の終端に達した場合に発生します。

--- syswrite(obj)    -> Integer
#@since 1.9.2
--- write_nonblock(obj) -> Integer
#@end

自身に obj を書き込みます。[[m:StringIO#write]] と同じです。

@param obj 書き込みたいオブジェクトを指定します。

@raise IOError 自身が書き込み用にオープンされていなければ発生します。

--- truncate(len)    -> Integer

自身のサイズが len になるように、自身を切り詰め、もしくは拡大します。
拡大した場合は、その部分を 0 で埋めます。
len を返します。

@param len 変更したいサイズを整数で指定します。

@raise IOError 自身が書き込み可能でない時に発生します。

@raise Errno::EINVAL len がマイナスの時に発生します。

  a = StringIO.new("hoge", 'r+')
  a.truncate(2)
  a.string                       #=> "ho"
  a.truncate(5)
  a.string                       #=> "ho\000\000\000"

--- tty?    -> false

何もせず false を返します。

--- ungetc(ch)    -> nil

整数で指定された文字 ch を自身に書き戻します。
nil を返します。

何回でも書き戻すことが可能です。
現在位置が自身のサイズよりも大きい場合は、自身をリサイズしてから、ch を書き戻します。
また現在位置が 0 である場合は何も行いません。

@param ch 書き戻したい文字を整数で指定します。

@raise IOError 自身が読み込み可能でない時に発生します。

      s = StringIO.new("hoge")
      s.pos = 1
      s.ungetc(?H)
      p s.string   #=> "Hoge"
      p s.pos        #=> 0

      s = StringIO.new("hoge")
      s.pos = 8
      s.ungetc(?A)
      p s.string   #=> "hoge\000\000\000A"
      p s.pos        #=> 7

--- write(obj)    -> Integer

自身に obj を書き込みます。obj が文字列でなければ to_s による文字列化を試みます。
書き込まれた文字列の長さを返します。

全ての出力メソッドは、最終的に「write」という名のメソッドを呼び出すので、
このメソッドを置き換えることで出力関数の挙動を変更することができます。

@param obj 書き込みたいオブジェクトを指定します。

@raise IOError 自身が書き込み可能でない時に発生します。

  a = StringIO.new("hoge", 'r+')
  a.write("aaa")                 #=> 3
  a.string                       #=> "aaae"

#@since 1.8.7

--- each_char{|c| ... } -> self
--- chars{|c| ... }     -> self
#@since 1.9.1
--- each_char           -> Enumerator
--- chars               -> Enumerator
#@else
--- each_char           -> Enumerable::Enumerator
--- chars               -> Enumerable::Enumerator
#@end
自身に含まれる文字を一文字ずつブロックに渡して評価します。

自身は読み込み用にオープンされていなければなりません。

#@until 1.9.1
また、マルチバイト文字列を使用する場合は [[m:$KCODE]] を適切に設定してください。
#@end

@raise IOError 自身が読み込み用にオープンされていない場合に発生します。

@see [[m:IO#each_char]]

#@end
#@since 1.9.1
--- ungetbyte(char) -> nil

指定された char を読み戻します。

2バイト以上の読み戻しは保証されません。

@param char 読み戻したい1文字かそのコードポイントを指定します。

@see [[m:IO#ungetbyte]]

#@since 1.9.3
--- set_encoding(ext_enc)               -> self
--- set_encoding(ext_enc, int_enc)      -> self
--- set_encoding(ext_enc, int_enc, opt) -> self
#@else
--- set_encoding(ext_enc) -> self
#@end

自身のエンコーディングを指定されたエンコーディングに設定します。

@param ext_enc エンコーディングを指定します。
#@since 1.9.3
               nil を指定した場合は [[m:Encoding.default_external]] が
               使われます。

@param int_enc 無視されます。[[c:IO]] クラスの API との互換性のために用
               意されています。

@param opt 無視されます。[[c:IO]] クラスの API との互換性のために用意さ
           れています。
#@end

--- external_encoding -> Encoding

現在の外部エンコーディングを返します。

--- internal_encoding -> Encoding

現在の内部エンコーディングを返します。

#@since 1.9.2
--- codepoints{|codepoint| ... } -> self
--- codepoints -> Enumerator
--- each_codepoint{|codepoint| ... } -> self
--- each_codepoint -> Enumerator

自身の各コードポイントに対して繰り返します。

@see [[m:IO#each_codepoint]]

#@end
#@end
