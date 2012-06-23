category Thread

スレッド間キューや状態変数 (condition variable) を提供するライブラリです。

このライブラリは [[c:Thread]] を拡張します。rubyインタプリタを
デバッグオプション付き([[m:$DEBUG]]を真)で実行したときには、
[[m:Thread.abort_on_exception]] を true にします。

= reopen Thread
== Class Methods
#@until 1.9.1
--- exclusive { ... } -> object

#@# 1.9.1 以降は prelude.rb で定義されているので _builtin/Thread に移動しました。
ブロック実行中、Threadの切り替えを行いません。

#@end

#@include(thread/ConditionVariable)
#@until 1.9.1
#@include(thread/Mutex)
#@end
#@include(thread/Queue)
#@include(thread/SizedQueue)
