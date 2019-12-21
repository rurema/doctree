各種 TestRunner を実装するために使われます。

Unit テストを行いたいだけのユーザが、このライブラリを require する
必要はありません。

= module Test::Unit::UI
各種 TestRunner を実装するためのモジュールです。

== Constants

--- SILENT        -> Integer

テスト結果の出力レベルを表す定数です。何も出力しません。

--- PROGRESS_ONLY -> Integer

テスト結果の出力レベルを表す定数です。テストの進捗を表す「.」だけが出力されます。

--- NORMAL        -> Integer

テスト結果の出力レベルを表す定数です。一般的な出力を行います。

--- VERBOSE       -> Integer

テスト結果の出力レベルを表す定数です。詳細な出力を行います。

= module Test::Unit::UI::TestRunnerUtilities

各種 TestRunner を実装するためのモジュールです。

== Instance Methods
--- run(suite, output_level = NORMAL)    -> Test::Unit::TestResult

新しく TestRunner を生成して、与えられた TestSuite のテストを実行します。

@param suite 実行したいテストを保持している TestSuite オブジェクトか
             TestCase オブジェクトを与えます。

@param output_level 出力レベルを指定します。

引数 output_level には以下の 4 つのいずれかを指定します。詳しくは
[[c:Test::Unit::UI]] をご覧ください。

 * Test::Unit::UI::SILENT
 * Test::Unit::UI::PROGRESS_ONLY
 * Test::Unit::UI::NORMAL
 * Test::Unit::UI::VERBOSE

--- start_command_line_test    -> Test::Unit::TestResult

[[m:Object::ARGV]] を解析して、ARGV[0] で与えられたTestRunner を新しく
生成して、テストを実行します。

ARGV が空だった場合、メッセージを出力してプログラムを終了します。
