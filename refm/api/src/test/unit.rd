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

#@#単なるバグかも知れない。
trueをセットすると[[c:Test::Unit]]はユニットテストを自動実行``しなくなります''。
runは過去分詞のrunです。trueにするとテストを実行し終えたという意味になります。

#@end

= class AssertionFailedError < StandardError
Thrown by Test::Unit::Assertions when an assertion fails.

= module Test::Unit::Assertions

Test::Unit::TestCase に include されて使われるモジュールです。assert メソッドを定義して
います。

各 assert メソッドの最後の引数 message はテストが失敗したときに表示される
メッセージです。

== Singleton Methods

--- use_pp=(value)

Select whether or not to use the pretty-printer. If this option
is set to false before any assertions are made, pp.rb will not
be required.


== Instance Methods

--- assert(boolean, message=nil)

boolean が真なら pass

--- assert_equal(expected, actual, message=nil)

expected == actual ならば pass

--- assert_not_equal(expected, actual, message="")

expected != actual ならば pass

--- assert_instance_of(klass, object, message="")

klass == object.class が真なら pass

--- assert_nil(object, message="")

object.nil? ならば pass

--- assert_not_nil(object, message="")

!object.nil? ならば pass

--- assert_kind_of(klass, object, message="")

object.kind_of?(klass) が真なら pass

--- assert_respond_to(object, method, message="")

object.respond_to?(method) が真なら pass

--- assert_match(pattern, string, message="")

string =~ pattern が真ならば pass

--- assert_no_match(regexp, string, message="")

regexp !~ string が真ならば pass

--- assert_same(expected, actual, message="")

actual.equal?(expected) が真なら pass

--- assert_not_same(expected, actual, message="")

!actual.equal?(expected) が真なら pass

--- assert_operator(object1, operator, object2, message="")

object1.send(operator, object2) が真なら pass

#@since 1.8.1
--- assert_raise(expected_exception_klass, message="") { ... }

ブロックを実行して例外が発生し、その例外が
expected_exception_klass クラスならば pass
#@end

#@# bc-rdoc: detected missing name: assert_raises
--- assert_raises(*args, &block)

Alias of assert_raise.

Will be deprecated in 1.9, and removed in 2.0.

#@# bc-rdoc: detected missing name: build_message
--- build_message(head, template=nil, *arguments)

Builds a failure message. head is added before the template and
arguments replaces the '?'s positionally in the template.

--- assert_nothing_raised(*args) { ... }

ブロックを実行して例外が起きなければ pass

--- flunk(message="Flunked")

常に失敗

--- assert_throws(expected_symbol, message="") { ... }

ブロックを実行して :expected_symbol が throw されたら pass

--- assert_nothing_thrown(message="") { ... }

ブロックを実行して throw が起こらなければ pass

--- assert_in_delta(expected_float, actual_float, delta, message="")

(expected_float.to_f - actual_float.to_f).abs <= delta.to_f 
が真なら pass

delta は正の数でなければならない。

--- assert_send(send_array, message="")

send_array[0].__send__(send_array[1], *send_array[2..-1])
が真なら pass

--- assert_block(message="assert_block failed.") { ... }

block の結果が真なら pass

#@since 1.8.1
= class Test::Unit::AutoRunner

#@todo

テストの実行を操作したいときにこの AutoRunner クラスを使います。
大量のテストの中から特定のテストスクリプトのみを実行したい場合、
特定のテストクラスのみを実行したい場合などに使います。
AutoRunner は Collector::Dir オブジェクトなどの Collector に
テストを集めさせて、UI::Console::TestRunner オブジェクトなどの
Runner にテストを実行させているクラスです。

=== 例

ディレクトリ ./somedir 以下にある全てのテストを実行したい場合は次のようなファイル(runner.rb)を用意して実行します。テストは test_*.rb というファイル名である必要があります。

#@# ruby 1.8.3 以降では AutoRunner.run の第一引数の意味が変わり、今までと真偽が逆になりました。

#@if (version <= "1.8.2")
第一引数に false を与えると、./somedir 以下にある全てのテストを実行します。
  require 'test/unit'
  Test::Unit::AutoRunner.run(false, './somedir')
#@end

#@if (version >= "1.8.3")
第一引数に true を与えると、./somedir 以下にある全てのテストを実行します。
  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir')
#@end

単に実行します。

  $ ruby runner.rb 

