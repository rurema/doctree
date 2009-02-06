スレッド間キューや状態変数(condition variable)を提供するライブラリです。

このライブラリは[[c:Thread]]を拡張します．rubyインタプリタを
デバッグオプション付き([[m:$DEBUG]]を真)で実行したときには，
[[m:Thread.abort_on_exception]]をtrueにします

#@#((-あらい: 2001-02-11
#@#$DEBUGが真の場合、rubyインタプリタの方で abort_on_exception を true にした
#@#ときと同じ動作にするので、この機能は必要ないのではないか？-))．
#@#また，[[c:Thread]]クラスに以下のクラスメソッドを追加定義します。

= reopen Thread
== Class Methods
--- Thread.exclusive { ... }
#@todo
ブロック実行中、Threadの切り替えを行いません。

#@include(thread/ConditionVariable)
#@until 1.9.1
#@include(thread/Mutex)
#@end
#@include(thread/Queue)
#@include(thread/SizedQueue)
