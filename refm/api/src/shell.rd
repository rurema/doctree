category CUI

require shell/error
require shell/command-processor
require shell/process-controller

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



= class Shell < Object
extend Exception2MessageMapper
include Shell::Error

Shell オブジェクトはカレントディレクトリを持ち, 
コマンド実行はそこからの相対パスになります.

== Class Methods

--- def_system_command(command, path = command) -> nil

Shell のメソッドとして command を登録します.

OS上のコマンドを実行するにはまず, Shellのメソッドとして定義します.
注) コマンドを定義しなくとも直接実行できる [[m:Shell#system]] コマンドもあります.

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

@param opts command で指定したコマンドのオプションを指定します.

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

#@since 1.9.1
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

#@since 1.9.1

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
#@todo

デバッグ用フラグを参照します。

--- debug=(val) 

デバッグ用のフラグを設定します。

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
#@todo

--- verbose=(flag)

true ならば冗長な出力の設定を行います。

@param flag true ならば冗長な出力の設定を行います。


--- cascade -> bool
#@todo

--- cascade=(flag)
#@todo

--- notify(*opts){|message| ... } -> String
#@todo

#@since 1.9.1
#@until 2.4.0
--- debug_output_exclusive_unlock{ ... } -> Mutex | nil
#@todo

@see [[m:Mutex#exclusive_unlock]]
#@end

--- debug_output_lock -> Mutex
#@todo

#@since 2.3.0
@see [[m:Thread::Mutex#lock]]
#@else
@see [[m:Mutex#lock]]
#@end

--- debug_output_locked? -> bool
#@todo

#@since 2.3.0
@see [[m:Thread::Mutex#locked?]]
#@else
@see [[m:Mutex#locked?]]
#@end

--- debug_output_synchronize
#@todo

#@since 2.3.0
@see [[m:Thread::Mutex#synchronize]]
#@else
@see [[m:Mutex#synchronize]]
#@end

--- debug_output_try_lock -> bool
#@todo

#@since 2.3.0
@see [[m:Thread::Mutex#try_lock]]
#@else
@see [[m:Mutex#try_lock]]
#@end

--- debug_output_unlock -> Mutex | nil
#@todo

#@since 2.3.0
@see [[m:Thread::Mutex#unlock]]
#@else
@see [[m:Mutex#unlock]]
#@end

#@end

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
#@todo

umaskを返します。

--- umask=(umask)
#@todo

--- jobs -> Array

スケジューリングされているjobの一覧を返します。

--- kill(signal, job) -> Integer
#@todo

ジョブにシグナルを送ります。

@param signal

@param job

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


#@# 組込みコマンド
#@include(shell/builtincommands)

--- expand_path(path) -> String

Fileクラスにある同名のクラスメソッドと同じです.

@param path ファイル名を表す文字列を指定します。

@see [[m:File.expand_path]]

--- verbose -> bool  
--- verbose? -> bool
#@todo

--- verbose=(flag)
#@todo

--- debug -> bool | Integer
--- debug? -> bool | Integer
#@todo

--- debug=(flag)
#@todo

--- dirs -> [String]
--- dir_stack -> [String]
#@todo

--- command_processor -> Shell::CommandProcessor
#@todo

--- process_controller -> Shell::ProcessController
#@todo

--- record_separator -> String
#@todo

--- record_separator=(rs)
#@todo


