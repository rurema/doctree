category Development

実行トレース出力をとる機能を提供します。

使い方は大きく分けて2通り。

ひとつは以下のようにコマンドラインから [[m:Kernel.#require]] する方法です。
hoge.rb の実行をすべてトレース出力します。

  ruby -rtracer hoge.rb

もうひとつはソースからrequireする方法です。

  require 'tracer'

とした後

  Tracer.on

によりトレース出力を有効にします。

  Tracer.off

によりトレース出力を無効にします。

また、ブロック付きで Tracer.on を呼び出すと、そのブロック内のみ
トレースを出力します。

=== サンプルコード

  # 例: 式の評価の中でHogeクラスのメソッドが呼び出される時、トレースする。

  # ruby 1.8 では警告がでますが、動作します。
  require 'tracer'

  class Hoge
    def Hoge.fuga(i)
      "fuga #{i}"
    end
  end

  Tracer.add_filter {|event, file, line, id, binding, klass|
    event =~ /line/ and klass.to_s =~ /hoge/i
  }
  Tracer.on
  for i in 0..3
    puts Hoge.fuga(i) if i % 3 == 0
  end 
  Tracer.off

=== SEE ALSO

[[m:Kernel.#set_trace_func]]

= class Tracer < Object
実行トレース出力をとる機能を提供するクラスです。

== Class Methods

--- new

自身を初期化します。

--- on -> nil
--- on {...}

トレース出力を開始します。
ブロックを与えられた場合はそのブロック内のみトレース出力を行います。

  require 'tracer'

  Tracer.on
  class Test
    def test
      b = 2
    end
  end

  t = Test.new
  t.test

@see [[m:Tracer.off]]

--- off -> nil

トレース出力を中断します。
トレース出力を開始するには、[[m:Tracer.on]]を使用します。

@see [[m:Tracer.on]]

--- set_get_line_procs(filename, proc)
--- set_get_line_procs(filename) {|line| .... }

あるファイルについて利用する、行番号からソースのその行の内容を返す
手続きを指定します。何も指定しなければデフォルトの動作が利用されます。
指定する手続きは行番号を唯一の引数として呼び出されます。

@param filename ソースファイルの場所を文字列で指定します。
@param proc 通常、文字列を返す手続きオブジェクトを指定します。

  # 例 dummy.rb の3行目から6 行目のトレース出力に !! をつける
  require 'tracer'

  Tracer.set_get_line_procs('./dummy.rb'){|line|
    str = "\n"
    str = "!!\n" if line >= 3 and line <= 6
    str
  }
  Tracer.on
  require 'dummy'

  dm = Dummy.new
  puts dm.number

  =begin
  # dummy.rb
  class Dummy
    def initialize
      @number = 135
    end
    attr :number
  end
  =end

--- add_filter(proc)
--- add_filter {|event, file, line, id, binding, klass| .... }

トレース出力するかどうかを決定するフィルタを追加します。
何もフィルタを与えない場合はすべての行についてトレース情報が出力されます。
与えられた手続き(ブロックまたはProcオブジェクト)が真を返せば
トレースは出力されます。


#@if (version < "1.9.1")
ruby 1.8 ではブロックを与えると警告がでます。
#@end

フィルタは複数追加でき、
そのうち一つでも偽を返すとトレースの出力は抑制されます。

@param proc トレース出力するかどうかを決定する手続きオブジェクトを指定します。
            通常、true か falseを返す必要があります。

フィルタ手続きは引数として event, file, line, id, binding, klass の
6 つをとります。
[[m:Kernel.#set_trace_func]] で指定するものとほぼ同じです。

=== フィルタ手続きのパラメータ

: event
  イベントを表す文字列。
  以下の種類がある。カッコ内は tracer の出力での表記。

//emlist{
  * line (-)   ある行を実行
  * call (>)   メソッド呼び出し
  * return (<) メソッドからのリターン
  * class (C)  クラスコンテキストに入った
  * end (E)    クラスコンテキストから出た
  * raise      例外が発生した
  * c-call     Cで記述されたメソッドが呼ばれた
  * c-return   Cで記述されたメソッドからreturn
//}

: file
  現在処理しているファイルの名前

: line
  現在処理している行番号

: id
  最後に呼び出されたメソッドのメソッド名(のシンボル)
  そのようなメソッドがなければ0になる。

: binding
  現在のコンテキスト

: klass
  現在呼び出されているメソッドのクラスオブジェクト。


--- verbose -> bool
--- verbose? -> bool

真ならばトレース出力の開始や終了を知らせます。

--- verbose=(flag)

トレース出力の開始や終了を知らせる文字列("Trace on"または"Trace off")が必要なら真を設定します。

@param flag トレース出力の開始や終了を知らせる文字列が必要ならtrueを設定します。

  require 'tracer'

  Tracer.verbose = true
  Tracer.on {
    puts "Hello"
  }

  # 出力例
  Trace on
  #0:t5.rb:7::-:   puts "Hello"
  #0:t5.rb:7:Kernel:>:   puts "Hello"
  #0:t5.rb:7:IO:>:   puts "Hello"
  Hello#0:t5.rb:7:IO:<:   puts "Hello"
  #0:t5.rb:7:IO:>:   puts "Hello"

  #0:t5.rb:7:IO:<:   puts "Hello"
  #0:t5.rb:7:Kernel:<:   puts "Hello"
  Trace off

--- stdout -> object

トレース出力先を参照します。

--- stdout=(fp)

トレース出力先を変更します。

@param fp 新しいトレース出力先を指定します。

  require 'tracer'

  fp = File.open('temptrace.txt', "w")
  Tracer.stdout = fp
  Tracer.on {
    puts "Hello"
  }
  fp.close


#@since 1.9.2
--- display_c_call -> bool
--- display_c_call? -> bool

真ならば、ビルトインメソッドの呼び出しを表示します。
デフォルトは偽です。

--- display_c_call=(flag)

ビルトインメソッドの呼び出しを表示するかどうかを設定します。

@param flag ビルトインメソッドの呼び出しを表示するならば、真を指定します。

--- display_process_id -> bool
--- display_process_id? -> bool

真ならば、プロセス ID を表示します。
デフォルトは、偽です。

--- display_process_id=(flag)

プロセス ID を表示するかどうかを設定します。

@param flag プロセス ID を表示するならば、真を指定します。

--- display_thread_id -> bool
--- display_thread_id? -> bool

真ならば、スレッド ID を表示します。
デフォルトは、真です。

--- display_thread_id=(flag)

スレッド ID を表示するかどうかを設定します。

@param flag スレッド ID を表示するならば、真を指定します。

--- stdout_mutex -> Mutex
#@todo

#@end

== Instance Methods

--- add_filter(p = proc)
#@todo

フィルターを追加します。

@param p [[c:Proc]] オブジェクトを指定します。

--- get_line(file, line) -> String
#@todo

@param file

@param line

--- get_thread_no -> Integer
#@todo

--- off -> ()

トレース出力を中断します。

--- on -> ()
--- on{ ... } -> ()

トレース出力を再開します。

ブロックを与えるとブロックの実行中のみトレースを出力します。

--- set_get_line_procs(file, p = proc)
#@todo

--- stdout -> IO

@see [[m:Tracer.stdout]]

--- trace_func(event, file, line, id, binding, klass, *) -> object | nil
#@todo


== Constants


--- EVENT_SYMBOL
  
トレース出力のシンボルのハッシュです。
下記のような文字列があります。

  EVENT_SYMBOL = {
    "line" => "-",
    "call" => ">",
    "return" => "<",
    "class" => "C",
    "end" => "E",
    "c-call" => ">",
    "c-return" => "<",
  }

@see [[m:Tracer.add_filter]]


--- Single -> Tracer
#@todo

