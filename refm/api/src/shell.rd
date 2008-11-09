Ruby 上で sh/csh のようにコマンドの実行及びフィルタリングを手軽に行うためのライブラリです。
#@# Author: Keiju ISHITSUKA

sh/csh の制御文は Ruby の機能を用いて実現します。

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

コマンドの実行結果はすべてShell::Filterとしてかえります. 

== Class Methods

--- new -> Shell::Filter

執筆者募集。
Shell::Filter クラス のインスタンスを返します。
通常このnewを直接使う機会はすくないでしょう。

== Instance Methods

--- each(rs = nil) -> ()

フィルタの一行ずつをblockに渡します。

@param rs レコードセパレーターを表す文字列を指定します。
          nil ならば、[[m:Shell.record_separator]]の値が使用されます。

使用例
  sh = Shell.new
  sh.cat("/etc/passwd").each { |line|
    puts line
  }

--- <(src) -> self

srcをフィルタの入力とする. srcが, 文字列ならばファイルを, IOオブジェクトであれ
ばそれをそのまま入力とする.

@param src フィルタの入力を, 文字列もしくは,IO オブジェクトで指定します.

使用例
  Shell.def_system_command("head")
  sh = Shell.new
  sh.transact {
    (sh.head("-n 30") < "/etc/passwd") > "ugo.txt"
  }

--- >(to) -> self

toをフィルタの出力とする. toが, 文字列ならばファイルに, IOオブジェクトであれ
ばそれをそのまま出力とする.

@param to 出力先を指定します.文字列ならばファイルに,IOオブジェクトならばそれに出力します.

使用例
  Shell.def_system_command("tail")
  sh = Shell.new
  sh.transact {
    (sh.tail("-n 3") < "/etc/passwd") > File.open("tail.out", "w")
    #(sh.tail("-n 3") < "/etc/passwd") > "tail.out" # と同じ.
  }

--- >>(to) -> self

toをフィルタに追加する. toが, 文字列ならばファイルに, IOオブジェクトであれば
それをそのまま出力とする.

@param to 出力先を指定します。文字列ならばファイルに、IOオブジェクトならばそれに出力します。

使用例
  Shell.def_system_command("tail")
  sh = Shell.new
  sh.transact {
    (sh.tail("-n 3") < "/etc/passwd") >> "tail.out" 
    #(sh.tail("-n 3") < "/etc/passwd") >> File.open("tail.out", "w") # でも同じ.
  }

--- |(filter) -> object

パイプ結合を filter に対して行います。

@param filter Shell::Filter オブジェクトを指定します.

@return filter を返します.

使用例
  Shell.def_system_command("tail")
  Shell.def_system_command("head")
  Shell.def_system_command("wc")
  sh = Shell.new
  sh.transact {
    i = 1
    while i <= (cat("/etc/passwd") | wc("-l")).to_s.chomp.to_i
      puts (cat("/etc/passwd") | head("-n #{i}") | tail("-n 1")).to_s
      i += 1
    end
  }

--- +(filter)
執筆者募集

filter1 + filter2 は filter1の出力の後, filter2の出力を行う.

--- to_a -> Array
--- to_s -> String

実行結果を文字列、それぞれ文字列の配列で返します。

使用例
  Shell.def_system_command("wc")
  sh = Shell.new
  puts sh.cat("/etc/passwd").to_a

  sh.transact {
    puts (cat("/etc/passwd") | wc("-l")).to_s
  }

--- input
--- input=
執筆者募集

フィルターを設定します。

= class Shell < Object

Shellオブジェクトはカレントディレクトリを持ち, 
コマンド実行はそこからの相対パスになります.

== Class Methods

#@#=== コマンド定義
#@#OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
#@#注) コマンドを定義しなくとも直接実行できるShell#systemコマンドもあります.

--- def_system_command(command, path = command) -> nil

Shellのメソッドとしてcommandを登録します.

OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
注) コマンドを定義しなくとも直接実行できるShell#systemコマンドもあります.

@param command Shell のメソッドとして定義するコマンドを文字列で指定します。

@param path command のパスを指定します。
            指定しない場合はcommand と同じになります。

例)
  Shell.def_system_command "ls"
  # ls を定義

  Shell.def_system_command "sys_sort", "sort"
  # sortコマンドをsys_sortとして定義

  sh = Shell.new
  sh.transact {
    ls.each { |l|
      puts l
    }
    (ls("-l") | sys_sort("-k 5")).each {|l|
      puts l
    }
  }


