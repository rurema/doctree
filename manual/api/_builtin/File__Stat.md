---
library: _builtin
include:
  - Comparable
---
# class File::Stat < Object

ファイルの情報を格納したオブジェクトのクラス。

[c:FileTest] に同名のモジュール関数がある場合はそれと同じ働きをします。ただ、
ファイル名を引数に取るかわりに Stat 自身について判定する点が違います。

```ruby
p File::Stat.new($0).directory? #=> false
p FileTest.directory?($0) #=> false
```

1.8 以降では、属性メソッドがシステムでサポートされていない場合 nil が返ります。
なお、1.7 以前では 0 が返っていました。

```text
dev         デバイス番号(ファイルシステム)
dev_major   dev の major 番号部
dev_minor   dev の minor 番号部
ino         i-node 番号
mode        ファイルモード
nlink       ハードリンクの数
uid         オーナーのユーザID
gid         オーナーのグループID
rdev        デバイスタイプ(スペシャルファイルのみ)
rdev_major  rdev の major 番号部
rdev_minor  rdev の minor 番号部
size        ファイルサイズ(バイト単位)
blksize     望ましいI/Oのブロックサイズ
blocks      割り当てられているブロック数
atime       最終アクセス時刻
mtime       最終更新時刻
ctime       最終状態変更時刻(状態の変更とは chmod などによるもので、Unix では i-node の変更を意味します)
```

## Class Methods

### def new(path)    -> File::Stat

path に関する File::Stat オブジェクトを生成して返します。
[m:File.stat] と同じです。

- **param** `path` -- ファイルのパスを指定します。

- **raise** `Errno::ENOENT` -- pathに該当するファイルが存在しない場合発生します。

```ruby
p $:[0]
#=> 例
# "C:/Program Files/ruby-1.8/lib/ruby/site_ruby/1.8"
p File::Stat.new($:[0])
#=> 例
#<File::Stat dev=0x2, ino=0, mode=040755, nlink=1, uid=0, gid=0, rdev=0x2, size=0, blksize=nil, blocks=nil, atime=Sun Sep 02 14:15:20 +0900 2007, mtime=Tue Apr 24 23:03:44 +0900 2007, ctime=Tue Apr 24 23:03:37 +0900 2007>
```

## Instance Methods

### def <=>(o) -> -1 | 0 | 1 | nil

ファイルの最終更新時刻を比較します。self が other よりも
新しければ 1 を、等しければ 0 を、古ければ -1 を返します。
比較できない場合は nil を返します。

- **param** `o` -- [c:File::Stat] のインスタンスを指定します。

```ruby
require 'tempfile' # for Tempfile

fp1 = Tempfile.open("first")
fp1.print "古い方\n"
sleep(1)
fp2 = Tempfile.open("second")
fp2.print "新しい方\n"

p File::Stat.new(fp1.path) <=> File::Stat.new(fp2.path) #=> -1
p File::Stat.new(fp2.path) <=> File::Stat.new(fp1.path) #=>  1
p File::Stat.new(fp1.path) <=> fp2.path #=> nil
```

### def ftype -> String

ファイルのタイプを表す文字列を返します。

文字列は以下のうちのいずれかです。

```text
"file"
"directory"
"characterSpecial"
"blockSpecial"
"fifo"
"link"
"socket"

"unknown"
```

#@# あらい 2002-01-06: 今のところ "unknown" を返すことはないはず。
#@# もしそのようなことがあれば、バグ報告をした方が良いと思われる。
#@# Solaris の Door とかは unknown になる？

```ruby title="例"
fs = File::Stat.new($0)
p fs.ftype #=> "file"
p File::Stat.new($:[0]).ftype #=> "directory"
```

1.8 以降では、属性メソッドがシステムでサポートされていない場合 nil が返ります。
なお、1.7 以前では 0 が返っていました。

### def dev -> String

デバイス番号(ファイルシステム)を返します。

```ruby
fs = File::Stat.new($0)
p fs.dev
#例
#=> 2
```

#@# WindowsXP ruby1.8.6 でテスト

### def dev_major -> Integer

dev の major 番号部を返します。

```ruby
fs = File::Stat.new($0)
p fs.dev_major
#例
#=> nil #この場合ではシステムでサポートされていないため
```

#@# WindowsXP ruby1.8.6 でテスト

### def dev_minor -> Integer

dev の minor 番号部を返します。

```ruby
fs = File::Stat.new($0)
p fs.dev_minor
#例
#=> nil
```

