#@# Author: Keiju ISHITSUKA
= class IRB::Frame

現在実行中のフレーム情報を取り扱うためのクラスです。

[注]
set_trace_func を用いて Ruby の実行をトレースしています。
マルチスレッドには対応していません。

== Class Methods

--- top(n = 0)
#@todo

上からn番目のコンテキストを取り出します。
n は 0 が最上位になります。

--- bottom(n = 0)
#@todo

下からn番目のコンテキストを取り出します。
n は 0 が最下位になります。

--- sender
#@todo

センダになっているオブジェクトを取り出します。
センダとは、そのメソッドを呼び出した側の self のことです。

== Instance Methods

--- bottom(n = 0)
#@todo

下からn番目のコンテキストを取り出します。
n は 0 が最下位になります。

--- top(n = 0)
#@todo

上からn番目のコンテキストを取り出します。
n は 0 が最上位になります。

--- trace_func(event, file, line, id, binding)
#@todo
