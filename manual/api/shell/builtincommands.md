#@# -*- mode: rd; -*-
#@# Shell::CommandProcessor.install_builtin_commands で定義されるメソッド
#@# Shell, Shell::Filter, Shell::CommandProcessor に定義される

#@# from File
### def atime(filename) -> Time
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:File.atime]

### def basename(filename, suffix = "")     -> String
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **param** `suffix` -- サフィックスを文字列で与えます。'.*' という文字列を与えた場合、'*' はワイルドカードとして働き
              '.' を含まない任意の文字列にマッチします。

- **SEE** [m:File.basename]


### def chmod(mode, *filename)    -> Integer

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **param** `mode` -- [man:chmod(2)] と同様に整数で指定します。

- **SEE** [m:File.chmod]

### def chown(owner, group, *filename)    -> Integer
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `owner` -- [man:chown(2)] と同様に数値で指定します。nil または -1 を指定することで、オーナーを維持できます。

- **param** `group` -- [man:chown(2)] と同様に数値で指定します。nil または -1 を指定することで、グループを維持できます。

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.chown]

### def ctime(filename)    -> Time
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:File.ctime]

### def delete(*filename)    -> Integer
### def rm(*filename)        -> Integer
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.delete]

### def dirname(filename)    -> String

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.dirname]

### def ftype(filename)    -> String

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.ftype]

### def join(*item)    -> String
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `item` -- 連結したいディレクトリ名やファイル名を文字列で与えます。

- **SEE** [m:File.join]

### def link(old, new)    -> 0

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `old` -- ファイル名を表す文字列を指定します。

- **param** `new` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.link]


### def lstat(filename)   -> File::Stat

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.lstat]

### def mtime(filename)    -> Time

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:File.mtime]

### def readlink(path)    -> String
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `path` -- シンボリックリンクを表す文字列を指定します。

- **SEE** [m:File.readlink]

### def rename(from, to)    -> 0
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `from` -- ファイルの名前を文字列で与えます。

- **param** `to` -- 新しいファイル名を文字列で与えます。

- **SEE** [m:File.rename]

### def split(pathname)    -> [String]

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `pathname` -- パス名を表す文字列を指定します。

- **SEE** [m:File.split]

### def stat(filename)    -> File::Stat

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **SEE** [m:File.stat]


### def symlink(old, new)    -> 0
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `old` -- ファイル名を表す文字列を指定します。

- **param** `new` -- シンボリックリンクを表す文字列を指定します。

- **SEE** [m:File.symlink]


### def truncate(path, length)    -> 0

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `path` -- パスを表す文字列を指定します。

- **param** `length` -- 変更したいサイズを整数で与えます。

- **SEE** [m:File.truncate]

