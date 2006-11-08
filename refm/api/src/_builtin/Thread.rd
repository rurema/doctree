= class Thread < Object

Ruby のスレッドを表現するクラスです。

Thread を使うことで並行プログラミングが可能になります。スレッド
はメモリ空間を共有して同時に実行される制御の流れです。ただし、現在の実
装では Ruby インタプリタは時分割でスレッドを実行しますので、スレッドを
使うことで実行速度が速くなることはありません。

プログラムの開始と同時に生成されるスレッドを「メインスレッド」と呼
びます。なんらかの理由でメインスレッドが終了する時には、他の全てのスレッ
ドもプログラム全体も終了します。ユーザからの割込みによって発生した例外
はメインスレッドに送られます。

スレッドの起動時に指定したブロックの実行が終了するとスレッドの実行も終
了します。ブロックの終了は正常な終了も例外などによる異常終了も含みます。

Ruby のスレッドスケジューリングは優先順位付のラウンドロビンです。一定
時間毎、あるいは実行中のスレッドが権利を放棄したタイミングでスケジュー
リングが行われ、その時点で実行可能なスレッドのうち最も優先順位が高いも
のにコンテキストが移ります。

=== スレッドと例外

あるスレッドで例外が発生し、そのスレッド内で rescue で捕捉されなかっ
た場合、通常はそのスレッドだけがなにも警告なしに終了されます。ただ
しその例外で終了するスレッドを [[m:Thread#join]] で待っている他の
スレッドがある場合、その待っているスレッドに対して、同じ例外が再度
発生します。

  begin
    t = Thread.new do
      Thread.pass    # メインスレッドが確実にjoinするように
      raise "unhandled exception"
    end
    t.join
  rescue
    p $!  # => "unhandled exception"
  end

また、以下の 3 つの方法により、いずれかのスレッドが例外によって終
了した時に、インタプリタ全体を中断させるように指定することができま
す。

  * 組み込み変数 [[m:$DEBUG]] を真に設定する(デバッグモード)
    ruby インタプリタを [[unknown:Rubyの起動/-d]] 付きで起動した場合も同様。
  * [[m:Thread.abort_on_exception]] でフラグを設定する。
  * [[m:Thread#abort_on_exception]] で指定
    したスレッドのフラグを設定する。

上記3つのいずれかが設定されていた場合、インタプリタ全体が中断されます。

スレッドの状態

個々のスレッドは、以下の実行状態を持ちます。これらの状態は
[[m:Object#inspect]] や
[[m:Thread#status]] によって見ることができます。

 p Thread.new {sleep 1} # => #<Thread:0xa039de0 sleep>

: run (実行or実行可能状態)

生成されたばかりのスレッドや [[m:Thread#run]] や
[[m:Thread#wakeup]] で起こされたスレッドはこの状態です。
[[m:Thread#join]] でスレッドの終了を待っているスレッドもスレッドの
終了によりこの状態になります。

この状態のスレッドは「生きて」います。

: sleep (停止状態)

[[m:Thread.stop]] や [[m:Thread#join]] により停止されたスレッ
ドはこの状態になります。

この状態のスレッドは「生きて」います。

: aborting (終了処理中)

[[m:Thread#kill]] 等で終了されるスレッドは一時的にこの状態になりま
す。この状態から停止状態(stop)になることもあります。

この状態のスレッドはまだ「生きて」います。

: dead (終了状態)

[[m:Thread#kill]] 等で終了したスレッドはこの状態になります。この状
態のスレッドはどこからも参照されていなければ GC によりメモリ上から
なくなります。

この状態のスレッドは「死んで」います。

== Class Methods
--- abort_on_exception
--- abort_on_exception=(newstate)

真の時は、いずれかのスレッドが例外によって終了した時に、インタプリタ
全体を中断させます。デフォルトは偽、すなわち、通常あるスレッドで起こった例
外は、[[m:Thread#join]] などで検出されない限りそのスレッ
ドだけをなにも警告を出さずに終了させます。[[unknown:Thread#スレッドと例外]]に詳述。

参照の場合は真偽値を、代入形式では右辺 newstate を、返します。

--- critical
--- critical=(newstate)

真である間、スレッドの切替えを行いません。カレントスレッドが停止
(stop)した場合やシグナルに割り込まれた場合には、自動的に
false になります。

ただし、[[m:Thread.new]] によりスレッドを生成した場合にはそ
のスレッドは実行されます。また、[[m:Thread.pass]] により明
示的に切替えることもできます。

参照の場合は真偽値を、代入形式では右辺 newstate を、返します。

注意: I/O や GC、拡張ライブラリがからむとこのフラグは無視さ
れることもあります。排他制御を行うにはこのメソッドに頼らず
[[c:Mutex]] や [[c:Monitor]] を使うべきです。

--- current

現在実行中のスレッド(カレントスレッド)を返します。

--- exit

カレントスレッドの実行を終了します。

カレントスレッドを返します。

#@#((-あらい 2001-10-14:
#@#p (Thread.new { Thread.exit }.value)
#@#は、false を表示します。Thread.exit や Thread#kill ではス
#@#レッドの終了結果を設定していないためです
#@#[[unknown:ruby-dev:14904]]-))

カレントスレッドが唯一のスレッドであるなら、[[m:Kernel#exit]](0)
により終了します。

--- kill(thread)

指定したスレッドの実行を終了させます。既に終了しているスレッドに対
しては何もしません。

thread を返します。 exit と同様 Thread の終了結果を設定しません

--- list

生きているスレッドのうち、実行中(run)または停止中(stop)のスレッド
の配列を返します。

#@since 1.8.0
version 1.8 では、aborting 状態であるスレッド
も要素に含まれます。つまり「生きている」スレッドの配列を返します
#@end

--- main

メインスレッドを返します。

--- new([arg, ...]) { ... }
--- start([arg, ...]) { ... }
--- fork([arg, ...]) { ... }

スレッドを生成して、ブロックの評価を開始します。

引数はそのままブロックに渡されます。スレッドの開始と同時にその
スレッド固有のローカル変数に値を渡すために使用します。

生成したスレッドを返します。

例えば、以下のコードは間違いです。スレッドの実行が開始される前に
変数 i が書き変わる可能性があるからです。

  for i in 1..5
     Thread.start { p i }
  end

上の例は以下のように書き直すべきです。

  for i in 1..5
     Thread.start(i) {|t| p t }
  end

--- pass

他のスレッドに実行権を譲ります。実行中のスレッドの状態を変えずに、
他の実行可能状態のスレッドに制御を移します(明示的なスケジューリン
グ)。

nil を返します。

--- stop

他のスレッドから [[m:Thread#run]] メソッドで再起動されるまで、カレ
ントスレッドの実行を停止します。

nil を返します。

== Instance Methods

--- [](name)

name に対応したスレッドに固有のデータを取り出しま
す。name は文字列か [[c:Symbol]] で指定します。

name に対応するスレッド固有データがなければ nil を返し
ます。

--- []=(name,val)

val を name に対応するスレッド固有のデータとして格納し
ます。name は文字列か [[c:Symbol]] で指定します。
val に nil を指定するとそのスレッド固有データは削除さ
れます。

val を返します。

--- abort_on_exception
--- abort_on_exception=(newstate)

参照の場合は真偽値を、代入形式では右辺 newstate を、返します。

真の時は、そのスレッドが例外によって終了した時に、インタプリタ
全体を中断させます。デフォルトは偽です。[[m:Thread#スレッドと例外]]に詳述。

--- alive?

スレッドが「生きている」時、true を返します。

[[m:Thread#status]] が真を返すなら、このメソッドも真
です。

--- exit
--- kill
--- terminate

スレッドの実行を終了させます。

self を返します。

#@since 1.8.6
--- thr.exit!
--- thr.kill!
--- thr.terminate!
#@#   => thr

Terminates thr without calling ensure clauses and schedules another
thread to be run, returning the terminated Thread. If this is
the main thread, or the last thread, exits the process.

See [[m:Thread#exit]] for the safer version.

#@end

--- group

スレッドが属している [[c:ThreadGroup]] オブジェクトを返します。

    p Thread.current.group == ThreadGroup::Default
    # => true

死んでいるスレッドは nil を返します。

--- join
#@if (version >= "1.7.0")
--- join(limit)
#@end

スレッド self の実行が終了するまで、カレントスレッドを停止し
ます。self が例外により終了していれば、その例外がカレントス
レッドに対して発生します。

self を返します。

#@since 1.8.0
引数 limit を指定すると、limit 秒でタイム
アウトし、nil を返します。
#@end

以下は、生成したすべてのスレッドの終了を待つ例です。

   threads = []
   threads.push(Thread.new { n = rand(5); sleep n; n })
   threads.push(Thread.new { n = rand(5); sleep n; n })
   threads.push(Thread.new { n = rand(5); sleep n; n })

   threads.each {|t| t.join}

--- key?(name)

name に対応したスレッドに固有のデータが定義されていれば
true を返します。name は文字列か [[c:Symbol]] で指定し
ます。

--- keys

スレッド固有データに関連づけられたキーの配列を返します。キーは
[[c:Symbol]] で返されます。

    th = Thread.current
    th[:foo] = 'FOO'
    th['bar'] = 'BAR'
    p th.keys

    #=> [:bar, :foo]

--- priority

スレッドの優先度を返します。優先度のデフォルト値は 0 で、この値の
大きいスレッドは小さいスレッドよりも優先度が高くなります。

--- priority=(val)

スレッドの優先度を設定します。負の値も指定できます。

val を返します。

#@#((<ruby 1.6 feature>)): version 1.6.5 までは self を返し
#@#ていました

--- raise([error_type,][message][,traceback])

そのスレッドで強制的に例外を発生させます。

引数の意味については組み込み関数 [[m:Kernel#raise]] を参照してく
ださい。

  Thread.new {
    sleep 1
    Thread.main.raise "foobar"
  }

  begin
    sleep
  rescue
    p $!, $@
  end

  => #<RuntimeError: foobar>
     ["-:3"]

--- run

停止状態(stop)のスレッドを再開させます。
[[m:Thread#wakeup]] と異なりすぐにスレッドの切り替え
を行います。死んでいるスレッドに対して実行すると [[c:ThreadError]]
が発生します。

self を返します。

--- safe_level

self のセーフレベルを返します。カレントスレッドの
safe_level は、[[m:$SAFE]] と同じです。

セーフレベルについては[[unknown:セキュリティモデル]]を参照してください。

--- status

生きているスレッドの状態を文字列 "run"、"sleep", "aborting" のいず
れかで返します。正常終了したスレッドに対して false、例外によ
り終了したスレッドに対して nil を返します。
#@#((-((<ruby 1.6 feature>)): version 1.6.5 までは、終了処理中
#@#(aborting)のスレッドに対しては "run" を返していました-))

[[m:Thread#alive?]] が真を返すなら、このメソッドも真です。

--- stop?

スレッドが終了(dead)あるいは停止(stop)している時、true を返
します。

--- value

スレッド self が終了するまで待ち([[m:Thread#join]] と同じ)、
そのスレッドのブロックが返した値を返します。スレッド実行中に例外が
発生した場合には、その例外を再発生させます。

以下は、生成したすべてのスレッドの終了を待ち結果を出力する例です。

   threads = []
   threads.push(Thread.new { n = rand(5); sleep n; n })
   threads.push(Thread.new { n = rand(5); sleep n; n })
   threads.push(Thread.new { n = rand(5); sleep n; n })

   threads.each {|t| p t.value}

最後の行で、待ち合わせを行っていることがわかりにくいと思うなら以下
のように書くこともできます。

   threads.each {|t| p t.join.value}

--- wakeup

停止状態(stop)のスレッドを実行可能状態(run)にします。死んでいるス
レッドに対して実行すると [[c:ThreadError]] が発生します。

self を返します。
