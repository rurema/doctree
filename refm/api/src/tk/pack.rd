require tk

= module TkPack

extend Tk
include Tk

ウィジェットを配置するためのモジュールです。
このモジュールにより、ウィジェットは空き領域を順次詰めるように配置されます。

普通、ウィジェットの配置には[[m:TkWindow#pack]]が使われます。

== Module Functions

--- configure(win1, win2, ... winN, keys=nil)
--- pack(win1, win2, ... winN, keys=nil)
#@todo

ウィジェットwin1 ... winNを配置します。
keysは以下をキーに持つハッシュです。

*"after"=>other

ウィジェットwinNをotherウィジェットの後に配置しなおします。
other がまだpackされていなければエラーになります。

  require "tk"
  
  a = TkButton.new {text 'a'}.pack
  b = TkButton.new {text 'b'}.pack
  c = TkButton.new {text 'c'}.pack
  
  TkPack.configure b,a, 'after'=>c
  
  Tk.mainloop

otherは、winNウィジェットとマスターが同じでなければなりま
せん。

  require "tk"
  
  frame = TkFrame.new
  a = TkButton.new        {text 'a'}.pack
  b = TkButton.new(frame) {text 'b'}.pack
  c = TkButton.new        {text 'c'}.pack
  
  b.pack 'after'=>c
  
  Tk.mainloop
  
  error--> can't pack .w0000.w0002 inside . (RuntimeError)

*"anchor"
*"before"=>other

配置する位置がotherの前であることを除いて、"after"
と同じです。

*"expand"

trueを指定すると、ウィジェットを配置していない空きの区画を常に
最小の状態に保つよう、ウィジェットを配置した区画を広げます。(ウィジェッ
ト自身を大きくするわけではありません。下記"fill"の項目も参照し
てください)デフォルトはfalseです。

*"fill"

配置のために割り当てられた区画がスレーブが要求するサイズよりも大きい
場合、スレーブを指定した方向に引き延ばします。

"fill"によって、ウィジェットが常にすき間なく詰められるわけではないこ
とに注意しなければなりません。

例えば、以下の例を実行した後ウィンドウのサイズを縦横に大きくすると
ウィンドウの下部に空きができます。

  require "tk"
  5.times {|i| TkButton.new {text i }.pack 'fill'=>'both'}
  Tk.mainloop

これは、ウィジェットを配置する区画を上から切り取っているからです。こ
の場合、横方向に区画の空きはないので、ウィジェットに割り当てられた区
画は横方向には伸びますが、縦方向(下部)には見えない空き区画が残されて
います。ウィンドウを大きくしたときにできた空き領域はまだウィジェット
が割り当てられていない空きの区画です。

以下の例のように区画を左から切り取る('side'=>'left'で指定する)
ようにすれば、ウィンドウを広げたときには右に空きができます。

  require "tk"
  5.times {|i| TkButton.new {text i }.pack 'fill'=>'both', 'side'=>'left'}
  Tk.mainloop

このような空きも埋めたい場合にはexpandを使用します。以下の例を
実行した後ウィンドウを広げるとウィジェットが配置された区画は縦横両方
向に広げられ、空きの区画は常に見えない状態になります。

  require "tk"
  5.times {|i| TkButton.new {text i }.pack 'fill'=>'both', 'expand'=>true}
  Tk.mainloop

*"none"

スレーブを引き延ばしません。デフォルト。
*"x"

横方向にウィジェットを引き延ばします。
*"y"

縦方向にウィジェットを引き延ばします。
*"both"

縦横両方向にウィジェットを引き延ばします。

*"in"=>master

masterをマスターウィジェットとしてpackします。

*"ipadx"
*"ipady"
*"padx"
*"pady"
*"side"
 *"left"
 *"right"
 *"top"
 *"bottom"

--- forget(*args)
#@todo

argsで指定したウィジェットの配置を取り下げます(非表示になります)。

--- info(slave)
#@todo

--- propagate(master, bool=None)
#@todo

スレーブのpackが完了した後マスターのウィジェット(master)
の大きさが自動的に変更されるかどうかを真偽値boolで指定します。

boolを省略した場合、現在の設定を返します。

デフォルトはtrueで、この場合マスターウィジェットは、ウィジェット
が配置されていない空き区画が見えなくなるよう縮んだり、すべてのスレーブ
(の割り当てられた区画)のサイズにあわせて大きくなったりします。

((-このメソッドの用途がわからない。マスターのサイズを固定にしたいのな
ら、geometry でサイズを指定すればいいんじゃないの？-))

  require "tk"

  p TkPack.propagate(Tk.root)
  TkButton.new { text "foo" }.pack

  top = TkToplevel.new
  p TkPack.propagate(top)

  TkPack.propagate(top, false)
  p TkPack.propagate(top)
  TkButton.new(top) { text "bar" }.pack

  Tk.mainloop

  => true
     true
     false

以下の例では、barが表示されない((-なんで？いつかちゃんと調べること-))

  require "tk"

  TkFrame.new {
    TkPack.propagate(self, true)
    TkLabel.new(self) { text "foo" }.pack
  }.pack

  TkFrame.new {
    TkPack.propagate(self, false)
    TkLabel.new(self) { text "bar" }.pack
  }.pack

  Tk.mainloop

--- slaves(master)
#@todo

== Constants

--- TkCommandNames
#@todo

