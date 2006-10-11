#@# Author: Keiju ISHITSUKA

Ruby 上で sh/csh のようにコマンドの実行及びフィルタリングを手軽に行う.
sh/csh の制御文は Ruby の機能を用いて実現する.

=== サンプル

==== Example 1:

  sh = Shell.cd("/tmp")
  sh.mkdir "shell-test-1" unless sh.exists?("shell-test-1")
  sh.cd("shell-test-1")
  for dir in ["dir1", "dir3", "dir5"]
    unless sh.exists?(dir)
      sh.mkdir dir
      sh.cd(dir) do
        f = sh.open("tmpFile", "w")
        f.puts "TEST"
        f.close
      end
      print sh.pwd
    end
  end

==== Example 2:

  sh = Shell.cd("/tmp")
  sh.transact do
    mkdir "shell-test-1" unless exists?("shell-test-1")
    cd("shell-test-1")
    for dir in ["dir1", "dir3", "dir5"]
      if !exists?(dir)
        mkdir dir
        cd(dir) do
          f = open("tmpFile", "w")
          f.print "TEST\n"
          f.close
        end
        print pwd
      end
    end
  end

==== Example 3: Using Pipe

  sh.cat("/etc/printcap") | sh.tee("tee1") > "tee2"
  (sh.cat < "/etc/printcap") | sh.tee("tee11") > "tee12"
  sh.cat("/etc/printcap") | sh.tee("tee1") >> "tee2"
  (sh.cat < "/etc/printcap") | sh.tee("tee11") >> "tee12"

==== Example 4:

  print sh.cat("/etc/passwd").head.collect {|line| /keiju/ =~ line }



= class Shell::Filter < Object

include Enumerable

コマンドの実行結果はすべてFilterとしてかえります. 

== Instance Methods

--- each

フィルタの一行ずつをblockに渡す.

--- <(src)

srcをフィルタの入力とする. srcが, 文字列ならばファイルを, IOであれ
ばそれをそのまま入力とする.

--- >(to)

srcをフィルタの出力とする. toが, 文字列ならばファイルに, IOであれ
ばそれをそのまま出力とする.

--- >>(to)

srcをフィルタに追加する. toが, 文字列ならばファイルに, IOであれば
それをそのまま出力とする.

--- |(filter)

パイプ結合

--- +(filter)

filter1 + filter2 は filter1の出力の後, filter2の出力を行う.

--- to_a
--- to_s



= class Shell < Object

Shellオブジェクトはカレントディレクトリを持ち, 
コマンド実行はそこからの相対パスになります.

== Class Methods

#@#=== コマンド定義
#@#OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
#@#注) コマンドを定義しなくとも直接実行できるShell#systemコマンドもあります.

--- def_system_command(command, path = command)

Shellのメソッドとしてcommandを登録します.

OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
注) コマンドを定義しなくとも直接実行できるShell#systemコマンドもあります.

例)
Shell.def_system_command "ls"
  ls を定義

Shell.def_system_command "sys_sort", "sort"
  sortコマンドをsys_sortとして定義

--- undef_system_command(command)

commandを削除します.

--- alias_command(ali, command, *opts) {...}

commandのaliasをします.

例)
  Shell.alias_command "lsC", "ls", "-CBF", "--show-control-chars"
  Shell.alias_command("lsC", "ls"){|*opts| ["-CBF", "--show-control-chars", *opts]}

--- unalias_command(ali)

commandのaliasを削除します.

--- install_system_commands(pre = "sys_")

system_path上にある全ての実行可能ファイルをShellに定義する. メソッ
ド名は元のファイル名の頭にpreをつけたものとなる.

--- new

プロセスのカレントディレクトリをカレントディレクトリとするShellオ
ブジェクトを生成します.

--- cd(path)

pathをカレントディレクトリとするShellオブジェクトを生成します.

== Instance Methods
#@#=== プロセス管理

--- cwd
--- dir
--- getwd
--- pwd

カレントディレクトリを返す。

--- system_path

コマンドサーチパスの配列を返す。

--- umask

umaskを返す。

--- jobs

スケジューリングされているjobの一覧を返す.

--- kill(sig, job)

jobにシグナルsigを送る

#@#=== カレントディレクトリ操作

