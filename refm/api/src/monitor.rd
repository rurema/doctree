category Thread

#@# = monitor

スレッドの同期機構としてのモニター機能を提供するクラスです。
また同じスレッドから何度も lock できる Mutex としての機能も提供します。

モニターとは、一つの Mutex とそれに関連付けられた複数の
条件変数から構成された、スレッドの同期機構です。
Mutex と 条件変数によって同等の機能を実現することは
可能ですが、モニタの利点はライブラリがその関連を保証
していることです。

monitor は以下のような [[c:Mutex]] としての機能も提供します。
  * lock の持ち主がスレッドである Mutex / 何度も lock できる Mutex
    * lock したスレッドを Mutex 側が覚えていて
    * そのスレッドがもう一度 lock しようとしてもブロックしない
    * synchronize は lock していなかったら通常どおり、
      自分が lock していたら ただ yield するだけ (lock/unlockもしない)
    * unlock はそのスレッドだけができる

[[ruby-list:30447]] より。

よりプリミティブな同期機構として、
[[c:Mutex]]、[[c:ConditionVariable]] も参照してください。

=== 参照

  * [[ruby-list:6829]]
  * [[ruby-list:30447]]
    * [[ruby-list:30449]]

#@include(monitor/Monitor)
#@include(monitor/MonitorMixin)
#@include(monitor/ConditionVariable)
