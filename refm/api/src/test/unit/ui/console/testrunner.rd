require test/unit/ui/testrunnerutilities
require test/unit/ui/testrunnermediator

コンソール上でユニットテストを実行し、結果を表示するための
ライブラリです。

= class Test::Unit::UI::Console::TestRunner < Object
extend Test::Unit::UI::TestRunnerUtilities

コンソール上でユニットテストを実行し、結果を表示するための
クラスです。

== Class Methods

--- new(suite, output_level=NORMAL, io=STDOUT)
#@todo

Creates a new TestRunner for running the passed suite. If quiet_mode
is true, the output while running is limited to progress dots,
errors and failures, and the final result. io specifies where
runner output should go to; defaults to STDOUT.

== Instance Methods

--- start

テストを実行し、生成時に与えられた io に結果を出力します。
