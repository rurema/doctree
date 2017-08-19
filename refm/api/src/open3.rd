category I/O

プログラムを実行し、そのプロセスの標準入力・標準出力・
標準エラー出力にパイプをつなぎます。

= module Open3

プログラムを実行し、そのプロセスの標準入力・標準出力・
標準エラー出力にパイプをつなぎます。

=== 使用例

nroff を実行してその標準入力に man ページを送り込み処理させる。
nroff プロセスの標準出力から処理結果を受け取る。

  require "open3"

  stdin, stdout, stderr = *Open3.popen3('nroff -man')
  # こちらから書く
  Thread.fork {
    File.foreach('/usr/man/man1/ruby.1') do |line|
      stdin.print line
    end
    stdin.close    # または close_write
  }
  # こちらから読む
  stdout.each do |line|
    print line
  end

== Module Functions

#@since 1.9.2
--- popen3(*cmd) -> [IO, IO, IO, Thread]
--- popen3(*cmd) {|stdin, stdout, stderr, wait_thr| ... } -> ()

外部プログラム cmd を実行し、そのプロセスの標準入力、標準出力、標準エラー
出力に接続されたパイプと実行したプロセスを待つためのスレッドを 4 要素の
配列で返します。

  require 'open3'
  stdin, stdout, stderr, wait_thr = *Open3.popen3("/usr/bin/nroff -man")

@param cmd 実行するコマンドを指定します。

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は標準入力、標準出力、標準エラー出
        力と実行したプロセスを待つためのスレッドに接続されたパイプを返
        します。

ブロックを指定するとパイプの配列を引数にブロックを実行し、最後にパイプ
を close します。この場合はブロックの最後の式の結果を返します。

  require 'open3'

  Open3.popen3("read stdin; echo stdout; echo stderr >&2") {|stdin, stdout, stderr, wait_thr|
    stdin.puts "stdin"
    stdin.close     # または close_write
    p stdout.read
    p stderr.read
  }
  #=> "stdout\n"
      "stderr\n"

#@else
--- popen3(*cmd) -> [IO, IO, IO]
--- popen3(*cmd) {|stdin, stdout, stderr| ... } -> ()

