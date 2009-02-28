パス名をオブジェクト指向らしく扱うためのライブラリです。

#@since 1.8.5
= reopen Kernel

== Private Instance Methods

--- Pathname(path) -> Pathname
文字列 path を元に Pathname オブジェクトを生成します。

Pathname.new(string) と同じです。

#@end



= class Pathname < Object

パス名クラス

== Constants

#@since 1.8.5
--- SEPARATOR_PAT
パス名のなかのディレクトリを区切る部分にマッチする正規表現です。

--- TO_PATH
内部的に使っている定数です。利用者が使うことはありません。

#@end

== Class Methods

--- new(path) -> Pathname
文字列 path を元に Pathname オブジェクトを生成します。

--- getwd -> Pathname
--- pwd   -> Pathname
カレントディレクトリを元に Pathname オブジェクトを生成します。
Pathname.new(Dir.getwd) と同じです。

--- glob(pattern, flags=0) -> [Pathname]
--- glob(pattern, flags=0) {|pathname| ...} -> nil

ワイルドカードの展開を行なった結果を、
Pathname オブジェクトの配列として返します。

引数の意味は、[[m:Dir.glob]] と同じです。 flag の初期値である 0 は「何
も指定しない」ことを意味します。

ブロックが与えられたときは、ワイルドカードにマッチした Pathname オブジェ
クトを1つずつ引数としてそのブロックに与えて実行させます。この場合、値と
しては nil を返します。

@param pattern ワイルドカードパターンです
@param flag    パターンマッチ時のふるまいを変化させるフラグを指定します

== Instance Methods

--- ==(other)   -> bool
--- ===(other)  -> bool
--- eql?(other) -> bool

パス名を比較し、 other と同じなら真を返します。大文字小文字は区別されます。
other は Pathname オブジェクトでなければなりません。

パス名の比較は単純にパス文字列の比較によって行われるので、論理的に
同じパスでもパス文字列が違えば異なると判断されます。

    require 'pathname'

    p Pathname.new("foo/bar") == Pathname.new("foo/bar")
    p Pathname.new("foo/bar") == Pathname.new("foo//bar")
    p Pathname.new("foo/../foo/bar") == Pathname.new("foo/bar")

    # => true
         false
         false

--- <=>(other) -> bool

パス名を比較します。other と同じなら 0 を、ASCII順で self が大きい場合
は正、other が大きい場合は負を返します。大文字小文字は区別されます。
other は Pathname オブジェクトでなければなりません。

パス名の比較は単純にパス文字列の比較によって行われるので、論理的に
同じパスでもパス文字列が違えば異なると判断されます。

    require 'pathname'

    p Pathname.new("foo/bar") <=> Pathname.new("foo/bar")
    p Pathname.new("foo/bar") <=> Pathname.new("foo//bar")
    p Pathname.new("foo/../foo/bar") <=> Pathname.new("foo/bar")
    => 0
       1
       -1

--- hash -> Fixnum
ハッシュ値を返します。

--- to_s   -> String
--- to_str -> String
パス名を文字列で返します。

to_str は、[[m:File.open]] などの引数にそのまま Pathname オブジェクトを
渡せるようにするために用意されています。

    require 'pathname'

    path = Pathname.new("/tmp/hogehoge")
    File.open(path)

--- cleanpath(consider_symlink = false) -> Pathname
余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返します。

    require "pathname"
    path = Pathname.new("//.././../")
    p path                  # => #<Pathname://.././../>
    p path.cleanpath        # => #<Pathname:/>

consider_symlink が真ならパス要素にシンボリックリンクがあった場合
にも問題ないように .. を残します。

cleanpath は、実際にファイルシステムを参照することなく、文字列操作
だけで処理を行います。

    require 'pathname'

    Dir.rmdir("/tmp/foo")      rescue nil
    File.unlink("/tmp/bar/foo") rescue nil
    Dir.rmdir("/tmp/bar")      rescue nil

    Dir.mkdir("/tmp/foo")
    Dir.mkdir("/tmp/bar")
    File.symlink("../foo", "/tmp/bar/foo")
    path = Pathname.new("bar/././//foo/../bar")

    Dir.chdir("/tmp")

    p path.cleanpath
    p path.cleanpath(true)

    => ruby 1.8.0 (2003-10-10) [i586-linux]
       #<Pathname:bar/bar>
       #<Pathname:bar/foo/../bar>

