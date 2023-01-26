category Thread

タイムアウトを行うライブラリです。

= reopen Kernel

== Private Instance Methods

--- timeout(sec) {|i| .... }                        -> object
--- timeout(sec, exception_class = nil) {|i| .... } -> object

ブロックを sec 秒の期限付きで実行します。
ブロックの実行時間が制限を過ぎたときは例外
[[c:Timeout::Error]] が発生します。

exception_class を指定した場合には [[c:Timeout::Error]] の代わりに
その例外が発生します。
ブロックパラメータ i は sec がはいります。

また sec が 0 もしくは nil のときは制限時間なしで
ブロックを実行します。

@param sec タイムアウトする時間を秒数で指定します.
@param exception_class タイムアウトした時、発生させる例外を指定します.

=== 注意

timeout による割り込みは Thread によって実現されています。C 言語
レベルで実装され、Ruby のスレッドが割り込めない処理に対して
timeout は無力です。
そのような
ものは実用レベルでは少ないのですが、例をあげると Socket などは
DNSの名前解決に時間がかかった場合割り込めません
([[lib:resolv-replace]] を使用する必要があります)。
その処理を Ruby で実装しなおすか C 側で Ruby
のスレッドを意識してあげる必要があります。
#@# [[unknown:timeoutの落し穴|trap::timeout]]も参照

= module Timeout

タイムアウトを行うためのモジュールです。

== Module Functions

#@since 2.4.0
--- timeout(sec, exception_class = nil)    {|i| ... }  -> object
--- timeout(sec, exception_class, message) {|i| ... }  -> object
#@else
--- timeout(sec, exception_class = nil) {|i| ... }  -> object
#@end

ブロックを sec 秒の期限付きで実行します。
ブロックの実行時間が制限を過ぎたときは例外
[[c:Timeout::Error]] が発生します。

exception_class を指定した場合には [[c:Timeout::Error]] の代わりに
その例外が発生します。
ブロックパラメータ i は sec がはいります。

また sec が 0 もしくは nil のときは制限時間なしで
ブロックを実行します。

@param sec タイムアウトする時間を秒数で指定します.
@param exception_class タイムアウトした時、発生させる例外を指定します.
#@since 2.4.0
@param message エラーメッセージを指定します.省略した場合は
               "execution expired" になります.
#@end

例 長い計算のタイムアウト
  require 'timeout'

  def calc_pi(min)
    loop do
      x = rand
      y = rand
      x**2 + y**2 < 1.0 ?  min[0] += 1 : min[1] += 1
    end
  end
 
  t = 5
  min = [ 0, 0]
  begin
    Timeout.timeout(t){
      calc_pi(min)
    }
  rescue Timeout::Error
    puts "timeout"
  end

  printf "%d: pi = %f\n", min[0] + min[1], min[0]*4.0/(min[0]+min[1])
  #例
  #=> 417519: pi = 3.141443

例 独自の例外を発生させるタイムアウト
  #!/usr/bin/env ruby

  require 'timeout'

  class MYError < Exception;end
  begin
    Timeout.timeout(5, MYError) {
      sleep(30)
    }
  rescue MYError => err
    puts "MYError"
    puts err
  end

=== 注意

timeout による割り込みは Thread によって実現されています。
C 言語レベルで実装され、
Ruby のスレッドが割り込めない処理に対して timeout は無力です。
そのようなものは実用レベルでは少ないのですが、
Socket などは DNSの名前解決に時間がかかった場合割り込めません
([[lib:resolv-replace]] を使用する必要があります)。
その処理を Ruby で実装しなおすか C 側で Ruby
のスレッドを意識してあげる必要があります。

以下の例では、gethostbyname(およそ0.6秒処理に時間がかかっている) が終了した直後((A)の箇所)で TimeoutError 例外があがっています。

例 timeout が割り込めない
  require 'timeout'
  require 'socket'

  t = 0.1
  start = Time.now
  begin
    Timeout.timeout(t) {
      p TCPSocket.gethostbyname("www.ruby-lang.org")
      # (A)
    }
  ensure
    p Time.now - start
  end
  # 実行例
  => ["helium.ruby-lang.org", [], 2, "210.251.121.214"]
     0.689331
     /usr/local/lib/ruby/1.6/timeout.rb:37: execution expired (TimeoutError)
           from -:6:in `timeout'
           from -:6
  # gethostbyname が0.1秒かからない場合は例外が発生しないので
  # その場合は、t に小さい数値(0.000001のような)に変える。

#@#[[unknown:timeoutの落し穴|trap::timeout]]も参照
#@# unknown なので、ここに少し変えてコピペした。

timeout による割り込みは [[m:Kernel.#system]] によって呼び出された外部プログラムを
タイムアウトさせる事はできないので、[[m:IO.popen]]、[[m:Kernel.#open]]を使用するなどの工夫が必要です。

例 外部コマンドのタイムアウト
  require 'timeout'

  # テスト用のシェルをつくる。
  File.open("loop.sh", "w"){|fp|
    fp.print <<SHELL_EOT
  #!/bin/bash

  S="scale=10"
  M=32767

  trap 'echo "$S; $m1/($m1+$m2)*4" | bc ; echo "count = $((m1+m2))" ; exit 0' INT
  m1=0
  m2=0

  while true
  do
    x="($RANDOM/$M)"
    y="($RANDOM/$M)"
    c=$(echo "$S;$x^2+$y^2 < 1.0" | bc)
    echo $x $y $c
    if [ $c -eq 1 ]
    then
      let m1++
    else
      let m2++
    fi
  done
  SHELL_EOT
  }

  File.chmod(0755, "loop.sh")
  t = 10 # 10 秒でタイムアウト
  begin
    pid = nil
    com = nil
    Timeout.timeout(t) {
      # system だととまらない
      # system("./loop.sh")
      com = IO.popen("./loop.sh")
      pid = com.pid
      while line = com.gets
        print line
      end
    }
  rescue Timeout::Error => err
    puts "timeout: shell execution."
    Process.kill('SIGINT', pid)
    printf "[result]\t%s", com.read
    com.close unless com.nil?
  end
#@# もっといい止め方があるかもしれない。

  #止まっているか確認する。
  #system("ps au")

#@# 内部用なのでコメントアウト
#@# == Constants
#@# --- THIS_FILE
#@# --- CALLER_OFFSET

#@since 1.9.1
= class Timeout::Error < RuntimeError
#@else
= class Timeout::Error < Interrupt
#@end
alias TimeoutError

[[lib:timeout]] で定義される例外クラスです。
関数 timeout がタイムアウトすると発生します。

[[lib:timeout]] を使うライブラリを作成する場合は、ユーザが指定した
timeout を捕捉しないようにライブラリ内で [[c:TimeoutError]] のサブクラスを
定義して使用した方が無難です。
#@#((-注: version 1.6 では、[[unknown:ruby-list:33352]] のパッチが必要です。
#@#このパッチは 1.7 に取り込まれました[[unknown:ruby-list:33391]]-))

        ==> foo.rb <==
        require 'timeout.rb'
        class Foo
          FooTimeoutError = Class.new(TimeoutError)
          def longlongtime_method
            Timeout.timeout(100, FooTimeoutError) {
               ...
            }
          end
        end

        ==> main.rb <==
        require 'foo'
        timeout(5) {
          Foo.new.longlongtime_method
        }

#@# nodoc
#@# = class Timeout::ExitException < Exception