ディレクトリ ./somedir 以下にあるテストをファイル somefile を除いて実行したい場合は次のように runner.rb にオプションを与えます。

  $ ruby runner.rb --exclude=somefile

同じことは、runner.rb に直接オプションを書いても実現できます。

  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir', ['--exclude=somefile'])

上のやり方では拡張子が .rb のファイルしか集めません。拡張子が .rbx のファイルも
テストとして集めたい場合は次のようにします。

  require 'test/unit'
  Test::Unit::AutoRunner.run(true, './somedir', ['--pattern=/test_.*\.rbx\Z/'])

== Class Methods

--- run(force_standalone = false, dir = nil, argv = ARGV)
テストを実行します。
        
#@if (version >= "1.8.3")
#@#ruby 1.8.3 以降では force_standalone の意味が変わり、今までと真偽が逆になりました。        
force_standalone に true を与えると、dir 以下にある全てのテストを実行します。
false を与えた場合は既に読み込まれたファイルの中からテストを探して実行します。
デフォルトは false です。
#@end

#@if (version <= "1.8.2")
#@#ruby 1.8.2 まで: 
force_standalone には $0 か false を与えます。
$0 を与えた場合は既に読み込まれたファイルの中からテストを探して実行します。
false を与えた場合は、dir の中からテストスクリプトを再帰的に探査して
実行します。デフォルトではファイル名が test_*.rb のテストスクリプトしか探査
しません。
false を与えた場合でも、既に読み込まれたファイルは実行するテストに含まれます。
#@end

dir には force_standalone に true を与えた時に再帰的に探査するディレクトリ名を
与えます。デフォルトではカレントディレクトリを再帰的に探査します。

argv にはオプションを配列として与えます。解釈するオプションは先に
出てきたものと同じです。

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
#@if (version <= "1.8.2")
force_standalone に false を与えた時には次のオプションが追加されます。
#@else
force_standalone に true を与えた時には次のオプションが追加されます。
#@end
      -a, --add=TORUN                  Add TORUN to the list of things to run;
                                       can be a file or a directory.
      -p, --pattern=PATTERN            Match files to collect against PATTERN.
#@since 1.8.2
      -x, --exclude=PATTERN            Ignore files to collect against PATTERN.
#@end

例

      require 'test/unit'
      Test::Unit::AutoRunner.run(true, './', ['--runner=tk', '-v',
                                               '--exclude=/test_hoge.*\.rb\Z/i'])
    
argv にデフォルトのまま ARGV を渡しておけばコマンドラインからオプションを
指定できます。

      require 'test/unit'
      Test::Unit::AutoRunner.run(true, './')

と、runner.rb に書いておいて、コマンドラインから以下のように実行。
   
      $ ruby runner.rb --runner=tk -v --exclude=/test_hoge.\*\\.rb\\Z/i

--- standalone?

#@end


= module Test::Unit::UI

== Constants

#@since 1.8.1
--- SILENT
--- PROGRESS_ONLY
--- NORMAL
--- VERBOSE
#@end

= module Test::Unit::UI::Console

= class Test::Unit::UI::Console::TestRunner < Object

Runs a Test::Unit::TestSuite on the console.

== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(suite, output_level=NORMAL, io=STDOUT)

Creates a new TestRunner for running the passed suite. If quiet_mode
is true, the output while running is limited to progress dots,
errors and failures, and the final result. io specifies where
runner output should go to; defaults to STDOUT.

== Instance Methods
#@# bc-rdoc: detected missing name: start
--- start

Begins the test run.


= class Test::Unit::TestCase < Object
include Test::Unit::Assertions
include Test::Unit::Util::BacktraceFilter

テストはこのクラスのサブクラスとして定義します。

Ties everything together. If you subclass and add your own test methods, it takes care of making them into tests and wrapping those tests into a suite. It also does the nitty-gritty of actually running an individual test and collecting its results into a [[c:Test::Unit::TestResult]] object.

== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(test_method_name)

Creates a new instance of the fixture for running the test represented
by test_method_name.

#@# bc-rdoc: detected missing name: suite
--- suite

Rolls up all of the test* methods in the fixture into one suite,
creating a new instance of the fixture for each method.

== Instance Methods

--- setup
各テストメソッドが呼ばれる前に必ず呼ばれます。

--- teardown
各テストメソッドが呼ばれた後に必ず呼ばれます。

