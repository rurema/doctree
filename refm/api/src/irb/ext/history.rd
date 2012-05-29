
[[c:IRB::Context]] に実行結果の履歴を保持する機能を提供するサブライブラ
リです。

conf.eval_history か IRB.conf[:EVAL_HISTORY] に [[c:Integer]] を設定す
る事で使用できます。

このライブラリで定義されているメソッドはユーザが直接使用するものではあ
りません。

= reopen IRB::Context

== Instance Methods

--- eval_history -> Integer | nil

実行結果の履歴の最大保存件数を [[c:Integer]] か nil で返します。

@return 履歴の最大保存件数を [[c:Integer]] か nil で返します。0 を返し
        た場合は無制限に保存します。nil を返した場合は追加の保存は行いません。

@see [[m:IRB::Context#eval_history=]]

--- eval_history=(val)

実行結果の履歴の最大保存件数を val に設定します。

.irbrc ファイル中で IRB.conf[:EVAL_HISTORY] を設定する事でも同様の事が
行えます。

@param val 実行結果の履歴の最大保存件数を [[c:Integer]] か nil で指定し
           ます。0 を指定した場合は無制限に履歴を保存します。現在の値よ
           りも小さい値を指定した場合は履歴がその件数に縮小されます。
           nil を指定した場合は履歴の追加がこれ以上行われなくなります。

@see [[m:IRB::Context#eval_history]]
