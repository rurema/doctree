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

なし

=== SEE ALSO

[[m:Kernel.#set_trace_func]]



= class Tracer < Object

== Class Methods

--- on
--- on {...}
#@todo

トレース出力を開始。
ブロックを与えられた場合はそのブロック内のみトレース出力を行う。

--- off
#@todo

トレース出力を中断。

--- set_get_line_procs(filename, proc)
--- set_get_line_procs(filename) {|line| .... }
#@todo

あるファイルについて利用する、行番号からソースのその行の内容を返す
手続きを指定する。何も指定しなければデフォルトの動作が利用される。
指定する手続きは行番号を唯一の引数として呼び出される。

--- add_filter(proc)
--- add_filter {|event, file, line, id, binding| .... }
#@todo

トレース出力するかどうかを決定するフィルタを追加する。
何もフィルタを与えない場合はすべての行についてトレース情報が出力される。
与えられた手続き(ブロックまたはProcオブジェクト)が真を返せば
トレースは出力される。

フィルタは複数追加でき、
そのうち一つでも偽を返すとトレースの出力は抑制される。

フィルタ手続きは引数として event, file, line, id, binding の
5 つをとる ([[m:Kernel.#set_trace_func]] で指定するものとほぼ同じ)。

[フィルタ手続きのパラメータ]

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

--- verbose
--- verbose?
--- verbose=
#@todo

--- stdout
--- stdout=
#@todo

== Constants

--- EVENT_SYMBOL
#@todo