### def utime(atime, mtime, *filename)    -> Integer
[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filename` -- ファイル名を表す文字列を指定します。

- **param** `atime` -- 最終アクセス時刻を [c:Time] か、起算時からの経過秒数を数値で指定します。

- **param** `utime` -- 更新時刻を [c:Time] か、起算時からの経過秒数を数値で指定します。

- **SEE** [m:File.utime]

#@# from FileTest

### def blockdev?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.blockdev?]

### def chardev?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.chardev?]

### def directory?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.directory?]

### def executable?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.executable?]

### def executable_real?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.executable_real?]

### def exist?(file) -> bool
### def exists?(file) -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.exist?] [m:FileTest?.exists?]

### def file?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.file?]

### def grpowned?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.grpowned?]

### def owned?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.owned?]

### def pipe?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列か IO オブジェクトを指定します。

- **SEE** [m:FileTest?.pipe?]

### def readable?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.readable?]

### def readable_real?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.readable_real?]

### def setgid?(file) -> bool

[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.setgid?]

### def setuid?(file)    -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.setuid?]

### def size(file) -> Integer
### def size?(file) -> Integer | nil

[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.size] [m:FileTest?.size?]

### def socket?(file) -> bool

[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.socket?]


### def sticky?(file) -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.sticky?]

### def symlink?(file) -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.symlink?]

### def writable?(file) -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.writable?]

### def writable_real?(file) -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.writable_real?]

### def zero?(file) -> bool
[c:FileTest] モジュールにある同名のクラスメソッドと同じです.

- **param** `file` -- ファイル名を表す文字列を指定します。

- **SEE** [m:FileTest?.zero?]

#@until 1.9.1
### def syscopy(from, to) -> bool

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `from` -- ファイルの名前を文字列で与えます。

- **param** `to` -- 新しいファイル名を文字列で与えます。

- **SEE** [m:File.syscopy]

### def copy(from, to) -> bool
### def cp(from, to) -> bool

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `from` -- ファイルの名前を文字列で与えます。

- **param** `to` -- 新しいファイル名を文字列で与えます。

- **SEE** [m:File.copy]

### def move(from, to) -> bool
### def mv(from, to) -> bool

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `from` -- ファイルの名前を文字列で与えます。

- **param** `to` -- 新しいファイル名を文字列で与えます。

- **SEE** [m:File.move]

### def compare(file1, file2) -> bool
### def cmp(file1, file2) -> bool

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `file1` -- ファイルの名前を文字列で与えます。

- **param** `file2` -- 新しいファイル名を文字列で与えます。

- **SEE** [m:File.compare]

### def safe_unlink(*filenames) -> Array
### def rm_f(*filenames) -> Array

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `filenames` -- 削除するファイルを指定します。

- **SEE** [m:File.safe_unlink]

### def makedirs(*dirs) -> Array
### def mkpath(*dirs) -> Array

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `dirs` -- 作成するディレクトリを指定します。

- **SEE** [m:File.makedirs]

### def install(from, to, mode = nil, verbose = false) -> () 

[c:File] クラスにある同名のクラスメソッドと同じです.

- **param** `from` -- コピー元のファイル。

- **param** `to` -- コピー先のファイル。

- **param** `mode` -- ファイルのアクセスモード。8進数で指定します。

- **param** `verbose` -- 真を指定すると詳細を表示します。

- **SEE** [m:File.install]

#@end

#@# Shell::CommandProcessor に直接定義されているメソッド

### def foreach(path = nil, &block) -> ()

pathがファイルなら, File#foreach
pathがディレクトリなら, Dir#foreach
の動作をします。

- **param** `path` -- ファイルもしくはディレクトリのパスを文字列で指定します。

```ruby title="使用例"
require 'shell'
Shell.verbose = false
sh = Shell.new
sh.foreach("/tmp"){|f|
  puts f
}
```

### def open(path, mode) -> File | Dir

path がファイルなら、 [m:File.open] path がディレクトリなら、 [m:Dir.open] の動作をします。

- **param** `path` -- 開きたいパスを指定します。

- **param** `mode` -- アクセスモードを指定します。path がディレクトリの場合は無視されます。

- **SEE** [m:File.open], [m:Dir.open]

### def unlink(path) -> self

path がファイルなら [m:File.unlink]、path がディレクトリなら [m:Dir.unlink] の動作をします。

- **param** `path` -- 削除したいパスを指定します。

- **SEE** [m:File.unlink], [m:Dir.unlink]

### def test(command, file1, file2 = nil) -> bool | Time | Integer | nil
### def [](command, file1, file2 = nil) -> bool | Time | Integer | nil

[m:Kernel?.test] や [c:FileTest] のメソッドに処理を委譲します。

- **param** `command` -- 数値、またはサイズが 1 の文字列の場合は [m:Kernel?.test] に処理委譲します。
               2 文字以上の文字列の場合は [c:FileTest] のメソッドとして実行します。

- **param** `file1` -- 文字列でファイルへのパスを指定します。

- **param** `file2` -- 文字列でファイルへのパスを指定します。

```ruby
require 'shell'
Shell.verbose = false
sh = Shell.new
begin
  sh.mkdir("foo")
rescue
end
p sh[?e, "foo"]         # => true
p sh[:e, "foo"]         # => true
p sh["e", "foo"]        # => true
p sh[:exists?, "foo"]   # => true
p sh["exists?", "foo"]  # => true
```

- **SEE** [m:Kernel?.test], [c:FileTest]


### def mkdir(*path) -> Array

Dir.mkdirと同じです。 (複数可)

- **param** `path` -- 作成するディレクトリ名を文字列で指定します。

- **return** -- 作成するディレクトリの一覧の配列を返します。

```ruby title="使用例"
require 'shell'
Shell.verbose = false
sh = Shell.new
begin
  p sh.mkdir("foo") #=> ["foo"]
rescue => err
  puts err
end
```

### def rmdir(*path) -> ()

Dir.rmdirと同じです。 (複数可)

- **param** `path` -- 削除するディレクトリ名を文字列で指定します。

### def system(command, *opts) -> Shell::SystemCommand

command を実行する.

- **param** `command` -- 実行するコマンドのパスを文字列で指定します。

- **param** `opts` -- command のオプションを文字列で指定します。複数可。

```ruby title="使用例"
require 'shell'
Shell.verbose = false
sh = Shell.new

print sh.system("ls", "-l")
Shell.def_system_command("head")
sh.system("ls", "-l") | sh.head("-n 3") > STDOUT
```


### def rehash -> {}

登録されているシステムコマンドの情報をクリアします。
通常、使うことはありません。

### def check_point
### def finish_all_jobs
#@todo

### def transact { ... } -> object

ブロック中で shell を self として実行します。

```ruby title="例"
require 'shell'
Shell.def_system_command("head")
sh = Shell.new
sh.transact{
  system("ls", "-l") | head > STDOUT
  # transact の中では、
  # sh.system("ls", "-l") | sh.head > STDOUT と同じとなる。
}
```

### def out(dev = STDOUT, &block) -> ()

[m:Shell#transact] を呼び出しその結果を dev に出力します。

- **param** `dev` --  出力先をIO オブジェクトなどで指定します。

- **param** `block` -- transact 内部で実行するシェルを指定します。


```ruby title="使用例"
require 'shell'
Shell.def_system_command("head")
sh = Shell.new
File.open("out.txt", "w"){ |fp|
  sh.out(fp) {
    system("ls", "-l") | head("-n 3")
  }
}
```


### def echo(*strings) -> Shell::Filter
実行すると, それらを内容とする Filter オブジェクトを返します.

- **param** `strings` -- シェルコマンド echo に与える引数を文字列で指定します。

```ruby title="動作例"
require 'shell'
Shell.def_system_command("head")
sh = Shell.new
sh.transact {
  glob("*.txt").to_a.each { |file|
    file.chomp!
    cat(file).each { |l|
      echo(l) | tee(file + ".tee") >> "all.tee"
    }
  }
}
```


### def cat(*files) -> Shell::Filter
実行すると, それらを内容とする Filter オブジェクトを返します.

- **param** `files` -- シェルコマンド cat に与えるファイル名を文字列で指定します。

```ruby title="動作例"
require 'shell'
Shell.def_system_command("head")
sh = Shell.new
sh.transact {
  glob("*.txt").to_a.each { |file|
    file.chomp!
    cat(file).each { |l|
      echo(l) | tee(file + ".tee") >> "all.tee"
    }
  }
}
```


### def glob(pattern) -> Shell::Filter
実行すると, それらを内容とする Filter オブジェクトを返します.

- **param** `pattern` -- シェルコマンド glob に与えるパターンを指定します。
              パターンの書式については、[m:Dir.\[\]]を参照してください。

```ruby title="動作例"
require 'shell'
Shell.def_system_command("head")
sh = Shell.new
sh.transact {
  glob("*.txt").to_a.each { |file|
    file.chomp!
    cat(file).each { |l|
      echo(l) | tee(file + ".tee") >> "all.tee"
    }
  }
}
```

- **SEE** [m:Dir.\[\]]

### def append(to, filter) -> Shell::AppendFile | Shell::AppendIO
#@todo

- **param** `to` -- 文字列か [c:IO] を指定します。

- **param** `filter` -- [c:Shell::Filter] のインスタンスを指定します。

### def tee(file) -> Shell::Filter

実行すると, それらを内容とする Filter オブジェクトを返します.

- **param** `file` -- シェルコマンドtee に与えるファイル名を文字列で指定します。

```ruby title="動作例"
require 'shell'
Shell.def_system_command("head")
sh = Shell.new
sh.transact {
  glob("*.txt").to_a.each { |file|
    file.chomp!
    cat(file).each { |l|
      echo(l) | tee(file + ".tee") >> "all.tee"
    }
  }
}
```

### def concat(*jobs) -> Shell::Concat
#@todo

### def notify(*opts){ ... } -> ()
#@todo

### def find_system_command(command)
#@todo

### def identical?
#@todo


#@since 1.9.1

### def world_readable?
#@todo

### def world_writable?
#@todo

#@end
