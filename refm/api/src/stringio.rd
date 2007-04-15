文字列に [[c:IO]] と同じインタフェースを持たせるためのライブラリです。

= class StringIO < Data

文字列に [[c:IO]] と同じインタフェースを持たせるためのクラスです。

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
--- open(string = '', mode = 'r+') {|io| ... }    -> StringIO
#@todo

StringIO オブジェクトを生成して返します。

与えられた string がフリーズされている場合には、mode はデフォルトでは読み取りのみに設定されます。

ブロックを与えた場合は StringIO オブジェクトを引数としてブロックを評価します。

@param string 生成される StringIO のデータを文字列で指定します。この文字列はバッファとして使われます。[[m:StringIO#write]] などによって、string 自身も書き換えられます。

@param mode [[m:Kernel#open]] 同様文字列か整数で指定します。

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

@raise Errno::EACCES string がフリーズされていて、mode が書き込み可能に設定されている場合に発生します。

== Instance Methods

--- string    -> String
#@todo
自身が表している文字列を返します。

--- string=(buf)
#@todo
自身が表している文字列を buf に変更します。
自身は読み書き両用になります。
buf がフリーズされている場合には、読み取り専用になります。
pos と lineno は 0 にセットされます。

#@if (version < "1.8.3")
buf が nil の場合は、StringIO への読み書きは禁止されます。
#@end

@param buf 自身が新たに表す文字列を与えます。

#@if (version >= "1.8.3")
@raise TypeError buf が nil の場合に発生します。
#@end

--- <<(obj)    -> self
#@todo
obj を pos の位置に書き込みます。 必要なら obj.to_s を呼んで
文字列に変換します。 self を返します。

@param obj 自身に書き込みたい、文字列か to_s が定義されたオブジェクトを与えます。

--- binmode    -> self

何もせずに self を返します。

--- close      -> nil
#@todo
自身を close します。以後、自身に対する読み書きが禁止されます。
close された StringIO に読み書き等が行われると IOError が発生します。

@raise IOError 自身がすでに close されていた時に発生します。

--- close_read    -> nil
#@todo
自身に対する読み取りを禁止します。

@raise IOError 自身がすでに読みとり不可だった場合に発生します。

--- close_write    -> nil
#@todo
自身に対する書き込みを禁止します。

@raise IOError 自身がすでに書き込み不可だった場合に発生します。

--- closed?    -> bool
#@todo
自身が既に close されていた場合に ture を返します。そうでない場合は、false を返します。

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

--- each(sep_string = $/){|line| ... }       -> self
--- each_line(sep_string = $/){|line| ... }  -> self
#@todo
自身から 1 行ずつ読み込み、それを引数として与えられたブロックを実行します。

詳しい仕様は [[m:IO#each]] を参照して下さい。

@param sep_string 行の区切りを文字列で指定します。

@raise IOError 自身が読み取り不可なら発生します。

--- each_byte{|ch| ... }    -> self
#@todo
自身から 1 バイトずつ読み込み、整数 ch に変換し、それを引数として与えられたブロックを実行します。

@raise IOError 自身が読み取り不可なら発生します。

--- eof    -> bool
--- eof?   -> bool
#@todo
自身の pos が文字列の終端にあれば true を返します。そうでないなら false を返します。

--- fcntl    -> ()

例外 [[c:NotImplementedError]] が発生します。

--- fileno    -> nil

何もせず nil を返します。

--- flush    -> self

何もせずに self を返します。

--- fsync    -> 0

何もせずに 0 を返します。

--- getc    -> Integer | nil
#@todo
自身から 1 文字読み込んで、その文字に対応する Fixnum を返します。
EOF に到達した時には nil を返します。 

@raise IOError 自身が読み取り不可なら発生します。

--- gets(sep_string = $/)    -> String | nil
#@todo
自身から 1 行読み込んで、その文字列を返します。EOF に到達した時には nil を返します。
詳しい仕様は [[m:IO#gets]] を参照して下さい。[[m:$_]] に読み込んだ行がセットされます。

@param sep_string 行の区切りを文字列で指定します。

--- isatty    -> false

何もせず false を返します。

--- lineno    -> Integer
#@todo
現在の行番号を返します。これは [[m:StringIO#gets]] が呼ばれた回数です。

--- lineno=(n)
#@todo
現在の行番号を n にセットします。

@param n 行番号を整数で指定します。

--- path    -> nil

StringIO には対応するパスはないので nil を返します。

--- pid    -> nil

何もせず nil を返します。

--- pos    -> Integer
--- tell   -> Integer

自身の現在の位置を返します。

--- pos=(n)
#@todo
自身の位置を n に移動します。自身が表す文字列のサイズより大きくても構いません。

@param n 自身の位置を整数で指定します。

@raise Errno::EINVAL n がマイナスである場合に発生します。

--- print()        -> nil
--- print(*obj)    -> nil
#@todo
自身に引数を順に出力します。引数を省略した場合は、 $_ を出力します。
引数の扱いは [[m:Kernel#print]] を参照して下さい。

@param obj 書き込みたいオブジェクトを与えます。

--- printf(format, *obj)    -> nil
#@todo
format に従い引数 *obj を文字列に変換して、自身に出力します。
詳しい仕様は[[m:Kernel#printf]]を参照して下さい。

@param format 文字列のフォーマットを指定します。[[m:Kernel#format]]を参照して下さい。

@param obj 書き込みたいオブジェクトを与えます。

--- putc(ch)    -> object
#@todo
文字 ch を自身に書き込みます。 ch が数字なら 0 〜 255 の範囲の対応する文字書き込みます。 
ch が文字列なら、その先頭の文字を書き込みます。ch を返します。

@param ch 書き込みたい文字を、整数か文字列で与えます。ch が Float や Rational であっても、整数に変換されてから書き込まれます。

--- puts(*obj)    -> nil
#@todo
obj と改行を順番に自身に出力します。引数がなければ改行のみを出力します。
詳しい仕様は [[m:Kernel#puts]] を参照して下さい。

@param obj 書き込みたいオブジェクトを与えます。

--- read                  -> String
--- read(len)             -> String | nil
--- read(len, outbuf)     -> String
#@todo

自身から len バイト読み込みんで返します。len が省略された場合は、最後まで読み込んで返します。
詳しい仕様は [[m:IO#read]] を参照して下さい。

@param len 読み込みたい長さを整数で指定します。

@param outbuf 読み込んだ文字列を出力するバッファを文字列で与えます。

--- readchar    -> Integer
#@todo
自身から 1 文字読み込んで、その文字に対応する整数を返します。EOF に到達した時には例外 EOFError を発生させます。

@raise EOFError EOF に到達した時に発生します。

--- readline(sep_string = $/)    -> String
#@todo
自身から 1 行読み込んで、その文字列を返します。EOF に到達した時には、例外 EOFError を発生させます。
詳しい仕様は [[m:IO#readline]] を参照して下さい。

@param sep_string 行の区切りを文字列で指定します。

@raise EOFError EOF に到達した時に発生します。

--- readlines(sep_string = $/)    -> [String]
#@todo
自身からデータを全て読み込んで、その各行を要素としてもつ配列を返します。 
既に EOF に達していれば [] を返します。 
詳しい仕様は [[m:IO#readlines]] を参照して下さい。

@param sep_string 行の区切りを文字列で指定します。

#@since 1.9.0
--- readpartial([integer [, buffer]])
#@todo
[[m:IO#readpartial]] と同様です。
#@end

--- reopen    
#@todo
例外 [[c:NotImplementedError]] が発生します。

@raise NotImplementedError 常に発生します。

--- rewind    -> 0
#@todo
自身の pos と lineno をそれぞれ 0 にします。

--- seek(offset, whence = IO::SEEK_SET)
#@todo

自身の pos を whence の位置から offset バイトだけ移動させます。 whence の値は以下のいずれかです。

 * IO::SEEK_SET: ファイルの先頭から (デフォルト)
 * IO::SEEK_CUR: 現在のファイルポインタから
 * IO::SEEK_END: ファイルの末尾から

@param offset 移動させたいバイト数を整数で与えます。

@raise Errno::EINVAL offset + whence がマイナスである場合に発生します。

@raise ArgumentError whence が上の SEEK_SET, SEEK_CUR, SEEK_END 以外だった場合に発生します。

--- size    -> Integer
--- length  -> Integer
#@todo
文字列の長さを返します。

--- sync    -> true
#@todo
何もせずに true を返します。

--- sync=(bool)
#@todo
何もせずに bool を返します。

@param bool true か flase を与えます。

--- sysread                  -> String
--- sysread(len)             -> String
--- sysread(len, outbuf)     -> String
#@todo
[[m:StringIO#read]] と同じです。ただし、EOF に達した場合、EOFError を投げます。

@param len 読み込みたい長さを整数で指定します。

@param outbuf 読み込んだ文字列を出力するバッファを文字列で与えます。

@raise EOFError EOF に達した場合に発生します。

--- syswrite(obj)    -> Integer
#@todo
[[m:StringIO#write]] と同じです。

@param obj 書き込みたいオブジェクトを与えます。

--- truncate(len)    -> Integer
#@todo
自身のサイズが len になるように、自身を切り詰め、もしくは拡大します。
拡大した場合は、その部分を 0 で埋めます。
len を返します。

@param len 変更したいサイズを整数で与えます。

@raise IOError 自身が書き込み可能でない時に発生します。

@raise Errno::EINVAL len がマイナスの時に発生します。

--- tty?    -> false
#@todo
何もせず false を返します。

--- ungetc(ch)    -> nil
#@todo
ch を自身に書き戻します。
pos が自身のサイズよりも大きい場合は、自身をリサイズしてから、ch を書き戻します。

何回でも書き戻すことが可能です。また現在位置が 0 である場合は何も行いません。

nil を返します。

@param ch 書き戻したい文字を整数で与えます。

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
#@todo
自身に obj を出力します。obj が文字列でなければ to_s による文字列化を試みます。
書き込まれた文字列の長さを返します。

全ての出力メソッドは、最終的に「write」という名のメソッドを呼び出すので、
このメソッドを置き換えることで出力関数の挙動を変更することができます。

@param obj 書き込みたいオブジェクトを与えます。

@raise IOError 自身が書き込み可能でない時に発生します。
