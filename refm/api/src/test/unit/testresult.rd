require test/unit/util/observable

= class Test::Unit::TestResult < Object
include Test::Unit::Util::Observable

テストの結果を保持するためのクラスです。

[[c:Test::Unit::Failure]] オブジェクトと [[c:Test::Unit::Error]] オブジェクトを
集めて、ユーザに表示するために使われます。

== Class Methods

--- new

このメソッドをユーザが直接呼ぶことはありません。

空の TestResult オブジェクトを返します。

== Instance Methods

--- run_count
今までに実行を記録したテストメソッドの数を返します。

--- assertion_count
今までに実行を記録した assert の数を返します。

--- error_count

今までに記録したテストのエラーの数を返します。

--- failure_count

今までに記録した失敗したテストの数を返します。

--- passed?

すべてのテストが成功したなら true を返します。
そうでないなら false を返します。

--- to_s

実行したテストメソッドの数と assert の数、テストの失敗・エラーそれぞれの回数を
人間が読みやすい文字列にして返します。