#@# bc-rdoc: detected missing name: name
--- name

Returns a human-readable name for the specific test that this
instance of TestCase represents.

#@# bc-rdoc: detected missing name: run
--- run(result) {|STARTED, name| ...}

Runs the individual test method represented by this instance
of the fixture, collecting statistics, failures and errors in
result.

#@# bc-rdoc: detected missing name: size
--- size

#@# bc-rdoc: detected missing name: default_test
--- default_test

= class Test::Unit::Failure < Object
Encapsulates a test failure. Created by [[c:Test::Unit::TestCase]] when an assertion fails.

== Class Methods
--- new(test_name, location, message)

Creates a new Failure with the given location and message.

== Instance Methods
#@# bc-rdoc: detected missing name: long_display
--- long_display

Returns a verbose version of the error description.

#@# bc-rdoc: detected missing name: short_display
--- short_display

Returns a brief version of the error description.

#@# bc-rdoc: detected missing name: single_character_display
--- single_character_display

Returns a single character representation of a failure.

#@# bc-rdoc: detected missing name: to_s
--- to_s

Overridden to return long_display.

= class Test::Unit::Error < Object

== Class Methods
#@# bc-rdoc: detected missing name: new
--- new(test_name, exception)

Creates a new Error with the given test_name and exception.

== Instance Methods
#@# bc-rdoc: detected missing name: long_display
--- long_display

Returns a verbose version of the error description.

#@# bc-rdoc: detected missing name: message
--- message

Returns the message associated with the error.

#@# bc-rdoc: detected missing name: short_display
--- short_display

Returns a brief version of the error description.

#@# bc-rdoc: detected missing name: single_character_display
--- single_character_display

Returns a single character representation of an error.

#@# bc-rdoc: detected missing name: to_s
--- to_s

Overridden to return long_display.

= class Test::Unit::TestResult < Object
include Test::Unit::Util::Observable

Collects [[c:Test::Unit::Failure]] and [[c:Test::Unit::Error]] so that they can be displayed to the user. To this end, observers can be added to it, allowing the dynamic updating of, say, a UI.

== Class Methods
#@# bc-rdoc: detected missing name: new
--- new

Constructs a new, empty TestResult.

== Instance Methods
#@# bc-rdoc: detected missing name: add_assertion
--- add_assertion

Records an individual assertion.

#@# bc-rdoc: detected missing name: add_error
--- add_error(error)

Records a Test::Unit::Error.

#@# bc-rdoc: detected missing name: add_failure
--- add_failure(failure)

Records a Test::Unit::Failure.

#@# bc-rdoc: detected missing name: add_run
--- add_run

Records a test run.

#@# bc-rdoc: detected missing name: error_count
--- error_count

Returns the number of errors this TestResult has recorded.
#@# bc-rdoc: detected missing name: failure_count
--- failure_count

Returns the number of failures this TestResult has recorded.

#@# bc-rdoc: detected missing name: passed?
--- passed?

Returns whether or not this TestResult represents successful
completion.

#@# bc-rdoc: detected missing name: to_s
--- to_s

Returns a string contain the recorded runs, assertions, failures
and errors in this TestResult.

= class Test::Unit::TestSuite < Object

A collection of tests which can be run.

Note: It is easy to confuse a TestSuite instance with something that has a static suite method; I know because I have trouble keeping them straight. Think of something that has a suite method as simply providing a way to get a meaningful TestSuite instance.


== Class Methods

#@# bc-rdoc: detected missing name: new
--- new(name="Unnamed TestSuite")

Creates a new TestSuite with the given name.

== Instance Methods

#@# bc-rdoc: detected missing name: <<
--- <<(test)

Adds the test to the suite.

#@# bc-rdoc: detected missing name: ==
--- ==(other)

It's handy to be able to compare TestSuite instances.

#@# bc-rdoc: detected missing name: delete
--- delete(test)



#@# bc-rdoc: detected missing name: empty?
--- empty?



#@# bc-rdoc: detected missing name: run
--- run(result, &progress_block) {|STARTED, name| ...}

Runs the tests and/or suites contained in this TestSuite.

#@# bc-rdoc: detected missing name: size
--- size

Retuns the rolled up number of tests in this suite; i.e. if the
suite contains other suites, it counts the tests within those
suites, not the suites themselves.

#@# bc-rdoc: detected missing name: to_s
--- to_s

Overridden to return the name given the suite at creation.

