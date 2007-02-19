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

== Class Methods

--- new
#@todo

== Instance Methods

--- each
#@todo

フィルタの一行ずつをblockに渡す.

--- <(src)
#@todo

srcをフィルタの入力とする. srcが, 文字列ならばファイルを, IOであれ
ばそれをそのまま入力とする.

--- >(to)
#@todo

srcをフィルタの出力とする. toが, 文字列ならばファイルに, IOであれ
ばそれをそのまま出力とする.

--- >>(to)
#@todo

srcをフィルタに追加する. toが, 文字列ならばファイルに, IOであれば
それをそのまま出力とする.

--- |(filter)
#@todo

パイプ結合

--- +(filter)
#@todo

filter1 + filter2 は filter1の出力の後, filter2の出力を行う.

--- to_a
--- to_s
#@todo

--- input
--- input=
#@todo

= class Shell < Object

Shellオブジェクトはカレントディレクトリを持ち, 
コマンド実行はそこからの相対パスになります.

== Class Methods

#@#=== コマンド定義
#@#OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
#@#注) コマンドを定義しなくとも直接実行できるShell#systemコマンドもあります.

--- def_system_command(command, path = command)
#@todo

Shellのメソッドとしてcommandを登録します.

OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
注) コマンドを定義しなくとも直接実行できるShell#systemコマンドもあります.

例)
  Shell.def_system_command "ls"
  ls を定義

  Shell.def_system_command "sys_sort", "sort"
  sortコマンドをsys_sortとして定義

--- undef_system_command(command)
#@todo

commandを削除します.

--- alias_command(ali, command, *opts) {...}
#@todo

commandのaliasをします.

例)
  Shell.alias_command "lsC", "ls", "-CBF", "--show-control-chars"
  Shell.alias_command("lsC", "ls"){|*opts| ["-CBF", "--show-control-chars", *opts]}

--- unalias_command(ali)
#@todo

commandのaliasを削除します.

--- install_system_commands(pre = "sys_")
#@todo

system_path上にある全ての実行可能ファイルをShellに定義する. メソッ
ド名は元のファイル名の頭にpreをつけたものとなる.

--- new
#@todo

プロセスのカレントディレクトリをカレントディレクトリとするShellオ
ブジェクトを生成します.

--- cd(path)
#@todo

pathをカレントディレクトリとするShellオブジェクトを生成します.

#@# bc-rdoc: detected missing name: debug=
--- debug
--- debug?
--- debug=(val)
#@todo


#@# bc-rdoc: detected missing name: default_record_separator
--- default_record_separator
--- default_record_separator=(rs)
#@todo



#@# bc-rdoc: detected missing name: default_system_path
--- default_system_path
--- default_system_path=(path)
#@todo


--- verbose   
--- verbose?  
--- verbose=  
#@todo


== Instance Methods
#@#=== プロセス管理

--- cwd
--- dir
--- getwd
--- pwd
#@todo

カレントディレクトリを返す。

--- system_path
--- system_path=(path)
#@todo

コマンドサーチパスの配列を返す。

--- umask
#@todo

umaskを返す。

--- jobs
#@todo

スケジューリングされているjobの一覧を返す.

--- kill(sig, job)
#@todo

jobにシグナルsigを送る

#@#=== カレントディレクトリ操作

--- cd(path, &block)
--- chdir
#@todo

カレントディレクトリをpathにする. イテレータとして呼ばれたときには
ブロック実行中のみカレントディレクトリを変更する.

--- pushd(path = nil, &block)
--- pushdir
#@todo

カレントディレクトリをディレクトリスタックにつみ, カレントディレク
トリをpathにする. pathが省略されたときには, カレントディレクトリと
ディレクトリスタックのトップを交換する. イテレータとして呼ばれたと
きには, ブロック実行中のみpushdする.

--- popd
--- popdir
#@todo

ディレクトリスタックからポップし, それをカレントディレクトリにする.

#@#=== ファイル/ディレクトリ操作
--- foreach(path = nil, &block)
#@todo

pathがファイルなら, File#foreach
pathがディレクトリなら, Dir#foreach

--- open(path, mode)
#@todo

pathがファイルなら, File#open
pathがディレクトリなら, Dir#open

--- unlink(path)
#@todo

pathがファイルなら, File#unlink
pathがディレクトリなら, Dir#unlink

--- test(command, file1, file2)
--- [](command, file1, file2)
#@todo

ファイルテスト関数testと同じ.

例:

    sh[?e, "foo"]
    sh[:e, "foo"]
    sh["e", "foo"]
    sh[:exists?, "foo"]
    sh["exists?", "foo"]

--- mkdir(*path)
#@todo

Dir.mkdirと同じ (複数可)

--- rmdir(*path)
#@todo

Dir.rmdirと同じ (複数可)

--- system(command, *opts)
#@todo

commandを実行する.

例:

  print sh.system("ls", "-l")
  sh.system("ls", "-l") | sh.head > STDOUT

--- rehash
#@todo

リハッシュする

--- transact { ... }
#@todo

ブロック中では shell を self として実行する.

例:

  sh.transact{system("ls", "-l") | head > STDOUT}

--- out(dev = STDOUT, &block)
#@todo

[[m:Shell#transact]] を呼び出しその結果を dev に出力する.

#@#=== 内部コマンド

--- echo(*strings)
--- cat(*files)
--- glob(patten)
--- tee(file)
#@todo

実行すると, それらを内容とする Filter オブジェクトを返します.

#@#=== 組込みコマンド

--- atime(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- basename(file, *opt)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- chmod(mode, *files)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- chown(owner, group, *file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- ctime(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- delete(*file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- dirname(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- ftype(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- join(*file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- link(file_from, file_to)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- lstat(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- mtime(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- readlink(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- rename(file_from, file_to)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- split(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- stat(file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- symlink(file_from, file_to)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- truncate(file, length)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- utime(atime, mtime, *file)
#@todo

Fileクラスにある同名のクラスメソッドと同じです.

--- blockdev?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- chardev?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- directory?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- executable?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- executable_real?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- exist?(file)
--- exists?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- file?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- grpowned?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- owned?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- pipe?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- readable?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- readable_real?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- setgid?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- setuid?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- size(file)
--- size?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- socket?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- sticky?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- symlink?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- writable?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- writable_real?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- zero?(file)
#@todo

FileTestクラスにある同名のクラスメソッドと同じです.

--- syscopy(filename_from, filename_to)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- copy(filename_from, filename_to)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- move(filename_from, filename_to)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- compare(filename_from, filename_to)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- safe_unlink(*filenames)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- makedirs(*filenames)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- install(filename_from, filename_to, mode)
#@todo

FileToolsクラスにある同名のクラスメソッドと同じです.

--- cmp
#@todo

[[m:Shell#compare]] と同じです。

--- mv
#@todo

[[m:Shell#move]] と同じです。

--- cp
#@todo

[[m:Shell#copy]] と同じです。

--- rm_f
#@todo

[[m:Shell#safe_unlink]] と同じです。

--- mkpath
#@todo

[[m:Shell#makedirs]] と同じです。

#@# bc-rdoc: detected missing name: debug=
--- debug
--- debug?
--- debug=(val)
#@todo

--- verbose   
--- verbose?  
--- verbose=  
#@todo

#@# bc-rdoc: detected missing name: expand_path
--- expand_path(path)
#@todo