--- undef_system_command(command) -> Shell::CommandProcessor

commandを削除します.

@param command 削除するコマンドの文字列を指定します。

動作例：
  Shell.def_system_command("ls")
  # ls を定義
  Shell.undef_system_command("ls")
  # ls を 削除

  sh = Shell.new
  begin
    sh.transact {
      ls("-l").each {|l|
        puts l
      }
    }
  rescue NameError => err
    puts err
  end

--- alias_command(alias, command, *opts) {...} -> self

コマンドの別名(エイリアス)を作成します。
コマンドが無い場合は、[[m:Shell.def_system_command]] などであらかじめ作成します.

@param alias エイリアスの名前を文字列で指定します.

@param command コマンド名を文字列で指定します.

@param *opts command で指定したコマンドのオプションを指定します.

使用例: ls -la | sort -k 5 のような例。

  Shell.def_system_command("ls")
  Shell.alias_command("lsla", "ls", "-a", "-l")
  Shell.def_system_command("sort")
  sh = Shell.new
  sh.transact {
    (lsla | sort("-k 5")).each {|l|
      puts l
    }
  }

--- unalias_command(alias) -> ()

commandのaliasを削除します.

@param alias 削除したいエイリアスの名前を文字列で指定します。

@raise NameError alias で指定したコマンドが無い場合に発生します。

使用例: ls -la | sort -k 5 のような例。
  Shell.def_system_command("ls")
  Shell.alias_command("lsla", "ls", "-a", "-l")
  Shell.def_system_command("sort")
  sh = Shell.new
  sh.transact {
    (lsla | sort("-k 5")).each {|l|
      puts l
    }
  }
  Shell.unalias_command("lsla")
  begin
    Shell.unalias_command("lsla")
  rescue NameError => err
    puts err
  end

--- install_system_commands(pre = "sys_") -> ()

system_path上にある全ての実行可能ファイルをShellに定義する. メソッ
ド名は元のファイル名の頭にpreをつけたものとなる.

@param pre Shellに定義するメソッド名の先頭に付加される文字列を指定します。

使用例: ls -l | head -n 5 のような例。

  Shell.install_system_commands
  sh = Shell.new
  sh.verbose = false
  sh.transact {
    (sys_ls("-l") | sys_head("-n 5")).each {|l|
      puts l
    } 
  }

#@since 1.9.0
--- new(pwd = Dir.pwd, umask = nil) -> Shell

プロセスのカレントディレクトリをpwd で指定されたディレクトリとするShellオ
ブジェクトを生成します.

@param pwd プロセスのカレントディレクトリをpwd で指定されたディレクトリとします。
           指定しない場合は、[[m:Dir.pwd]] が使用されます。

@param umask ファイル作成の際に用いられる umask を使用します。


#@else
--- new -> Shell

プロセスのカレントディレクトリをカレントディレクトリとするShellオ
ブジェクトを生成します.

使用例：カレントディレクトリを表示

  sh = Shell.new
  puts sh.pwd.to_s

#@end

#@since 1.9.0

--- cd(path = nil, verbose = self.verbose) -> self

pathをカレントディレクトリとするShellオブジェクトを生成します.

@param path カレントディレクトリとするディレクトリを文字列で指定します。

@param verbose true を指定すると冗長な出力を行います。

#@else
--- cd(path = nil) -> self

pathをカレントディレクトリとするShellオブジェクトを生成します.

@param path カレントディレクトリとするディレクトリを文字列で指定します。

#@end

使用例
  require 'shell'
  sh = Shell.new
  sh.cd("/tmp")


--- debug -> bool | Integer
--- debug? -> bool | Integer
--- debug=(val) 

デバッグ用のフラグの設定および、参照を行います。

@param val bool 値や整数値を指定します。詳細は下記を参照してください。

  # debug: true -> normal debug
  # debug: 1    -> eval definition debug
  # debug: 2    -> detail inspect debug

--- default_record_separator -> String
--- default_record_separator=(rs)

執筆者募集

Shell で用いられる入力レコードセパレータを表す文字列を設定および参照します。
なにも指定しない場合は[[m:$/]] の値が用いられます。

@param rs Shell で用いられる入力レコードセパレータを表す文字列を指定します。


--- default_system_path -> Array
--- default_system_path=(path)

Shellでもちいられるコマンドを検索する対象のパスを設定および、参照します。

