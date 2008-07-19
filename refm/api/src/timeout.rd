タイムアウトを行うライブラリ。

= class TimeoutError < Interrupt

[[c:Timeout::Error]]の別名です。

= reopen Kernel

== Private Instance Methods

#@since 1.8.0
--- timeout(sec) {|i| .... }
--- timeout(sec, exception_class = nil) {|i| .... }

ブロックを sec 秒の期限付きで実行します。
ブロックの実行時間が制限を過ぎたときは例外
[[c:Timeout::Error]] が発生します。
exception_class を指定した場合には [[c:Timeout::Error]] の代わりに
その例外が発生します。
ブロックパラメータ i は sec がはいります。

また sec が nil のときは制限時間なしで
ブロックを実行します。

@param sec タイムアウトする時間を秒数で指定します.
@param exception_class タイムアウトした時、発生させる例外を指定します.

[注意]

timeout による割り込みは Thread によって実現されています。C 言語
レベルで実装され、Ruby のスレッドが割り込めない処理に対して
timeout は無力です。
そのような
ものは実用レベルでは少ないのですが、例をあげると Socket などは
DNSの名前解決に時間がかかった場合割り込めません
([[lib:resolv-replace]] を使用する必要があります)。
その処理を Ruby で実装しなおすか C 側で Ruby
のスレッドを意識してあげる必要があります。
[[unknown:timeoutの落し穴|trap::timeout]]も参照
#@end

= module Timeout

タイムアウトを行うためのモジュール。

== Module Functions

--- timeout(sec, exception_class = nil) {|i| ... }

ブロックを sec 秒の期限付きで実行します。
ブロックの実行時間が制限を過ぎたときは例外
[[c:Timeout::Error]] が発生します。
exception_class を指定した場合には [[c:Timeout::Error]] の代わりに
その例外が発生します。
ブロックパラメータ i は sec がはいります。

また sec が nil のときは制限時間なしで
ブロックを実行します。

@param sec タイムアウトする時間を秒数で指定します.
@param exception_class タイムアウトした時、発生させる例外を指定します.

例1
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
    timeout(t){
      calc_pi(min)
    }
  rescue Timeout::Error
    puts "timeout"
  end

  printf "%d: pi = %f\n", min[0] + min[1], min[0]*4.0/(min[0]+min[1])
  #例
  #=> 417519: pi = 3.141443

例2
  #!/usr/bin/env ruby

  require 'timeout'

  class MYError < Exception;end
  begin
    timeout(5, MYError) {
      sleep(30)
    }
  rescue MYError => err
    puts "MYError"
    puts err
  end

[注意]

timeout による割り込みは Thread によって実現されています。
C 言語レベルで実装され、
Ruby のスレッドが割り込めない処理に対して timeout は無力です。
そのようなものは実用レベルでは少ないのですが、
Socket などは DNSの名前解決に時間がかかった場合割り込めません
([[lib:resolv-replace]] を使用する必要があります)。
その処理を Ruby で実装しなおすか C 側で Ruby
のスレッドを意識してあげる必要があります。
[[unknown:timeoutの落し穴|trap::timeout]]も参照

#@#== Constants
#@#--- Error
#@#[[c:Timeout::Error]]

= class Timeout::Error < Interrupt

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
            timeout(100, FooTimeoutError) {
               ...
            }
          end
        end

        ==> main.rb <==
        require 'foo'
        timeout(5) {
          Foo.new.longlongtime_method
        }
