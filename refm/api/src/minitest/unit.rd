

= class MiniTest

== Singleton Methods

--- filter_backtrace(backtrace) -> Array
#@todo

== Constants

--- MINI_DIR -> String
#@todo


= class MiniTest::Assertion < Exception
#@todo

アサーションに失敗した時に発生する例外です。

= class MiniTest::Skip < MiniTest::Assertion
#@todo

[[m:MiniTest::Assertions#skip]] を呼び出した時に発生する例外です。


#@include(MiniTest__Unit)
#@include(MiniTest__Assertions)

