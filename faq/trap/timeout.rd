= timeout

* gethostbyname で timeout できない

  timeout は Thread で実現されているため、C レベルで停止してしまう
  (Threadの切替えが発生しない)処理に対しては効果がありません。

  以下の例では、gethostbyname(およそ0.6秒処理に時間がかかっている) が終了し
  た直後((A)の箇所)で TimeoutError 例外があがっています。

      require 'timeout'
      require 'socket'

      start = Time.now
      begin
        timeout(0.1) {
          p TCPSocket.gethostbyname("www.ruby-lang.org")
          # (A)
        }
      ensure
        p Time.now - start
      end

      => ["helium.ruby-lang.org", [], 2, "210.251.121.214"]
         0.689331
         /usr/local/lib/ruby/1.6/timeout.rb:37: execution expired (TimeoutError)
                from -:6:in `timeout'
                from -:6

  Rubyで書かれたリゾルバを利用するという回避策があります。
  (({require "resolv-replace"})) すると、(({resolv})) で定義された、
  リゾルバが利用されるようになります。

* Windows版 Ruby で timeout できない

  Win32版 ruby (((<Cygwin>))、((<MinGW>))、((<mswin32>)),
  ((<bccwin32>)))では、以下の場合も Thread の切替えが起こらないために 
  timeout できません。

      # Win32ネイティブ版(mingw, mswin32, bccwin32)

      require 'timeout'

      begin
        timeout(5) do
          $stdin.gets
        end
      rescue TimeoutError
        print "timeout\n"
      end

      # Cygwin版

      i = 0
      begin
        timeout(5) do
          while true
              puts (i+=1)
          end
        end
      rescue TimeoutError
        print "timeout\n"
      end

  ((<Win32ネイティブ版>))では、$stdin.gets が、((<Cygwin>))版 では、
  puts が Thread の切替えを発生させないようです。((-正確には cygwinで
  は ((<setitimer(2)|manual page>)) にバグがある(らしい)ため 
  Thread が切り替わらないようです。Cygwin版 ruby version 1.6.8 と 
  1.7.3 の最新では setitimer(2) を使わないようにすることでこの不具合が
  修正されました((<ruby-list:36058>)), ((<ruby 1.6 feature>))-))
