require test/unit/assertions
require test/unit/testsuite

= class Test::Unit::TestCase < Object
include Test::Unit::Assertions
include Test::Unit::Util::BacktraceFilter

テストはこのクラスのサブクラスとして定義します。

Ties everything together. If you subclass and add your own test methods, it takes care of making them into tests and wrapping those tests into a suite. It also does the nitty-gritty of actually running an individual test and collecting its results into a [[c:Test::Unit::TestResult]] object.

== Class Methods

--- new(test_method_name)
#@todo

Creates a new instance of the fixture for running the test represented
by test_method_name.

--- suite
#@todo

Rolls up all of the test* methods in the fixture into one suite,
creating a new instance of the fixture for each method.

== Instance Methods

--- setup
#@todo
各テストメソッドが呼ばれる前に必ず呼ばれます。

--- teardown
#@todo
各テストメソッドが呼ばれた後に必ず呼ばれます。

--- name
#@todo

Returns a human-readable name for the specific test that this
instance of TestCase represents.

--- run(result) {|STARTED, name| ...}
#@todo

Runs the individual test method represented by this instance
of the fixture, collecting statistics, failures and errors in
result.

--- size
#@todo

--- default_test
#@todo

--- passed?
#@todo

Returns whether this individual test passed or
not. Primarily for use in teardown so that artifacts
can be left behind if the test fails.

== Constants

--- PASSTHROUGH_EXCEPTIONS

These exceptions are not caught by #run.

#@include(error.rd)
#@include(failure.rd)

