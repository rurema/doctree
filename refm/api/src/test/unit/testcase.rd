require test/unit/assertions
require test/unit/testsuite

= class Test::Unit::TestCase < Object
include Test::Unit::Assertions
#@#include Test::Unit::Util::BacktraceFilter

テストの基本単位(あるいは「テスト本体」)のためのクラスです。
テストを行うメソッド(テストメソッド)は TestCase のサブクラスのインスタンスメソッド
として定義されます。テストメソッドの名前は「test」で始まっていなければなりません。
逆に、「test」で始まっているメソッドは全てテストメソッドと見なされます。
各テストメソッドは、[[m:Test::Unit::TestCase.suite]] により [[c:Test::Unit::TestSuite]]
オブジェクトへとひとつにまとめられます。

 require 'test/unit'
 require 'test/unit/ui/console/testrunner'
 
 class TC_String < Test::Unit::TestCase
   def test_size
     assert_equal('abc'.size, 3)
   end

   def test_concat
     assert_raise(TypeError) do
       'abc' + 1
     end
   end
 end
 
 suite = TC_String.suite
 Test::Unit::UI::Console::TestRunner.run(suite)

各 TestCase オブジェクトは、ひとつのテストメソッドに対応しています。テストが実行される時は、
テストメソッドの数だけ TestCase オブジェクトが生成されます。

Ties everything together. If you subclass and add your own test methods, it takes care of making them into tests and wrapping those tests into a suite. It also does the nitty-gritty of actually running an individual test and collecting its results into a [[c:Test::Unit::TestResult]] object.

== Class Methods

--- new(test_method_name)    -> Test::Unit::TestCase
#@todo

このメソッドをユーザが直接呼ぶことはありません。

test_method_name に対応した TestCase オブジェクトを生成して返します。

@param test_method_name テストメソッドの名前を文字列で与えます。

--- suite    -> Test::Unit::TestSuite

「test」ではじまるインスタンスメソッド全てに対して、それぞれに対応する
TestCase オブジェクトを生成し、[[c:Test::Unit::TestSuite]] オブジェクト
としてまとめたものを返します。

「test」ではじまるインスタンスメソッドがない場合は、[[m:Test::Unit::TestCase#default_test]]
に対応づけされた TestCase オブジェクトのみを持つ、TestSuite オブジェクトを返します。

== Instance Methods

--- setup    -> ()
各テストメソッドが呼ばれる前に必ず呼ばれます。

--- teardown    -> ()
各テストメソッドが呼ばれた後に必ず呼ばれます。

--- method_name    -> String

自身に対応しているテストメソッドの名前を文字列で返します。

[[m:Test::Unit::TestCase#setup]] や [[m:Test::Unit::TestCase#teardown]] 
において、実行する(あるいは、実行した)テストメソッドの名前を知るのに
使うことができます。

--- name    -> String
自身に対応しているテストメソッドの名前を人間が読みやすい形式で返します。

--- run(result) {|STARTED, name| ...}
#@todo

このメソッドをユーザが直接呼ぶことはありません。

自身に対応したテストメソッドを実行します。

Runs the individual test method represented by this instance
of the fixture, collecting statistics, failures and errors in
result.

@param result [[c:Test::Unit::TestResult]] オブジェクトを与えます。

--- size    -> Integer

常に 1 を返します。

--- default_test     -> ()

常に失敗するテストです。

== Private Instance Methods
--- passed?

テストが成功したなら、true を返します。そうでないなら、false を返します。
[[m:Test::Unit::TestCase#teardown]] の中で使うことを意図されています。
テスト実行前に何を返すかは不定です。

== Constants

--- PASSTHROUGH_EXCEPTIONS

These exceptions are not caught by #run.

#@include(error.rd)
#@include(failure.rd)