--- realpath -> Pathname
#@until 1.9.2
--- realpath(force_absolute = true) -> Pathname
#@end
余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返します。

また、ファイルシステムをアクセスし、実際に存在するパスを返します。
シンボリックリンクも解決されます。

self が指すパスが存在しない場合は例外 [[c:Errno::ENOENT]] が発生します。

#@until 1.9.2
@param force_absolute 真の場合、絶対パスを返します。 self が相対パスであれば、カレントディレクトリからの相対パスとして解釈されます。
                      古い挙動は obsolete です。引数は省略すべきです。
#@end

    require 'pathname'

    Dir.rmdir("/tmp/foo")      rescue nil
    File.unlink("/tmp/bar/foo") rescue nil
    Dir.rmdir("/tmp/bar")      rescue nil

    Dir.mkdir("/tmp/foo")
    Dir.mkdir("/tmp/bar")
    File.symlink("../foo", "/tmp/bar/foo")
    path = Pathname.new("bar/././//foo/../bar")

    Dir.chdir("/tmp")

    p path.realpath
#@until 1.9.2
    p path.realpath(false)
#@end

    => ruby 1.8.0 (2003-10-10) [i586-linux]
       #<Pathname:/tmp/bar>
#@until 1.9.2
       #<Pathname:bar>
#@end

--- parent -> Pathname
self の親ディレクトリを指す新しい Pathname オブジェクトを返します。

--- mountpoint? -> bool
self がマウントポイントであれば真を返します。

--- root? -> bool
self がルートディレクトリであれば真を返します。判断は文字列操作によっ
て行われ、ファイルシステムはアクセスされません。

--- absolute? -> bool
self が絶対パス指定であれば真を返します。

--- relative? -> bool
self が相対パス指定であれば真を返す。

--- each_filename {|v| ... } -> nil
self のパス名要素毎にブロックを実行します。

    require 'pathname'

    Pathname.new("/foo/../bar").each_filename {|v| p v}

    # => "foo"
         ".."
         "bar"

--- +(other) -> Pathname
パス名を連結します。つまり、other を self からの相対パスとした新しい
Pathname オブジェクトを生成して返します。

other が絶対パスなら単に other と同じ内容の Pathname オブジェクトが返さ
れます。

@param other 文字列か Pathname オブジェクトを指定します。

#@since 1.8.1

