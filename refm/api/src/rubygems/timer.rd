
このライブラリは、ログ取得のために $log というグローバル変数を定義します。


= reopen Kernel

== Private Instance Methods

--- time(msg, width = 25){ ... } -> object

与えられたブロックの実行時間を計測して表示します。

@param msg 表示するメッセージを指定します。

@param width 表示する幅を指定します。

@return ブロックの実行結果を返します。
