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

@param mode [[m:Kernel#open]]同様文字列か整数で指定します。

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

自身に対する読み取りが禁止されているなら true を返します。

--- closed_write?    -> bool

自身に対する書き込みが禁止されているなら true を返します。

--- each(sep_string = $/){|line| ... }       -> self
--- each_line(sep_string = $/){|line| ... }  -> self
#@todo
自身から 1 行ずつ読み込み、それを引数として与えられたブロックを実行します。

細かい仕様は [[m:IO#each]] を参照して下さい。

@raise IOError 自身が読み取り不可なら発生します。

--- each_byte{|byte| ... }    -> self
#@todo
自身から 1 バイトずつ読み込み、整数に変換し、それを引数として与えられたブロックを実行します。

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

--- gets(sep_string = $/)    -> String
#@todo
一行読み込んで、その文字列を返します。EOF に到達した時には nil を返します。
詳しい仕様は [[m:IO#gets]] を参照して下さい。[[m:$_]] に読み込んだ行がセットされます。

--- isatty    -> false

何もせず false を返します。

--- lineno    -> Integer
#@todo
現在の行番号を返します。これは [[m:StringIO#gets]] が呼ばれた回数です。

--- lineno=(n)
#@todo
現在の行番号を n にセットします。

--- path    -> nil

StringIOには対応するパスはないので nil を返します。

--- pid    -> nil

何もせず nil を返します。

--- pos    -> Integer
--- tell   -> Integer

自身の現在の位置を返します。

--- pos=(n)
#@todo
自身の位置を n に移動します。自身が表す文字列のサイズより大きくても構いません。

@raise Errno::EINVAL n がマイナスである場合に発生します。

--- print()        -> nil
--- print(*obj)    -> nil
#@todo
自身に引数を順に出力します。引数を省略した場合は、 $_ を出力します。
引数の扱いは [[m:Kernel#print]] を参照して下さい。

--- printf(format, *obj)    -> nil
#@todo
format に従い引数 *obj を文字列に変換して、自身に出力します。
詳しい仕様は[[m:Kernel#printf]]を参照して下さい。

--- putc(obj)
#@todo
[[m:IO#putc]] と同様です。与えられた obj を返します。

--- puts(obj, ...)
#@todo
[[m:IO#puts]] と同様です。

--- read([integer [, buffer]])
#@todo
[[m:IO#read]] と同様です。

--- readchar
#@todo
[[m:IO#readchar]] と同様です。

--- readline(sep_string = $/)
#@todo
[[m:IO#readline]] と同様です。

--- readlines(sep_string = $/)
#@todo
[[m:IO#readlines]] と同様です。

#@since 1.9.0
--- readpartial([integer [, buffer]])
#@todo
[[m:IO#readpartial]] と同様です。
#@end

--- reopen
#@todo
例外 [[c:NotImplementedError]] が発生します。

--- rewind
#@todo
[[m:IO#rewind]] と同様です。

--- seek(n, whence)
#@todo
[[m:IO#seek]] と同様です。

--- size
--- length
#@todo
文字列の長さを返します。

--- sync
#@todo
何もせずに 0 を返します。

--- sync=(bool)
#@todo
何もせずに bool を返します。

--- sysread([integer [, buffer]])
#@todo
[[m:StringIO#read]] と同じです。

--- syswrite(obj)
#@todo
[[m:StringIO#write]] と同じです。

--- truncate(n)
#@todo
n が self.size より小さい場合にはバッファのサイズを n に切り詰めます。
n が self.size より大きい場合にはバッファのサイズを n に拡大します。

--- tty?
#@todo
何もせず false を返します。

--- ungetc(c)
#@todo
c は Fixnum です。
pos を 1 減らしてからキャラクターコードが c の文字を書き込みます。
#@#この時posは 1 増えません。
pos が size よりも大きい場合は、リサイズして新しく加えられたバッファを 0 で
埋めてから pos を 1 減らしてキャラクターコードが c の文字を書き込みます。
#@#この時も pos は 1 増えません。
nil を返します。

      s = StringIO.new("hoge")
      s.pos = 1
      s.ungetc(0x48)
      p s.string   #=> "Hoge"
      p s.pos        #=> 0

      s = StringIO.new("hoge")
      s.pos = 8
      s.ungetc(0x41)
      p s.string   #=> "hoge\000\000\000A"
      p s.pos        #=> 7

--- write(obj)
#@todo
[[m:IO#write]] と同様です。書き込まれた文字列の長さを返します。