--- children -> [Pathname]
self 配下にあるパス名(Pathnameオブジェクト)の配列を返します。

    require 'pathname'

    p Pathname.new("/tmp").children
    => ruby 1.8.0 (2003-10-10) [i586-linux]
       [#<Pathname:.X11-unix>, #<Pathname:.iroha_unix>, ... ]

ただし、 ".", ".." は要素に含まれません。

self が存在しないパスであったりディレクトリでなければ例外
[[c:Errno::EXXX]] が発生します。

#@end

#@since 1.8.1

--- relative_path_from(base_directory) -> Pathname
base_direcoty から self への相対パスを求め、その内容の新しい Pathname
オブジェクトを生成して返します。

パス名の解決は文字列操作によって行われ、ファイルシステムをアクセス
しません。

    require 'pathname'

    path = Pathname.new("/tmp/foo")
    base = Pathname.new("/tmp")

    p path.relative_path_from(base)

    # => ruby 1.8.0 (2003-10-10) [i586-linux]
         #<Pathname:foo>

self が相対パスなら base_directory も相対パス、self が絶対パスなら
base_directory も絶対パスでなければなりません。

base_directory は Pathname オブジェクトでなければなりません。

#@end

#@since 1.8.1

--- each_line(*args, &block)
IO.foreach(self.to_s, *args, &block) と同じです。

@see [[m:IO.foreach]]
#@end

#@until 1.9.2
--- foreachline(*args, &block)
IO.foreach(self.to_s, *args, &block) と同じです。

#@since 1.8.1
このメソッドは obsolete です。
代わりに [[m:Pathname#each_line]] を使ってください。
#@end

@see [[m:IO.foreach]]
#@end
--- read(*args)
IO.read(self.to_s, *args)と同じです。

@see [[m:IO.read]]

--- readlines(*args)
IO.readlines(self.to_s, *args)と同じです。

@see [[m:IO.readlines]]

--- sysopen(*args)
IO.sysopen(self.to_s, *args)と同じです。

@see [[m:IO.sysopen]]

#@since 1.8.1
--- make_link(old)
File.link(old, self.to_s) と同じです。

@see [[m:File.link]]

--- make_symlink(old)
File.symlink(old, self.to_s) と同じです。

@see [[m:File.symlink]]
#@end

--- atime
File.atime(self.to_s) を渡したものと同じです。

@see [[m:File.atime]]

--- ctime
File.ctime(self.to_s) を渡したものと同じです。

@see [[m:File.ctime]]
--- mtime
File.mtime(self.to_s) を渡したものと同じです。

@see [[m:File.mtime]]

--- chmod(mode)
File.chmod(mode, self.to_s) と同じです。

@see [[m:File.chmod]]

--- lchmod(mode)
File.lchmod(mode, self.to_s) と同じです。

@see [[m:File.lchmod]]

--- chown(owner, group)
File.chown(owner, group, self.to_s) と同じです。

@see [[m:File.chown]]

--- lchown(owner, group)
File.lchown(owner, group, self.to_s) と同じです。

@see [[m:File.lchown]]

--- fnmatch(pattern, *args)
File.fnmatch(pattern, self.to_s, *args) と同じです。

@see [[m:File.fnmatch]]

--- fnmatch?(pattern, *args)
File.fnmatch?(pattern, self.to_s, *args) と同じです。

@see [[m:File.fnmatch?]]

--- ftype
File.ftype(self.to_s) と同じです。

@see [[m:File.ftype]]

#@until 1.9.2
--- link(old)
File.link(old, self.to_s) と同じです。

@see [[m:File.link]]

レシーバと引数がシステムコールの引数と逆順に対応していて紛らわしいため、
このメソッドは obsolete です。
代わりに [[m:Pathname#make_link]] を使ってください。
#@end

--- open(*args, &block)
File.open(self.to_s, *args, &block) と同じです。

@see [[m:File.open]]

--- readlink
Pathname.new(File.readlink(self.to_s)) と同じです。

@see [[m:File.readlink]]

--- rename(to)
File.rename(self.to_s, to) と同じです。

@see [[m:File.rename]]

--- stat
File.stat(self.to_s) と同じです。

@see [[m:File.stat]]

--- lstat
File.lstat(self.to_s) と同じです。

@see [[m:File.lstat]]

#@until 1.9.2
--- symlink(old)
File.symlink(old, self.to_s) と同じです。

@see [[m:File.symlink]]

レシーバと引数がシステムコールの引数と逆順に対応していて紛らわしいため、
このメソッドは obsolete です。
代わりに [[m:Pathname#make_symlink]] を使ってください。
#@end

--- truncate(length)
File.truncate(self.to_s, length) と同じです。

@see [[m:File.truncate]]

--- utime(atime, mtime)
File.utime(atime, mtime, self.to_s) と同じです。

@see [[m:File.utime]]

--- basename(*args)
Pathname.new(File.basename(self.to_s, *args)) と同じです。

@see [[m:File.basename]]

--- dirname
Pathname.new(File.dirname(self.to_s)) と同じです。

@see [[m:File.dirname]]

--- extname
File.extname(self.to_s) と同じです。

@see [[m:File.extname]]

--- expand_path(*args)
Pathname.new(File.expand_path(self.to_s, *args)) と同じです。

@see [[m:File.expand_path]]

--- join(*args)
Pathname.new(File.join(self.to_s, *args)) と同じです。

@see [[m:File.join]]

--- split
File.split(self.to_s) と同じです。

@see [[m:File.split]]

--- blockdev?
FileTest.blockdev?(self.to_s) と同じです。

@see [[m:FileTest.#blockdev?]]

--- chardev?
FileTest.chardev?(self.to_s) と同じです。

@see [[m:FileTest.#chardev?]]

--- executable?
FileTest.executable?(self.to_s) と同じです。

@see [[m:FileTest.#executable?]]

--- executable_real?
FileTest.executable_real?(self.to_s) と同じです。

@see [[m:FileTest.#executable_real?]]

--- exist?
FileTest.exist?(self.to_s) と同じです。

@see [[m:FileTest.#exist?]]

--- grpowned?
FileTest.grpowned?(self.to_s) と同じです。

@see [[m:FileTest.#grpowned?]]

--- directory?
FileTest.directory?(self.to_s) と同じです。

@see [[m:FileTest.#directory?]]

--- file?
FileTest.file?(self.to_s) と同じです。

@see [[m:FileTest.#file?]]

--- pipe?
FileTest.pipe?(self.to_s) と同じです。

@see [[m:FileTest.#pipe?]]

--- socket?
FileTest.socket?(self.to_s) と同じです。

@see [[m:FileTest.#socket?]]

--- owned?
FileTest.owned?(self.to_s) と同じです。

@see [[m:FileTest.#owned?]]

--- readable?
FileTest.readable?(self.to_s) と同じです。

@see [[m:FileTest.#readable?]]

--- readable_real?
FileTest.readable_real?(self.to_s) と同じです。

@see [[m:FileTest.#readable_real?]]

--- setuid?
FileTest.setuid?(self.to_s) と同じです。

@see [[m:FileTest.#setuid?]]

--- setgid?
FileTest.setgid?(self.to_s) と同じです。

@see [[m:FileTest.#setgid?]]

--- size
FileTest.size(self.to_s) と同じです。

@see [[m:FileTest.#size]]

--- size?
FileTest.size?(self.to_s) と同じです。

@see [[m:FileTest.#size?]]

--- sticky?
FileTest.sticky?(self.to_s) と同じです。

@see [[m:FileTest.#sticky?]]

--- symlink?
FileTest.symlink?(self.to_s) と同じです。

@see [[m:FileTest.#symlink?]]

#@since 1.8.5

--- world_readable?
FileTest.world_readable?(self.to_s) と同じです。

@see [[m:FileTest.#world_readable?]]

--- world_writable?
FileTest.world_writable?(self.to_s) と同じです。

@see [[m:FileTest.#world_writable?]]

#@end

--- writable?
FileTest.writable?(self.to_s) と同じです。

@see [[m:FileTest.#writable?]]

--- writable_real?
FileTest.writable_real?(self.to_s) と同じです。

@see [[m:FileTest.#writable_real?]]

--- zero?
FileTest.zero?(self.to_s) と同じです。

@see [[m:FileTest.#zero?]]

#@until 1.9.2
--- chdir(&block)
Dir.chdir(self.to_s, &block) と同じです。

@see [[m:Dir.chdir]]

#@since 1.8.1
このメソッドは obsolete です。
代わりに [[m:Dir.chdir]] を使ってください。
#@end
--- chroot
Dir.chroot(self.to_s) と同じです。

@see [[m:Dir.chroot]]

#@since 1.8.1
このメソッドは obsolete です。
代わりに [[m:Dir.chroot]] を使ってください。
#@end
#@end
--- rmdir
Dir.rmdir(self.to_s) と同じです。

@see [[m:Dir.rmdir]]

--- entries
Dir.entries(self.to_s) と同じです。

@see [[m:Dir.entries]]

#@since 1.8.1

--- each_entry {|pathname| ... }
Dir.foreach(self.to_s) {|f| yield Pathname.new(f) } と同じです。

@see [[m:Dir.foreach]]

#@end

#@until 1.9.2
--- dir_foreach {|pathname| ... }
Dir.foreach(self.to_s) {|f| yield Pathname.new(f) } と同じです。

@see [[m:Dir.foreach]]

#@since 1.8.1
このメソッドは obsolete です。
代わりに [[m:Pathname#each_entry]] メソッドを使ってください。
#@end
#@end
--- mkdir(*args)
Dir.mkdir(self.to_s, *args) と同じです。

@see [[m:Dir.mkdir]]

--- opendir(&block)
Dir.open(self.to_s, &block) と同じです。

@see [[m:Dir.open]]

--- find {|pathname| ...}
self 配下のすべてのファイルやディレクトリを
一つずつ引数 pathname に渡してブロックを実行します。

  require 'find'
  Find.find(self.to_s) {|f| yield Pathname.new(f)}

と同じです。

@see [[m:Find.#find]]

--- mkpath
FileUtils.mkpath(self.to_s) と同じです。

@see [[m:FileUtils.#mkpath]]

--- rmtree
FileUtils.rm_r(self.to_s) と同じです。

@see [[m:FileUtils.#rm_r]]

--- unlink
--- delete
self が指すディレクトリあるいはファイルを削除します。

#@since 1.8.5

--- ascend { |pathname| ... }
self のパス名から親方向に辿っていったときの各パス名を新しい Pathname オ
ブジェクトとして生成し、ブロックへの引数として渡して実行します。

  Pathname.new('/path/to/some/file.rb').ascend {|v| p v}
     #<Pathname:/path/to/some/file.rb>
     #<Pathname:/path/to/some>
     #<Pathname:/path/to>
     #<Pathname:/path>
     #<Pathname:/>

  Pathname.new('path/to/some/file.rb').ascend {|v| p v}
     #<Pathname:path/to/some/file.rb>
     #<Pathname:path/to/some>
     #<Pathname:path/to>
     #<Pathname:path>

ファイルシステムにはアクセスしません。

#@end

#@since 1.8.5
--- descend { |pathname| ... }
self のパス名の親から子供へと辿っていったときの各パス名を新しい
Pathname オブジェクトとして生成し、ブロックへの引数として渡して実行しま
す。

  Pathname.new('/path/to/some/file.rb').descend {|v| p v}
     #<Pathname:/>
     #<Pathname:/path>
     #<Pathname:/path/to>
     #<Pathname:/path/to/some>
     #<Pathname:/path/to/some/file.rb>
  
  Pathname.new('path/to/some/file.rb').descend {|v| p v}
     #<Pathname:path>
     #<Pathname:path/to>
     #<Pathname:path/to/some>
     #<Pathname:path/to/some/file.rb>

ファイルシステムにはアクセスしません。

#@end

#@if(version <= "1.8.1")

--- cleanpath_aggressive
cleanpath(false) と同じです。 1.8.2 以降より private メソッドとなり、利用できなくなりました。 cleanpath を利用してください。

--- cleanpath_conservative
cleanpath(true) と同じです。 1.8.2 以降より private メソッドとなり、利用できなくなりました。 cleanpath を利用してください。

#@end

--- foreach(*args, &block)
self の指し示すパスがディレクトリなら
Dir.foreach(self.to_s, *args, &block) と、さもなければ
IO.foreach(self.to_s, *args, &block) と同じです。

#@since 1.8.1
このメソッドは obsolete です。 each_line か each_entry を使ってください。
#@end


#@if(version <= "1.8.0")
--- realpath_rec
realpath メソッドの実質的な処理を行っているメソッドです。利用するべきで
はありません。

#@end


#@since 1.8.5
--- sub(pattern, replace)  -> Pathname
--- sub(pattern) {|matched| ... } -> Pathname

self を表現するパス文字列に対して sub メソッドを呼び出し、その結果を内
容とする新しい Pathname オブジェクトを生成し、返します。 cf. [[m:String#sub]]

#@end

#@since 1.9.1
--- to_path
File.open などの引数に渡す際に呼ばれるメソッドです。 Pathname オブジェ
クトにおいては、 to_s と同じです。

#@end

