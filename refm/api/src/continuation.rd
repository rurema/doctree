Ruby 1.9 以降で継続オブジェクトを扱うためのライブラリです。

Ruby 2.2.0から非推奨になりました。代わりに[[c:Fiber]]を使ってください。

= reopen Kernel
== Module functions
--- callcc {|cont| .... } -> object

継続を作成します。 [[c:Continuation]] を参照してください。

#@include(_builtin/Continuation)
