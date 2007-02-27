ユニットテストを行うためのライブラリです。

[[url:http://www.ruby-doc.org/stdlib/libdoc/test/unit/rdoc/index.html]]

=== 使い方

Test::Unit は以下のように使います。

まずテスト対象のソース(foo.rb)が必要です。

    class Foo
       def foo
         "foo"
       end
       def bar
         "foo"
       end
    end

次にユニットテスト(test_foo.rb)を書きます。テストを実行するメソッドの名前は
全て test_ で始まる必要があります。

    require 'test/unit'
    require 'foo'

    class TC_Foo < Test::Unit::TestCase
      def setup
        @obj = Foo.new
      end

      # def teardown
      # end

      def test_foo
        assert_equal("foo", @obj.foo)
      end
      def test_bar
        assert_equal("bar", @obj.bar)
      end
    end

テストを実行するには上で用意した test_foo.rb を実行します。
デフォルトではすべてのテストが実行されます。

        $ ruby test_foo.rb

        Loaded suite test_foo
        Started
        F.
        Finished in 0.022223 seconds.

          1) Failure!!!
        test_bar(TC_Foo) [test_foo.rb:16]:
        <bar> expected but was
        <foo>

        2 tests, 2 assertions, 1 failures, 0 errors

test_bar だけテストしたい場合は以下のようなオプションを与えます。

        $ ruby test_foo.rb --name=test_bar

        Loaded suite test_foo
        Started
        F
        Finished in 0.019573 seconds.

          1) Failure!!!
        test_bar(TC_Foo) [test_foo.rb:16]:
        <bar> expected but was
        <foo>

        1 tests, 1 assertions, 1 failures, 0 errors

gtk を使った testrunner

        $ ruby test_foo.rb --runner=gtk --name=test_bar

fox を使う

        $ ruby test_foo.rb --runner=fox --name=test_bar

console を使う (default)

        $ ruby test_foo.rb --runner=console --name=test_bar

以下のようにすると help も表示されます。

  $ ruby test_foo.rb --help

     Usage: test_foo.rb [options] [-- untouched arguments]
     
         -r, --runner=RUNNER              Use the given RUNNER.
                                          (c[onsole], f[ox], g[tk], g[tk]2, t[k])
#@since 1.8.6
         -b, --basedir=DIR                Base directory of test suites.
         -w, --workdir=DIR                Working directory to run tests.
#@end
         -n, --name=NAME                  Runs tests matching NAME.
                                          (patterns may be used).
         -t, --testcase=TESTCASE          Runs tests in TestCases matching TESTCASE.
                                          (patterns may be used).
         -v, --verbose=[LEVEL]            Set the output level (default is verbose).
                                          (s[ilent], p[rogress], n[ormal], v[erbose])
             --                           Stop processing options so that the
                                          remaining options will be passed to the
                                          test.
         -h, --help                       Display this help.

複数のテストを一度に行う場合、以下のように書いただけのファイルを実行します。

 require 'test/unit'
 require 'test_foo.rb'
 require 'test_bar.rb'

もう少し高度なテストの実行方法に関しては [[c:Test::Unit::AutoRunner]] を
参照して下さい。

=== RubyUnit からの移行

assertion メソッドの違いは [[unknown:"ruby-src:lib/runit/assert.rb"]] を参照。
[[c:RUNIT::Assert]] も参照。

= module Test::Unit

== Singleton Methods

#@since 1.8.1
--- run?
--- run=(flag)
#@todo

#@#単なるバグかも知れない。
trueをセットすると[[c:Test::Unit]]はユニットテストを自動実行``しなくなります''。
runは過去分詞のrunです。trueにするとテストを実行し終えたという意味になります。

#@end

= class Test::Unit::TestCase < Object
include Test::Unit::Assertions
include Test::Unit::Util::BacktraceFilter

テストはこのクラスのサブクラスとして定義します。

Ties everything together. If you subclass and add your own test methods, it takes care of making them into tests and wrapping those tests into a suite. It also does the nitty-gritty of actually running an individual test and collecting its results into a [[c:Test::Unit::TestResult]] object.

== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(test_method_name)
#@todo

Creates a new instance of the fixture for running the test represented
by test_method_name.

#@# bc-rdoc: detected missing name: suite
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

#@# bc-rdoc: detected missing name: name
--- name
#@todo

Returns a human-readable name for the specific test that this
instance of TestCase represents.

