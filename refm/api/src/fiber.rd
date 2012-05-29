#@since 1.9.0
軽量スレッド Fiber をコルーチン的に扱うためのライブラリです。

@see [[c:Fiber]]

= reopen Fiber

== Singleton Methods

--- current -> Fiber

このメソッドが評価されたコンテキストにおける [[c:Fiber]] のインスタンスを返します。

例:

   fr = Fiber.new do
     Fiber.current
   end
   
   fb = fr.resume
   p fb.equal?(fr) # => true
   
   p Fiber.current # => #<Fiber:0x91345e4>
   p Fiber.current # => #<Fiber:0x91345e4>
  

== Public Instance Methods

--- transfer(*args) -> object

自身が表すファイバーへコンテキストを切り替えます。

自身は [[m:Fiber#resume]] を呼んだファイバーの子となります。
[[m:Fiber#resume]] との違いは、ファイバーが終了したときや [[m:Fiber.yield]] が呼ばれたときは、
ファイバーの親へ戻らずにメインファイバーへ戻ります。

@param args メインファイバーから呼び出した [[m:Fiber#resume]] メソッドの返り値として渡したいオブジェクトを指定します。

@return コンテキスト切り替えの際に、[[m:Fiber#resume]] メソッドに与えられた引数を返します。

@raise FiberError 自身が既に終了している場合、コンテキストの切り替えが [[c:Thread]] クラスが表すスレッド間をまたがる場合、
                  [[m:Fiber#resume]] を呼んだファイバーがその親か先祖である場合に発生します。

例:

  require 'fiber'
  
  fr1 = Fiber.new do |v|
    :fugafuga
  end
  
  fr2 = Fiber.new do |v|
    fr1.transfer
    :fuga
  end
  
  fr3 = Fiber.new do |v|
    fr2.resume
    :hoge
  end
  
  p fr3.resume # => :fugafuga


--- alive? -> bool

ファイバーが「生きている」時、真を返します。

このメソッドが真を返すのは以下の場合です。

 * まだ [[m:Fiber#resume]] されていない
 * ブロック内の評価が終了していない ([[m:Fiber.yield]] が呼ばれていない)

例:

  fr = Fiber.new{
    Fiber.yield
    "a"
  }
  
  p fr.alive? # => true
  fr.resume   # Fiber.yieldで戻ってくる
  p fr.alive? # => true
  fr.resume   # ブロック内の評価を終えて戻ってくる
  p fr.alive? # => false


#@end
