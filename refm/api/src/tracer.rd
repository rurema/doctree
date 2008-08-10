実行トレース出力をとる機能を提供する。

使い方は大きく分けて2通り。

ひとつは以下のようにコマンドラインからrequireする方法です。
hoge.rbの実行をすべてトレース出力します。

  ruby -rtracer hoge.rb

もうひとつはソースからrequireする方法です。

  require 'tracer'

とした後

  Tracer.on

によりトレース出力を有効にする。

  Tracer.off

によりトレース出力を無効にする。

また、ブロック付きで Tracer.on を呼び出すと、そのブロック内のみ
トレースを出力する。

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
手続きを指定する。何も指定しなければデフォルトの動作が利用される。
指定する手続きは行番号を唯一の引数として呼び出される。

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


#@if (version < "1.9.0")
ruby 1.8 ではブロックを与えると警告がでます。
#@end

フィルタは複数追加でき、
そのうち一つでも偽を返すとトレースの出力は抑制される。

@param proc トレース出力するかどうかを決定する手続きオブジェクトを指定します。
            通常、true か falseを返す必要があります。

フィルタ手続きは引数として event, file, line, id, binding, klass の
6 つをとります。
[[m:Kernel.#set_trace_func]] で指定するものとほぼ同じです。

==== フィルタ手続きのパラメータ

: event
  イベントを表す文字列。
  以下の種類がある。カッコ内は tracer の出力での表記。

    : line (-)
      ある行を実行
    : call (>)
      メソッド呼び出し
    : return (<)
      メソッドからのリターン
    : class (C)
      クラスコンテキストに入った
    : end (E)
      クラスコンテキストから出た
    : raise
      例外が発生した
    : c-call
      Cで記述されたメソッドが呼ばれた
    : c-return
      Cで記述されたメソッドからreturn
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
--- verbose=(flag)

トレース出力の開始や終了を知らせる文字列("Trace on"または"Trace off")が必要ならtrueを設定します。

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

--- stdout -> Object
--- stdout=(fp)

トレース出力先をIOオブジェクトなどに変更したり、参照することができます。

@param fp トレース出力をfp に変更します。

  require 'tracer'

  fp = File.open('temptrace.txt', "w")
  Tracer.stdout = fp
  Tracer.on {
    puts "Hello"
  }
  fp.close

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
