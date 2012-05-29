require test/unit
require test/unit/util/observable
require test/unit/testresult

各種 TestRunner を実装するために使われます。

Unit テストを行いたいだけのユーザが、このライブラリを require する
必要はありません。

= class Test::Unit::UI::TestRunnerMediator
include Test::Unit::Util::Observable

各種 TestRunner を実装するためのクラスです。

== Class Methods

--- new(suite) -> Test::Unit::UI::TestRunnerMediator

新しく TestRunnerMediator オブジェクトを生成して返します。

@param suite 実行したいテストを持った Test::Unit::TestSuite オブジェクトを
             与えます。

== Instance Methods

--- run_suite -> Test::Unit::TestResult

生成時に与えられた Test::Unit::TestSuite が保持しているテストを実行します。
実行結果を表す Test::Unit::TestResult オブジェクトを返します。

== Private Instance Methods

--- create_result -> Test::Unit::TestResult

自身が結果オブジェクトを生成するためのファクトリメソッドです。

異なる結果オブジェクトが必要な場合は再定義して使います。
