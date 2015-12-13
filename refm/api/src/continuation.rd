Ruby 1.9 以降で継続オブジェクトを扱うためのライブラリです。

#@since 2.2.0
非推奨になりました。代わりに[[lib:fiber]]を使ってください。
#@end

= reopen Kernel
== Module functions
--- callcc {|cont| .... } -> object

継続を作成します。 [[c:Continuation]] を参照してください。

#@include(_builtin/Continuation)
