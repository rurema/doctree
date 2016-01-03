category Thread

#@# = monitor

スレッドの同期機構としてのモニター機能を提供するクラスです。
また同じスレッドから何度も lock できる Mutex としての機能も提供します。

モニターとは、一つの Mutex とそれに関連付けられた複数の
条件変数から構成された、スレッドの同期機構です。
Mutex と 条件変数によって同等の機能を実現することは
可能ですが、モニタの利点はライブラリがその関連を保証
していることです。

#@since 2.3.0
monitor は以下のような [[c:Thread::Mutex]] としての機能も提供します。
#@else
monitor は以下のような [[c:Mutex]] としての機能も提供します。
#@end
  * lock の持ち主がスレッドである Mutex / 何度も lock できる Mutex
    * lock したスレッドを Mutex 側が覚えていて
    * そのスレッドがもう一度 lock しようとしてもブロックしない
    * synchronize は lock していなかったら通常どおり、
      自分が lock していたら ただ yield するだけ (lock/unlockもしない)
    * unlock はそのスレッドだけができる

[[ruby-list:30447]] より。

よりプリミティブな同期機構として、
#@since 2.1.0
#@since 2.3.0
[[c:Thread::Mutex]]、[[c:Thread::ConditionVariable]] も参照してください。
#@else
[[c:Mutex]]、[[c:Thread::ConditionVariable]] も参照してください。
#@end
#@else
[[c:Mutex]]、[[c:ConditionVariable]] も参照してください。
#@end

=== 参照

  * [[ruby-list:6829]]
  * [[ruby-list:30447]]
    * [[ruby-list:30449]]

#@include(monitor/Monitor)
#@include(monitor/MonitorMixin)
#@include(monitor/ConditionVariable)
