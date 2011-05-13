require test/unit/ui/testrunnerutilities
require test/unit/ui/testrunnermediator

コンソール上でユニットテストを実行し、結果を表示するための
ライブラリです。

= class Test::Unit::UI::Console::TestRunner < Object
extend Test::Unit::UI::TestRunnerUtilities

コンソール上でユニットテストを実行し、結果を表示するための
クラスです。

== Class Methods

--- new(suite, output_level = NORMAL, io = STDOUT) -> Test::Unit::UI::Console::TestRunner

TestRunner オブジェクトを生成して返します。

@param suite 実行したいテストを保持している TestSuite オブジェクトか
             TestCase オブジェクトを与えます。

@param output_level 出力レベルを指定します。

@param io 結果を出力するための [[c:IO]] オブジェクトを与えます。

引数 output_level には以下の 4 つのいずれかを指定します。詳しくは
[[c:Test::Unit::UI]] をご覧ください。

 * Test::Unit::UI::SILENT
 * Test::Unit::UI::PROGRESS_ONLY
 * Test::Unit::UI::NORMAL
 * Test::Unit::UI::VERBOSE

== Instance Methods

--- start    -> Test::Unit::TestResult

テストを実行し、生成時に与えられた io に結果を出力します。
テスト結果を保持した Test::Unit::TestResult オブジェクトを返します。
