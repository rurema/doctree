現在実行中のフレーム情報を取り扱うためのサブライブラリです。

このライブラリで定義されているメソッドはユーザが直接使用するものではありません。

#@# Author: Keiju ISHITSUKA

= class IRB::Frame

現在実行中のフレーム情報を取り扱うためのクラスです。

[注]
set_trace_func を用いて Ruby の実行をトレースしています。
マルチスレッドには対応していません。

== Class Methods

--- top(n = 0) -> Binding

上から n 番目のコンテキストを取り出します。

@param n 取り出すコンテキストを [[c:Integer]] で指定します。n は 0 が最
         上位になります。

--- bottom(n = 0) -> Binding

下から n 番目のコンテキストを取り出します。

@param n 取り出すコンテキストを [[c:Integer]] で指定します。n は 0 が最
         下位になります。

--- sender -> object

センダになっているオブジェクトを取り出します。
センダとは、そのメソッドを呼び出した側の self のことです。

== Instance Methods

--- bottom(n = 0) -> Binding

下から n 番目のコンテキストを取り出します。

@param n 取り出すコンテキストを [[c:Integer]] で指定します。n は 0 が最
         下位になります。

--- top(n = 0) -> Binding

上から n 番目のコンテキストを取り出します。

@param n 取り出すコンテキストを [[c:Integer]] で指定します。n は 0 が最
         上位になります。

--- trace_func(event, file, line, id, binding) -> Binding

ライブラリ内部で使用します。
