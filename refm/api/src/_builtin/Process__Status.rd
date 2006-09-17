#@if (version >= "1.7.0")
= module Process::Status

((<ruby 1.7 feature>))
[[m:Process#Process.wait]] などで生成されるオブジェクト。プロセスの終
了ステータスを表現します。

使用例

wait を使用した例

  fork { exit }
  Process.wait
  case
  when $?.signaled?
    p "child #{$?.pid} was killed by signal #{$?.termsig}"
  when $?.stopped?
    # 実際には Process.wait を使用しているので、ここに来ることはない
    p "child #{$?.pid} was stopped by signal #{$?.stopsig}"
  when $?.exited?
    p "child #{$?.pid} exited normaly. status=#{$?.exitstatus}"
  when $?.coredump?   # システムがこのステータスをサポートしてなければ常にfalse
    p "child #{$?.pid} dumped core."
  else
    p "unknown status %#x" % $?.to_i
  end

SIGCHLD を trap する例

  trap(:SIGCHLD) {|sig|

    puts "interrupted by signal #{sig} at #{caller[1]}"
    # 複数の子プロセスの終了に対して1つの SIGCHLD しか届かない
    # 場合があるのでループさせる必要があります

    while Process.waitpid(-1, Process::WNOHANG|Process::WUNTRACED)
      case
      when $?.signaled?
        puts "   child #{$?.pid} was killed by signal #{$?.termsig}"
      when $?.stopped?
        puts "   child #{$?.pid} was stopped by signal #{$?.stopsig}"
      when $?.exited?
        puts "   child #{$?.pid} exited normaly. status=#{$?.exitstatus}"
      when $?.coredump?
        puts "   child #{$?.pid} dumped core."
      else
        p "unknown status %#x" % $?.to_i
      end
    end
  }

  p pid1 = fork { sleep 1; exit }
  p pid2 = fork { loop { sleep } } # signal を待つための sleep
  begin
     Process.kill :STOP, pid2
     sleep                      # SIGCHLD を待つための sleep
     Process.kill :CONT, pid2
     Process.kill :TERM, pid2
     loop { sleep }             # SIGCHLD を待つための sleep
  rescue Errno::ECHILD
    puts "done"
  end

  => 12964
     12965
     interrupted by signal 17 at -:27:in `sleep'
        child 12965 was stopped by signal 19
     interrupted by signal 17 at -:30:in `sleep'
        child 12965 was killed by signal 15
     interrupted by signal 17 at -:30:in `sleep'
        child 12964 exited normaly. status=0
     done


== Instance Methods

--- ==(other)

同じステータスの場合に真を返します。

other が数値の場合、self.to_i との比較が行われます。こ
れは後方互換性のためです。

--- &(other)

to_i & other と同じです。

このメソッドは後方互換性のためにあります。

--- pid

終了したプロセスのプロセス ID を返します。

--- to_i

C 言語での終了ステータス表現の整数を返します。

多くのシステムの実装では、この値の上位 8 bit に [[man:exit(2)]]
に渡した終了ステータスが、下位 8 bit にシグナル等で終了した等の情
報が入っています。

--- to_int

to_i と同じです。このメソッドにより $? が [[c:Fixnum]]
として扱われるようになります(暗黙の型変換)。これは後方互換性のため
です。

  fork { exit 1 }
  Process.wait
  p $? # => 256

--- to_s

to_i.to_s と同じです。

--- exited?

プロセスが [[man:exit(2)]] により自分で終了した(他のプロ
セスに止められたのではない)場合、真を返します。

--- exitstatus

exited? が真の場合プロセスが返した終了ステータスの整数を、そ
うでない場合は nil を返します。

--- inspect

プロセスの状態を以下のフォーマットで出力します。

    正常終了のとき

    #<Process::Status: pid=18262,exited(nnn)>

    シグナルによる停止のとき

    #<Process::Status: pid=18262,stopped(SIGxxx=nnn)>

    シグナルによる終了のとき

    #<Process::Status: pid=18262,signaled(SIGxxx=nnn)>

    コアダンプしたとき(このステータスの表示はシステムに依存します)

    #<Process::Status: pid=18262,coredumped>


--- stopped?

プロセスが現在停止(終了ではない)している場合に真を返します。
Process.waitpid に Process::WUNTRACED フラグを設定した
場合にだけ真になりえます。

--- stopsig

stopped? が真の場合そのシグナルの番号を、そうでない場合は
nil を返します。

--- signaled?

プロセスがハンドラを定義していないシグナルを受けて終了した場合に真
を返します。

--- termsig

signaled? が真の場合プロセスを終了させたシグナル番号を、
そうでない場合は nil を返します。

--- coredump?

終了時にコアダンプしていたら真を返します。

(このメソッドはシステムに依存します。サポートしないプラットフォー
ムでは常に false を返します)

#@end