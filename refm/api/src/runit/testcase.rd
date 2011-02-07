require runit/testresult
require runit/testsuite
require runit/assert
require runit/error

このライブラリは RubyUnit との互換性を提供するためだけに提供されています。
これからユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。

= class RUNIT::TestCase < Test::Unit::TestCase
include RUNIT::Assert

テストの基本単位(あるいは「テスト本体」)を構成するクラスです。

このモジュールは RubyUnit との互換性のためにのみ提供されています。
これからユニットテストを書くときは [[lib:test/unit]] を使ってください。

== Class Methods

--- new(test_name, suite_name = RUNIT::TestCase.name) -> RUNIT::TestCase

自身を初期化します。

--- suite -> RUNIT::TestSuite

テストスイートを作成して返します。

== Instance Methods

--- assert_equals(expected, actual, message = nil)

[[m:Test::Unit::Assertions#assert_equal]] の別名。

@param expected 期待値を指定します。

@param actual 実際の値を指定します。

@param message 検査に失敗した場合のメッセージを指定します。

--- name -> String

名前を返します。

--- run(result) { .... } -> ()

テストを実行します。

@param result [[c:RUNIT::TestResult]] のインスタンスを指定します。

