各種 TestRunner を実装するために使われます。

Unit テストを行いたいだけのユーザが、このライブラリを require する
必要はありません。

= module Test::Unit::UI
各種 TestRunner を実装するためのモジュールです。

== Constants

#@since 1.8.1
--- SILENT
--- PROGRESS_ONLY
--- NORMAL
--- VERBOSE
#@todo
#@end

= module Test::Unit::UI::TestRunnerUtilities
== Instance Methods
--- run(suite, output_level=NORMAL)    -> Test::Unit::TestResult
#@todo

新しく TestRunner を生成して、与えられた TestSuite のテストを実行します。

@param suite 実行したいテストを保持している TestSuite オブジェクトか
TestCase オブジェクトを与えます。

@param output_level 出力レベルを指定します。指定できるのは以下の4つです。
 * Test::Unit::UI::SILENT 
 * Test::Unit::UI::PROGRESS_ONLY
 * Test::Unit::UI::NORMAL
 * Test::Unit::UI::VERBOSE

--- start_command_line_test    -> Test::Unit::TestResult
#@todo
Takes care of the ARGV parsing and suite
determination necessary for running one of the
TestRunners from the command line.