--- cd(path, &block)
--- chdir

カレントディレクトリをpathにする. イテレータとして呼ばれたときには
ブロック実行中のみカレントディレクトリを変更する.

--- pushd(path = nil, &block)
--- pushdir

カレントディレクトリをディレクトリスタックにつみ, カレントディレク
トリをpathにする. pathが省略されたときには, カレントディレクトリと
ディレクトリスタックのトップを交換する. イテレータとして呼ばれたと
きには, ブロック実行中のみpushdする.

--- popd
--- popdir

ディレクトリスタックからポップし, それをカレントディレクトリにする.

#@#=== ファイル/ディレクトリ操作
--- foreach(path = nil, &block)

pathがファイルなら, File#foreach
pathがディレクトリなら, Dir#foreach

--- open(path, mode)

pathがファイルなら, File#open
pathがディレクトリなら, Dir#open

--- unlink(path)

pathがファイルなら, File#unlink
pathがディレクトリなら, Dir#unlink

--- test(command, file1, file2)
--- [](command, file1, file2)

ファイルテスト関数testと同じ.

例:

    sh[?e, "foo"]
    sh[:e, "foo"]
    sh["e", "foo"]
    sh[:exists?, "foo"]
    sh["exists?", "foo"]

--- mkdir(*path)

Dir.mkdirと同じ (複数可)

--- rmdir(*path)

Dir.rmdirと同じ (複数可)

--- system(command, *opts)

commandを実行する.

例:

  print sh.system("ls", "-l")
  sh.system("ls", "-l") | sh.head > STDOUT

--- rehash

リハッシュする

--- transact { ... }

ブロック中では shell を self として実行する.

例:

  sh.transact{system("ls", "-l") | head > STDOUT}

--- out(dev = STDOUT, &block)

[[m:Shell#transact]] を呼び出しその結果を dev に出力する.

#@#=== 内部コマンド

--- echo(*strings)
--- cat(*files)
--- glob(patten)
--- tee(file)

実行すると, それらを内容とする Filter オブジェクトを返します.

#@#=== 組込みコマンド

--- atime(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- basename(file, *opt)

Fileクラスにある同名のクラスメソッドと同じです.

--- chmod(mode, *files)

Fileクラスにある同名のクラスメソッドと同じです.

--- chown(owner, group, *file)

Fileクラスにある同名のクラスメソッドと同じです.

--- ctime(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- delete(*file)

Fileクラスにある同名のクラスメソッドと同じです.

--- dirname(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- ftype(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- join(*file)

Fileクラスにある同名のクラスメソッドと同じです.

--- link(file_from, file_to)

Fileクラスにある同名のクラスメソッドと同じです.

--- lstat(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- mtime(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- readlink(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- rename(file_from, file_to)

Fileクラスにある同名のクラスメソッドと同じです.

--- split(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- stat(file)

Fileクラスにある同名のクラスメソッドと同じです.

--- symlink(file_from, file_to)

Fileクラスにある同名のクラスメソッドと同じです.

--- truncate(file, length)

Fileクラスにある同名のクラスメソッドと同じです.

--- utime(atime, mtime, *file)

Fileクラスにある同名のクラスメソッドと同じです.

--- blockdev?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- chardev?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- directory?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- executable?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- executable_real?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- exist?(file)
--- exists?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- file?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- grpowned?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- owned?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- pipe?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- readable?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- readable_real?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- setgid?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- setuid?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- size(file)
--- size?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- socket?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- sticky?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- symlink?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- writable?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- writable_real?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- zero?(file)

FileTestクラスにある同名のクラスメソッドと同じです.

--- syscopy(filename_from, filename_to)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- copy(filename_from, filename_to)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- move(filename_from, filename_to)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- compare(filename_from, filename_to)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- safe_unlink(*filenames)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- makedirs(*filenames)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- install(filename_from, filename_to, mode)

FileToolsクラスにある同名のクラスメソッドと同じです.

--- cmp

[[m:Shell#compare]] と同じです。

--- mv

[[m:Shell#move]] と同じです。

--- cp

[[m:Shell#copy]] と同じです。

--- rm_f

[[m:Shell#safe_unlink]] と同じです。

--- mkpath

[[m:Shell#makedirs]] と同じです。