#@# bc-rdoc: detected missing name: run
--- run(result) {|STARTED, name| ...}
#@todo

Runs the individual test method represented by this instance
of the fixture, collecting statistics, failures and errors in
result.

#@# bc-rdoc: detected missing name: size
--- size
#@todo

#@# bc-rdoc: detected missing name: default_test
--- default_test
#@todo

= class Test::Unit::Failure < Object
Encapsulates a test failure. Created by [[c:Test::Unit::TestCase]] when an assertion fails.

== Class Methods
--- new(test_name, location, message)
#@todo

Creates a new Failure with the given location and message.

== Instance Methods
#@# bc-rdoc: detected missing name: long_display
--- long_display
#@todo

Returns a verbose version of the error description.

#@# bc-rdoc: detected missing name: short_display
--- short_display
#@todo

Returns a brief version of the error description.

#@# bc-rdoc: detected missing name: single_character_display
--- single_character_display
#@todo

Returns a single character representation of a failure.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Overridden to return long_display.

= class Test::Unit::Error < Object

== Class Methods
#@# bc-rdoc: detected missing name: new
--- new(test_name, exception)
#@todo

Creates a new Error with the given test_name and exception.

== Instance Methods
#@# bc-rdoc: detected missing name: long_display
--- long_display
#@todo

Returns a verbose version of the error description.

#@# bc-rdoc: detected missing name: message
--- message
#@todo

Returns the message associated with the error.

#@# bc-rdoc: detected missing name: short_display
--- short_display
#@todo

Returns a brief version of the error description.

#@# bc-rdoc: detected missing name: single_character_display
--- single_character_display
#@todo

Returns a single character representation of an error.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Overridden to return long_display.

= class Test::Unit::TestResult < Object
include Test::Unit::Util::Observable

Collects [[c:Test::Unit::Failure]] and [[c:Test::Unit::Error]] so that they can be displayed to the user. To this end, observers can be added to it, allowing the dynamic updating of, say, a UI.

== Class Methods
#@# bc-rdoc: detected missing name: new
--- new
#@todo

Constructs a new, empty TestResult.

== Instance Methods
#@# bc-rdoc: detected missing name: add_assertion
--- add_assertion
#@todo

Records an individual assertion.

#@# bc-rdoc: detected missing name: add_error
--- add_error(error)
#@todo

Records a Test::Unit::Error.

#@# bc-rdoc: detected missing name: add_failure
--- add_failure(failure)
#@todo

Records a Test::Unit::Failure.

#@# bc-rdoc: detected missing name: add_run
--- add_run
#@todo

Records a test run.

#@# bc-rdoc: detected missing name: error_count
--- error_count
#@todo

Returns the number of errors this TestResult has recorded.
#@# bc-rdoc: detected missing name: failure_count
--- failure_count
#@todo

Returns the number of failures this TestResult has recorded.

#@# bc-rdoc: detected missing name: passed?
--- passed?
#@todo

Returns whether or not this TestResult represents successful
completion.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Returns a string contain the recorded runs, assertions, failures
and errors in this TestResult.

= class Test::Unit::TestSuite < Object

A collection of tests which can be run.

Note: It is easy to confuse a TestSuite instance with something that has a static suite method; I know because I have trouble keeping them straight. Think of something that has a suite method as simply providing a way to get a meaningful TestSuite instance.


== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(name="Unnamed TestSuite")
#@todo

Creates a new TestSuite with the given name.

== Instance Methods

#@# bc-rdoc: detected missing name: <<
--- <<(test)
#@todo

Adds the test to the suite.

#@# bc-rdoc: detected missing name: ==
--- ==(other)
#@todo

It's handy to be able to compare TestSuite instances.

#@# bc-rdoc: detected missing name: delete
--- delete(test)
#@todo



#@# bc-rdoc: detected missing name: empty?
--- empty?
#@todo



#@# bc-rdoc: detected missing name: run
--- run(result, &progress_block) {|STARTED, name| ...}
#@todo

Runs the tests and/or suites contained in this TestSuite.

#@# bc-rdoc: detected missing name: size
--- size
#@todo

Retuns the rolled up number of tests in this suite; i.e. if the
suite contains other suites, it counts the tests within those
suites, not the suites themselves.

#@# bc-rdoc: detected missing name: to_s
--- to_s
#@todo

Overridden to return the name given the suite at creation.

