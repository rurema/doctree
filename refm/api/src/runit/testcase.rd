require runit/testresult
require runit/testsuite
require runit/assert
require runit/error

このライブラリは RubyUnit との互換性を提供するためだけに提供されています。
これからユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。


= class RUNIT::TestCase < Test::Unit::TestCase

include RUNIT::AssertMixin

== Class Methods

--- new(test_name, suite_name = Test::Unit::TestCase.name)
#@todo

--- suite
#@todo

== Instance Methods

--- assert_equals(expected, really, message = nil)
#@todo

alias of assert_equal.

--- name
#@todo

--- run(result) { .... }
#@todo

