このライブラリは RubyUnit との互換性を提供するためだけに提供されています。
これからユニットテストを書くときは
[[lib:test/unit]] ライブラリを使ってください。


= class RUNIT::TestResult < Test::Unit::TestResult

テストの実行結果を格納するクラスです。

== Instance Methods

--- errors -> Array

エラーが発生したテストケースの配列を返します。

--- failures -> Array

失敗したテストケースの配列を返します。

--- succeed? -> bool

成功している場合は、真を返します。
そうでない場合は、偽を返します。

--- failure_size -> Integer

失敗した件数を返します。

--- run_asserts -> Integer

アサーションの件数を返します。

--- error_size -> Integer

エラーが発生した件数を返します。

--- run_tests -> Integer

テストの件数を返します。

--- add_failure(failure) -> ()

失敗したテストを追加します。

@param failure 失敗したテストを指定します。

--- add_error(error) -> ()

エラーが発生したテストを追加します。

@param error エラーが発生したテストを指定します。

