= class File < IO
#@if (version >= "1.8.0")
((<ruby 1.8 feature>)): File::Constants は、[[c:IO]] でインクルードさ
れるようになりました。
#@# else
#@#include File::Constant
#@end

ファイルアクセスのためのクラス。通常 [[m:Kernel#open]]
または [[m:File#File.open]] を使って生成します。

== Class Methods

--- atime(filename)
--- ctime(filename)
--- mtime(filename)

atime は最終アクセス時刻、
ctime は状態が最後に変更された時刻、
mtime は最終更新時刻を [[c:Time]] オブジェクトとして返します。

なお、ctime における状態の変更とは chmod などによるものです。

ファイルの時刻の取得に失敗した場合は例外 [[c:Errno::EXXX]] が発生
します。

--- basename(filename[, suffix])

filename の一番後ろのスラッシュに続く要素を返します。もし、
引数 suffix が与えられて、かつそれが filename の末尾に
一致するなら、それを取り除いたものを返します。

例:

  p File.basename("ruby/ruby.c")        #=> "ruby.c"
  p File.basename("ruby/ruby.c", ".c")  #=> "ruby"
  p File.basename("ruby/ruby.c", ".*")  #=> "ruby"
  p File.basename("ruby/ruby.exe", ".*")  #=> "ruby"

[[m:File#File.dirname]], [[m:File#File.extname]] も参照。

[[unknown:1.6.8から1.8.0への変更点(まとめ)]]

File.basename の動作は [[unknown:SUSv3|URL:http://www.unix-systems.org/version3/online.html]] に従うよう変更されました。

    p File.basename("foo/bar/")      # => "bar"  以前は、""

--- chmod(mode[, filename[, ...]])
--- lchmod(mode[, filename[, ...]])

ファイルのモードを mode に変更します。モードを変更したファイ
ルの数を返します。モードの変更に失敗した場合は例外
[[c:Errno::EXXX]] が発生します。

mode は [[man:chmod(2)]] と同様に数値で指定します。

lchmod は、シンボリックリンクに関してリンクそのものの
モードを変更します。[[man:lchmod(2)]] を実装し
ていないシステムでこのメソッドを呼び出すと
[[c:NotImplementedError]] 例外が発生します。

--- chown(owner, group[, filename[, ...]])
--- lchown(owner, group[, filename[, ...]])

ファイルのオーナーとグループを変更します。スーパーユーザだけがファ
イルのオーナーとグループを変更できます。変更を行ったファイルの数を
返します。変更に失敗した場合は例外 [[c:Errno::EXXX]] が発生します。

owner と group は、[[man:chown(2)]] と同様に
数値で指定します。
片方だけ変更したいような場合は nil または -1 を指定する
ことでオーナーやグループを現在のままにすることができます。

lchown は、シンボリックリンクに関してリンクそのもののオーナー、
グループを変更します。[[man:lchown(2)]] を実装していない
システムでこのメソッドを呼び出すと [[c:NotImplementedError]] 例外
が発生します。

--- delete(filename ... )
--- unlink(filename ... )

ファイルを削除します。削除したファイルの数を返します。削除に失敗し
た場合は例外 [[c:Errno::EXXX]] が発生します。

このメソッドは通常ファイルの削除用で、ディレクトリの削除には
[[m:Dir#Dir.rmdir]] を使います。

--- dirname(filename)

filename の一番後ろのスラッシュより前を文
字列として返します。スラッシュを含まないファイル名に対しては
"."(カレントディレクトリ)を返します。

例:

    p File.dirname("dir/file.ext")    # => "dir"
    p File.dirname("file.ext")        # => "."

[[m:File#File.basename]], [[m:File#File.extname]] も参照。

((<ruby 1.8 feature>))

File.dirname の動作は [[unknown:SUSv3|URL:http://www.unix-systems.org/version3/online.html]] に従うよう変更されました。

    p File.dirname("foo/bar/")      # => "foo"  以前は、"foo/bar"
    p File.dirname("foo//bar")      # => "foo"  以前は、"foo/"

--- expand_path(path[, default_dir])

path を絶対パスに展開した文字列を返します。
path が相対パスであれば default_dir を基準にします。
default_dir が nil かまたは与えられなかった時にはカ
レントディレクトリが使われます。

先頭の ~ はホームディレクトリ(環境変数 HOME が使われます)に、
~USER はそのユーザのホームディレクトリに展開されます。

  p File.expand_path("..")         #=> "/home/matz/work"
  p File.expand_path("..", "/tmp") #=> "/"
  p File.expand_path("~")          #=> "/home/matz"
  p File.expand_path("~foo")       #=> "/home/foo"

--- extname(filename)

ファイル名 filename の拡張子部分(最後の "." に続く文字列)を
返します。ディレクトリ名に含まれる "." や、ファイル名先頭の "."
は拡張子の一部としては見なされません。filename に拡張子が含
まれない場合は空文字列を返します。

  p File.extname("foo/foo.txt")     # => ".txt"
  p File.extname("foo/foo.tar.gz")  # => ".gz"
  p File.extname("foo/bar")         # => ""
  p File.extname("foo/.bar")        # => ""
  p File.extname("foo.txt/bar")     # => ""
  p File.extname(".foo")            # => ""


[[m:File#File.basename]], [[m:File#File.dirname]] も参照。

--- fnmatch(pattern, path[, flags])
--- fnmatch?(pattern, path[, flags])

ファイル名のパターンマッチを行います([[man:fnmatch(3)]])。
path が pattern にマッチすれば真を返します。

pattern にはワイルドカードとして `*', `?', `[]' が使用できま
す([[m:Dir#Dir.glob]] とは違って `{}' や `**/' は使用できません)。

    %w(foo foobar bar).each {|f|
      p File.fnmatch("foo*", f)
    }
    # => true
         true
         false

flags に以下の定数([[c:File::Constants]] モジュールで定義さ
れています)を論理和で指定することでパターンマッチの動作を変更する
ことができます。flags のデフォルト値は0(フラグ指定なし)です。

--- FNM_NOESCAPE
エスケープ文字 `\' を普通の文字とみなします。

  # デフォルトでは \ を伴う任意の文字はその文字にマッチしますが、
  # このフラグをつけると、\ が普通の文字として扱われます。
  p File.fnmatch('\a', 'a')                       # => true
  p File.fnmatch('\a', '\a', File::FNM_NOESCAPE)  # => true

  # 前者で * は、エスケープされているので "*" そのものにマッチ
  # します。
  p File.fnmatch('\*', 'a')                       # => false
  p File.fnmatch('\*', '\a', File::FNM_NOESCAPE)  # => true

  # 単体の \ は、このフラグの有無に関わらず \ にマッチします。
  # (シングルクォート文字列中では \\ は、\ であることに注意)
  p File.fnmatch('\\', '\\')                      # => true
  p File.fnmatch('\\', '\\', File::FNM_NOESCAPE)  # => true

--- FNM_PATHNAME
ワイルドカード `*', `?', `[]' が `/' にマッチしなくなります。
シェルのパターンマッチにはこのフラグが使用されています。

  p File.fnmatch('*', '/', File::FNM_PATHNAME)   # => false
  p File.fnmatch('?', '/', File::FNM_PATHNAME)   # => false
  p File.fnmatch('[/]', '/', File::FNM_PATHNAME) # => false

--- FNM_CASEFOLD
アルファベットの大小文字を区別せずにパターンマッチを行います。

  p File.fnmatch('A', 'a', File::FNM_CASEFOLD)   # => true

--- FNM_DOTMATCH
ワイルドカード `*', `?', `[]' が先頭の `.' にマッチするようになります。

  p File.fnmatch('*', '.', File::FNM_DOTMATCH)           # => true
  p File.fnmatch('?', '.', File::FNM_DOTMATCH)           # => true
  p File.fnmatch('[.]', '.', File::FNM_DOTMATCH)         # => true
  p File.fnmatch('foo/*', 'foo/.', File::FNM_DOTMATCH)   # => true

--- ftype(filename)

ファイルのタイプを表す文字列を返します。文字列は以下のうちのいずれ
かです。[[m:File.lstat(filename).ftype]] と同じで
す(シンボリックリンクに対して "link" を返します)。

  "file"
  "directory"
  "characterSpecial"
  "blockSpecial"
  "fifo"
  "link"
  "socket"

  "unknown"

#@#((-あらい 2002-01-07: 今のところ "unknown" を返すことはないはず。
#@#もしそのようなことがあれば、バグ報告をした方が良いと思われる-))

--- join(item, item, ...)

File::SEPARATORを間に入れて文字列を連結します。

  [item, item, ...].join(File::SEPARATOR)

と同じです。([[unknown:DOSISH 対応]]で環境依存になる予定です。)

--- link(old, new)

old を指す new という名前のハードリンクを
生成します。old はすでに存在している必要があります。

ハードリンクに成功した場合は 0 を返します。失敗した場合は例外
[[c:Errno::EXXX]] が発生します。

--- new(path[, mode [, perm]])
--- open(path[, mode [, perm]])
--- open(path[, mode [, perm]]) {|file| ... }

pathで指定されるファイルをオープンし、ファイルオブジェクトを
返します。ファイルのオープンに失敗した場合は例外 [[c:Errno::EXXX]]
が発生します。

引数 mode, perm については 組み込み関数
[[m:Kernel#open]] と同じです。

open() はブロックを指定することができます。
ブロックを指定して呼び出した場合は、ファイルオブジェクトを
与えられてブロックが実行されます。ブロックの実行が終了すると、
ファイルは自動的にクローズされます。

ブロックが指定されたときのこのメソッドの戻り値はブロックの実行結果
です。

--- readlink(path)

シンボリックリンクのリンク先を文字列で返します。リンクの読み取りに
失敗した場合は例外 [[c:Errno::EXXX]] が発生します。

--- rename(from, to)

ファイルの名前を変更します。ディレクトリが異なる場合には移動も行い
ます。[[man:rename(2)]] を参照してください。移動先のファ
イルが存在する時には上書きされます。

ファイルの移動に成功した場合 0 を返します。失敗した場合は例外
[[c:Errno::EXXX]] が発生します。

--- split(pathname)

pathname を dirname とbasename に分割して、2 要
素の配列を返します。

  [File.dirname(pathname), File.basename(pathname)]

と同じです。

--- stat(filename)
--- lstat(filename)

filename の情報を含む [[c:File::Stat]] オブジェクトを生成し
て返します。情報の取得に失敗した場合は例外 [[c:Errno::EXXX]] が発
生します。

lstat は、シンボリックリンクに関してリンクそのものの
情報を返します。
[[man:lstat(2)]] を実装していないシステムでは、
File.stat と同じです。

[[m:IO#stat]],
[[m:File#lstat]] も参照してください。

--- symlink(old, new)

old への new という名前のシンボリックリンクを生成しま
す。

シンボリックリンクの作成に成功すれば 0 を返します。失敗した場合は
例外 [[c:Errno::EXXX]] が発生します。

--- truncate(path, length)

path で指定されたファイルのサイズを最大 length バイト
にします。

サイズの変更に成功すれば 0 を返します。失敗した場合は例外
[[c:Errno::EXXX]] が発生します。

--- umask([umask])

umask を変更します。変更前の umask の値を返します。umask を
省略すると変更を行わないで、現在の umask の値を返します。

--- utime(atime, mtime[, filename[, ...]])

ファイルの最終アクセス時刻と更新時刻を変更します。変更したファイル
の数を返します。変更に失敗した場合は例外 [[c:Errno::EXXX]] が発生
します。

先頭の二つの引数は時刻を指定する数値または [[c:Time]] クラスのイン
スタンスでなければなりません。

--- blockdev?(path)

[[m:FileTest#FileTest.blockdev?]] と同じです。

--- chardev?(path)

[[m:FileTest#FileTest.chardev?]] と同じです。

--- directory?(path)

[[m:FileTest#FileTest.directory?]] と同じです。

--- executable?(path)

[[m:FileTest#FileTest.executable?]] と同じです。

--- executable_real?(path)

[[m:FileTest#FileTest.executable_real?]] と同じです。

--- exist?(path)

[[m:FileTest#FileTest.exist?]] と同じです。

--- file?(path)

[[m:FileTest#FileTest.file?]] と同じです。

--- grpowned?(path)

[[m:FileTest#FileTest.grpowned?]] と同じです。

--- owned?(path)

[[m:FileTest#FileTest.owned?]] と同じです。

--- identical?(filename1, filename2)

[[m:FileTest#FileTest.identical?]] と同じです。

--- pipe?(path)

[[m:FileTest#FileTest.pipe?]] と同じです。

--- readable?(path)

[[m:FileTest#FileTest.readable?]] と同じです。

--- readable_real?(path)

[[m:FileTest#FileTest.readable_real?]] と同じです。

--- setgid?(path)

[[m:FileTest#FileTest.setgid?]] と同じです。

--- setuid?(path)

[[m:FileTest#FileTest.setuid?]] と同じです。

--- size(path)

[[m:FileTest#FileTest.size]] と同じです。

--- size?(path)

[[m:FileTest#FileTest.size?]] と同じです。

--- socket?(path)

[[m:FileTest#FileTest.socket?]] と同じです。

--- sticky?(path)

[[m:FileTest#FileTest.sticky?]] と同じです。

--- symlink?(path)

[[m:FileTest#FileTest.symlink?]] と同じです。

--- writable?(path)

[[m:FileTest#FileTest.writable?]] と同じです。

--- writable_real?(path)

[[m:FileTest#FileTest.writable_real?]] と同じです。

--- zero?(path)

[[m:FileTest#FileTest.zero?]] と同じです。

== Instance Methods

--- atime
--- ctime
--- mtime

atime は最終アクセス時刻、
ctime は状態が最後に変更された時刻、
mtime は最終更新時刻を [[c:Time]] オブジェクトとして返します。

なお、ctime における状態の変更とは chmod などによるものです。

ファイルの時刻の取得に失敗した場合は例外 [[c:Errno::EXXX]] が発生
します。

--- chmod(mode)

ファイルのモードを mode に変更します。モードの変更に成功した
場合は 0 を返します。失敗した場合は例外 [[c:Errno::EXXX]] が発生し
ます。

mode は [[man:chmod(2)]] と同様に数値で指定します。

--- chown(owner, group)

ファイルのオーナーとグループを変更します。スーパーユーザだけがファ
イルのオーナーとグループを変更できます。所有者の変更に成功した場合
は 0 を返します。変更に失敗した場合は例外 [[c:Errno::EXXX]] が発生
します。

owner と group は、[[man:chown(2)]] と同様に
数値で指定します。
nil または -1 を指定することでオーナーやグループを現在
のままにすることができます。

--- flock(operation)

ファイルをロックします。ロックに成功した場合は 0 を返します。失敗
した場合は例外 [[c:Errno::EXXX]] が発生します。File::LOCK_NB が指
定されていて、ブロックされそうな場合には false を返します。
有効な operation は以下の通りです。

--- LOCK_SH

共有ロック。複数のプロセスが同時にロックを共有できます。

システムによってはロック対象のファイルは読み込みモード
("r", "r+" など)でオープンされている必要があります。そのよ
うなシステムでは読み込み可能でないファイルに対するロックは例外
[[unknown:Errno::EBADF|Errno::EXXX]] が発生するかもしれません。

--- LOCK_EX

排他ロック。同時にはただひとつのプロセスだけがロックを保持できます。

システムによってはロック対象のファイルは書き込みモード
("w", "r+" など)でオープンされている必要があります。そのよ
うなシステムでは書き込み可能でないファイルに対するロックは例外
[[unknown:Errno::EBADF|Errno::EXXX]] が発生するかもしれません。

--- LOCK_UN

アンロック。

この明示的なアンロック以外に、Rubyインタプリタの終了
(プロセスの終了)によっても自動的にロック状態は解除されます。

--- LOCK_NB

ノンブロックモード。

File::LOCK_SH | File::LOCK_NB のように他の指定と or することで指
定します。この指定がない場合、ブロックされる条件での flock
の呼び出しはロックが解除されるまでブロックされます。

File::LOCK_NB の指定がある場合、ブロックされる条件での
flock は false を返します。

「ブロックされる条件」とは
  * 他のプロセスが排他ロックをすでに行っている場合にロックを行う
  * 他のプロセスがロックしている状態で排他ロックを行う
の場合です

以上の定数は [[c:File::Constants]] モジュールで定義されています。

例:

    f = File.open("/tmp/foo", "w")

    f.flock(File::LOCK_EX)
    puts "locked by process1"

    fork {
      f = File.open("/tmp/foo", "r")
      f.flock(File::LOCK_SH)
      puts "locked by process2"
      sleep 5
      puts "unlocked by process2"
    }

    sleep 5

    f.flock(File::LOCK_UN)
    puts "unlocked by process1"
    sleep 1 # <- 子プロセスが確実に先にロックするための sleep
    f.flock(File::LOCK_EX)
    puts "re-locked by process1"

    => locked by process1
       unlocked by process1
       locked by process2
       unlocked by process2
       re-locked by process1

--- path

オープン時に使用したパスを文字列で返します。

--- lstat

ファイルの状態を含む [[c:File::Stat]] オブジェクトを生成して返しま
す。情報の取得に失敗した場合は例外 [[c:Errno::EXXX]] が発生します。

lstat は、シンボリックリンクに関してリンクそのものの
情報を返します。
[[man:lstat(2)]] を実装していないシステムでは、
[[m:IO#stat]]と同じです。

[[m:IO#stat]],
[[m:File#File.stat]],
[[m:File#File.lstat]] も参照してください。

--- truncate(length)

ファイルのサイズを最大 length バイトにします。ファイルが書き
込みモードでオープンされてなければ例外 [[c:IOError]] が発生します。

サイズの変更に成功すれば 0 を返します。失敗した場合は例外
[[c:Errno::EXXX]] が発生します。

== Constants

--- ALT_SEPARATOR

システムのファイルパスのセパレータが SEPARATOR と異なる場合
に設定されます。MS-DOS などでは "\" です。UNIX や
[[c:Cygwin]] などでは nil です。

--- PATH_SEPARATOR

PATH 環境変数の要素のセパレータです。UNIX では ":" MS-DOS な
どでは ";" です。

--- SEPARATOR
--- Separator

ファイルパスのセパレータです。ファイルを扱うメソッドにパス名を渡す
場合などスクリプト内のパス名は環境によらずこのセパレータで統一され
ます。値は "/" です。

#@#= class  File::Constants < Object

#@#File クラスに関係する定数を格納したモジュールです。[[c:File::Constants]]
#@#を参照してください。

#@#= class File::Stat < Object

#@#stat 構造体([[man:stat(2)]]参照)を表すクラスです。
#@#[[c:File::Stat]] を参照してください。