#@# WindowsXP ruby1.8.6 でテスト

### def ino -> Integer

i-node 番号を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.ino      #=> 0
```

#@# WindowsXP ruby1.8.6 でテスト

### def mode -> Integer

ファイルモードを返します。

```ruby
fs = File::Stat.new($0)
printf "%o\n", fs.mode
#例
#=> 100644
```

#@# WindowsXP ruby1.8.6 でテスト

### def nlink -> Integer

ハードリンクの数を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.nlink    #=> 1
```

#@# WindowsXP ruby1.8.6 でテスト

### def uid -> Integer

オーナーのユーザIDを返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.uid    #=> 0
```

#@# WindowsXP ruby1.8.6 でテスト

### def gid -> Integer

オーナーのグループIDを返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.gid      #=> 0
```

#@# WindowsXP ruby1.8.6 でテスト

### def rdev -> Integer

デバイスタイプ(スペシャルファイルのみ)を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.rdev     #=> 2
```

#@# WindowsXP ruby1.8.6 でテスト

### def rdev_major -> Integer

rdev の major 番号部を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.rdev_major #=> nil
```

#@# WindowsXP ruby1.8.6 でテスト

### def rdev_minor -> Integer

rdev の minor 番号部を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.rdev_minor #=> nil
```

#@# WindowsXP ruby1.8.6 でテスト

### def size -> Integer

ファイルサイズ(バイト単位)を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.size    #=> 1548
```

#@# WindowsXP ruby1.8.6 でテスト

### def blksize -> Integer

望ましいI/Oのブロックサイズを返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.blksize #=> nil
```

#@# WindowsXP ruby1.8.6 でテスト

### def blocks -> Integer

割り当てられているブロック数を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.blocks  #=> nil
```

#@# WindowsXP ruby1.8.6 でテスト

### def atime -> Time

最終アクセス時刻を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.atime.to_a  #=> [45, 5, 21, 5, 9, 2007, 3, 248, false, "\223\214\213\236 (\225W\217\200\216\236) "]
```

#@# WindowsXP ruby1.8.6 でテスト

- **SEE** [c:Time]

### def mtime -> Time

最終更新時刻を返します。

```ruby
fs = File::Stat.new($0)
#例
p fs.mtime   #=> Wed Sep 05 20:42:18 +0900 2007
```

#@# WindowsXP ruby1.8.6 でテスト

- **SEE** [c:Time]

### def ctime -> Time

最終状態変更時刻を返します。
(状態の変更とは chmod などによるもので、Unix では i-node の変更を意味します)

```ruby
fs = File::Stat.new($0)
#例
p fs.ctime.to_f   #=> 1188719843.0
```

#@# WindowsXP ruby1.8.6 でテスト

- **SEE** [c:Time]

### def birthtime -> Time

作成された時刻を返します。

- **raise** `NotImplementedError` --  Windows のような birthtime のない環境で発生します。

```ruby
File.write("testfile", "foo")
sleep 10
File.write("testfile", "bar")
sleep 10
File.chmod(0644, "testfile")
sleep 10
File.read("testfile")
p File.stat("testfile").birthtime #=> 2014-02-24 11:19:17 +0900
p File.stat("testfile").mtime     #=> 2014-02-24 11:19:27 +0900
p File.stat("testfile").ctime     #=> 2014-02-24 11:19:37 +0900
p File.stat("testfile").atime     #=> 2014-02-24 11:19:47 +0900
```

### def directory? -> bool

ディレクトリの時に真を返します。

```ruby
p File::Stat.new($0).directory? #=> false
```

- **SEE** [m:FileTest?.directory?]

### def readable? -> bool

読み込み可能な時に真を返します。

```ruby
p File::Stat.new($0).readable? #=> true
```

### def readable_real? -> bool

実ユーザ/実グループによって読み込み可能な時に真を返します。

```ruby
p File::Stat.new($0).readable_real? #=> true
```

### def writable? -> bool

書き込み可能な時に真を返します。

```ruby
p File::Stat.new($0).writable? #=> true
```

### def writable_real? -> bool

実ユーザ/実グループによって書き込み可能な時に真を返します。

```ruby
p File::Stat.new($0).writable_real? #=> true
```

### def executable? -> bool

実効ユーザ/グループIDで実行できる時に真を返します。

```ruby
p File::Stat.new($0).executable?
# 例
#=> true
```

### def executable_real? -> bool

実ユーザ/グループIDで実行できる時に真を返します。

```ruby
p File::Stat.new($0).executable_real?
#例
#=> true
```

### def file? -> bool

通常ファイルの時に真を返します。

```ruby
p File::Stat.new($0).file? #=> true
```

### def zero? -> bool

サイズが0である時に真を返します。

```ruby
p File::Stat.new($0).zero? #=> false
```

### def size? -> Integer | nil

サイズが0の時にはnil、それ以外の場合はファイルサイズを返します。

```ruby
require 'tempfile'

