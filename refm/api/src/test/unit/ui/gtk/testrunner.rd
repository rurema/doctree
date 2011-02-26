require test/unit/ui/testrunnerutilities
require test/unit/ui/testrunnermediator

GTK を用いた UI 上でユニットテストを実行し、結果を表示するためのライブ
ラリです。

= class Test::Unit::UI::GTK::TestRunner < Object
extend Test::Unit::UI::TestRunnerUtilities

GTK を用いた UI で Test::Unit::TestSuite を実行します。

この機能を利用するには、GTK の拡張ライブラリをインストールする必要があ
ります。

== Class Methods
--- new(suite, output_level = NORMAL)   -> Test::Unit::UI::GTK::TestRunner

TestRunner オブジェクトを生成して返します。

@param suite 実行したいテストを保持している TestSuite オブジェクトか
             TestCase オブジェクトを与えます。

@param output_level 出力レベルを指定します。

引数 output_level には以下の 4 つのいずれかを指定します。詳しくは
[[c:Test::Unit::UI]] をご覧ください。

 * Test::Unit::UI::SILENT
 * Test::Unit::UI::PROGRESS_ONLY
 * Test::Unit::UI::NORMAL
 * Test::Unit::UI::VERBOSE

== Instance Methods
--- start   -> Test::Unit::TestResult

テストを実行します。

テスト結果を保持した Test::Unit::TestResult オブジェクトを返します。
