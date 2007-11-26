#@# = monitor

スレッドの同期機構としてのモニター機能を提供するクラスです。
また同じスレッドから何度も lock できる Mutex としての機能も提供します。

=== 参照

  *[[unknown:ruby-list:6829]]
  *[[unknown:ruby-list:30447]]
    *[[unknown:ruby-list:30449]]

monitor は以下のような [[c:Mutex]] としての機能も提供します。

  * lock の持ち主がスレッドである Mutex / 何度も lock できる Mutex
    * lock したスレッドを Mutex 側が覚えていて
    * そのスレッドがもう一度 lock しようとしてもブロックしない
    * synchronize は lock していなかったら通常どおり、
      自分が lock していたら ただ yield するだけ (lock/unlockもしない)
    * unlock はそのスレッドだけができる

[[unknown:ruby-list:30447]] より。

#@include(monitor/Monitor)
#@include(monitor/MonitorMixin)
#@include(monitor/ConditionVariable)
