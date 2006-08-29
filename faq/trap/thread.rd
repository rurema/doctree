= Thread

* finalizer で Mutex は注意((<ruby-list:24697>))

  finalizer で登録したブロックの中で、Mutex などで待ちに入るとデッドロックします。
  理由はまだ自分で整理しきれてないのですが、おそらく、同じ Mutex を他でもロックしていると、そのロック中の GC で finalizerが 呼ばれてデッドロックするのかな、と思います。
  weakref みたいに Thread.critical を使う方が安全です。

* 以下の TCPServer の使用例では s2がThreadのブロック内で評価される前に、
  whileのループでs2を更新してしまうことがあるため、期待した動作になら
  ない。正しい使い方に関しては((<TCPServer>))のスレッド版の例を参照。


   s = TCPServer.new(11111)
 
   while(true)
     s2 = s.accept
     Thread.new do
       sleep 0.1
       p s2
     end
   end

* timeout

  ((<trap::timeout>)) に書かれた落とし穴は Thread の問題です。

* 代入演算子はアトミックじゃない((<ruby-dev:22193>))

  += のような代入演算子は途中でスレッドが切り替わる可能性があります。スレッド間で変数を共有している場合には注意が必要です。