外部プログラム cmd を実行し、そのプロセスの標準入力、
標準出力、標準エラー出力に接続されたパイプを 3 要素の配列で返します。
cmd は組み込み関数 [[m:Kernel.#exec]] と同じ規則で解釈されます。

  require 'open3'
  stdin, stdout, stderr = *Open3.popen3("/usr/bin/nroff -man")

@param cmd 実行するコマンドを指定します。

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は標準入力、標準出力、標準エラー
        を返します。

ブロックを指定するとパイプの配列を引数にブロックを実行し、最後にパイプ
を close します。この場合はブロックの最後の式の結果を返します。

  require 'open3'

  Open3.popen3("read stdin; echo stdout; echo stderr >&2") {|stdin, stdout, stderr|
    stdin.puts "stdin"
    stdin.close     # または close_write
    p stdout.read
    p stderr.read
  }
  #=> "stdout\n"
      "stderr\n"

#@end

stdin への入力が終わったらできる限り早く close か close_write
で閉じるべきです。

[UNIX系OS固有の注意] Open3 で作成した子プロセスは
[[man:wait(2)]] しなくてもゾンビになりません。

#@since 1.9.1
引数 cmd はそのまま [[m:Kernel.#spawn]] に渡されます。
[[m:Kernel.#spawn]]と同様に、引数リストの最初に環境変数をハッシュ形式で
指定する事ができます。

例:

  require 'open3'

  Open3.popen3({"foo" => "1", "bar" => "2"}, "env") {|i, o, e, t|
    i.close
    print o.read
  }
  #=> ...
      foo=1
      bar=2

[[m:Kernel.#spawn]]と同様に、引数リストの最後にオプションをハッシュ形式
で指定する事ができます。

例:

  require "open3"
  
  # オプションを指定した場合。
  Dir.chdir("/tmp")
  Open3.popen3("pwd", :chdir=> "/") {|i,o,e,t|
    p o.read.chomp #=> "/"
  }
  
  # オプションを指定しない場合。
  Dir.chdir("/tmp")
  Open3.popen3("pwd") {|i,o,e,t|
    p o.read.chomp #=> "/tmp"
  }

@see [[m:Kernel.#spawn]]
#@else
コマンドは実際には孫プロセスとして動作するため、組み込み変数 [[m:$?]] でコマンドの終了ステータスを得ることはできません。
#@#終了ステータスがほしいひとは、((<POpen4|URL:http://popen4.rubyforge.org/>)) を試してみるといいかもしれません。
#@end

#@since 1.9.2

--- popen2(*cmd) -> [IO, IO, Thread]
--- popen2(*cmd) {|stdin, stdout, wait_thr| ... } -> ()

cmdで指定されたコマンドを実行し、そのプロセスの標準入力・標準出力にパイ
プをつなぎます。Open3.popen3に似ていますが、標準エラーを扱いません。

@param cmd 実行するコマンドを指定します。

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は標準入力、標準出力に接続されたパ
        イプと実行したプロセスを待つためのスレッドを返します。

[[m:Open3.#popen3]]と同様に引数に環境変数とオプションを指定してコマンド
を実行する事ができます。

@see [[m:Open3.#popen3]]

--- popen2e(*cmd) -> [IO, IO, Thread]
--- popen2e(*cmd) {|stdin, stdout_and_stderr, wait_thr| ... } -> ()

cmdで指定されたコマンドを実行し、そのプロセスの標準入力・標準出力と標準
エラーにパイプをつなぎます。Open3.popen3に似ていますが、標準出力と標準
エラーが1つの変数で扱われます。

@param cmd 実行するコマンドを指定します。

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は標準入力、標準出力と標準エラーに
        接続されたパイプと実行したプロセスを待つためのスレッドを返しま
        す。

[[m:Open3.#popen3]]と同様に引数に環境変数とオプションを指定してコマンド
を実行する事ができます。

@see [[m:Open3.#popen3]]

--- capture3(*cmd) -> [String, String, Process::Status]

cmdで指定されたコマンドを実行し、そのプロセスの標準出力と標準エラー、プ
ロセスの終了ステータスを表すオブジェクトを返します。

@param cmd 実行するコマンドを指定します。

@return 実行したコマンドの標準出力と標準エラー、プロセスの終了ステータ
        スを表すオブジェクトを配列で返します。

指定された引数はopts[:stdin_data]とopts[:binmode]以外は全て
[[m:Open3.#popen3]]に渡されます。opts[:stdin_data]は実行するコマンドの
標準出力に渡されます。opts[:binmode]を真に指定されると内部で使用される
パイプをバイナリモードに指定します。

例:

  require "open3"
  
  o, e, s = Open3.capture3("echo a; sort >&2", :stdin_data=>"foo\nbar\nbaz\n")
  p o #=> "a\n"
  p e #=> "bar\nbaz\nfoo\n"
  p s #=> #<Process::Status: pid 32682 exit 0>

[[m:Open3.#popen3]]と同様に引数に環境変数とオプションを指定してコマンド
を実行する事ができます。

@see [[m:Open3.#popen3]]

--- capture2(*cmd) -> [String, Process::Status]

cmdで指定されたコマンドを実行し、そのプロセスの標準出力とプロセスの終了
ステータスを表すオブジェクトを返します。

@param cmd 実行するコマンドを指定します。

@return 実行したコマンドの標準出力と終了ステータスを表すオブジェクトを
        配列で返します。

指定された引数はopts[:stdin_data]とopts[:binmode]以外は全て
[[m:Open3.#popen3]]に渡されます。opts[:stdin_data]は実行するコマンドの
標準出力に渡されます。opts[:binmode]を真に指定されると内部で使用される
パイプをバイナリモードに指定します。

例:

  require "open3"
  
  # factorコマンドで与えられた数値(42)を素因数分解する。
  o, s = Open3.capture2("factor", :stdin_data=>"42")
  p o #=> "42: 2 3 7\n"

[[m:Open3.#popen3]]と同様に引数に環境変数とオプションを指定してコマンド
を実行する事ができます。

@see [[m:Open3.#popen3]]

--- capture2e(*cmd) -> [String, Process::Status]

cmdで指定されたコマンドを実行し、そのプロセスの標準出力と標準エラーを1
つの文字列にしたものとプロセスの終了ステータスを表すオブジェクトを返し
ます。

@param cmd 実行するコマンドを指定します。

@return 実行したコマンドの標準出力と標準エラーを1つの文字列にしたものと
        終了ステータスを表すオブジェクトを配列で返します。

指定された引数はopts[:stdin_data]とopts[:binmode]以外は全て
[[m:Open3.#popen3]]に渡されます。opts[:stdin_data]は実行するコマンドの
標準出力に渡されます。opts[:binmode]を真に指定されると内部で使用される
パイプをバイナリモードに指定します。

例:

  require "open3"
  
  o, s = Open3.capture2e("echo a; sort >&2", :stdin_data=>"foo\nbar\nbaz\n")
  p o #=> "a\nbar\nbaz\nfoo\n"
  p s #=> #<Process::Status: pid 20574 exit 0>

[[m:Open3.#popen3]]と同様に引数に環境変数とオプションを指定してコマンド
を実行する事ができます。

@see [[m:Open3.#popen3]]

--- pipeline_rw(*cmds) -> [IO, IO, [Thread]]
--- pipeline_rw(*cmds) {|first_stdin, last_stdout, wait_thrs| ... } -> ()

指定したコマンドのリストをパイプで繋いで順番に実行します。最初の
コマンドの標準入力に書き込む事も最後のコマンドの標準出力を受けとる事も
できます。

@param cmds 実行するコマンドのリストを指定します。それぞれのコマンドは
            以下のように [[c:String]] か [[c:Array]] で指定します。
            commandline にはコマンド全体(例. "nroff -man")を表す
            [[c:String]] を指定します。
            options には [[c:Hash]] で指定します。
            env には環境変数を [[c:Hash]] で指定します。
            cmdname にはコマンド名を表す [[c:String]] を指定します。
            1、2、3 は shell 経由で実行されます。

 (1) commandline
 (2) [commandline, options]
 (3) [env, commandline, options]
 (4) [env, cmdname, arg1, arg2, ..., options]
 (5) [env, [cmdname, argv0], arg1, ..., options]

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は最初に実行するコマンドの標準入力
        と最後に実行するコマンドの標準出力、実行したプロセスを待つため
        のスレッドの配列を配列で返します。

例:

  require "open3"
  
  Open3.pipeline_rw("sort", "cat -n") {|stdin, stdout, wait_thrs|
    stdin.puts "foo"
    stdin.puts "bar"
    stdin.puts "baz"
    
    # sortコマンドにEOFを送る。
    stdin.close
    
    # stdinに渡した文字列をsortコマンドが並べ替えたものに、catコマンド
    # が行番号を付けた文字列が表示される。
    p stdout.read   #=> "     1\tbar\n     2\tbaz\n     3\tfoo\n"
  }

@see [[m:Open3.#popen3]]

--- pipeline_r(*cmds) -> [IO, [Thread]]
--- pipeline_r(*cmds) {|last_stdout, wait_thrs| ... } -> ()

指定したコマンドのリストをパイプで繋いで順番に実行します。最後の
コマンドの標準出力を受けとる事ができます。

@param cmds 実行するコマンドのリストを指定します。それぞれのコマンドは
            以下のように [[c:String]] か [[c:Array]] で指定します。
            commandline にはコマンド全体(例. "nroff -man")を表す
            [[c:String]] を指定します。
            options には [[c:Hash]] で指定します。
            env には環境変数を [[c:Hash]] で指定します。
            cmdname にはコマンド名を表す [[c:String]] を指定します。
            1、2、3 は shell 経由で実行されます。

 (1) commandline
 (2) [commandline, options]
 (3) [env, commandline, options]
 (4) [env, cmdname, arg1, arg2, ..., options]
 (5) [env, [cmdname, argv0], arg1, ..., options]

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は最後に実行するコマンドの標準出力、
        実行したプロセスを待つためのスレッドの配列を配列で返します。

例:

  require "open3"
  
  Open3.pipeline_r("yes", "head -10") {|r, ts|
    p r.read      #=> "y\ny\ny\ny\ny\ny\ny\ny\ny\ny\n"
    p ts[0].value #=> #<Process::Status: pid 24910 SIGPIPE (signal 13)>
    p ts[1].value #=> #<Process::Status: pid 24913 exit 0>
  }

@see [[m:Open3.#popen3]]

--- pipeline_w(*cmds) -> [IO, [Thread]]
--- pipeline_w(*cmds) {|first_stdin, wait_thrs| ... } -> ()

指定したコマンドのリストをパイプで繋いで順番に実行します。最初の
コマンドの標準入力に書き込む事ができます。

@param cmds 実行するコマンドのリストを指定します。それぞれのコマンドは
            以下のように [[c:String]] か [[c:Array]] で指定します。
            commandline にはコマンド全体(例. "nroff -man")を表す
            [[c:String]] を指定します。
            options には [[c:Hash]] で指定します。
            env には環境変数を [[c:Hash]] で指定します。
            cmdname にはコマンド名を表す [[c:String]] を指定します。
            1、2、3 は shell 経由で実行されます。

 (1) commandline
 (2) [commandline, options]
 (3) [env, commandline, options]
 (4) [env, cmdname, arg1, arg2, ..., options]
 (5) [env, [cmdname, argv0], arg1, ..., options]

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は最初に実行するコマンドの標準入力、
        実行したプロセスを待つためのスレッドの配列を配列で返します。

例:

  require "open3"
  
  Open3.pipeline_w("bzip2 -c", :out=>"/tmp/hello.bz2") {|w, ts|
    w.puts "hello"
  }

@see [[m:Open3.#popen3]]

--- pipeline_start(*cmds) -> [Thread]
--- pipeline_start(*cmds) {|wait_thrs| ... } -> ()

指定したコマンドのリストをパイプで繋いで順番に実行します。

@param cmds 実行するコマンドのリストを指定します。それぞれのコマンドは
            以下のように [[c:String]] か [[c:Array]] で指定します。
            commandline にはコマンド全体(例. "nroff -man")を表す
            [[c:String]] を指定します。
            options には [[c:Hash]] で指定します。
            env には環境変数を [[c:Hash]] で指定します。
            cmdname にはコマンド名を表す [[c:String]] を指定します。
            1、2、3 は shell 経由で実行されます。

 (1) commandline
 (2) [commandline, options]
 (3) [env, commandline, options]
 (4) [env, cmdname, arg1, arg2, ..., options]
 (5) [env, [cmdname, argv0], arg1, ..., options]

@return ブロックを指定した場合はブロックの最後に評価された値を返します。
        ブロックを指定しなかった場合は実行したプロセスを待つためのスレッ
        ドの配列を返します。

例:

  require "open3"
  
  # xeyesを10秒だけ実行する。
  Open3.pipeline_start("xeyes") {|ts|
    sleep 10
    t = ts[0]
    Process.kill("TERM", t.pid)
    p t.value #=> #<Process::Status: pid 911 SIGTERM (signal 15)>
  }

@see [[m:Open3.#popen3]]

--- pipeline(*cmds) -> [Process::Status]

指定したコマンドのリストをパイプで繋いで順番に実行します。

@param cmds 実行するコマンドのリストを指定します。それぞれのコマンドは
            以下のように [[c:String]] か [[c:Array]] で指定します。
            commandline にはコマンド全体(例. "nroff -man")を表す
            [[c:String]] を指定します。
            options には [[c:Hash]] で指定します。
            env には環境変数を [[c:Hash]] で指定します。
            cmdname にはコマンド名を表す [[c:String]] を指定します。
            1、2、3 は shell 経由で実行されます。

 (1) commandline
 (2) [commandline, options]
 (3) [env, commandline, options]
 (4) [env, cmdname, arg1, arg2, ..., options]
 (5) [env, [cmdname, argv0], arg1, ..., options]

@return 実行したコマンドの終了ステータスを配列で返します。

例1:

  require "open3"
  
  fname = "/usr/share/man/man1/ruby.1.gz"
  p Open3.pipeline(["zcat", fname], "nroff -man", "less")
  #=> [#<Process::Status: pid 11817 exit 0>,
  #    #<Process::Status: pid 11820 exit 0>,
  #    #<Process::Status: pid 11828 exit 0>]

例2:

  require "open3"

  Open3.pipeline([{"LANG"=>"C"}, "env"], ["grep", "LANG"], "less")

@see [[m:Open3.#popen3]]

#@end
