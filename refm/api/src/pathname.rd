category File

パス名をオブジェクト指向らしく扱うためのライブラリです。

= reopen Kernel

== Private Instance Methods

--- Pathname(path) -> Pathname
文字列 path を元に [[c:Pathname]] オブジェクトを生成します。

Pathname.new(path) と同じです。

@param path 文字列、または類似のオブジェクトを与えます。
            実際には to_str に反応するオブジェクトなら何でも構いません。


= class Pathname < Object

パス名をオブジェクト指向らしく扱うクラスです。

Pathname オブジェクトはパス名を表しており、ファイルやディレクトリそのものを表してはいません。
当然、存在しないファイルのパス名も扱えます。

絶対パスも相対パスも扱えます。

Pathname オブジェクトは immutable であり、自身を破壊的に操作するメソッドはありません。

Pathname のインスタンスメソッドには、ディレクトリのパスを返す [[m:Pathname#dirname]] のように、
文字列操作だけで結果を返すものもあれば、ファイルの中身を読み出す [[m:Pathname#read]] のように
ファイルシステムにアクセスするものもあります。

Pathname オブジェクトの生成には、[[m:Pathname.new]] のほかに [[m:Kernel#Pathname]] も使えます。

#@samplecode 例
require 'pathname'

Pathname.new("foo/bar") # => #<Pathname:foo/bar>
Pathname("foo/bar")     # => #<Pathname:foo/bar>
#@end


== Constants

--- SEPARATOR_PAT -> Regexp
パス名のなかのディレクトリを区切る部分にマッチする正規表現です。

この値は環境依存です。

--- TO_PATH -> Symbol
内部的に使っている定数です。利用者が使うことはありません。


== Class Methods

--- new(path) -> Pathname
文字列 path を元に Pathname オブジェクトを生成します。

@param path 文字列、または類似のオブジェクトを与えます。
            実際には to_str に反応するオブジェクトなら何でも構いません。

@raise ArgumentError path が \0 を含んでいると発生します。

#@samplecode 例
require "pathname"

Pathname.new(__FILE__) # => #<Pathname:/path/to/file.rb>
#@end

--- getwd -> Pathname
--- pwd   -> Pathname
カレントディレクトリを元に Pathname オブジェクトを生成します。
Pathname.new(Dir.getwd) と同じです。

#@samplecode 例
require "pathname"

Pathname.getwd #=> #<Pathname:/home/zzak/projects/ruby>
#@end

@see [[m:Dir.getwd]]

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
@param flags   パターンマッチ時のふるまいを変化させるフラグを指定します

#@samplecode
require "pathname"
Pathname.glob("lib/i*.rb") # => [#<Pathname:lib/ipaddr.rb>, #<Pathname:lib/irb.rb>]
#@end

@see [[m:Dir.glob]]
#@since 2.5.0
@see [[m:Pathname#glob]]
#@end

== Instance Methods

--- ==(other)   -> bool
--- ===(other)  -> bool
--- eql?(other) -> bool

パス名を比較し、 other と同じなら真を返します。大文字小文字は区別されます。
other は Pathname オブジェクトでなければなりません。

パス名の比較は単純にパス文字列の比較によって行われるので、論理的に
同じパスでもパス文字列が違えば異なると判断されます。

@param other 比較対象の Pathname オブジェクトを指定します。

#@samplecode 例
require 'pathname'

p Pathname.new("foo/bar") == Pathname.new("foo/bar")
p Pathname.new("foo/bar") == Pathname.new("foo//bar")
p Pathname.new("foo/../foo/bar") == Pathname.new("foo/bar")

# => true
#    false
#    false
#@end

--- <=>(other) -> -1 | 0 | 1 | nil

パス名を比較します。other と同じなら 0 を、ASCII順で self が大きい場合
は正、other が大きい場合は負を返します。大文字小文字は区別されます。
other は Pathname オブジェクトでなければなりません。

パス名の比較は単純にパス文字列の比較によって行われるので、論理的に
同じパスでもパス文字列が違えば異なると判断されます。

@param other 比較対象の Pathname オブジェクトを指定します。

#@samplecode 例
require 'pathname'

p Pathname.new("foo/bar") <=> Pathname.new("foo/bar")
p Pathname.new("foo/bar") <=> Pathname.new("foo//bar")
p Pathname.new("foo/../foo/bar") <=> Pathname.new("foo/bar")
# => 0
#    1
#    -1
#@end

--- hash -> Integer
ハッシュ値を返します。

#@#noexample

--- to_s   -> String
#@until 1.9.1
--- to_str -> String
#@end
パス名を文字列で返します。

#@until 1.9.1
to_str は、[[m:File.open]] などの引数にそのまま Pathname オブジェクトを
渡せるようにするために用意されています。
#@end

#@samplecode 例
require 'pathname'

path = Pathname.new("/tmp/hogehoge")
File.open(path)
#@end

--- cleanpath(consider_symlink = false) -> Pathname
余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返します。

cleanpath は、実際にファイルシステムを参照することなく、文字列操作
だけで処理を行います。

@param consider_symlink 真ならパス要素にシンボリックリンクがあった場合
                        にも問題ないように .. を残します。

#@samplecode 例
require "pathname"
path = Pathname.new("//.././../")
path                  # => #<Pathname://.././../>
path.cleanpath        # => #<Pathname:/>


require 'pathname'
Dir.rmdir("/tmp/foo")      rescue nil
File.unlink("/tmp/bar/foo") rescue nil
Dir.rmdir("/tmp/bar")      rescue nil
Dir.mkdir("/tmp/foo")
Dir.mkdir("/tmp/bar")
File.symlink("../foo", "/tmp/bar/foo")
path = Pathname.new("bar/././//foo/../bar")
Dir.chdir("/tmp")

path.cleanpath       # => #<Pathname:bar/bar>
path.cleanpath(true) # => #<Pathname:bar/foo/../bar>
#@end

#@since 1.9.2
--- realpath(basedir = nil) -> Pathname
#@end
--- realpath -> Pathname
余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返します。

また、ファイルシステムをアクセスし、実際に存在するパスを返します。
シンボリックリンクも解決されます。

self が指すパスが存在しない場合は例外 [[c:Errno::ENOENT]] が発生します。

#@since 1.9.2
@param basedir ベースディレクトリを指定します。省略するとカレントディレクトリになります。
#@end

#@samplecode 例
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

# => ruby 1.8.0 (2003-10-10) [i586-linux]
#    #<Pathname:/tmp/bar>
#@end

@see [[m:Pathname#realdirpath]], [[m:File.realpath]]

--- realdirpath(basedir = nil) -> Pathname

[[m:Pathname#realpath]] とほぼ同じで、最後のコンポーネントは実際に
存在しなくてもエラーになりません。

@param basedir ベースディレクトリを指定します。省略するとカレントディレクトリになります。

#@samplecode 例
require "pathname"

path = Pathname("/not_exist")
path.realdirpath  # => #<Pathname:/not_exist>
path.realpath     # => Errno::ENOENT

# 最後ではないコンポーネント(/not_exist_1)も存在しないのでエラーになる。
path = Pathname("/not_exist_1/not_exist_2")
path.realdirpath  # => Errno::ENOENT
#@end

@see [[m:Pathname#realpath]]

--- parent -> Pathname
self の親ディレクトリを指す新しい Pathname オブジェクトを返します。

#@samplecode 例 絶対パス
require "pathname"

path = Pathname("/usr")
path        # => #<Pathname:/usr>
path.parent # => #<Pathname:/>
#@end

#@samplecode 例 相対パス
require "pathname"

path = Pathname("foo/bar")
path.parent               # => #<Pathname:foo>
path.parent.parent        # => #<Pathname:.>
path.parent.parent.parent # => #<Pathname:..>
#@end

--- mountpoint? -> bool
self がマウントポイントであれば真を返します。

#@samplecode 例
require "pathname"

path = Pathname("/")
path.mountpoint? # => true
path = Pathname("/usr")
path.mountpoint? # => false
#@end

--- root? -> bool
self がルートディレクトリであれば真を返します。判断は文字列操作によっ
て行われ、ファイルシステムはアクセスされません。

#@samplecode 例
require 'pathname'

Pathname('/').root?         # => true
Pathname('/im/sure').root?  # => false
#@end

--- absolute? -> bool
self が絶対パス指定であれば真を返します。

#@samplecode 例
require "pathname"

pathname = Pathname("/path/to/example.rb")
pathname.absolute? # => true
pathname = Pathname("../")
pathname.absolute? # => false
#@end

--- relative? -> bool
self が相対パス指定であれば真を返します。

#@samplecode 例
require 'pathname'

p = Pathname.new('/im/sure')
p.relative? #=> false

p = Pathname.new('not/so/sure')
p.relative? #=> true
#@end

--- each_filename {|v| ... } -> nil
self のパス名要素毎にブロックを実行します。

#@samplecode 例
require 'pathname'

Pathname.new("/foo/../bar").each_filename {|v| p v}

# => "foo"
#    ".."
#    "bar"
#@end

--- +(other) -> Pathname
#@since 2.2.0
--- /(other) -> Pathname
#@end

パス名を連結します。つまり、other を self からの相対パスとした新しい
Pathname オブジェクトを生成して返します。

other が絶対パスなら単に other と同じ内容の Pathname オブジェクトが返さ
れます。

#@samplecode 例
require 'pathname'

Pathname("foo/bar")+"baz" # => #<Pathname:foo/bar/baz>
Pathname("foo/bar/")+"baz" # => #<Pathname:foo/bar/baz>
Pathname("foo/bar")+"/baz" # => #<Pathname:/baz>
Pathname("foo/bar")+"../baz" # => #<Pathname:foo/baz>
#@end

@param other 文字列か Pathname オブジェクトを指定します。


--- children(with_directory = true) -> [Pathname]
self 配下にあるパス名(Pathnameオブジェクト)の配列を返します。

ただし、 ".", ".." は要素に含まれません。

@param with_directory 偽を指定するとファイル名のみ返します。デフォルトは真です。

@raise Errno::EXXX self が存在しないパスであったりディレクトリでなければ例外が発生します。

#@samplecode 例
require 'pathname'
Pathname.new("/tmp").children # => [#<Pathname:.X11-unix>, #<Pathname:.iroha_unix>, ... ]
#@end


#@since 1.9.2

--- each_child(with_directory = true)                  -> Enumerator
--- each_child(with_directory = true) {|pathname| ...} -> [Pathname]

self.children(with_directory).each と同じです。

@param with_directory 偽を指定するとファイル名のみ返します。デフォルトは真です。

#@samplecode 例
require "pathname"

Pathname("/usr/local").each_child {|f| p f }
# => #<Pathname:/usr/local/bin>
# => #<Pathname:/usr/local/etc>
# => #<Pathname:/usr/local/include>
# => #<Pathname:/usr/local/lib>
# => #<Pathname:/usr/local/opt>
# => #<Pathname:/usr/local/sbin>
# => #<Pathname:/usr/local/share>
# => #<Pathname:/usr/local/var>

Pathname("/usr/local").each_child(false) {|f| p f }
# => #<Pathname:bin>
# => #<Pathname:etc>
# => #<Pathname:include>
# => #<Pathname:lib>
# => #<Pathname:opt>
# => #<Pathname:sbin>
# => #<Pathname:share>
# => #<Pathname:var>
#@end

@see [[m:Pathname#children]]
#@end


--- relative_path_from(base_directory) -> Pathname
base_directory から self への相対パスを求め、その内容の新しい Pathname
オブジェクトを生成して返します。

パス名の解決は文字列操作によって行われ、ファイルシステムをアクセス
しません。

self が相対パスなら base_directory も相対パス、self が絶対パスなら
base_directory も絶対パスでなければなりません。

@param base_directory ベースディレクトリを表す Pathname オブジェクトを指定します。

@raise ArgumentError Windows上でドライブが違うなど、base_directory から self への相対パスが求められないときに例外が発生します。

#@samplecode 例
require 'pathname'

path = Pathname.new("/tmp/foo")
base = Pathname.new("/tmp")

path.relative_path_from(base) # => #<Pathname:foo>
#@end



--- each_line(*args){|line| ... } -> nil
#@since 1.9.1
--- each_line(*args) -> Enumerator
#@else
--- each_line(*args) -> Enumerable::Enumerator
#@end
IO.foreach(self.to_s, *args, &block) と同じです。

#@samplecode 例
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line
# => #<Enumerator: IO:foreach("testfile")>
#@end

#@samplecode 例 ブロックを指定
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line {|f| p f }

# => "line1\n"
# => "line2,\n"
# => "line3\n"
#@end

#@samplecode 例 limit を指定
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line(4) {|f| p f }

# => "line"
# => "1\n"
# => "line"
# => "2,\n"
# => "line"
# => "3\n"
#@end

#@samplecode 例 sep を指定
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line(",") {|f| p f }

# => "line1\nline2,"
# => "\nline3\n"
#@end

@see [[m:IO.foreach]]

--- read(*args) -> String | nil
IO.read(self.to_s, *args)と同じです。

#@#noexample IO.readの例を参照

@see [[m:IO.read]]

#@since 1.9.2
--- binread(*args) -> String | nil
IO.binread(self.to_s, *args)と同じです。

#@samplecode 例
require "pathname"

pathname = Pathname("testfile")
pathname.binread           # => "This is line one\nThis is line two\nThis is line three\nAnd so on...\n"
pathname.binread(20)       # => "This is line one\nThi"
pathname.binread(20, 10)   # => "ne one\nThis is line "
#@end

@see [[m:IO.binread]]

#@end
--- readlines(*args) -> [String]
IO.readlines(self.to_s, *args)と同じです。

#@#noexample IO.readlines の例を参照

@see [[m:IO.readlines]]

--- sysopen(*args) -> Integer
IO.sysopen(self.to_s, *args)と同じです。

#@#noexample IO.sysopen の例を参照

@see [[m:IO.sysopen]]

--- make_link(old) -> 0
File.link(old, self.to_s) と同じです。

#@#noexample File.linkの例を参照

@see [[m:File.link]]

--- make_symlink(old) -> 0
File.symlink(old, self.to_s) と同じです。

#@#noexample File.symlinkの例を参照

@see [[m:File.symlink]]

--- atime -> Time
File.atime(self.to_s) を渡したものと同じです。

#@samplecode 例
require "pathname"

pathname = Pathname("testfile")
pathname.atime # => 2018-12-18 20:58:13 +0900
#@end

@see [[m:File.atime]]

--- ctime -> Time
File.ctime(self.to_s) を渡したものと同じです。

#@samplecode 例
require 'pathname'

IO.write("testfile", "test")
pathname = Pathname("testfile")
pathname.ctime # => 2019-01-14 00:39:51 +0900
sleep 1
pathname.chmod(0755)
pathname.ctime # => 2019-01-14 00:39:52 +0900
#@end

@see [[m:File.ctime]]
--- mtime -> Time
File.mtime(self.to_s) を渡したものと同じです。

#@#noexample File.mtime の例を参照

@see [[m:File.mtime]]

#@since 2.2.0
--- birthtime -> Time
File.birthtime(self.to_s) を渡したものと同じです。

@raise NotImplementedError  Windows のような birthtime のない環境で発生します。

#@#noexample File.birthtime の例を参照

@see [[m:File.birthtime]]
#@end

--- chmod(mode) -> Integer
File.chmod(mode, self.to_s) と同じです。

@param mode ファイルのアクセス権限を整数で指定します。

#@#noexample File.chmod の例を参照

@see [[m:File.chmod]]

--- lchmod(mode) -> Integer
File.lchmod(mode, self.to_s) と同じです。

@param mode ファイルのアクセス権限を整数で指定します。

#@#noexample File.lchmod の例を参照

@see [[m:File.lchmod]]

--- chown(owner, group) -> Integer
File.chown(owner, group, self.to_s) と同じです。

@param owner オーナーを指定します。

@param group グループを指定します。

#@samplecode 例
require 'pathname'

Pathname('testfile').stat.uid     # => 501
Pathname('testfile').chown(502, 12)
Pathname('testfile').stat.uid     # => 502
#@end

@see [[m:File.chown]], [[m:File#chown]]

--- lchown(owner, group) -> Integer
File.lchown(owner, group, self.to_s) と同じです。

@param owner オーナーを指定します。

@param group グループを指定します。

#@#noexample File.lchown の例を参照

@see [[m:File.lchown]]

--- fnmatch(pattern, *args) -> bool
File.fnmatch(pattern, self.to_s, *args) と同じです。

@param pattern パターンを文字列で指定します。

@param args [[m:File.fnmatch]] を参照してください。

#@samplecode 例
require "pathname"

path = Pathname("testfile")
path.fnmatch("test*")                       # => true
path.fnmatch("TEST*")                       # => false
path.fnmatch("TEST*", File::FNM_CASEFOLD)   # => true
#@end

@see [[m:File.fnmatch]]

--- fnmatch?(pattern, *args) -> bool
File.fnmatch?(pattern, self.to_s, *args) と同じです。

@param pattern パターンを文字列で指定します。

@param args [[m:File.fnmatch]] を参照してください。

@see [[m:File.fnmatch?]]

--- ftype -> String
File.ftype(self.to_s) と同じです。

#@#noexample File.ftype の例を参照

@see [[m:File.ftype]]

--- open(mode = 'r', perm = 0666) -> File
--- open(mode = 'r', perm = 0666){|file| ... } -> object
File.open(self.to_s, *args, &block) と同じです。

#@#noexample File.open の例を参照

@see [[m:File.open]]

--- readlink -> Pathname
Pathname.new(File.readlink(self.to_s)) と同じです。

#@#noexample File.readlink の例を参照

@see [[m:File.readlink]]

--- rename(to) -> 0
File.rename(self.to_s, to) と同じです。

@param to ファイル名を表す文字列を指定します。

#@#noexample File.renameの例を参照

@see [[m:File.rename]]

--- stat -> File::Stat
File.stat(self.to_s) と同じです。

#@#noexample File.stat の例を参照

@see [[m:File.stat]]

--- lstat -> File::Stat
File.lstat(self.to_s) と同じです。

#@#noexample File.lstat の例を参照

@see [[m:File.lstat]]

--- truncate(length) -> 0
File.truncate(self.to_s, length) と同じです。

#@#noexample File.truncate の例を参照

@param length 変更したいサイズを整数で与えます。

@see [[m:File.truncate]]

--- utime(atime, mtime) -> Integer
File.utime(atime, mtime, self.to_s) と同じです。

@param atime 最終アクセス時刻を [[c:Time]] か、起算時からの経過秒数を数値で指定します。

@param mtime 更新時刻を [[c:Time]] か、起算時からの経過秒数を数値で指定します。

#@#noexample File.utimeの例を参照

@see [[m:File.utime]]

--- basename(suffix = "") -> Pathname
Pathname.new(File.basename(self.to_s, suffix)) と同じです。

@param suffix サフィックスを文字列で与えます。'.*' という文字列を与えた場合、'*' はワイルドカードとして働き
              '.' を含まない任意の文字列にマッチします。

#@samplecode 例
require "pathname"

Pathname("ruby/ruby.c").basename          #=> #<Pathname:"ruby.c">
Pathname("ruby/ruby.c").basename(".c")    #=> #<Pathname:"ruby">
Pathname("ruby/ruby.c").basename(".*")    #=> #<Pathname:"ruby">
Pathname("ruby/ruby.exe").basename(".*")  #=> #<Pathname:"ruby">
Pathname("ruby/y.tab.c").basename(".*")   #=> #<Pathname:"y.tab">
#@end

@see [[m:File.basename]]

--- dirname -> Pathname
Pathname.new(File.dirname(self.to_s)) と同じです。

#@samplecode 例
require "pathname"

Pathname('/usr/bin/shutdown').dirname # => #<Pathname:/usr/bin>
#@end

@see [[m:File.dirname]]

--- extname -> String
File.extname(self.to_s) と同じです。

#@#noexample File.extname の例を参照

@see [[m:File.extname]]

--- expand_path(default_dir = '.') -> Pathname
Pathname.new(File.expand_path(self.to_s, *args)) と同じです。

@param default_dir self が相対パスであれば default_dir を基準に展開されます。

#@samplecode 例
require "pathname"

path = Pathname("testfile")
Pathname.pwd             # => #<Pathname:/path/to>
path.expand_path         # => #<Pathname:/path/to/testfile>
path.expand_path("../")  # => #<Pathname:/path/testfile>
#@end

@see [[m:File.expand_path]]

--- join(*args) -> Pathname

与えられたパス名を連結します。

@param args 連結したいディレクトリ名やファイル名を文字列で与えます。

#@samplecode 例
require "pathname"

path0 = Pathname("/usr")                # Pathname:/usr
path0 = path0.join("bin/ruby")          # Pathname:/usr/bin/ruby
    # 上記の path0 の処理は下記の path1 と同様のパスになります
path1 = Pathname("/usr") + "bin/ruby"   # Pathname:/usr/bin/ruby
path0 == path1                          #=> true
#@end

--- split -> Array
File.split(self.to_s) と同じです。

#@samplecode 例
require "pathname"

pathname = Pathname("/path/to/sample")
pathname.split # => [#<Pathname:/path/to>, #<Pathname:sample>]
#@end

@see [[m:File.split]]

--- blockdev? -> bool
FileTest.blockdev?(self.to_s) と同じです。

#@#noexample FileTest.#blockdev? の例を参照

@see [[m:FileTest.#blockdev?]]

--- chardev? -> bool
FileTest.chardev?(self.to_s) と同じです。

#@#noexample FileTest.chardev? の例を参照

@see [[m:FileTest.#chardev?]]

--- executable? -> bool
FileTest.executable?(self.to_s) と同じです。

#@#noexample FileTest.#executable? の例を参照

@see [[m:FileTest.#executable?]]

--- executable_real? -> bool
FileTest.executable_real?(self.to_s) と同じです。

#@#noexample FileTest.#executable_real? の例を参照

@see [[m:FileTest.#executable_real?]]

--- exist? -> bool
FileTest.exist?(self.to_s) と同じです。

#@#noexample FileTest.#exist? の例を参照

@see [[m:FileTest.#exist?]]

--- grpowned? -> bool
FileTest.grpowned?(self.to_s) と同じです。

#@#noexample FileTest.#grpowned? の例を参照

@see [[m:FileTest.#grpowned?]]

--- directory? -> bool
FileTest.directory?(self.to_s) と同じです。

#@#noexample FileTest.#directory? の例を参照

@see [[m:FileTest.#directory?]]

--- file? -> bool
FileTest.file?(self.to_s) と同じです。

#@#noexample FileTest.#file? の例を参照

@see [[m:FileTest.#file?]]

--- pipe? -> bool
FileTest.pipe?(self.to_s) と同じです。

#@#noexample FileTest.#pipe?の例を参照

@see [[m:FileTest.#pipe?]]

--- socket? -> bool
FileTest.socket?(self.to_s) と同じです。

#@#noexample FileTest.#socket? の例を参照

@see [[m:FileTest.#socket?]]

--- owned? -> bool
FileTest.owned?(self.to_s) と同じです。

#@#noexample FileTest.#owned?の例を参照

@see [[m:FileTest.#owned?]]

--- readable? -> bool
FileTest.readable?(self.to_s) と同じです。

#@#noexample FileTest.#readable?の例を参照

@see [[m:FileTest.#readable?]]

--- readable_real? -> bool
FileTest.readable_real?(self.to_s) と同じです。

#@#noexample FileTest.#readable_real?の例を参照

@see [[m:FileTest.#readable_real?]]

--- setuid? -> bool
FileTest.setuid?(self.to_s) と同じです。

#@#noexample FileTest.#setuid? の例を参照

@see [[m:FileTest.#setuid?]]

--- setgid? -> bool
FileTest.setgid?(self.to_s) と同じです。

#@#noexample FileTest.#setgid? の例を参照

@see [[m:FileTest.#setgid?]]

--- size -> Integer
FileTest.size(self.to_s) と同じです。

#@#noexample FileTest.#size の例を参照

@see [[m:FileTest.#size]]

--- size? -> bool
FileTest.size?(self.to_s) と同じです。

#@#noexample FileTest.#size? の例を参照

@see [[m:FileTest.#size?]]

--- sticky? -> bool
FileTest.sticky?(self.to_s) と同じです。

#@#noexample FileTest.#sticky? の例を参照

@see [[m:FileTest.#sticky?]]

--- symlink? -> bool
FileTest.symlink?(self.to_s) と同じです。

#@#noexample FileTest.#symlink? の例を参照

@see [[m:FileTest.#symlink?]]


--- world_readable? -> bool
FileTest.world_readable?(self.to_s) と同じです。

#@#noexample FileTest.#world_readable? の例を参照

@see [[m:FileTest.#world_readable?]]

--- world_writable? -> bool
FileTest.world_writable?(self.to_s) と同じです。

#@#noexample FileTest.#world_writable? の例を参照

@see [[m:FileTest.#world_writable?]]


#@since 2.1.0

--- write(string, offset=nil, **opts) -> Integer

#@#noexample IO.write の例を参照

IO.write(self.to_s, string, offset, **opts)と同じです。

@see [[m:IO.write]]

--- binwrite(string, offset=nil) -> Integer

IO.binwrite(self.to_s, *args)と同じです。

#@#noexample IO.binwrite の例を参照

@see [[m:IO.binwrite]]

#@end

--- writable? -> bool
FileTest.writable?(self.to_s) と同じです。

#@#noexample FileTest.#writable? の例を参照

@see [[m:FileTest.#writable?]]

--- writable_real? -> bool
FileTest.writable_real?(self.to_s) と同じです。

#@#noexample FileTest.#writable_real? の例を参照

@see [[m:FileTest.#writable_real?]]

--- zero? -> bool

FileTest.zero?(self.to_s) と同じです。

#@#noexample FileTest.#zero? の例を参照

@see [[m:FileTest.#zero?]]
#@since 2.4.0
     , [[m:Pathname#empty?]]

--- empty? -> bool
ディレクトリに対しては Dir.empty?(self.to_s) と同じ、他に対しては FileTest.empty?(self.to_s) と同じです。

#@samplecode 例 ディレクトリの場合
require "pathname"
require 'tmpdir'

Pathname("/usr/local").empty?               # => false
Dir.mktmpdir { |dir| Pathname(dir).empty? } # => true
#@end

#@samplecode 例 ファイルの場合
require "pathname"
require 'tempfile'

Pathname("testfile").empty?                           # => false
Tempfile.create("tmp") { |tmp| Pathname(tmp).empty? } # => true
#@end

@see [[m:Dir.empty?]], [[m:FileTest.#empty?]], [[m:Pathname#zero?]]
#@end

--- rmdir -> 0
Dir.rmdir(self.to_s) と同じです。

#@#noexample Dir.rmdirの例を参照

@see [[m:Dir.rmdir]]

--- entries -> [Pathname]
self に含まれるファイルエントリ名を元にした [[c:Pathname]] オブジェクトの配列を返します。

@raise Errno::EXXX self が存在しないパスであったりディレクトリでなければ例外が発生します。

#@samplecode 例
require 'pathname'
require 'pp'

pp Pathname('/usr/local').entries
# => [#<Pathname:.>,
#     #<Pathname:..>,
#     #<Pathname:bin>,
#     #<Pathname:etc>,
#     #<Pathname:include>,
#     #<Pathname:lib>,
#     #<Pathname:opt>,
#     #<Pathname:sbin>,
#     #<Pathname:share>,
#     #<Pathname:var>]
#@end

@see [[m:Dir.entries]]


--- each_entry {|pathname| ... } -> nil
#@since 3.2
--- each_entry -> Enumerator
#@end
Dir.foreach(self.to_s) {|f| yield Pathname.new(f) } と同じです。

#@since 3.2
ブロックを省略した場合は [[c:Enumerator]] を返します。
#@end

#@samplecode 例
require "pathname"

Pathname("/usr/local").each_entry {|f| p f }

# => #<Pathname:.>
# => #<Pathname:..>
# => #<Pathname:bin>
# => #<Pathname:etc>
# => #<Pathname:include>
# => #<Pathname:lib>
# => #<Pathname:opt>
#@end

@see [[m:Dir.foreach]]


--- mkdir(*args) -> 0
Dir.mkdir(self.to_s, *args) と同じです。

#@#noexample Dir.mkdir の例を参照

@see [[m:Dir.mkdir]]

--- opendir -> Dir
--- opendir{|dir| ... } -> nil
Dir.open(self.to_s, &block) と同じです。

#@#noexample Dir.open の例を参照

@see [[m:Dir.open]]

#@since 2.2.0
--- find(ignore_error: true)                  -> Enumerator
--- find(ignore_error: true) {|pathname| ...} -> nil
#@else
#@since 2.0.0
--- find                  -> Enumerator
#@end
--- find {|pathname| ...} -> nil
#@end
self 配下のすべてのファイルやディレクトリを
一つずつ引数 pathname に渡してブロックを実行します。

  require 'find'
  Find.find(self.to_s) {|f| yield Pathname.new(f)}

と同じです。

ブロックを省略した場合は [[c:Enumerator]] を返します。

#@since 2.2.0
@param ignore_error 探索中に発生した例外を無視するかどうかを指定します。
#@end

@see [[m:Find.#find]]

--- mkpath -> nil
FileUtils.mkpath(self.to_s) と同じです。

#@#noexample FileUtils.#mkpath の例を参照

@see [[m:FileUtils.#mkpath]]

--- rmtree -> nil
FileUtils.rm_r(self.to_s) と同じです。

#@#noexample FileUtils.#rmtree の例を参照

@see [[m:FileUtils.#rm_r]]

--- unlink -> Integer
--- delete -> Integer
self が指すディレクトリあるいはファイルを削除します。

#@samplecode 例
require "pathname"

pathname = Pathname("/path/to/sample")
pathname.exist? # => true
pathname.unlink # => 1
pathname.exist? # => false
#@end

--- ascend {|pathname| ... } -> nil
--- ascend                   -> Enumerator

self のパス名から親方向に辿っていったときの各パス名を新しい Pathname オ
ブジェクトとして生成し、ブロックへの引数として渡して実行します。
ブロックを省略した場合は [[c:Enumerator]] を返します。

#@samplecode 例
require 'pathname'

Pathname.new('/path/to/some/file.rb').ascend {|v| p v}
# => #<Pathname:/path/to/some/file.rb>
#    #<Pathname:/path/to/some>
#    #<Pathname:/path/to>
#    #<Pathname:/path>
#    #<Pathname:/>

Pathname.new('path/to/some/file.rb').ascend {|v| p v}
# => #<Pathname:path/to/some/file.rb>
#    #<Pathname:path/to/some>
#    #<Pathname:path/to>
#    #<Pathname:path>
#@end

ファイルシステムにはアクセスしません。


--- descend {|pathname| ... } -> nil
--- descend                   -> Enumerator
self のパス名の親から子供へと辿っていったときの各パス名を新しい
Pathname オブジェクトとして生成し、ブロックへの引数として渡して実行しま
す。
ブロックを省略した場合は [[c:Enumerator]] を返します。

#@samplecode 例
require 'pathname'

Pathname.new('/path/to/some/file.rb').descend {|v| p v}
# => #<Pathname:/>
#    #<Pathname:/path>
#    #<Pathname:/path/to>
#    #<Pathname:/path/to/some>
#    #<Pathname:/path/to/some/file.rb>

Pathname.new('path/to/some/file.rb').descend {|v| p v}
# => #<Pathname:path>
#    #<Pathname:path/to>
#    #<Pathname:path/to/some>
#    #<Pathname:path/to/some/file.rb>
#@end

ファイルシステムにはアクセスしません。

--- sub(pattern, replace)  -> Pathname
--- sub(pattern) {|matched| ... } -> Pathname

self を表現するパス文字列に対して sub メソッドを呼び出し、その結果を内
容とする新しい Pathname オブジェクトを生成し、返します。

@param pattern 置き換える文字列のパターンを指定します。

@param replace pattern で指定した文字列と置き換える文字列を指定します。

#@samplecode 例
require 'pathname'

path1 = Pathname('/usr/bin/perl')
path1.sub('perl', 'ruby') #=> #<Pathname:/usr/bin/ruby>
#@end

@see [[m:String#sub]]


#@since 1.9.1
--- to_path -> String
File.open などの引数に渡す際に呼ばれるメソッドです。 Pathname オブジェ
クトにおいては、 to_s と同じです。

#@#noexample

@see [[m:Pathname#to_s]]

--- sub_ext(replace) -> Pathname

拡張子を与えられた文字列で置き換えた [[c:Pathname]] オブジェクトを返します。

自身が拡張子を持たない場合は、与えられた文字列を拡張子として付加します。

@param replace 拡張子を文字列で指定します。

#@samplecode 例
require "pathname"

Pathname('/usr/bin/shutdown').sub_ext('.rb')      # => #<Pathname:/usr/bin/shutdown.rb>
Pathname('/home/user/test.txt').sub_ext('.pdf')   # => #<Pathname:/home/user/test.pdf>
Pathname('/home/user/test').sub_ext('.pdf')       # => #<Pathname:/home/user/test.pdf>
Pathname('/home/user/test.').sub_ext('.pdf')      # => #<Pathname:/home/user/test..pdf>
Pathname('/home/user/.test').sub_ext('.pdf')      # => #<Pathname:/home/user/.test.pdf>
Pathname('/home/user/test.tar.gz').sub_ext('.xz') # => #<Pathname:/home/user/test.tar.xz>
#@end

#@end
#@since 2.5.0
--- glob(pattern, flags=0) -> [Pathname]
--- glob(pattern, flags=0) {|pathname| ...} -> nil

ワイルドカードの展開を行なった結果を、
Pathname オブジェクトの配列として返します。

引数の意味は、[[m:Dir.glob]] と同じです。 flag の初期値である 0 は「何
も指定しない」ことを意味します。

ブロックが与えられたときは、ワイルドカードにマッチした Pathname オブジェ
クトを1つずつ引数としてそのブロックに与えて実行させます。この場合、値と
しては nil を返します。

このメソッドは内部で [[m:Dir.glob]] の base キーワード引数を使っています。

@param pattern ワイルドカードパターンです
@param flags   パターンマッチ時のふるまいを変化させるフラグを指定します

#@samplecode
require "pathname"
Pathname("ruby-2.4.2").glob("R*.md") # => [#<Pathname:ruby-2.4.2/README.md>, #<Pathname:ruby-2.4.2/README.ja.md>]
#@end

@see [[m:Dir.glob]]
@see [[m:Pathname.glob]]
#@end