@param path Shellでもちいられるコマンドを検索する対象のパスを文字列で指定します。

動作例
  require 'shell'
  p Shell.default_system_path 
  # 例
  #=> [ "/opt/local/bin", "/opt/local/sbin", "/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/X11/bin", "/Users/kouya/bin"]
  Shell.default_system_path = ENV["HOME"] + "/bin"
  p Shell.default_system_path
  # => "/Users/kouya/bin"

--- verbose -> bool  
--- verbose? -> bool
--- verbose=(flag)

true ならば冗長な出力の設定を行います。

@param flag true ならば冗長な出力の設定を行います。

== Instance Methods
#@#=== プロセス管理

--- cwd -> String
--- dir -> String
--- getwd -> String
--- pwd -> String

カレントディレクトリのパスを文字列で返します。

使用例
  require 'shell'
  sh = Shell.new
  p sh.cwd 
  # 例
  #=> "/Users/kouya/tall"


--- system_path -> Array 
--- system_path=(path)
コマンドサーチパスの配列を返す。

@param path コマンドサーチパスの配列を指定します。

使用例

  require 'shell'
  sh = Shell.new
  sh.system_path = [ "./" ]
  p sh.system_path #=> ["./"]

--- umask -> object

umaskを返します。

--- jobs -> Array

執筆者募集. スケジューリングされているjobの一覧を返す.

--- kill(sig, job)
#@todo

執筆者募集. jobにシグナルsigを送る.

#@#=== カレントディレクトリ操作

--- cd(path, &block) -> self
--- chdir(path, &block) -> self

カレントディレクトリをpathにする. イテレータとして呼ばれたときには
ブロック実行中のみカレントディレクトリを変更する.

@param path カレントディレクトリを文字列で指定します.  

@param block path で指定したディレクトリで行う操作をブロックで指定します.

使用例
  require 'shell'
  sh = Shell.new
  sh.transact {
    cd("/tmp"){
      p cwd #=> "/tmp"
    }
    p cwd #=> "/Users/kouya/rbmanual"
  }

--- pushd(path = nil, &block) -> object
--- pushdir(path = nil, &block) -> object

カレントディレクトリをディレクトリスタックにつみ, カレントディレク
トリをpathにする. pathが省略されたときには, カレントディレクトリと
ディレクトリスタックのトップを交換する. イテレータとして呼ばれたと
きには, ブロック実行中のみpushdする.

@param path  カレントディレクトリをpathにする。文字列で指定します。

@param block イテレータとして呼ぶ場合, ブロックを指定します。
 
動作例
  require 'shell'
  Shell.verbose = false
  sh = Shell.new
  sh.pushd("/tmp")
  p sh.cwd #=> "/tmp"
  sh.pushd("/usr")
  p sh.cwd #=> "/usr"
  sh.popd
  p sh.cwd #=> "/tmp"
  sh.pushd("/usr/local"){
    p sh.cwd #=> "/usr/local"
  }
  p sh.cwd #=> "/tmp"

--- popd -> ()
--- popdir -> ()

ディレクトリスタックからポップし, それをカレントディレクトリにする.

動作例
  require 'shell'
  Shell.verbose = false
  sh = Shell.new
  sh.pushd("/tmp")
  p sh.cwd #=> "/tmp"
  sh.pushd("/usr")
  p sh.cwd #=> "/usr"
  sh.popd
  p sh.cwd #=> "/tmp"

#@#=== ファイル/ディレクトリ操作
--- foreach(path = nil, &block) -> ()

pathがファイルなら, File#foreach
pathがディレクトリなら, Dir#foreach
の動作をします。

@param path ファイルもしくはディレクトリのパスを文字列で指定します。

使用例
  require 'shell'
  Shell.verbose = false
  sh = Shell.new
  sh.foreach("/tmp"){|f|
    puts f
  }

--- open(path, mode) -> object

pathがファイルなら, File#open
pathがディレクトリなら, Dir#open
の動作をします。

@param path くわしくは、[[m:File.open]], [[m:Dir.open]]を参照してください。

@param mode くわしくは、[[m:File.open]], [[m:Dir.open]]を参照してください。

--- unlink(path) -> self

pathがファイルなら, File#unlink
pathがディレクトリなら, Dir#unlink
の動作をします。

@param path くわしくは、[[m:File.unlink]], [[m:Dir.unlink]]を参照してください。

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


