= class StringIO < Data

[[c:IO]] と同じインタフェースを持った文字列クラスです。


=== 例外
StringIO オブジェクトは大抵の場合 IO オブジェクトと同じ例外を発生させます。
例えば次の例では write は IOError を発生させます。

  require "stringio"
  sio = StringIO.new("hoge")
  sio.close
  sio.write("a")
  # => in `write': not opened for writing (IOError)

== Class Methods

--- new(string = '', mode = 'r+')
--- open(string = '', mode = 'r+')
--- open(string = '', mode = 'r+') {|io| ... }
#@todo

StringIO オブジェクトを生成します。mode はデフォルトでは読み書き可能に
設定されます。与えられた string がフリーズされている場合には、
mode はデフォルトでは読み取りのみに設定されます。

ブロックを与えた場合は StringIO オブジェクトを引数としてブロックを評価します。

        require 'stringio'

        io = StringIO.new("foo")
        p io.getc       # => 102
        p io.pos        # => 1
        p io.size       # => 3
        io << "bar"
        p io.size       # => 4
        io.rewind
        p io.gets       # => "fbar"

        StringIO.open("hoge"){|io|
          p io.string   # => "hoge"
        }

== Instance Methods

--- string
#@todo
IOバッファ(文字列)を返します。

--- string=(buf)
#@todo
IOバッファを buf に変更し、buf を返します。これ以前の
バッファは捨てられます。StringIO は読み書き両用になります。
buf がフリーズされている場合には、読み取り専用になります。
pos と lineno は 0 にセットされます。

#@if (version >= "1.8.3")
ruby 1.8.3 からは 
buf が nil の場合には、例外 TypeError が発生します。
#@else
ruby 1.8.2 まで: 
buf が nil の場合は、StringIO への読み書きは禁止されます。
#@end


--- <<(obj)
#@todo
[[m:IO#<<]] と同様です。obj を pos の位置に書き込みます。 必要なら obj.to_s を呼んで
文字列に変換します。 self を返します。

--- binmode
#@todo
何もせずに self を返します。

--- close
#@todo
close します。[[m:IO#close]] と同じように読み書きが禁止されます。

--- close_read
#@todo
[[m:IO#close_read]] と同様です。読み取りを禁止します。

--- close_write
#@todo
[[m:IO#close_write]] と同様です。書き込みが禁止されます。

--- closed?
#@todo
[[m:IO#closed?]] と同様です。

      sio = StringIO.open("hoge")
      p sio.closed? # => false
      sio.close_read
      p sio.closed? # => false
      sio.close_write
      sio.closed?   # => true

--- closed_read?
#@todo
読み取りが禁止されているなら true を返します。

--- closed_write?
#@todo
書き込みが禁止されているなら true を返します。

--- each(sep_string=$/){|line| ... }
--- each_line(sep_string=$/){|line| ... }
#@todo
[[m:IO#each]] と同様です。

--- each_byte{|byte| ... }
#@todo
[[m:IO#each_byte]] と同様です。

--- eof
--- eof?
#@todo
pos が文字列の終端にあれば true を返します。

--- fcntl
#@todo

例外 [[c:NotImplementedError]] が発生します。

--- fileno
#@todo
何もせず nil を返します。

--- flush
#@todo
何もせずに self を返します。

--- fsync
#@todo
何もせずに 0 を返します。

--- getc
#@todo
[[m:IO#getc]] と同様です。

--- gets(sep_string = $/)
#@todo
[[m:IO#gets]] と同様です。[[m:$_]] に読み込んだ行がセットされます。

--- isatty
#@todo
何もせず false を返します。

--- lineno
#@todo
[[m:IO#lineno]] と同様です。

--- lineno=()
#@todo
[[m:IO#lineno=]] と同様です。

--- path
#@todo
StringIOには対応するパスはないので nil を返します。

--- pid
#@todo
何もせず nil を返します。

--- pos
--- tell
#@todo
[[m:IO#pos]] と同様です。

--- pos=(n)
#@todo
[[m:IO#pos=]] と同様です。

--- print([obj, ...])
#@todo
[[m:IO#print]] と同様です。

--- printf(format_string [, obj, ...] )
#@todo
[[m:IO#printf]] と同様です。

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
