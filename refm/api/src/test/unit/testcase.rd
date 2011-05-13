require test/unit/assertions
#@until 1.9.1
require test/unit/testsuite
#@end

テストケースを記述するときに使います。

test/unit の require 時に同時にrequireされます。

#@since 1.9.1
= class Test::Unit::TestCase < MiniTest::Unit::TestCase
include MiniTest::Assertions
#@else
= class Test::Unit::TestCase < Object
include Test::Unit::Assertions
#@#include Test::Unit::Util::BacktraceFilter
#@end

テストの基本単位(あるいは「テスト本体」)を表すクラスです。
テストを行うメソッド(テストメソッド)は TestCase のサブクラスのインスタンスメソッド
として定義されます。テストメソッドの名前は「test」で始まっていなければなりません。
逆に、「test」で始まっているメソッドは全てテストメソッドと見なされます。
#@until 1.9.1
各テストメソッドは、[[m:Test::Unit::TestCase.suite]] により [[c:Test::Unit::TestSuite]]
オブジェクトへとひとつにまとめられます。
#@end

 require 'test/unit'
#@until 1.9.1
 require 'test/unit/ui/console/testrunner'
#@end
 
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
 
#@until 1.9.1
 suite = TC_String.suite
 Test::Unit::UI::Console::TestRunner.run(suite)
#@end

各 TestCase オブジェクトは、ひとつのテストメソッドに対応しています。テストが実行される時には、
テストメソッドの数だけ TestCase オブジェクトが生成されます。
#@until 1.9.1
テストの実行時にはそれぞれの結果が[[c:Test::Unit::TestResult]]に集計されます。
#@end

== Class Methods

#@since 1.9.1
--- test_order    -> Symbol

テストの実行順序を返します。

#@else
--- new(test_method_name)    -> Test::Unit::TestCase

このメソッドをユーザが直接呼ぶことはありません。

test_method_name に対応した TestCase オブジェクトを生成して返します。

@param test_method_name テストメソッドの名前を文字列で与えます。

--- suite    -> Test::Unit::TestSuite

「test」ではじまるインスタンスメソッド全てに対して、それぞれに対応する
TestCase オブジェクトを生成し、[[c:Test::Unit::TestSuite]] オブジェクト
としてまとめたものを返します。

「test」ではじまるインスタンスメソッドがない場合は、
[[m:Test::Unit::TestCase#default_test]] に対応づけされた TestCase オブ
ジェクトのみを持つ、TestSuite オブジェクトを返します。

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

このメソッドをユーザが直接呼ぶことはありません。

自身に対応したテストメソッドを実行して failures や errors を集計します。

@param result [[c:Test::Unit::TestResult]] オブジェクトを与えます。

--- size    -> Integer

常に 1 を返します。

--- default_test     -> ()

常に失敗するテストです。

== Private Instance Methods
--- passed?    -> bool

テストが成功したなら、true を返します。そうでないなら、false を返します。
[[m:Test::Unit::TestCase#teardown]] の中で使うことを意図されています。
テスト実行前に何を返すかは不定です。

== Constants

--- PASSTHROUGH_EXCEPTIONS

[[m:Test::Unit::TestCase#run]] の実行時に rescue されない例外の一覧です。

#@include(error.rd)
#@include(failure.rd)

#@end
