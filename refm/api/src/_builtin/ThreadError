= class ThreadError < StandardError

[[c:Thread]] 関連のエラーが起きたときに発生します。

  * カレントスレッドを [[m:Thread#join]] しようとしたとき
  * [[m:Thread#join]] でデッドロックしそうになったとき
  * 終了したスレッドを [[m:Thread#wakeup]] しようとしたとき
  * スレッドが一つしかないのに [[m:Thread.stop]] しようとしたとき
  * イテレータを与えずにスレッドを生成しようとしたとき
  * [[m:Kernel#throw]] がスレッド内で
    [[m:Kernel#catch]] されないとき
  * スレッドから [[unknown:制御構造/return]] しようとしたとき