fp = Tempfile.new("temp")
p fp.size #=> 0
p File::Stat.new(fp.path).size? #=> nil
fp.print "not 0 "
fp.close
p FileTest.exist?(fp.path) #=> true
p File::Stat.new(fp.path).size? #=> 6
```

### def owned? -> bool

自分のものである時に真を返します。

```ruby
printf "%s %s\n", $:[0], File::Stat.new($:[0]).owned?
#例
#=> /usr/local/lib/site_ruby/1.8 false
```

### def grpowned? -> bool

グループIDが実効グループIDと等しい時に真を返します。

補助グループIDは考慮されません。

```ruby
printf "%s %s\n", $:[0], File::Stat.new($:[0]).grpowned?
#例
#=> /usr/local/lib/site_ruby/1.8 false
printf "%s %s\n", $0, File::Stat.new($0).grpowned?
#例
#=> filestat.rb true
```

### def pipe? -> bool

無名パイプおよび名前つきパイプ(FIFO)の時に真を返します。

#@#linux のみ？

```ruby
system("mkfifo /tmp/pipetest")
p File::Stat.new("/tmp/pipetest").pipe? #=> true
```

### def symlink? -> false

シンボリックリンクである時に真を返します。
ただし、File::Statは自動的にシンボリックリンクをたどっていくので
常にfalseを返します。

#@# ソースにそう書いてあったので

```ruby
require 'fileutils'
outfile = $0 + ".ln"
FileUtils.ln_s($0, outfile)
p File::Stat.new(outfile).symlink? #=> false
p File.lstat(outfile).symlink?     #=> true
p FileTest.symlink?(outfile)       #=> true
```

- **SEE** [m:File.lstat]

### def socket? -> bool

ソケットの時に真を返します。

```ruby
Dir.glob("/tmp/*"){|file|
  if File::Stat.new(file).socket?
    printf "%s\n", file
  end
}
#例
#=> /tmp/uimhelper-hogehoge
#...
```

### def blockdev? -> bool

ブロックスペシャルファイルの時に真を返します。

```ruby
Dir.glob("/dev/*") {|bd|
  if File::Stat.new(bd).blockdev?
    puts bd
  end
}
#例
#...
#=> /dev/hda1
#=> /dev/hda3
#...
```

### def chardev? -> bool

キャラクタスペシャルファイルの時に真を返します。

```ruby
Dir.glob("/dev/*") {|bd|
  if File::Stat.new(bd).chardev?
    puts bd
  end
}
#例
#...
#=> /dev/tty1
#=> /dev/stderr
#...
```

### def setuid? -> bool

setuidされている時に真を返します。

```ruby
Dir.glob("/bin/*") {|bd|
  if File::Stat.new(bd).setuid?
    puts bd
  end
}
#例
#...
#=> /bin/ping
#=> /bin/su
#...
```

### def setgid? -> bool

setgidされている時に真を返します。

```ruby
Dir.glob("/usr/sbin/*") {|bd|
  if File::Stat.new(bd).setgid?
    puts bd
  end
}
#例
#...
#=> /usr/sbin/postqueue
#...
```

### def sticky? -> bool

stickyビットが立っている時に真を返します。

```ruby
Dir.glob("/usr/bin/*") {|bd|
  begin
    if File::Stat.new(bd).sticky?
      puts bd
    end
  rescue
  end
}
#例
#...
#=> /usr/bin/emacs-21.4
#...
```

### def world_readable? -> Integer | nil

全てのユーザから読めるならば、そのファイルのパーミッションを表す
整数を返します。そうでない場合は nil を返します。

整数の意味はプラットフォームに依存します。

```ruby
m = File.stat("/etc/passwd").world_readable?  # => 420
p sprintf("%o", m)                            # => "644"
```

### def world_writable? -> Integer | nil

全てのユーザから書き込めるならば、そのファイルのパーミッションを表す
整数を返します。そうでない場合は nil を返します。

整数の意味はプラットフォームに依存します。

```ruby
m = File.stat("/tmp").world_writable?         # => 511
p sprintf("%o", m)                            # => "777"
```
