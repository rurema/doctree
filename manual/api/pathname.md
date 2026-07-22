---
type: library
category: File
---
パス名をオブジェクト指向らしく扱うためのライブラリです。

# reopen Kernel

## Private Instance Methods

### def Pathname(path) -> Pathname

文字列 path を元に [c:Pathname] オブジェクトを生成します。

Pathname.new(path) と同じです。

- **param** `path` -- 文字列、または類似のオブジェクトを与えます。
            実際には to_str に反応するオブジェクトなら何でも構いません。

# class Pathname < Object

パス名をオブジェクト指向らしく扱うクラスです。

Pathname オブジェクトはパス名を表しており、ファイルやディレクトリそのものを表してはいません。
当然、存在しないファイルのパス名も扱えます。

絶対パスも相対パスも扱えます。

Pathname オブジェクトは immutable であり、自身を破壊的に操作するメソッドはありません。

Pathname のインスタンスメソッドには、ディレクトリのパスを返す [m:Pathname#dirname] のように、
文字列操作だけで結果を返すものもあれば、ファイルの中身を読み出す [m:Pathname#read] のように
ファイルシステムにアクセスするものもあります。

Pathname オブジェクトの生成には、[m:Pathname.new] のほかに [m:Kernel#Pathname] も使えます。

```ruby title="例"
require 'pathname'

p Pathname.new("foo/bar") # => #<Pathname:foo/bar>
p Pathname("foo/bar")   # => #<Pathname:foo/bar>
```

## Constants

### const SEPARATOR_PAT -> Regexp

パス名のなかのディレクトリを区切る部分にマッチする正規表現です。

この値は環境依存です。

### const TO_PATH -> Symbol

内部的に使っている定数です。利用者が使うことはありません。

## Class Methods

### def new(path) -> Pathname

文字列 path を元に Pathname オブジェクトを生成します。

- **param** `path` -- 文字列、または類似のオブジェクトを与えます。
            実際には to_str に反応するオブジェクトなら何でも構いません。

- **raise** `ArgumentError` -- path が \0 を含んでいると発生します。

```ruby title="例"
require "pathname"

p Pathname.new(__FILE__) # => #<Pathname:/path/to/file.rb>
```

### def getwd -> Pathname
### def pwd   -> Pathname

カレントディレクトリを元に Pathname オブジェクトを生成します。
Pathname.new(Dir.getwd) と同じです。

```ruby title="例"
require "pathname"

p Pathname.getwd #=> #<Pathname:/home/zzak/projects/ruby>
```

- **SEE** [m:Dir.getwd]

### def glob(pattern, flags=0) -> [Pathname]
### def glob(pattern, flags=0) {|pathname| ...} -> nil

ワイルドカードの展開を行なった結果を、
Pathname オブジェクトの配列として返します。

引数の意味は、[m:Dir.glob] と同じです。 flag の初期値である 0 は「何
も指定しない」ことを意味します。

ブロックが与えられたときは、ワイルドカードにマッチした Pathname オブジェ
クトを1つずつ引数としてそのブロックに与えて実行させます。この場合、値と
しては nil を返します。

- **param** `pattern` -- ワイルドカードパターンです
- **param** `flags` --   ワイルドカードのマッチ時のふるまいを変化させるフラグを指定します

```ruby
require "pathname"
p Pathname.glob("lib/i*.rb") # => [#<Pathname:lib/ipaddr.rb>, #<Pathname:lib/irb.rb>]
```

- **SEE** [m:Dir.glob]
- **SEE** [m:Pathname#glob]

## Instance Methods

### def ==(other)   -> bool
### def ===(other)  -> bool
### def eql?(other) -> bool

パス名を比較し、 other と同じなら真を返します。大文字小文字は区別されます。
other は Pathname オブジェクトでなければなりません。

パス名の比較は単純にパス文字列の比較によって行われるので、論理的に
同じパスでもパス文字列が違えば異なると判断されます。

- **param** `other` -- 比較対象の Pathname オブジェクトを指定します。

```ruby title="例"
require 'pathname'

p Pathname.new("foo/bar") == Pathname.new("foo/bar")
p Pathname.new("foo/bar") == Pathname.new("foo//bar")
p Pathname.new("foo/../foo/bar") == Pathname.new("foo/bar")

# => true
#    false
#    false
```

### def <=>(other) -> -1 | 0 | 1 | nil

パス名を比較します。other と同じなら 0 を、ASCII順で self が大きい場合
は正、other が大きい場合は負を返します。大文字小文字は区別されます。
other は Pathname オブジェクトでなければなりません。

パス名の比較は単純にパス文字列の比較によって行われるので、論理的に
同じパスでもパス文字列が違えば異なると判断されます。

- **param** `other` -- 比較対象の Pathname オブジェクトを指定します。

```ruby title="例"
require 'pathname'

p Pathname.new("foo/bar") <=> Pathname.new("foo/bar")
p Pathname.new("foo/bar") <=> Pathname.new("foo//bar")
p Pathname.new("foo/../foo/bar") <=> Pathname.new("foo/bar")
# => 0
#    1
#    -1
```

### def hash -> Integer

ハッシュ値を返します。

#@#noexample

### def to_s   -> String

パス名を文字列で返します。

```ruby title="例"
require 'pathname'

path = Pathname.new("/tmp/hogehoge")
File.open(path)
```

### def cleanpath(consider_symlink = false) -> Pathname

余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返します。

cleanpath は、実際にファイルシステムを参照することなく、文字列操作
だけで処理を行います。

- **param** `consider_symlink` -- 真ならパス要素にシンボリックリンクがあった場合
                        にも問題ないように .. を残します。

```ruby title="例"
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
```

### def realpath(basedir = nil) -> Pathname
### def realpath -> Pathname

余計な "."、".." や "/" を取り除いた新しい Pathname オブジェクトを返します。

また、ファイルシステムをアクセスし、実際に存在するパスを返します。
シンボリックリンクも解決されます。

self が指すパスが存在しない場合は例外 [c:Errno::ENOENT] が発生します。

- **param** `basedir` -- ベースディレクトリを指定します。省略するとカレントディレクトリになります。

```ruby title="例"
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
```

- **SEE** [m:Pathname#realdirpath], [m:File.realpath]

### def realdirpath(basedir = nil) -> Pathname

[m:Pathname#realpath] とほぼ同じで、最後のコンポーネントは実際に
存在しなくてもエラーになりません。

- **param** `basedir` -- ベースディレクトリを指定します。省略するとカレントディレクトリになります。

```ruby title="例"
require "pathname"

path = Pathname("/not_exist")
path.realdirpath  # => #<Pathname:/not_exist>
path.realpath     # => Errno::ENOENT

# 最後ではないコンポーネント(/not_exist_1)も存在しないのでエラーになる。
path = Pathname("/not_exist_1/not_exist_2")
path.realdirpath  # => Errno::ENOENT
```

- **SEE** [m:Pathname#realpath]

### def parent -> Pathname

self の親ディレクトリを指す新しい Pathname オブジェクトを返します。

```ruby title="例 絶対パス"
require "pathname"

path = Pathname("/usr")
path        # => #<Pathname:/usr>
path.parent # => #<Pathname:/>
```

```ruby title="例 相対パス"
require "pathname"

path = Pathname("foo/bar")
path.parent               # => #<Pathname:foo>
path.parent.parent        # => #<Pathname:.>
path.parent.parent.parent # => #<Pathname:..>
```

### def mountpoint? -> bool

self がマウントポイントであれば真を返します。

```ruby title="例"
require "pathname"

path = Pathname("/")
path.mountpoint? # => true
path = Pathname("/usr")
path.mountpoint? # => false
```

### def root? -> bool

self がルートディレクトリであれば真を返します。判断は文字列操作によっ
て行われ、ファイルシステムはアクセスされません。

```ruby title="例"
require 'pathname'

p Pathname('/').root?       # => true
p Pathname('/im/sure').root?  # => false
```

### def absolute? -> bool

self が絶対パス指定であれば真を返します。

```ruby title="例"
require "pathname"

pathname = Pathname("/path/to/example.rb")
pathname.absolute? # => true
pathname = Pathname("../")
pathname.absolute? # => false
```

### def relative? -> bool

self が相対パス指定であれば真を返します。

```ruby title="例"
require 'pathname'

p = Pathname.new('/im/sure')
p.relative? #=> false

p = Pathname.new('not/so/sure')
p.relative? #=> true
```

### def each_filename {|v| ... } -> nil

self のパス名要素毎にブロックを実行します。

```ruby title="例"
require 'pathname'

Pathname.new("/foo/../bar").each_filename {|v| p v}

# => "foo"
#    ".."
#    "bar"
```

### def +(other) -> Pathname
### def /(other) -> Pathname

パス名を連結します。つまり、other を self からの相対パスとした新しい
Pathname オブジェクトを生成して返します。

other が絶対パスなら単に other と同じ内容の Pathname オブジェクトが返さ
れます。

```ruby title="例"
require 'pathname'

p Pathname("foo/bar")+"baz" # => #<Pathname:foo/bar/baz>
p Pathname("foo/bar/")+"baz" # => #<Pathname:foo/bar/baz>
p Pathname("foo/bar")+"/baz" # => #<Pathname:/baz>
p Pathname("foo/bar")+"../baz" # => #<Pathname:foo/baz>
```

- **param** `other` -- 文字列か Pathname オブジェクトを指定します。

### def children(with_directory = true) -> [Pathname]

self 配下にあるパス名(Pathnameオブジェクト)の配列を返します。

ただし、 ".", ".." は要素に含まれません。

- **param** `with_directory` -- 偽を指定するとファイル名のみ返します。デフォルトは真です。

- **raise** `Errno::EXXX` -- self が存在しないパスであったりディレクトリでなければ例外が発生します。

```ruby title="例"
require 'pathname'
p Pathname.new("/tmp").children # => [#<Pathname:.X11-unix>, #<Pathname:.iroha_unix>, ... ]
```

### def each_child(with_directory = true)                  -> Enumerator
### def each_child(with_directory = true) {|pathname| ...} -> [Pathname]

self.children(with_directory).each と同じです。

- **param** `with_directory` -- 偽を指定するとファイル名のみ返します。デフォルトは真です。

```ruby title="例"
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
```

- **SEE** [m:Pathname#children]

### def relative_path_from(base_directory) -> Pathname

base_directory から self への相対パスを求め、その内容の新しい Pathname
オブジェクトを生成して返します。

パス名の解決は文字列操作によって行われ、ファイルシステムをアクセス
しません。

self が相対パスなら base_directory も相対パス、self が絶対パスなら
base_directory も絶対パスでなければなりません。

- **param** `base_directory` -- ベースディレクトリを表す Pathname オブジェクトを指定します。

- **raise** `ArgumentError` -- Windows上でドライブが違うなど、base_directory から self への相対パスが求められないときに例外が発生します。

```ruby title="例"
require 'pathname'

path = Pathname.new("/tmp/foo")
base = Pathname.new("/tmp")

path.relative_path_from(base) # => #<Pathname:foo>
```

### def each_line(*args){|line| ... } -> nil
### def each_line(*args) -> Enumerator

IO.foreach(self.to_s, *args, &block) と同じです。

```ruby title="例"
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
p Pathname("testfile").each_line
# => #<Enumerator: IO:foreach("testfile")>
```

```ruby title="例 ブロックを指定"
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line {|f| p f }

# => "line1\n"
# => "line2,\n"
# => "line3\n"
```

```ruby title="例 limit を指定"
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line(4) {|f| p f }

# => "line"
# => "1\n"
# => "line"
# => "2,\n"
# => "line"
# => "3\n"
```

```ruby title="例 sep を指定"
require "pathname"

IO.write("testfile", "line1\nline2,\nline3\n")
Pathname("testfile").each_line(",") {|f| p f }

# => "line1\nline2,"
# => "\nline3\n"
```

- **SEE** [m:IO.foreach]

### def read(*args) -> String | nil

IO.read(self.to_s, *args)と同じです。

#@#noexample IO.readの例を参照

- **SEE** [m:IO.read]

### def binread(*args) -> String | nil

IO.binread(self.to_s, *args)と同じです。

```ruby title="例"
require "pathname"

pathname = Pathname("testfile")
pathname.binread           # => "This is line one\nThis is line two\nThis is line three\nAnd so on...\n"
pathname.binread(20)       # => "This is line one\nThi"
pathname.binread(20, 10)   # => "ne one\nThis is line "
```

- **SEE** [m:IO.binread]

### def readlines(*args) -> [String]

IO.readlines(self.to_s, *args)と同じです。

#@#noexample IO.readlines の例を参照

- **SEE** [m:IO.readlines]

### def sysopen(*args) -> Integer

IO.sysopen(self.to_s, *args)と同じです。

#@#noexample IO.sysopen の例を参照

- **SEE** [m:IO.sysopen]

### def make_link(old) -> 0

File.link(old, self.to_s) と同じです。

#@#noexample File.linkの例を参照

- **SEE** [m:File.link]

### def make_symlink(old) -> 0

File.symlink(old, self.to_s) と同じです。

#@#noexample File.symlinkの例を参照

- **SEE** [m:File.symlink]

### def atime -> Time

File.atime(self.to_s) を渡したものと同じです。

```ruby title="例"
require "pathname"

pathname = Pathname("testfile")
pathname.atime # => 2018-12-18 20:58:13 +0900
```

- **SEE** [m:File.atime]

### def ctime -> Time

File.ctime(self.to_s) を渡したものと同じです。

```ruby title="例"
require 'pathname'

IO.write("testfile", "test")
pathname = Pathname("testfile")
pathname.ctime # => 2019-01-14 00:39:51 +0900
sleep 1
pathname.chmod(0755)
pathname.ctime # => 2019-01-14 00:39:52 +0900
```

- **SEE** [m:File.ctime]

### def mtime -> Time

File.mtime(self.to_s) を渡したものと同じです。

#@#noexample File.mtime の例を参照

- **SEE** [m:File.mtime]

### def birthtime -> Time

File.birthtime(self.to_s) を渡したものと同じです。

- **raise** `NotImplementedError` --  Windows のような birthtime のない環境で発生します。

#@#noexample File.birthtime の例を参照

- **SEE** [m:File.birthtime]

### def chmod(mode) -> Integer

File.chmod(mode, self.to_s) と同じです。

- **param** `mode` -- ファイルのアクセス権限を整数で指定します。

#@#noexample File.chmod の例を参照

- **SEE** [m:File.chmod]

### def lchmod(mode) -> Integer

File.lchmod(mode, self.to_s) と同じです。

- **param** `mode` -- ファイルのアクセス権限を整数で指定します。

#@#noexample File.lchmod の例を参照

- **SEE** [m:File.lchmod]

### def chown(owner, group) -> Integer

File.chown(owner, group, self.to_s) と同じです。

- **param** `owner` -- オーナーを指定します。

- **param** `group` -- グループを指定します。

```ruby title="例"
require 'pathname'

p Pathname('testfile').stat.uid   # => 501
Pathname('testfile').chown(502, 12)
p Pathname('testfile').stat.uid   # => 502
```

- **SEE** [m:File.chown], [m:File#chown]

### def lchown(owner, group) -> Integer

File.lchown(owner, group, self.to_s) と同じです。

- **param** `owner` -- オーナーを指定します。

- **param** `group` -- グループを指定します。

#@#noexample File.lchown の例を参照

- **SEE** [m:File.lchown]

### def fnmatch(pattern, *args) -> bool

File.fnmatch(pattern, self.to_s, *args) と同じです。

- **param** `pattern` -- パターンを文字列で指定します。ワイルドカードとして `*`,
               `**`, `?`, `[]`, `{}` が使用できます。詳細は [m:File.fnmatch] を参照してください。

- **param** `args` -- [m:File.fnmatch] を参照してください。

```ruby title="例"
require "pathname"

path = Pathname("testfile")
path.fnmatch("test*")                       # => true
path.fnmatch("TEST*")                       # => false
path.fnmatch("TEST*", File::FNM_CASEFOLD)   # => true
```

- **SEE** [m:File.fnmatch]

### def fnmatch?(pattern, *args) -> bool

File.fnmatch?(pattern, self.to_s, *args) と同じです。

- **param** `pattern` -- パターンを文字列で指定します。ワイルドカードとして `*`,
               `**`, `?`, `[]`, `{}` が使用できます。詳細は [m:File.fnmatch] を参照してください。

- **param** `args` -- [m:File.fnmatch] を参照してください。

- **SEE** [m:File.fnmatch?]

### def ftype -> String

File.ftype(self.to_s) と同じです。

#@#noexample File.ftype の例を参照

- **SEE** [m:File.ftype]

### def open(mode = 'r', perm = 0666) -> File
### def open(mode = 'r', perm = 0666){|file| ... } -> object

File.open(self.to_s, *args, &block) と同じです。

#@#noexample File.open の例を参照

- **SEE** [m:File.open]

### def readlink -> Pathname

Pathname.new(File.readlink(self.to_s)) と同じです。

#@#noexample File.readlink の例を参照

- **SEE** [m:File.readlink]

### def rename(to) -> 0

File.rename(self.to_s, to) と同じです。

- **param** `to` -- ファイル名を表す文字列を指定します。

#@#noexample File.renameの例を参照

このメソッドはファイルシステム上のファイル名を変更しますが、レシーバの
[c:Pathname] オブジェクトが保持しているパス文字列は変更されません。
そのため、rename の呼び出し後も self は変更前のパスを指したままです。

```ruby
require 'pathname'
path = Pathname.new("old")
File.write("old", "")
path.rename("new")
path.to_s    # => "old"
path.exist?  # => false
p Pathname.new("new").exist? # => true
```

新しいパスを指す [c:Pathname] オブジェクトが必要な場合は、
Pathname.new(to) などとして新しく作成する必要があります。

- **SEE** [m:File.rename]

### def stat -> File::Stat

File.stat(self.to_s) と同じです。

#@#noexample File.stat の例を参照

- **SEE** [m:File.stat]

### def lstat -> File::Stat

File.lstat(self.to_s) と同じです。

#@#noexample File.lstat の例を参照

- **SEE** [m:File.lstat]

### def truncate(length) -> 0

File.truncate(self.to_s, length) と同じです。

#@#noexample File.truncate の例を参照

- **param** `length` -- 変更したいサイズを整数で与えます。

- **SEE** [m:File.truncate]

### def utime(atime, mtime) -> Integer

File.utime(atime, mtime, self.to_s) と同じです。

- **param** `atime` -- 最終アクセス時刻を [c:Time] か、起算時からの経過秒数を数値で指定します。

- **param** `mtime` -- 更新時刻を [c:Time] か、起算時からの経過秒数を数値で指定します。

#@#noexample File.utimeの例を参照

- **SEE** [m:File.utime]

### def basename(suffix = "") -> Pathname

Pathname.new(File.basename(self.to_s, suffix)) と同じです。

- **param** `suffix` -- サフィックスを文字列で与えます。'.*' という文字列を与えた場合、'*' はワイルドカードとして働き
              '.' を含まない任意の文字列にマッチします。

```ruby title="例"
require "pathname"

p Pathname("ruby/ruby.c").basename        #=> #<Pathname:"ruby.c">
p Pathname("ruby/ruby.c").basename(".c")  #=> #<Pathname:"ruby">
p Pathname("ruby/ruby.c").basename(".*")  #=> #<Pathname:"ruby">
p Pathname("ruby/ruby.exe").basename(".*")  #=> #<Pathname:"ruby">
p Pathname("ruby/y.tab.c").basename(".*") #=> #<Pathname:"y.tab">
```

- **SEE** [m:File.basename]

### def dirname -> Pathname

Pathname.new(File.dirname(self.to_s)) と同じです。

```ruby title="例"
require "pathname"

p Pathname('/usr/bin/shutdown').dirname # => #<Pathname:/usr/bin>
```

- **SEE** [m:File.dirname]

### def extname -> String

File.extname(self.to_s) と同じです。

#@#noexample File.extname の例を参照

- **SEE** [m:File.extname]

### def expand_path(default_dir = '.') -> Pathname

Pathname.new(File.expand_path(self.to_s, *args)) と同じです。

- **param** `default_dir` -- self が相対パスであれば default_dir を基準に展開されます。

```ruby title="例"
require "pathname"

path = Pathname("testfile")
p Pathname.pwd           # => #<Pathname:/path/to>
path.expand_path         # => #<Pathname:/path/to/testfile>
path.expand_path("../")  # => #<Pathname:/path/testfile>
```

- **SEE** [m:File.expand_path]

### def join(*args) -> Pathname

与えられたパス名を連結します。

- **param** `args` -- 連結したいディレクトリ名やファイル名を文字列で与えます。

```ruby title="例"
require "pathname"

path0 = Pathname("/usr")                # Pathname:/usr
path0 = path0.join("bin/ruby")          # Pathname:/usr/bin/ruby
    # 上記の path0 の処理は下記の path1 と同様のパスになります
path1 = Pathname("/usr") + "bin/ruby"   # Pathname:/usr/bin/ruby
path0 == path1                          #=> true
```

### def split -> Array

File.split(self.to_s) と同じです。

```ruby title="例"
require "pathname"

pathname = Pathname("/path/to/sample")
pathname.split # => [#<Pathname:/path/to>, #<Pathname:sample>]
```

- **SEE** [m:File.split]

### def blockdev? -> bool

FileTest.blockdev?(self.to_s) と同じです。

#@#noexample FileTest.#blockdev? の例を参照

- **SEE** [m:FileTest?.blockdev?]

### def chardev? -> bool

FileTest.chardev?(self.to_s) と同じです。

#@#noexample FileTest.chardev? の例を参照

- **SEE** [m:FileTest?.chardev?]

### def executable? -> bool

FileTest.executable?(self.to_s) と同じです。

#@#noexample FileTest.#executable? の例を参照

- **SEE** [m:FileTest?.executable?]

### def executable_real? -> bool

FileTest.executable_real?(self.to_s) と同じです。

#@#noexample FileTest.#executable_real? の例を参照

- **SEE** [m:FileTest?.executable_real?]

### def exist? -> bool

FileTest.exist?(self.to_s) と同じです。

#@#noexample FileTest.#exist? の例を参照

- **SEE** [m:FileTest?.exist?]

### def grpowned? -> bool

FileTest.grpowned?(self.to_s) と同じです。

#@#noexample FileTest.#grpowned? の例を参照

- **SEE** [m:FileTest?.grpowned?]

### def directory? -> bool

FileTest.directory?(self.to_s) と同じです。

#@#noexample FileTest.#directory? の例を参照

- **SEE** [m:FileTest?.directory?]

### def file? -> bool

FileTest.file?(self.to_s) と同じです。

#@#noexample FileTest.#file? の例を参照

- **SEE** [m:FileTest?.file?]

### def pipe? -> bool

FileTest.pipe?(self.to_s) と同じです。

#@#noexample FileTest.#pipe?の例を参照

- **SEE** [m:FileTest?.pipe?]

### def socket? -> bool

FileTest.socket?(self.to_s) と同じです。

#@#noexample FileTest.#socket? の例を参照

- **SEE** [m:FileTest?.socket?]

### def owned? -> bool

FileTest.owned?(self.to_s) と同じです。

#@#noexample FileTest.#owned?の例を参照

- **SEE** [m:FileTest?.owned?]

### def readable? -> bool

FileTest.readable?(self.to_s) と同じです。

#@#noexample FileTest.#readable?の例を参照

- **SEE** [m:FileTest?.readable?]

### def readable_real? -> bool

FileTest.readable_real?(self.to_s) と同じです。

#@#noexample FileTest.#readable_real?の例を参照

- **SEE** [m:FileTest?.readable_real?]

### def setuid? -> bool

FileTest.setuid?(self.to_s) と同じです。

#@#noexample FileTest.#setuid? の例を参照

- **SEE** [m:FileTest?.setuid?]

### def setgid? -> bool

FileTest.setgid?(self.to_s) と同じです。

#@#noexample FileTest.#setgid? の例を参照

- **SEE** [m:FileTest?.setgid?]

### def size -> Integer

FileTest.size(self.to_s) と同じです。

#@#noexample FileTest.#size の例を参照

- **SEE** [m:FileTest?.size]

### def size? -> bool

FileTest.size?(self.to_s) と同じです。

#@#noexample FileTest.#size? の例を参照

- **SEE** [m:FileTest?.size?]

### def sticky? -> bool

FileTest.sticky?(self.to_s) と同じです。

#@#noexample FileTest.#sticky? の例を参照

- **SEE** [m:FileTest?.sticky?]

### def symlink? -> bool

FileTest.symlink?(self.to_s) と同じです。

#@#noexample FileTest.#symlink? の例を参照

- **SEE** [m:FileTest?.symlink?]

### def world_readable? -> bool

FileTest.world_readable?(self.to_s) と同じです。

#@#noexample FileTest.#world_readable? の例を参照

- **SEE** [m:FileTest?.world_readable?]

### def world_writable? -> bool

FileTest.world_writable?(self.to_s) と同じです。

#@#noexample FileTest.#world_writable? の例を参照

- **SEE** [m:FileTest?.world_writable?]

### def write(string, offset=nil, **opts) -> Integer

#@#noexample IO.write の例を参照

IO.write(self.to_s, string, offset, **opts)と同じです。

- **SEE** [m:IO.write]

### def binwrite(string, offset=nil) -> Integer

IO.binwrite(self.to_s, *args)と同じです。

#@#noexample IO.binwrite の例を参照

- **SEE** [m:IO.binwrite]

### def writable? -> bool

FileTest.writable?(self.to_s) と同じです。

#@#noexample FileTest.#writable? の例を参照

- **SEE** [m:FileTest?.writable?]

### def writable_real? -> bool

FileTest.writable_real?(self.to_s) と同じです。

#@#noexample FileTest.#writable_real? の例を参照

- **SEE** [m:FileTest?.writable_real?]

### def zero? -> bool

FileTest.zero?(self.to_s) と同じです。

#@#noexample FileTest.#zero? の例を参照

- **SEE** [m:FileTest?.zero?]
     , [m:Pathname#empty?]

### def empty? -> bool

ディレクトリに対しては Dir.empty?(self.to_s) と同じ、他に対しては FileTest.empty?(self.to_s) と同じです。

```ruby title="例 ディレクトリの場合"
require "pathname"
require 'tmpdir'

p Pathname("/usr/local").empty?             # => false
p Dir.mktmpdir { |dir| Pathname(dir).empty? } # => true
```

```ruby title="例 ファイルの場合"
require "pathname"
require 'tempfile'

p Pathname("testfile").empty?                         # => false
p Tempfile.create("tmp") { |tmp| Pathname(tmp).empty? } # => true
```

- **SEE** [m:Dir.empty?], [m:FileTest?.empty?], [m:Pathname#zero?]

### def rmdir -> 0

Dir.rmdir(self.to_s) と同じです。

#@#noexample Dir.rmdirの例を参照

- **SEE** [m:Dir.rmdir]

### def entries -> [Pathname]

self に含まれるファイルエントリ名を元にした [c:Pathname] オブジェクトの配列を返します。

- **raise** `Errno::EXXX` -- self が存在しないパスであったりディレクトリでなければ例外が発生します。

```ruby title="例"
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
```

- **SEE** [m:Dir.entries]

### def each_entry {|pathname| ... } -> nil
#@since 3.2
### def each_entry -> Enumerator
#@end
Dir.foreach(self.to_s) {|f| yield Pathname.new(f) } と同じです。

#@since 3.2
ブロックを省略した場合は [c:Enumerator] を返します。
#@end

```ruby title="例"
require "pathname"

Pathname("/usr/local").each_entry {|f| p f }

# => #<Pathname:.>
# => #<Pathname:..>
# => #<Pathname:bin>
# => #<Pathname:etc>
# => #<Pathname:include>
# => #<Pathname:lib>
# => #<Pathname:opt>
```

- **SEE** [m:Dir.foreach]

### def mkdir(*args) -> 0

Dir.mkdir(self.to_s, *args) と同じです。

#@#noexample Dir.mkdir の例を参照

- **SEE** [m:Dir.mkdir]

### def opendir -> Dir
### def opendir{|dir| ... } -> nil

Dir.open(self.to_s, &block) と同じです。

#@#noexample Dir.open の例を参照

- **SEE** [m:Dir.open]

### def find(ignore_error: true)                  -> Enumerator
### def find(ignore_error: true) {|pathname| ...} -> nil

self 配下のすべてのファイルやディレクトリを
一つずつ引数 pathname に渡してブロックを実行します。

```text
require 'find'
Find.find(self.to_s) {|f| yield Pathname.new(f)}
```

と同じです。

ブロックを省略した場合は [c:Enumerator] を返します。

- **param** `ignore_error` -- 探索中に発生した例外を無視するかどうかを指定します。

- **SEE** [m:Find?.find]

### def mkpath -> nil

FileUtils.mkpath(self.to_s) と同じです。

#@#noexample FileUtils.#mkpath の例を参照

- **SEE** [m:FileUtils?.mkpath]

### def rmtree -> nil

FileUtils.rm_r(self.to_s) と同じです。

#@#noexample FileUtils.#rmtree の例を参照

- **SEE** [m:FileUtils?.rm_r]

### def unlink -> Integer
### def delete -> Integer

self が指すディレクトリあるいはファイルを削除します。

```ruby title="例"
require "pathname"

pathname = Pathname("/path/to/sample")
pathname.exist? # => true
pathname.unlink # => 1
pathname.exist? # => false
```

### def ascend {|pathname| ... } -> nil
### def ascend                   -> Enumerator

self のパス名から親方向に辿っていったときの各パス名を新しい Pathname オ
ブジェクトとして生成し、ブロックへの引数として渡して実行します。
ブロックを省略した場合は [c:Enumerator] を返します。

```ruby title="例"
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
```

ファイルシステムにはアクセスしません。

### def descend {|pathname| ... } -> nil
### def descend                   -> Enumerator

self のパス名の親から子供へと辿っていったときの各パス名を新しい
Pathname オブジェクトとして生成し、ブロックへの引数として渡して実行しま
す。
ブロックを省略した場合は [c:Enumerator] を返します。

```ruby title="例"
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
```

ファイルシステムにはアクセスしません。

### def sub(pattern, replace)  -> Pathname
### def sub(pattern) {|matched| ... } -> Pathname

self を表現するパス文字列に対して sub メソッドを呼び出し、その結果を内
容とする新しい Pathname オブジェクトを生成し、返します。

- **param** `pattern` -- 置き換える文字列のパターンを指定します。

- **param** `replace` -- pattern で指定した文字列と置き換える文字列を指定します。

```ruby title="例"
require 'pathname'

path1 = Pathname('/usr/bin/perl')
path1.sub('perl', 'ruby') #=> #<Pathname:/usr/bin/ruby>
```

- **SEE** [m:String#sub]

### def to_path -> String

File.open などの引数に渡す際に呼ばれるメソッドです。 Pathname オブジェ
クトにおいては、 to_s と同じです。

#@#noexample

- **SEE** [m:Pathname#to_s]

### def sub_ext(replace) -> Pathname

拡張子を与えられた文字列で置き換えた [c:Pathname] オブジェクトを返します。

自身が拡張子を持たない場合は、与えられた文字列を拡張子として付加します。

- **param** `replace` -- 拡張子を文字列で指定します。

```ruby title="例"
require "pathname"

p Pathname('/usr/bin/shutdown').sub_ext('.rb')    # => #<Pathname:/usr/bin/shutdown.rb>
p Pathname('/home/user/test.txt').sub_ext('.pdf') # => #<Pathname:/home/user/test.pdf>
p Pathname('/home/user/test').sub_ext('.pdf')     # => #<Pathname:/home/user/test.pdf>
p Pathname('/home/user/test.').sub_ext('.pdf')    # => #<Pathname:/home/user/test..pdf>
p Pathname('/home/user/.test').sub_ext('.pdf')    # => #<Pathname:/home/user/.test.pdf>
p Pathname('/home/user/test.tar.gz').sub_ext('.xz') # => #<Pathname:/home/user/test.tar.xz>
```

### def glob(pattern, flags=0) -> [Pathname]
### def glob(pattern, flags=0) {|pathname| ...} -> nil

ワイルドカードの展開を行なった結果を、
Pathname オブジェクトの配列として返します。

引数の意味は、[m:Dir.glob] と同じです。 flag の初期値である 0 は「何
も指定しない」ことを意味します。

ブロックが与えられたときは、ワイルドカードにマッチした Pathname オブジェ
クトを1つずつ引数としてそのブロックに与えて実行させます。この場合、値と
しては nil を返します。

このメソッドは内部で [m:Dir.glob] の base キーワード引数を使っています。

- **param** `pattern` -- ワイルドカードパターンです
- **param** `flags` --   ワイルドカードのマッチ時のふるまいを変化させるフラグを指定します

```ruby
require "pathname"
p Pathname("ruby-2.4.2").glob("R*.md") # => [#<Pathname:ruby-2.4.2/README.md>, #<Pathname:ruby-2.4.2/README.ja.md>]
```

- **SEE** [m:Dir.glob]
- **SEE** [m:Pathname.glob]
